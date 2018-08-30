From: zemlyanoy@ispras.ru (Pavel Zemlyanoy)
Date: Thu, 30 Aug 2018 18:14:00 +0300
Subject: [PATCH 4/6] staging: erofs: formatting add spaces arround '*'
In-Reply-To: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <1535642042-5336-4-git-send-email-zemlyanoy@ispras.ru>

This patch does not change the logic, it only
corrects the formatting and checkpatch check by
adding spaces around '*'.

The patch fixes 1 check of type:
"Check: spaces preferred around that '*'".

Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index bf1f51c..7389500 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -181,7 +181,7 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 		for (i = 0; i < clusterpages; ++i) {
 			void *t = kmap_atomic(compressed_pages[i]);
 
-			memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
+			memcpy(vin + PAGE_SIZE * i, t, PAGE_SIZE);
 			kunmap_atomic(t);
 		}
 	} else if (clusterpages == 1)
-- 
2.7.4
