From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 30 Jul 2018 11:34:53 +0800
Subject: [FOR INTERNAL REVIEW] [PATCH RESEND 2/3] staging: erofs: add 'erofs_'
 prefixes for try_to_free_(all_)cached_page(s)
In-Reply-To: <1532921694-23526-1-git-send-email-gaoxiang25@huawei.com>
References: <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
 <1532921694-23526-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532921694-23526-2-git-send-email-gaoxiang25@huawei.com>

From: Gao Xiang <hsiangkao@aol.com>

This patch also fixes out-of-date code snippets due to spilt code
into small patches by mistake.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
RESEND:
 - spilt into two patches according to Chao's suggestion

 drivers/staging/erofs/internal.h  | 4 ++--
 drivers/staging/erofs/super.c     | 2 +-
 drivers/staging/erofs/unzip_vle.c | 7 ++++---
 drivers/staging/erofs/utils.c     | 2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 669f93a..367b39f 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -260,9 +260,9 @@ static inline void erofs_workstation_cleanup_all(struct super_block *sb)
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 #define EROFS_UNALLOCATED_CACHED_PAGE	((void *)0x5F0EF00D)
 
-extern int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
+extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	struct erofs_workgroup *egrp);
-extern int try_to_free_cached_page(struct address_space *mapping,
+extern int erofs_try_to_free_cached_page(struct address_space *mapping,
 	struct page *page);
 #endif
 
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 97da5c8..1aec509 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -269,7 +269,7 @@ static int managed_cache_releasepage(struct page *page, gfp_t gfp_mask)
 	BUG_ON(mapping->a_ops != &managed_cache_aops);
 
 	if (PagePrivate(page))
-		ret = try_to_free_cached_page(mapping, page);
+		ret = erofs_try_to_free_cached_page(mapping, page);
 
 	return ret;
 }
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 7671fe8..0e410a2 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -131,8 +131,8 @@ static bool grab_managed_cache_pages(struct address_space *mapping,
 }
 
 /* called by erofs_shrinker to get rid of all compressed_pages */
-int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
-				 struct erofs_workgroup *egrp)
+int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
+				       struct erofs_workgroup *egrp)
 {
 	struct z_erofs_vle_workgroup *const grp =
 		container_of(egrp, struct z_erofs_vle_workgroup, obj);
@@ -166,7 +166,8 @@ int try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	return 0;
 }
 
-int try_to_free_cached_page(struct address_space *mapping, struct page *page)
+int erofs_try_to_free_cached_page(struct address_space *mapping,
+				  struct page *page)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(mapping->host->i_sb);
 	const unsigned int clusterpages = erofs_clusterpages(sbi);
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 1d06b5f..595cf90 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -160,7 +160,7 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		}
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (try_to_free_all_cached_pages(sbi, grp))
+		if (erofs_try_to_free_all_cached_pages(sbi, grp))
 			goto skip;
 
 		erofs_workgroup_unfreeze(grp, 1);
-- 
1.9.1
