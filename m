From: cgxu519@gmx.com (Chengguang Xu)
Date: Mon, 17 Sep 2018 23:34:25 +0800
Subject: [PATCH v2 5/6] staging: erofs: code cleanup for erofs_show_options()
In-Reply-To: <20180917153426.16880-1-cgxu519@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
Message-ID: <20180917153426.16880-6-cgxu519@gmx.com>

Call erofs_get_fault_rate() to get fault rate instead of
directly getting it from sbi, so we can remove the macro
check surrounding it.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 24f3423ed804..a6a4874d9c9e 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -648,11 +648,9 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
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
