From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 11 Sep 2018 07:51:54 +0800
Subject: [PATCH v2] erofs: surround fault_injection ralted option parsing
 using CONFIG_EROFS_FAULT_INJECTION
Message-ID: <20180910235154.3148-1-cgxu519@gmx.com>

It's a little bit strange when fault_injection related
option fail with -EINVAL which was already disabled
from config, so surround all fault_injection related option
parsing code using CONFIG_EROFS_FAULT_INJECTION. Meanwhile,
slightly change warning message to keep consistency with
option POSIX_ACL and FS_XATTR.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
v1->v2:
- modify warning message.

 drivers/staging/erofs/super.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1aec509c805f..4ad55dcb8e68 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -237,16 +237,18 @@ static int parse_options(struct super_block *sb, char *options)
 			infoln("noacl options not supported");
 			break;
 #endif
+#ifdef CONFIG_EROFS_FAULT_INJECTION
 		case Opt_fault_injection:
 			if (args->from && match_int(args, &arg))
 				return -EINVAL;
-#ifdef CONFIG_EROFS_FAULT_INJECTION
 			erofs_build_fault_attr(EROFS_SB(sb), arg);
 			set_opt(EROFS_SB(sb), FAULT_INJECTION);
+			break;
 #else
-			infoln("FAULT_INJECTION was not selected");
-#endif
+		case Opt_fault_injection:
+			infoln("fault_injection options not supported");
 			break;
+#endif
 		default:
 			errln("Unrecognized mount option \"%s\" "
 					"or missing value", p);
-- 
2.17.1
