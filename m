From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Jun 2018 21:55:16 +0800
Subject: [erofs-dev] [RFC PATCH RESEND 12/12] erofs: introduce VLE
 decompression support (experimental)
In-Reply-To: <1529589316-114929-1-git-send-email-gaoxiang25@huawei.com>
References: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
 <1529589316-114929-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1529589316-114929-6-git-send-email-gaoxiang25@huawei.com>

This implements the experimental VLE decompression support,
used for the compressed on-disk layout and prototype verification.

This implementation works and has the nearly expected
random read improvements.

On the one hand, it has some good parts that are unnecessary
to change, eg. fast path (percpu buffer, memcpy) and
slow path(vmap, no memcpy), but we observed some issues from
the bad parts too.

In brief, some parts of this patch will be refactored
in the near future.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/Kconfig         |   17 +
 fs/erofs/Makefile        |    1 +
 fs/erofs/data.c          |  176 ++++++++
 fs/erofs/inode.c         |    4 +
 fs/erofs/internal.h      |   93 +++++
 fs/erofs/pagevec.h       |  184 ++++++++
 fs/erofs/super.c         |   41 +-
 fs/erofs/unzip.c         | 1039 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/unzip.h         |  119 ++++++
 fs/erofs/unzip_generic.c |  295 +++++++++++++
 fs/erofs/unzip_vle.h     |   79 ++++
 11 files changed, 2043 insertions(+), 5 deletions(-)
 create mode 100644 fs/erofs/pagevec.h
 create mode 100644 fs/erofs/unzip.c
 create mode 100644 fs/erofs/unzip.h
 create mode 100644 fs/erofs/unzip_generic.c
 create mode 100644 fs/erofs/unzip_vle.h

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index c244cf3..752f0e0 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -69,3 +69,20 @@ config EROFS_FS_USE_VM_MAP_RAM
 
 	  If you don't know what these are, say N.
 
+config EROFS_FS_PAGE_BUNDLE
+	bool "EROFS Page Bundle Feature"
+	depends on EROFS_FS
+	help
+	  Page Bundles manager several meta pages as a whole.
+
+	  If you don't use compression or don't know what these are, say N.
+
+config EROFS_FS_ZIP
+	bool "EROFS Data Compresssion Support"
+	depends on EROFS_FS_PAGE_BUNDLE
+	help
+	  Currently we support VLE Compression only.
+	  Play at your own risk.
+
+	  If you don't want to use compression, say N.
+
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
index 9d7f90a..3086d08 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -5,4 +5,5 @@ EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 obj-$(CONFIG_EROFS_FS) += erofs.o
 erofs-objs := super.o inode.o data.o namei.o dir.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip.o unzip_generic.o unzip_lz4.o
 
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9b30095..c54495d 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -391,3 +391,179 @@ static int erofs_raw_access_readpages(struct file *filp,
 	.readpages = erofs_raw_access_readpages,
 };
 
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+
+struct inode *erofs_init_page_bundle(struct super_block *sb)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (unlikely(inode == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	set_nlink(inode, 1);
+	inode->i_size = OFFSET_MAX;
+
+	inode->i_mapping->a_ops = &erofs_page_bundle_aops;
+	mapping_set_gfp_mask(inode->i_mapping,
+	                     GFP_NOFS | __GFP_HIGHMEM |
+	                     __GFP_MOVABLE |  __GFP_NOFAIL
+#if defined(CONFIG_CMA) && defined(___GFP_CMA)
+	                     | ___GFP_CMA
+#endif
+	                    );
+	return inode;
+}
+
+/*
+ * Our zip(compression) subsystem wants to get the page bundle
+ * in the non-blocking way. In that case, we could dynamically add
+ * filemap pages to a zipped pack on-the-fly before decompressing.
+ *
+ * Different from buffer head (fs/buffer.c) using a private_lock
+ * which is slightly slow in the high-concurrency scenarios,
+ * we introduce a bit_spinlock to serialize and close all races.
+ */
+struct page *erofs_grab_bundle_page(struct super_block *sb,
+	pgoff_t index, bool *created, struct list_head *page_pool)
+{
+	struct address_space *const mapping =
+		EROFS_SB(sb)->ibundle->i_mapping;
+	/* page, alternate page (if page is not exist in the mapping) */
+	struct page *page, *alt = NULL;
+
+	/* currectly, the fail path is still unimplemented */
+	const gfp_t gfp = mapping_gfp_mask(mapping) | __GFP_NOFAIL;
+
+	/* first, we try to find a unlock page */
+	*created = false;
+
+	/*
+	 * In order to reduce the memory pressure, we don't mark
+	 * the page accessed again.
+	 */
+	page = find_get_page(mapping, index);
+
+	if (page != NULL)
+		return page;
+
+	/* then, get a new free page if not found */
+	if (!list_empty(page_pool)) {
+		alt = list_last_entry(page_pool, struct page, lru);
+		list_del(&alt->lru);
+	} else {
+		alt = __page_cache_alloc(gfp);
+		DBG_BUGON(alt == NULL);
+	}
+
+	prefetchw(&alt->flags);
+	/* clean page private for the later page bundle use */
+	set_page_private(alt, 0);
+
+	do {
+		int err = add_to_page_cache_lru(alt, mapping, index, gfp);
+		if (!err) {
+			*created = true;
+			return alt;
+		} else if (err != -EEXIST) {
+			/* Presumably ENOMEM for radix tree node */
+			page = ERR_PTR(err);
+			break;
+		}
+		page = find_get_page(mapping, index);
+	} while(page == NULL);
+
+	/* put the unused alternate page back to the free pool */
+	list_add(&alt->lru, page_pool);
+	return page;
+}
+
+void erofs_add_to_page_bundle(struct erofs_page_bundle *bundle,
+	unsigned nr, struct page *page)
+{
+	struct erofs_page_bundle *b = erofs_lock_page_private(page);
+
+	if (has_page_bundle(page))
+		goto exist;
+
+	page_cache_get(page);
+	if (test_set_page_bundle(page)) {
+		page_cache_release(page);
+exist:
+		BUG_ON(bundle != b);
+		lockref_get(&b->lockref);
+		goto out;
+	}
+
+	spin_lock(&bundle->lockref.lock);
+	BUG_ON(b != NULL);
+	BUG_ON(bundle->lockref.count <= 0);
+	BUG_ON(bundle->pages[nr] != NULL);
+
+	++bundle->lockref.count;
+	bundle->pages[nr] = page;
+	spin_unlock(&bundle->lockref.lock);
+out:
+	erofs_set_page_private(page, bundle);
+	erofs_unlock_page_private(page);
+}
+
+struct erofs_page_bundle *erofs_get_page_bundle(struct page *page,
+	unsigned nr, erofs_page_bundle_ctor_t ctor)
+{
+	struct erofs_page_bundle *b = erofs_lock_page_private(page);
+
+	if (!has_page_bundle(page))
+		ctor(page, nr);
+	else {
+		DBG_BUGON(b == NULL);
+		DBG_BUGON(b->pages[nr] != page);
+
+		lockref_get(&b->lockref);
+	}
+	erofs_unlock_page_private(page);
+
+	/* page private must be available now */
+	return erofs_page_private(page);
+}
+
+extern int erofs_try_to_free_vle_zipped_page(struct page *page);
+
+static int page_bundle_releasepage(struct page *page, gfp_t gfp_mask)
+{
+	int ret = 1;	/* 0 - busy */
+	struct address_space *const mapping = page->mapping;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(mapping->a_ops != &erofs_page_bundle_aops);
+
+	if (has_page_bundle(page)) {
+		debugln("%s, page: %p", __func__, page);
+
+		/* currently we have the only user */
+		ret = erofs_try_to_free_vle_zipped_page(page);
+	}
+	return ret;
+}
+
+static void page_bundle_invalidatepage(struct page *page,
+                                       unsigned int offset,
+                                       unsigned int length)
+{
+	const unsigned int stop = length + offset;
+
+	BUG_ON(!PageLocked(page));
+	/* Check for overflow */
+	BUG_ON(stop > PAGE_SIZE || stop < length);
+
+	if (offset == 0 && stop == PAGE_SIZE)
+		while(!page_bundle_releasepage(page, GFP_NOFS))
+			cond_resched();
+}
+
+const struct address_space_operations erofs_page_bundle_aops = {
+	.releasepage = page_bundle_releasepage,
+	.invalidatepage = page_bundle_invalidatepage,
+};
+
+#endif
+
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 7391ef6..61010c0 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -182,7 +182,11 @@ int fill_inode(struct inode *inode, int isdir)
 		}
 
 		/* for compression or unknown data mapping mode */
+#ifdef CONFIG_EROFS_FS_ZIP
+		inode->i_mapping->a_ops = &z_erofs_vle_normal_access_aops;
+#else
 		err = -ENOTSUPP;
+#endif
 	}
 
 out_unlock:
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 1dd783c..307f435 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -20,6 +20,9 @@
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
 #include <linux/cleancache.h>
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+#include <linux/swap.h>
+#endif
 #include <linux/vmalloc.h>
 #include "erofs_fs.h"
 
@@ -54,8 +57,16 @@ struct erofs_sb_info {
 	u32 xattr_blkaddr;
 #endif
 
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+	struct inode *ibundle;
+#endif
+
 	/* inode slot unit size in bit shift */
 	unsigned char islotbits;
+#ifdef CONFIG_EROFS_FS_ZIP
+	/* cluster size in bit shift */
+	unsigned char clusterbits;
+#endif
 
 	u32 build_time_nsec;
 	u64 build_time;
@@ -100,6 +111,10 @@ struct erofs_sb_info {
 
 #define ROOT_NID(sb)		((sb)->root_nid)
 
+#ifdef CONFIG_EROFS_FS_ZIP
+#define erofs_clusterpages(sbi)	((1 << (sbi)->clusterbits) / PAGE_SIZE)
+#endif
+
 typedef u64 erofs_off_t;
 
 /* data type for filesystem-wide blocks number */
@@ -181,6 +196,9 @@ static inline bool is_inode_layout_inline(struct inode *inode)
 extern const struct file_operations erofs_unaligned_compressed_fops;
 
 extern const struct address_space_operations erofs_raw_access_aops;
+#ifdef CONFIG_EROFS_FS_ZIP
+extern const struct address_space_operations z_erofs_vle_normal_access_aops;
+#endif
 
 /*
  * Logical to physical block mapping, used by erofs_map_blocks()
@@ -248,6 +266,81 @@ static inline struct page *erofs_get_inline_page(struct inode *inode,
 		blkaddr, S_ISDIR(inode->i_mode));
 }
 
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+
+#define EROFS_PAGE_BUNDLE_MAX_PAGES	1
+
+struct erofs_page_bundle {
+	struct lockref lockref;
+	struct page *pages[EROFS_PAGE_BUNDLE_MAX_PAGES];
+};
+
+typedef void (*erofs_page_bundle_ctor_t)(struct page *, unsigned nr);
+
+static inline struct page *erofs_get_page_accessed(
+	struct address_space *mapping,
+	pgoff_t index)
+{
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 31))
+	struct page *page = find_get_page(mapping, index);
+
+	if (page != NULL)
+		mark_page_accessed(page);
+
+	return page;
+#else
+	return pagecache_get_page(mapping, index, 0, FGP_ACCESSED);
+#endif
+}
+
+#define has_page_bundle(page)           PagePrivate(page)
+#define test_set_page_bundle(page) \
+	test_and_set_bit(PG_private, &(page)->flags)
+
+#define erofs_page_private(page)	\
+	(void *)(page_private(page) & ~1UL)
+
+static inline void *erofs_lock_page_private(struct page *page)
+{
+	bit_spin_lock(0, &page_private(page));
+	return erofs_page_private(page);
+}
+
+#define erofs_set_page_private(page, b) \
+	WRITE_ONCE((page)->private, (unsigned long)(b) | 1)
+
+static inline void erofs_unlock_page_private(struct page *page)
+{
+	bit_spin_unlock(0, &page_private(page));
+}
+
+extern struct inode *erofs_init_page_bundle(struct super_block *);
+extern struct page *erofs_grab_bundle_page(struct super_block *,
+	pgoff_t index, bool *, struct list_head *);
+extern void erofs_add_to_page_bundle(struct erofs_page_bundle *,
+	unsigned, struct page *);
+extern struct erofs_page_bundle *erofs_get_page_bundle(struct page *,
+	unsigned, erofs_page_bundle_ctor_t);
+
+static inline int erofs_put_page_bundle(struct erofs_page_bundle *b)
+{
+	int ret = lockref_put_return(&b->lockref);
+
+	if (unlikely(ret < 0)) {
+		spin_lock(&b->lockref.lock);
+		if (b->lockref.count > 0)
+			--b->lockref.count;
+		ret = b->lockref.count;
+		spin_unlock(&b->lockref.lock);
+	}
+	return ret;
+}
+
+extern const struct address_space_operations erofs_page_bundle_aops;
+
+#endif
+
+
 /* inode.c */
 extern struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool dir);
diff --git a/fs/erofs/pagevec.h b/fs/erofs/pagevec.h
new file mode 100644
index 0000000..5a7ef76
--- /dev/null
+++ b/fs/erofs/pagevec.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * linux/fs/erofs/pagevec.h
+ *
+ * Copyright (c) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#ifndef __EROFS_PAGEVEC_H
+#define __EROFS_PAGEVEC_H
+
+#include "internal.h"
+
+/*
+ * page_start
+ * |  /
+ * | /
+ * |/
+ * +------+--------------------------------+-------+
+ * | prev | (*1) |       ...               | *next |
+ * +------+--------------------------------+-------+
+ * NOTE: (*1) could be the pagevec page itself.
+ */
+
+/* used for traversaling zipped page in reserve order */
+struct z_erofs_zipped_pagevec {
+	struct page *page;
+	struct page **pages;
+};
+
+static inline void z_erofs_zipped_pagevec_push(
+	struct z_erofs_zipped_pagevec *vec,
+	struct page *page)
+{
+	if (unlikely(vec->page == NULL)) {
+		vec->page = page;
+		vec->pages = kmap(page);
+		*vec->pages = NULL;
+	} else if (!offset_in_page(vec->pages + 1)) {
+		struct page *const prev = vec->page;
+
+		vec->page = *vec->pages;
+		kunmap(prev);
+		vec->pages = kmap(vec->page);
+		*vec->pages = prev;
+	}
+	*++vec->pages = page;
+}
+
+#define z_erofs_zipped_pagevec_empty(v)	((v)->page == NULL)
+
+static inline struct page *z_erofs_zipped_pagevec_pop(
+	struct z_erofs_zipped_pagevec *vec)
+{
+	const unsigned ofs = offset_in_page(vec->pages);
+
+	if (ofs < sizeof(struct page *)) {
+		struct page *const prev = *vec->pages;
+
+		DBG_BUGON(ofs);
+		DBG_BUGON(vec->page == NULL);
+		kunmap(vec->page);
+		if ((vec->page = prev) == NULL)
+			return NULL;
+		vec->pages = (struct page **)(kmap(prev) + PAGE_SIZE) - 1;
+	}
+	return *vec->pages--;
+}
+
+static inline void z_erofs_zipped_pagevec_end(
+	struct z_erofs_zipped_pagevec *vec)
+{
+	if (vec->page != NULL)
+		kunmap(vec->page);
+}
+
+#define DE_PAGEVEC_INLINE_ENTRYS      4
+/*
+ * page_start
+ * |  /
+ * | /
+ * |/
+ * +------+------+--------------------------------+
+ * | .... | next |              ...               |
+ * +------+------+--------------------------------+
+ */
+struct z_erofs_de_pagevec {
+	unsigned short nr, index;
+	struct page *page;
+	struct page **pages;
+};
+
+static inline void z_erofs_de_pagevec_end(
+	struct z_erofs_de_pagevec *vec, bool atomic)
+{
+	if (vec->page != NULL) {
+		if (!atomic) {
+			kunmap(vec->page);
+			return;
+		}
+		kunmap_atomic(vec->pages);
+	}
+}
+
+/* the mid page is safe and avoid partial pages */
+static inline struct page *__find_midpage(struct page **pages)
+{
+	struct page *const a = pages[0],
+		*const b = pages[1], *const c = pages[2];
+
+	DBG_BUGON(a == NULL);
+	DBG_BUGON(b == NULL);
+	DBG_BUGON(c == NULL);
+	return a->index > b->index ?
+		(c->index > a->index ? a : (b->index > c->index ? b : c)) :
+		(c->index > b->index ? b : (a->index > c->index ? a : c));
+}
+
+static inline void __z_erofs_de_pagevec_pagedown(
+	struct z_erofs_de_pagevec *vec)
+{
+	struct page *selected = __find_midpage(vec->pages);
+	z_erofs_de_pagevec_end(vec, false);
+	vec->page = selected;
+	vec->pages = kmap(vec->page);
+	vec->nr = PAGE_SIZE / sizeof(struct page *);
+	vec->index = 0;
+}
+
+static inline void z_erofs_de_pagevec_init(
+	struct z_erofs_de_pagevec *vec,
+	struct page **inlinepages, unsigned i)
+{
+	vec->nr = DE_PAGEVEC_INLINE_ENTRYS;
+	vec->page = NULL;
+	vec->pages = inlinepages;
+
+	if (i >= DE_PAGEVEC_INLINE_ENTRYS) {
+		i -= DE_PAGEVEC_INLINE_ENTRYS;
+		__z_erofs_de_pagevec_pagedown(vec);
+		while(i > vec->nr) {
+			i -= vec->nr;
+			__z_erofs_de_pagevec_pagedown(vec);
+		}
+	}
+	vec->index = i;
+}
+
+static inline void z_erofs_de_pagevec_enqueue(
+	struct z_erofs_de_pagevec *vec,
+	struct page *page)
+{
+	if (vec->index >= vec->nr)
+		__z_erofs_de_pagevec_pagedown(vec);
+
+	vec->pages[vec->index++] = page;
+	debugln("%s, vec->pages[%d] = %p", __func__,
+		vec->index - 1, vec->pages[vec->index - 1]);
+}
+
+static inline struct page *z_erofs_de_pagevec_dequeue(
+	struct z_erofs_de_pagevec *vec)
+{
+	if (vec->index >= vec->nr) {
+		struct page *par = vec->page;
+
+		vec->page = __find_midpage(vec->pages);
+
+		if (par != NULL)
+			kunmap_atomic(vec->pages);
+		vec->pages = kmap_atomic(vec->page);
+		vec->nr = PAGE_SIZE / sizeof(struct page *);
+		vec->index = 0;
+	}
+
+	return vec->pages[vec->index++];
+}
+
+#endif
+
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index b41613f..c46d1c6 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -111,6 +111,9 @@ static int superblock_read(struct super_block *sb)
 	sbi->xattr_blkaddr = le32_to_cpu(layout->xattr_blkaddr);
 #endif
 	sbi->islotbits = ffs(sizeof(struct erofs_inode_v1)) - 1;
+#ifdef CONFIG_EROFS_FS_ZIP
+	sbi->clusterbits = 12;
+#endif
 
 	sbi->root_nid = le64_to_cpu(layout->root_nid);
 	sbi->inos = le64_to_cpu(layout->inos);
@@ -185,12 +188,19 @@ static int erofs_read_super(struct super_block *sb,
 
 	if (!silent)
 		infoln("root inode @ nid %llu", ROOT_NID(sbi));
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+	sbi->ibundle = erofs_init_page_bundle(sb);
+	if (sbi->ibundle == NULL) {
+		err = -ENOMEM;
+		goto err_sbi;
+	}
+#endif
 
 	/* get the root inode */
 	inode = erofs_iget(sb, ROOT_NID(sbi), true);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
-		goto err_sbi;
+		goto err_ibundle;
 	}
 
 	if (!S_ISDIR(inode->i_mode)) {
@@ -231,6 +241,10 @@ static int erofs_read_super(struct super_block *sb,
 err_iput:
 	if (sb->s_root == NULL)
 		iput(inode);
+err_ibundle:
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+	iput(sbi->ibundle);
+#endif
 err_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
@@ -252,7 +266,9 @@ static void erofs_put_super(struct super_block *sb)
 
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
-
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+	iput(sbi->ibundle);
+#endif
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 }
@@ -301,6 +317,11 @@ static void erofs_kill_sb(struct super_block *sb)
 	.fs_flags       = FS_REQUIRES_DEV,
 };
 
+#ifdef CONFIG_EROFS_FS_ZIP
+extern int z_erofs_init_zip_subsystem(void);
+extern void z_erofs_exit_zip_subsystem(void);
+#endif
+
 int __init erofs_module_init(void)
 {
 	int err;
@@ -309,11 +330,18 @@ int __init erofs_module_init(void)
 
 	err = erofs_init_inode_cache();
 	if (!err) {
-		err = register_filesystem(&erofs_fs_type);
+#ifdef CONFIG_EROFS_FS_ZIP
+		err = z_erofs_init_zip_subsystem();
 		if (!err) {
-			infoln("Successfully to initialize erofs");
-			return 0;
+#endif
+			err = register_filesystem(&erofs_fs_type);
+			if (!err) {
+				infoln("Successfully to initialize erofs");
+				return 0;
+			}
+#ifdef CONFIG_EROFS_FS_ZIP
 		}
+#endif
 	}
 	return err;
 }
@@ -321,6 +349,9 @@ int __init erofs_module_init(void)
 void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+#ifdef CONFIG_EROFS_FS_ZIP
+	z_erofs_exit_zip_subsystem();
+#endif
 	infoln("Successfully finalize erofs");
 }
 
diff --git a/fs/erofs/unzip.c b/fs/erofs/unzip.c
new file mode 100644
index 0000000..171aec1
--- /dev/null
+++ b/fs/erofs/unzip.c
@@ -0,0 +1,1039 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/unzip.c
+ *
+ * Copyright (c) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include "unzip.h"
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+
+static struct workqueue_struct *z_erofs_workqueue __read_mostly;
+static struct kmem_cache *z_erofs_pack_cachep __read_mostly;
+
+void z_erofs_exit_zip_subsystem(void)
+{
+	BUG_ON(z_erofs_workqueue == NULL);
+	BUG_ON(z_erofs_pack_cachep == NULL);
+
+	destroy_workqueue(z_erofs_workqueue);
+	kmem_cache_destroy(z_erofs_pack_cachep);
+}
+
+static inline int init_unzip_workqueue(void)
+{
+	const unsigned onlinecpus = num_online_cpus();
+
+	/*
+	 * we don't need too many threads, limiting threads
+	 * could improve scheduling performance.
+	 */
+	z_erofs_workqueue = alloc_workqueue("erofs_unzipd",
+		WQ_UNBOUND | WQ_CPU_INTENSIVE | WQ_HIGHPRI |
+		WQ_NON_REENTRANT, onlinecpus + onlinecpus / 4);
+
+	return z_erofs_workqueue != NULL ? 0 : -ENOMEM;
+}
+
+int z_erofs_init_zip_subsystem(void)
+{
+	z_erofs_pack_cachep =
+		kmem_cache_create("erofs_compressed_pack",
+		Z_EROFS_PACK_SIZE, 0,
+		SLAB_RECLAIM_ACCOUNT, NULL);
+
+	if (z_erofs_pack_cachep != NULL) {
+		if (!init_unzip_workqueue())
+			return 0;
+
+		kmem_cache_destroy(z_erofs_pack_cachep);
+	}
+	return -ENOMEM;
+}
+
+static inline void put_vle_zipped_pack(struct z_erofs_vle_zipped_pack *z,
+                                       bool __maybe_unused allow_free)
+{
+	if (erofs_put_page_bundle(&z->bundle))
+		return;
+
+	DBG_BUGON(mutex_is_locked(&z->lock));
+	DBG_BUGON(!allow_free);
+	kmem_cache_free(z_erofs_pack_cachep, z);
+}
+
+int erofs_try_to_free_vle_zipped_page(struct page *page)
+{
+	struct erofs_page_bundle *b;
+	struct z_erofs_vle_zipped_pack *zip;
+	unsigned i;
+	bool will_free;
+
+	erofs_dbg_might_sleep();
+	b = erofs_lock_page_private(page);
+
+	DBG_BUGON(!has_page_bundle(page));
+	zip = container_of(b, struct z_erofs_vle_zipped_pack, bundle);
+
+	/* I prefer not to sleep in the reclaim path, try_lock instead */
+	if (!mutex_trylock(&zip->lock)) {
+busy_unlock_page_private:
+		erofs_unlock_page_private(page);
+		return 0;
+	}
+
+	/* freeze the whole page bundle */
+	spin_lock(&b->lockref.lock);
+
+	/* the page bundle still has active users */
+	if (b->lockref.count > 1) {
+busy_unlock_bundle:
+		spin_unlock(&b->lockref.lock);
+		mutex_unlock(&zip->lock);
+		goto busy_unlock_page_private;
+	}
+
+	/* try to release the head zipped page */
+	if (page == b->pages[0]) {
+		/* the rest zpages should be released */
+		for(i = 1; i < EROFS_PAGE_BUNDLE_MAX_PAGES; ++i)
+			if (b->pages[i] != NULL)
+				goto busy_unlock_bundle;
+		b->pages[0] = NULL;
+		will_free = true;
+		goto reclaim;
+	}
+
+	for(i = 1; i < EROFS_PAGE_BUNDLE_MAX_PAGES; ++i) {
+		if (b->pages[i] == page) {
+			b->pages[i] = NULL;
+			will_free = false;
+			goto reclaim;
+		}
+	}
+
+	BUG();
+reclaim:
+	ClearPagePrivate(page);
+	erofs_set_page_private(page, NULL);
+	spin_unlock(&b->lockref.lock);
+	mutex_unlock(&zip->lock);
+	erofs_unlock_page_private(page);
+
+	if (will_free)
+		put_vle_zipped_pack(zip, true);
+	put_page(page);
+	return 1;
+}
+
+/* zip should be locked by callers */
+static void z_erofs_vle_unzip(struct z_erofs_vle_zipped_pack *const zip)
+{
+	struct erofs_page_bundle *const b = &zip->bundle;
+	struct z_erofs_pack_info pack;
+	struct inode *inode;
+	struct page *page;
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+	unsigned clusterpages, i;
+#else
+	const unsigned clusterpages = 1;
+#endif
+	void *in;
+
+	/*
+	 * end_io queue work start
+	 * end_io work queue end (queued_pages == 0)
+	 * z_erofs_vle_do_read_page, queue work again
+	 */
+	if (unlikely(!READ_ONCE(zip->queued_pages)))
+		goto out_unlock;
+
+	page = zip->pages[0];
+	DBG_BUGON(page == NULL);
+	inode = page->mapping->host;
+
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+	clusterpages = erofs_clusterpages(EROFS_I_SB(inode));
+
+	for(i = 0; i < clusterpages; ++i) {
+		DBG_BUGON(b->pages[i] == NULL);
+		DBG_BUGON(!PageUptodate(b->pages[i]));
+	}
+#else
+	DBG_BUGON(b->pages[0] == NULL);
+	DBG_BUGON(!PageUptodate(b->pages[0]));
+#endif
+
+	debugln("%s, zip=%p la = %llu, llen = %u", __func__, zip, zip->la, zip->llen);
+
+	pack.pages = zip->pages;
+	pack.nr_pages = zip->nr_pages;
+	pack.queued_pages = zip->queued_pages;
+
+	if (!(zip->flags & Z_EROFS_PACK_ZIPPED))
+		z_erofs_plain_copy(&pack, b->pages, clusterpages, zip->la);
+	else {
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+		in = clusterpages == 1 ? kmap(b->pages[0]):
+			vmap(b->pages, clusterpages, VM_MAP, PAGE_KERNEL);
+#else
+		in = kmap(b->pages[0]);
+#endif
+
+		z_erofs_unzip_generic(&pack, in, clusterpages * PAGE_SIZE,
+		                      zip->la, zip->llen);
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+		if (clusterpages == 1)
+			kunmap(b->pages[0]);
+		else
+			vunmap(in);
+#else
+		kunmap(b->pages[0]);
+#endif
+	}
+
+	/* check decompressor has filled all queued pages */
+	DBG_BUGON(pack.queued_pages);
+	zip->queued_pages = 0;
+	zip->nr_pages = 0;		/* FIXME later */
+out_unlock:
+	mutex_unlock(&zip->lock);
+	put_vle_zipped_pack(zip, false);
+
+}
+
+static void z_erofs_vle_decompress_wq(struct work_struct *work)
+{
+	struct z_erofs_vle_zipped_pack *const zip =
+		container_of(work, struct z_erofs_vle_zipped_pack, work);
+
+	if (!READ_ONCE(zip->queued_pages)) {
+		put_vle_zipped_pack(zip, false);
+		return;
+	}
+	mutex_lock(&zip->lock);
+	z_erofs_vle_unzip(zip);
+}
+
+static void __vle_zipped_bundle_alloc(struct page *page, unsigned nr)
+{
+	struct erofs_page_bundle *b;
+	struct z_erofs_vle_zipped_pack *zip =
+		kmem_cache_zalloc(z_erofs_pack_cachep, GFP_ATOMIC);
+
+	/* here we grab an extra page reference for page private */
+	get_page(page);
+
+	/* if we cannot allocate memory in atomic, try sleeping way instead */
+	if (unlikely(zip == NULL)) {
+		erofs_unlock_page_private(page);
+
+		erofs_dbg_might_sleep();
+		zip = kmem_cache_zalloc(z_erofs_pack_cachep,
+		                        GFP_KERNEL | __GFP_NOFAIL);
+
+		b = erofs_lock_page_private(page);
+		if (test_set_page_bundle(page)) {
+			DBG_BUGON(b == NULL);
+			DBG_BUGON(b->pages[nr] != page);
+
+			lockref_get(&b->lockref);
+			kmem_cache_free(z_erofs_pack_cachep, zip);
+			put_page(page);
+			return;
+		}
+
+		DBG_BUGON(b != NULL);
+	} else if (test_set_page_bundle(page))
+		BUG();
+
+	mutex_init(&zip->lock);
+	INIT_WORK(&zip->work, z_erofs_vle_decompress_wq);
+
+	b = &zip->bundle;
+	/* initialize global page bundle */
+	b->pages[nr] = page;
+	b->lockref.count = 2;
+	spin_lock_init(&b->lockref.lock);
+	erofs_set_page_private(page, b);
+}
+
+static inline struct page *grab_vle_zipped_page(struct super_block *sb,
+                                                pgoff_t index,
+                                                struct erofs_page_bundle **b,
+                                                bool *created,
+                                                struct list_head *page_pool)
+{
+	struct page *page;
+
+	page = erofs_grab_bundle_page(sb, index, created, page_pool);
+	if (!IS_ERR(page)) {
+		/* we only get a new page bundle from the head page */
+		*b = erofs_get_page_bundle(page, 0, __vle_zipped_bundle_alloc);
+	}
+	return page;
+}
+
+/* TODO! FIXME!!! this function is still broken :( */
+static int z_erofs_add_tailpage(struct z_erofs_zipped_pagevec *z_pvec,
+                                struct super_block *sb,
+                                pgoff_t hi, pgoff_t ti,
+                                struct erofs_page_bundle *b,
+                                struct list_head *page_pool)
+{
+	return -ENOTSUPP;
+}
+
+struct z_erofs_zipped_pack_collector {
+	struct list_head list;
+	bool sync;
+};
+
+static inline void vle_zipped_iter_dispatch(struct z_erofs_vle_zipped_iter *z,
+	struct z_erofs_zipped_pack_collector *c)
+{
+	struct z_erofs_vle_zipped_pack *const zip = z->zip;
+	struct list_head *const e = z_erofs_vle_zipped_list_entry(zip);
+
+	/* decompressed pages is already ok? */
+	if (!z->already) {
+		if (c->sync) {
+			if (!z_erofs_vle_zipped_protect_list_entry(zip))
+				return;
+			list_add_tail(e, &c->list);
+		}
+	} else {
+		if (!z_erofs_vle_zipped_protect_list_entry(zip))
+			return;
+		list_add(e, &c->list);
+	}
+	lockref_get(&zip->bundle.lockref);
+}
+
+static inline void vle_zipped_iter_end(struct z_erofs_vle_zipped_iter *z)
+{
+	z_erofs_de_pagevec_end(&z->d_pvec, false);
+	mutex_unlock(&z->zip->lock);
+
+	put_vle_zipped_pack(z->zip, false);
+}
+
+static inline void vle_zipped_collected_enqueue_all(struct list_head *list)
+{
+	struct list_head *e, *tmp;
+
+	list_for_each_safe(e, tmp, list) {
+		struct work_struct *work = container_of(e,
+			struct work_struct, entry);
+		struct z_erofs_vle_zipped_pack *zip;
+
+		list_del(e);
+		INIT_LIST_HEAD(e);
+
+		zip = container_of(work, struct z_erofs_vle_zipped_pack, work);
+		z_erofs_vle_zipped_unprotect_list_entry(zip);
+
+		/* there is no need to lock strictly */
+		if (unlikely(!READ_ONCE(zip->queued_pages))) {
+			put_vle_zipped_pack(zip, false);
+			continue;
+		}
+		debugln("%s, queue work %p", __func__, &zip->work);
+		queue_work(z_erofs_workqueue, work);
+	}
+}
+
+static inline void vle_zipped_collected_unzip_all(struct super_block *sb,
+	struct list_head *list)
+{
+	struct work_struct *work;
+	struct z_erofs_vle_zipped_pack *zip;
+	struct erofs_page_bundle *b;
+	struct page *victim;
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	unsigned j;
+#endif
+	struct list_head *e, *tmp;
+	unsigned round = 0;
+
+repeat:
+	/* why isn't blk_flush_plug_list() exported? :-( */
+	if (round == 1 && blk_needs_flush_plug(current))
+		io_schedule();
+
+	/* wait on a single page at each end of a round */
+	victim = NULL;
+
+	list_for_each_safe(e, tmp, list) {
+		work = container_of(e, struct work_struct, entry);
+		zip = container_of(work, struct z_erofs_vle_zipped_pack, work);
+		b = &zip->bundle;
+
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+		for (j = 0; j < clusterpages; ++j) {
+			if (!PageLocked(b->pages[j]))
+				continue;
+			if (round >= 4)
+				if (victim == NULL || !PageLocked(victim))
+					victim = b->pages[j];
+			break;
+		}
+		if (j < clusterpages) {
+#else
+		if (PageLocked(b->pages[0])) {
+			if (victim == NULL || !PageLocked(victim))
+				victim = b->pages[0];
+#endif
+			continue;
+		}
+
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+		for (j = 0; j < clusterpages; ++j)
+			BUG_ON(!PageUptodate(b->pages[j]));
+#else
+		BUG_ON(!PageUptodate(b->pages[0]));
+#endif
+
+		if (round >= 6)
+			mutex_lock(&zip->lock);
+		else if (!mutex_trylock(&zip->lock))
+			continue;
+
+		list_del(e);
+		INIT_LIST_HEAD(e);
+		z_erofs_vle_zipped_unprotect_list_entry(zip);
+		z_erofs_vle_unzip(zip);
+	}
+
+	if (!list_empty(list)) {
+		if (victim != NULL)
+			wait_on_page_locked(victim);
+
+		++round;
+		goto repeat;
+	}
+}
+
+static int z_erofs_vle_do_read_page(
+	struct page *page,
+	struct z_erofs_zipped_pagevec *z_pvec,
+	struct z_erofs_vle_zipped_iter *z,
+	struct erofs_map_blocks_iter *m,
+	struct list_head *page_pool,
+	struct z_erofs_zipped_pack_collector *collector)
+{
+	struct inode *const inode = page->mapping->host;
+	struct super_block *const sb = inode->i_sb;
+	struct erofs_sb_info *const sbi = EROFS_SB(sb);
+	const loff_t offset = page_offset(page);
+	struct z_erofs_vle_zipped_pack *zip = z->zip;
+	unsigned cur, end, spiltted;
+	int err;
+	bool creat;
+	struct page *zpage;
+	struct erofs_page_bundle *b;
+	unsigned clusterpages;
+	pgoff_t hi, ti;
+
+	/* register locked file pages as online pages in pack */
+	z_erofs_onlinepage_init(page);
+
+	spiltted = 0;
+	end = PAGE_SIZE;
+repeat:
+	cur = end - 1;
+
+	/* lucky, within the range of the current map_blocks */
+	if (offset + cur >= m->map.m_la &&
+            offset + cur < m->map.m_la + m->map.m_llen)
+		goto hitted;
+
+	/* go ahead the next map_blocks */
+	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
+
+	if (zip != NULL) {
+		vle_zipped_iter_dispatch(z, collector);
+		vle_zipped_iter_end(z);
+	}
+
+	m->map.m_la = offset + cur;
+	m->map.m_llen = 0;
+	err = erofs_map_blocks_iter(inode, &m->map, &m->mpage, 0);
+	if (unlikely(err))
+		goto err_out;
+
+	/* deal with hole (FIXME! broken now) */
+	if (unlikely(!(m->map.m_flags & EROFS_MAP_MAPPED))) {
+		zip = NULL;
+		goto hitted;
+	}
+
+	DBG_BUGON(m->map.m_plen != 1 << sbi->clusterbits);
+	BUG_ON(m->map.m_pa % EROFS_BLKSIZ);
+
+	/* grab the zipped head page and bundle */
+	hi = m->map.m_pa / PAGE_SIZE;
+	zpage = grab_vle_zipped_page(sb, hi, &b, &creat, page_pool);
+
+	zip = container_of(b, struct z_erofs_vle_zipped_pack, bundle);
+	if (IS_ERR(zpage))
+		goto err_out;
+
+	debugln("%s, (head zipped page %p, index=%lu) page %p "
+		"created=%d", __func__, zpage, hi, page, creat);
+
+	clusterpages = erofs_clusterpages(sbi);
+
+	/* already = true iff no zpage adds to zipped_pagevec */
+	z->already = true;
+
+	/* as others above, add tail zpages in the reserve order */
+	ti = DIV_ROUND_UP(m->map.m_pa + m->map.m_plen, PAGE_SIZE);
+	while(ti > hi + 1) {
+		err = z_erofs_add_tailpage(z_pvec, sb, hi, --ti, b, page_pool);
+		z->already &= !err;
+	}
+
+	if (!creat) {
+		/* why do this? -- see comment in "do_read_cache_page" */
+		wait_on_page_locked(zpage);
+
+		if (PageUptodate(zpage))
+			goto has_data;
+
+		lock_page(zpage);
+		if (PageUptodate(zpage)) {
+			unlock_page(zpage);
+			goto has_data;
+		}
+	}
+
+	z_erofs_zipped_pagevec_push(z_pvec, zpage);
+	z->already = false;
+
+has_data:
+	mutex_lock(&zip->lock);
+
+	z->zip = zip;
+
+	if (!(zip->flags & Z_EROFS_PACK_INITIALIZED)) {
+		zip->la = m->map.m_la;
+		if (m->map.m_flags & EROFS_MAP_ZIPPED)
+			zip->flags |= Z_EROFS_PACK_ZIPPED;
+		zip->flags |= Z_EROFS_PACK_INITIALIZED;
+	} else {
+		BUG_ON(zip->la != m->map.m_la);
+		BUG_ON(!(zip->flags & Z_EROFS_PACK_ZIPPED) !=
+			!(m->map.m_flags & EROFS_MAP_ZIPPED));
+	}
+
+	/* physical address should be equal */
+	DBG_BUGON(m->map.m_pa != page_offset(b->pages[0]));
+
+	/* update logical extent length */
+	if (m->map.m_llen > zip->llen)
+		zip->llen = m->map.m_llen;
+
+	put_page(zpage);
+	z_erofs_de_pagevec_init(&z->d_pvec, zip->pages, zip->queued_pages);
+
+hitted:
+	cur = end - min_t(unsigned, offset + end - m->map.m_la, end);
+	if (unlikely(!(m->map.m_flags & EROFS_MAP_MAPPED))) {
+		zero_user_segment(page, cur, end);
+		goto next_part;
+	}
+
+	++spiltted;
+	z_erofs_de_pagevec_enqueue(&z->d_pvec, page);
+
+	/* also update nr_pages and increase queued_pages */
+	zip->nr_pages = max_t(pgoff_t, zip->nr_pages,
+	                      page->index - m->map.m_la / PAGE_SIZE + 1);
+	++zip->queued_pages;
+
+next_part:
+	/* used for verification */
+	m->map.m_llen = offset + cur - m->map.m_la;
+
+	if ((end = cur) > 0)
+		goto repeat;
+
+	debugln("%s, finish page: %p spiltted: %u map->m_llen %llu",
+		__func__, page, spiltted, m->map.m_llen);
+
+	/* the online file page could be unlocked after this line */
+	z_erofs_onlinepage_setup(page, spiltted);
+	return 0;
+
+err_out:
+	/* TODO! the missing error handing cases */
+	return err;
+}
+
+
+/*
+ * Variable-sized Logical Extent (Fixed Physical Cluster) Compression Mode
+ * ---
+ * VLE compression mode attempts to compress a number of logical data into
+ * a physical cluster with a fixed size.
+ * VLE compression mode uses "struct erofs_decompressed_index_vle".
+ */
+static erofs_off_t vle_get_logical_extent_head(
+	struct inode *inode,
+	struct page **page_iter,
+	void **kaddr_iter,
+	unsigned lcn,	/* logical cluster number */
+	erofs_blk_t *pcn,
+	unsigned *flags)
+{
+	/* for extent meta */
+	struct page *page = *page_iter;
+	erofs_blk_t blkaddr = vle_extent_blkaddr(inode, lcn);
+	struct erofs_decompressed_index_vle *di;
+	unsigned long long ofs;
+	unsigned clustersize = 1 << EROFS_SB(inode->i_sb)->clusterbits;
+
+	if (page->index != blkaddr) {
+		kunmap_atomic(*kaddr_iter);
+		unlock_page(page);
+		put_page(page);
+
+		*page_iter = page = erofs_get_meta_page(inode->i_sb,
+			blkaddr, false);
+		*kaddr_iter = kmap_atomic(page);
+	}
+
+	di = *kaddr_iter + vle_extent_blkoff(inode, lcn);
+	switch(vle_cluster_type(di)) {
+	case EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		BUG_ON(!di->di_u.delta[0]);
+		BUG_ON(lcn < di->di_u.delta[0]);
+
+		ofs = vle_get_logical_extent_head(inode,
+			page_iter, kaddr_iter,
+			lcn - di->di_u.delta[0], pcn, flags);
+		break;
+	case EROFS_VLE_CLUSTER_TYPE_PLAIN:
+		*flags ^= EROFS_MAP_ZIPPED;
+	case EROFS_VLE_CLUSTER_TYPE_HEAD:
+		ofs = lcn * clustersize +
+			(le16_to_cpu(di->di_clusterofs) & (clustersize - 1));
+		*pcn = le32_to_cpu(di->di_u.blkaddr);
+		break;
+	default:
+		BUG_ON(1);
+	}
+	return ofs;
+}
+
+int erofs_map_blocks_iter(struct inode *inode,
+	struct erofs_map_blocks *map,
+	struct page **mpage_ret, int flags)
+{
+	/* logicial extent (start, end) offset */
+	unsigned long long ofs, end;
+	struct erofs_decompressed_index_vle *di;
+	erofs_blk_t e_blkaddr, pcn;
+	unsigned lcn, logical_cluster_ofs;
+	struct page *mpage = *mpage_ret;
+	void *kaddr;
+	bool initial;
+	unsigned clustersize = 1 << EROFS_SB(inode->i_sb)->clusterbits;
+
+	/* if both m_(l,p)len are 0, regularize l_lblk, l_lofs, etc... */
+	initial = !map->m_llen;
+
+	if (unlikely(map->m_la >= inode->i_size)) {
+		BUG_ON(!initial);
+		map->m_la = inode->i_size - 1;
+	}
+
+	debugln("%s, m_la %llu m_llen %llu --- start", __func__,
+		map->m_la, map->m_llen);
+
+	ofs = map->m_la + map->m_llen;
+
+	lcn = ofs / clustersize;
+	e_blkaddr = vle_extent_blkaddr(inode, lcn);
+
+	if (mpage == NULL || mpage->index != e_blkaddr) {
+		if (mpage != NULL)
+			put_page(mpage);
+
+		mpage = erofs_get_meta_page(inode->i_sb, e_blkaddr, false);
+		*mpage_ret = mpage;
+	} else {
+		lock_page(mpage);
+		DBG_BUGON(!PageUptodate(mpage));
+	}
+
+	kaddr = kmap_atomic(mpage);
+	di = kaddr + vle_extent_blkoff(inode, lcn);
+
+	debugln("%s, lcn %u e_blkaddr %u e_blkoff %u", __func__, lcn,
+		e_blkaddr, vle_extent_blkoff(inode, lcn));
+
+	logical_cluster_ofs = vle_compressed_index_clusterofs(clustersize, di);
+	if (!initial) {
+		/* m_(l,p)blk, m_(l,p)ofs has been already initialized */
+		map->m_llen += logical_cluster_ofs;
+		goto out;
+	}
+
+	/* by default, compressed */
+	map->m_flags |= EROFS_MAP_ZIPPED;
+
+	end = (u64)(lcn + 1) * clustersize;
+
+	switch(vle_cluster_type(di)) {
+	case EROFS_VLE_CLUSTER_TYPE_PLAIN:
+		if (ofs % clustersize >= logical_cluster_ofs)
+			map->m_flags ^= EROFS_MAP_ZIPPED;
+	case EROFS_VLE_CLUSTER_TYPE_HEAD:
+		if (ofs % clustersize == logical_cluster_ofs) {
+			pcn = le32_to_cpu(di->di_u.blkaddr);
+			goto unneed;
+		}
+
+		if (ofs % clustersize > logical_cluster_ofs) {
+			ofs = lcn * clustersize | logical_cluster_ofs;
+			pcn = le32_to_cpu(di->di_u.blkaddr);
+			break;
+		}
+
+		BUG_ON(!lcn);	/* logical cluster number >= 1 */
+		end = (lcn-- * clustersize) | logical_cluster_ofs;
+	case EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		/* get the correspoinding first chunk */
+		ofs = vle_get_logical_extent_head(inode, mpage_ret,
+			&kaddr, lcn, &pcn, &map->m_flags);
+		mpage = *mpage_ret;
+		break;
+	default:
+		errln("%s, invalid cluster type %u on m_la %llu of nid %llu",
+			__func__, vle_cluster_type(di), ofs,
+			EROFS_V(inode)->nid);
+		BUG();
+		pcn = ~0;
+	}
+
+	map->m_la = ofs;
+unneed:
+	map->m_llen = end - ofs;
+	map->m_plen = clustersize;
+	map->m_pa = blknr_to_addr(pcn);
+	map->m_flags |= EROFS_MAP_MAPPED;
+	debugln("%s, m_la %llu m_pa %llu m_llen %llu m_plen %llu m_flags %u",
+		__func__, map->m_la, map->m_pa,
+		map->m_llen, map->m_plen, map->m_flags);
+out:
+	kunmap_atomic(kaddr);
+	unlock_page(mpage);
+	return 0;
+}
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 3, 0))
+static inline void zipped_async_read_endio(struct bio *bio, int err)
+#else
+static inline void zipped_async_read_endio(struct bio *bio)
+#endif
+{
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+	struct super_block *sb = bio->bi_private;
+	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	struct z_erofs_vle_zipped_pack *victim = NULL;
+	unsigned j, z_avail = 0; /* avoid the false uninitialized warning */
+#endif
+	unsigned i;
+	struct bio_vec *bvec;
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 13, 0))
+		const int err = bio->bi_status;
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 3, 0))
+		const int err = bio->bi_error;
+#endif
+		struct z_erofs_vle_zipped_pack *zip;
+
+		/* page is already locked */
+		DBG_BUGON(PageUptodate(page));
+
+		if (unlikely(err))
+			SetPageError(page);
+		else
+			SetPageUptodate(page);
+
+		debugln("%s: %d zpage %p index: %lu", __func__, __LINE__,
+			page, page->index);
+
+		zip = (void *)erofs_page_private(page);
+		DBG_BUGON(zip == NULL);
+
+		DBG_BUGON(!has_page_bundle(page));
+
+#if EROFS_PAGE_BUNDLE_MAX_PAGES > 1
+		/* for multiple bundle pages */
+		if (zip == victim)
+			++z_avail;
+		else {
+			z_avail = 0;
+			for(j = 0; j < EROFS_PAGE_BUNDLE_MAX_PAGES; ++j)
+				z_avail += PageUptodate(zip->bundle.pages[j]);
+			victim = zip;
+		}
+
+		if (z_avail == clusterpages) {
+#else
+		if (PageUptodate(zip->bundle.pages[0])) {
+#endif
+
+			debugln("queue work %p zpage %p zip %p", &zip->work, page, zip);
+
+			queue_work(z_erofs_workqueue, &zip->work);
+		}
+
+		unlock_page(page);
+		/* page could be reclaimed now */
+	}
+	bio_put(bio);
+}
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 3, 0))
+static inline void zipped_sync_read_endio(struct bio *bio, int err)
+#else
+static inline void zipped_sync_read_endio(struct bio *bio)
+#endif
+{
+	unsigned i;
+	struct bio_vec *bvec;
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 13, 0))
+		const int err = bio->bi_status;
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 3, 0))
+		const int err = bio->bi_error;
+#endif
+
+		/* page is already locked */
+		DBG_BUGON(PageUptodate(page));
+
+		if (unlikely(err))
+			SetPageError(page);
+		else
+			SetPageUptodate(page);
+
+		unlock_page(page);
+		/* page could be reclaimed now */
+	}
+	bio_put(bio);
+}
+
+static struct bio *zipped_prepare_bio(struct super_block *sb,
+	erofs_blk_t blkaddr, bool sync)
+{
+	/* FIXME, need optimise */
+	struct bio *bio = bio_alloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
+
+	BUG_ON(bio == NULL);
+	bio->bi_end_io = sync ? zipped_sync_read_endio :
+	                        zipped_async_read_endio;
+	bio_set_dev(bio, sb->s_bdev);
+	bio->bi_private = sb;
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 0))
+	bio->bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
+#else
+	bio->bi_iter.bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
+#endif
+	return bio;
+}
+
+static void __submit_bio(struct bio *bio, unsigned op, unsigned op_flags)
+{
+	bio_set_op_attrs(bio, op, op_flags);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 8, 0))
+	submit_bio(0, bio);
+#else
+	submit_bio(bio);
+#endif
+}
+
+static void z_erofs_vle_submit_all(struct super_block *sb,
+                                   struct z_erofs_zipped_pagevec *vec,
+                                   bool sync)
+{
+	struct page *page, *tmp;
+	pgoff_t last_page;
+	struct bio *bio = NULL;
+
+	if (z_erofs_zipped_pagevec_empty(vec))
+		return;
+
+	/* should not be NULL */
+	tmp = z_erofs_zipped_pagevec_pop(vec);
+	do {
+		pgoff_t current_page;
+
+		page = tmp;
+		current_page = page->index;
+
+		/* could contain the pagevec itself, pop "tmp" in advance */
+		tmp = z_erofs_zipped_pagevec_pop(vec);
+
+		debugln("%s, found vec=%p page %p, index=%lu",
+			__func__, vec, page, current_page);
+
+		DBG_BUGON(!PageLocked(page));
+
+		if (bio != NULL && last_page + 1 != page->index) {
+submit_bio_retry:
+			__submit_bio(bio, REQ_OP_READ, 0);
+			bio = NULL;
+		}
+
+		if (bio == NULL)
+			bio = zipped_prepare_bio(sb, current_page, sync);
+
+		if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE)
+			goto submit_bio_retry;
+
+		last_page = current_page;
+	} while (tmp != NULL);
+
+	if (bio != NULL)
+		__submit_bio(bio, REQ_OP_READ, 0);
+}
+
+static int z_erofs_vle_normalaccess_readpage(struct file *file,
+                                             struct page *page)
+{
+	struct erofs_map_blocks_iter m_iter = {
+		.map = {.m_llen = 0, .m_plen = 0},
+		.mpage = NULL
+	};
+	struct z_erofs_vle_zipped_iter z_iter = { .zip = NULL };
+	struct z_erofs_zipped_pagevec z_pvec = { .page = NULL };
+	struct z_erofs_zipped_pack_collector collector = {
+		.list = LIST_HEAD_INIT(collector.list),
+		.sync = true
+	};
+	LIST_HEAD(pagepool);
+
+	int err = z_erofs_vle_do_read_page(page, &z_pvec,
+		&z_iter, &m_iter, &pagepool, &collector);
+
+	if (z_iter.zip != NULL) {
+		vle_zipped_iter_dispatch(&z_iter, &collector);
+		vle_zipped_iter_end(&z_iter);
+	}
+
+	if (!err) {
+		struct super_block *sb = page->mapping->host->i_sb;
+
+		/* submit all compressed page in the forward order */
+		z_erofs_vle_submit_all(sb, &z_pvec, true);
+		/* unzip all collected compressed pages */
+		vle_zipped_collected_unzip_all(sb, &collector.list);
+	} else {
+		errln("%s, failed to read, err [%d]", __func__, err);
+		z_erofs_zipped_pagevec_end(&z_pvec);
+	}
+
+	if (m_iter.mpage != NULL)
+		put_page(m_iter.mpage);
+
+	/* clean up the remaining free pages */
+	put_pages_list(&pagepool);
+	return err;
+}
+
+static inline int __z_erofs_vle_normalaccess_readpages(
+	struct file *filp,
+	struct address_space *mapping,
+	struct list_head *pages, unsigned nr_pages, bool sync)
+{
+	struct erofs_map_blocks_iter m_iter = {
+		.map = {.m_llen = 0, .m_plen = 0},
+		.mpage = NULL
+	};
+	struct z_erofs_vle_zipped_iter z_iter = { .zip = NULL };
+	struct z_erofs_zipped_pagevec z_pvec = { .page = NULL };
+	struct z_erofs_zipped_pack_collector collector = {
+		.list = LIST_HEAD_INIT(collector.list),
+		.sync = sync
+	};
+	struct super_block *sb = mapping->host->i_sb;
+	LIST_HEAD(pagepool);
+
+	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
+
+	for (; nr_pages; --nr_pages) {
+		/* traversal in reverse order */
+		struct page *page = list_entry(pages->next, struct page, lru);
+
+		prefetchw(&page->flags);
+		list_del(&page->lru);
+
+		if (add_to_page_cache_lru(page, mapping, page->index, gfp))
+			list_add(&page->lru, &pagepool);
+		else {
+			int err = z_erofs_vle_do_read_page(page, &z_pvec,
+				&z_iter, &m_iter, &pagepool, &collector);
+
+			if (err) {
+				errln("%s, readahead error at page %lu of nid %llu",
+					__func__, page->index,
+					EROFS_V(mapping->host)->nid);
+			}
+			put_page(page);
+		}
+	}
+
+	if (z_iter.zip != NULL) {
+		vle_zipped_iter_dispatch(&z_iter, &collector);
+		vle_zipped_iter_end(&z_iter);
+	}
+
+	/* submit all compresssed page in the forward order */
+	z_erofs_vle_submit_all(sb, &z_pvec, sync);
+
+	if (!sync)
+		/* queue all collected compressed pages (ready) for workers */
+		vle_zipped_collected_enqueue_all(&collector.list);
+	else
+		/* unzip all collected compressed pages */
+		vle_zipped_collected_unzip_all(sb, &collector.list);
+
+	if (m_iter.mpage != NULL)
+		put_page(m_iter.mpage);
+
+	/* clean up the remaining free pages */
+	put_pages_list(&pagepool);
+	return 0;
+}
+
+static int z_erofs_vle_normalaccess_readpages(
+	struct file *filp,
+	struct address_space *mapping,
+	struct list_head *pages, unsigned nr_pages)
+{
+	return __z_erofs_vle_normalaccess_readpages(filp,
+		mapping, pages, nr_pages,
+		nr_pages < 4 /* sync */);
+}
+
+/* for uncompressed (aligned) files and raw access for other files */
+const struct address_space_operations z_erofs_vle_normal_access_aops = {
+	.readpage = z_erofs_vle_normalaccess_readpage,
+	.readpages = z_erofs_vle_normalaccess_readpages,
+};
+
diff --git a/fs/erofs/unzip.h b/fs/erofs/unzip.h
new file mode 100644
index 0000000..45e4e14
--- /dev/null
+++ b/fs/erofs/unzip.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * linux/fs/erofs/unzip.h
+ *
+ * Copyright (c) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#ifndef __EROFS_UNZIP_H
+#define __EROFS_UNZIP_H
+
+#include "pagevec.h"
+#include <linux/workqueue.h>
+
+#define Z_EROFS_PACK_SIZE       (sizeof(struct z_erofs_vle_zipped_pack))
+
+#define Z_EROFS_PACK_INITIALIZED        0x0001
+#define Z_EROFS_PACK_ZIPPED             0x0002
+
+struct z_erofs_vle_zipped_pack {
+	struct erofs_page_bundle bundle;
+	struct mutex lock;
+
+	struct work_struct work;
+	/*
+	 * a small number of inline pages (should be > 3, currently == 4)
+	 * the rest pages are dynamically managed in de_pagevec (see pagevec.h)
+	 */
+	struct page *pages[DE_PAGEVEC_INLINE_ENTRYS];
+
+	unsigned flags;
+	unsigned short queued_pages;
+	unsigned short nr_pages;
+
+	/* logical extent information */
+	unsigned llen;
+	unsigned long long la;
+};
+
+struct z_erofs_vle_zipped_iter {
+	struct z_erofs_vle_zipped_pack *zip;
+	struct z_erofs_de_pagevec d_pvec;
+
+	bool already;
+};
+
+struct z_erofs_pack_info {
+	struct page **pages;
+	unsigned short queued_pages;
+	unsigned short nr_pages;
+};
+
+#define z_erofs_vle_zipped_list_entry(zip) (&(zip)->work.entry)
+#define z_erofs_vle_zipped_protect_list_entry(zip) \
+	(!test_and_set_bit(WORK_STRUCT_PENDING_BIT, \
+work_data_bits(&(zip)->work)))
+#define z_erofs_vle_zipped_unprotect_list_entry(zip) \
+	clear_bit(WORK_STRUCT_PENDING_BIT, \
+work_data_bits(&(zip)->work))
+
+struct z_erofs_onlinepage_info {
+	atomic_t pending_packs;
+};
+
+static inline void z_erofs_onlinepage_init(struct page *page)
+{
+	struct z_erofs_onlinepage_info opi = {
+		.pending_packs = ATOMIC_INIT(0)
+	};
+
+	set_page_private(page, *(unsigned long *)&opi);
+	smp_wmb();
+	SetPagePrivate(page);
+}
+
+static inline void z_erofs_onlinepage_setup(struct page *page, int packs)
+{
+	struct z_erofs_onlinepage_info *opi;
+	int ret;
+
+	DBG_BUGON(!PagePrivate(page));
+	opi = (void *)&page_private(page);
+
+	ret = atomic_add_return(packs, &opi->pending_packs);
+	if (!ret) {
+		ClearPagePrivate(page);
+		if (!PageError(page))
+			SetPageUptodate(page);
+		unlock_page(page);
+	}
+	debugln("%s, page %p pending_packs %d count: %u",
+		__func__, page, atomic_read(&opi->pending_packs),
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 7, 0))
+		atomic_read(&page->_count));
+#else
+		atomic_read(&page->_refcount));
+#endif
+}
+
+#define z_erofs_onlinepage_endio(page)	\
+	z_erofs_onlinepage_setup(page, -1)
+
+/* unzip_generic.c */
+int erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
+
+extern void z_erofs_plain_copy(struct z_erofs_pack_info *,
+	struct page **, unsigned, unsigned long long);
+extern int z_erofs_unzip_generic(struct z_erofs_pack_info *,
+	void *, size_t, unsigned long long, unsigned);
+extern int erofs_try_to_free_vle_zipped_page(struct page *);
+
+#include "unzip_vle.h"
+
+#endif
+
diff --git a/fs/erofs/unzip_generic.c b/fs/erofs/unzip_generic.c
new file mode 100644
index 0000000..5e0b0bc
--- /dev/null
+++ b/fs/erofs/unzip_generic.c
@@ -0,0 +1,295 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/unzip_generic.c
+ *
+ * Copyright (c) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include "unzip.h"
+
+/*
+ * - The temporarily workaround approach -
+ *
+ * In the future, we attempt to add new interfaces
+ * which can support a customized vmap iterator
+ * to avoid memory allocation.
+ */
+static DEFINE_MUTEX(pagemap_lock);
+static struct page *pagemap_pages_global[2048];
+
+void z_erofs_plain_copy(struct z_erofs_pack_info *pack,
+                        struct page **in_pages,
+                        unsigned nr_inpages,
+                        unsigned long long lofs)
+{
+	void *src = NULL;
+	struct z_erofs_de_pagevec d_pvec;
+	struct page *out_pages[96];
+	unsigned i, nr_pages, startnr, pageofs;
+
+	DBG_BUGON(!pack->nr_pages);
+	DBG_BUGON(!pack->queued_pages);
+
+	pageofs = lofs & ~PAGE_MASK;
+	startnr = lofs >> PAGE_SHIFT;
+
+	nr_pages = pack->nr_pages;
+	for(i = 0; i < nr_pages; ++i)
+		out_pages[i] = NULL;
+
+	z_erofs_de_pagevec_init(&d_pvec, pack->pages, 0);
+	for(i = 0; i < pack->queued_pages; ++i) {
+		struct page *page = z_erofs_de_pagevec_dequeue(&d_pvec);
+		unsigned pagenr;
+
+		DBG_BUGON(page == NULL);
+		pagenr = page->index - startnr;
+
+		DBG_BUGON(!PageLocked(page));
+		DBG_BUGON(pagenr >= nr_pages);
+		out_pages[pagenr] = page;
+	}
+	z_erofs_de_pagevec_end(&d_pvec, true);
+	/* clear queued logical pages */
+	pack->queued_pages = 0;
+
+	for(i = 0; i < nr_pages; ++i) {
+		struct page *page = out_pages[i];
+		void *dst;
+		const unsigned righthalf = PAGE_SIZE - pageofs;
+
+		if (page == NULL) {
+			if (src != NULL)
+				kunmap_atomic(src);
+			src = kmap_atomic(in_pages[i]);
+			continue;
+		}
+
+		dst = kmap_atomic(page);
+		if (src != NULL) {
+			memcpy(dst, src + righthalf, pageofs);
+			kunmap_atomic(src);
+		}
+
+		if (i >= nr_inpages) {
+			kunmap_atomic(dst);
+			z_erofs_onlinepage_endio(page);
+			return;
+		}
+
+		src = kmap_atomic(in_pages[i]);
+		memcpy(dst + pageofs, src, righthalf);
+		kunmap_atomic(dst);
+		z_erofs_onlinepage_endio(page);
+	}
+	kunmap_atomic(src);
+}
+
+struct unzip_fast_percpu_buffer {
+	char data[PAGE_SIZE * DE_PAGEVEC_INLINE_ENTRYS];
+};
+
+static inline int unzip_fast_percpu(struct z_erofs_pack_info *pack,
+                                    void *in, size_t inlen,
+                                    unsigned long long lofs,
+                                    unsigned llen,
+                                    struct page **pagemap)
+{
+	static struct unzip_fast_percpu_buffer pcpubuf[NR_CPUS];
+	unsigned nr_pages = pack->nr_pages;
+	unsigned i, j, pageofs;
+	void *addr;
+	size_t outlen;
+	int ret;
+
+	if (nr_pages > DE_PAGEVEC_INLINE_ENTRYS)
+		return -ENOTSUPP;
+
+	/* should be auto-unwrapped */
+	for(i = 0; i < DE_PAGEVEC_INLINE_ENTRYS; ++i)
+		pagemap[i] = NULL;
+
+	j = lofs / PAGE_SIZE;
+	for(i = 0; i < pack->queued_pages; ++i) {
+		struct page *const page = pack->pages[i];
+
+		DBG_BUGON(page == NULL);
+		DBG_BUGON(page->index - j >= nr_pages);
+		pagemap[page->index - j] = page;
+	}
+
+	/* clear queued logical pages */
+	pack->queued_pages = 0;
+
+	addr = pagemap[0] == NULL || PageHighMem(pagemap[0]) ?
+	       NULL : page_address(pagemap[0]);
+
+	for(i = 1; i < nr_pages; ++i) {
+		if (pagemap[i] == NULL ||
+		    addr + PAGE_SIZE != page_address(pagemap[i]) ||
+		    PageHighMem(pagemap[i])) {
+			addr = NULL;
+			break;
+		}
+		addr += PAGE_SIZE;
+	}
+
+	pageofs = lofs & ~PAGE_MASK;
+	outlen = min((nr_pages << PAGE_SHIFT) - pageofs, llen);
+	if (addr != NULL) {
+		/* we are lucky, do in-place decompression */
+		ret = erofs_unzip_lz4(in,
+		                      page_address(pagemap[0]) + pageofs,
+		                      inlen, outlen);
+		for(i = 0; i < nr_pages; ++i) {
+			DBG_BUGON(pagemap[i] == NULL);
+			if (ret < 0)
+				SetPageError(pagemap[i]);
+			z_erofs_onlinepage_endio(pagemap[i]);
+		}
+	} else {
+		preempt_disable();
+		addr = pcpubuf[smp_processor_id()].data;
+
+		ret = erofs_unzip_lz4(in, addr + pageofs, inlen, outlen);
+		if (ret >= 0)
+			outlen = ret;
+
+		for(i = 0; i < nr_pages; ++i) {
+			j = min(PAGE_SIZE - pageofs, outlen);
+			if (pagemap[i] != NULL) {
+				if (ret < 0)
+					SetPageError(pagemap[i]);
+				else {
+					void *dst = kmap_atomic(pagemap[i]);
+
+					memcpy(dst + pageofs, addr + pageofs, j);
+					kunmap_atomic(dst);
+				}
+				z_erofs_onlinepage_endio(pagemap[i]);
+			}
+			addr += PAGE_SIZE;
+			outlen -= j;
+			pageofs = 0;
+		}
+
+		preempt_enable();
+	}
+	return ret;
+}
+
+int z_erofs_unzip_generic(struct z_erofs_pack_info *pack,
+                          void *in, size_t inlen,
+                          unsigned long long lofs,
+                          unsigned llen)
+{
+	struct z_erofs_de_pagevec d_pvec;
+	unsigned i, startnr, pageofs, nr_pages;
+	struct page *pagemap_pages_inline[96], **pagemap_pages;
+
+	void *addr;
+	size_t outlen;
+	int ret;
+
+	DBG_BUGON(!pack->queued_pages);
+
+	erofs_dbg_might_sleep();
+
+	nr_pages = pack->nr_pages;
+	if (nr_pages > 96) {
+		pagemap_pages = pagemap_pages_global;
+		mutex_lock(&pagemap_lock);
+	} else {
+		pagemap_pages = pagemap_pages_inline;
+		ret = unzip_fast_percpu(pack, in, inlen,
+		                        lofs, llen,
+		                        pagemap_pages);
+		if (ret != -ENOTSUPP)
+			return ret;
+	}
+
+	for(i = 0; i < nr_pages; ++i)
+		pagemap_pages[i] = NULL;
+
+	startnr = lofs / PAGE_SIZE;
+
+	debugln("%s, pack = %p queued_pages = %u",
+		__func__, pack, pack->queued_pages);
+
+	z_erofs_de_pagevec_init(&d_pvec, pack->pages, 0);
+	for(i = 0; i < pack->queued_pages; ++i) {
+		struct page *page = z_erofs_de_pagevec_dequeue(&d_pvec);
+		unsigned pagenr;
+
+		DBG_BUGON(page == NULL);
+
+		pagenr = page->index - startnr;
+		debugln("%s, pack = %p page = %p, index = %lu, pagenr = %u",
+			__func__, pack, page, page->index, pagenr);
+
+		DBG_BUGON(!PageLocked(page));
+		DBG_BUGON(pagenr >= nr_pages);
+		pagemap_pages[pagenr] = page;
+	}
+	z_erofs_de_pagevec_end(&d_pvec, true);
+
+	/* clear queued logical pages */
+	pack->queued_pages = 0;
+
+	/*
+	 * for preload or small compression-ratio files,
+	 * it is very likely queued_pages == nr_pages.
+	 */
+	if (i != nr_pages) {
+		for(i = 0; i < nr_pages; ++i) {
+			if (pagemap_pages[i] == NULL)
+				/* TODO! temporary work */
+				pagemap_pages[i] = alloc_page(GFP_KERNEL | __GFP_NOFAIL);
+		}
+	}
+
+	addr = erofs_vmap(pagemap_pages, nr_pages);
+	/* FIXME! error handling case */
+	BUG_ON(addr == NULL);
+
+	pageofs = lofs & ~PAGE_MASK;
+	outlen = min((nr_pages << PAGE_SHIFT) - pageofs, llen);
+
+	debugln("%s, in %p out %p inlen %lu outlen %lu", __func__,
+		in, addr + pageofs, inlen, outlen);
+
+#if 0
+	print_hex_dump(KERN_DEBUG, "raw data: ", DUMP_PREFIX_OFFSET,
+		16, 1, in, inlen, true);
+#endif
+
+	/* we only support LZ4 currently */
+	ret = erofs_unzip_lz4(in, addr + pageofs, inlen, outlen);
+	if (ret > 0) {
+		outlen = ret;
+		ret = 0;
+	}
+
+	erofs_vunmap(addr, nr_pages);
+
+	for(i = 0; i < nr_pages; ++i) {
+		if (!PageLocked(pagemap_pages[i]))
+			/* TODO! temporary work */
+			__free_page(pagemap_pages[i]);
+		else {
+			if (ret)
+				SetPageError(pagemap_pages[i]);
+			z_erofs_onlinepage_endio(pagemap_pages[i]);
+		}
+	}
+
+	if (pagemap_pages == pagemap_pages_global)
+		mutex_unlock(&pagemap_lock);
+	return ret;
+}
+
diff --git a/fs/erofs/unzip_vle.h b/fs/erofs/unzip_vle.h
new file mode 100644
index 0000000..cf7ef9f
--- /dev/null
+++ b/fs/erofs/unzip_vle.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * linux/fs/erofs/unzip_vle.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+
+#ifndef __EROFS_UNZIP_H
+#error "Please don't include unzip_vle.h directly, use unzip.h instead."
+#endif
+
+#define __vle_cluster_advise(x, bit, bits) \
+	((le16_to_cpu(x) >> (bit)) & ((1 << (bits)) - 1))
+
+#define __vle_cluster_type(advise) __vle_cluster_advise(advise, \
+	EROFS_VLE_DI_CLUSTER_TYPE_BIT, EROFS_VLE_DI_CLUSTER_TYPE_BITS)
+
+enum {
+	EROFS_VLE_CLUSTER_TYPE_PLAIN,
+	EROFS_VLE_CLUSTER_TYPE_HEAD,
+	EROFS_VLE_CLUSTER_TYPE_NONHEAD,
+	EROFS_VLE_CLUSTER_TYPE_RESERVED,
+	EROFS_VLE_CLUSTER_TYPE_MAX
+};
+
+#define vle_cluster_type(di)	\
+	__vle_cluster_type((di)->di_advise)
+
+static inline unsigned
+vle_compressed_index_clusterofs(unsigned clustersize,
+	struct erofs_decompressed_index_vle *di)
+{
+	debugln("%s, vle=%p, advise=%x (type %u), clusterofs=%x blkaddr=%x",
+		__func__, di, di->di_advise, vle_cluster_type(di),
+		di->di_clusterofs, di->di_u.blkaddr);
+
+	switch(vle_cluster_type(di)) {
+	case EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		break;
+	case EROFS_VLE_CLUSTER_TYPE_PLAIN:
+	case EROFS_VLE_CLUSTER_TYPE_HEAD:
+		return di->di_clusterofs;
+	default:
+		BUG_ON(1);
+	}
+	return clustersize;
+}
+
+static inline erofs_blk_t
+vle_extent_blkaddr(struct inode *inode, pgoff_t index)
+{
+	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
+	struct erofs_vnode *vi = EROFS_V(inode);
+
+	unsigned ofs = EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
+		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
+		index * sizeof(struct erofs_decompressed_index_vle);
+
+	return erofs_blknr(iloc(sbi, vi->nid) + ofs);
+}
+
+static inline unsigned int
+vle_extent_blkoff(struct inode *inode, pgoff_t index)
+{
+	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
+	struct erofs_vnode *vi = EROFS_V(inode);
+
+	unsigned ofs = EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
+		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
+		index * sizeof(struct erofs_decompressed_index_vle);
+
+	return erofs_blkoff(iloc(sbi, vi->nid) + ofs);
+}
-- 
1.9.1
