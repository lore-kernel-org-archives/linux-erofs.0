From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 16 Jul 2018 09:58:19 +0800
Subject: [PATCH 1/2] erofs: fix match_table with a NULL terminated pattern
In-Reply-To: <1531158912-84952-1-git-send-email-gaoxiang25@huawei.com>
References: <1531158912-84952-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531706300-45908-1-git-send-email-gaoxiang25@huawei.com>

Without a NULL terminated pattern, it could cause memory
access violation.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 0dcf9c7..de8ee81 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -173,13 +173,15 @@ static void default_options(struct erofs_sb_info *sbi)
 enum {
 	Opt_user_xattr,
 	Opt_acl,
-	Opt_fault_injection
+	Opt_fault_injection,
+	Opt_err
 };
 
 static match_table_t erofs_tokens = {
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_acl, "acl"},
 	{Opt_fault_injection, "fault_injection=%u"},
+	{Opt_err, NULL}
 };
 
 static int parse_options(struct super_block *sb, char *options)
-- 
1.9.1
