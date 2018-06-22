From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:29 +0800
Subject: [PATCH 09/11] erofs: introduce parse_options()
In-Reply-To: <20180622020131.65525-1-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
Message-ID: <20180622020131.65525-9-yuchao0@huawei.com>

Introduce parse_options() for mount option parsing, now, it only
supports two options: 'user_xattr' and 'acl'.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/super.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 3fcb56fd988e..390a5217bbcc 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
+#include <linux/parser.h>
 #include "internal.h"
 
 static struct kmem_cache *erofs_inode_cachep __read_mostly;
@@ -145,6 +146,61 @@ static void default_options(struct erofs_sb_info *sbi)
 #endif
 }
 
+enum {
+	Opt_user_xattr,
+	Opt_acl
+};
+
+static match_table_t erofs_tokens = {
+	{Opt_user_xattr, "user_xattr"},
+	{Opt_acl, "acl"},
+};
+
+static int parse_options(struct super_block *sb, char *options)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *p;
+
+	if (!options)
+		return 0;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+
+		if (!*p)
+			continue;
+
+		args[0].to = args[0].from = NULL;
+		token = match_token(p, erofs_tokens, args);
+
+		switch (token) {
+#ifdef CONFIG_EROFS_FS_XATTR
+		case Opt_user_xattr:
+			set_opt(EROFS_SB(sb), XATTR_USER);
+			break;
+#else
+		case Opt_user_xattr:
+			infoln("user_xattr options not supported");
+			break;
+#endif
+#ifdef CONFIG_EROFS_FS_POSIX_ACL
+		case Opt_acl:
+			set_opt(EROFS_SB(sb), POSIX_ACL);
+			break;
+#else
+		case Opt_acl:
+			infoln("acl options not supported");
+			break;
+#endif
+		default:
+			infoln("Unrecognized mount option \"%s\" "
+					"or missing value", p);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 static int erofs_read_super(struct super_block *sb,
 	const char *dev_name, void *data, int silent)
 {
@@ -185,6 +241,10 @@ static int erofs_read_super(struct super_block *sb,
 	/* set erofs default mount options */
 	default_options(sbi);
 
+	err = parse_options(sb, data);
+	if (err)
+		goto err_sbi;
+
 	if (!silent)
 		infoln("root inode @ nid %llu", ROOT_NID(sbi));
 #ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
-- 
2.18.0.rc1
