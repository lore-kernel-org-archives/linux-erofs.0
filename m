From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 18 Sep 2018 23:10:57 +0800
Subject: [PATCH v3 3/4] staging: erofs: code cleanup for erofs_show_options()
In-Reply-To: <20180918151058.25041-1-cgxu519@gmx.com>
References: <20180918151058.25041-1-cgxu519@gmx.com>
Message-ID: <20180918151058.25041-4-cgxu519@gmx.com>

Add new helper erofs_get_fault_rate() to get fault rate instead of
directly getting it from sbi, so we can remove the macro check
surrounding it.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index f496e0c1d04d..a091b93190e1 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -165,6 +165,11 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 	set_opt(sbi, FAULT_INJECTION);
 	return 0;
 }
+
+static unsigned int erofs_get_fault_rate(struct erofs_sb_info *sbi)
+{
+	return sbi->fault_info.inject_rate;
+}
 #else
 static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 					substring_t *args)
@@ -172,6 +177,11 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 	infoln("fault_injection options not supported");
 	return 0;
 }
+
+static unsigned int erofs_get_fault_rate(struct erofs_sb_info *sbi)
+{
+	return 0;
+}
 #endif
 
 static void default_options(struct erofs_sb_info *sbi)
@@ -626,11 +636,9 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 	else
 		seq_puts(seq, ",noacl");
 #endif
-#ifdef CONFIG_EROFS_FAULT_INJECTION
 	if (test_opt(sbi, FAULT_INJECTION))
 		seq_printf(seq, ",fault_injection=%u",
-				sbi->fault_info.inject_rate);
-#endif
+			erofs_get_fault_rate(sbi));
 	return 0;
 }
 
-- 
2.17.1
