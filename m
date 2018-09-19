From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 19 Sep 2018 22:53:45 +0800
Subject: [PATCH v4 2/3] staging: erofs: code cleanup for erofs_show_options()
In-Reply-To: <20180919145346.9927-1-cgxu519@gmx.com>
References: <20180919145346.9927-1-cgxu519@gmx.com>
Message-ID: <20180919145346.9927-3-cgxu519@gmx.com>

Add new helper erofs_get_fault_rate() to get fault rate instead of
directly getting it from sbi, so we can remove the macro check
surrounding it.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index d6c6ccc4936d..720436d082f7 100644
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
