From: cgxu519@gmx.com (Chengguang Xu)
Date: Mon, 17 Sep 2018 23:34:24 +0800
Subject: [PATCH v2 4/6] staging: erofs: introduce a new helper
 erofs_get_fault_rate()
In-Reply-To: <20180917153426.16880-1-cgxu519@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
Message-ID: <20180917153426.16880-5-cgxu519@gmx.com>

Introduce a new helper for getting fault rate, so that we
don't have to check macro in calling place.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 3f5ae64b9c60..24f3423ed804 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -145,6 +145,11 @@ char *erofs_fault_name[FAULT_MAX] = {
 	[FAULT_KMALLOC]		= "kmalloc",
 };
 
+static unsigned int erofs_get_fault_rate(struct erofs_sb_info *sbi)
+{
+	return sbi->fault_info.inject_rate;
+}
+
 static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
 					unsigned int rate)
 {
@@ -173,6 +178,11 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
 	return 0;
 }
 #else
+static unsigned int erofs_get_fault_rate(struct erofs_sb_info *sbi)
+{
+	return 0;
+}
+
 static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
 					unsigned int rate)
 {
-- 
2.17.1
