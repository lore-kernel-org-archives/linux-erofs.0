From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 23:57:42 +0800
Subject: [PATCH v2 12/22] staging: erofs: drop __GFP_NOFAIL for managed inode
In-Reply-To: <20190731155752.210602-1-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
Message-ID: <20190731155752.210602-13-gaoxiang25@huawei.com>

For historical reasons, __GFP_NOFAIL was set for managed inode.
It's no need using that since EROFS can handle it properly.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 7c31030daf4e..af5d87793e4d 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -356,8 +356,7 @@ static int erofs_init_managed_cache(struct super_block *sb)
 
 	inode->i_mapping->a_ops = &managed_cache_aops;
 	mapping_set_gfp_mask(inode->i_mapping,
-			     GFP_NOFS | __GFP_HIGHMEM |
-			     __GFP_MOVABLE |  __GFP_NOFAIL);
+			     GFP_NOFS | __GFP_HIGHMEM | __GFP_MOVABLE);
 	sbi->managed_cache = inode;
 	return 0;
 }
-- 
2.17.1
