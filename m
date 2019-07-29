From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:42 +0800
Subject: [PATCH 05/22] staging: erofs: sunset erofs_workstn_{lock,unlock}
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-6-gaoxiang25@huawei.com>

It was used for Linux backward compatibility, and no use
for upstream kernel.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h |  3 ---
 drivers/staging/erofs/utils.c    | 10 +++++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 501429ec0f91..ed487ee56f74 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -179,9 +179,6 @@ static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
 #define test_opt(sbi, option)	((sbi)->mount_opt & EROFS_MOUNT_##option)
 
 #ifdef CONFIG_EROFS_FS_ZIP
-#define erofs_workstn_lock(sbi)         xa_lock(&(sbi)->workstn_tree)
-#define erofs_workstn_unlock(sbi)       xa_unlock(&(sbi)->workstn_tree)
-
 /* basic unit of the workstation of a super_block */
 struct erofs_workgroup {
 	/* the workgroup index in the workstation */
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index a68dbe375fa0..024806003297 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -102,14 +102,14 @@ int erofs_register_workgroup(struct super_block *sb,
 		return err;
 
 	sbi = EROFS_SB(sb);
-	erofs_workstn_lock(sbi);
+	xa_lock(&sbi->workstn_tree);
 
 	grp = xa_tag_pointer(grp, tag);
 
 	/*
 	 * Bump up reference count before making this workgroup
 	 * visible to other users in order to avoid potential UAF
-	 * without serialized by erofs_workstn_lock.
+	 * without serialized by workstn_lock.
 	 */
 	__erofs_workgroup_get(grp);
 
@@ -122,7 +122,7 @@ int erofs_register_workgroup(struct super_block *sb,
 		 */
 		__erofs_workgroup_put(grp);
 
-	erofs_workstn_unlock(sbi);
+	xa_unlock(&sbi->workstn_tree);
 	radix_tree_preload_end();
 	return err;
 }
@@ -225,7 +225,7 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 
 	int i, found;
 repeat:
-	erofs_workstn_lock(sbi);
+	xa_lock(&sbi->workstn_tree);
 
 	found = radix_tree_gang_lookup(&sbi->workstn_tree,
 				       batch, first_index, PAGEVEC_SIZE);
@@ -243,7 +243,7 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		if (unlikely(!--nr_shrink))
 			break;
 	}
-	erofs_workstn_unlock(sbi);
+	xa_unlock(&sbi->workstn_tree);
 
 	if (i && nr_shrink)
 		goto repeat;
-- 
2.17.1
