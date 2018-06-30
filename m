From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 30 Jun 2018 23:44:04 +0800
Subject: [PATCH v4] erofs: introduce error injection infrastructure
In-Reply-To: <20180622020131.65525-10-yuchao0@huawei.com>
References: <20180622020131.65525-10-yuchao0@huawei.com>
Message-ID: <1530373444-127732-1-git-send-email-gaoxiang25@huawei.com>

From: Chao Yu <yuchao0@huawei.com>

This patch introduces error injection infrastructure, with it, we can
inject error in any kernel exported common functions which erofs used,
so that it can force erofs running into error paths, it turns out that
tests can cover real rare paths more easily to find bugs.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
v4 Gao Xiang <gaoxiang25 at huawei.com>:
- avoid the global variable 'fault_name' to pollute symbol space.
  Reported-by: kbuild test robot <lkp at intel.com>
v3:
- code rebase.
v2:
- add missing Kconfig entry.
- fix double prefix 'erofs:' in erofs_show_injection_info macro.
 
 fs/erofs/Kconfig    |  6 ++++++
 fs/erofs/inode.c    |  3 ++-
 fs/erofs/internal.h | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/super.c    | 40 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 752f0e0..e9bab0f 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -86,3 +86,9 @@ config EROFS_FS_ZIP
 
 	  If you don't want to use compression, say N.
 
+config EROFS_FAULT_INJECTION
+	bool "EROFS fault injection facility"
+	depends on EROFS_FS
+	help
+	  Test EROFS to inject faults such as ENOMEM, EIO, and so on.
+	  If unsure, say N.
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 3dbce0c..78e94dd 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -100,6 +100,7 @@ static int read_inode(struct inode *inode, void *data)
 int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
 {
 	struct erofs_vnode *vi = EROFS_V(inode);
+	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
 	int mode = vi->data_mapping_mode;
 
 	BUG_ON(mode >= EROFS_INODE_LAYOUT_MAX);
@@ -110,7 +111,7 @@ int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
 
 	/* fast symlink (following ext4) */
 	if (S_ISLNK(inode->i_mode) && inode->i_size < PAGE_SIZE) {
-		char *lnk = kmalloc(inode->i_size + 1, GFP_KERNEL);
+		char *lnk = erofs_kmalloc(sbi, inode->i_size + 1, GFP_KERNEL);
 
 		if (unlikely(lnk == NULL))
 			return -ENOMEM;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 43620c0..9f6f4db 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -45,6 +45,22 @@
 #define DBG_BUGON(...)  ((void)0)
 #endif
 
+#ifdef CONFIG_EROFS_FAULT_INJECTION
+enum {
+	FAULT_KMALLOC,
+	FAULT_MAX,
+};
+
+extern char *erofs_fault_name[FAULT_MAX];
+#define IS_FAULT_SET(fi, type) ((fi)->inject_type & (1 << (type)))
+
+struct erofs_fault_info {
+	atomic_t inject_ops;
+	unsigned int inject_rate;
+	unsigned int inject_type;
+};
+#endif
+
 /* EROFS_SUPER_MAGIC_V1 to represent the whole file system */
 #define EROFS_SUPER_MAGIC   EROFS_SUPER_MAGIC_V1
 
@@ -81,14 +97,55 @@ struct erofs_sb_info {
 	char *dev_name;
 
 	unsigned int mount_opt;
+
+#ifdef CONFIG_EROFS_FAULT_INJECTION
+	struct erofs_fault_info fault_info;	/* For fault injection */
+#endif
 };
 
+#ifdef CONFIG_EROFS_FAULT_INJECTION
+#define erofs_show_injection_info(type)					\
+	infoln("inject %s in %s of %pS", erofs_fault_name[type],        \
+		__func__, __builtin_return_address(0))
+
+static inline bool time_to_inject(struct erofs_sb_info *sbi, int type)
+{
+	struct erofs_fault_info *ffi = &sbi->fault_info;
+
+	if (!ffi->inject_rate)
+		return false;
+
+	if (!IS_FAULT_SET(ffi, type))
+		return false;
+
+	atomic_inc(&ffi->inject_ops);
+	if (atomic_read(&ffi->inject_ops) >= ffi->inject_rate) {
+		atomic_set(&ffi->inject_ops, 0);
+		return true;
+	}
+	return false;
+}
+#endif
+
+static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
+					size_t size, gfp_t flags)
+{
+#ifdef CONFIG_EROFS_FAULT_INJECTION
+	if (time_to_inject(sbi, FAULT_KMALLOC)) {
+		erofs_show_injection_info(FAULT_KMALLOC);
+		return NULL;
+	}
+#endif
+	return kmalloc(size, flags);
+}
+
 #define EROFS_SB(sb) ((struct erofs_sb_info *)(sb)->s_fs_info)
 #define EROFS_I_SB(inode) ((struct erofs_sb_info *)(inode)->i_sb->s_fs_info)
 
 /* Mount flags set via mount options or defaults */
 #define EROFS_MOUNT_XATTR_USER		0x00000010
 #define EROFS_MOUNT_POSIX_ACL		0x00000020
+#define EROFS_MOUNT_FAULT_INJECTION	0x00000040
 
 #define clear_opt(sbi, option)	((sbi)->mount_opt &= ~EROFS_MOUNT_##option)
 #define set_opt(sbi, option)	((sbi)->mount_opt |= EROFS_MOUNT_##option)
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 390a521..5ac674d 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -135,6 +135,26 @@ static int superblock_read(struct super_block *sb)
 	return ret;
 }
 
+#ifdef CONFIG_EROFS_FAULT_INJECTION
+char *erofs_fault_name[FAULT_MAX] = {
+	[FAULT_KMALLOC]		= "kmalloc",
+};
+
+static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
+						unsigned int rate)
+{
+	struct erofs_fault_info *ffi = &sbi->fault_info;
+
+	if (rate) {
+		atomic_set(&ffi->inject_ops, 0);
+		ffi->inject_rate = rate;
+		ffi->inject_type = (1 << FAULT_MAX) - 1;
+	} else {
+		memset(ffi, 0, sizeof(struct erofs_fault_info));
+	}
+}
+#endif
+
 static void default_options(struct erofs_sb_info *sbi)
 {
 #ifdef CONFIG_EROFS_FS_XATTR
@@ -148,18 +168,21 @@ static void default_options(struct erofs_sb_info *sbi)
 
 enum {
 	Opt_user_xattr,
-	Opt_acl
+	Opt_acl,
+	Opt_fault_injection
 };
 
 static match_table_t erofs_tokens = {
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_acl, "acl"},
+	{Opt_fault_injection, "fault_injection=%u"},
 };
 
 static int parse_options(struct super_block *sb, char *options)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
+	int arg = 0;
 
 	if (!options)
 		return 0;
@@ -192,6 +215,16 @@ static int parse_options(struct super_block *sb, char *options)
 			infoln("acl options not supported");
 			break;
 #endif
+		case Opt_fault_injection:
+			if (args->from && match_int(args, &arg))
+				return -EINVAL;
+#ifdef CONFIG_EROFS_FAULT_INJECTION
+			erofs_build_fault_attr(EROFS_SB(sb), arg);
+			set_opt(EROFS_SB(sb), FAULT_INJECTION);
+#else
+			infoln("FAULT_INJECTION was not selected");
+#endif
+			break;
 		default:
 			infoln("Unrecognized mount option \"%s\" "
 					"or missing value", p);
@@ -452,6 +485,11 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 	else
 		seq_puts(seq, ",noacl");
 #endif
+#ifdef CONFIG_EROFS_FAULT_INJECTION
+	if (test_opt(sbi, FAULT_INJECTION))
+		seq_printf(seq, ",fault_injection=%u",
+				sbi->fault_info.inject_rate);
+#endif
 	return 0;
 }
 
-- 
1.9.1
