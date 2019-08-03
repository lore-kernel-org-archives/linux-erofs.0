From: pratikshinde320@gmail.com (Pratik Shinde)
Date: Sat,  3 Aug 2019 13:33:10 +0530
Subject: [PATCH] erofs-utils: code for handling incorrect debug level.
Message-ID: <20190803080310.17827-1-pratikshinde320@gmail.com>

handling the case of incorrect debug level.
Added an enumerated type for supported debug levels.
Using 'atoi' in place of 'parse_num_from_str'.

I have dropped the check for invalid compression algo name(which was there
in last patch)
Note:I think this patch covers different set of code changes than previous
patch,Hence I am sending a new patch instead of 'v2' of previous patch.

Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
---
 include/erofs/print.h | 16 ++++++++++++----
 mkfs/main.c           | 19 ++++++++-----------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/erofs/print.h b/include/erofs/print.h
index bc0b8d4..d6ec692 100644
--- a/include/erofs/print.h
+++ b/include/erofs/print.h
@@ -12,6 +12,14 @@
 #include "config.h"
 #include <stdio.h>
 
+enum {
+	EROFS_ERR     = 0,
+	EROFS_WARN    = 2,
+	EROFS_INFO    = 3,
+	EROFS_DBG     = 7,
+	EROFS_DBG_MAX = 9
+};
+
 #define FUNC_LINE_FMT "%s() Line[%d] "
 
 #ifndef pr_fmt
@@ -19,7 +27,7 @@
 #endif
 
 #define erofs_dbg(fmt, ...) do {				\
-	if (cfg.c_dbg_lvl >= 7) {				\
+	if (cfg.c_dbg_lvl >= EROFS_DBG) {			\
 		fprintf(stdout,					\
 			pr_fmt(fmt),				\
 			__func__,				\
@@ -29,7 +37,7 @@
 } while (0)
 
 #define erofs_info(fmt, ...) do {				\
-	if (cfg.c_dbg_lvl >= 3) {				\
+	if (cfg.c_dbg_lvl >= EROFS_INFO) {			\
 		fprintf(stdout,					\
 			pr_fmt(fmt),				\
 			__func__,				\
@@ -40,7 +48,7 @@
 } while (0)
 
 #define erofs_warn(fmt, ...) do {				\
-	if (cfg.c_dbg_lvl >= 2) {				\
+	if (cfg.c_dbg_lvl >= EROFS_WARN) {			\
 		fprintf(stdout,					\
 			pr_fmt(fmt),				\
 			__func__,				\
@@ -51,7 +59,7 @@
 } while (0)
 
 #define erofs_err(fmt, ...) do {				\
-	if (cfg.c_dbg_lvl >= 0) {				\
+	if (cfg.c_dbg_lvl >= EROFS_ERR) {			\
 		fprintf(stderr,					\
 			"Err: " pr_fmt(fmt),			\
 			__func__,				\
diff --git a/mkfs/main.c b/mkfs/main.c
index fdb65fd..9b497d8 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -30,16 +30,6 @@ static void usage(void)
 	fprintf(stderr, " -EX[,...] X=extended options\n");
 }
 
-u64 parse_num_from_str(const char *str)
-{
-	u64 num      = 0;
-	char *endptr = NULL;
-
-	num = strtoull(str, &endptr, 10);
-	BUG_ON(num == ULLONG_MAX);
-	return num;
-}
-
 static int parse_extended_opts(const char *opts)
 {
 #define MATCH_EXTENTED_OPT(opt, token, keylen) \
@@ -108,7 +98,14 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 			break;
 
 		case 'd':
-			cfg.c_dbg_lvl = parse_num_from_str(optarg);
+			cfg.c_dbg_lvl = atoi(optarg);
+			if (cfg.c_dbg_lvl < EROFS_ERR
+			    || cfg.c_dbg_lvl > EROFS_DBG_MAX) {
+				fprintf(stderr,
+					"invalid debug level %d\n",
+					cfg.c_dbg_lvl);
+				return -EINVAL;
+			}
 			break;
 
 		case 'E':
-- 
2.9.3
