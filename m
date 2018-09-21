From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 21 Sep 2018 11:43:35 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 3/3] staging: erofs: managed pages
 could be locked at the time of decompression
In-Reply-To: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1537501415-70936-3-git-send-email-gaoxiang25@huawei.com>

Managed compressed pages should be unlocked when IO ends by design.
Therefore, these pages will be up-to-date and unlocked at the time
of decompression in general.

However managed pages could be re-locked in some other paths, such as
the reclaim path. Let's remove the related assertion in decompression.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 337a82d..3b14126 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -872,7 +872,6 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 			continue;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 		else if (page->mapping == mngda) {
-			BUG_ON(PageLocked(page));
 			BUG_ON(!PageUptodate(page));
 			continue;
 		}
-- 
1.9.1
