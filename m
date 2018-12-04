From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 4 Dec 2018 21:30:50 +0800
Subject: [PREVIEW] [NOMERGE] [PATCH v2 2/2] staging: erofs: replace old percpu
 buffers decompression
In-Reply-To: <20181204133050.4501-1-gaoxiang25@huawei.com>
References: <20181204133050.4501-1-gaoxiang25@huawei.com>
Message-ID: <20181204133050.4501-2-gaoxiang25@huawei.com>

After introducing percpu map areas, let's remove the current
percpu buffers approach for two reasons:

  1) It's ineffective since the buffer size for each cpu is
     4 * PAGE_SIZE, and an extra memcpy will be performed
     after decompressing into the specific percpu buffer,
     and it will also fall back to vmap approach if
     decompression size is larger than 4 * PAGE_SIZE;
     Note that percpu map areas win in all cases for mobile
     platforms (ex, ARM), even if the decompressed size is
     very small, but I have to admit that a copy-based
     decompression method is still useful in some platforms
     (eg, X86 according to [1]) for small decompressed sizes;

  2) It has high coupling of erofs compression code and it is
     not as clean as expected.

Anyway, a more cleaned hybird (memcpy for small decompressed
size) approach will be introduced independently for those
platforms, that is another story. Let's drop the current
percpu buffers approach for now.

[1] https://lkml.org/lkml/2013/2/5/852

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c     |  7 ----
 drivers/staging/erofs/unzip_vle.h     |  5 ---
 drivers/staging/erofs/unzip_vle_lz4.c | 71 +----------------------------------
 3 files changed, 1 insertion(+), 82 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 695f342d0509..24f05701ea40 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -991,12 +991,6 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	if (llen > grp->llen)
 		llen = grp->llen;
 
-	err = z_erofs_vle_unzip_fast_percpu(compressed_pages,
-		clusterpages, pages, llen, work->pageofs,
-		z_erofs_onlinepage_endio);
-	if (err != -ENOTSUPP)
-		goto out_percpu;
-
 	if (sparsemem_pages >= nr_pages) {
 		BUG_ON(sparsemem_pages > nr_pages);
 		goto skip_allocpage;
@@ -1032,7 +1026,6 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		z_erofs_onlinepage_endio(page);
 	}
 
-out_percpu:
 	for (i = 0; i < clusterpages; ++i) {
 		page = compressed_pages[i];
 
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 9517ace352a4..7b61fa3b0e75 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -222,11 +222,6 @@ extern int z_erofs_vle_plain_copy(struct page **compressed_pages,
 	unsigned clusterpages, struct page **pages,
 	unsigned nr_pages, unsigned short pageofs);
 
-extern int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
-	unsigned clusterpages, struct page **pages,
-	unsigned outlen, unsigned short pageofs,
-	void (*endio)(struct page *));
-
 extern int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	unsigned clusterpages, void *vaddr, unsigned llen,
 	unsigned short pageofs, bool overlapped);
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index 2bf09daac206..9b63ecfa7b09 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -34,14 +34,8 @@ int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen)
 	return -EIO;
 }
 
-#if Z_EROFS_CLUSTER_MAX_PAGES > Z_EROFS_VLE_INLINE_PAGEVECS
-#define EROFS_PERCPU_NR_PAGES   Z_EROFS_CLUSTER_MAX_PAGES
-#else
-#define EROFS_PERCPU_NR_PAGES   Z_EROFS_VLE_INLINE_PAGEVECS
-#endif
-
 static struct {
-	char data[PAGE_SIZE * EROFS_PERCPU_NR_PAGES];
+	char data[PAGE_SIZE * (Z_EROFS_CLUSTER_MAX_PAGES + 1)];
 } erofs_pcpubuf[NR_CPUS];
 
 int z_erofs_vle_plain_copy(struct page **compressed_pages,
@@ -121,69 +115,6 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 	return 0;
 }
 
-int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
-				  unsigned int clusterpages,
-				  struct page **pages,
-				  unsigned int outlen,
-				  unsigned short pageofs,
-				  void (*endio)(struct page *))
-{
-	void *vin, *vout;
-	unsigned int nr_pages, i, j;
-	int ret;
-
-	if (outlen + pageofs > EROFS_PERCPU_NR_PAGES * PAGE_SIZE)
-		return -ENOTSUPP;
-
-	nr_pages = DIV_ROUND_UP(outlen + pageofs, PAGE_SIZE);
-
-	if (clusterpages == 1)
-		vin = kmap_atomic(compressed_pages[0]);
-	else
-		vin = erofs_vmap(compressed_pages, clusterpages);
-
-	preempt_disable();
-	vout = erofs_pcpubuf[smp_processor_id()].data;
-
-	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
-				clusterpages * PAGE_SIZE, outlen);
-
-	if (ret >= 0) {
-		outlen = ret;
-		ret = 0;
-	}
-
-	for (i = 0; i < nr_pages; ++i) {
-		j = min((unsigned int)PAGE_SIZE - pageofs, outlen);
-
-		if (pages[i]) {
-			if (ret < 0) {
-				SetPageError(pages[i]);
-			} else if (clusterpages == 1 &&
-				   pages[i] == compressed_pages[0]) {
-				memcpy(vin + pageofs, vout + pageofs, j);
-			} else {
-				void *dst = kmap_atomic(pages[i]);
-
-				memcpy(dst + pageofs, vout + pageofs, j);
-				kunmap_atomic(dst);
-			}
-			endio(pages[i]);
-		}
-		vout += PAGE_SIZE;
-		outlen -= j;
-		pageofs = 0;
-	}
-	preempt_enable();
-
-	if (clusterpages == 1)
-		kunmap_atomic(vin);
-	else
-		erofs_vunmap(vin, clusterpages);
-
-	return ret;
-}
-
 int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 			   unsigned int clusterpages,
 			   void *vout,
-- 
2.14.4
