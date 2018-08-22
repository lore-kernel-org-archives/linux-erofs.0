From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 22 Aug 2018 19:09:23 +0800
Subject: [WIP] [PREVIEW] [RFC PATCH 2/3] staging: erofs: introduce
 MNGD_MAPPING to wrap up
In-Reply-To: <1534936164-112151-1-git-send-email-gaoxiang25@huawei.com>
References: <1534936164-112151-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1534936164-112151-2-git-send-email-gaoxiang25@huawei.com>

This patch introduces MNGD_MAPPING to wrap up
sbi->managed_cache->i_mapping.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h  |  5 +++++
 drivers/staging/erofs/unzip_vle.c | 11 +++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index cf0774a..15d45c5 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -263,6 +263,11 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 #define EROFS_UNALLOCATED_CACHED_PAGE	((void *)0x5F0EF00D)
 
+static inline struct address_space *MNGD_MAPPING(struct erofs_sb_info *sbi)
+{
+	return sbi->managed_cache->i_mapping;
+}
+
 extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	struct erofs_workgroup *egrp);
 extern int erofs_try_to_free_cached_page(struct address_space *mapping,
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index eae9be1..a8b86717 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -138,7 +138,7 @@ int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 {
 	struct z_erofs_vle_workgroup *const grp =
 		container_of(egrp, struct z_erofs_vle_workgroup, obj);
-	struct address_space *const mapping = sbi->managed_cache->i_mapping;
+	struct address_space *const mapping = MNGD_MAPPING(sbi);
 	const int clusterpages = erofs_clusterpages(sbi);
 	int i;
 
@@ -591,7 +591,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	struct z_erofs_vle_work *work = builder->work;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+	struct address_space *const mngda = MNGD_MAPPING(sbi);
 	struct z_erofs_vle_workgroup *grp;
 	bool noio_outoforder;
 #endif
@@ -748,9 +748,8 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 		if (unlikely(mngda == NULL && !z_erofs_is_stagingpage(page))) {
 			struct inode *const inode = page->mapping->host;
-			struct super_block *const sb = inode->i_sb;
 
-			mngda = EROFS_SB(sb)->managed_cache->i_mapping;
+			mngda = MNGD_MAPPING(EROFS_I_SB(inode));
 		}
 
 		/*
@@ -782,7 +781,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+	struct address_space *const mngda = MNGD_MAPPING(sbi);
 #endif
 	const unsigned clusterpages = erofs_clusterpages(sbi);
 
@@ -1085,7 +1084,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	const unsigned clusterpages = erofs_clusterpages(sbi);
 	const gfp_t gfp = GFP_NOFS;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+	struct address_space *const mngda = MNGD_MAPPING(sbi);
 	struct z_erofs_vle_workgroup *lstgrp_noio = NULL, *lstgrp_io = NULL;
 #endif
 	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
-- 
1.9.1
