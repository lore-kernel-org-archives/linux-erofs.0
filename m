From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 26 Jul 2018 20:21:53 +0800
Subject: [PATCH 10/25] staging: erofs: support special inode
In-Reply-To: <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
References: <1527764767-22190-1-git-send-email-gaoxiang25@huawei.com>
 <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532607728-103372-11-git-send-email-gaoxiang25@huawei.com>

From: Chao Yu <yuchao0@huawei.com>

This patch adds to support special inode, such as block dev, char,
socket, pipe inode.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/inode.c    | 36 ++++++++++++++++++++++++++++++++++--
 drivers/staging/erofs/internal.h |  1 +
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 15ed919..c011811 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -34,8 +34,18 @@ static int read_inode(struct inode *inode, void *data)
 		vi->inode_isize = sizeof(struct erofs_inode_v2);
 		vi->xattr_isize = ondisk_xattr_ibody_size(v2->i_xattr_icount);
 
-		vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
 		inode->i_mode = le16_to_cpu(v2->i_mode);
+		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+						S_ISLNK(inode->i_mode)) {
+			vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
+		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+			inode->i_rdev =
+				new_decode_dev(le32_to_cpu(v2->i_u.rdev));
+		} else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
+			inode->i_rdev = 0;
+		} else {
+			return -EIO;
+		}
 
 		i_uid_write(inode, le32_to_cpu(v2->i_uid));
 		i_gid_write(inode, le32_to_cpu(v2->i_gid));
@@ -54,8 +64,18 @@ static int read_inode(struct inode *inode, void *data)
 		vi->inode_isize = sizeof(struct erofs_inode_v1);
 		vi->xattr_isize = ondisk_xattr_ibody_size(v1->i_xattr_icount);
 
-		vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
 		inode->i_mode = le16_to_cpu(v1->i_mode);
+		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+						S_ISLNK(inode->i_mode)) {
+			vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
+		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+			inode->i_rdev =
+				new_decode_dev(le32_to_cpu(v1->i_u.rdev));
+		} else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
+			inode->i_rdev = 0;
+		} else {
+			return -EIO;
+		}
 
 		i_uid_write(inode, le16_to_cpu(v1->i_uid));
 		i_gid_write(inode, le16_to_cpu(v1->i_gid));
@@ -173,6 +193,12 @@ static int fill_inode(struct inode *inode, int isdir)
 				&page_symlink_inode_operations;
 #endif
 			inode_nohighmem(inode);
+		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
+#ifdef CONFIG_EROFS_FS_XATTR
+			inode->i_op = &erofs_special_inode_operations;
+#endif
+			init_special_inode(inode, inode->i_mode, inode->i_rdev);
 		} else {
 			err = -EIO;
 			goto out_unlock;
@@ -232,6 +258,12 @@ struct inode *erofs_iget(struct super_block *sb,
 };
 #endif
 
+const struct inode_operations erofs_special_inode_operations = {
+#ifdef CONFIG_EROFS_FS_XATTR
+	.listxattr = erofs_listxattr,
+#endif
+};
+
 #ifdef CONFIG_EROFS_FS_XATTR
 const struct inode_operations erofs_fast_symlink_xattr_iops = {
 	.get_link = simple_get_link,
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 8a8caf0..5862705 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -252,6 +252,7 @@ int erofs_namei(struct inode *dir, struct qstr *name,
 #ifdef CONFIG_EROFS_FS_XATTR
 extern const struct inode_operations erofs_symlink_xattr_iops;
 extern const struct inode_operations erofs_fast_symlink_xattr_iops;
+extern const struct inode_operations erofs_special_inode_operations;
 #endif
 
 static inline void set_inode_fast_symlink(struct inode *inode)
-- 
1.9.1
