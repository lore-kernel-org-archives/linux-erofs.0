From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 19 Sep 2018 13:49:05 +0800
Subject: [PATCH 1/6] staging: erofs: remove redundant CONFIG_EROFS_FS_XATTRs
Message-ID: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>

some CONFIG_EROFS_FS_XATTR conditions were added because of
the historial Linux kernel compatibility, which are unneeded now.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

Hi all,

  These are cleanup patches in Chao's erofs-dev test tree for a while.
  Many of them are trivial.
  In order for all preview patches to keep up with the staging tree,
I resend them now.

Thanks,
Gao Xiang

 drivers/staging/erofs/inode.c    | 6 ------
 drivers/staging/erofs/internal.h | 6 ++----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index c46a8d4..da8693a 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -260,22 +260,16 @@ struct inode *erofs_iget(struct super_block *sb,
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
index 0011b9d..cfcc6db 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -507,13 +507,11 @@ extern struct inode *erofs_iget(struct super_block *sb,
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
