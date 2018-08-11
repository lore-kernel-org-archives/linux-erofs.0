From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 11:09:56 +0800
Subject: [PREVIEW] [PATCH 3/4] staging: erofs: fix refcount assertion in
 erofs_register_workgroup
In-Reply-To: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
References: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533956997-106704-3-git-send-email-gaoxiang25@huawei.com>

Since the reference count of an erofs_workgroup is a signed atomic
integer, fix a refcount assertion in erofs_register_workgroup.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 595cf90..8f1875c 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -74,7 +74,7 @@ int erofs_register_workgroup(struct super_block *sb,
 	int err;
 
 	/* grp->refcount should not < 1 */
-	BUG_ON(!atomic_read(&grp->refcount));
+	DBG_BUGON(atomic_read(&grp->refcount) < 1);
 
 	err = radix_tree_preload(GFP_NOFS);
 	if (err)
-- 
1.9.1
