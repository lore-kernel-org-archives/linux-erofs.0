From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 30 Jun 2018 23:17:33 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.3 6/6] erofs: introduce VLE
 decompression subsystem
In-Reply-To: <1530371853-104412-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530371853-104412-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530371853-104412-6-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v0.3:
 - separate to several small patches, maybe more in the future patchset

change log v0.2:
 - use the recent introduced tagptr_t type to manage tagged pointers.
 - bugfix

Todo list:
 - spilt into more understandable patches
 - add missing functions and bugfix

The patchset is temporarily based on
[RFC PATCH RESEND 11/12] erofs: introduce a customized LZ4 decompression

The new unzip system is still _buggy_, not for _daily_ use!

 fs/erofs/Kconfig         |  15 +
 fs/erofs/Makefile        |   4 +-
 fs/erofs/inode.c         |   6 +-
 fs/erofs/internal.h      |  29 ++
 fs/erofs/staging.h       |  42 +++
 fs/erofs/super.c         |  36 +-
 fs/erofs/unzip_vle.c     | 943 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/erofs/unzip_vle.h     | 236 ++++++++++++
 fs/erofs/unzip_vle_lz4.c | 145 ++++++++
 9 files changed, 1449 insertions(+), 7 deletions(-)
 create mode 100644 fs/erofs/unzip_vle.h
 create mode 100644 fs/erofs/unzip_vle_lz4.c

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 3b34402..c7fea19 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -77,3 +77,18 @@ config EROFS_FS_ZIP
 	  Play at your own risk.
 
 	  If you don't want to use compression feature, say N.
+
+config EROFS_FS_CLUSTER_PAGE_LIMIT
+	int "EROFS Cluster Pages Hard Limit"
+	depends on EROFS_FS_ZIP
+	range 1 256
+	default "1"
+	help
+	  Indicates VLE compressed pages hard limit of a
+	  compressed cluster.
+
+	  For example, if files of a image are compressed
+	  into 8k-unit, the hard limit should not be less
+	  than 2. Otherwise, the image cannot be mounted
+	  correctly on this kernel.
+
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
index 0b3db0a..fa9d179 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -3,7 +3,7 @@ EROFS_VERSION = "1.0"
 EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 
 obj-$(CONFIG_EROFS_FS) += erofs.o
-erofs-objs := super.o inode.o data.o namei.o dir.o
+erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
-erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_vle_lz4.o unzip_lz4.o
 
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
index c9482fe..f015e1d 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -59,6 +59,14 @@ struct erofs_sb_info {
 #ifdef CONFIG_EROFS_FS_ZIP
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
 #endif
 
 	u32 build_time_nsec;
@@ -87,6 +95,16 @@ struct erofs_sb_info {
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
 
@@ -104,6 +122,14 @@ struct erofs_sb_info {
 
 #define ROOT_NID(sb)		((sb)->root_nid)
 
+#ifdef CONFIG_EROFS_FS_ZIP
+/* hard limit of pages per compressed cluster */
+#define Z_EROFS_CLUSTER_MAX_PAGES       (CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT)
+
+/* page count of a compressed cluster */
+#define erofs_clusterpages(sbi)         ((1 << (sbi)->clusterbits) / PAGE_SIZE)
+#endif
+
 typedef u64 erofs_off_t;
 
 /* data type for filesystem-wide blocks number */
@@ -185,6 +211,9 @@ static inline bool is_inode_layout_inline(struct inode *inode)
 extern const struct file_operations erofs_unaligned_compressed_fops;
 
 extern const struct address_space_operations erofs_raw_access_aops;
+#ifdef CONFIG_EROFS_FS_ZIP
+extern const struct address_space_operations z_erofs_vle_normal_access_aops;
+#endif
 
 /*
  * Logical to physical block mapping, used by erofs_map_blocks()
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
index b41613f..297dc78 100644
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
@@ -186,6 +193,13 @@ static int erofs_read_super(struct super_block *sb,
 	if (!silent)
 		infoln("root inode @ nid %llu", ROOT_NID(sbi));
 
+#ifdef CONFIG_EROFS_FS_ZIP
+	INIT_RADIX_TREE(&sbi->zwrksp.tree, GFP_ATOMIC);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+	spin_lock_init(&sbi->zwrksp.lock);
+#endif
+#endif
+
 	/* get the root inode */
 	inode = erofs_iget(sb, ROOT_NID(sbi), true);
 	if (IS_ERR(inode)) {
@@ -301,6 +315,12 @@ static void erofs_kill_sb(struct super_block *sb)
 	.fs_flags       = FS_REQUIRES_DEV,
 };
 
+#ifdef CONFIG_EROFS_FS_ZIP
+extern int z_erofs_init_zip_subsystem(void);
+
+extern void z_erofs_exit_zip_subsystem(void);
+#endif
+
 int __init erofs_module_init(void)
 {
 	int err;
@@ -309,11 +329,18 @@ int __init erofs_module_init(void)
 
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
@@ -321,6 +348,9 @@ int __init erofs_module_init(void)
 void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+#ifdef CONFIG_EROFS_FS_ZIP
+	z_erofs_exit_zip_subsystem();
+#endif
 	infoln("Successfully finalize erofs");
 }
 
diff --git a/fs/erofs/unzip_vle.c b/fs/erofs/unzip_vle.c
index 300f556..f553f5e 100644
--- a/fs/erofs/unzip_vle.c
+++ b/fs/erofs/unzip_vle.c
@@ -10,7 +10,948 @@
  * License.  See the file COPYING in the main directory of the Linux
  * distribution for more details.
  */
-#include "internal.h"
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
+
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
+	struct z_erofs_vle_workgroup *grp;
+	bool cached;
+	pgoff_t index = map->m_pa / EROFS_BLKSIZ;
+	struct z_erofs_vle_work *work;
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
+
+		/* claim the work if it can */
+		if (try_to_claim_work(work, owned_head, cached))
+			l->owner = true;
+
+		goto got_it;
+	}
+
+	/* no available workgroup, let's allocate one */
+	do {
+		grp = kmem_cache_zalloc(z_erofs_workgroup_cachep,
+			GFP_NOFS | __GFP_NOFAIL);
+
+		/* it is not allowed to fail (-ENOMEM / -EIO, no...) */
+	} while (unlikely(grp == NULL));
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
+	/* new works has type 1 */
+	WRITE_ONCE(work->next, *owned_head);
+
+	err = z_erofs_vle_workgroup_register(sb, grp, cached);
+	if (err) {
+		kmem_cache_free(z_erofs_workgroup_cachep, grp);
+		goto repeat;
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
+	if (atomic_add_return(bios, &io->pending_bios))
+		return;
+
+	if (async)
+		queue_work(z_erofs_workqueue, &io->u.work);
+	else
+		wake_up(&io->u.wait);
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
+	WRITE_ONCE(work->next, Z_EROFS_WORK_TPTR_NIL);
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
+	struct page *head = NULL;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+	erofs_wtptr_t owned_head = Z_EROFS_WORK_TPTR_TAIL;
+	LIST_HEAD(pagepool);
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
 
 #define __vle_cluster_advise(x, bit, bits) \
 	((le16_to_cpu(x) >> (bit)) & ((1 << (bits)) - 1))
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
-- 
1.9.1
