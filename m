From: zhongjiang@huawei.com (zhong jiang)
Date: Wed, 19 Sep 2018 10:16:21 +0800
Subject: [PATCH] staging: erofs: Fix a unused variable 'arg' warning
Message-ID: <1537323381-23839-1-git-send-email-zhongjiang@huawei.com>

I find the following warning when compiling the kernel.

drivers/staging/erofs/super.c:195:6: warning: unused variable 'arg' [-Wunused-variable]
  int arg = 0;

Signed-off-by: zhong jiang <zhongjiang at huawei.com>
---
 drivers/staging/erofs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 6423592..c04313f 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -192,7 +192,9 @@ static int parse_options(struct super_block *sb, char *options)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
+#ifdef CONFIG_EROFS_FAULT_INJECTION
 	int arg = 0;
+#endif
 
 	if (!options)
 		return 0;
-- 
1.7.12.4
