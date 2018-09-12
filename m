From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 12 Sep 2018 13:10:30 +0800
Subject: [PATCH 3/7] staging: erofs: introduce a new helper
 __erofs_build_fault_attr()
In-Reply-To: <20180912051034.3463-1-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
Message-ID: <20180912051034.3463-4-cgxu519@gmx.com>

Introduce a new helper __erofs_build_fault_attr() to handle set/clear
erofs_fault_info, we need this funciton for internal use case.
for example, reset fault_injection option in remount.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 14dbb6517b8d..d2dbc1fd3abb 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -144,15 +144,9 @@ char *erofs_fault_name[FAULT_MAX] = {
 	[FAULT_KMALLOC]		= "kmalloc",
 };
 
-static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
-					substring_t *args)
+static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
+					unsigned int rate)
 {
-	struct erofs_fault_info *ffi = &sbi->fault_info;
-	int rate = 0;
-
-	if (args->from && match_int(args, &rate))
-		return -EINVAL;
-
 	if (rate) {
 		atomic_set(&ffi->inject_ops, 0);
 		ffi->inject_rate = rate;
@@ -162,10 +156,26 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 		memset(ffi, 0, sizeof(struct erofs_fault_info));
 		clear_opt(sbi, FAULT_INJECTION);
 	}
+}
 
+static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
+					substring_t *args)
+{
+	struct erofs_fault_info *ffi = &sbi->fault_info;
+	int rate = 0;
+
+	if (args->from && match_int(args, &rate))
+		return -EINVAL;
+
+	__erofs_build_fault_attr(sbi, rate);
 	return 0;
 }
 #else
+static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
+					unsigned int rate)
+{
+}
+
 static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 					substring_t *args)
 {
-- 
2.17.1
