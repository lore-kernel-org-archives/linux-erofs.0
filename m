From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 11:09:54 +0800
Subject: [PREVIEW] [PATCH 1/4] staging: erofs: avoid magic constants when
 initializing clusterbits
Message-ID: <1533956997-106704-1-git-send-email-gaoxiang25@huawei.com>

Currently erofs only supports clustersize == blocksize.
and clustersize == 2^n * blocksize will be supported in the future.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1aec509..93548b9 100644
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
