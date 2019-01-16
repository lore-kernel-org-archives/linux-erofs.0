From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 16:59:52 +0800
Subject: [PATCH 1/5] staging: erofs: sunset erofs_workstation_cleanup_all
Message-ID: <20190116085956.21004-1-gaoxiang25@huawei.com>

There is only one user calling erofs_workstation_cleanup_all,
and it is no likely that more users will use in that way
in the future.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
Hi,

 These 5 patches are all cleanup patches, no logic change.

Thanks,
Gao Xiang

 drivers/staging/erofs/internal.h | 5 -----
 drivers/staging/erofs/super.c    | 3 ++-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index c3de24e7fb67..80cc09ea787d 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -283,11 +283,6 @@ extern int erofs_register_workgroup(struct super_block *sb,
 extern unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 	unsigned long nr_shrink, bool cleanup);
 
-static inline void erofs_workstation_cleanup_all(struct super_block *sb)
-{
-	erofs_shrink_workstation(EROFS_SB(sb), ~0UL, true);
-}
-
 extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 45c7f6ddb9f5..69e1840d3842 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -494,7 +494,8 @@ static void erofs_put_super(struct super_block *sb)
 	mutex_lock(&sbi->umount_mutex);
 
 #ifdef CONFIG_EROFS_FS_ZIP
-	erofs_workstation_cleanup_all(sb);
+	/* clean up the compression space of this sb */
+	erofs_shrink_workstation(EROFS_SB(sb), ~0UL, true);
 #endif
 
 	erofs_unregister_super(sb);
-- 
2.14.4
