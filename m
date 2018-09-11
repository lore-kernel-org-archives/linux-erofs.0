From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 11 Sep 2018 18:51:29 +0800
Subject: [PATCH] erofs: option validation in remount
Message-ID: <20180911105129.3340-1-cgxu519@gmx.com>

Add option validation in remount. After this patch, remount
can change recognized options, and for unknown options remount
will fail and report error.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1aec509c805f..8bab077381ad 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -625,10 +625,27 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 
 static int erofs_remount(struct super_block *sb, int *flags, char *data)
 {
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	struct erofs_fault_info *ffi = &sbi->fault_info;
+	unsigned int orig_mount_opt = sbi->mount_opt;
+	unsigned int orig_inject_rate = ffi->inject_rate;
+	int err;
+
 	BUG_ON(!sb_rdonly(sb));
 
+	err = parse_options(sb, data);
+	if (err)
+		goto out;
+
 	*flags |= MS_RDONLY;
 	return 0;
+
+out:
+	if (ffi->inject_rate != orig_inject_rate)
+		erofs_build_fault_attr(sbi, orig_inject_rate);
+	sbi->mount_opt = orig_mount_opt;
+
+	return err;
 }
 
 const struct super_operations erofs_sops = {
-- 
2.17.1
