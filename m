From: zemlyanoy@ispras.ru (Pavel Zemlyanoy)
Date: Thu, 30 Aug 2018 18:13:57 +0300
Subject: [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
Message-ID: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>


This patch does not change the logic, it only
corrects the formatting and checkpatch warnings by
adding "int" to the unsigned type.

The patch fixes 11 warnings of the type:
"WARNING: Prefer 'unsigned int' to bare use of 'unsigned'"

Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
---
 drivers/staging/erofs/unzip_vle_lz4.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index f5b665f..f9e6b78 100644
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
@@ -134,7 +134,7 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	}
 
 	for (i = 0; i < nr_pages; ++i) {
-		j = min((unsigned)PAGE_SIZE - pageofs, outlen);
+		j = min((unsigned int)PAGE_SIZE - pageofs, outlen);
 
 		if (pages[i] != NULL) {
 			if (ret < 0)
@@ -164,14 +164,14 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
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
@@ -206,4 +206,3 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 
 	return ret;
 }
-
-- 
2.7.4
