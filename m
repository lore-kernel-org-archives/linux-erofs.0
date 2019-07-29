From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:56 +0800
Subject: [PATCH 19/22] staging: erofs: tidy up utils.c
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-20-gaoxiang25@huawei.com>

keep in line with erofs-outofstaging patchset:
 - Update comments in erofs_try_to_release_workgroup;
 - code style cleanup.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/utils.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 0e6308b15717..814c2ee037ae 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -114,8 +114,7 @@ int erofs_register_workgroup(struct super_block *sb,
 	 */
 	__erofs_workgroup_get(grp);
 
-	err = radix_tree_insert(&sbi->workstn_tree,
-				grp->index, grp);
+	err = radix_tree_insert(&sbi->workstn_tree, grp->index, grp);
 	if (unlikely(err))
 		/*
 		 * it's safe to decrease since the workgroup isn't visible
@@ -156,18 +155,18 @@ static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
 					   bool cleanup)
 {
 	/*
-	 * for managed cache enabled, the refcount of workgroups
-	 * themselves could be < 0 (freezed). So there is no guarantee
-	 * that all refcount > 0 if managed cache is enabled.
+	 * If managed cache is on, refcount of workgroups
+	 * themselves could be < 0 (freezed). In other words,
+	 * there is no guarantee that all refcounts > 0.
 	 */
 	if (!erofs_workgroup_try_to_freeze(grp, 1))
 		return false;
 
 	/*
-	 * note that all cached pages should be unlinked
-	 * before delete it from the radix tree.
-	 * Otherwise some cached pages of an orphan old workgroup
-	 * could be still linked after the new one is available.
+	 * Note that all cached pages should be unattached
+	 * before deleted from the radix tree. Otherwise some
+	 * cached pages could be still attached to the orphan
+	 * old workgroup when the new one is available in the tree.
 	 */
 	if (erofs_try_to_free_all_cached_pages(sbi, grp)) {
 		erofs_workgroup_unfreeze(grp, 1);
@@ -175,7 +174,7 @@ static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
 	}
 
 	/*
-	 * it is impossible to fail after the workgroup is freezed,
+	 * It's impossible to fail after the workgroup is freezed,
 	 * however in order to avoid some race conditions, add a
 	 * DBG_BUGON to observe this in advance.
 	 */
@@ -183,8 +182,8 @@ static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
 						     grp->index)) != grp);
 
 	/*
-	 * if managed cache is enable, the last refcount
-	 * should indicate the related workstation.
+	 * If managed cache is on, last refcount should indicate
+	 * the related workstation.
 	 */
 	erofs_workgroup_unfreeze_final(grp);
 	return true;
@@ -273,9 +272,9 @@ static unsigned long erofs_shrink_scan(struct shrinker *shrink,
 	unsigned long freed = 0;
 
 	spin_lock(&erofs_sb_list_lock);
-	do
+	do {
 		run_no = ++shrinker_run_no;
-	while (run_no == 0);
+	} while (run_no == 0);
 
 	/* Iterate over all mounted superblocks and try to shrink them */
 	p = erofs_sb_list.next;
-- 
2.17.1
