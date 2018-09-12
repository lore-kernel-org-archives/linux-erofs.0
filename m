From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 12 Sep 2018 13:10:34 +0800
Subject: [PATCH 7/7] staging: erofs: option validation in remount
In-Reply-To: <20180912051034.3463-1-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
Message-ID: <20180912051034.3463-8-cgxu519@gmx.com>

Add option validation in remount. After this patch, remount
can change recognized options, and for unknown options remount
will fail and report error.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 702098c80446..953408fb82c8 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -656,10 +656,23 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 
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
 
 	*flags |= MS_RDONLY;
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
