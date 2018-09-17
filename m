From: cgxu519@gmx.com (Chengguang Xu)
Date: Mon, 17 Sep 2018 23:34:23 +0800
Subject: [PATCH v2 3/6] staging: erofs: introduce a new helper
 __erofs_build_fault_attr()
In-Reply-To: <20180917153426.16880-1-cgxu519@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
Message-ID: <20180917153426.16880-4-cgxu519@gmx.com>

Introduce a new helper __erofs_build_fault_attr() to handle set/clear
erofs_fault_info, we need this funciton for internal use case.
for example, reset fault_injection option in remount.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 7ce2fd3d49f3..3f5ae64b9c60 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -145,14 +145,10 @@ char *erofs_fault_name[FAULT_MAX] = {
 	[FAULT_KMALLOC]		= "kmalloc",
 };
 
-static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
-					substring_t *args)
+static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
+					unsigned int rate)
 {
 	struct erofs_fault_info *ffi = &sbi->fault_info;
-	int rate = 0;
-
-	if (args->from && match_int(args, &rate))
-		return -EINVAL;
 
 	if (rate) {
 		atomic_set(&ffi->inject_ops, 0);
@@ -164,7 +160,24 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 
 	set_opt(sbi, FAILt_INJECTION);
 }
+
+static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
+					substring_t *args)
+{
+	int rate = 0;
+
+	if (args->from && match_int(args, &rate))
+		return -EINVAL;
+
+	__erofs_build_fault_attr(sbi, rate);
+	return 0;
+}
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
