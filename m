From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 28 Oct 2018 16:19:44 +0800
Subject: [PREVIEW] [RFC PATCH chao/erofs-dev v2 RESEND] staging: erofs:
 decompress asynchronously if PG_readahead page at first
In-Reply-To: <1540714458-12279-1-git-send-email-hsiangkao@aol.com>
References: <1540714458-12279-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1540714784-16314-1-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

For the case of nr_to_read == lookahead_size, it is better to
decompress asynchronously as well since no page will be needed immediately.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v2:
 - fix the condition that it could missing flags if some pages
   fail to add_to_page_cache_lru
 - (resend) remove a redundant new line

 drivers/staging/erofs/unzip_vle.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 79d3ba6..17a22ae 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1315,8 +1315,8 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 {
 	struct inode *const inode = mapping->host;
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
-	const bool sync = __should_decompress_synchronously(sbi, nr_pages);
 
+	bool sync = __should_decompress_synchronously(sbi, nr_pages);
 	struct z_erofs_vle_frontend f = VLE_FRONTEND_INIT(inode);
 	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 	struct page *head = NULL;
@@ -1334,6 +1334,13 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
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
2.7.4
