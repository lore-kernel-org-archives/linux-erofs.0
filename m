From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:21 +0800
Subject: [PATCH 01/11] erofs: fix compile error
Message-ID: <20180622020131.65525-1-yuchao0@huawei.com>

Without CONFIG_EROFS_FS_XATTR, compiler will complain us, fix it.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/internal.h | 2 ++
 fs/erofs/xattr.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 934f750975f2..0606a50a0067 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -350,7 +350,9 @@ int erofs_namei(struct inode *dir, struct qstr *name,
 	erofs_nid_t *nid, unsigned *d_type);
 
 /* xattr.c */
+#ifdef CONFIG_EROFS_FS_XATTR
 extern const struct xattr_handler *erofs_xattr_handlers[];
+#endif
 
 extern void test_meta_ops(struct super_block *sb);
 
diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index f27ee416542d..fb8f3f1b3aab 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -512,6 +512,7 @@ const struct xattr_handler __maybe_unused erofs_xattr_security_handler = {
 };
 #endif
 
+#ifdef CONFIG_EROFS_FS_XATTR
 const struct xattr_handler *erofs_xattr_handlers[] = {
 	&erofs_xattr_user_handler,
 #ifdef CONFIG_EROFS_FS_POSIX_ACL
@@ -524,6 +525,7 @@ const struct xattr_handler *erofs_xattr_handlers[] = {
 #endif
 	NULL,
 };
+#endif
 
 struct listxattr_iter {
 	struct xattr_iter it;
-- 
2.18.0.rc1
