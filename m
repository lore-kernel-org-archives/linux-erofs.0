From: jeremy@azazel.net (Jeremy Sowden)
Date: Mon,  7 Jan 2019 18:25:16 +0000
Subject: [PATCH 2/2] staging: erofs: fixed -Wmissing-prototype warnings.
In-Reply-To: <20190107182516.21511-1-jeremy@azazel.net>
References: <20190107182516.21511-1-jeremy@azazel.net>
Message-ID: <20190107182516.21511-3-jeremy@azazel.net>

Moved prototypes for two functions to header file in order to fix the
following warnings:

  drivers/staging/erofs/unzip_vle.c:577:6: warning: no previous prototype for ?erofs_workgroup_free_rcu? [-Wmissing-prototypes]
   void erofs_workgroup_free_rcu(struct erofs_workgroup *grp)
        ^~~~~~~~~~~~~~~~~~~~~~~~

  drivers/staging/erofs/unzip_vle.c:1702:5: warning: no previous prototype for ?z_erofs_map_blocks_iter? [-Wmissing-prototypes]
   int z_erofs_map_blocks_iter(struct inode *inode,
       ^~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Jeremy Sowden <jeremy at azazel.net>
---
 drivers/staging/erofs/data.c     | 6 ------
 drivers/staging/erofs/internal.h | 7 +++++++
 drivers/staging/erofs/utils.c    | 2 --
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 5a55f0bfdfbb..329fa4fa3e9c 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -165,12 +165,6 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 	return err;
 }
 
-#ifdef CONFIG_EROFS_FS_ZIP
-extern int z_erofs_map_blocks_iter(struct inode *,
-				   struct erofs_map_blocks *,
-				   struct page **, int);
-#endif
-
 int erofs_map_blocks_iter(struct inode *inode,
 			  struct erofs_map_blocks *map,
 			  struct page **mpage_ret, int flags)
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 49c587383315..192f4028d85d 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -288,6 +288,8 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
 	erofs_shrink_workstation(EROFS_SB(sb), ~0UL, true);
 }
 
+extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
+
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	struct erofs_workgroup *egrp);
@@ -530,6 +532,11 @@ struct erofs_map_blocks_iter {
 	struct page *mpage;
 };
 
+#ifdef CONFIG_EROFS_FS_ZIP
+extern int z_erofs_map_blocks_iter(struct inode *,
+				   struct erofs_map_blocks *,
+				   struct page **, int);
+#endif
 
 static inline struct page *
 erofs_get_inline_page(struct inode *inode,
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index fc30025ef101..aed211cd5875 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -104,8 +104,6 @@ int erofs_register_workgroup(struct super_block *sb,
 	return err;
 }
 
-extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
-
 static void  __erofs_workgroup_free(struct erofs_workgroup *grp)
 {
 	atomic_long_dec(&erofs_global_shrink_cnt);
-- 
2.20.1
