From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:14:44 +0800
Subject: [PATCH v3 chao/erofs-dev 10/14] staging: erofs: rename strange
 variable names in z_erofs_vle_frontend
In-Reply-To: <20181120141448.29483-1-gaoxiang25@huawei.com>
References: <20181120141448.29483-1-gaoxiang25@huawei.com>
Message-ID: <20181120141448.29483-10-gaoxiang25@huawei.com>

Previously, 2 members called `initial' and `cachedzone_la' are used
for applying caching policy (whether the workgroup is at either end),
which are hard to understand, rename them to `backmost' and `headoffset'.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 824d2c12c2f3..1ef178e7ac39 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -586,10 +586,9 @@ struct z_erofs_vle_frontend {
 
 	z_erofs_vle_owned_workgrp_t owned_head;
 
-	bool initial;
-#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
-	erofs_off_t cachedzone_la;
-#endif
+	/* used for applying cache strategy on the fly */
+	bool backmost;
+	erofs_off_t headoffset;
 };
 
 #define VLE_FRONTEND_INIT(__i) { \
@@ -600,7 +599,7 @@ struct z_erofs_vle_frontend {
 	}, \
 	.builder = VLE_WORK_BUILDER_INIT(), \
 	.owned_head = Z_EROFS_VLE_WORKGRP_TAIL, \
-	.initial = true, }
+	.backmost = true, }
 
 static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 				struct page *page,
@@ -643,7 +642,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
 
 	if (z_erofs_vle_work_iter_end(builder))
-		fe->initial = false;
+		fe->backmost = false;
 
 	map->m_la = offset + cur;
 	map->m_llen = 0;
@@ -669,8 +668,8 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 		erofs_blknr(map->m_pa),
 		grp->compressed_pages, erofs_blknr(map->m_plen),
 		/* compressed page caching selection strategy */
-		fe->initial | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
-			map->m_la < fe->cachedzone_la : 0));
+		fe->backmost | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
+				map->m_la < fe->headoffset : 0));
 
 	if (noio_outoforder && builder_is_followed(builder))
 		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
@@ -1316,9 +1315,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 
 	trace_erofs_readpage(page, false);
 
-#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
-	f.cachedzone_la = (erofs_off_t)page->index << PAGE_SHIFT;
-#endif
+	f.headoffset = (erofs_off_t)page->index << PAGE_SHIFT;
+
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
 
@@ -1354,9 +1352,8 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 	trace_erofs_readpages(mapping->host, lru_to_page(pages),
 			      nr_pages, false);
 
-#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
-	f.cachedzone_la = (erofs_off_t)lru_to_page(pages)->index << PAGE_SHIFT;
-#endif
+	f.headoffset = (erofs_off_t)lru_to_page(pages)->index << PAGE_SHIFT;
+
 	for (; nr_pages; --nr_pages) {
 		struct page *page = lru_to_page(pages);
 
-- 
2.14.4
