From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 25 Jan 2019 20:01:04 +0800
Subject: [PATCH 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190125115103.47250-1-gaoxiang25@huawei.com>
References: <20190125115103.47250-1-gaoxiang25@huawei.com>
Message-ID: <20190125120104.15604-1-gaoxiang25@huawei.com>

Let's add .get_acl() to read the file's acl
from its xattrs to make POSIX ACL usable.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 This [PATCH 2/2] currently hasn't tested, please ignore temporarily...
 I will test it asap...

Thanks,
Gao Xiang

 drivers/staging/erofs/inode.c |  3 +++
 drivers/staging/erofs/namei.c |  1 +
 drivers/staging/erofs/xattr.c | 40 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/erofs/xattr.h |  6 ++++++
 4 files changed, 50 insertions(+)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 4f04f7c38cf2..924b8dfc7a8f 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -287,6 +287,7 @@ const struct inode_operations erofs_generic_iops = {
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
+	.get_acl = erofs_get_acl,
 };
 
 const struct inode_operations erofs_symlink_iops = {
@@ -294,6 +295,7 @@ const struct inode_operations erofs_symlink_iops = {
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
+	.get_acl = erofs_get_acl,
 };
 
 const struct inode_operations erofs_fast_symlink_iops = {
@@ -301,5 +303,6 @@ const struct inode_operations erofs_fast_symlink_iops = {
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
+	.get_acl = erofs_get_acl,
 };
 
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index 7fed1f996ab0..b1752adc5934 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -238,5 +238,6 @@ const struct inode_operations erofs_dir_iops = {
 #ifdef CONFIG_EROFS_FS_XATTR
 	.listxattr = erofs_listxattr,
 #endif
+	.get_acl = erofs_get_acl,
 };
 
diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index eca65df46133..ee66ebffbb93 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -644,3 +644,43 @@ ssize_t erofs_listxattr(struct dentry *dentry,
 	return shared_listxattr(&it);
 }
 
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+struct posix_acl *erofs_get_acl(struct inode *inode, int type)
+{
+	struct posix_acl *acl;
+	int ea_prefix, rc;
+	char *ea_name;
+	char *value = NULL;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		ea_prefix = EROFS_XATTR_INDEX_POSIX_ACL_ACCESS;
+		ea_name = XATTR_NAME_POSIX_ACL_ACCESS;
+		break;
+	case ACL_TYPE_DEFAULT:
+		ea_prefix = EROFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		ea_name = XATTR_NAME_POSIX_ACL_DEFAULT;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	rc = erofs_getxattr(inode, ea_prefix, ea_name, NULL, 0);
+	if (rc > 0) {
+		value = kvmalloc(rc, GFP_KERNEL);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		rc = erofs_getxattr(inode, ea_prefix, ea_name, value, rc);
+	}
+
+	if (rc == -ENOATTR)
+		acl = NULL;
+	else if (rc < 0)
+		acl = ERR_PTR(rc);
+	else
+		acl = posix_acl_from_xattr(&init_user_ns, value, rc);
+	kvfree(value);
+	return acl;
+}
+#endif
+
diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
index 634dae9aaa0b..35ba5ac2139a 100644
--- a/drivers/staging/erofs/xattr.h
+++ b/drivers/staging/erofs/xattr.h
@@ -87,5 +87,11 @@ static ssize_t __maybe_unused erofs_listxattr(struct dentry *dentry,
 }
 #endif
 
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+struct posix_acl *erofs_get_acl(struct inode *inode, int type);
+#else
+#define erofs_get_acl	(NULL)
+#endif
+
 #endif
 
-- 
2.14.4
