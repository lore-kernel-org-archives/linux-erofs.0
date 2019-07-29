From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:40 +0800
Subject: [PATCH 03/22] staging: erofs: fix dummy functions erofs_{get,
 list}xattr
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-4-gaoxiang25@huawei.com>

dummy functions erofs_{get,list}xattr should be inlined
without xattr enabled.

Signed-off-by: Yue Hu <zbestahu at gmail.com>
[ Gao Xiang : this patch was "staging: erofs: remove needless
              dummy functions of erofs_{get,list}xattr. "]
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/xattr.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
index fbcd57bdf886..63cc87e3d3f4 100644
--- a/drivers/staging/erofs/xattr.h
+++ b/drivers/staging/erofs/xattr.h
@@ -39,6 +39,7 @@ static inline unsigned int xattrblock_offset(struct erofs_sb_info *sbi,
 	return (xattr_id * sizeof(__u32)) % EROFS_BLKSIZ;
 }
 
+#ifdef CONFIG_EROFS_FS_XATTR
 extern const struct xattr_handler erofs_xattr_user_handler;
 extern const struct xattr_handler erofs_xattr_trusted_handler;
 #ifdef CONFIG_EROFS_FS_SECURITY
@@ -64,25 +65,24 @@ static const struct xattr_handler *xattr_handler_map[] = {
 		xattr_handler_map[idx] : NULL;
 }
 
-#ifdef CONFIG_EROFS_FS_XATTR
 extern const struct xattr_handler *erofs_xattr_handlers[];
 
 int erofs_getxattr(struct inode *, int, const char *, void *, size_t);
 ssize_t erofs_listxattr(struct dentry *, char *, size_t);
 #else
-static int __maybe_unused erofs_getxattr(struct inode *inode, int index,
-	const char *name,
-	void *buffer, size_t buffer_size)
+static inline int erofs_getxattr(struct inode *inode, int index,
+				 const char *name, void *buffer,
+				 size_t buffer_size)
 {
 	return -ENOTSUPP;
 }
 
-static ssize_t __maybe_unused erofs_listxattr(struct dentry *dentry,
-	char *buffer, size_t buffer_size)
+static inline ssize_t erofs_listxattr(struct dentry *dentry,
+				      char *buffer, size_t buffer_size)
 {
 	return -ENOTSUPP;
 }
-#endif
+#endif	/* !CONFIG_EROFS_FS_XATTR */
 
 #ifdef CONFIG_EROFS_FS_POSIX_ACL
 struct posix_acl *erofs_get_acl(struct inode *inode, int type);
-- 
2.17.1
