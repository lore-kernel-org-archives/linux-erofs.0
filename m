From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 27 Jun 2018 22:20:04 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0] erofs: introduce the new unzip
 subsystem
Message-ID: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

The patch is temporarily based on
[RFC PATCH RESEND 12/12] erofs: introduce VLE decompression support (experimental)

STILL BUGGY, NOT FOR DAILY USE!

 fs/erofs/Makefile        |    7 +-
 fs/erofs/data.c          |  189 +------
 fs/erofs/inode.c         |    2 +-
 fs/erofs/internal.h      |   54 ++
 fs/erofs/staging.h       |   42 ++
 fs/erofs/super.c         |    8 +
 fs/erofs/unzip_vle.c     | 1261 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/unzip_vle.h     |  236 +++++++--
 fs/erofs/unzip_vle_lz4.c |  145 ++++++
 fs/erofs/utils.c         |   31 ++
 10 files changed, 1742 insertions(+), 233 deletions(-)
 create mode 100644 fs/erofs/unzip_vle.c
 create mode 100644 fs/erofs/unzip_vle_lz4.c
 create mode 100644 fs/erofs/utils.c

diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
index 3086d08..6622e68 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -1,9 +1,8 @@
 EROFS_VERSION = "1.0"
 
-EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
+EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\" -DCONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT=1
 
 obj-$(CONFIG_EROFS_FS) += erofs.o
-erofs-objs := super.o inode.o data.o namei.o dir.o
+erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
-erofs-$(CONFIG_EROFS_FS_ZIP) += unzip.o unzip_generic.o unzip_lz4.o
-
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_vle_lz4.o unzip_lz4.o
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index c54495d..4817e16 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -43,33 +43,6 @@ static inline void read_endio(struct bio *bio)
 	bio_put(bio);
 }
 
-static void __submit_bio(struct bio *bio, unsigned op, unsigned op_flags)
-{
-	bio_set_op_attrs(bio, op, op_flags);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 8, 0))
-	submit_bio(0, bio);
-#else
-	submit_bio(bio);
-#endif
-}
-
-static struct bio *prepare_bio(struct super_block *sb,
-	erofs_blk_t blkaddr, unsigned nr_pages)
-{
-	struct bio *bio = bio_alloc(GFP_NOIO | __GFP_NOFAIL, nr_pages);
-
-	BUG_ON(bio == NULL);
-
-	bio->bi_end_io = read_endio;
-	bio_set_dev(bio, sb->s_bdev);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 0))
-	bio->bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
-#else
-	bio->bi_iter.bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
-#endif
-	return bio;
-}
-
 /* prio -- true is used for dir */
 struct page *erofs_get_meta_page(struct super_block *sb,
 	erofs_blk_t blkaddr, bool prio)
@@ -92,7 +65,7 @@ struct page *erofs_get_meta_page(struct super_block *sb,
 		struct bio *bio;
 		int err;
 
-		bio = prepare_bio(sb, blkaddr, 1);
+		bio = prepare_bio(sb, blkaddr, 1, read_endio);
 		err = bio_add_page(bio, page, PAGE_SIZE, 0);
 		BUG_ON(err != PAGE_SIZE);
 
@@ -233,6 +206,8 @@ static inline struct bio *erofs_read_raw_page(
 		struct erofs_map_blocks map = {
 			.m_la = blknr_to_addr(current_block),
 		};
+		erofs_blk_t blknr;
+		unsigned blkoff;
 
 		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
 		if (unlikely(err))
@@ -250,6 +225,9 @@ static inline struct bio *erofs_read_raw_page(
 		/* for RAW access mode, m_plen must be equal to m_llen */
 		BUG_ON(map.m_plen != map.m_llen);
 
+		blknr = erofs_blknr(map.m_pa);
+		blkoff = erofs_blkoff(map.m_pa);
+
 		/* deal with inline page */
 		if (map.m_flags & EROFS_MAP_META) {
 			void *vsrc, *vto;
@@ -257,8 +235,7 @@ static inline struct bio *erofs_read_raw_page(
 
 			BUG_ON(map.m_plen > PAGE_SIZE);
 
-			ipage = erofs_get_meta_page(inode->i_sb,
-				erofs_blknr(map.m_pa), 0);
+			ipage = erofs_get_meta_page(inode->i_sb, blknr, 0);
 
 			if (IS_ERR(ipage)) {
 				err = PTR_ERR(ipage);
@@ -267,7 +244,7 @@ static inline struct bio *erofs_read_raw_page(
 
 			vsrc = kmap_atomic(ipage);
 			vto = kmap_atomic(page);
-			memcpy(vto, vsrc + erofs_blkoff(map.m_pa), map.m_plen);
+			memcpy(vto, vsrc + blkoff, map.m_plen);
 			memset(vto + map.m_plen, 0, PAGE_SIZE - map.m_plen);
 			kunmap_atomic(vto);
 			kunmap_atomic(vsrc);
@@ -291,7 +268,7 @@ static inline struct bio *erofs_read_raw_page(
 		if (nblocks > BIO_MAX_PAGES)
 			nblocks = BIO_MAX_PAGES;
 
-		bio = prepare_bio(inode->i_sb, erofs_blknr(map.m_pa), nblocks);
+		bio = prepare_bio(inode->i_sb, blknr, nblocks, read_endio);
 	}
 
 	err = bio_add_page(bio, page, PAGE_SIZE, 0);
@@ -414,155 +391,7 @@ struct inode *erofs_init_page_bundle(struct super_block *sb)
 	return inode;
 }
 
-/*
- * Our zip(compression) subsystem wants to get the page bundle
- * in the non-blocking way. In that case, we could dynamically add
- * filemap pages to a zipped pack on-the-fly before decompressing.
- *
- * Different from buffer head (fs/buffer.c) using a private_lock
- * which is slightly slow in the high-concurrency scenarios,
- * we introduce a bit_spinlock to serialize and close all races.
- */
-struct page *erofs_grab_bundle_page(struct super_block *sb,
-	pgoff_t index, bool *created, struct list_head *page_pool)
-{
-	struct address_space *const mapping =
-		EROFS_SB(sb)->ibundle->i_mapping;
-	/* page, alternate page (if page is not exist in the mapping) */
-	struct page *page, *alt = NULL;
-
-	/* currectly, the fail path is still unimplemented */
-	const gfp_t gfp = mapping_gfp_mask(mapping) | __GFP_NOFAIL;
-
-	/* first, we try to find a unlock page */
-	*created = false;
-
-	/*
-	 * In order to reduce the memory pressure, we don't mark
-	 * the page accessed again.
-	 */
-	page = find_get_page(mapping, index);
-
-	if (page != NULL)
-		return page;
-
-	/* then, get a new free page if not found */
-	if (!list_empty(page_pool)) {
-		alt = list_last_entry(page_pool, struct page, lru);
-		list_del(&alt->lru);
-	} else {
-		alt = __page_cache_alloc(gfp);
-		DBG_BUGON(alt == NULL);
-	}
-
-	prefetchw(&alt->flags);
-	/* clean page private for the later page bundle use */
-	set_page_private(alt, 0);
-
-	do {
-		int err = add_to_page_cache_lru(alt, mapping, index, gfp);
-		if (!err) {
-			*created = true;
-			return alt;
-		} else if (err != -EEXIST) {
-			/* Presumably ENOMEM for radix tree node */
-			page = ERR_PTR(err);
-			break;
-		}
-		page = find_get_page(mapping, index);
-	} while(page == NULL);
-
-	/* put the unused alternate page back to the free pool */
-	list_add(&alt->lru, page_pool);
-	return page;
-}
-
-void erofs_add_to_page_bundle(struct erofs_page_bundle *bundle,
-	unsigned nr, struct page *page)
-{
-	struct erofs_page_bundle *b = erofs_lock_page_private(page);
-
-	if (has_page_bundle(page))
-		goto exist;
-
-	page_cache_get(page);
-	if (test_set_page_bundle(page)) {
-		page_cache_release(page);
-exist:
-		BUG_ON(bundle != b);
-		lockref_get(&b->lockref);
-		goto out;
-	}
-
-	spin_lock(&bundle->lockref.lock);
-	BUG_ON(b != NULL);
-	BUG_ON(bundle->lockref.count <= 0);
-	BUG_ON(bundle->pages[nr] != NULL);
-
-	++bundle->lockref.count;
-	bundle->pages[nr] = page;
-	spin_unlock(&bundle->lockref.lock);
-out:
-	erofs_set_page_private(page, bundle);
-	erofs_unlock_page_private(page);
-}
-
-struct erofs_page_bundle *erofs_get_page_bundle(struct page *page,
-	unsigned nr, erofs_page_bundle_ctor_t ctor)
-{
-	struct erofs_page_bundle *b = erofs_lock_page_private(page);
-
-	if (!has_page_bundle(page))
-		ctor(page, nr);
-	else {
-		DBG_BUGON(b == NULL);
-		DBG_BUGON(b->pages[nr] != page);
-
-		lockref_get(&b->lockref);
-	}
-	erofs_unlock_page_private(page);
-
-	/* page private must be available now */
-	return erofs_page_private(page);
-}
-
-extern int erofs_try_to_free_vle_zipped_page(struct page *page);
-
-static int page_bundle_releasepage(struct page *page, gfp_t gfp_mask)
-{
-	int ret = 1;	/* 0 - busy */
-	struct address_space *const mapping = page->mapping;
-
-	BUG_ON(!PageLocked(page));
-	BUG_ON(mapping->a_ops != &erofs_page_bundle_aops);
-
-	if (has_page_bundle(page)) {
-		debugln("%s, page: %p", __func__, page);
-
-		/* currently we have the only user */
-		ret = erofs_try_to_free_vle_zipped_page(page);
-	}
-	return ret;
-}
-
-static void page_bundle_invalidatepage(struct page *page,
-                                       unsigned int offset,
-                                       unsigned int length)
-{
-	const unsigned int stop = length + offset;
-
-	BUG_ON(!PageLocked(page));
-	/* Check for overflow */
-	BUG_ON(stop > PAGE_SIZE || stop < length);
-
-	if (offset == 0 && stop == PAGE_SIZE)
-		while(!page_bundle_releasepage(page, GFP_NOFS))
-			cond_resched();
-}
-
 const struct address_space_operations erofs_page_bundle_aops = {
-	.releasepage = page_bundle_releasepage,
-	.invalidatepage = page_bundle_invalidatepage,
 };
 
 #endif
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 61010c0..12f2e1c 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -181,7 +181,7 @@ int fill_inode(struct inode *inode, int isdir)
 			goto out_unlock;
 		}
 
-		/* for compression or unknown data mapping mode */
+		/* for compression mapping mode */
 #ifdef CONFIG_EROFS_FS_ZIP
 		inode->i_mapping->a_ops = &z_erofs_vle_normal_access_aops;
 #else
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 307f435..726636e 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -64,8 +64,20 @@ struct erofs_sb_info {
 	/* inode slot unit size in bit shift */
 	unsigned char islotbits;
 #ifdef CONFIG_EROFS_FS_ZIP
+
+#define Z_EROFS_CLUSTER_MAX_PAGES       (CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT)
+
 	/* cluster size in bit shift */
 	unsigned char clusterbits;
+
+	/* dedicated workspace for compression */
+	struct {
+		struct radix_tree_root tree;
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+		spinlock_t lock;
+#endif
+	} zwrksp;
+
 #endif
 
 	u32 build_time_nsec;
@@ -94,6 +106,16 @@ struct erofs_sb_info {
 #define set_opt(sbi, option)	((sbi)->mount_opt |= EROFS_MOUNT_##option)
 #define test_opt(sbi, option)	((sbi)->mount_opt & EROFS_MOUNT_##option)
 
+#ifdef CONFIG_EROFS_FS_ZIP
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+#define z_erofs_workspace_lock(sbi) spin_lock(&(sbi)->zwrksp.lock)
+#define z_erofs_workspace_unlock(sbi) spin_unlock(&(sbi)->zwrksp.lock)
+#else
+#define z_erofs_workspace_lock(sbi) xa_lock(&(sbi)->zwrksp.tree)
+#define z_erofs_workspace_unlock(sbi) xa_unlock(&(sbi)->zwrksp.tree)
+#endif
+#endif
+
 /* we strictly follow PAGE_SIZE and no buffer head */
 #define LOG_BLOCK_SIZE		PAGE_SHIFT
 
@@ -247,6 +269,35 @@ struct erofs_map_blocks {
 #define EROFS_GET_BLOCKS_RAW    0x0001
 
 /* data.c */
+
+static inline struct bio *prepare_bio(struct super_block *sb,
+				      erofs_blk_t blkaddr,
+				      unsigned nr_pages, bio_end_io_t endio)
+{
+	struct bio *bio = bio_alloc(GFP_NOIO | __GFP_NOFAIL, nr_pages);
+
+	BUG_ON(bio == NULL);
+
+	bio->bi_end_io = endio;
+	bio_set_dev(bio, sb->s_bdev);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 0))
+	bio->bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
+#else
+	bio->bi_iter.bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
+#endif
+	return bio;
+}
+
+static inline void __submit_bio(struct bio *bio, unsigned op, unsigned op_flags)
+{
+	bio_set_op_attrs(bio, op, op_flags);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 8, 0))
+	submit_bio(0, bio);
+#else
+	submit_bio(bio);
+#endif
+}
+
 extern struct page *erofs_get_meta_page(struct super_block *sb,
 	erofs_blk_t blkaddr, bool prio);
 extern int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
@@ -409,5 +460,8 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
 #endif
 }
 
+/* utils.c */
+extern struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
+
 #endif
 
diff --git a/fs/erofs/staging.h b/fs/erofs/staging.h
index 7712a7b..c9cd542 100644
--- a/fs/erofs/staging.h
+++ b/fs/erofs/staging.h
@@ -81,3 +81,45 @@ static inline bool sb_rdonly(const struct super_block *sb) {
 
 #endif
 
+#ifndef lru_to_page
+#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 12, 0))
+
+static inline void *kvmalloc(size_t size, gfp_t flags)
+{
+	void *buffer = NULL;
+
+	if (size == 0)
+		return NULL;
+
+	/* do not attempt kmalloc if we need more than 16 pages at once */
+	if (size <= (16 * PAGE_SIZE))
+		buffer = kmalloc(size, flags);
+	if (!buffer) {
+		if (flags & __GFP_ZERO)
+			buffer = vzalloc(size);
+		else
+			buffer = vmalloc(size);
+	}
+	return buffer;
+}
+
+static inline void *kvzalloc(size_t size, gfp_t flags)
+{
+	return kvmalloc(size, flags | __GFP_ZERO);
+}
+
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 15, 0))
+static inline void kvfree(const void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree(addr);
+	else
+		kfree(addr);
+}
+#endif
+
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index c46d1c6..3de0631 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -113,6 +113,10 @@ static int superblock_read(struct super_block *sb)
 	sbi->islotbits = ffs(sizeof(struct erofs_inode_v1)) - 1;
 #ifdef CONFIG_EROFS_FS_ZIP
 	sbi->clusterbits = 12;
+
+	if (1 << (sbi->clusterbits - 12) > Z_EROFS_CLUSTER_MAX_PAGES)
+		errln("clusterbits %u is not supported on this kernel",
+			sbi->clusterbits);
 #endif
 
 	sbi->root_nid = le64_to_cpu(layout->root_nid);
@@ -195,6 +199,10 @@ static int erofs_read_super(struct super_block *sb,
 		goto err_sbi;
 	}
 #endif
+	INIT_RADIX_TREE(&sbi->zwrksp.tree, GFP_ATOMIC);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+	spin_lock_init(&sbi->zwrksp.lock);
+#endif
 
 	/* get the root inode */
 	inode = erofs_iget(sb, ROOT_NID(sbi), true);
diff --git a/fs/erofs/unzip_vle.c b/fs/erofs/unzip_vle.c
new file mode 100644
index 0000000..5fa10db
--- /dev/null
+++ b/fs/erofs/unzip_vle.c
@@ -0,0 +1,1261 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/unzip_vle.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include "unzip_vle.h"
+#include <linux/prefetch.h>
+
+/* -- zip subsystem overall -- */
+static struct workqueue_struct *z_erofs_workqueue __read_mostly;
+static struct kmem_cache *z_erofs_workgroup_cachep __read_mostly;
+
+void z_erofs_exit_zip_subsystem(void)
+{
+	BUG_ON(z_erofs_workqueue == NULL);
+	BUG_ON(z_erofs_workgroup_cachep == NULL);
+
+	destroy_workqueue(z_erofs_workqueue);
+	kmem_cache_destroy(z_erofs_workgroup_cachep);
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
+	z_erofs_workgroup_cachep =
+		kmem_cache_create("erofs_compress",
+		Z_EROFS_WORKGROUP_SIZE, 0,
+		SLAB_RECLAIM_ACCOUNT, NULL);
+
+	if (z_erofs_workgroup_cachep != NULL) {
+		if (!init_unzip_workqueue())
+			return 0;
+
+		kmem_cache_destroy(z_erofs_workgroup_cachep);
+	}
+	return -ENOMEM;
+}
+
+/* -- pagevec implementation -- */
+struct z_erofs_pagevec_collector {
+	struct page *curr, *next;
+	uintptr_t *pages;
+
+	unsigned int nr, index;
+};
+
+static inline void
+z_erofs_pagevec_collector_exit(
+	struct z_erofs_pagevec_collector *collector,
+	bool atomic)
+{
+	if (collector->curr == NULL)
+		return;
+
+	if (atomic)
+		kunmap_atomic(collector->pages);
+	else
+		kunmap(collector->curr);
+}
+
+union z_erofs_page_converter {
+	struct page *page;
+	uintptr_t v;
+};
+
+enum z_erofs_vle_page_type {
+	/* including Z_EROFS_VLE_PAGE_TAIL_EXCLUSIVE */
+	Z_EROFS_VLE_PAGE_TYPE_EXCLUSIVE,
+	Z_EROFS_VLE_PAGE_TYPE_TAIL_SHARED,
+
+	Z_EROFS_VLE_PAGE_TYPE_HEAD,
+	Z_EROFS_VLE_PAGE_TYPE_MASK
+};
+
+static inline struct page *
+z_erofs_pagevec_collector_next_page(
+	struct z_erofs_pagevec_collector *collector, unsigned nr)
+{
+	struct page *next = collector->next;
+
+	/* keep away from occupied pages */
+	if (next == NULL) {
+		unsigned index;
+
+		for(index = 0; index < nr; ++index) {
+			union z_erofs_page_converter cvt =
+				{.v = collector->pages[index]};
+
+			if (!(cvt.v & Z_EROFS_VLE_PAGE_TYPE_MASK)) {
+				cvt.v &= ~Z_EROFS_VLE_PAGE_TYPE_MASK;
+				next = cvt.page;
+				break;
+			}
+		}
+	}
+	return next;
+}
+
+static inline void
+z_erofs_pagevec_collector_pagedown(
+	struct z_erofs_pagevec_collector *ctor,
+	bool atomic)
+{
+	struct page *next;
+
+	next = z_erofs_pagevec_collector_next_page(ctor, ctor->nr);
+	z_erofs_pagevec_collector_exit(ctor, atomic);
+
+	ctor->curr = next;
+	ctor->next = NULL;
+	ctor->pages = atomic ?
+		kmap_atomic(ctor->curr) : kmap(ctor->curr);
+
+	ctor->nr = PAGE_SIZE / sizeof(struct page *);
+	ctor->index = 0;
+}
+
+static inline void z_erofs_pagevec_collector_init(
+	struct z_erofs_pagevec_collector *ctor,
+	uintptr_t *pages, unsigned i)
+{
+	const unsigned inline_nr = Z_EROFS_VLE_INLINE_PAGEVECS;
+
+	ctor->nr = inline_nr;
+	ctor->curr = ctor->next = NULL;
+	ctor->pages = pages;
+
+	if (i >= inline_nr) {
+		i -= inline_nr;
+		z_erofs_pagevec_collector_pagedown(ctor, false);
+		while (i > ctor->nr) {
+			i -= ctor->nr;
+			z_erofs_pagevec_collector_pagedown(ctor, false);
+		}
+	}
+
+	ctor->next = z_erofs_pagevec_collector_next_page(ctor, i);
+	ctor->index = i;
+}
+
+static inline bool z_erofs_pagevec_collector_enqueue(
+	struct z_erofs_pagevec_collector *collector,
+	struct page *page,
+	enum z_erofs_vle_page_type type,
+	bool *occupied)
+{
+	union z_erofs_page_converter cvt;
+
+	*occupied = false;
+	if (unlikely(collector->next == NULL && type))
+		if (collector->index + 1 == collector->nr)
+			return false;
+
+	if (unlikely(collector->index >= collector->nr))
+		z_erofs_pagevec_collector_pagedown(collector, false);
+
+	/* should remind that collector->next never equal to 1, 2 */
+	if (type == (uintptr_t)collector->next) {
+		collector->next = page;
+		*occupied = true;
+	}
+
+	cvt.page = page;
+	BUG_ON(cvt.v & Z_EROFS_VLE_PAGE_TYPE_MASK);
+	collector->pages[collector->index++] = cvt.v | type;
+	return true;
+}
+
+static inline struct page *z_erofs_pagevec_collector_dequeue(
+	struct z_erofs_pagevec_collector *collector,
+	enum z_erofs_vle_page_type *type)
+{
+	union z_erofs_page_converter cvt;
+
+	if (unlikely(collector->index >= collector->nr)) {
+		BUG_ON(collector->next == NULL);
+		z_erofs_pagevec_collector_pagedown(collector, true);
+	}
+	cvt.v = collector->pages[collector->index];
+
+	*type = cvt.v & Z_EROFS_VLE_PAGE_TYPE_MASK;
+	cvt.v &= ~Z_EROFS_VLE_PAGE_TYPE_MASK;
+
+	if (collector->next == NULL)
+		collector->next = cvt.page;
+
+	collector->pages[collector->index++] = (uintptr_t)NULL;
+	return cvt.page;
+}
+
+struct z_erofs_vle_work_pageldr {
+	bool owner;
+	struct z_erofs_vle_work *curr;
+	struct z_erofs_pagevec_collector vector;
+
+	/* pages used for reading the compressed data */
+	struct page **compressed_pages;
+	unsigned compressed_deficit;
+};
+
+static inline bool try_to_reuse_as_compressed_page(
+	struct z_erofs_vle_work_pageldr *l,
+	struct page *page)
+{
+	/* the following is a lockless approach */
+	while (l->compressed_deficit) {
+		--l->compressed_deficit;
+		if (cmpxchg(l->compressed_pages++, NULL, page) == NULL)
+			return true;
+	}
+
+	return false;
+}
+
+/* callers must be with work->lock held */
+static int z_erofs_vle_work_add_page(
+	struct z_erofs_vle_work_pageldr *l,
+	struct page *page,
+	enum z_erofs_vle_page_type type)
+{
+	int ret;
+	bool occupied;
+
+	/* give priority for the compressed data storage */
+	if (type == Z_EROFS_VLE_PAGE_TYPE_EXCLUSIVE &&
+		try_to_reuse_as_compressed_page(l, page))
+		return 0;
+
+	ret = z_erofs_pagevec_collector_enqueue(&l->vector,
+		page, type, &occupied);
+	l->curr->vcnt += (unsigned)ret;
+	return ret ? 0 : -EAGAIN;
+}
+
+static struct z_erofs_vle_workgroup *
+z_erofs_vle_workgroup_find(struct super_block *sb,
+			   pgoff_t index,
+			   bool *cached)
+{
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	union {
+		struct z_erofs_vle_workgroup *grp;
+		uintptr_t v;
+		void *ptr;
+	} u;
+
+repeat:
+	rcu_read_lock();
+	u.ptr = radix_tree_lookup(&sbi->zwrksp.tree, index);
+	if (u.ptr != NULL) {
+		*cached = radix_tree_exceptional_entry(u.ptr);
+		u.v &= ~RADIX_TREE_EXCEPTIONAL_ENTRY;
+
+		if (z_erofs_vle_workgroup_get(u.grp)) {
+			rcu_read_unlock();
+			goto repeat;
+		}
+	}
+	rcu_read_unlock();
+	return u.grp;
+}
+
+static int z_erofs_vle_workgroup_register(struct super_block *sb,
+					  struct z_erofs_vle_workgroup *grp,
+					  bool cached)
+{
+	union {
+		struct z_erofs_vle_workgroup *grp;
+		uintptr_t v;
+	} u;
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+
+	int err = radix_tree_preload(GFP_NOFS);
+
+	if (err)
+		return err;
+
+	z_erofs_workspace_lock(sbi);
+	u.grp = grp;
+	u.v |= (unsigned)cached << RADIX_TREE_EXCEPTIONAL_SHIFT;
+
+	err = radix_tree_insert(&sbi->zwrksp.tree, grp->index, u.grp);
+	if (!err)
+		__z_erofs_vle_workgroup_get(grp);
+
+	z_erofs_workspace_unlock(sbi);
+	radix_tree_preload_end();
+	return err;
+}
+
+static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_pageldr *l,
+				       struct super_block *sb,
+				       struct erofs_map_blocks *map,
+				       uintptr_t *chained_page)
+{
+	bool cached;
+	pgoff_t index = map->m_pa / EROFS_BLKSIZ;
+	struct z_erofs_vle_work *work;
+	struct z_erofs_vle_workgroup *grp;
+	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	unsigned pageofs = map->m_la & ~PAGE_MASK;
+	int err;
+
+	BUG_ON(l->curr != NULL);
+
+	/* must be Z_EROFS_WORK_TAIL or the next chained page */
+	BUG_ON(*chained_page == (uintptr_t)NULL);
+	BUG_ON(map->m_pa % EROFS_BLKSIZ);
+
+repeat:
+	grp = z_erofs_vle_workgroup_find(sb, index, &cached);
+	if (grp != NULL) {
+		BUG_ON(index != grp->index);
+
+		if (!cached) {
+			work = z_erofs_vle_work_uncached(grp, pageofs);
+			/* currently, work will not be NULL */
+
+			l->compressed_pages =
+				z_erofs_vle_work_uncached_mux(work);
+			l->compressed_deficit = clusterpages;
+		} else {
+			work = z_erofs_vle_work_cached(grp, pageofs);
+			/* currently, work will not be NULL */
+
+			/* TODO! get cached pages before submitting io */
+			l->compressed_pages = NULL;
+			l->compressed_deficit = 0;
+		}
+		BUG_ON(work->pageofs != pageofs);
+
+		mutex_lock(&work->lock);
+
+		if (grp->llen < map->m_llen)
+			grp->llen = map->m_llen;
+
+		l->owner = false;
+		/* let's claim these following types of work */
+		if (work->next == Z_EROFS_WORK_TAIL) {
+			/* type 2 */
+			work->next = *chained_page;
+			*chained_page = Z_EROFS_WORK_TAIL;
+			l->owner = true;
+		} else if (work->next == (uintptr_t)NULL) {
+			/* type 1 */
+			work->next = *chained_page;
+			*chained_page = (uintptr_t)work | cached;
+			l->owner = true;
+		}
+		goto got_it;
+	}
+
+	/* no available workgroup, let's allocate one */
+retry:
+	grp = kmem_cache_zalloc(z_erofs_workgroup_cachep,
+		GFP_NOFS | __GFP_NOFAIL);
+
+	/* it is not allowed to fail (-ENOMEM / -EIO, no...) */
+	if (unlikely(grp == NULL))
+		goto retry;
+
+	/* fill general fields */
+	grp->index = index;
+	grp->llen = map->m_llen;
+	if (map->m_flags & EROFS_MAP_ZIPPED)
+		grp->flags |= Z_EROFS_WORK_FORMAT_LZ4;
+
+	/* currently, we implement uncached work at first */
+	cached = false;
+	work = z_erofs_vle_work_uncached(grp, 0);
+	work->pageofs = pageofs;
+	atomic_set(&work->refcount, 1);
+	l->compressed_pages = z_erofs_vle_work_uncached_mux(work);
+	l->compressed_deficit = clusterpages;
+
+	mutex_init(&work->lock);
+	/* type 1 */
+	WRITE_ONCE(work->next, *chained_page);
+
+	err = z_erofs_vle_workgroup_register(sb, grp, cached);
+	if (err) {
+		kmem_cache_free(z_erofs_workgroup_cachep, grp);
+		goto repeat;
+	}
+
+	*chained_page = (uintptr_t)work | cached;
+	l->owner = true;
+	mutex_lock(&work->lock);
+got_it:
+	z_erofs_pagevec_collector_init(&l->vector, work->pagevec, work->vcnt);
+	l->curr = work;
+	return 0;
+}
+
+static void z_erofs_rcu_callback(struct rcu_head *head)
+{
+	struct z_erofs_vle_work *work =	container_of(head,
+		struct z_erofs_vle_work, rcu);
+	struct z_erofs_vle_workgroup *grp = z_erofs_vle_work_workgroup(work);
+
+	kmem_cache_free(z_erofs_workgroup_cachep, grp);
+}
+
+static void z_erofs_vle_workgroup_put(struct z_erofs_vle_workgroup *g)
+{
+	struct z_erofs_vle_work *work = &g->u.work;
+
+	if (!atomic_dec_return(&work->refcount))
+		call_rcu(&work->rcu, z_erofs_rcu_callback);
+}
+
+static inline void
+z_erofs_vle_work_iter_end(struct z_erofs_vle_work_pageldr *l)
+{
+	if (l->curr == NULL)
+		return;
+
+	z_erofs_pagevec_collector_exit(&l->vector, false);
+	mutex_unlock(&l->curr->lock);
+	l->curr = NULL;
+}
+
+static int z_erofs_do_read_page(struct page *page,
+				struct z_erofs_vle_work_pageldr *l,
+				struct erofs_map_blocks_iter *m,
+				uintptr_t *chained_page)
+{
+	struct inode *const inode = page->mapping->host;
+	struct super_block *const sb = inode->i_sb;
+	const loff_t offset = page_offset(page);
+	bool owned = true;
+	struct z_erofs_vle_work *work = l->curr;
+	enum z_erofs_vle_page_type page_type;
+	unsigned cur, end, spiltted, index;
+	int err;
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
+	z_erofs_vle_work_iter_end(l);
+
+	m->map.m_la = offset + cur;
+	m->map.m_llen = 0;
+	err = erofs_map_blocks_iter(inode, &m->map, &m->mpage, 0);
+	if (unlikely(err))
+		goto err_out;
+
+	/* deal with hole (FIXME! broken now) */
+	if (unlikely(!(m->map.m_flags & EROFS_MAP_MAPPED)))
+		goto hitted;
+
+	DBG_BUGON(m->map.m_plen != 1 << EROFS_SB(sb)->clusterbits);
+	BUG_ON(m->map.m_pa % EROFS_BLKSIZ);
+
+	err = z_erofs_vle_work_iter_begin(l, sb, &m->map, chained_page);
+	if (unlikely(err))
+		goto err_out;
+
+	owned &= l->owner;
+	work = l->curr;
+hitted:
+	cur = end - min_t(unsigned, offset + end - m->map.m_la, end);
+	if (unlikely(!(m->map.m_flags & EROFS_MAP_MAPPED))) {
+		zero_user_segment(page, cur, end);
+		goto next_part;
+	}
+
+	/* let's derive page type */
+	page_type = cur ? Z_EROFS_VLE_PAGE_TYPE_HEAD :
+		(!spiltted ? Z_EROFS_VLE_PAGE_TYPE_EXCLUSIVE :
+			(owned ? Z_EROFS_VLE_PAGE_TYPE_EXCLUSIVE :
+				Z_EROFS_VLE_PAGE_TYPE_TAIL_SHARED));
+
+retry:
+	err = z_erofs_vle_work_add_page(l, page, page_type);
+	/* should allocate an additional page */
+	if (err == -EAGAIN) {
+		struct page *newpage;
+
+		newpage = alloc_pages(GFP_KERNEL | __GFP_NOFAIL, 0);
+		newpage->mapping = NULL;
+		err = z_erofs_vle_work_add_page(l, newpage, page_type);
+		if (!err)
+			goto retry;
+	}
+
+	if (unlikely(err))
+		goto err_out;
+
+	index = page->index - m->map.m_la / PAGE_SIZE;
+
+	/* FIXME! avoid the last relundant fixup & endio */
+	z_erofs_onlinepage_fixup(page, index, true);
+	++spiltted;
+
+	/* also update nr_pages and increase queued_pages */
+	work->nr_pages = max_t(pgoff_t, work->nr_pages, index + 1);
+next_part:
+	/* can be used for verification */
+	m->map.m_llen = offset + cur - m->map.m_la;
+
+	if ((end = cur) > 0)
+		goto repeat;
+
+	/* FIXME! avoid the last relundant fixup & endio */
+	z_erofs_onlinepage_endio(page);
+
+	debugln("%s, finish page: %pK spiltted: %u map->m_llen %llu",
+		__func__, page, spiltted, m->map.m_llen);
+	return 0;
+
+err_out:
+	/* TODO: the missing error handing cases */
+	return err;
+}
+
+static void z_erofs_vle_unzip_kickoff(void *io, int bios)
+{
+	union {
+		struct z_erofs_vle_unzip_io *ptr;
+		unsigned v;
+	} u = { .ptr = io };
+
+	bool async = u.v & 1;
+	u.v &= ~1UL;
+
+	if (!atomic_add_return(bios, &u.ptr->pending_bios)) {
+		if (async)
+			queue_work(z_erofs_workqueue, &u.ptr->u.work);
+		else
+			wake_up(&u.ptr->u.wait);
+	}
+}
+
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 3, 0))
+static inline void z_erofs_vle_read_endio(struct bio *bio, int err)
+#else
+static inline void z_erofs_vle_read_endio(struct bio *bio)
+#endif
+{
+	unsigned i;
+	struct bio_vec *bvec;
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 13, 0))
+	const int err = bio->bi_status;
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 3, 0))
+	const int err = bio->bi_error;
+#endif
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
+
+		DBG_BUGON(PageUptodate(page));
+		if (unlikely(err))
+			SetPageError(page);
+		else if (0)
+			SetPageUptodate(page);
+
+		if (0)
+			unlock_page(page);
+	}
+	z_erofs_vle_unzip_kickoff(bio->bi_private, -1);
+	bio_put(bio);
+
+}
+
+static struct page *z_pagemap_global[Z_EROFS_VLE_VMAP_GLOBAL_PAGES];
+static DEFINE_MUTEX(z_pagemap_global_lock);
+
+static int z_erofs_vle_unzip(struct super_block *sb,
+	struct z_erofs_vle_work *work,
+	bool cached, struct list_head *page_pool)
+{
+	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	struct z_erofs_pagevec_collector ctor;
+	unsigned nr_pages;
+	struct page *pages_onstack[Z_EROFS_VLE_VMAP_ONSTACK_PAGES];
+	struct page **pages, **compressed_pages, *page;
+	unsigned i, llen;
+
+	enum z_erofs_vle_page_type page_type;
+	bool overlapped;
+	struct z_erofs_vle_workgroup *grp;
+	void *vout;
+	int err;
+
+	BUG_ON(!READ_ONCE(work->nr_pages));
+	might_sleep();
+
+	mutex_lock(&work->lock);
+	nr_pages = work->nr_pages;
+
+	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES))
+		pages = pages_onstack;
+	else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
+		mutex_trylock(&z_pagemap_global_lock))
+use_global_pagemap:
+		pages = z_pagemap_global;
+	else {
+		pages = kvmalloc(nr_pages, GFP_KERNEL | __GFP_NOFAIL);
+
+		/* fallback to global pagemap for the lowmem scenario */
+		if (unlikely(pages == NULL)) {
+			mutex_lock(&z_pagemap_global_lock);
+			goto use_global_pagemap;
+		}
+	}
+
+	for(i = 0; i < nr_pages; ++i)
+		pages[i] = NULL;
+
+	z_erofs_pagevec_collector_init(&ctor, work->pagevec, 0);
+
+	for(i = 0; i < work->vcnt; ++i) {
+		unsigned pagenr;
+
+		page = z_erofs_pagevec_collector_dequeue(&ctor, &page_type);
+		BUG_ON(!page);
+
+		if (page->mapping == NULL) {
+			list_add(&page->lru, page_pool);
+			continue;
+		}
+
+		if (page_type == Z_EROFS_VLE_PAGE_TYPE_HEAD)
+			pagenr = 0;
+		else
+			pagenr = z_erofs_onlinepage_index(page);
+
+		BUG_ON(pagenr >= nr_pages);
+
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+		BUG_ON(pages[pagenr] != NULL);
+#endif
+		pages[pagenr] = page;
+	}
+
+	z_erofs_pagevec_collector_exit(&ctor, true);
+
+	overlapped = false;
+	if (cached) {
+		grp = z_erofs_vle_work_workgroup(work);
+		compressed_pages = z_erofs_vle_cached_managed(grp);
+	} else {
+		grp = z_erofs_vle_work_workgroup(work);
+		compressed_pages = z_erofs_vle_work_uncached_mux(work);
+
+		for(i = 0; i < clusterpages; ++i) {
+			unsigned pagenr;
+
+			BUG_ON(compressed_pages[i] == NULL);
+			page = compressed_pages[i];
+
+			if (page->mapping == NULL)
+				continue;
+
+			pagenr = z_erofs_onlinepage_index(page);
+
+			BUG_ON(pagenr >= nr_pages);
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+			BUG_ON(pages[pagenr] != NULL);
+#endif
+			pages[pagenr] = page;
+
+			overlapped = true;
+		}
+	}
+
+	llen = (nr_pages << PAGE_SHIFT) - work->pageofs;
+
+	if (z_erofs_vle_workgroup_fmt(grp) == Z_EROFS_WORK_FORMAT_PLAIN) {
+		BUG_ON(grp->llen != llen);
+
+		err = z_erofs_vle_plain_copy(compressed_pages, clusterpages,
+			pages, nr_pages, work->pageofs);
+		goto out;
+	}
+
+	if (llen > grp->llen)
+		llen = grp->llen;
+
+	err = z_erofs_vle_unzip_fast_percpu(compressed_pages,
+		clusterpages, pages, llen, work->pageofs);
+	if (err != -ENOTSUPP)
+		goto out;
+
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	if (work->vcnt == nr_pages)
+		goto skip_allocpage;
+#endif
+
+	for(i = 0; i < nr_pages; ++i) {
+		if (pages[i] != NULL)
+			continue;
+		pages[i] = erofs_allocpage(page_pool, GFP_KERNEL);
+	}
+
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+skip_allocpage:
+#endif
+	vout = erofs_vmap(pages, nr_pages);
+
+	err = z_erofs_vle_unzip_vmap(compressed_pages,
+		clusterpages, vout, llen, work->pageofs, overlapped);
+
+	erofs_vunmap(vout, nr_pages);
+
+out:
+	for(i = 0; i < nr_pages; ++i) {
+		page = pages[i];
+
+		/* recycle all individual pages */
+		if (page->mapping == NULL) {
+			list_add(&page->lru, page_pool);
+			continue;
+		}
+
+		if (unlikely(err < 0))
+			SetPageError(page);
+
+		z_erofs_onlinepage_endio(page);
+	}
+
+	for(i = 0; i < clusterpages; ++i) {
+		page = compressed_pages[i];
+
+		/* recycle all individual pages */
+		if (page->mapping == NULL)
+			list_add(&page->lru, page_pool);
+
+		if (!cached)
+			WRITE_ONCE(compressed_pages[i], NULL);
+	}
+
+	if (pages == z_pagemap_global)
+		mutex_unlock(&z_pagemap_global_lock);
+	else if (unlikely(pages != pages_onstack))
+		kvfree(pages);
+
+	work->nr_pages = 0;
+	work->vcnt = 0;
+	WRITE_ONCE(work->next, NULL);
+
+	mutex_unlock(&work->lock);
+	return err;
+}
+
+#define for_each_chained_work_safe(chained, n, work, cached) \
+for(; (cached) = (chained) & 1, \
+	(work) = (struct z_erofs_vle_work *)((chained) & ~1UL), \
+	(chained) != Z_EROFS_WORK_TAIL && ((n) = (work)->next, 1); \
+	(chained) = (n))
+
+static void z_erofs_vle_unzip_all(struct super_block *sb,
+				  struct z_erofs_vle_unzip_io *io,
+				  struct list_head *page_pool)
+{
+	struct z_erofs_vle_work *work;
+	bool cached;
+	uintptr_t chained_page = io->head, tmp;
+
+	for_each_chained_work_safe(chained_page, tmp, work, cached) {
+		struct z_erofs_vle_workgroup *g =
+			z_erofs_vle_work_workgroup(work);
+
+		z_erofs_vle_unzip(sb, work, cached, page_pool);
+		z_erofs_vle_workgroup_put(g);
+	}
+}
+
+static void z_erofs_vle_unzip_wq(struct work_struct *work)
+{
+	struct z_erofs_vle_unzip_io_sb *iosb = container_of(work,
+		struct z_erofs_vle_unzip_io_sb, io.u.work);
+	LIST_HEAD(page_pool);
+
+	z_erofs_vle_unzip_all(iosb->sb, &iosb->io, &page_pool);
+
+	put_pages_list(&page_pool);
+	kvfree(iosb);
+}
+
+static void z_erofs_vle_submit_all(struct super_block *sb,
+				   uintptr_t chained_head,
+				   struct list_head *page_pool,
+				   struct z_erofs_vle_unzip_io *io)
+{
+	struct bio *bio = NULL;
+	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	pgoff_t last_page;
+	uintptr_t tmp;
+	struct z_erofs_vle_work *work;
+	bool sync, cached;
+	unsigned bios_submitted;
+	union {
+		struct z_erofs_vle_unzip_io *ptr;
+		unsigned v;
+	} u;
+
+	if (unlikely(chained_head == Z_EROFS_WORK_TAIL))
+		return;
+
+	sync = true;
+	u.ptr = io;
+
+	/* allocate io descriptor in async mode */
+	if (io != NULL) {
+		init_waitqueue_head(&io->u.wait);
+		atomic_set(&io->pending_bios, 0);
+	} else {
+		struct z_erofs_vle_unzip_io_sb *iosb;
+
+		sync = false;
+
+		iosb = kvzalloc(sizeof(struct z_erofs_vle_unzip_io_sb),
+			GFP_KERNEL | __GFP_NOFAIL);
+		BUG_ON(iosb == NULL);
+
+		iosb->sb = sb;
+		io = &iosb->io;
+		INIT_WORK(&io->u.work, z_erofs_vle_unzip_wq);
+		u.v |= 1;
+	}
+	io->head = chained_head;
+
+	bios_submitted = 0;
+	for_each_chained_work_safe(chained_head, tmp, work, cached) {
+		struct z_erofs_vle_workgroup *grp =
+			z_erofs_vle_work_workgroup(work);
+		struct page **compressed_pages;
+		pgoff_t current_page;
+		unsigned i;
+		int err;
+
+		BUG_ON(cached);
+		compressed_pages = z_erofs_vle_work_uncached_mux(work);
+
+		/* fulfill all compressed pages */
+		for(i = 0; i < clusterpages; ++i) {
+			struct page *page;
+
+			if (READ_ONCE(compressed_pages[i]) != NULL)
+				continue;
+
+			page = erofs_allocpage(page_pool, GFP_KERNEL);
+
+			page->mapping = NULL;
+			if (cmpxchg(compressed_pages + i, NULL, page) != NULL)
+				list_add(&page->lru, page_pool);
+		}
+
+		current_page = grp->index;
+		i = 0;
+
+		if (bio != NULL && last_page + 1 != current_page) {
+submit_bio_retry:
+			__submit_bio(bio, REQ_OP_READ, 0);
+			bio = NULL;
+		}
+repeat:
+		if (bio == NULL) {
+			bio = prepare_bio(sb, current_page,
+				BIO_MAX_PAGES, z_erofs_vle_read_endio);
+			bio->bi_private = u.ptr;
+
+			++bios_submitted;
+		}
+
+		err = bio_add_page(bio, compressed_pages[i], PAGE_SIZE, 0);
+		if (err < PAGE_SIZE)
+			goto submit_bio_retry;
+
+		last_page = current_page;
+		++current_page;
+		if (++i < clusterpages)
+			goto repeat;
+	}
+
+	if (bio != NULL)
+		__submit_bio(bio, REQ_OP_READ, 0);
+
+	z_erofs_vle_unzip_kickoff(u.ptr, bios_submitted);
+}
+
+static int z_erofs_vle_normalaccess_readpage(struct file *file,
+                                             struct page *page)
+{
+	struct erofs_map_blocks_iter m_iter = {
+		.map = { .m_llen = 0, .m_plen = 0 },
+		.mpage = NULL
+	};
+	struct z_erofs_vle_work_pageldr l = { .curr = NULL };
+	uintptr_t chained_page = Z_EROFS_WORK_TAIL;
+	struct z_erofs_vle_unzip_io io;
+	LIST_HEAD(pagepool);
+
+	int err = z_erofs_do_read_page(page, &l, &m_iter, &chained_page);
+
+	z_erofs_vle_work_iter_end(&l);
+
+	if (!err) {
+		struct super_block *sb = page->mapping->host->i_sb;
+
+		z_erofs_vle_submit_all(sb, chained_page, &pagepool, &io);
+
+		/* wait until all bios are completed */
+		wait_event(io.u.wait, !atomic_read(&io.pending_bios));
+
+		/* synchronous decompression */
+		z_erofs_vle_unzip_all(sb, &io, &pagepool);
+	} else {
+		errln("%s, failed to read, err [%d]", __func__, err);
+	}
+
+	if (m_iter.mpage != NULL)
+		put_page(m_iter.mpage);
+
+	/* clean up the remaining free pages */
+	put_pages_list(&pagepool);
+	return 0;
+}
+
+static inline int __z_erofs_vle_normalaccess_readpages(
+	struct file *filp,
+	struct address_space *mapping,
+	struct list_head *pages, unsigned nr_pages, bool sync)
+{
+	struct erofs_map_blocks_iter m_iter = {
+		.map = { .m_llen = 0, .m_plen = 0 },
+		.mpage = NULL
+	};
+	struct z_erofs_vle_work_pageldr l = { .curr = NULL };
+	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
+	LIST_HEAD(pagepool);
+	struct page *head = NULL;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+	uintptr_t chained_page = Z_EROFS_WORK_TAIL;
+
+	for(; nr_pages; --nr_pages) {
+		struct page *page = lru_to_page(pages);
+
+		prefetchw(&page->flags);
+		list_del(&page->lru);
+
+		if (add_to_page_cache_lru(page, mapping, page->index, gfp)) {
+			list_add(&page->lru, &pagepool);
+			continue;
+		}
+
+		BUG_ON(PagePrivate(page));
+		set_page_private(page, (unsigned long)head);
+		head = page;
+	}
+
+	while(head != NULL) {
+		struct page *page = head;
+		int err;
+
+		/* traversal in reverse order */
+		head = (void *)page_private(page);
+		err = z_erofs_do_read_page(page, &l, &m_iter, &chained_page);
+		if (err) {
+			struct erofs_vnode *vi = EROFS_V(inode);
+
+			errln("%s, readahead error at page %lu of nid %llu",
+				__func__, page->index, vi->nid);
+		}
+		put_page(page);
+	}
+	z_erofs_vle_work_iter_end(&l);
+
+	if (!sync)
+		z_erofs_vle_submit_all(sb, chained_page, &pagepool, NULL);
+	else {
+		struct z_erofs_vle_unzip_io io;
+
+		z_erofs_vle_submit_all(sb, chained_page, &pagepool, &io);
+
+		/* wait until all bios are completed */
+		wait_event(io.u.wait, !atomic_read(&io.pending_bios));
+
+		/* let's synchronous decompression */
+		z_erofs_vle_unzip_all(sb, &io, &pagepool);
+	}
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
+/* for VLE compressed files */
+const struct address_space_operations z_erofs_vle_normal_access_aops = {
+	.readpage = z_erofs_vle_normalaccess_readpage,
+	.readpages = z_erofs_vle_normalaccess_readpages,
+};
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
+	debugln("%s, vle=%pK, advise=%x (type %u), clusterofs=%x blkaddr=%x",
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
diff --git a/fs/erofs/unzip_vle.h b/fs/erofs/unzip_vle.h
index cf7ef9f..ca90fd8 100644
--- a/fs/erofs/unzip_vle.h
+++ b/fs/erofs/unzip_vle.h
@@ -10,70 +10,210 @@
  * License.  See the file COPYING in the main directory of the Linux
  * distribution for more details.
  */
+#ifndef __EROFS_FS_UNZIP_VLE_H
+#define __EROFS_FS_UNZIP_VLE_H
 
-#ifndef __EROFS_UNZIP_H
-#error "Please don't include unzip_vle.h directly, use unzip.h instead."
-#endif
+#include "internal.h"
+
+#define Z_EROFS_WORK_TAIL	0x5F0ECAFE
+
+/*
+ * Structure fields follow one of the following exclusion rules.
+ *
+ * I: Modifiable by initialization/destruction paths and read-only
+ *    for everyone else.
+ *
+ */
+
+#define Z_EROFS_VLE_INLINE_PAGEVECS  3
+
+struct z_erofs_vle_work {
+	/* struct z_erofs_vle_work *left, *right; */
+	struct mutex lock;
+
+	atomic_t refcount;
+	/* I: decompression offset in page */
+	unsigned short pageofs;
+	unsigned short nr_pages;
+
+	/* L: queued pages in pagevec[] */
+	unsigned vcnt;
+	/* L: the next owned work */
+	uintptr_t next;
+
+	union {
+		/* L: pagevec */
+		uintptr_t pagevec[Z_EROFS_VLE_INLINE_PAGEVECS];
+		struct rcu_head rcu;
+	};
+};
+
+#define Z_EROFS_WORK_FORMAT_PLAIN       0
+#define Z_EROFS_WORK_FORMAT_LZ4         1
+#define Z_EROFS_WORK_FORMAT_MASK        1
 
-#define __vle_cluster_advise(x, bit, bits) \
-	((le16_to_cpu(x) >> (bit)) & ((1 << (bits)) - 1))
+struct z_erofs_vle_work_uncached {
+	struct z_erofs_vle_work work;
 
-#define __vle_cluster_type(advise) __vle_cluster_advise(advise, \
-	EROFS_VLE_DI_CLUSTER_TYPE_BIT, EROFS_VLE_DI_CLUSTER_TYPE_BITS)
+	/* multi-usage (both used for decompressed / compressed pages) */
+	struct page *mux[Z_EROFS_CLUSTER_MAX_PAGES];
+};
+
+struct z_erofs_vle_cached_header {
+	struct z_erofs_vle_work work;
 
-enum {
-	EROFS_VLE_CLUSTER_TYPE_PLAIN,
-	EROFS_VLE_CLUSTER_TYPE_HEAD,
-	EROFS_VLE_CLUSTER_TYPE_NONHEAD,
-	EROFS_VLE_CLUSTER_TYPE_RESERVED,
-	EROFS_VLE_CLUSTER_TYPE_MAX
+	struct page *managed[Z_EROFS_CLUSTER_MAX_PAGES];
 };
 
-#define vle_cluster_type(di)	\
-	__vle_cluster_type((di)->di_advise)
+struct z_erofs_vle_workgroup {
+	union {
+		struct z_erofs_vle_work work;
+		struct z_erofs_vle_work_uncached uncached;
+		struct z_erofs_vle_cached_header cached;
+	} u;
+
+	unsigned int llen, flags;
+	erofs_blk_t index;
+};
 
-static inline unsigned
-vle_compressed_index_clusterofs(unsigned clustersize,
-	struct erofs_decompressed_index_vle *di)
+#define z_erofs_vle_workgroup_fmt(grp)	\
+	((grp)->flags & Z_EROFS_WORK_FORMAT_MASK)
+
+#define z_erofs_vle_work_uncached(grp, pageofs) (&(grp)->u.uncached.work)
+#define z_erofs_vle_work_uncached_mux(wrk)      \
+	(container_of(wrk, struct z_erofs_vle_work_uncached, work)->mux)
+#define z_erofs_vle_work_cached(grp, pageofs)   (&(grp)->u.cached.work)
+#define z_erofs_vle_cached_managed(grp)         ((grp)->u.cached.managed)
+#define z_erofs_vle_work_workgroup(wrk) \
+	container_of(wrk, struct z_erofs_vle_workgroup, u.work)
+
+static inline int z_erofs_vle_workgroup_get(struct z_erofs_vle_workgroup *g)
 {
-	debugln("%s, vle=%p, advise=%x (type %u), clusterofs=%x blkaddr=%x",
-		__func__, di, di->di_advise, vle_cluster_type(di),
-		di->di_clusterofs, di->di_u.blkaddr);
-
-	switch(vle_cluster_type(di)) {
-	case EROFS_VLE_CLUSTER_TYPE_NONHEAD:
-		break;
-	case EROFS_VLE_CLUSTER_TYPE_PLAIN:
-	case EROFS_VLE_CLUSTER_TYPE_HEAD:
-		return di->di_clusterofs;
-	default:
-		BUG_ON(1);
-	}
-	return clustersize;
+	int o;
+
+repeat:
+	o = atomic_read(&g->u.work.refcount);
+	if (unlikely(o <= 0))
+		return -1;
+	if (unlikely(atomic_cmpxchg(&g->u.work.refcount, o, o + 1) != o))
+		goto repeat;
+	return 0;
+}
+
+#define __z_erofs_vle_workgroup_get(g)  atomic_inc(&(g)->u.work.refcount)
+
+#define Z_EROFS_WORKGROUP_SIZE       sizeof(struct z_erofs_vle_workgroup)
+
+struct z_erofs_vle_unzip_io {
+	atomic_t pending_bios;
+	uintptr_t head;
+	union {
+		wait_queue_head_t wait;
+		struct work_struct work;
+	} u;
+};
+
+struct z_erofs_vle_unzip_io_sb {
+	struct z_erofs_vle_unzip_io io;
+	struct super_block *sb;
+};
+
+#define Z_EROFS_ONLINEPAGE_COUNT_BITS   2
+#define Z_EROFS_ONLINEPAGE_COUNT_MASK   ((1 << Z_EROFS_ONLINEPAGE_COUNT_BITS) - 1)
+#define Z_EROFS_ONLINEPAGE_INDEX_SHIFT  (Z_EROFS_ONLINEPAGE_COUNT_BITS)
+
+/*
+ * waiters (aka. ongoing_packs): # to unlock the page
+ * sub-index: 0 - for partial page, >= 1 full page sub-index
+ */
+typedef atomic_t z_erofs_onlinepage_t;
+
+/* type punning */
+union z_erofs_onlinepage_converter {
+	z_erofs_onlinepage_t *o;
+	unsigned long *v;
+};
+
+static inline unsigned z_erofs_onlinepage_index(struct page *page)
+{
+	union z_erofs_onlinepage_converter u;
+
+	BUG_ON(!PagePrivate(page));
+	u.v = &page_private(page);
+
+	return atomic_read(u.o) >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
+}
+
+static inline void z_erofs_onlinepage_init(struct page *page)
+{
+	union {
+		z_erofs_onlinepage_t o;
+		unsigned long v;
+	/* keep from being unlocked in advance */
+	} u = { .o = ATOMIC_INIT(1) };
+
+	set_page_private(page, u.v);
+	smp_wmb();
+	SetPagePrivate(page);
 }
 
-static inline erofs_blk_t
-vle_extent_blkaddr(struct inode *inode, pgoff_t index)
+static inline void z_erofs_onlinepage_fixup(struct page *page,
+	uintptr_t index, bool down)
 {
-	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
-	struct erofs_vnode *vi = EROFS_V(inode);
+	unsigned long *p, o, v, id;
+repeat:
+	p = &page_private(page);
+	o = READ_ONCE(*p);
 
-	unsigned ofs = EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
-		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
-		index * sizeof(struct erofs_decompressed_index_vle);
+	id = o >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
+	if (id) {
+		if (!index)
+			return;
+
+		BUG_ON(id != index);
+	}
 
-	return erofs_blknr(iloc(sbi, vi->nid) + ofs);
+	v = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
+		((o & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned)down);
+	if (cmpxchg(p, o, v) != o)
+		goto repeat;
 }
 
-static inline unsigned int
-vle_extent_blkoff(struct inode *inode, pgoff_t index)
+static inline void z_erofs_onlinepage_endio(struct page *page)
 {
-	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
-	struct erofs_vnode *vi = EROFS_V(inode);
+	union z_erofs_onlinepage_converter u;
+	unsigned v;
 
-	unsigned ofs = EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
-		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
-		index * sizeof(struct erofs_decompressed_index_vle);
+	BUG_ON(!PagePrivate(page));
+	u.v = &page_private(page);
 
-	return erofs_blkoff(iloc(sbi, vi->nid) + ofs);
+	v = atomic_dec_return(u.o);
+	if (!(v & Z_EROFS_ONLINEPAGE_COUNT_MASK)) {
+		ClearPagePrivate(page);
+		if (!PageError(page))
+			SetPageUptodate(page);
+		unlock_page(page);
+	}
+
+	debugln("%s, page %p value %x", __func__, page, atomic_read(u.o));
 }
+
+#define Z_EROFS_VLE_VMAP_ONSTACK_PAGES	\
+	(min(THREAD_SIZE >> 3, 96 * sizeof(struct page *)) / sizeof(struct page *))
+#define Z_EROFS_VLE_VMAP_GLOBAL_PAGES	2048
+
+/* unzip_vle_lz4.c */
+extern int z_erofs_vle_plain_copy(struct page **compressed_pages,
+	unsigned clusterpages, struct page **pages,
+	unsigned nr_pages, unsigned short pageofs);
+
+extern int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
+	unsigned clusterpages, struct page **pages,
+	unsigned llen, unsigned short pageofs);
+
+extern int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
+	unsigned clusterpages, void *vaddr, unsigned llen,
+	unsigned short pageofs, bool overlapped);
+
+#endif
+
diff --git a/fs/erofs/unzip_vle_lz4.c b/fs/erofs/unzip_vle_lz4.c
new file mode 100644
index 0000000..bb5d830
--- /dev/null
+++ b/fs/erofs/unzip_vle_lz4.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/unzip_vle_lz4.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include "unzip_vle.h"
+
+#if Z_EROFS_CLUSTER_MAX_PAGES > Z_EROFS_VLE_INLINE_PAGEVECS
+#define EROFS_PERCPU_NR_PAGES   Z_EROFS_CLUSTER_MAX_PAGES
+#else
+#define EROFS_PERCPU_NR_PAGES   Z_EROFS_VLE_INLINE_PAGEVECS
+#endif
+
+static struct {
+	char data[PAGE_SIZE * EROFS_PERCPU_NR_PAGES];
+} erofs_pcpubuf[NR_CPUS];
+
+int z_erofs_vle_plain_copy(struct page **compressed_pages,
+			   unsigned clusterpages,
+			   struct page **pages,
+			   unsigned nr_pages,
+			   unsigned short pageofs)
+{
+	unsigned i, j;
+	void *src = NULL;
+	const unsigned righthalf = PAGE_SIZE - pageofs;
+	char *percpu_data;
+	bool backedup[Z_EROFS_CLUSTER_MAX_PAGES] = { 0 };
+
+	preempt_disable();
+	percpu_data = erofs_pcpubuf[smp_processor_id()].data;
+
+	for(i = 0; i < nr_pages; ++i) {
+		struct page *page = pages[i];
+		void *dst;
+
+		if (page == NULL) {
+			if (src != NULL && !backedup[i-1])
+				kunmap_atomic(src);
+
+			src = NULL;
+			continue;
+		}
+
+		dst = kmap_atomic(page);
+
+		for(j = 0; j < clusterpages; ++j) {
+			if (compressed_pages[j] != page)
+				continue;
+
+			BUG_ON(backedup[j]);
+			memcpy(percpu_data + j * PAGE_SIZE, dst, PAGE_SIZE);
+			backedup[j] = true;
+			break;
+		}
+
+		if (src == NULL && i) {
+			if (backedup[i-1])
+				src = percpu_data + i-1;
+			else
+				src = kmap_atomic(compressed_pages[i-1]);
+		}
+
+		memcpy(dst, src + righthalf, pageofs);
+
+		if (!backedup[i-1])
+			kunmap_atomic(src);
+
+		if (i >= clusterpages) {
+			kunmap_atomic(dst);
+			break;
+		}
+
+		if (backedup[i])
+			src = percpu_data + i;
+		else
+			src = kmap_atomic(compressed_pages[i]);
+		memcpy(dst + pageofs, src, righthalf);
+		kunmap_atomic(dst);
+	}
+	return 0;
+}
+
+int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
+				  unsigned clusterpages,
+				  struct page **pages,
+				  unsigned llen,
+				  unsigned short pageofs)
+{
+	return -ENOTSUPP;
+}
+
+extern int erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
+
+int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
+			   unsigned clusterpages,
+			   void *vout,
+			   unsigned llen,
+			   unsigned short pageofs,
+			   bool overlapped)
+{
+	void *vin;
+	unsigned i;
+	int ret;
+
+	if (overlapped) {
+		preempt_disable();
+		vin = erofs_pcpubuf[smp_processor_id()].data;
+
+		for(i = 0; i < clusterpages; ++i) {
+			void *t = kmap_atomic(compressed_pages[i]);
+
+			memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
+			kunmap_atomic(t);
+		}
+	} else if (clusterpages == 1)
+		vin = kmap_atomic(compressed_pages[0]);
+	else {
+		vin = erofs_vmap(compressed_pages, clusterpages);
+	}
+
+	ret = erofs_unzip_lz4(vin, vout + pageofs,
+		clusterpages * PAGE_SIZE, llen);
+	if (ret > 0)
+		ret = 0;
+
+	if (!overlapped) {
+		if (clusterpages == 1)
+			kunmap_atomic(vin);
+		else {
+			erofs_vunmap(vin, clusterpages);
+		}
+	} else
+		preempt_enable();
+
+	return ret;
+}
+
diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
new file mode 100644
index 0000000..dce5177
--- /dev/null
+++ b/fs/erofs/utils.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/utils.c
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
+#include "internal.h"
+
+struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
+{
+	struct page *page;
+
+	if (!list_empty(pool)) {
+		page = lru_to_page(pool);
+		list_del(&page->lru);
+	} else {
+		page = alloc_pages(gfp | __GFP_NOFAIL, 0);
+
+		BUG_ON(page == NULL);
+		BUG_ON(page->mapping != NULL);
+	}
+	return page;
+}
+
-- 
1.9.1
