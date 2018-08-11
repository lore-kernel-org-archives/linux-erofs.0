From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 11:09:57 +0800
Subject: [NOMERGE] [WIP] [PREVIEW] [PATCH 4/4] staging: erofs: fix race when
 the managed cache is enabled
In-Reply-To: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
References: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533956997-106704-4-git-send-email-gaoxiang25@huawei.com>

When the managed cache is enabled, the last reference count
of a workgroup should be used for its workstation.

Otherwise, (un)freeze in the reclaim path will work improperly.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/utils.c | 57 +++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 8f1875c..8f45ebb 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -87,12 +87,28 @@ int erofs_register_workgroup(struct super_block *sb,
 		grp = (void *)((unsigned long)grp |
 			1UL << RADIX_TREE_EXCEPTIONAL_SHIFT);
 
+	/*
+	 * If managed cache is enabled, the reclaim path assumes
+	 * that the last reference count is used for its workstation.
+	 * Therefore we should bump up reference count before
+	 * making this workgroup visible to other users.
+	 */
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	/* refcount should be at least 2 to get on well with reclaim path */
+	__erofs_workgroup_get(grp);
+#endif
+
 	err = radix_tree_insert(&sbi->workstn_tree,
 		grp->index, grp);
 
-	if (!err) {
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	if (unlikely(err))
+		/* it is safe to decrease for refcount >= 2 */
+		atomic_dec(&grp->refcount);
+#else
+	if (!err)
 		__erofs_workgroup_get(grp);
-	}
+#endif
 
 	erofs_workstn_unlock(sbi);
 	radix_tree_preload_end();
@@ -101,19 +117,29 @@ int erofs_register_workgroup(struct super_block *sb,
 
 extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
 
+static void  __erofs_workgroup_free(struct erofs_workgroup *grp)
+{
+	atomic_long_dec(&erofs_global_shrink_cnt);
+	erofs_workgroup_free_rcu(grp);
+}
+
 int erofs_workgroup_put(struct erofs_workgroup *grp)
 {
 	int count = atomic_dec_return(&grp->refcount);
 
 	if (count == 1)
 		atomic_long_inc(&erofs_global_shrink_cnt);
-	else if (!count) {
-		atomic_long_dec(&erofs_global_shrink_cnt);
-		erofs_workgroup_free_rcu(grp);
-	}
+	else if (!count)
+		__erofs_workgroup_free(grp);
 	return count;
 }
 
+static void erofs_workgroup_unfreeze_final(struct erofs_workgroup *grp)
+{
+	erofs_workgroup_unfreeze(grp, 0);
+	__erofs_workgroup_free(grp);
+}
+
 unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 				       unsigned long nr_shrink,
 				       bool cleanup)
@@ -130,20 +156,21 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		batch, first_index, PAGEVEC_SIZE);
 
 	for (i = 0; i < found; ++i) {
+#ifndef EROFS_FS_HAS_MANAGED_CACHE
 		int cnt;
+#endif
 		struct erofs_workgroup *grp = (void *)
 			((unsigned long)batch[i] &
 				~RADIX_TREE_EXCEPTIONAL_ENTRY);
 
 		first_index = grp->index + 1;
 
+#ifndef EROFS_FS_HAS_MANAGED_CACHE
 		cnt = atomic_read(&grp->refcount);
-		BUG_ON(cnt <= 0);
+		DBG_BUGON(cnt <= 0);
 
 		if (cleanup)
-			BUG_ON(cnt != 1);
-
-#ifndef EROFS_FS_HAS_MANAGED_CACHE
+			DBG_BUGON(cnt != 1);
 		else if (cnt > 1)
 #else
 		if (!erofs_workgroup_try_to_freeze(grp, 1))
@@ -163,11 +190,15 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		if (erofs_try_to_free_all_cached_pages(sbi, grp))
 			goto skip;
 
-		erofs_workgroup_unfreeze(grp, 1);
-#endif
+		/*
+		 * if managed cache is enable, the last refcount
+		 * should indicate the related workstation.
+		 */
+		erofs_workgroup_unfreeze_final(grp);
+#else
 		/* (rarely) grabbed again when freeing */
 		erofs_workgroup_put(grp);
-
+#endif
 		++freed;
 		if (unlikely(!--nr_shrink))
 			break;
-- 
1.9.1
