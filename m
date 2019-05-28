From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 28 May 2019 10:31:46 +0800
Subject: [PATCH 1/2] staging: erofs: support statx
Message-ID: <20190528023147.94117-1-gaoxiang25@huawei.com>

statx() has already been supported in commit a528d35e8bfc
("statx: Add a system call to make enhanced file info available"),
user programs can get more useful attributes.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/inode.c    | 18 ++++++++++++++++++
 drivers/staging/erofs/internal.h |  2 ++
 drivers/staging/erofs/namei.c    |  1 +
 3 files changed, 21 insertions(+)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index c7d3b815a798..8da144943ed6 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -285,7 +285,23 @@ struct inode *erofs_iget(struct super_block *sb,
 	return inode;
 }
 
+int erofs_getattr(const struct path *path, struct kstat *stat,
+		  u32 request_mask, unsigned int query_flags)
+{
+	struct inode *const inode = d_inode(path->dentry);
+	struct erofs_vnode *const vi = EROFS_V(inode);
+
+	if (vi->data_mapping_mode == EROFS_INODE_LAYOUT_COMPRESSION)
+		stat->attributes |= STATX_ATTR_COMPRESSED;
+
+	stat->attributes |= STATX_ATTR_IMMUTABLE;
+
+	generic_fillattr(inode, stat);
+	return 0;
+}
+
 const struct inode_operations erofs_generic_iops = {
+	.getattr = erofs_getattr,
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
@@ -294,6 +310,7 @@ const struct inode_operations erofs_generic_iops = {
 
 const struct inode_operations erofs_symlink_iops = {
 	.get_link = page_get_link,
+	.getattr = erofs_getattr,
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
@@ -302,6 +319,7 @@ const struct inode_operations erofs_symlink_iops = {
 
 const struct inode_operations erofs_fast_symlink_iops = {
 	.get_link = simple_get_link,
+	.getattr = erofs_getattr,
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index c47778b3fabd..911333cdeef4 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -556,6 +556,8 @@ static inline bool is_inode_fast_symlink(struct inode *inode)
 }
 
 struct inode *erofs_iget(struct super_block *sb, erofs_nid_t nid, bool dir);
+int erofs_getattr(const struct path *path, struct kstat *stat,
+		  u32 request_mask, unsigned int query_flags);
 
 /* namei.c */
 extern const struct inode_operations erofs_dir_iops;
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index d8d9dc9dab43..fd3ae78d0ba5 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -247,6 +247,7 @@ static struct dentry *erofs_lookup(struct inode *dir,
 
 const struct inode_operations erofs_dir_iops = {
 	.lookup = erofs_lookup,
+	.getattr = erofs_getattr,
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
-- 
2.17.1
