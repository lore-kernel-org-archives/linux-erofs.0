From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 14 Sep 2018 22:40:28 +0800
Subject: [PATCH 6/8] staging: erofs: avoid magic constants when initializing
 clusterbits
In-Reply-To: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
References: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1536936030-62362-7-git-send-email-gaoxiang25@huawei.com>

Currently erofs only supports clustersize == blocksize.
and clustersize == 2^n * blocksize will be supported in the future.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 2109b03..9e42153 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -116,9 +116,10 @@ static int superblock_read(struct super_block *sb)
 #endif
 	sbi->islotbits = ffs(sizeof(struct erofs_inode_v1)) - 1;
 #ifdef CONFIG_EROFS_FS_ZIP
-	sbi->clusterbits = 12;
+	/* TODO: clusterbits should be related to inode */
+	sbi->clusterbits = blkszbits;
 
-	if (1 << (sbi->clusterbits - 12) > Z_EROFS_CLUSTER_MAX_PAGES)
+	if (1 << (sbi->clusterbits - PAGE_SHIFT) > Z_EROFS_CLUSTER_MAX_PAGES)
 		errln("clusterbits %u is not supported on this kernel",
 			sbi->clusterbits);
 #endif
-- 
1.9.1
