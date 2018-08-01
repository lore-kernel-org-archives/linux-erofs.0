From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 1 Aug 2018 16:41:52 +0800
Subject: [FOR PREVIEW] [PATCH] staging: erofs: remove an extra semicolon in
 z_erofs_vle_unzip_all
Message-ID: <1533112912-62205-1-git-send-email-gaoxiang25@huawei.com>

There is an extra semicolon in z_erofs_vle_unzip_all, remove it.

Reported-by: Julia Lawall <julia.lawall at lip6.fr>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 823ea2e..591cd9b 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1016,7 +1016,7 @@ static void z_erofs_vle_unzip_all(struct super_block *sb,
 		owned = READ_ONCE(grp->next);
 
 		z_erofs_vle_unzip(sb, grp, page_pool);
-	};
+	}
 }
 
 static void z_erofs_vle_unzip_wq(struct work_struct *work)
-- 
1.9.1
