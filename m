From: nishkadg.linux@gmail.com (Nishka Dasgupta)
Date: Fri, 12 Jul 2019 12:42:47 +0530
Subject: [PATCH] staging: erofs: Remove function erofs_kill_sb()
Message-ID: <20190712071247.2357-1-nishkadg.linux@gmail.com>

Remove function erofs_kill_sb as all it does is call kill_block_super.
Modify references to the former to point to the latter.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux at gmail.com>
---
 drivers/staging/erofs/super.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 54494412eba4..3e2a65ba1945 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -554,16 +554,11 @@ static struct dentry *erofs_mount(
 		&priv, erofs_fill_super);
 }
 
-static void erofs_kill_sb(struct super_block *sb)
-{
-	kill_block_super(sb);
-}
-
 static struct file_system_type erofs_fs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "erofs",
 	.mount          = erofs_mount,
-	.kill_sb        = erofs_kill_sb,
+	.kill_sb        = kill_block_super,
 	.fs_flags       = FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("erofs");
-- 
2.19.1
