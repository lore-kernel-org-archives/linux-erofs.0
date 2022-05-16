Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9944C433EF
	for <linux-erofs@archiver.kernel.org>; Mon, 16 May 2022 07:10:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4L1r4y0C8tz3bvd
	for <linux-erofs@archiver.kernel.org>; Mon, 16 May 2022 17:10:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.45;
 helo=out30-45.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-45.freemail.mail.aliyun.com
 (out30-45.freemail.mail.aliyun.com [115.124.30.45])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4L1r4p16Vcz2ybB
 for <linux-erofs@lists.ozlabs.org>; Mon, 16 May 2022 17:10:46 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=2; SR=0; TI=SMTPD_---0VDFjyV2_1652685034; 
Received: from
 e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VDFjyV2_1652685034) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 16 May 2022 15:10:39 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: mkfs: show per-file progress
Date: Mon, 16 May 2022 15:10:33 +0800
Message-Id: <20220516071033.96151-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Generally, users want to know the latest progress since it may take
long time to build a image. Let's add a per-file progress as a start.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 include/erofs/config.h |  3 +++
 include/erofs/print.h  | 26 ++++++++++++++------------
 lib/config.c           | 34 ++++++++++++++++++++++++++++++++++
 lib/inode.c            |  1 +
 mkfs/main.c            |  7 ++++++-
 5 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/include/erofs/config.h b/include/erofs/config.h
index 1e985b0..aeacb7b 100644
--- a/include/erofs/config.h
+++ b/include/erofs/config.h
@@ -45,6 +45,7 @@ struct erofs_configure {
 	bool c_noinline_data;
 	bool c_ztailpacking;
 	bool c_ignore_mtime;
+	bool c_showprogress;
 
 #ifdef HAVE_LIBSELINUX
 	struct selabel_handle *sehnd;
@@ -92,6 +93,8 @@ static inline int erofs_selabel_open(const char *file_contexts)
 }
 #endif
 
+void erofs_update_progressinfo(const char *fmt, ...);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/include/erofs/print.h b/include/erofs/print.h
index f188a6b..a896d75 100644
--- a/include/erofs/print.h
+++ b/include/erofs/print.h
@@ -41,37 +41,39 @@ enum {
 #define PR_FMT_FUNC_LINE(fmt)	pr_fmt(fmt), __func__, __LINE__
 #endif
 
+void erofs_msg(int dbglv, const char *fmt, ...);
+
 #define erofs_dbg(fmt, ...) do {			\
 	if (cfg.c_dbg_lvl >= EROFS_DBG) {		\
-		fprintf(stdout,				\
-			"<D> " PR_FMT_FUNC_LINE(fmt),	\
-			##__VA_ARGS__);			\
+		erofs_msg(EROFS_DBG,			\
+			  "<D> " PR_FMT_FUNC_LINE(fmt),	\
+			  ##__VA_ARGS__);		\
 	}						\
 } while (0)
 
 #define erofs_info(fmt, ...) do {			\
 	if (cfg.c_dbg_lvl >= EROFS_INFO) {		\
-		fprintf(stdout,				\
-			"<I> " PR_FMT_FUNC_LINE(fmt),	\
-			##__VA_ARGS__);			\
+		erofs_msg(EROFS_INFO,			\
+			  "<I> " PR_FMT_FUNC_LINE(fmt),	\
+			  ##__VA_ARGS__);		\
 		fflush(stdout);				\
 	}						\
 } while (0)
 
 #define erofs_warn(fmt, ...) do {			\
 	if (cfg.c_dbg_lvl >= EROFS_WARN) {		\
-		fprintf(stdout,				\
-			"<W> " PR_FMT_FUNC_LINE(fmt),	\
-			##__VA_ARGS__);			\
+		erofs_msg(EROFS_WARN,			\
+			  "<W> " PR_FMT_FUNC_LINE(fmt),	\
+			  ##__VA_ARGS__);		\
 		fflush(stdout);				\
 	}						\
 } while (0)
 
 #define erofs_err(fmt, ...) do {			\
 	if (cfg.c_dbg_lvl >= EROFS_ERR) {		\
-		fprintf(stderr,				\
-			"<E> " PR_FMT_FUNC_LINE(fmt),	\
-			##__VA_ARGS__);			\
+		erofs_msg(EROFS_ERR,			\
+			  "<E> " PR_FMT_FUNC_LINE(fmt),	\
+			  ##__VA_ARGS__);		\
 	}						\
 } while (0)
 
diff --git a/lib/config.c b/lib/config.c
index 24db751..0ae3120 100644
--- a/lib/config.c
+++ b/lib/config.c
@@ -6,6 +6,7 @@
  */
 #include <string.h>
 #include <stdlib.h>
+#include <stdarg.h>
 #include "erofs/print.h"
 #include "erofs/internal.h"
 #include "liberofs_private.h"
@@ -91,3 +92,36 @@ int erofs_selabel_open(const char *file_contexts)
 	return 0;
 }
 #endif
+
+bool __erofs_is_progressmsg;
+
+void erofs_msg(int dbglv, const char *fmt, ...)
+{
+	va_list ap;
+	FILE *f = dbglv >= EROFS_ERR ? stderr : stdout;
+
+	if (__erofs_is_progressmsg) {
+		fputc('\n', f);
+		__erofs_is_progressmsg = false;
+	}
+	va_start(ap, fmt);
+	vfprintf(f, fmt, ap);
+	va_end(ap);
+}
+
+void erofs_update_progressinfo(const char *fmt, ...)
+{
+	char msg[1024];
+	va_list ap;
+
+	if (cfg.c_dbg_lvl >= EROFS_INFO || !cfg.c_showprogress)
+		return;
+
+	va_start(ap, fmt);
+	vsprintf(msg, fmt, ap);
+	va_end(ap);
+
+	printf("\r\033[K%s", msg);
+	__erofs_is_progressmsg = true;
+	fflush(stdout);
+}
diff --git a/lib/inode.c b/lib/inode.c
index 6c6e42e..cafac40 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1098,6 +1098,7 @@ static struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
 			goto fail;
 		}
 
+		erofs_update_progressinfo("Processing %s ...", buf);
 		d->inode = erofs_mkfs_build_tree_from_path(dir, buf);
 		if (IS_ERR(d->inode)) {
 			ret = PTR_ERR(d->inode);
diff --git a/mkfs/main.c b/mkfs/main.c
index 25b72ad..0e09b38 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -423,8 +423,10 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 		erofs_err("unexpected argument: %s\n", argv[optind]);
 		return -EINVAL;
 	}
-	if (quiet)
+	if (quiet) {
 		cfg.c_dbg_lvl = EROFS_ERR;
+		cfg.c_showprogress = false;
+	}
 	return 0;
 }
 
@@ -520,6 +522,7 @@ static int erofs_mkfs_superblock_csum_set(void)
 
 static void erofs_mkfs_default_options(void)
 {
+	cfg.c_showprogress = true;
 	cfg.c_legacy_compress = false;
 	sbi.feature_incompat = EROFS_FEATURE_INCOMPAT_LZ4_0PADDING;
 	sbi.feature_compat = EROFS_FEATURE_COMPAT_SB_CHKSUM |
@@ -738,6 +741,8 @@ exit:
 		erofs_err("\tCould not format the device : %s\n",
 			  erofs_strerror(err));
 		return 1;
+	} else {
+		erofs_update_progressinfo("Build completed.");
 	}
 	return 0;
 }
-- 
2.24.4

