From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 19 Sep 2018 22:53:44 +0800
Subject: [PATCH v4 1/3] staging: erofs: code cleanup for option parsing of
 fault_injection
In-Reply-To: <20180919145346.9927-1-cgxu519@gmx.com>
References: <20180919145346.9927-1-cgxu519@gmx.com>
Message-ID: <20180919145346.9927-2-cgxu519@gmx.com>

Define a dummpy function of erofs_build_fault_attr() when macro
CONFIG_EROFS_FAULT_INJECTION is disabled, so that we don't have to
check the macro in calling place. Based on above adjustment,
do proper code cleanup for option parsing of fault_injection.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 802202ca7213..d6c6ccc4936d 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -145,10 +145,14 @@ char *erofs_fault_name[FAULT_MAX] = {
 	[FAULT_KMALLOC]		= "kmalloc",
 };
 
-static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
-						unsigned int rate)
+static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
+				  substring_t *args)
 {
 	struct erofs_fault_info *ffi = &sbi->fault_info;
+	int rate = 0;
+
+	if (args->from && match_int(args, &rate))
+		return -EINVAL;
 
 	if (rate) {
 		atomic_set(&ffi->inject_ops, 0);
@@ -157,6 +161,16 @@ static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
 	} else {
 		memset(ffi, 0, sizeof(struct erofs_fault_info));
 	}
+
+	set_opt(sbi, FAULT_INJECTION);
+	return 0;
+}
+#else
+static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
+				  substring_t *args)
+{
+	infoln("fault_injection options not supported");
+	return 0;
 }
 #endif
 
@@ -193,7 +207,7 @@ static int parse_options(struct super_block *sb, char *options)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
-	int arg = 0;
+	int err;
 
 	if (!options)
 		return 0;
@@ -238,18 +252,12 @@ static int parse_options(struct super_block *sb, char *options)
 			infoln("noacl options not supported");
 			break;
 #endif
-#ifdef CONFIG_EROFS_FAULT_INJECTION
 		case Opt_fault_injection:
-			if (args->from && match_int(args, &arg))
-				return -EINVAL;
-			erofs_build_fault_attr(EROFS_SB(sb), arg);
-			set_opt(EROFS_SB(sb), FAULT_INJECTION);
+			err = erofs_build_fault_attr(EROFS_SB(sb), args);
+			if (err)
+				return err;
 			break;
-#else
-		case Opt_fault_injection:
-			infoln("fault_injection options not supported");
-			break;
-#endif
+
 		default:
 			errln("Unrecognized mount option \"%s\" "
 					"or missing value", p);
-- 
2.17.1
