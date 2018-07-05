From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 5 Jul 2018 13:03:50 +0800
Subject: [PATCH] erofs: fix erofs_module_init & exit
Message-ID: <1530767030-86277-1-git-send-email-gaoxiang25@huawei.com>

This patch adds missing parts and EROFS ondisk
layout check as well.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/erofs_fs.h | 13 +++++++++++++
 fs/erofs/super.c    | 28 +++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index ed943d4..0dbf08d 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -253,5 +253,18 @@ enum {
 
 #define EROFS_NAME_LEN      255
 
+/* check the EROFS on-disk layout strictly at compile time */
+static inline void erofs_check_ondisk_layout(void)
+{
+	BUILD_BUG_ON(sizeof(struct erofs_super_block) != 128);
+	BUILD_BUG_ON(sizeof(struct erofs_inode_v1) != 32);
+	BUILD_BUG_ON(sizeof(struct erofs_inode_v2) != 64);
+	BUILD_BUG_ON(sizeof(struct erofs_xattr_ibody_header) != 12);
+	BUILD_BUG_ON(sizeof(struct erofs_xattr_entry) != 4);
+	BUILD_BUG_ON(sizeof(struct erofs_extent_header) != 16);
+	BUILD_BUG_ON(sizeof(struct erofs_decompressed_index_vle) != 8);
+	BUILD_BUG_ON(sizeof(struct erofs_dirent) != 12);
+}
+
 #endif
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index a1826b9..d104d88 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -37,6 +37,12 @@ static int erofs_init_inode_cache(void)
 	return erofs_inode_cachep != NULL ? 0 : -ENOMEM;
 }
 
+static void erofs_exit_inode_cache(void)
+{
+	BUG_ON(erofs_inode_cachep == NULL);
+	kmem_cache_destroy(erofs_inode_cachep);
+}
+
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	struct erofs_vnode *vi =
@@ -398,22 +404,30 @@ int __init erofs_module_init(void)
 {
 	int err;
 
+	erofs_check_ondisk_layout();
 	infoln("Initializing erofs " EROFS_VERSION);
 
 	err = erofs_init_inode_cache();
-	if (!err) {
-		err = register_filesystem(&erofs_fs_type);
-		if (!err) {
-			infoln("Successfully to initialize erofs");
-			return 0;
-		}
-	}
+	if (err)
+		goto icache_err;
+
+	err = register_filesystem(&erofs_fs_type);
+	if (err)
+		goto fs_err;
+
+	infoln("Successfully to initialize erofs");
+	return 0;
+
+fs_err:
+	erofs_exit_inode_cache();
+icache_err:
 	return err;
 }
 
 void __exit erofs_module_exit(void)
 {
 	unregister_filesystem(&erofs_fs_type);
+	erofs_exit_inode_cache();
 	infoln("Successfully finalize erofs");
 }
 
-- 
1.9.1
