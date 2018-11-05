From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 18:44:57 +0800
Subject: [PATCH 4.20-rc1 rebased 04/10] staging: erofs: fix refcount assertion
 in erofs_register_workgroup
In-Reply-To: <20181105104503.45627-1-gaoxiang25@huawei.com>
References: <20181105104503.45627-1-gaoxiang25@huawei.com>
Message-ID: <20181105104503.45627-4-gaoxiang25@huawei.com>

Since the reference count of an erofs_workgroup is a signed atomic
integer, fix a refcount assertion in erofs_register_workgroup.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index d9b437dd6818..71201c822fd4 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -72,7 +72,7 @@ int erofs_register_workgroup(struct super_block *sb,
 	int err;
 
 	/* grp->refcount should not < 1 */
-	BUG_ON(!atomic_read(&grp->refcount));
+	DBG_BUGON(atomic_read(&grp->refcount) < 1);
 
 	err = radix_tree_preload(GFP_NOFS);
 	if (err)
-- 
2.14.4
