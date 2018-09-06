From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 6 Sep 2018 17:01:48 +0800
Subject: [PATCH 2/2 dhowells/mount-api] staging: erofs: update .mount and
 .remount_sb
In-Reply-To: <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>
References: <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1536224508-66168-2-git-send-email-gaoxiang25@huawei.com>

This patch updates .mount and .remount_sb after
commit ("vfs: Require specification of size of
mount data for internal mounts") in reference to
drivers/usb/gadget/function/f_fs.c.

Reported-by: Stephen Rothwell <sfr at canb.auug.org.au>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 2df9768..98614f1 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -480,7 +480,7 @@ struct erofs_mount_private {
 
 /* support mount_bdev() with options */
 static int erofs_fill_super(struct super_block *sb,
-	void *_priv, int silent)
+	void *_priv, size_t data_size, int silent)
 {
 	struct erofs_mount_private *priv = _priv;
 
@@ -488,9 +488,9 @@ static int erofs_fill_super(struct super_block *sb,
 		priv->options, silent);
 }
 
-static struct dentry *erofs_mount(
-	struct file_system_type *fs_type, int flags,
-	const char *dev_name, void *data)
+static struct dentry *erofs_mount(struct file_system_type *fs_type,
+				  int flags, const char *dev_name,
+				  void *data, size_t data_size)
 {
 	struct erofs_mount_private priv = {
 		.dev_name = dev_name,
@@ -498,7 +498,7 @@ static struct dentry *erofs_mount(
 	};
 
 	return mount_bdev(fs_type, flags, dev_name,
-		&priv, erofs_fill_super);
+		&priv, sizeof(priv), erofs_fill_super);
 }
 
 static void erofs_kill_sb(struct super_block *sb)
@@ -623,7 +623,8 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 	return 0;
 }
 
-static int erofs_remount(struct super_block *sb, int *flags, char *data)
+static int erofs_remount(struct super_block *sb, int *flags,
+			 char *data, size_t data_size)
 {
 	BUG_ON(!sb_rdonly(sb));
 
-- 
1.9.1
