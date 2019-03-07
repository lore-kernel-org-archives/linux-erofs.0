From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 7 Mar 2019 14:02:27 +0800
Subject: [PATCH for-4.20] staging: erofs: compressed_pages should not be
 accessed again after freed
In-Reply-To: <20190301212202.3297720848@mail.kernel.org>
References: <20190301212202.3297720848@mail.kernel.org>
Message-ID: <20190307060227.35571-1-gaoxiang25@huawei.com>

commit af692e117cb8cd9d3d844d413095775abc1217f9 upstream.

This patch resolves the following page use-after-free issue,
z_erofs_vle_unzip:
    ...
    for (i = 0; i < nr_pages; ++i) {
        ...
        z_erofs_onlinepage_endio(page);  (1)
    }

    for (i = 0; i < clusterpages; ++i) {
        page = compressed_pages[i];

        if (page->mapping == mngda)      (2)
            continue;
        /* recycle all individual staging pages */
        (void)z_erofs_gather_if_stagingpage(page_pool, page); (3)
        WRITE_ONCE(compressed_pages[i], NULL);
    }
    ...

After (1) is executed, page is freed and could be then reused, if
compressed_pages is scanned after that, it could fall info (2) or
(3) by mistake and that could finally be in a mess.

This patch aims to solve the above issue only with little changes
as much as possible in order to make the fix backport easier.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable at vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c     | 38 ++++++++++++++++++-----------------
 drivers/staging/erofs/unzip_vle.h     |  3 +--
 drivers/staging/erofs/unzip_vle_lz4.c | 19 ++++++++----------
 3 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 1c4b3e0343f5..7182769f546a 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -904,11 +904,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	if (llen > grp->llen)
 		llen = grp->llen;
 
-	err = z_erofs_vle_unzip_fast_percpu(compressed_pages,
-		clusterpages, pages, llen, work->pageofs,
-		z_erofs_onlinepage_endio);
+	err = z_erofs_vle_unzip_fast_percpu(compressed_pages, clusterpages,
+					    pages, llen, work->pageofs);
 	if (err != -ENOTSUPP)
-		goto out_percpu;
+		goto out;
 
 	if (sparsemem_pages >= nr_pages)
 		goto skip_allocpage;
@@ -929,8 +928,25 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	erofs_vunmap(vout, nr_pages);
 
 out:
+	/* must handle all compressed pages before endding pages */
+	for (i = 0; i < clusterpages; ++i) {
+		page = compressed_pages[i];
+
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+		if (page->mapping == mngda)
+			continue;
+#endif
+		/* recycle all individual staging pages */
+		(void)z_erofs_gather_if_stagingpage(page_pool, page);
+
+		WRITE_ONCE(compressed_pages[i], NULL);
+	}
+
 	for (i = 0; i < nr_pages; ++i) {
 		page = pages[i];
+		if (!page)
+			continue;
+
 		DBG_BUGON(page->mapping == NULL);
 
 		/* recycle all individual staging pages */
@@ -943,20 +959,6 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		z_erofs_onlinepage_endio(page);
 	}
 
-out_percpu:
-	for (i = 0; i < clusterpages; ++i) {
-		page = compressed_pages[i];
-
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (page->mapping == mngda)
-			continue;
-#endif
-		/* recycle all individual staging pages */
-		(void)z_erofs_gather_if_stagingpage(page_pool, page);
-
-		WRITE_ONCE(compressed_pages[i], NULL);
-	}
-
 	if (pages == z_pagemap_global)
 		mutex_unlock(&z_pagemap_global_lock);
 	else if (unlikely(pages != pages_onstack))
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3316bc36965d..684ff06fc7bf 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -218,8 +218,7 @@ extern int z_erofs_vle_plain_copy(struct page **compressed_pages,
 
 extern int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	unsigned clusterpages, struct page **pages,
-	unsigned outlen, unsigned short pageofs,
-	void (*endio)(struct page *));
+	unsigned int outlen, unsigned short pageofs);
 
 extern int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
 	unsigned clusterpages, void *vaddr, unsigned llen,
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index 16ac335ee59f..8fa8a71a5445 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -105,8 +105,7 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 				  unsigned int clusterpages,
 				  struct page **pages,
 				  unsigned int outlen,
-				  unsigned short pageofs,
-				  void (*endio)(struct page *))
+				  unsigned short pageofs)
 {
 	void *vin, *vout;
 	unsigned int nr_pages, i, j;
@@ -128,19 +127,16 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 	ret = z_erofs_unzip_lz4(vin, vout + pageofs,
 				clusterpages * PAGE_SIZE, outlen);
 
-	if (ret >= 0) {
-		outlen = ret;
-		ret = 0;
-	}
+	if (ret < 0)
+		goto out;
+	ret = 0;
 
 	for (i = 0; i < nr_pages; ++i) {
 		j = min((unsigned int)PAGE_SIZE - pageofs, outlen);
 
 		if (pages[i]) {
-			if (ret < 0) {
-				SetPageError(pages[i]);
-			} else if (clusterpages == 1 &&
-				   pages[i] == compressed_pages[0]) {
+			if (clusterpages == 1 &&
+			    pages[i] == compressed_pages[0]) {
 				memcpy(vin + pageofs, vout + pageofs, j);
 			} else {
 				void *dst = kmap_atomic(pages[i]);
@@ -148,12 +144,13 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 				memcpy(dst + pageofs, vout + pageofs, j);
 				kunmap_atomic(dst);
 			}
-			endio(pages[i]);
 		}
 		vout += PAGE_SIZE;
 		outlen -= j;
 		pageofs = 0;
 	}
+
+out:
 	preempt_enable();
 
 	if (clusterpages == 1)
-- 
2.14.5
