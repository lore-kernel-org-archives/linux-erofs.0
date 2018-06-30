From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 30 Jun 2018 17:18:27 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.2 2/2] erofs: introduce the new VLE
 unzip subsystem
In-Reply-To: <1530350307-76310-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530350307-76310-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530350307-76310-2-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

change log v0.2:
 - use the recent introduced tagptr_t type to manage tagged pointers.
 - bugfix

TODO:
 - spilt into more understandable patches
 - add missing functions and bugfix

The patchset is temporarily based on
[RFC PATCH RESEND 11/12] erofs: introduce a customized LZ4 decompression

STILL BUGGY, NOT FOR DAILY USE!

 fs/erofs/Kconfig         |   17 +
 fs/erofs/Makefile        |    6 +-
 fs/erofs/data.c          |   69 +--
 fs/erofs/inode.c         |    6 +-
 fs/erofs/internal.h      |   81 ++++
 fs/erofs/staging.h       |   42 ++
 fs/erofs/super.c         |   49 +-
 fs/erofs/unzip.c         | 1039 ++++++++++++++++++++++++++++++++++++++++
 fs/erofs/unzip_pagevec.h |  165 +++++++
 fs/erofs/unzip_vle.c     | 1170 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/unzip_vle.h     |  236 ++++++++++
 fs/erofs/unzip_vle_lz4.c |  145 ++++++
 fs/erofs/utils.c         |   31 ++
 13 files changed, 3015 insertions(+), 41 deletions(-)
 create mode 100644 fs/erofs/unzip.c
 create mode 100644 fs/erofs/unzip_pagevec.h
 create mode 100644 fs/erofs/unzip_vle.c
 create mode 100644 fs/erofs/unzip_vle.h
 create mode 100644 fs/erofs/unzip_vle_lz4.c
 create mode 100644 fs/erofs/utils.c

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
index 9d7f90a..6622e68 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -1,8 +1,8 @@
 EROFS_VERSION = "1.0"
 
-EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
+EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\" -DCONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT=1
 
 obj-$(CONFIG_EROFS_FS) += erofs.o
-erofs-objs := super.o inode.o data.o namei.o dir.o
+erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
-
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_vle_lz4.o unzip_lz4.o
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9b30095..4817e16 100644
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
@@ -391,3 +368,31 @@ static int erofs_raw_access_readpages(struct file *filp,
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
+const struct address_space_operations erofs_page_bundle_aops = {
+};
+
+#endif
+
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 7391ef6..12f2e1c 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -181,8 +181,12 @@ int fill_inode(struct inode *inode, int isdir)
 			goto out_unlock;
 		}
 
-		/* for compression or unknown data mapping mode */
+		/* for compression mapping mode */
+#ifdef CONFIG_EROFS_FS_ZIP
+		inode->i_mapping->a_ops = &z_erofs_vle_normal_access_aops;
+#else
 		err = -ENOTSUPP;
+#endif
 	}
 
 out_unlock:
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 1dd783c..1efaeac 100644
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
 
@@ -54,8 +57,28 @@ struct erofs_sb_info {
 	u32 xattr_blkaddr;
 #endif
 
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+	struct inode *ibundle;
+#endif
+
 	/* inode slot unit size in bit shift */
 	unsigned char islotbits;
+#ifdef CONFIG_EROFS_FS_ZIP
+
+#define Z_EROFS_CLUSTER_MAX_PAGES       (CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT)
+
+	/* cluster size in bit shift */
+	unsigned char clusterbits;
+
+	/* dedicated workspace for compression */
+	struct {
+		struct radix_tree_root tree;
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+		spinlock_t lock;
+#endif
+	} zwrksp;
+
+#endif
 
 	u32 build_time_nsec;
 	u64 build_time;
@@ -83,6 +106,16 @@ struct erofs_sb_info {
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
 
@@ -100,6 +133,10 @@ struct erofs_sb_info {
 
 #define ROOT_NID(sb)		((sb)->root_nid)
 
+#ifdef CONFIG_EROFS_FS_ZIP
+#define erofs_clusterpages(sbi)	((1 << (sbi)->clusterbits) / PAGE_SIZE)
+#endif
+
 typedef u64 erofs_off_t;
 
 /* data type for filesystem-wide blocks number */
@@ -181,6 +218,9 @@ static inline bool is_inode_layout_inline(struct inode *inode)
 extern const struct file_operations erofs_unaligned_compressed_fops;
 
 extern const struct address_space_operations erofs_raw_access_aops;
+#ifdef CONFIG_EROFS_FS_ZIP
+extern const struct address_space_operations z_erofs_vle_normal_access_aops;
+#endif
 
 /*
  * Logical to physical block mapping, used by erofs_map_blocks()
@@ -229,6 +269,35 @@ struct erofs_map_blocks {
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
@@ -248,6 +317,15 @@ static inline struct page *erofs_get_inline_page(struct inode *inode,
 		blkaddr, S_ISDIR(inode->i_mode));
 }
 
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+
+extern struct inode *erofs_init_page_bundle(struct super_block *);
+
+extern const struct address_space_operations erofs_page_bundle_aops;
+
+#endif
+
+
 /* inode.c */
 extern struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool dir);
@@ -316,5 +394,8 @@ static inline void erofs_vunmap(const void *mem, unsigned int count)
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
index b41613f..3de0631 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -111,6 +111,13 @@ static int superblock_read(struct super_block *sb)
 	sbi->xattr_blkaddr = le32_to_cpu(layout->xattr_blkaddr);
 #endif
 	sbi->islotbits = ffs(sizeof(struct erofs_inode_v1)) - 1;
+#ifdef CONFIG_EROFS_FS_ZIP
+	sbi->clusterbits = 12;
+
+	if (1 << (sbi->clusterbits - 12) > Z_EROFS_CLUSTER_MAX_PAGES)
+		errln("clusterbits %u is not supported on this kernel",
+			sbi->clusterbits);
+#endif
 
 	sbi->root_nid = le64_to_cpu(layout->root_nid);
 	sbi->inos = le64_to_cpu(layout->inos);
@@ -185,12 +192,23 @@ static int erofs_read_super(struct super_block *sb,
 
 	if (!silent)
 		infoln("root inode @ nid %llu", ROOT_NID(sbi));
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+	sbi->ibundle = erofs_init_page_bundle(sb);
+	if (sbi->ibundle == NULL) {
+		err = -ENOMEM;
+		goto err_sbi;
+	}
+#endif
+	INIT_RADIX_TREE(&sbi->zwrksp.tree, GFP_ATOMIC);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+	spin_lock_init(&sbi->zwrksp.lock);
+#endif
 
 	/* get the root inode */
 	inode = erofs_iget(sb, ROOT_NID(sbi), true);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
-		goto err_sbi;
+		goto err_ibundle;
 	}
 
 	if (!S_ISDIR(inode->i_mode)) {
@@ -231,6 +249,10 @@ static int erofs_read_super(struct super_block *sb,
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
@@ -252,7 +274,9 @@ static void erofs_put_super(struct super_block *sb)
 
 	infoln("unmounted for %s", sbi->dev_name);
 	__putname(sbi->dev_name);
-
+#ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
+	iput(sbi->ibundle);
+#endif
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 }
@@ -301,6 +325,11 @@ static void erofs_kill_sb(struct super_block *sb)
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
@@ -309,11 +338,18 @@ int __init erofs_module_init(void)
 
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
@@ -321,6 +357,9 @@ int __init erofs_module_init(void)
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
diff --git a/fs/erofs/unzip_pagevec.h b/fs/erofs/unzip_pagevec.h
new file mode 100644
index 0000000..9441750
--- /dev/null
+++ b/fs/erofs/unzip_pagevec.h
@@ -0,0 +1,165 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * linux/fs/erofs/unzip_pagevec.h
+ *
+ * Copyright (c) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#ifndef __EROFS_UNZIP_PAGEVEC_H
+#define __EROFS_UNZIP_PAGEVEC_H
+
+#include <linux/tagptr.h>
+
+/* page type in pagevec for unzip subsystem */
+enum z_erofs_page_type {
+	/* including Z_EROFS_VLE_PAGE_TAIL_EXCLUSIVE */
+	Z_EROFS_PAGE_TYPE_EXCLUSIVE,
+
+	Z_EROFS_VLE_PAGE_TYPE_TAIL_SHARED,
+
+	Z_EROFS_VLE_PAGE_TYPE_HEAD,
+	Z_EROFS_VLE_PAGE_TYPE_MAX
+};
+
+/* pagevec tagged pointer */
+typedef tagptr2_t	erofs_vtptr_t;
+
+/* pagevec collector */
+struct z_erofs_pagevec_ctor {
+	struct page *curr, *next;
+	erofs_vtptr_t *pages;
+
+	unsigned int nr, index;
+};
+
+static inline void z_erofs_pagevec_ctor_exit(struct z_erofs_pagevec_ctor *ctor,
+				             bool atomic)
+{
+	if (ctor->curr == NULL)
+		return;
+
+	if (atomic)
+		kunmap_atomic(ctor->pages);
+	else
+		kunmap(ctor->curr);
+}
+
+static inline struct page *
+z_erofs_pagevec_ctor_next_page(struct z_erofs_pagevec_ctor *ctor,
+			       unsigned nr)
+{
+	unsigned index;
+
+	/* keep away from occupied pages */
+	if (ctor->next != NULL)
+		return ctor->next;
+
+	for(index = 0; index < nr; ++index) {
+		const erofs_vtptr_t t = ctor->pages[index];
+		const unsigned tags = tagptr_unfold_tags(t);
+
+		if (tags == Z_EROFS_PAGE_TYPE_EXCLUSIVE)
+			return tagptr_unfold_ptr(t);
+	}
+
+	if (unlikely(nr >= ctor->nr))
+		BUG();
+
+	return NULL;
+}
+
+static inline void
+z_erofs_pagevec_ctor_pagedown(struct z_erofs_pagevec_ctor *ctor,
+			      bool atomic)
+{
+	struct page *next = z_erofs_pagevec_ctor_next_page(ctor, ctor->nr);
+
+	z_erofs_pagevec_ctor_exit(ctor, atomic);
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
+static inline void z_erofs_pagevec_ctor_init(struct z_erofs_pagevec_ctor *ctor,
+					     unsigned nr,
+					     erofs_vtptr_t *pages, unsigned i)
+{
+	ctor->nr = nr;
+	ctor->curr = ctor->next = NULL;
+	ctor->pages = pages;
+
+	if (i >= nr) {
+		i -= nr;
+		z_erofs_pagevec_ctor_pagedown(ctor, false);
+		while (i > ctor->nr) {
+			i -= ctor->nr;
+			z_erofs_pagevec_ctor_pagedown(ctor, false);
+		}
+	}
+
+	ctor->next = z_erofs_pagevec_ctor_next_page(ctor, i);
+	ctor->index = i;
+}
+
+static inline bool
+z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
+			     struct page *page,
+			     enum z_erofs_page_type type,
+			     bool *occupied)
+{
+	*occupied = false;
+	if (unlikely(ctor->next == NULL && type))
+		if (ctor->index + 1 == ctor->nr)
+			return false;
+
+	if (unlikely(ctor->index >= ctor->nr))
+		z_erofs_pagevec_ctor_pagedown(ctor, false);
+
+	/* should remind that collector->next never equal to 1, 2 */
+	if (type == (uintptr_t)ctor->next) {
+		ctor->next = page;
+		*occupied = true;
+	}
+
+	ctor->pages[ctor->index++] =
+		tagptr_fold(erofs_vtptr_t, page, type);
+	return true;
+}
+
+static inline struct page *
+z_erofs_pagevec_ctor_dequeue(struct z_erofs_pagevec_ctor *ctor,
+			     enum z_erofs_page_type *type)
+{
+	erofs_vtptr_t t;
+
+	if (unlikely(ctor->index >= ctor->nr)) {
+		BUG_ON(ctor->next == NULL);
+		z_erofs_pagevec_ctor_pagedown(ctor, true);
+	}
+
+	t = ctor->pages[ctor->index];
+
+	*type = tagptr_unfold_tags(t);
+
+	/* should remind that collector->next never equal to 1, 2 */
+	if (*type == (uintptr_t)ctor->next)
+		ctor->next = tagptr_unfold_ptr(t);
+
+	ctor->pages[ctor->index++] =
+		tagptr_fold(erofs_vtptr_t, NULL, 0);
+
+	return tagptr_unfold_ptr(t);
+}
+
+#endif
+
diff --git a/fs/erofs/unzip_vle.c b/fs/erofs/unzip_vle.c
new file mode 100644
index 0000000..aac339a
--- /dev/null
+++ b/fs/erofs/unzip_vle.c
@@ -0,0 +1,1170 @@
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
+#include <linux/slab.h>
+#include <linux/prefetch.h>
+
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
+struct z_erofs_vle_work_pageldr {
+	bool owner;
+	struct z_erofs_vle_work *curr;
+	struct z_erofs_pagevec_ctor vector;
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
+	enum z_erofs_page_type type)
+{
+	int ret;
+	bool occupied;
+
+	/* give priority for the compressed data storage */
+	if (type == Z_EROFS_PAGE_TYPE_EXCLUSIVE &&
+		try_to_reuse_as_compressed_page(l, page))
+		return 0;
+
+	ret = z_erofs_pagevec_ctor_enqueue(&l->vector,
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
+static inline bool try_to_claim_work(struct z_erofs_vle_work *work,
+     erofs_wtptr_t *owned_head, bool cached)
+{
+retry:
+	/* let's claim these following types of work */
+	if (tagptr_eq(work->next, Z_EROFS_WORK_TPTR_TAIL)) {
+		/* type 2, link to a existing chain */
+		if (!tagptr_eq(tagptr_cmpxchg(&work->next,
+			Z_EROFS_WORK_TPTR_TAIL, *owned_head),
+			Z_EROFS_WORK_TPTR_TAIL))
+			goto retry;
+
+		*owned_head = Z_EROFS_WORK_TPTR_TAIL;
+	} else if (tagptr_eq(work->next, Z_EROFS_WORK_TPTR_NIL)) {
+		/* type 1 */
+		if (!tagptr_eq(tagptr_cmpxchg(&work->next,
+			Z_EROFS_WORK_TPTR_NIL, *owned_head),
+			Z_EROFS_WORK_TPTR_TAIL))
+			goto retry;
+
+		*owned_head = tagptr_fold(erofs_wtptr_t, work, cached);
+	} else
+		return false;
+
+	return true;
+}
+
+static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_pageldr *l,
+				       struct super_block *sb,
+				       struct erofs_map_blocks *map,
+				       erofs_wtptr_t *owned_head)
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
+	/* must be Z_EROFS_WORK_TAIL or the next chained work */
+	BUG_ON(tagptr_cast_ptr(*owned_head) == NULL);
+	BUG_ON(map->m_pa % EROFS_BLKSIZ);
+
+restart:
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
+
+		/* claim the work if it can */
+		if (try_to_claim_work(work, owned_head, cached))
+			l->owner = true;
+
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
+	WRITE_ONCE(work->next, *owned_head);
+
+	err = z_erofs_vle_workgroup_register(sb, grp, cached);
+	if (err) {
+		kmem_cache_free(z_erofs_workgroup_cachep, grp);
+		goto restart;
+	}
+
+	*owned_head = tagptr_fold(erofs_wtptr_t, work, cached);
+	l->owner = true;
+	mutex_lock(&work->lock);
+
+got_it:
+	z_erofs_pagevec_ctor_init(&l->vector,
+		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, work->vcnt);
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
+	z_erofs_pagevec_ctor_exit(&l->vector, false);
+	mutex_unlock(&l->curr->lock);
+	l->curr = NULL;
+}
+
+static int z_erofs_do_read_page(struct page *page,
+				struct z_erofs_vle_work_pageldr *l,
+				struct erofs_map_blocks_iter *m,
+				erofs_wtptr_t *owned_head)
+{
+	struct inode *const inode = page->mapping->host;
+	struct super_block *const sb = inode->i_sb;
+	const loff_t offset = page_offset(page);
+	bool owned = true;
+	struct z_erofs_vle_work *work = l->curr;
+	enum z_erofs_page_type page_type;
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
+	err = z_erofs_vle_work_iter_begin(l, sb, &m->map, owned_head);
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
+		(!spiltted ? Z_EROFS_PAGE_TYPE_EXCLUSIVE :
+			(owned ? Z_EROFS_PAGE_TYPE_EXCLUSIVE :
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
+static void z_erofs_vle_unzip_kickoff(void *ptr, int bios)
+{
+	tagptr1_t t = tagptr_init(tagptr1_t, ptr);
+	struct z_erofs_vle_unzip_io *io = tagptr_unfold_ptr(t);
+	bool async = tagptr_unfold_tags(t);
+
+	if (!atomic_add_return(bios, &io->pending_bios)) {
+		if (async)
+			queue_work(z_erofs_workqueue, &io->u.work);
+		else
+			wake_up(&io->u.wait);
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
+
+		/* TODO: design for pages for cached work */
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
+	struct z_erofs_pagevec_ctor ctor;
+	unsigned nr_pages;
+	struct page *pages_onstack[Z_EROFS_VLE_VMAP_ONSTACK_PAGES];
+	struct page **pages, **compressed_pages, *page;
+	unsigned i, llen;
+
+	enum z_erofs_page_type page_type;
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
+	for (i = 0; i < nr_pages; ++i)
+		pages[i] = NULL;
+
+	z_erofs_pagevec_ctor_init(&ctor,
+		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, 0);
+
+	for (i = 0; i < work->vcnt; ++i) {
+		unsigned pagenr;
+
+		page = z_erofs_pagevec_ctor_dequeue(&ctor, &page_type);
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
+	z_erofs_pagevec_ctor_exit(&ctor, true);
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
+	for (i = 0; i < nr_pages; ++i) {
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
+	for (i = 0; i < nr_pages; ++i) {
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
+	for (i = 0; i < clusterpages; ++i) {
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
+
+	mutex_unlock(&work->lock);
+	return err;
+}
+
+static void z_erofs_vle_unzip_all(struct super_block *sb,
+				  struct z_erofs_vle_unzip_io *io,
+				  struct list_head *page_pool)
+{
+	erofs_wtptr_t owned = io->head;
+	struct z_erofs_vle_work *work;
+	bool cached;
+
+	BUG_ON(tagptr_eq(owned, Z_EROFS_WORK_TPTR_TAIL_CLOSED));
+	do {
+		/* no possible that 'owned' equals Z_EROFS_WORK_TPTR_TAIL */
+		BUG_ON(tagptr_eq(owned, Z_EROFS_WORK_TPTR_TAIL));
+
+		/* no possible that 'owned' equals NULL */
+		BUG_ON(tagptr_eq(owned, Z_EROFS_WORK_TPTR_NIL));
+
+		work = tagptr_unfold_ptr(owned);
+		cached = tagptr_unfold_tags(owned);
+
+		owned = READ_ONCE(work->next);
+		z_erofs_vle_unzip(sb, work, cached, page_pool);
+
+		z_erofs_vle_workgroup_put(z_erofs_vle_work_workgroup(work));
+	} while (!tagptr_eq(owned, Z_EROFS_WORK_TPTR_TAIL_CLOSED));
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
+static inline tagptr1_t prepare_io_descriptor(
+	struct super_block *sb,
+	struct z_erofs_vle_unzip_io *io,
+	bool *sync)
+{
+	struct z_erofs_vle_unzip_io_sb *iosb;
+
+	/* use the existing on-stack dummy descriptor for sync mode */
+	if (io != NULL) {
+		*sync = true;
+
+		init_waitqueue_head(&io->u.wait);
+		atomic_set(&io->pending_bios, 0);
+
+		return tagptr_fold(tagptr1_t, io, 0);
+	}
+
+	/* allocate extra io descriptor in async mode */
+	sync = false;
+
+	iosb = kvzalloc(sizeof(struct z_erofs_vle_unzip_io_sb),
+		GFP_KERNEL | __GFP_NOFAIL);
+	BUG_ON(iosb == NULL);
+
+	iosb->sb = sb;
+	io = &iosb->io;
+	INIT_WORK(&io->u.work, z_erofs_vle_unzip_wq);
+
+	return tagptr_fold(tagptr1_t, io, 1);
+}
+
+static bool z_erofs_vle_submit_all(struct super_block *sb,
+				   erofs_wtptr_t owned_head,
+				   struct list_head *page_pool,
+				   struct z_erofs_vle_unzip_io *io)
+{
+	struct bio *bio = NULL;
+	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	pgoff_t last_page;
+	bool sync;
+	unsigned bios_submitted;
+	tagptr1_t tio;
+
+	if (unlikely(tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_TAIL)))
+		return false;
+
+	tio = prepare_io_descriptor(sb, io, &sync);
+	io->head = owned_head;
+
+	bios_submitted = 0;
+
+	do {
+		struct z_erofs_vle_work *work;
+		struct z_erofs_vle_workgroup *grp;
+		bool cached, locked;
+		struct page **compressed_pages;
+		pgoff_t current_page;
+		unsigned i;
+		int err;
+
+		/* no possible 'owned_head' equals the following */
+		BUG_ON(tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_TAIL_CLOSED));
+		BUG_ON(tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_NIL));
+
+		work = tagptr_unfold_ptr(owned_head);
+		cached = tagptr_unfold_tags(owned_head);
+
+		/* close the owned chain at first */
+		owned_head = tagptr_cmpxchg(&work->next,
+			Z_EROFS_WORK_TPTR_TAIL, Z_EROFS_WORK_TPTR_TAIL_CLOSED);
+
+		grp = z_erofs_vle_work_workgroup(work);
+
+		BUG_ON(cached);
+
+		locked = false;
+		if (unlikely(mutex_is_locked(&work->lock))) {
+			mutex_lock(&work->lock);
+			locked = true;
+		}
+
+		compressed_pages = z_erofs_vle_work_uncached_mux(work);
+		/* fulfill all compressed pages */
+		for (i = 0; i < clusterpages; ++i) {
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
+		if (unlikely(locked))
+			mutex_unlock(&work->lock);
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
+			bio->bi_private = tagptr_cast_ptr(tio);
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
+
+		if (++i < clusterpages)
+			goto repeat;
+	} while (!tagptr_eq(owned_head, Z_EROFS_WORK_TPTR_TAIL));
+
+	if (bio != NULL)
+		__submit_bio(bio, REQ_OP_READ, 0);
+
+	z_erofs_vle_unzip_kickoff(tagptr_cast_ptr(tio), bios_submitted);
+	return true;
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
+	erofs_wtptr_t owned_head = Z_EROFS_WORK_TPTR_TAIL;
+	struct super_block *sb;
+	struct z_erofs_vle_unzip_io io;
+	LIST_HEAD(pagepool);
+
+	int err = z_erofs_do_read_page(page, &l, &m_iter, &owned_head);
+
+	z_erofs_vle_work_iter_end(&l);
+
+	if (err) {
+		errln("%s, failed to read, err [%d]", __func__, err);
+		goto out;
+	}
+
+	sb = page->mapping->host->i_sb;
+
+	if (!z_erofs_vle_submit_all(sb, owned_head, &pagepool, &io))
+		goto out;
+
+	/* wait until all bios are completed */
+	wait_event(io.u.wait, !atomic_read(&io.pending_bios));
+
+	/* synchronous decompression */
+	z_erofs_vle_unzip_all(sb, &io, &pagepool);
+
+out:
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
+	erofs_wtptr_t owned_head = Z_EROFS_WORK_TPTR_TAIL;
+
+	for (; nr_pages; --nr_pages) {
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
+	while (head != NULL) {
+		struct page *page = head;
+		int err;
+
+		/* traversal in reverse order */
+		head = (void *)page_private(page);
+		err = z_erofs_do_read_page(page, &l, &m_iter, &owned_head);
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
+		z_erofs_vle_submit_all(sb, owned_head, &pagepool, NULL);
+	else {
+		struct z_erofs_vle_unzip_io io;
+
+		if (!z_erofs_vle_submit_all(sb, owned_head, &pagepool, &io))
+			goto out;
+
+		/* wait until all bios are completed */
+		wait_event(io.u.wait, !atomic_read(&io.pending_bios));
+
+		/* let's synchronous decompression */
+		z_erofs_vle_unzip_all(sb, &io, &pagepool);
+	}
+
+out:
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
new file mode 100644
index 0000000..a74a4fc
--- /dev/null
+++ b/fs/erofs/unzip_vle.h
@@ -0,0 +1,236 @@
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
+#ifndef __EROFS_FS_UNZIP_VLE_H
+#define __EROFS_FS_UNZIP_VLE_H
+
+#include "internal.h"
+#include "unzip_pagevec.h"
+
+/* (uncached/cached) work tagged pointer */
+typedef tagptr1_t       erofs_wtptr_t;
+
+/* let's avoid the 32-bit valid kernel address */
+
+/* the chained works haven't io submitted (still open) */
+#define Z_EROFS_WORK_TAIL               0x5F0ECAFE
+/* the chained works have already io submitted */
+#define Z_EROFS_WORK_TAIL_CLOSED        0x5F0EDEAD
+
+
+#define Z_EROFS_WORK_TPTR_TAIL  tagptr_init(erofs_wtptr_t, Z_EROFS_WORK_TAIL)
+#define Z_EROFS_WORK_TPTR_TAIL_CLOSED \
+	tagptr_init(erofs_wtptr_t, Z_EROFS_WORK_TAIL_CLOSED)
+
+#define Z_EROFS_WORK_TPTR_NIL   tagptr_init(erofs_wtptr_t, NULL)
+
+/*
+ * Structure fields follow one of the following exclusion rules.
+ *
+ * I: Modifiable by initialization/destruction paths and read-only
+ *    for everyone else.
+ *
+ */
+
+#define Z_EROFS_VLE_INLINE_PAGEVECS     3
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
+	erofs_wtptr_t next;
+
+	union {
+		/* L: pagevec */
+		erofs_vtptr_t pagevec[Z_EROFS_VLE_INLINE_PAGEVECS];
+		struct rcu_head rcu;
+	};
+};
+
+#define Z_EROFS_WORK_FORMAT_PLAIN       0
+#define Z_EROFS_WORK_FORMAT_LZ4         1
+#define Z_EROFS_WORK_FORMAT_MASK        1
+
+struct z_erofs_vle_work_uncached {
+	struct z_erofs_vle_work work;
+
+	/* multi-usage (both used for decompressed / compressed pages) */
+	struct page *mux[Z_EROFS_CLUSTER_MAX_PAGES];
+};
+
+struct z_erofs_vle_cached_header {
+	struct z_erofs_vle_work work;
+
+	struct page *managed[Z_EROFS_CLUSTER_MAX_PAGES];
+};
+
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
+
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
+{
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
+	erofs_wtptr_t head;
+
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
+}
+
+static inline void z_erofs_onlinepage_fixup(struct page *page,
+	uintptr_t index, bool down)
+{
+	unsigned long *p, o, v, id;
+repeat:
+	p = &page_private(page);
+	o = READ_ONCE(*p);
+
+	id = o >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
+	if (id) {
+		if (!index)
+			return;
+
+		BUG_ON(id != index);
+	}
+
+	v = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
+		((o & Z_EROFS_ONLINEPAGE_COUNT_MASK) + (unsigned)down);
+	if (cmpxchg(p, o, v) != o)
+		goto repeat;
+}
+
+static inline void z_erofs_onlinepage_endio(struct page *page)
+{
+	union z_erofs_onlinepage_converter u;
+	unsigned v;
+
+	BUG_ON(!PagePrivate(page));
+	u.v = &page_private(page);
+
+	v = atomic_dec_return(u.o);
+	if (!(v & Z_EROFS_ONLINEPAGE_COUNT_MASK)) {
+		ClearPagePrivate(page);
+		if (!PageError(page))
+			SetPageUptodate(page);
+		unlock_page(page);
+	}
+
+	debugln("%s, page %p value %x", __func__, page, atomic_read(u.o));
+}
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
