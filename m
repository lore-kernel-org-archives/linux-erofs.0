From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:47 +0800
Subject: [PATCH 10/22] staging: erofs: kill sbi->dev_name
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-11-gaoxiang25@huawei.com>

As Al said, "the only use of sbi->dev_name is debugging
printks and all of those have sb->s_id available, with
device name stored in there.  Which makes the whole
thing bloody weird".

sbi->dev_name was used for our debugging use and it's
better to just use s_id in community and delete
the whole erofs_mount_private stuff.

Suggested-by: Al Viro <viro at zeniv.linux.org.uk>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h |  2 --
 drivers/staging/erofs/super.c    | 54 +++++---------------------------
 2 files changed, 7 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index c082a462baf6..b206a85776b4 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -113,8 +113,6 @@ struct erofs_sb_info {
 	u8 volume_name[16];             /* volume name */
 	u32 requirements;
 
-	char *dev_name;
-
 	unsigned int mount_opt;
 
 #ifdef CONFIG_EROFS_FAULT_INJECTION
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 7e6fe9cd45e7..bfb6e1e09781 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -362,15 +362,13 @@ static struct inode *erofs_init_managed_cache(struct super_block *sb)
 
 #endif
 
-static int erofs_read_super(struct super_block *sb,
-			    const char *dev_name,
-			    void *data, int silent)
+static int erofs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
 	struct erofs_sb_info *sbi;
 	int err = -EINVAL;
 
-	infoln("read_super, device -> %s", dev_name);
+	infoln("fill_super, device -> %s", sb->s_id);
 	infoln("options -> %s", (char *)data);
 
 	if (unlikely(!sb_set_blocksize(sb, EROFS_BLKSIZ))) {
@@ -448,30 +446,16 @@ static int erofs_read_super(struct super_block *sb,
 		goto err_iget;
 	}
 
-	/* save the device name to sbi */
-	sbi->dev_name = __getname();
-	if (!sbi->dev_name) {
-		err = -ENOMEM;
-		goto err_devname;
-	}
-
-	snprintf(sbi->dev_name, PATH_MAX, "%s", dev_name);
-	sbi->dev_name[PATH_MAX - 1] = '\0';
-
 	erofs_shrinker_register(sb);
 
 	if (!silent)
-		infoln("mounted on %s with opts: %s.", dev_name,
-		       (char *)data);
+		infoln("mounted on %s with opts: %s.", sb->s_id, (char *)data);
 	return 0;
 	/*
 	 * please add a label for each exit point and use
 	 * the following name convention, thus new features
 	 * can be integrated easily without renaming labels.
 	 */
-err_devname:
-	dput(sb->s_root);
-	sb->s_root = NULL;
 err_iget:
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 	iput(sbi->managed_cache);
@@ -499,8 +483,7 @@ static void erofs_put_super(struct super_block *sb)
 
 	WARN_ON(sb->s_magic != EROFS_SUPER_MAGIC);
 
-	infoln("unmounted for %s", sbi->dev_name);
-	__putname(sbi->dev_name);
+	infoln("unmounted for %s", sb->s_id);
 
 	erofs_shrinker_unregister(sb);
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
@@ -510,33 +493,10 @@ static void erofs_put_super(struct super_block *sb)
 	sb->s_fs_info = NULL;
 }
 
-
-struct erofs_mount_private {
-	const char *dev_name;
-	char *options;
-};
-
-/* support mount_bdev() with options */
-static int erofs_fill_super(struct super_block *sb,
-			    void *_priv, int silent)
-{
-	struct erofs_mount_private *priv = _priv;
-
-	return erofs_read_super(sb, priv->dev_name,
-		priv->options, silent);
-}
-
-static struct dentry *erofs_mount(
-	struct file_system_type *fs_type, int flags,
-	const char *dev_name, void *data)
+static struct dentry *erofs_mount(struct file_system_type *fs_type, int flags,
+				  const char *dev_name, void *data)
 {
-	struct erofs_mount_private priv = {
-		.dev_name = dev_name,
-		.options = data
-	};
-
-	return mount_bdev(fs_type, flags, dev_name,
-		&priv, erofs_fill_super);
+	return mount_bdev(fs_type, flags, dev_name, data, erofs_fill_super);
 }
 
 static struct file_system_type erofs_fs_type = {
-- 
2.17.1
