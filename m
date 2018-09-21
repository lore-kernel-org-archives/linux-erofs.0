From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 21 Sep 2018 11:43:34 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 2/3] staging: erofs: fix race when
 the managed cache is enabled
In-Reply-To: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1537501415-70936-2-git-send-email-gaoxiang25@huawei.com>

When the managed cache is enabled, the last reference count
of a workgroup must be used for its workstation.

Otherwise, it could lead to incorrect (un)freezes in
the reclaim path, and it would be harmful.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/utils.c | 131 ++++++++++++++++++++++++++++++------------
 1 file changed, 95 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index ddd220a..8ef13c8 100644
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
@@ -101,19 +117,90 @@ int erofs_register_workgroup(struct super_block *sb,
 
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
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+
+static void erofs_workgroup_unfreeze_final(struct erofs_workgroup *grp)
+{
+	erofs_workgroup_unfreeze(grp, 0);
+	__erofs_workgroup_free(grp);
+}
+
+bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
+				    struct erofs_workgroup *grp,
+				    bool cleanup)
+{
+	/*
+	 * for managed cache enabled, the refcount of workgroups
+	 * themselves could be < 0 (freezed). So there is no guarantee
+	 * that all refcount > 0 if managed cache is enabled.
+	 */
+	if (!erofs_workgroup_try_to_freeze(grp, 1))
+		return false;
+
+	/*
+	 * note that all cached pages should be unlinked
+	 * before delete it from the radix tree.
+	 * Otherwise some cached pages of an orphan old workgroup
+	 * could be still linked after the new one is available.
+	 */
+	if (erofs_try_to_free_all_cached_pages(sbi, grp)) {
+		erofs_workgroup_unfreeze(grp, 1);
+		return false;
+	}
+
+	/* it is impossible to fail after we freeze the workgroup */
+	if (radix_tree_delete(&sbi->workstn_tree, grp->index) != grp)
+		BUG();	/* should never happen */
+
+	/*
+	 * if managed cache is enable, the last refcount
+	 * should indicate the related workstation.
+	 */
+	erofs_workgroup_unfreeze_final(grp);
+	return true;
+}
+
+#else
+
+bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
+				    struct erofs_workgroup *grp,
+				    bool cleanup)
+{
+	int cnt = atomic_read(&grp->refcount);
+
+	DBG_BUGON(cnt <= 0);
+	DBG_BUGON(cleanup && cnt != 1);
+
+	if (cnt > 1)
+		return false;
+
+	if (radix_tree_delete(&sbi->workstn_tree, grp->index) != grp)
+		return false;
+
+	/* (rarely) could be grabbed again when freeing */
+	erofs_workgroup_put(grp);
+	return true;
+}
+
+#endif
+
 unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 				       unsigned long nr_shrink,
 				       bool cleanup)
@@ -130,43 +217,15 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		batch, first_index, PAGEVEC_SIZE);
 
 	for (i = 0; i < found; ++i) {
-		int cnt;
 		struct erofs_workgroup *grp = (void *)
 			((unsigned long)batch[i] &
 				~RADIX_TREE_EXCEPTIONAL_ENTRY);
 
 		first_index = grp->index + 1;
 
-		cnt = atomic_read(&grp->refcount);
-		BUG_ON(cnt <= 0);
-
-		if (cleanup)
-			BUG_ON(cnt != 1);
-
-#ifndef EROFS_FS_HAS_MANAGED_CACHE
-		else if (cnt > 1)
-#else
-		if (!erofs_workgroup_try_to_freeze(grp, 1))
-#endif
-			continue;
-
-		if (radix_tree_delete(&sbi->workstn_tree,
-			grp->index) != grp) {
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-skip:
-			erofs_workgroup_unfreeze(grp, 1);
-#endif
+		/* try to shrink each workgroup */
+		if (!erofs_try_to_release_workgroup(sbi, grp, cleanup))
 			continue;
-		}
-
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (erofs_try_to_free_all_cached_pages(sbi, grp))
-			goto skip;
-
-		erofs_workgroup_unfreeze(grp, 1);
-#endif
-		/* (rarely) grabbed again when freeing */
-		erofs_workgroup_put(grp);
 
 		++freed;
 		if (unlikely(!--nr_shrink))
-- 
1.9.1
