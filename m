From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 29 Dec 2018 22:01:42 +0800
Subject: [PREVIEW] [PATCH v2 2/3] staging: erofs: remove unneeded
 inode_operations
In-Reply-To: <20181229140143.23352-1-gaoxiang25@huawei.com>
References: <20181229140143.23352-1-gaoxiang25@huawei.com>
Message-ID: <20181229140143.23352-2-gaoxiang25@huawei.com>

Currently, EROFS uses generic iops when xattr is off,
it seems unnecessary and a lot of extra code is there.
Let's follow what other filesystems do instead.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/inode.c    | 38 ++++++++++++------------------------
 drivers/staging/erofs/internal.h | 42 +++++++++++++++++-----------------------
 drivers/staging/erofs/namei.c    |  4 ----
 drivers/staging/erofs/xattr.h    |  4 ----
 4 files changed, 30 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index f99954dbfdb5..4f04f7c38cf2 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -184,32 +184,18 @@ static int fill_inode(struct inode *inode, int isdir)
 	if (!err) {
 		/* setup the new inode */
 		if (S_ISREG(inode->i_mode)) {
-#ifdef CONFIG_EROFS_FS_XATTR
-			inode->i_op = &erofs_generic_xattr_iops;
-#endif
+			inode->i_op = &erofs_generic_iops;
 			inode->i_fop = &generic_ro_fops;
 		} else if (S_ISDIR(inode->i_mode)) {
-			inode->i_op =
-#ifdef CONFIG_EROFS_FS_XATTR
-				&erofs_dir_xattr_iops;
-#else
-				&erofs_dir_iops;
-#endif
+			inode->i_op = &erofs_dir_iops;
 			inode->i_fop = &erofs_dir_fops;
 		} else if (S_ISLNK(inode->i_mode)) {
 			/* by default, page_get_link is used for symlink */
-			inode->i_op =
-#ifdef CONFIG_EROFS_FS_XATTR
-				&erofs_symlink_xattr_iops,
-#else
-				&page_symlink_inode_operations;
-#endif
+			inode->i_op = &erofs_symlink_iops;
 			inode_nohighmem(inode);
 		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
 			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
-#ifdef CONFIG_EROFS_FS_XATTR
-			inode->i_op = &erofs_special_inode_operations;
-#endif
+			inode->i_op = &erofs_generic_iops;
 			init_special_inode(inode, inode->i_mode, inode->i_rdev);
 		} else {
 			err = -EIO;
@@ -297,23 +283,23 @@ struct inode *erofs_iget(struct super_block *sb,
 	return inode;
 }
 
+const struct inode_operations erofs_generic_iops = {
 #ifdef CONFIG_EROFS_FS_XATTR
-const struct inode_operations erofs_generic_xattr_iops = {
 	.listxattr = erofs_listxattr,
+#endif
 };
 
-const struct inode_operations erofs_symlink_xattr_iops = {
+const struct inode_operations erofs_symlink_iops = {
 	.get_link = page_get_link,
+#ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
+#endif
 };
 
-const struct inode_operations erofs_special_inode_operations = {
-	.listxattr = erofs_listxattr,
-};
-
-const struct inode_operations erofs_fast_symlink_xattr_iops = {
+const struct inode_operations erofs_fast_symlink_iops = {
 	.get_link = simple_get_link,
+#ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
-};
 #endif
+};
 
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e049d00c087a..d1579fbe94cd 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -412,8 +412,6 @@ static inline bool is_inode_layout_inline(struct inode *inode)
 }
 
 extern const struct super_operations erofs_sops;
-extern const struct inode_operations erofs_dir_iops;
-extern const struct file_operations erofs_dir_fops;
 
 extern const struct address_space_operations erofs_raw_access_aops;
 #ifdef CONFIG_EROFS_FS_ZIP
@@ -552,37 +550,33 @@ static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
 extern struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool dir);
 
-/* dir.c */
-int erofs_namei(struct inode *dir, struct qstr *name,
-	erofs_nid_t *nid, unsigned *d_type);
-
-#ifdef CONFIG_EROFS_FS_XATTR
-/* xattr.c */
-extern const struct xattr_handler *erofs_xattr_handlers[];
-
-/* symlink and special inode */
-extern const struct inode_operations erofs_symlink_xattr_iops;
-extern const struct inode_operations erofs_fast_symlink_xattr_iops;
-extern const struct inode_operations erofs_special_inode_operations;
-#endif
+extern const struct inode_operations erofs_generic_iops;
+extern const struct inode_operations erofs_symlink_iops;
+extern const struct inode_operations erofs_fast_symlink_iops;
 
 static inline void set_inode_fast_symlink(struct inode *inode)
 {
-#ifdef CONFIG_EROFS_FS_XATTR
-	inode->i_op = &erofs_fast_symlink_xattr_iops;
-#else
-	inode->i_op = &simple_symlink_inode_operations;
-#endif
+	inode->i_op = &erofs_fast_symlink_iops;
 }
 
 static inline bool is_inode_fast_symlink(struct inode *inode)
 {
+	return inode->i_op == &erofs_fast_symlink_iops;
+}
+
+/* namei.c */
+extern const struct inode_operations erofs_dir_iops;
+
+int erofs_namei(struct inode *dir, struct qstr *name,
+		erofs_nid_t *nid, unsigned int *d_type);
+
+/* dir.c */
+extern const struct file_operations erofs_dir_fops;
+
 #ifdef CONFIG_EROFS_FS_XATTR
-	return inode->i_op == &erofs_fast_symlink_xattr_iops;
-#else
-	return inode->i_op == &simple_symlink_inode_operations;
+/* xattr.c */
+extern const struct xattr_handler *erofs_xattr_handlers[];
 #endif
-}
 
 static inline void *erofs_vmap(struct page **pages, unsigned int count)
 {
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index 5596c52e246d..7fed1f996ab0 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -235,10 +235,6 @@ static struct dentry *erofs_lookup(struct inode *dir,
 
 const struct inode_operations erofs_dir_iops = {
 	.lookup = erofs_lookup,
-};
-
-const struct inode_operations erofs_dir_xattr_iops = {
-	.lookup = erofs_lookup,
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
index 0c7379282fc5..810fc947701d 100644
--- a/drivers/staging/erofs/xattr.h
+++ b/drivers/staging/erofs/xattr.h
@@ -68,10 +68,6 @@ static const struct xattr_handler *xattr_handler_map[] = {
 }
 
 #ifdef CONFIG_EROFS_FS_XATTR
-
-extern const struct inode_operations erofs_generic_xattr_iops;
-extern const struct inode_operations erofs_dir_xattr_iops;
-
 int erofs_getxattr(struct inode *, int, const char *, void *, size_t);
 ssize_t erofs_listxattr(struct dentry *, char *, size_t);
 #else
-- 
2.14.4
