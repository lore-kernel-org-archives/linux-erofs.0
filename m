From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 23 Nov 2018 01:21:49 +0800
Subject: [PATCH v2 10/10] staging: erofs: rename strange variable names in
 z_erofs_vle_frontend
In-Reply-To: <1542906967-249-1-git-send-email-hsiangkao@aol.com>
References: <1542906967-249-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1542907309-927-4-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

Previously, 2 members called `initial' and `cachedzone_la' are used
for applying caching policy (whether the workgroup is at either end),
which are hard to understand, rename them to `backmost' and `headoffset'.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index fab907e0fe06..f5d088fdf7f2 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -587,10 +587,9 @@ struct z_erofs_vle_frontend {
 
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
@@ -601,7 +600,7 @@ struct z_erofs_vle_frontend {
 	}, \
 	.builder = VLE_WORK_BUILDER_INIT(), \
 	.owned_head = Z_EROFS_VLE_WORKGRP_TAIL, \
-	.initial = true, }
+	.backmost = true, }
 
 static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 				struct page *page,
@@ -644,7 +643,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
 
 	if (z_erofs_vle_work_iter_end(builder))
-		fe->initial = false;
+		fe->backmost = false;
 
 	map->m_la = offset + cur;
 	map->m_llen = 0;
@@ -670,8 +669,8 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 		erofs_blknr(map->m_pa),
 		grp->compressed_pages, erofs_blknr(map->m_plen),
 		/* compressed page caching selection strategy */
-		fe->initial | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
-			map->m_la < fe->cachedzone_la : 0));
+		fe->backmost | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
+				map->m_la < fe->headoffset : 0));
 
 	if (noio_outoforder && builder_is_followed(builder))
 		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
@@ -1317,9 +1316,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 
 	trace_erofs_readpage(page, false);
 
-#if (EROFS_FS_ZIP_CACHE_LVL >= 2)
-	f.cachedzone_la = (erofs_off_t)page->index << PAGE_SHIFT;
-#endif
+	f.headoffset = (erofs_off_t)page->index << PAGE_SHIFT;
+
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
 
@@ -1355,9 +1353,8 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
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
2.11.0
