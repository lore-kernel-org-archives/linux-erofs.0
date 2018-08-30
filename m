From: zemlyanoy@ispras.ru (Pavel Zemlyanoy)
Date: Thu, 30 Aug 2018 18:14:02 +0300
Subject: [PATCH 6/6] staging: erofs: fix 1 warning and 9 checks
In-Reply-To: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <1535642042-5336-6-git-send-email-zemlyanoy@ispras.ru>

This patch does not change the logic, it only
corrects the formatting and checkpatch checks by
braces {} should be used on all arms of this statement,
unbalanced braces around else statement and warning by
braces {} are not necessary for any arm of this statement.

The patch fixes 9 checks of type:
"Check: braces {} should be used on all arms of this statement";
"Check: Unbalanced braces around else statement";

and 1 warning of type:
"WARNING: braces {} are not necessary for any arm of this statement".

Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index f285a50..1a42865 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -80,9 +80,9 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 			}
 		}
 
-		if (!righthalf)
+		if (!righthalf) {
 			src = NULL;
-		else {
+		} else {
 			src = mirrored[i] ? percpu_data + i * PAGE_SIZE :
 				kmap_atomic(compressed_pages[i]);
 
@@ -137,11 +137,12 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 		j = min((unsigned int)PAGE_SIZE - pageofs, outlen);
 
 		if (pages[i]) {
-			if (ret < 0)
+			if (ret < 0) {
 				SetPageError(pages[i]);
-			else if (clusterpages == 1 && pages[i] == compressed_pages[0])
+			} else if (clusterpages == 1 &&
+				   pages[i] == compressed_pages[0]) {
 				memcpy(vin + pageofs, vout + pageofs, j);
-			else {
+			} else {
 				void *dst = kmap_atomic(pages[i]);
 
 				memcpy(dst + pageofs, vout + pageofs, j);
@@ -184,9 +185,9 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 			memcpy(vin + PAGE_SIZE * i, t, PAGE_SIZE);
 			kunmap_atomic(t);
 		}
-	} else if (clusterpages == 1)
+	} else if (clusterpages == 1) {
 		vin = kmap_atomic(compressed_pages[0]);
-	else {
+	} else {
 		vin = erofs_vmap(compressed_pages, clusterpages);
 	}
 
@@ -198,11 +199,10 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	if (!overlapped) {
 		if (clusterpages == 1)
 			kunmap_atomic(vin);
-		else {
+		else
 			erofs_vunmap(vin, clusterpages);
-		}
-	} else
+	} else {
 		preempt_enable();
-
+	}
 	return ret;
 }
-- 
2.7.4
