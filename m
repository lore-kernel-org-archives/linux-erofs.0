From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 28 Oct 2018 15:56:10 +0800
Subject: [PREVIEW] [RFC PATCH chao/erofs-dev] staging: erofs: decompress
 asynchronously if PG_readahead page at first
Message-ID: <1540713370-10223-1-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

For the case of nr_to_read == lookahead_size, it is better to
decompress asynchronously as well since no page will be needed immediately.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 79d3ba6..d73a5a1 100644
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
@@ -1340,6 +1340,14 @@ static int z_erofs_vle_normalaccess_readpages(struct file *filp,
 		}
 
 		BUG_ON(PagePrivate(page));
+
+		/*
+		 * A pure asynchronous readahead is indicated if a PG_readahead
+		 * marked page is hitted at first.
+		 * Let's also do asynchronous decompression for this case.
+		 */
+		sync &= !(PageReadahead(page) && !head);
+
 		set_page_private(page, (unsigned long)head);
 		head = page;
 	}
-- 
2.7.4
