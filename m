From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 8 Dec 2018 00:19:13 +0800
Subject: [PATCH 2/7] staging: erofs: introduce MNGD_MAPPING helper
In-Reply-To: <20181207161918.20747-1-gaoxiang25@huawei.com>
References: <20181207161918.20747-1-gaoxiang25@huawei.com>
Message-ID: <20181207161918.20747-3-gaoxiang25@huawei.com>

This patch introduces MNGD_MAPPING to wrap up
sbi->managed_cache->i_mapping, which will be used
to solve too many #ifdefs in a single function.

No logic changes.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

The following lines will be changed in the next cleanup patch.
-	noio_outoforder = grab_managed_cache_pages(mngda,
+	noio_outoforder = grab_managed_cache_pages(mc,
 		erofs_blknr(map->m_pa),
 		grp->compressed_pages, erofs_blknr(map->m_plen),
 		/* compressed page caching selection strategy */


 drivers/staging/erofs/internal.h  |  4 ++++
 drivers/staging/erofs/unzip_vle.c | 29 +++++++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 892944355867..b78d6e4c12ab 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -295,6 +295,10 @@ extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	struct erofs_workgroup *egrp);
 extern int erofs_try_to_free_cached_page(struct address_space *mapping,
 	struct page *page);
+
+#define MNGD_MAPPING(sbi)	((sbi)->managed_cache->i_mapping)
+#else
+#define MNGD_MAPPING(sbi)	(NULL)
 #endif
 
 #define DEFAULT_MAX_SYNC_DECOMPRESS_PAGES	3
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 4404ea6fb9e4..ac2e30474520 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -165,7 +165,7 @@ int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 {
 	struct z_erofs_vle_workgroup *const grp =
 		container_of(egrp, struct z_erofs_vle_workgroup, obj);
-	struct address_space *const mapping = sbi->managed_cache->i_mapping;
+	struct address_space *const mapping = MNGD_MAPPING(sbi);
 	const int clusterpages = erofs_clusterpages(sbi);
 	int i;
 
@@ -617,7 +617,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	struct z_erofs_vle_work *work = builder->work;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+	struct address_space *const mc = MNGD_MAPPING(sbi);
 	struct z_erofs_vle_workgroup *grp;
 	bool noio_outoforder;
 #endif
@@ -665,7 +665,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	grp = fe->builder.grp;
 
 	/* let's do out-of-order decompression for noio */
-	noio_outoforder = grab_managed_cache_pages(mngda,
+	noio_outoforder = grab_managed_cache_pages(mc,
 		erofs_blknr(map->m_pa),
 		grp->compressed_pages, erofs_blknr(map->m_plen),
 		/* compressed page caching selection strategy */
@@ -764,7 +764,7 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 	unsigned int i;
 	struct bio_vec *bvec;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *mngda = NULL;
+	struct address_space *mc = NULL;
 #endif
 
 	bio_for_each_segment_all(bvec, bio, i) {
@@ -775,18 +775,18 @@ static inline void z_erofs_vle_read_endio(struct bio *bio)
 		BUG_ON(!page->mapping);
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (unlikely(!mngda && !z_erofs_is_stagingpage(page))) {
+		if (unlikely(!mc && !z_erofs_is_stagingpage(page))) {
 			struct inode *const inode = page->mapping->host;
 			struct super_block *const sb = inode->i_sb;
 
-			mngda = EROFS_SB(sb)->managed_cache->i_mapping;
+			mc = MNGD_MAPPING(EROFS_SB(sb));
 		}
 
 		/*
-		 * If mngda has not gotten, it equals NULL,
+		 * If mc has not gotten, it equals NULL,
 		 * however, page->mapping never be NULL if working properly.
 		 */
-		cachemngd = (page->mapping == mngda);
+		cachemngd = (page->mapping == mc);
 #endif
 
 		if (unlikely(err))
@@ -810,9 +810,6 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	struct list_head *page_pool)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = sbi->managed_cache->i_mapping;
-#endif
 	const unsigned int clusterpages = erofs_clusterpages(sbi);
 
 	struct z_erofs_pagevec_ctor ctor;
@@ -903,7 +900,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		if (z_erofs_is_stagingpage(page))
 			continue;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-		else if (page->mapping == mngda) {
+		if (page->mapping == MNGD_MAPPING(sbi)) {
 			BUG_ON(PageLocked(page));
 			BUG_ON(!PageUptodate(page));
 			continue;
@@ -981,7 +978,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		page = compressed_pages[i];
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (page->mapping == mngda)
+		if (page->mapping == MNGD_MAPPING(sbi))
 			continue;
 #endif
 		/* recycle all individual staging pages */
@@ -1114,7 +1111,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	const unsigned int clusterpages = erofs_clusterpages(sbi);
 	const gfp_t gfp = GFP_NOFS;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct address_space *const mngda = sbi->managed_cache->i_mapping;
+	struct address_space *const mc = MNGD_MAPPING(sbi);
 	struct z_erofs_vle_workgroup *lstgrp_noio = NULL, *lstgrp_io = NULL;
 #endif
 	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
@@ -1187,7 +1184,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 			cachemngd = true;
 			goto do_allocpage;
 		} else if (page) {
-			if (page->mapping != mngda)
+			if (page->mapping != mc)
 				BUG_ON(PageUptodate(page));
 			else if (recover_managed_page(grp, page)) {
 				/* page is uptodate, skip io submission */
@@ -1210,7 +1207,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 				goto repeat;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 			} else if (cachemngd && !add_to_page_cache_lru(page,
-				mngda, first_index + i, gfp)) {
+				   mc, first_index + i, gfp)) {
 				set_page_private(page, (unsigned long)grp);
 				SetPagePrivate(page);
 #endif
-- 
2.14.4
