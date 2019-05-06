From: cgxu519@gmail.com (Chengguang Xu)
Date: Mon,  6 May 2019 19:01:02 +0800
Subject: [PATCH] staging: erofs: set sb->s_root to NULL when failing from
 __getname()
Message-ID: <1557140462-22578-1-git-send-email-cgxu519@gmail.com>

Set sb->s_root to NULL when failing from __getname(),
so that we can avoid double dput and unnecessary operations
in generic_shutdown_super().

Signed-off-by: Chengguang Xu <cgxu519 at gmail.com>
---
 drivers/staging/erofs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 15c784fba879..c8981662a49b 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -459,6 +459,7 @@ static int erofs_read_super(struct super_block *sb,
 	 */
 err_devname:
 	dput(sb->s_root);
+	sb->s_root = NULL;
 err_iget:
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 	iput(sbi->managed_cache);
-- 
2.20.1
