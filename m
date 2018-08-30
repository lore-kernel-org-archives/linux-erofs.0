From: zemlyanoy@ispras.ru (Pavel Zemlyanoy)
Date: Thu, 30 Aug 2018 18:13:58 +0300
Subject: [PATCH 2/6] staging: erofs: formatting fix to NULL comparison
In-Reply-To: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <1535642042-5336-2-git-send-email-zemlyanoy@ispras.ru>

This patch does not change the logic, it only
corrects the formatting and checkpatch checks by
to NULL comparison.

The patch fixes 5 checks of type:
"Comparison to NULL could be written".

Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index f9e6b78..54da72a 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -42,8 +42,8 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 		struct page *page = pages[i];
 		void *dst;
 
-		if (page == NULL) {
-			if (src != NULL) {
+		if (!page) {
+			if (src) {
 				if (!mirrored[j])
 					kunmap_atomic(src);
 				src = NULL;
@@ -64,7 +64,7 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 		}
 
 		if (i) {
-			if (src == NULL)
+			if (!src)
 				src = mirrored[i-1] ?
 					percpu_data + (i-1) * PAGE_SIZE :
 					kmap_atomic(compressed_pages[i-1]);
@@ -92,7 +92,7 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 		kunmap_atomic(dst);
 	}
 
-	if (src != NULL && !mirrored[j])
+	if (src && !mirrored[j])
 		kunmap_atomic(src);
 
 	preempt_enable();
@@ -136,7 +136,7 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	for (i = 0; i < nr_pages; ++i) {
 		j = min((unsigned int)PAGE_SIZE - pageofs, outlen);
 
-		if (pages[i] != NULL) {
+		if (pages[i]) {
 			if (ret < 0)
 				SetPageError(pages[i]);
 			else if (clusterpages == 1 && pages[i] == compressed_pages[0])
-- 
2.7.4
