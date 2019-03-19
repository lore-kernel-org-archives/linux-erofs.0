From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 19 Mar 2019 21:55:00 +0800
Subject: [PATCH 2/3] staging: erofs: introduce erofs_page_is_managed()
In-Reply-To: <20190319135501.28712-1-gaoxiang25@huawei.com>
References: <20190319135501.28712-1-gaoxiang25@huawei.com>
Message-ID: <20190319135501.28712-2-gaoxiang25@huawei.com>

1) In order to clean up unnecessary
   page->mapping == MNGD_MAPPING(sbi) wrapped by #ifdefs;

2) Needed by "staging: erofs: support IO read error injection".

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h  |  7 +++++++
 drivers/staging/erofs/unzip_vle.c | 31 +++++++++----------------------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e3bfde00c7d2..ba1d86f3470e 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -268,8 +268,15 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
 				  struct page *page);
 
 #define MNGD_MAPPING(sbi)	((sbi)->managed_cache->i_mapping)
+static inline bool erofs_page_is_managed(const struct erofs_sb_info *sbi,
+					 struct page *page)
+{
+	return page->mapping == MNGD_MAPPING(sbi);
+}
 #else
 #define MNGD_MAPPING(sbi)	(NULL)
+static inline bool erofs_page_is_managed(const struct erofs_sb_info *sbi,
+					 struct page *page) { return false; }
 #endif
 
 #define DEFAULT_MAX_SYNC_DECOMPRESS_PAGES	3
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 3416d3f10324..d05fed4f8013 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -844,11 +844,9 @@ static void z_erofs_vle_unzip_kickoff(void *ptr, int bios)
 static inline void z_erofs_vle_read_endio(struct bio *bio)
 {
 	const blk_status_t err = bio->bi_status;
+	struct erofs_sb_info *sbi = NULL;
 	unsigned int i;
 	struct bio_vec *bvec;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *mc = NULL;
-#endif
 	struct bvec_iter_all iter_all;
 
 	bio_for_each_segment_all(bvec, bio, i, iter_all) {
@@ -858,20 +856,12 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 		DBG_BUGON(PageUptodate(page));
 		DBG_BUGON(!page->mapping);
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (unlikely(!mc && !z_erofs_is_stagingpage(page))) {
-			struct inode *const inode = page->mapping->host;
-			struct super_block *const sb = inode->i_sb;
+		if (unlikely(!sbi && !z_erofs_is_stagingpage(page)))
+			sbi = EROFS_SB(page->mapping->host->i_sb);
 
-			mc = MNGD_MAPPING(EROFS_SB(sb));
-		}
-
-		/*
-		 * If mc has not gotten, it equals NULL,
-		 * however, page->mapping never be NULL if working properly.
-		 */
-		cachemngd = (page->mapping == mc);
-#endif
+		/* sbi should already be gotten if the page is managed */
+		if (sbi)
+			cachemngd = erofs_page_is_managed(sbi, page);
 
 		if (unlikely(err))
 			SetPageError(page);
@@ -983,13 +973,11 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		DBG_BUGON(!page->mapping);
 
 		if (!z_erofs_is_stagingpage(page)) {
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-			if (page->mapping == MNGD_MAPPING(sbi)) {
+			if (erofs_page_is_managed(sbi, page)) {
 				if (unlikely(!PageUptodate(page)))
 					err = -EIO;
 				continue;
 			}
-#endif
 
 			/*
 			 * only if non-head page can be selected
@@ -1054,10 +1042,9 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	for (i = 0; i < clusterpages; ++i) {
 		page = compressed_pages[i];
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (page->mapping == MNGD_MAPPING(sbi))
+		if (erofs_page_is_managed(sbi, page))
 			continue;
-#endif
+
 		/* recycle all individual staging pages */
 		(void)z_erofs_gather_if_stagingpage(page_pool, page);
 
-- 
2.12.2
