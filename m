From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 19 Sep 2018 22:53:46 +0800
Subject: [PATCH v4 3/3] staging: erofs: option validation in remount
In-Reply-To: <20180919145346.9927-1-cgxu519@gmx.com>
References: <20180919145346.9927-1-cgxu519@gmx.com>
Message-ID: <20180919145346.9927-4-cgxu519@gmx.com>

Add option validation in remount. After this patch, remount
can change recognized options, and for unknown options remount
will fail and report error.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 37 +++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 720436d082f7..880d01f857ca 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -145,14 +145,10 @@ char *erofs_fault_name[FAULT_MAX] = {
 	[FAULT_KMALLOC]		= "kmalloc",
 };
 
-static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
-				  substring_t *args)
+static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
+				     unsigned int rate)
 {
 	struct erofs_fault_info *ffi = &sbi->fault_info;
-	int rate = 0;
-
-	if (args->from && match_int(args, &rate))
-		return -EINVAL;
 
 	if (rate) {
 		atomic_set(&ffi->inject_ops, 0);
@@ -163,6 +159,17 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 	}
 
 	set_opt(sbi, FAULT_INJECTION);
+}
+
+static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
+				  substring_t *args)
+{
+	int rate = 0;
+
+	if (args->from && match_int(args, &rate))
+		return -EINVAL;
+
+	__erofs_build_fault_attr(sbi, rate);
 	return 0;
 }
 
@@ -171,6 +178,11 @@ static unsigned int erofs_get_fault_rate(struct erofs_sb_info *sbi)
 	return sbi->fault_info.inject_rate;
 }
 #else
+static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
+				     unsigned int rate)
+{
+}
+
 static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 				  substring_t *args)
 {
@@ -644,10 +656,23 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 
 static int erofs_remount(struct super_block *sb, int *flags, char *data)
 {
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	unsigned int org_mnt_opt = sbi->mount_opt;
+	unsigned int org_inject_rate = erofs_get_fault_rate(sbi);
+	int err;
+
 	BUG_ON(!sb_rdonly(sb));
+	err = parse_options(sb, data);
+	if (err)
+		goto out;
 
 	*flags |= SB_RDONLY;
 	return 0;
+out:
+	__erofs_build_fault_attr(sbi, org_inject_rate);
+	sbi->mount_opt = org_mnt_opt;
+
+	return err;
 }
 
 const struct super_operations erofs_sops = {
-- 
2.17.1
