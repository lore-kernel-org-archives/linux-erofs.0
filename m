From: zemlyanoy@ispras.ru (Pavel Zemlyanoy)
Date: Thu, 30 Aug 2018 18:14:01 +0300
Subject: [PATCH 5/6] staging: erofs: formatting alignment parenthesis
In-Reply-To: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <1535642042-5336-5-git-send-email-zemlyanoy@ispras.ru>

This patch does not change the logic, it only
corrects the formatting and checkpatch check by
alignment should match open parenthesis.

The patch fixes 2 check of type:
"Check: Alignment should match open parenthesis".

Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index 7389500..f285a50 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -126,7 +126,7 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	vout = erofs_pcpubuf[smp_processor_id()].data;
 
 	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
-		clusterpages * PAGE_SIZE, outlen);
+				clusterpages * PAGE_SIZE, outlen);
 
 	if (ret >= 0) {
 		outlen = ret;
@@ -191,7 +191,7 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	}
 
 	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
-		clusterpages * PAGE_SIZE, llen);
+				clusterpages * PAGE_SIZE, llen);
 	if (ret > 0)
 		ret = 0;
 
-- 
2.7.4
