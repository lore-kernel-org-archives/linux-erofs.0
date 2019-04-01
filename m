From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 1 Apr 2019 14:53:08 +0800
Subject: [PATCH for-4.19 1/2] staging: erofs: fix error handling when failed
 to read compresssed data
Message-ID: <20190401065309.68109-1-gaoxiang25@huawei.com>

commit b6391ac73400eff38377a4a7364bd3df5efb5178 upstream.

Complete read error handling paths for all three kinds of
compressed pages:

 1) For cache-managed pages, PG_uptodate will be checked since
    read_endio will unlock and SetPageUptodate for these pages;

 2) For inplaced pages, read_endio cannot SetPageUptodate directly
    since it should be used to mark the final decompressed data,
    PG_error will be set with page locked for IO error instead;

 3) For staging pages, PG_error is used, which is similar to
    what we do for inplaced pages.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable at vger.kernel.org> # 4.19+
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
This series resolves the following conflicts:
FAILED: patch "[PATCH] staging: erofs: fix error handling when failed to read" failed to apply to 4.19-stable tree
FAILED: patch "[PATCH] staging: erofs: keep corrupted fs from crashing kernel in" failed to apply to 4.19-stable tree

Thanks,
Gao Xiang

 drivers/staging/erofs/unzip_vle.c | 42 +++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f44662dd795c..bb9a69158ba4 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -885,6 +885,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	overlapped = false;
 	compressed_pages = grp->compressed_pages;
 
+	err = 0;
 	for (i = 0; i < clusterpages; ++i) {
 		unsigned pagenr;
 
@@ -894,26 +895,39 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 		DBG_BUGON(page == NULL);
 		DBG_BUGON(page->mapping == NULL);
 
-		if (z_erofs_is_stagingpage(page))
-			continue;
+		if (!z_erofs_is_stagingpage(page)) {
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (page->mapping == mngda) {
-			DBG_BUGON(!PageUptodate(page));
-			continue;
-		}
+			if (page->mapping == mngda) {
+				if (unlikely(!PageUptodate(page)))
+					err = -EIO;
+				continue;
+			}
 #endif
 
-		/* only non-head page could be reused as a compressed page */
-		pagenr = z_erofs_onlinepage_index(page);
+			/*
+			 * only if non-head page can be selected
+			 * for inplace decompression
+			 */
+			pagenr = z_erofs_onlinepage_index(page);
 
-		DBG_BUGON(pagenr >= nr_pages);
-		DBG_BUGON(pages[pagenr]);
-		++sparsemem_pages;
-		pages[pagenr] = page;
+			DBG_BUGON(pagenr >= nr_pages);
+			DBG_BUGON(pages[pagenr]);
+			++sparsemem_pages;
+			pages[pagenr] = page;
 
-		overlapped = true;
+			overlapped = true;
+		}
+
+		/* PG_error needs checking for inplaced and staging pages */
+		if (unlikely(PageError(page))) {
+			DBG_BUGON(PageUptodate(page));
+			err = -EIO;
+		}
 	}
 
+	if (unlikely(err))
+		goto out;
+
 	llen = (nr_pages << PAGE_SHIFT) - work->pageofs;
 
 	if (z_erofs_vle_workgrp_fmt(grp) == Z_EROFS_VLE_WORKGRP_FMT_PLAIN) {
@@ -1078,6 +1092,8 @@ static inline bool recover_managed_page(struct z_erofs_vle_workgroup *grp,
 		return true;
 
 	lock_page(page);
+	ClearPageError(page);
+
 	if (unlikely(!PagePrivate(page))) {
 		set_page_private(page, (unsigned long)grp);
 		SetPagePrivate(page);
-- 
2.17.1
