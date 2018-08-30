From: zemlyanoy@ispras.ru (Pavel Zemlyanoy)
Date: Thu, 30 Aug 2018 13:40:07 +0300
Subject: [PATCH] staging: erofs: formatting unzip_vle_lz4.c
Message-ID: <1535625607-14281-1-git-send-email-zemlyanoy@ispras.ru>

This patch changes the coding style for unzip_vle_lz4.c,
following the accepted formatting rules.

Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 72 ++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index f5b665f..34992f2 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -23,14 +23,14 @@ static struct {
 } erofs_pcpubuf[NR_CPUS];
 
 int z_erofs_vle_plain_copy(struct page **compressed_pages,
-			   unsigned clusterpages,
+			   unsigned int clusterpages,
 			   struct page **pages,
-			   unsigned nr_pages,
+			   unsigned int nr_pages,
 			   unsigned short pageofs)
 {
-	unsigned i, j;
+	unsigned int i, j;
 	void *src = NULL;
-	const unsigned righthalf = PAGE_SIZE - pageofs;
+	const unsigned int righthalf = PAGE_SIZE - pageofs;
 	char *percpu_data;
 	bool mirrored[Z_EROFS_CLUSTER_MAX_PAGES] = { 0 };
 
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
@@ -64,14 +64,14 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 		}
 
 		if (i) {
-			if (src == NULL)
-				src = mirrored[i-1] ?
-					percpu_data + (i-1) * PAGE_SIZE :
-					kmap_atomic(compressed_pages[i-1]);
+			if (!src)
+				src = mirrored[i - 1] ?
+					percpu_data + (i - 1) * PAGE_SIZE :
+					kmap_atomic(compressed_pages[i - 1]);
 
 			memcpy(dst, src + righthalf, pageofs);
 
-			if (!mirrored[i-1])
+			if (!mirrored[i - 1])
 				kunmap_atomic(src);
 
 			if (unlikely(i >= clusterpages)) {
@@ -80,19 +80,19 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 			}
 		}
 
-		if (!righthalf)
+		if (!righthalf) {
 			src = NULL;
-		else {
+
+		} else {
 			src = mirrored[i] ? percpu_data + i * PAGE_SIZE :
 				kmap_atomic(compressed_pages[i]);
-
 			memcpy(dst + pageofs, src, righthalf);
 		}
 
 		kunmap_atomic(dst);
 	}
 
-	if (src != NULL && !mirrored[j])
+	if (src && !mirrored[j])
 		kunmap_atomic(src);
 
 	preempt_enable();
@@ -102,14 +102,14 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 extern int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
 
 int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
-				  unsigned clusterpages,
+				  unsigned int clusterpages,
 				  struct page **pages,
-				  unsigned outlen,
+				  unsigned int outlen,
 				  unsigned short pageofs,
 				  void (*endio)(struct page *))
 {
 	void *vin, *vout;
-	unsigned nr_pages, i, j;
+	unsigned int nr_pages, i, j;
 	int ret;
 
 	if (outlen + pageofs > EROFS_PERCPU_NR_PAGES * PAGE_SIZE)
@@ -126,7 +126,8 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	vout = erofs_pcpubuf[smp_processor_id()].data;
 
 	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
-		clusterpages * PAGE_SIZE, outlen);
+				clusterpages * PAGE_SIZE,
+				outlen);
 
 	if (ret >= 0) {
 		outlen = ret;
@@ -134,14 +135,15 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	}
 
 	for (i = 0; i < nr_pages; ++i) {
-		j = min((unsigned)PAGE_SIZE - pageofs, outlen);
+		j = min((unsigned int)PAGE_SIZE - pageofs, outlen);
 
-		if (pages[i] != NULL) {
-			if (ret < 0)
+		if (pages[i]) {
+			if (ret < 0) {
 				SetPageError(pages[i]);
-			else if (clusterpages == 1 && pages[i] == compressed_pages[0])
+			} else if (clusterpages == 1 &&
+					   pages[i] == compressed_pages[0]) {
 				memcpy(vin + pageofs, vout + pageofs, j);
-			else {
+			} else {
 				void *dst = kmap_atomic(pages[i]);
 
 				memcpy(dst + pageofs, vout + pageofs, j);
@@ -164,14 +166,14 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 }
 
 int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
-			   unsigned clusterpages,
+			   unsigned int clusterpages,
 			   void *vout,
-			   unsigned llen,
+			   unsigned int llen,
 			   unsigned short pageofs,
 			   bool overlapped)
 {
 	void *vin;
-	unsigned i;
+	unsigned int i;
 	int ret;
 
 	if (overlapped) {
@@ -181,29 +183,29 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 		for (i = 0; i < clusterpages; ++i) {
 			void *t = kmap_atomic(compressed_pages[i]);
 
-			memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
+			memcpy(vin + PAGE_SIZE * i, t, PAGE_SIZE);
 			kunmap_atomic(t);
 		}
-	} else if (clusterpages == 1)
+	} else if (clusterpages == 1) {
 		vin = kmap_atomic(compressed_pages[0]);
-	else {
+	} else {
 		vin = erofs_vmap(compressed_pages, clusterpages);
 	}
 
 	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
-		clusterpages * PAGE_SIZE, llen);
+				clusterpages * PAGE_SIZE,
+				llen);
 	if (ret > 0)
 		ret = 0;
 
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
