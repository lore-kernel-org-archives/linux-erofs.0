From: pratikshinde320@gmail.com (Pratik Shinde)
Date: Wed, 24 Jul 2019 10:25:19 +0530
Subject: [PATCH v2] erofs-utils: Add missing error code handling.
Message-ID: <20190724045519.8498-1-pratikshinde320@gmail.com>

Handling error conditions that are missed in few scenarios.
also, mkfs command should return 1 on failure and 0 on success.

Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
---
 lib/inode.c | 10 ++++++++--
 mkfs/main.c |  8 +++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

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
index 1348587..f73eb10 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -212,6 +212,12 @@ int main(int argc, char **argv)
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
@@ -254,5 +260,5 @@ exit:
 			  erofs_strerror(err));
 		return 1;
 	}
-	return err;
+	return 0;
 }
-- 
2.9.3
