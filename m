From: daeseok.youn@gmail.com (Daeseok Youn)
Date: Mon, 8 Oct 2018 20:45:18 +0900
Subject: [PATCH] staging: erofs: adds a space around '*'
Message-ID: <20181008114518.GA2475@AD01277334>

fix checkpatch.pl error:
ERROR: need consistent spacing around '*' (ctx:WxV)
+                       memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);

Signed-off-by: Daeseok Youn <daeseok.youn at gmail.com>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index f5b665f..501cfe0 100644
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
