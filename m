From: pratikshinde320@gmail.com (Pratik Shinde)
Date: Wed, 24 Jul 2019 01:34:29 +0530
Subject: [PATCH] erofs-utils: Add missing error code handling.
Message-ID: <20190723200429.7132-1-pratikshinde320@gmail.com>

Handling error conditions that are missing in few scenarios.

Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
---
 lib/inode.c | 10 ++++++++--
 mkfs/main.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index 179aa26..08d38c0 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -752,8 +752,14 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
 	}
 	closedir(_dir);
 
-	erofs_prepare_dir_file(dir);
-	erofs_prepare_inode_buffer(dir);
+	ret = erofs_prepare_dir_file(dir);
+	if(!ret)
+		goto err_closedir;
+
+	ret = erofs_prepare_inode_buffer(dir);
+	if(!ret)
+		goto err_closedir;
+
 	if (IS_ROOT(dir))
 		erofs_fixup_meta_blkaddr(dir);
 
diff --git a/mkfs/main.c b/mkfs/main.c
index 1348587..9c9530d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -200,18 +200,24 @@ int main(int argc, char **argv)
 	if (err) {
 		if (err == -EINVAL)
 			usage();
-		return 1;
+		return err;
 	}
 
 	err = dev_open(cfg.c_img_path);
 	if (err) {
 		usage();
-		return 1;
+		return err;
 	}
 
 	erofs_show_config();
 
 	sb_bh = erofs_buffer_init();
+	if(IS_ERR(sb_bh)) {
+		err = PTR_ERR(sb_bh);
+		erofs_err("Failed to initialize super block buffer head : %s",
+			  erofs_strerror(err));
+		goto exit;
+	}
 	err = erofs_bh_balloon(sb_bh, EROFS_SUPER_END);
 	if (err < 0) {
 		erofs_err("Failed to balloon erofs_super_block: %s",
-- 
2.9.3
