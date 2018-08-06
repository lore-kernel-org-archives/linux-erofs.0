From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 6 Aug 2018 10:39:15 +0800
Subject: [PREVIEW] [PATCH v2] staging: erofs: remove an extra semicolon in
 z_erofs_vle_unzip_all
In-Reply-To: <1533112912-62205-1-git-send-email-gaoxiang25@huawei.com>
References: <1533112912-62205-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533523155-109926-1-git-send-email-gaoxiang25@huawei.com>

There is an extra semicolon in z_erofs_vle_unzip_all, remove it.

Reported-by: Julia Lawall <julia.lawall at lip6.fr>
Signed-off-by: zhong jiang <zhongjiang at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
changelog v2:
 - zhong jiang also submits this fix, add
   'Signed-off-by: zhong jiang <zhongjiang at huawei.com>'

 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 45b1255..8721f0a 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1017,7 +1017,7 @@ static void z_erofs_vle_unzip_all(struct super_block *sb,
 		owned = READ_ONCE(grp->next);
 
 		z_erofs_vle_unzip(sb, grp, page_pool);
-	};
+	}
 }
 
 static void z_erofs_vle_unzip_wq(struct work_struct *work)
-- 
1.9.1
