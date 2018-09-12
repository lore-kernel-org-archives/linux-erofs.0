From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 12 Sep 2018 13:10:33 +0800
Subject: [PATCH 6/7] staging: erofs: code cleanup for erofs_show_options()
In-Reply-To: <20180912051034.3463-1-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
Message-ID: <20180912051034.3463-7-cgxu519@gmx.com>

Call erofs_get_fault_rate() to get fault rate instead of
directly getting it from sbi, so we can remove the macro
check surrounding it.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index a6ae60564c65..702098c80446 100644
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
