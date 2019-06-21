From: zbestahu@gmail.com (Yue Hu)
Date: Fri, 21 Jun 2019 12:08:08 +0800
Subject: [PATCH] staging: erofs: remove needless dummy functions of erofs_{get,
 list}xattr
Message-ID: <20190621040808.3708-1-zbestahu@gmail.com>

From: Yue Hu <huyue2@yulong.com>

The two dummy functions of erofs_getxattr()/erofs_listxattr() will never
be used if disable CONFIG_EROFS_FS_XATTR.

Signed-off-by: Yue Hu <huyue2 at yulong.com>
---
 drivers/staging/erofs/xattr.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
index 35ba5ac..2c1e46f 100644
--- a/drivers/staging/erofs/xattr.h
+++ b/drivers/staging/erofs/xattr.h
@@ -72,19 +72,6 @@ static inline const struct xattr_handler *erofs_xattr_handler(unsigned index)
 
 int erofs_getxattr(struct inode *, int, const char *, void *, size_t);
 ssize_t erofs_listxattr(struct dentry *, char *, size_t);
-#else
-static int __maybe_unused erofs_getxattr(struct inode *inode, int index,
-	const char *name,
-	void *buffer, size_t buffer_size)
-{
-	return -ENOTSUPP;
-}
-
-static ssize_t __maybe_unused erofs_listxattr(struct dentry *dentry,
-	char *buffer, size_t buffer_size)
-{
-	return -ENOTSUPP;
-}
 #endif
 
 #ifdef CONFIG_EROFS_FS_POSIX_ACL
-- 
1.9.1
