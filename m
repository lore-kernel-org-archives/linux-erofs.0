From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 5 Jul 2018 16:44:09 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.5 09/10] erofs: introduce workstation
 for decompression
In-Reply-To: <1530780250-77563-1-git-send-email-gaoxiang25@huawei.com>
References: <1530780087-76872-1-git-send-email-gaoxiang25@huawei.com>
 <1530780250-77563-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530780250-77563-5-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/internal.h | 60 ++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/super.c    | 12 +++++++++
 fs/erofs/utils.c    | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index e202ef3..489cd4e 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -80,6 +80,14 @@ struct erofs_sb_info {
 #ifdef CONFIG_EROFS_FS_ZIP
 	/* cluster size in bit shift */
 	unsigned char clusterbits;
+
+	/* the dedicated workstation for compression */
+	struct {
+		struct radix_tree_root tree;
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+		spinlock_t lock;
+#endif
+	} workstn;
 #endif
 
 	u32 build_time_nsec;
@@ -150,6 +158,58 @@ static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
 #define set_opt(sbi, option)	((sbi)->mount_opt |= EROFS_MOUNT_##option)
 #define test_opt(sbi, option)	((sbi)->mount_opt & EROFS_MOUNT_##option)
 
+#ifdef CONFIG_EROFS_FS_ZIP
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+#define erofs_workstn_lock(sbi)         spin_lock(&(sbi)->workstn.lock)
+#define erofs_workstn_unlock(sbi)       spin_unlock(&(sbi)->workstn.lock)
+#else
+#define erofs_workstn_lock(sbi)         xa_lock(&(sbi)->workstn.tree)
+#define erofs_workstn_unlock(sbi)       xa_unlock(&(sbi)->workstn.tree)
+#endif
+
+/* basic unit of the workstation of a super_block */
+struct erofs_workgroup {
+	/* the workgroup index in the workstation */
+	pgoff_t index;
+
+	/* overall workgroup reference count */
+	atomic_t refcount;
+};
+
+static inline bool erofs_workgroup_get(struct erofs_workgroup *grp)
+{
+	int o;
+
+repeat:
+	o = atomic_read(&grp->refcount);
+
+	if (unlikely(o <= 0))
+		return -1;
+
+	if (unlikely(atomic_cmpxchg(&grp->refcount, o, o + 1) != o))
+		goto repeat;
+
+	return 0;
+}
+
+#define __erofs_workgroup_get(grp)	atomic_inc(&(grp)->refcount)
+
+extern struct erofs_workgroup *erofs_find_workgroup(
+	struct super_block *sb, pgoff_t index, bool *tag);
+
+extern int erofs_register_workgroup(struct super_block *sb,
+	struct erofs_workgroup *grp, bool tag);
+
+extern unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
+	unsigned long nr_shrink, bool cleanup);
+
+static inline void erofs_workstation_cleanup_all(struct super_block *sb)
+{
+	erofs_shrink_workstation(EROFS_SB(sb), ~0UL, true);
+}
+
+#endif
+
 /* we strictly follow PAGE_SIZE and no buffer head */
 #define LOG_BLOCK_SIZE		PAGE_SHIFT
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 9452a89..d26eeed 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -285,6 +285,13 @@ static int erofs_read_super(struct super_block *sb,
 	if (!silent)
 		infoln("root inode @ nid %llu", ROOT_NID(sbi));
 
+#ifdef CONFIG_EROFS_FS_ZIP
+	INIT_RADIX_TREE(&sbi->workstn.tree, GFP_ATOMIC);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0))
+	spin_lock_init(&sbi->workstn.lock);
+#endif
+#endif
+
 	/* get the root inode */
 	inode = erofs_iget(sb, ROOT_NID(sbi), true);
 	if (IS_ERR(inode)) {
@@ -355,6 +362,11 @@ static void erofs_put_super(struct super_block *sb)
 	__putname(sbi->dev_name);
 
 	mutex_lock(&sbi->umount_mutex);
+
+#ifdef CONFIG_EROFS_FS_ZIP
+	erofs_workstation_cleanup_all(sb);
+#endif
+
 	erofs_unregister_super(sb);
 	mutex_unlock(&sbi->umount_mutex);
 
diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index 6b8c60d..912be2a 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -29,6 +29,76 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 	return page;
 }
 
+/* global shrink count (for all mounted EROFS instances) */
+static atomic_long_t erofs_global_shrink_cnt;
+
+#ifdef CONFIG_EROFS_FS_ZIP
+
+/* radix_tree and the future XArray both don't use tagptr_t yet */
+struct erofs_workgroup *erofs_find_workgroup(
+	struct super_block *sb, pgoff_t index, bool *tag)
+{
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	struct erofs_workgroup *grp;
+
+repeat:
+	rcu_read_lock();
+	grp = radix_tree_lookup(&sbi->workstn.tree, index);
+	if (grp != NULL) {
+		*tag = radix_tree_exceptional_entry(grp);
+		grp = (void *)((unsigned long)grp &
+			~RADIX_TREE_EXCEPTIONAL_ENTRY);
+
+		if (erofs_workgroup_get(grp)) {
+			/* prefer to relax rcu read side */
+			rcu_read_unlock();
+			goto repeat;
+		}
+
+		BUG_ON(index != grp->index);
+	}
+	rcu_read_unlock();
+	return grp;
+}
+
+int erofs_register_workgroup(struct super_block *sb,
+			     struct erofs_workgroup *grp,
+			     bool tag)
+{
+	struct erofs_sb_info *sbi;
+	int err = radix_tree_preload(GFP_NOFS);
+
+	if (err)
+		return err;
+
+	sbi = EROFS_SB(sb);
+	erofs_workstn_lock(sbi);
+
+	if (tag)
+		grp = (void *)((unsigned long)grp |
+			1UL << RADIX_TREE_EXCEPTIONAL_SHIFT);
+
+	err = radix_tree_insert(&sbi->workstn.tree,
+		grp->index, grp);
+
+	if (!err) {
+		__erofs_workgroup_get(grp);
+		atomic_long_inc(&erofs_global_shrink_cnt);
+	}
+
+	erofs_workstn_unlock(sbi);
+	radix_tree_preload_end();
+	return err;
+}
+
+unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
+				       unsigned long nr_shrink,
+				       bool cleanup)
+{
+	return 0;
+}
+
+#endif
 
 /* protected by 'erofs_sb_list_lock' */
 static unsigned int shrinker_run_no;
@@ -108,6 +178,7 @@ unsigned long erofs_shrink_scan(struct shrinker *shrink,
 		list_move_tail(&sbi->list, &erofs_sb_list);
 		mutex_unlock(&sbi->umount_mutex);
 
+		freed += erofs_shrink_workstation(sbi, nr, false);
 		if (freed >= nr)
 			break;
 	}
-- 
1.9.1
