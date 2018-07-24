From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 24 Jul 2018 10:36:44 +0800
Subject: [RFC PATCH 24/25] staging: erofs: introduce VLE decompression support
In-Reply-To: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532399805-65674-25-git-send-email-gaoxiang25@huawei.com>

This patch introduces the basic in-place VLE decompression
implementation for the erofs file system.

Compared with fixed-sized input compression, it implements
what we call 'the variable-length extent compression' which
specifies the same output size for each compression block
to make the full use of IO bandwidth (which means almost
all data from block device can be directly used for decomp-
ression), improve the real (rather than just via data caching,
which costs more memory) random read and keep the relatively
lower compression ratios (it saves more storage space than
fixed-sized input compression which is also configured with
the same input block size), as illustrated below:

        |---  variable-length extent ---|------ VLE ------|---  VLE ---|
         /> clusterofs                  /> clusterofs     /> clusterofs /> clusterofs
   ++---|-------++-----------++---------|-++-----------++-|---------++-|
...||   |       ||           ||         | ||           || |         || | ... original data
   ++---|-------++-----------++---------|-++-----------++-|---------++-|
   ++->cluster<-++->cluster<-++->cluster<-++->cluster<-++->cluster<-++
        size         size         size         size         size
         \                             /                 /            /
          \                      /              /            /
           \               /            /            /
            ++-----------++-----------++-----------++
        ... ||           ||           ||           || ... compressed clusters
            ++-----------++-----------++-----------++
            ++->cluster<-++->cluster<-++->cluster<-++
                 size         size         size

The main point of 'in-place' refers to the decompression mode:
Instead of allocating independent compressed pages and data
structures, it reuses the allocated file cache pages at most
to store its compressed data and the corresponding pagevec in
a time-sharing approach by default, which will be useful for
low memory scenario.

In the end, unlike the other filesystems with (de)compression
support using a relatively large compression block size, which
reads and decompresses >= 128KB at once, and gains a more
good-looking random read (In fact it collects small random reads
into large sequential reads and caches all decompressed data
in memory, but it is unacceptable especially for embedded devices
with limited memory, and it is not the real random read), we
select a universal small-sized 4KB compressed cluster, which is
the smallest page size for most architectures, and all compressed
clusters can be read and decompressed independently, which ensures
random read number for all use cases.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/inode.c     |    5 +
 drivers/staging/erofs/internal.h  |    6 +
 drivers/staging/erofs/staging.h   |   46 ++
 drivers/staging/erofs/super.c     |   25 +
 drivers/staging/erofs/unzip_vle.c | 1128 ++++++++++++++++++++++++++++++++++++-
 drivers/staging/erofs/unzip_vle.h |  204 +++++++
 drivers/staging/erofs/utils.c     |   61 +-
 7 files changed, 1473 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 001ddb9..7d07056 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -214,7 +214,12 @@ int fill_inode(struct inode *inode, int isdir)
 		}
 
 		if (is_inode_layout_compression(inode)) {
+#ifdef CONFIG_EROFS_FS_ZIP
+			inode->i_mapping->a_ops =
+				&z_erofs_vle_normalaccess_aops;
+#else
 			err = -ENOTSUPP;
+#endif
 			goto out_unlock;
 		}
 
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 9c25ffa..676cb1e 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -274,6 +274,9 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
 #ifdef CONFIG_EROFS_FS_ZIP
 /* hard limit of pages per compressed cluster */
 #define Z_EROFS_CLUSTER_MAX_PAGES       (CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT)
+
+/* page count of a compressed cluster */
+#define erofs_clusterpages(sbi)         ((1 << (sbi)->clusterbits) / PAGE_SIZE)
 #endif
 
 typedef u64 erofs_off_t;
@@ -355,6 +358,9 @@ static inline bool is_inode_layout_inline(struct inode *inode)
 extern const struct file_operations erofs_dir_fops;
 
 extern const struct address_space_operations erofs_raw_access_aops;
+#ifdef CONFIG_EROFS_FS_ZIP
+extern const struct address_space_operations z_erofs_vle_normalaccess_aops;
+#endif
 
 /*
  * Logical to physical block mapping, used by erofs_map_blocks()
diff --git a/drivers/staging/erofs/staging.h b/drivers/staging/erofs/staging.h
index a9bfd8c..47c9708d 100644
--- a/drivers/staging/erofs/staging.h
+++ b/drivers/staging/erofs/staging.h
@@ -85,3 +85,49 @@ static inline bool sb_rdonly(const struct super_block *sb) {
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 #endif
 
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
+static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	if (size != 0 && n > SIZE_MAX / size)
+		return NULL;
+
+	return kvmalloc(n * size, flags);
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
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1d4bcaa..a0db717 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -119,6 +119,13 @@ static int superblock_read(struct super_block *sb)
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
 
 	sbi->root_nid = le16_to_cpu(layout->root_nid);
 	sbi->inos = le64_to_cpu(layout->inos);
@@ -452,6 +459,11 @@ static void erofs_kill_sb(struct super_block *sb)
 };
 MODULE_ALIAS_FS("erofs");
 
+#ifdef CONFIG_EROFS_FS_ZIP
+extern int z_erofs_init_zip_subsystem(void);
+extern void z_erofs_exit_zip_subsystem(void);
+#endif
+
 int __init erofs_module_init(void)
 {
 	int err;
@@ -467,6 +479,12 @@ int __init erofs_module_init(void)
 	if (err)
 		goto shrinker_err;
 
+#ifdef CONFIG_EROFS_FS_ZIP
+	err = z_erofs_init_zip_subsystem();
+	if (err)
+		goto zip_err;
+#endif
+
 	err = register_filesystem(&erofs_fs_type);
 	if (err)
 		goto fs_err;
@@ -475,6 +493,10 @@ int __init erofs_module_init(void)
 	return 0;
 
 fs_err:
+#ifdef CONFIG_EROFS_FS_ZIP
+	z_erofs_exit_zip_subsystem();
+zip_err:
+#endif
 	unregister_shrinker(&erofs_shrinker_info);
 shrinker_err:
 	erofs_exit_inode_cache();
@@ -485,6 +507,9 @@ int __init erofs_module_init(void)
 void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+#ifdef CONFIG_EROFS_FS_ZIP
+	z_erofs_exit_zip_subsystem();
+#endif
 	unregister_shrinker(&erofs_shrinker_info);
 	erofs_exit_inode_cache();
 	infoln("successfully finalize erofs");
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index e6752cf..a739dc6 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -10,7 +10,1133 @@
  * License.  See the file COPYING in the main directory of the Linux
  * distribution for more details.
  */
-#include "internal.h"
+#include "unzip_vle.h"
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
+enum z_erofs_vle_work_role {
+	Z_EROFS_VLE_WORK_SECONDARY,
+	Z_EROFS_VLE_WORK_PRIMARY,
+	/*
+	 * The current work has at least been linked with the following
+	 * processed chained works, which means if the processing page
+	 * is the tail partial page of the work, the current work can
+	 * safely use the whole page, as illustrated below:
+	 * +--------------+-------------------------------------------+
+	 * |  tail page   |      head page (of the previous work)     |
+	 * +--------------+-------------------------------------------+
+	 *   /\  which belongs to the current work
+	 * [  (*) this page can be used for the current work itself.  ]
+	 */
+	Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED,
+	Z_EROFS_VLE_WORK_MAX
+};
+
+struct z_erofs_vle_work_builder {
+	enum z_erofs_vle_work_role role;
+	/*
+	 * 'hosted = false' means that the current workgroup doesn't belong to
+	 * the owned chained workgroups. In the other words, it is none of our
+	 * business to submit this workgroup.
+	 */
+	bool hosted;
+
+	struct z_erofs_vle_workgroup *grp;
+	struct z_erofs_vle_work *work;
+	struct z_erofs_pagevec_ctor vector;
+
+	/* pages used for reading the compressed data */
+	struct page **compressed_pages;
+	unsigned compressed_deficit;
+};
+
+#define VLE_WORK_BUILDER_INIT()	\
+	{ .work = NULL, .role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED }
+
+/* page_type must be Z_EROFS_PAGE_TYPE_EXCLUSIVE */
+static inline bool try_to_reuse_as_compressed_page(
+	struct z_erofs_vle_work_builder *b,
+	struct page *page)
+{
+	while (b->compressed_deficit) {
+		--b->compressed_deficit;
+		if (NULL == cmpxchg(b->compressed_pages++, NULL, page))
+			return true;
+	}
+
+	return false;
+}
+
+/* callers must be with work->lock held */
+static int z_erofs_vle_work_add_page(
+	struct z_erofs_vle_work_builder *builder,
+	struct page *page,
+	enum z_erofs_page_type type)
+{
+	int ret;
+	bool occupied;
+
+	/* give priority for the compressed data storage */
+	if (builder->role >= Z_EROFS_VLE_WORK_PRIMARY &&
+		type == Z_EROFS_PAGE_TYPE_EXCLUSIVE &&
+		try_to_reuse_as_compressed_page(builder, page))
+		return 0;
+
+	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector,
+		page, type, &occupied);
+	builder->work->vcnt += (unsigned)ret;
+
+	return ret ? 0 : -EAGAIN;
+}
+
+static inline bool try_to_claim_workgroup(
+	struct z_erofs_vle_workgroup *grp,
+	z_erofs_vle_owned_workgrp_t *owned_head,
+	bool *hosted)
+{
+	DBG_BUGON(*hosted == true);
+
+	/* let's claim these following types of workgroup */
+retry:
+	if (grp->next == Z_EROFS_VLE_WORKGRP_NIL) {
+		/* type 1, nil workgroup */
+		if (Z_EROFS_VLE_WORKGRP_NIL != cmpxchg(&grp->next,
+			Z_EROFS_VLE_WORKGRP_NIL, *owned_head))
+			goto retry;
+
+		*owned_head = grp;
+		*hosted = true;
+	} else if (grp->next == Z_EROFS_VLE_WORKGRP_TAIL) {
+		/*
+		 * type 2, link to the end of a existing open chain,
+		 * be careful that its submission itself is governed
+		 * by the original owned chain.
+		 */
+		if (Z_EROFS_VLE_WORKGRP_TAIL != cmpxchg(&grp->next,
+			Z_EROFS_VLE_WORKGRP_TAIL, *owned_head))
+			goto retry;
+
+		*owned_head = Z_EROFS_VLE_WORKGRP_TAIL;
+	} else
+		return false;	/* :( better luck next time */
+
+	return true;	/* lucky, I am the followee :) */
+}
+
+static struct z_erofs_vle_work *
+z_erofs_vle_work_lookup(struct super_block *sb,
+			pgoff_t idx, unsigned pageofs,
+			struct z_erofs_vle_workgroup **grp_ret,
+			enum z_erofs_vle_work_role *role,
+			z_erofs_vle_owned_workgrp_t *owned_head,
+			bool *hosted)
+{
+	bool tag, primary;
+	struct erofs_workgroup *egrp;
+	struct z_erofs_vle_workgroup *grp;
+	struct z_erofs_vle_work *work;
+
+	egrp = erofs_find_workgroup(sb, idx, &tag);
+	if (egrp == NULL) {
+		*grp_ret = NULL;
+		return NULL;
+	}
+
+	*grp_ret = grp = container_of(egrp,
+		struct z_erofs_vle_workgroup, obj);
+
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	work = z_erofs_vle_grab_work(grp, pageofs);
+	primary = true;
+#else
+	BUG();
+#endif
+
+	DBG_BUGON(work->pageofs != pageofs);
+
+	/*
+	 * lock must be taken first to avoid grp->next == NIL between
+	 * claiming workgroup and adding pages:
+	 *                        grp->next != NIL
+	 *   grp->next = NIL
+	 *   mutex_unlock_all
+	 *                        mutex_lock(&work->lock)
+	 *                        add all pages to pagevec
+	 *
+	 * [correct locking case 1]:
+	 *   mutex_lock(grp->work[a])
+	 *   ...
+	 *   mutex_lock(grp->work[b])     mutex_lock(grp->work[c])
+	 *   ...                          *role = SECONDARY
+	 *                                add all pages to pagevec
+	 *                                ...
+	 *                                mutex_unlock(grp->work[c])
+	 *   mutex_lock(grp->work[c])
+	 *   ...
+	 *   grp->next = NIL
+	 *   mutex_unlock_all
+	 *
+	 * [correct locking case 2]:
+	 *   mutex_lock(grp->work[b])
+	 *   ...
+	 *   mutex_lock(grp->work[a])
+	 *   ...
+	 *   mutex_lock(grp->work[c])
+	 *   ...
+	 *   grp->next = NIL
+	 *   mutex_unlock_all
+	 *                                mutex_lock(grp->work[a])
+	 *                                *role = PRIMARY_OWNER
+	 *                                add all pages to pagevec
+	 *                                ...
+	 */
+	mutex_lock(&work->lock);
+
+	*hosted = false;
+	if (!primary)
+		*role = Z_EROFS_VLE_WORK_SECONDARY;
+	/* claim the workgroup if possible */
+	else if (try_to_claim_workgroup(grp, owned_head, hosted))
+		*role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
+	else
+		*role = Z_EROFS_VLE_WORK_PRIMARY;
+
+	return work;
+}
+
+static struct z_erofs_vle_work *
+z_erofs_vle_work_register(struct super_block *sb,
+			  struct z_erofs_vle_workgroup **grp_ret,
+			  struct erofs_map_blocks *map,
+			  pgoff_t index, unsigned pageofs,
+			  enum z_erofs_vle_work_role *role,
+			  z_erofs_vle_owned_workgrp_t *owned_head,
+			  bool *hosted)
+{
+	bool newgrp = false;
+	struct z_erofs_vle_workgroup *grp = *grp_ret;
+	struct z_erofs_vle_work *work;
+
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	BUG_ON(grp != NULL);
+#else
+	if (grp != NULL)
+		goto skip;
+#endif
+	/* no available workgroup, let's allocate one */
+	grp = kmem_cache_zalloc(z_erofs_workgroup_cachep, GFP_NOFS);
+	if (unlikely(grp == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	grp->obj.index = index;
+	grp->llen = map->m_llen;
+
+	z_erofs_vle_set_workgrp_fmt(grp,
+		(map->m_flags & EROFS_MAP_ZIPPED) ?
+			Z_EROFS_VLE_WORKGRP_FMT_LZ4 :
+			Z_EROFS_VLE_WORKGRP_FMT_PLAIN);
+	atomic_set(&grp->obj.refcount, 1);
+
+	/* new workgrps have been claimed as type 1 */
+	WRITE_ONCE(grp->next, *owned_head);
+	/* primary and followed work for all new workgrps */
+	*role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
+	/* it should be submitted by ourselves */
+	*hosted = true;
+
+	newgrp = true;
+#ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
+skip:
+	/* currently unimplemented */
+	BUG();
+#else
+	work = z_erofs_vle_grab_primary_work(grp);
+#endif
+	work->pageofs = pageofs;
+
+	mutex_init(&work->lock);
+
+	if (newgrp) {
+		int err = erofs_register_workgroup(sb, &grp->obj, 0);
+
+		if (err) {
+			kmem_cache_free(z_erofs_workgroup_cachep, grp);
+			return ERR_PTR(-EAGAIN);
+		}
+	}
+
+	*owned_head = *grp_ret = grp;
+
+	mutex_lock(&work->lock);
+	return work;
+}
+
+static inline void __update_workgrp_llen(struct z_erofs_vle_workgroup *grp,
+					 unsigned int llen)
+{
+	while(1) {
+		unsigned int orig_llen = grp->llen;
+
+		if (orig_llen >= llen || orig_llen ==
+			cmpxchg(&grp->llen, orig_llen, llen))
+			break;
+	}
+}
+
+#define builder_is_followed(builder) \
+	((builder)->role >= Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED)
+
+static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
+				       struct super_block *sb,
+				       struct erofs_map_blocks *map,
+				       z_erofs_vle_owned_workgrp_t *owned_head)
+{
+	const unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
+	const erofs_blk_t index = erofs_blknr(map->m_pa);
+	const unsigned pageofs = map->m_la & ~PAGE_MASK;
+	struct z_erofs_vle_workgroup *grp;
+	struct z_erofs_vle_work *work;
+
+	DBG_BUGON(builder->work != NULL);
+
+	/* must be Z_EROFS_WORK_TAIL or the next chained work */
+	DBG_BUGON(*owned_head == Z_EROFS_VLE_WORKGRP_NIL);
+	DBG_BUGON(*owned_head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+
+	DBG_BUGON(erofs_blkoff(map->m_pa));
+
+repeat:
+	work = z_erofs_vle_work_lookup(sb, index,
+		pageofs, &grp, &builder->role, owned_head, &builder->hosted);
+	if (work != NULL) {
+		__update_workgrp_llen(grp, map->m_llen);
+		goto got_it;
+	}
+
+	work = z_erofs_vle_work_register(sb, &grp, map, index, pageofs,
+		&builder->role, owned_head, &builder->hosted);
+
+	if (unlikely(work == ERR_PTR(-EAGAIN)))
+		goto repeat;
+
+	if (unlikely(IS_ERR(work)))
+		return PTR_ERR(work);
+got_it:
+	z_erofs_pagevec_ctor_init(&builder->vector,
+		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, work->vcnt);
+
+	if (builder->role >= Z_EROFS_VLE_WORK_PRIMARY) {
+		/* enable possibly in-place decompression */
+		builder->compressed_pages = grp->compressed_pages;
+		builder->compressed_deficit = clusterpages;
+	} else {
+		builder->compressed_pages = NULL;
+		builder->compressed_deficit = 0;
+	}
+
+	builder->grp = grp;
+	builder->work = work;
+	return 0;
+}
+
+/*
+ * keep in mind that no referenced workgroups will be freed
+ * only after a RCU grace period, so rcu_read_lock() could
+ * prevent a workgroup from being freed.
+ */
+static void z_erofs_rcu_callback(struct rcu_head *head)
+{
+	struct z_erofs_vle_work *work =	container_of(head,
+		struct z_erofs_vle_work, rcu);
+	struct z_erofs_vle_workgroup *grp =
+		z_erofs_vle_work_workgroup(work, true);
+
+	kmem_cache_free(z_erofs_workgroup_cachep, grp);
+}
+
+void erofs_workgroup_free_rcu(struct erofs_workgroup *grp)
+{
+	struct z_erofs_vle_workgroup *const vgrp = container_of(grp,
+		struct z_erofs_vle_workgroup, obj);
+	struct z_erofs_vle_work *const work = &vgrp->work;
+
+	call_rcu(&work->rcu, z_erofs_rcu_callback);
+}
+
+void __z_erofs_vle_work_release(struct z_erofs_vle_workgroup *grp,
+	struct z_erofs_vle_work *work __maybe_unused)
+{
+	erofs_workgroup_put(&grp->obj);
+}
+
+void z_erofs_vle_work_release(struct z_erofs_vle_work *work)
+{
+	struct z_erofs_vle_workgroup *grp =
+		z_erofs_vle_work_workgroup(work, true);
+
+	__z_erofs_vle_work_release(grp, work);
+}
+
+static inline bool
+z_erofs_vle_work_iter_end(struct z_erofs_vle_work_builder *builder)
+{
+	struct z_erofs_vle_work *work = builder->work;
+
+	if (work == NULL)
+		return false;
+
+	z_erofs_pagevec_ctor_exit(&builder->vector, false);
+	mutex_unlock(&work->lock);
+
+	/*
+	 * if all pending pages are added, don't hold work reference
+	 * any longer if the current work isn't hosted by ourselves.
+	 */
+	if (!builder->hosted)
+		__z_erofs_vle_work_release(builder->grp, work);
+
+	builder->work = NULL;
+	builder->grp = NULL;
+	return true;
+}
+
+static inline struct page *__stagingpage_alloc(struct list_head *pagepool,
+					       gfp_t gfp)
+{
+	struct page *page = erofs_allocpage(pagepool, gfp);
+
+	if (unlikely(page == NULL))
+		return NULL;
+
+	page->mapping = Z_EROFS_MAPPING_STAGING;
+	return page;
+}
+
+struct z_erofs_vle_frontend {
+	struct inode *const inode;
+
+	struct z_erofs_vle_work_builder builder;
+	struct erofs_map_blocks_iter m_iter;
+
+	z_erofs_vle_owned_workgrp_t owned_head;
+
+	bool initial;
+};
+
+#define VLE_FRONTEND_INIT(__i) { \
+	.inode = __i, \
+	.m_iter = { \
+		{ .m_llen = 0, .m_plen = 0 }, \
+		.mpage = NULL \
+	}, \
+	.builder = VLE_WORK_BUILDER_INIT(), \
+	.owned_head = Z_EROFS_VLE_WORKGRP_TAIL, \
+	.initial = true, }
+
+static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
+				struct page *page,
+				struct list_head *page_pool)
+{
+	struct super_block *const sb = fe->inode->i_sb;
+	struct erofs_sb_info *const sbi __maybe_unused = EROFS_SB(sb);
+	struct erofs_map_blocks_iter *const m = &fe->m_iter;
+	struct erofs_map_blocks *const map = &m->map;
+	struct z_erofs_vle_work_builder *const builder = &fe->builder;
+	const loff_t offset = page_offset(page);
+
+	bool tight = builder_is_followed(builder);
+	struct z_erofs_vle_work *work = builder->work;
+
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
+	if (offset + cur >= map->m_la &&
+            offset + cur < map->m_la + map->m_llen)
+		goto hitted;
+
+	/* go ahead the next map_blocks */
+	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
+
+	if (!z_erofs_vle_work_iter_end(builder))
+		fe->initial = false;
+
+	map->m_la = offset + cur;
+	map->m_llen = 0;
+	err = erofs_map_blocks_iter(fe->inode, map, &m->mpage, 0);
+	if (unlikely(err))
+		goto err_out;
+
+	/* deal with hole (FIXME! broken now) */
+	if (unlikely(!(map->m_flags & EROFS_MAP_MAPPED)))
+		goto hitted;
+
+	DBG_BUGON(map->m_plen != 1 << sbi->clusterbits);
+	BUG_ON(erofs_blkoff(map->m_pa));
+
+	err = z_erofs_vle_work_iter_begin(builder, sb, map, &fe->owned_head);
+	if (unlikely(err))
+		goto err_out;
+
+	tight &= builder_is_followed(builder);
+	work = builder->work;
+hitted:
+	cur = end - min_t(unsigned, offset + end - map->m_la, end);
+	if (unlikely(!(map->m_flags & EROFS_MAP_MAPPED))) {
+		zero_user_segment(page, cur, end);
+		goto next_part;
+	}
+
+	/* let's derive page type */
+	page_type = cur ? Z_EROFS_VLE_PAGE_TYPE_HEAD :
+		(!spiltted ? Z_EROFS_PAGE_TYPE_EXCLUSIVE :
+			(tight ? Z_EROFS_PAGE_TYPE_EXCLUSIVE :
+				Z_EROFS_VLE_PAGE_TYPE_TAIL_SHARED));
+
+retry:
+	err = z_erofs_vle_work_add_page(builder, page, page_type);
+	/* should allocate an additional staging page for pagevec */
+	if (err == -EAGAIN) {
+		struct page *const newpage =
+			__stagingpage_alloc(page_pool, GFP_NOFS);
+
+		err = z_erofs_vle_work_add_page(builder,
+			newpage, Z_EROFS_PAGE_TYPE_EXCLUSIVE);
+		if (!err)
+			goto retry;
+	}
+
+	if (unlikely(err))
+		goto err_out;
+
+	index = page->index - map->m_la / PAGE_SIZE;
+
+	/* FIXME! avoid the last relundant fixup & endio */
+	z_erofs_onlinepage_fixup(page, index, true);
+	++spiltted;
+
+	/* also update nr_pages and increase queued_pages */
+	work->nr_pages = max_t(pgoff_t, work->nr_pages, index + 1);
+next_part:
+	/* can be used for verification */
+	map->m_llen = offset + cur - map->m_la;
+
+	if ((end = cur) > 0)
+		goto repeat;
+
+	/* FIXME! avoid the last relundant fixup & endio */
+	z_erofs_onlinepage_endio(page);
+
+	debugln("%s, finish page: %pK spiltted: %u map->m_llen %llu",
+		__func__, page, spiltted, map->m_llen);
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
+	bool background = tagptr_unfold_tags(t);
+
+	if (atomic_add_return(bios, &io->pending_bios))
+		return;
+
+	if (background)
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
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 13, 0))
+	const int err = bio->bi_status;
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 3, 0))
+	const int err = bio->bi_error;
+#endif
+	unsigned i;
+	struct bio_vec *bvec;
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
+
+		DBG_BUGON(PageUptodate(page));
+		BUG_ON(page->mapping == NULL);
+
+		if (unlikely(err))
+			SetPageError(page);
+	}
+
+	z_erofs_vle_unzip_kickoff(bio->bi_private, -1);
+	bio_put(bio);
+}
+
+static struct page *z_pagemap_global[Z_EROFS_VLE_VMAP_GLOBAL_PAGES];
+static DEFINE_MUTEX(z_pagemap_global_lock);
+
+static int z_erofs_vle_unzip(struct super_block *sb,
+	struct z_erofs_vle_workgroup *grp,
+	struct list_head *page_pool)
+{
+	struct erofs_sb_info *const sbi = EROFS_SB(sb);
+	const unsigned clusterpages = erofs_clusterpages(sbi);
+
+	struct z_erofs_pagevec_ctor ctor;
+	unsigned nr_pages;
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	unsigned sparsemem_pages = 0;
+#endif
+	struct page *pages_onstack[Z_EROFS_VLE_VMAP_ONSTACK_PAGES];
+	struct page **pages, **compressed_pages, *page;
+	unsigned i, llen;
+
+	enum z_erofs_page_type page_type;
+	bool overlapped;
+	struct z_erofs_vle_work *work;
+	void *vout;
+	int err;
+
+	might_sleep();
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	work = z_erofs_vle_grab_primary_work(grp);
+#else
+	BUG();
+#endif
+	BUG_ON(!READ_ONCE(work->nr_pages));
+
+	mutex_lock(&work->lock);
+	nr_pages = work->nr_pages;
+
+	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES))
+		pages = pages_onstack;
+	else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
+		mutex_trylock(&z_pagemap_global_lock))
+		pages = z_pagemap_global;
+	else {
+repeat:
+		pages = kvmalloc_array(nr_pages,
+			sizeof(struct page *), GFP_KERNEL);
+
+		/* fallback to global pagemap for the lowmem scenario */
+		if (unlikely(pages == NULL)) {
+			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
+				goto repeat;
+			else {
+				mutex_lock(&z_pagemap_global_lock);
+				pages = z_pagemap_global;
+			}
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
+
+		/* all pages in pagevec ought to be valid */
+		DBG_BUGON(page == NULL);
+		DBG_BUGON(page->mapping == NULL);
+
+		if (z_erofs_gather_if_stagingpage(page_pool, page))
+			continue;
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
+		++sparsemem_pages;
+#endif
+		pages[pagenr] = page;
+	}
+
+	z_erofs_pagevec_ctor_exit(&ctor, true);
+
+	overlapped = false;
+	compressed_pages = grp->compressed_pages;
+
+	for(i = 0; i < clusterpages; ++i) {
+		unsigned pagenr;
+
+		page = compressed_pages[i];
+
+		/* all compressed pages ought to be valid */
+		DBG_BUGON(page == NULL);
+		DBG_BUGON(page->mapping == NULL);
+
+		if (z_erofs_is_stagingpage(page))
+			continue;
+
+		/* only non-head page could be reused as a compressed page */
+		pagenr = z_erofs_onlinepage_index(page);
+
+		BUG_ON(pagenr >= nr_pages);
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+		BUG_ON(pages[pagenr] != NULL);
+		++sparsemem_pages;
+#endif
+		pages[pagenr] = page;
+
+		overlapped = true;
+	}
+
+	llen = (nr_pages << PAGE_SHIFT) - work->pageofs;
+
+	if (z_erofs_vle_workgrp_fmt(grp) == Z_EROFS_VLE_WORKGRP_FMT_PLAIN) {
+		/* FIXME! this should be fixed in the future */
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
+		clusterpages, pages, llen, work->pageofs,
+		z_erofs_onlinepage_endio);
+	if (err != -ENOTSUPP)
+		goto out_percpu;
+
+#ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
+	if (sparsemem_pages >= nr_pages) {
+		BUG_ON(sparsemem_pages > nr_pages);
+		goto skip_allocpage;
+	}
+#endif
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (pages[i] != NULL)
+			continue;
+
+		pages[i] = __stagingpage_alloc(page_pool, GFP_NOFS);
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
+		DBG_BUGON(page->mapping == NULL);
+
+		/* recycle all individual staging pages */
+		if (z_erofs_gather_if_stagingpage(page_pool, page))
+			continue;
+
+		if (unlikely(err < 0))
+			SetPageError(page);
+
+		z_erofs_onlinepage_endio(page);
+	}
+
+out_percpu:
+	for (i = 0; i < clusterpages; ++i) {
+		page = compressed_pages[i];
+
+		/* recycle all individual staging pages */
+		(void)z_erofs_gather_if_stagingpage(page_pool, page);
+
+		WRITE_ONCE(compressed_pages[i], NULL);
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
+	/* all work locks MUST be taken before the following line */
+
+	WRITE_ONCE(grp->next, Z_EROFS_VLE_WORKGRP_NIL);
+
+	/* all work locks SHOULD be released right now */
+	mutex_unlock(&work->lock);
+
+	z_erofs_vle_work_release(work);
+	return err;
+}
+
+static void z_erofs_vle_unzip_all(struct super_block *sb,
+				  struct z_erofs_vle_unzip_io *io,
+				  struct list_head *page_pool)
+{
+	z_erofs_vle_owned_workgrp_t owned = io->head;
+
+	while (owned != Z_EROFS_VLE_WORKGRP_TAIL_CLOSED) {
+		struct z_erofs_vle_workgroup *grp;
+
+		/* no possible that 'owned' equals Z_EROFS_WORK_TPTR_TAIL */
+		DBG_BUGON(owned == Z_EROFS_VLE_WORKGRP_TAIL);
+
+		/* no possible that 'owned' equals NULL */
+		DBG_BUGON(owned == Z_EROFS_VLE_WORKGRP_NIL);
+
+		grp = owned;
+		owned = READ_ONCE(grp->next);
+
+		z_erofs_vle_unzip(sb, grp, page_pool);
+	};
+}
+
+static void z_erofs_vle_unzip_wq(struct work_struct *work)
+{
+	struct z_erofs_vle_unzip_io_sb *iosb = container_of(work,
+		struct z_erofs_vle_unzip_io_sb, io.u.work);
+	LIST_HEAD(page_pool);
+
+	BUG_ON(iosb->io.head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+	z_erofs_vle_unzip_all(iosb->sb, &iosb->io, &page_pool);
+
+	put_pages_list(&page_pool);
+	kvfree(iosb);
+}
+
+static inline struct z_erofs_vle_unzip_io *
+prepare_io_handler(struct super_block *sb,
+		   struct z_erofs_vle_unzip_io *io,
+		   bool background)
+{
+	struct z_erofs_vle_unzip_io_sb *iosb;
+
+	if (!background) {
+		/* waitqueue available for foreground io */
+		BUG_ON(io == NULL);
+
+		init_waitqueue_head(&io->u.wait);
+		atomic_set(&io->pending_bios, 0);
+		goto out;
+	}
+
+	if (io != NULL)
+		BUG();
+	else {
+		/* allocate extra io descriptor for background io */
+		iosb = kvzalloc(sizeof(struct z_erofs_vle_unzip_io_sb),
+			GFP_KERNEL | __GFP_NOFAIL);
+		BUG_ON(iosb == NULL);
+
+		io = &iosb->io;
+	}
+
+	iosb->sb = sb;
+	INIT_WORK(&io->u.work, z_erofs_vle_unzip_wq);
+out:
+	io->head = Z_EROFS_VLE_WORKGRP_TAIL_CLOSED;
+	return io;
+}
+
+#define __FSIO_1 0
+
+static bool z_erofs_vle_submit_all(struct super_block *sb,
+				   z_erofs_vle_owned_workgrp_t owned_head,
+				   struct list_head *pagepool,
+				   struct z_erofs_vle_unzip_io *fg_io,
+				   bool force_fg)
+{
+	struct erofs_sb_info *const sbi = EROFS_SB(sb);
+	const unsigned clusterpages = erofs_clusterpages(sbi);
+	const gfp_t gfp = GFP_NOFS;
+	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
+	struct bio *bio;
+	tagptr1_t bi_private;
+	/* since bio will be NULL, no need to initialize last_index */
+	pgoff_t uninitialized_var(last_index);
+	bool force_submit = false;
+	unsigned nr_bios;
+
+	if (unlikely(owned_head == Z_EROFS_VLE_WORKGRP_TAIL))
+		return false;
+
+	/*
+	 * force_fg == 1, (io, fg_io[0]) no io, (io, fg_io[1]) need submit io
+         * force_fg == 0, (io, fg_io[0]) no io; (io[1], bg_io) need submit io
+	 */
+	if (force_fg) {
+		ios[__FSIO_1] = prepare_io_handler(sb, fg_io + __FSIO_1, false);
+		bi_private = tagptr_fold(tagptr1_t, ios[__FSIO_1], 0);
+	} else {
+		ios[__FSIO_1] = prepare_io_handler(sb, NULL, true);
+		bi_private = tagptr_fold(tagptr1_t, ios[__FSIO_1], 1);
+	}
+
+	nr_bios = 0;
+	force_submit = false;
+	bio = NULL;
+
+	/* by default, all need io submission */
+	ios[__FSIO_1]->head = owned_head;
+
+	do {
+		struct z_erofs_vle_workgroup *grp;
+		struct page **compressed_pages, *oldpage, *page;
+		pgoff_t first_index;
+		unsigned i = 0;
+		int err;
+
+		/* no possible 'owned_head' equals the following */
+		DBG_BUGON(owned_head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+		DBG_BUGON(owned_head == Z_EROFS_VLE_WORKGRP_NIL);
+
+		grp = owned_head;
+
+		/* close the main owned chain at first */
+		owned_head = cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_TAIL,
+			Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+
+		first_index = grp->obj.index;
+		compressed_pages = grp->compressed_pages;
+
+		force_submit |= (first_index != last_index + 1);
+repeat:
+		/* fulfill all compressed pages */
+		oldpage = page = READ_ONCE(compressed_pages[i]);
+
+		if (page != NULL)
+			BUG_ON(PageUptodate(page));
+		else {
+			page = __stagingpage_alloc(pagepool, gfp);
+
+			if (oldpage != cmpxchg(compressed_pages + i,
+				oldpage, page)) {
+				list_add(&page->lru, pagepool);
+				goto repeat;
+			}
+		}
+
+		if (bio != NULL && force_submit) {
+submit_bio_retry:
+			__submit_bio(bio, REQ_OP_READ, 0);
+			bio = NULL;
+		}
+
+		if (bio == NULL) {
+			bio = prepare_bio(sb, first_index + i,
+				BIO_MAX_PAGES, z_erofs_vle_read_endio);
+			bio->bi_private = tagptr_cast_ptr(bi_private);
+
+			++nr_bios;
+		}
+
+		err = bio_add_page(bio, page, PAGE_SIZE, 0);
+		if (err < PAGE_SIZE)
+			goto submit_bio_retry;
+
+		force_submit = false;
+		last_index = first_index + i;
+		if (++i < clusterpages)
+			goto repeat;
+	} while (owned_head != Z_EROFS_VLE_WORKGRP_TAIL);
+
+	if (bio != NULL)
+		__submit_bio(bio, REQ_OP_READ, 0);
+
+	BUG_ON(!nr_bios);
+
+	z_erofs_vle_unzip_kickoff(tagptr_cast_ptr(bi_private), nr_bios);
+	return true;
+}
+
+static void z_erofs_submit_and_unzip(struct z_erofs_vle_frontend *f,
+				     struct list_head *pagepool,
+				     bool force_fg)
+{
+	struct super_block *sb = f->inode->i_sb;
+	struct z_erofs_vle_unzip_io io[1 + __FSIO_1];
+
+	if (!z_erofs_vle_submit_all(sb, f->owned_head, pagepool, io, force_fg))
+		return;
+
+	if (!force_fg)
+		return;
+
+	/* wait until all bios are completed */
+	wait_event(io[__FSIO_1].u.wait,
+		!atomic_read(&io[__FSIO_1].pending_bios));
+
+	/* let's synchronous decompression */
+	z_erofs_vle_unzip_all(sb, &io[__FSIO_1], pagepool);
+}
+
+static int z_erofs_vle_normalaccess_readpage(struct file *file,
+                                             struct page *page)
+{
+	struct inode *const inode = page->mapping->host;
+	struct z_erofs_vle_frontend f = VLE_FRONTEND_INIT(inode);
+	int err;
+	LIST_HEAD(pagepool);
+
+	err = z_erofs_do_read_page(&f, page, &pagepool);
+	(void)z_erofs_vle_work_iter_end(&f.builder);
+
+	if (err) {
+		errln("%s, failed to read, err [%d]", __func__, err);
+		goto out;
+	}
+
+	z_erofs_submit_and_unzip(&f, &pagepool, true);
+out:
+	if (f.m_iter.mpage != NULL)
+		put_page(f.m_iter.mpage);
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
+	struct inode *const inode = mapping->host;
+
+	struct z_erofs_vle_frontend f = VLE_FRONTEND_INIT(inode);
+	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
+	struct page *head = NULL;
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
+
+		err = z_erofs_do_read_page(&f, page, &pagepool);
+		if (err) {
+			struct erofs_vnode *vi = EROFS_V(inode);
+
+			errln("%s, readahead error at page %lu of nid %llu",
+				__func__, page->index, vi->nid);
+		}
+
+		put_page(page);
+	}
+
+	(void)z_erofs_vle_work_iter_end(&f.builder);
+
+	z_erofs_submit_and_unzip(&f, &pagepool, sync);
+
+	if (f.m_iter.mpage != NULL)
+		put_page(f.m_iter.mpage);
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
+const struct address_space_operations z_erofs_vle_normalaccess_aops = {
+	.readpage = z_erofs_vle_normalaccess_readpage,
+	.readpages = z_erofs_vle_normalaccess_readpages,
+};
 
 #define __vle_cluster_advise(x, bit, bits) \
 	((le16_to_cpu(x) >> (bit)) & ((1 << (bits)) - 1))
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index b34f5bc..2388a09 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -14,9 +14,213 @@
 #define __EROFS_FS_UNZIP_VLE_H
 
 #include "internal.h"
+#include "unzip_pagevec.h"
+
+/*
+ *  - 0x5FA11OC8D ('fsallocated', Z_EROFS_MAPPING_STAGING) -
+ * used for temporary allocated pages (via erofs_allocpage),
+ * in order to seperate those from NULL mapping (eg. truncated pages)
+ */
+#define Z_EROFS_MAPPING_STAGING		((void *)0x5FA110C8D)
+
+#define z_erofs_is_stagingpage(page)	\
+	((page)->mapping == Z_EROFS_MAPPING_STAGING)
+
+static inline bool z_erofs_gather_if_stagingpage(struct list_head *page_pool,
+						 struct page *page)
+{
+	if (z_erofs_is_stagingpage(page)) {
+		list_add(&page->lru, page_pool);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Structure fields follow one of the following exclusion rules.
+ *
+ * I: Modifiable by initialization/destruction paths and read-only
+ *    for everyone else.
+ *
+ */
 
 #define Z_EROFS_VLE_INLINE_PAGEVECS     3
 
+struct z_erofs_vle_work {
+	/* struct z_erofs_vle_work *left, *right; */
+
+#ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
+	struct list_head list;
+
+	atomic_t refcount;
+#endif
+	struct mutex lock;
+
+	/* I: decompression offset in page */
+	unsigned short pageofs;
+	unsigned short nr_pages;
+
+	/* L: queued pages in pagevec[] */
+	unsigned vcnt;
+
+	union {
+		/* L: pagevec */
+		erofs_vtptr_t pagevec[Z_EROFS_VLE_INLINE_PAGEVECS];
+		struct rcu_head rcu;
+	};
+};
+
+#define Z_EROFS_VLE_WORKGRP_FMT_PLAIN        0
+#define Z_EROFS_VLE_WORKGRP_FMT_LZ4          1
+#define Z_EROFS_VLE_WORKGRP_FMT_MASK         1
+
+typedef struct z_erofs_vle_workgroup *z_erofs_vle_owned_workgrp_t;
+
+struct z_erofs_vle_workgroup {
+	struct erofs_workgroup obj;
+	struct z_erofs_vle_work work;
+
+	/* next owned workgroup */
+	z_erofs_vle_owned_workgrp_t next;
+
+	/* compressed pages (including multi-usage pages) */
+	struct page *compressed_pages[Z_EROFS_CLUSTER_MAX_PAGES];
+	unsigned int llen, flags;
+};
+
+/* let's avoid the valid 32-bit kernel addresses */
+
+/* the chained workgroup has't submitted io (still open) */
+#define Z_EROFS_VLE_WORKGRP_TAIL        ((void *)0x5F0ECAFE)
+/* the chained workgroup has already submitted io */
+#define Z_EROFS_VLE_WORKGRP_TAIL_CLOSED ((void *)0x5F0EDEAD)
+
+#define Z_EROFS_VLE_WORKGRP_NIL         (NULL)
+
+#define z_erofs_vle_workgrp_fmt(grp)	\
+	((grp)->flags & Z_EROFS_VLE_WORKGRP_FMT_MASK)
+
+static inline void z_erofs_vle_set_workgrp_fmt(
+	struct z_erofs_vle_workgroup *grp,
+	unsigned int fmt)
+{
+	grp->flags = fmt | (grp->flags & ~Z_EROFS_VLE_WORKGRP_FMT_MASK);
+}
+
+#ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
+#error multiref decompression is unimplemented yet
+#else
+
+#define z_erofs_vle_grab_primary_work(grp)	(&(grp)->work)
+#define z_erofs_vle_grab_work(grp, pageofs)	(&(grp)->work)
+#define z_erofs_vle_work_workgroup(wrk, primary)	\
+	((primary) ? container_of(wrk,	\
+		struct z_erofs_vle_workgroup, work) : \
+		({ BUG(); (void *)NULL; }))
+
+#endif
+
+#define Z_EROFS_WORKGROUP_SIZE       sizeof(struct z_erofs_vle_workgroup)
+
+struct z_erofs_vle_unzip_io {
+	atomic_t pending_bios;
+	z_erofs_vle_owned_workgrp_t head;
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
+	min(THREAD_SIZE / 8 / sizeof(struct page *), 96UL)
+#define Z_EROFS_VLE_VMAP_GLOBAL_PAGES	2048
+
 /* unzip_vle_lz4.c */
 extern int z_erofs_vle_plain_copy(struct page **compressed_pages,
 	unsigned clusterpages, struct page **pages,
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 035cbd7..df4aadd 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -12,6 +12,7 @@
  */
 
 #include "internal.h"
+#include <linux/pagevec.h>
 
 struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 {
@@ -98,11 +99,69 @@ int erofs_register_workgroup(struct super_block *sb,
 	return err;
 }
 
+extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
+
+int erofs_workgroup_put(struct erofs_workgroup *grp)
+{
+	int count = atomic_dec_return(&grp->refcount);
+
+	if (count == 1)
+		atomic_long_inc(&erofs_global_shrink_cnt);
+	else if (!count) {
+		atomic_long_dec(&erofs_global_shrink_cnt);
+		erofs_workgroup_free_rcu(grp);
+	}
+	return count;
+}
+
 unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 				       unsigned long nr_shrink,
 				       bool cleanup)
 {
-	return 0;
+	pgoff_t first_index = 0;
+	void *batch[PAGEVEC_SIZE];
+	unsigned freed = 0;
+
+	int i, found;
+repeat:
+	erofs_workstn_lock(sbi);
+
+	found = radix_tree_gang_lookup(&sbi->workstn.tree,
+		batch, first_index, PAGEVEC_SIZE);
+
+	for (i = 0; i < found; ++i) {
+		int cnt;
+		struct erofs_workgroup *grp = (void *)
+			((unsigned long)batch[i] &
+				~RADIX_TREE_EXCEPTIONAL_ENTRY);
+
+		first_index = grp->index + 1;
+
+		cnt = atomic_read(&grp->refcount);
+		BUG_ON(cnt <= 0);
+
+		if (cleanup)
+			BUG_ON(cnt != 1);
+
+		else if (cnt > 1)
+			continue;
+
+		if (radix_tree_delete(&sbi->workstn.tree,
+			grp->index) != grp)
+			continue;
+
+		/* (rarely) grabbed again when freeing */
+		erofs_workgroup_put(grp);
+
+		++freed;
+		if (unlikely(!--nr_shrink))
+			break;
+	}
+	erofs_workstn_unlock(sbi);
+
+	if (i && nr_shrink)
+		goto repeat;
+	return freed;
 }
 
 #endif
-- 
1.9.1
