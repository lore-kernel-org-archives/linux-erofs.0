From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 6 Aug 2018 11:27:53 +0800
Subject: [PATCH] staging: erofs: remove an extra semicolon in
 z_erofs_vle_unzip_all
Message-ID: <1533526073-116588-1-git-send-email-gaoxiang25@huawei.com>

There is an extra semicolon in z_erofs_vle_unzip_all, remove it.

Reported-by: Julia Lawall <julia.lawall at lip6.fr>
Signed-off-by: zhong jiang <zhongjiang at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

zhongjiang <zhongjiang at huawei.com> also submitted a patch yesterday titled
    "drivers/staging: Remove some unneeded semicolon"

Since it was reported by Julia Lawall <julia.lawall at lip6.fr> weeks ago
and already pending for review in linux-erofs mailing list. Add
   Signed-off-by: zhong jiang <zhongjiang at huawei.com>
in this patch.

Thanks,
Gao Xiang

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
