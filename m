From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 16 Nov 2018 01:57:13 +0800
Subject: [RFC PATCH chao/erofs-dev rebased NOTEST 1/3] staging: erofs: rename
 strange variable names in z_erofs_vle_frontend
Message-ID: <20181115175715.23691-1-gaoxiang25@huawei.com>

Previously, 2 members called `initial' and `cachedzone_la' are used
for applying caching policy (whether the workgroup is at either end),
which are hard to understand, rename them to `backmost' and `headoffset'.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 0680d6d2e85d..87bc9cac2989 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -585,10 +585,9 @@ struct z_erofs_vle_frontend {
 
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
@@ -599,7 +598,7 @@ struct z_erofs_vle_frontend {
 	}, \
 	.builder = VLE_WORK_BUILDER_INIT(), \
 	.owned_head = Z_EROFS_VLE_WORKGRP_TAIL, \
-	.initial = true, }
+	.backmost = true, }
 
 static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 				struct page *page,
@@ -642,7 +641,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
 
 	if (z_erofs_vle_work_iter_end(builder))
-		fe->initial = false;
+		fe->backmost = false;
 
 	map->m_la = offset + cur;
 	map->m_llen = 0;
@@ -668,8 +667,8 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 		erofs_blknr(map->m_pa),
 		grp->compressed_pages, erofs_blknr(map->m_plen),
 		/* compressed page caching selection strategy */
-		fe->initial | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
-			map->m_la < fe->cachedzone_la : 0));
+		fe->backmost | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
+				map->m_la < fe->headoffset : 0));
 
 	if (noio_outoforder && builder_is_followed(builder))
 		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
@@ -1315,9 +1314,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 
 	trace_erofs_readpage(page, false);
 
-#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
-	f.cachedzone_la = (erofs_off_t)page->index << PAGE_SHIFT;
-#endif
+	f.headoffset = (erofs_off_t)page->index << PAGE_SHIFT;
+
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
 
@@ -1353,9 +1351,8 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
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
