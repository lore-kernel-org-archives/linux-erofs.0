Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED022C48BC3
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Feb 2024 07:56:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TfBYW4jpTz3cZL
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Feb 2024 18:56:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sjtu.edu.cn (client-ip=202.120.2.232; helo=smtp232.sjtu.edu.cn; envelope-from=zhaoyifan@sjtu.edu.cn; receiver=lists.ozlabs.org)
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TfBYS5fY6z3cCx
	for <linux-erofs@lists.ozlabs.org>; Tue, 20 Feb 2024 18:56:12 +1100 (AEDT)
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 1E72910090E01;
	Tue, 20 Feb 2024 15:55:38 +0800 (CST)
Received: from zhaoyf.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id AA96F37C98F;
	Tue, 20 Feb 2024 15:55:33 +0800 (CST)
From: Yifan Zhao <zhaoyifan@sjtu.edu.cn>
To: hsiangkao@linux.alibaba.com
Subject: [PATCH v2 2/7] erofs-utils: add a helper to get available processors
Date: Tue, 20 Feb 2024 15:55:20 +0800
Message-ID: <20240220075525.684205-3-zhaoyifan@sjtu.edu.cn>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220075525.684205-2-zhaoyifan@sjtu.edu.cn>
References: <20240220075525.684205-1-zhaoyifan@sjtu.edu.cn>
 <20240220075525.684205-2-zhaoyifan@sjtu.edu.cn>
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@linux.alibaba.com>

In order to prepare for multi-threaded decompression.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 configure.ac           |  1 +
 include/erofs/config.h |  1 +
 lib/config.c           | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/configure.ac b/configure.ac
index 53306c3..52b4010 100644
--- a/configure.ac
+++ b/configure.ac
@@ -264,6 +264,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	strerror
 	strrchr
 	strtoull
+	sysconf
 	tmpfile64
 	utimensat]))
 
diff --git a/include/erofs/config.h b/include/erofs/config.h
index eecf575..73e3ac2 100644
--- a/include/erofs/config.h
+++ b/include/erofs/config.h
@@ -109,6 +109,7 @@ static inline int erofs_selabel_open(const char *file_contexts)
 
 void erofs_update_progressinfo(const char *fmt, ...);
 char *erofs_trim_for_progressinfo(const char *str, int placeholder);
+unsigned int erofs_get_available_processors(void);
 
 #ifdef __cplusplus
 }
diff --git a/lib/config.c b/lib/config.c
index 1096cd1..947a183 100644
--- a/lib/config.c
+++ b/lib/config.c
@@ -14,6 +14,9 @@
 #ifdef HAVE_SYS_IOCTL_H
 #include <sys/ioctl.h>
 #endif
+#ifdef HAVE_UNISTD_H
+#include <unistd.h>
+#endif
 
 struct erofs_configure cfg;
 struct erofs_sb_info sbi;
@@ -177,3 +180,12 @@ void erofs_update_progressinfo(const char *fmt, ...)
 	fputs(msg, stdout);
 	fputc('\n', stdout);
 }
+
+unsigned int erofs_get_available_processors(void)
+{
+#if defined(HAVE_UNISTD_H) && defined(HAVE_SYSCONF)
+	return sysconf(_SC_NPROCESSORS_ONLN);
+#else
+	return 0;
+#endif
+}
-- 
2.43.2

