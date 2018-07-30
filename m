From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 30 Jul 2018 09:51:01 +0800
Subject: [PATCH] staging: erofs: use the wrapped PTR_ERR_OR_ZERO instead of
 open code
In-Reply-To: <20180729053757.34195-1-hsiangkao@aol.com>
References: <20180729053757.34195-1-hsiangkao@aol.com>
Message-ID: <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>

Just clean up and logic doesn't change.

Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050766.html
Fixes: d72d1ce60174 ("staging: erofs: add namei functions")
Reported-by: kbuild test robot <lkp at intel.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index d2a0da3..546a471 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -195,7 +195,7 @@ int erofs_namei(struct inode *dir,
 	kunmap_atomic(data);
 	put_page(page);
 
-	return IS_ERR(de) ? PTR_ERR(de) : 0;
+	return PTR_ERR_OR_ZERO(de);
 }
 
 /* NOTE: i_mutex is already held by vfs */
-- 
1.9.1
