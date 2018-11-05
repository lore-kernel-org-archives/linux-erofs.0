From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 18:44:54 +0800
Subject: [PATCH 4.20-rc1 rebased 01/10] staging: erofs: fix
 `trace_erofs_readpage' position
Message-ID: <20181105104503.45627-1-gaoxiang25@huawei.com>

`trace_erofs_readpage' should be placed in .readpage()
rather than in the internal `z_erofs_do_read_page'.

Fixes: 284db12cfda3 ("staging: erofs: add trace points for reading zipped data")
Cc: Chen Gong <gongchen4 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 79d3ba62b298..94ceb391f607 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -597,8 +597,6 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	unsigned int cur, end, spiltted, index;
 	int err = 0;
 
-	trace_erofs_readpage(page, false);
-
 	/* register locked file pages as online pages in pack */
 	z_erofs_onlinepage_init(page);
 
@@ -1287,6 +1285,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	int err;
 	LIST_HEAD(pagepool);
 
+	trace_erofs_readpage(page, false);
+
 #if (EROFS_FS_ZIP_CACHE_LVL >= 2)
 	f.cachedzone_la = (erofs_off_t)page->index << PAGE_SHIFT;
 #endif
-- 
2.14.4
