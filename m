From: zemlyanoy@ispras.ru (Pavel Zemlyanoy)
Date: Thu, 30 Aug 2018 18:13:59 +0300
Subject: [PATCH 3/6] staging: erofs: formatting spaces around '-'
In-Reply-To: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <1535642042-5336-3-git-send-email-zemlyanoy@ispras.ru>

This patch does not change the logic, it only
corrects the formatting and checkpatch checks by
adding spaces around '-'.

The patch fixes 4 checks of type:
"Check: spaces preferred around that '-'".

Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index 54da72a..bf1f51c 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -65,13 +65,13 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 
 		if (i) {
 			if (!src)
-				src = mirrored[i-1] ?
-					percpu_data + (i-1) * PAGE_SIZE :
-					kmap_atomic(compressed_pages[i-1]);
+				src = mirrored[i - 1] ?
+					percpu_data + (i - 1) * PAGE_SIZE :
+					kmap_atomic(compressed_pages[i - 1]);
 
 			memcpy(dst, src + righthalf, pageofs);
 
-			if (!mirrored[i-1])
+			if (!mirrored[i - 1])
 				kunmap_atomic(src);
 
 			if (unlikely(i >= clusterpages)) {
-- 
2.7.4
