From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 11:09:55 +0800
Subject: [PREVIEW] [PATCH 2/4] staging: erofs: cached compressed pages could
 be relocked
In-Reply-To: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
References: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533956997-106704-2-git-send-email-gaoxiang25@huawei.com>

Cached compressed pages will all unlock when IO ends by design.
So compressed pages will be up-to-date and unlocked when
decompressing typically.

However there is an exception, since compressed pages are
unlocked, it could be locked by the reclaim path. Therefore,
the redundant BUG_ON in z_erofs_vle_unzip should be dropped.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 1d0ffa6..6e5c24d 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -894,7 +894,6 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 			continue;
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 		else if (page->mapping == mngda) {
-			BUG_ON(PageLocked(page));
 			BUG_ON(!PageUptodate(page));
 			continue;
 		}
-- 
1.9.1
