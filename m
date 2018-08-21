From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 21 Aug 2018 16:08:49 +0800
Subject: [PREVIEW] [PATCH] staging: erofs: remove redundant
 CONFIG_EROFS_FS_XATTRs
Message-ID: <1534838929-53429-1-git-send-email-gaoxiang25@huawei.com>

some CONFIG_EROFS_FS_XATTR conditions were added because of
the historial Linux kernel compatibility, which are unneeded now.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/inode.c    | 6 ------
 drivers/staging/erofs/internal.h | 6 ++----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index fbf6ff2..66a8bf7 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -259,22 +259,16 @@ struct inode *erofs_iget(struct super_block *sb,
 const struct inode_operations erofs_generic_xattr_iops = {
 	.listxattr = erofs_listxattr,
 };
-#endif
 
-#ifdef CONFIG_EROFS_FS_XATTR
 const struct inode_operations erofs_symlink_xattr_iops = {
 	.get_link = page_get_link,
 	.listxattr = erofs_listxattr,
 };
-#endif
 
 const struct inode_operations erofs_special_inode_operations = {
-#ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
-#endif
 };
 
-#ifdef CONFIG_EROFS_FS_XATTR
 const struct inode_operations erofs_fast_symlink_xattr_iops = {
 	.get_link = simple_get_link,
 	.listxattr = erofs_listxattr,
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 8951e01..7486fec 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -500,13 +500,11 @@ extern struct inode *erofs_iget(struct super_block *sb,
 int erofs_namei(struct inode *dir, struct qstr *name,
 	erofs_nid_t *nid, unsigned *d_type);
 
-/* xattr.c */
 #ifdef CONFIG_EROFS_FS_XATTR
+/* xattr.c */
 extern const struct xattr_handler *erofs_xattr_handlers[];
-#endif
 
-/* symlink */
-#ifdef CONFIG_EROFS_FS_XATTR
+/* symlink and special inode */
 extern const struct inode_operations erofs_symlink_xattr_iops;
 extern const struct inode_operations erofs_fast_symlink_xattr_iops;
 extern const struct inode_operations erofs_special_inode_operations;
-- 
1.9.1
