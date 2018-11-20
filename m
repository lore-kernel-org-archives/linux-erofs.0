From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:14:43 +0800
Subject: [PATCH v3 chao/erofs-dev 09/14] staging: erofs: decompress
 asynchronously if PG_readahead page at first
In-Reply-To: <20181120141448.29483-1-gaoxiang25@huawei.com>
References: <20181120141448.29483-1-gaoxiang25@huawei.com>
Message-ID: <20181120141448.29483-9-gaoxiang25@huawei.com>

For the case of nr_to_read == lookahead_size, it is better to
decompress asynchronously as well since no page will be needed immediately.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index a1376f3c6065..824d2c12c2f3 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1344,8 +1344,8 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 {
 	struct inode *const inode = mapping->host;
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
-	const bool sync = __should_decompress_synchronously(sbi, nr_pages);
 
+	bool sync = __should_decompress_synchronously(sbi, nr_pages);
 	struct z_erofs_vle_frontend f = VLE_FRONTEND_INIT(inode);
 	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	struct page *head = NULL;
@@ -1363,6 +1363,13 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 		prefetchw(&page->flags);
 		list_del(&page->lru);
 
+		/*
+		 * A pure asynchronous readahead is indicated if
+		 * a PG_readahead marked page is hitted at first.
+		 * Let's also do asynchronous decompression for this case.
+		 */
+		sync &= !(PageReadahead(page) && !head);
+
 		if (add_to_page_cache_lru(page, mapping, page->index, gfp)) {
 			list_add(&page->lru, &pagepool);
 			continue;
-- 
2.14.4
