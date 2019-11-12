Return-Path: <SRS0=HQBZ=ZE=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535B0C43331
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2019 11:25:27 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E7EBD22469
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2019 11:25:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7EBD22469
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47C55H6c05zF4kS
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2019 22:25:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.32; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47C54T5B44zF4FV
 for <linux-erofs@lists.ozlabs.org>; Tue, 12 Nov 2019 22:24:41 +1100 (AEDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 0E5FB5C9D1D469B7B3D5
 for <linux-erofs@lists.ozlabs.org>; Tue, 12 Nov 2019 19:24:33 +0800 (CST)
Received: from architecture4.huawei.com (10.140.130.215) by smtp.huawei.com
 (10.3.19.209) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 12 Nov
 2019 19:24:23 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Li Guifu <bluce.liguifu@huawei.com>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 2/2] erofs-utils: set up all compiler/linker variables
 independently
Date: Tue, 12 Nov 2019 19:26:50 +0800
Message-ID: <20191112112650.143498-2-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112112650.143498-1-gaoxiang25@huawei.com>
References: <20191112112650.143498-1-gaoxiang25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.140.130.215]
X-CFilter-Loop: Reflected
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
Cc: Miao Xie <miaoxie@huawei.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Otherwise, the following checking will be effected
and it can cause unexpected behavior on configuring.

Founded by the upcoming XZ algorithm patches.

Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 configure.ac | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/configure.ac b/configure.ac
index a93767f61578..a5adf172cc43 100644
--- a/configure.ac
+++ b/configure.ac
@@ -131,7 +131,7 @@ if test "x$enable_lz4" = "xyes"; then
   test -z "${with_lz4_libdir}" || LZ4_LIBS="-L$with_lz4_libdir $LZ4_LIBS"
 
   saved_CPPFLAGS=${CPPFLAGS}
-  CPPFLAGS="${LZ4_CFLAGS} ${CFLAGS}"
+  CPPFLAGS="${LZ4_CFLAGS} ${CPPFLAGS}"
 
   AC_CHECK_HEADERS([lz4.h],[have_lz4h="yes"], [])
 
@@ -150,28 +150,29 @@ if test "x$enable_lz4" = "xyes"; then
       ])
     ], [AC_MSG_ERROR([Cannot find proper lz4 version (>= 1.8.0)])])
     LDFLAGS=${saved_LDFLAGS}
-
-    if test "x${have_lz4}" = "xyes"; then
-      AC_DEFINE([LZ4_ENABLED], [1], [Define to 1 if lz4 is enabled.])
-
-      if test "x${have_lz4hc}" = "xyes"; then
-        AC_DEFINE([LZ4HC_ENABLED], [1], [Define to 1 if lz4hc is enabled.])
-      fi
-
-      if test "x${lz4_force_static}" = "xyes"; then
-        LDFLAGS="-all-static ${LDFLAGS}"
-      else
-	test -z "${with_lz4_libdir}" || LZ4_LIBS="-R ${with_lz4_libdir} $LZ4_LIBS"
-      fi
-      LIBS="$LZ4_LIBS $LIBS"
-    fi
   fi
-  CFLAGS=${saved_CPPFLAGS}
+  CPPFLAGS=${saved_CPPFLAGS}
 fi
 
+# Set up needed symbols, conditionals and compiler/linker flags
 AM_CONDITIONAL([ENABLE_LZ4], [test "x${have_lz4}" = "xyes"])
 AM_CONDITIONAL([ENABLE_LZ4HC], [test "x${have_lz4hc}" = "xyes"])
 
+if test "x${have_lz4}" = "xyes"; then
+  AC_DEFINE([LZ4_ENABLED], [1], [Define to 1 if lz4 is enabled.])
+
+  if test "x${have_lz4hc}" = "xyes"; then
+    AC_DEFINE([LZ4HC_ENABLED], [1], [Define to 1 if lz4hc is enabled.])
+  fi
+
+  if test "x${lz4_force_static}" = "xyes"; then
+    LDFLAGS="-all-static ${LDFLAGS}"
+  else
+    test -z "${with_lz4_libdir}" || LZ4_LIBS="-R ${with_lz4_libdir} $LZ4_LIBS"
+  fi
+  LIBS="$LZ4_LIBS $LIBS"
+fi
+
 AC_CONFIG_FILES([Makefile
 		 man/Makefile
 		 lib/Makefile
-- 
2.17.1

