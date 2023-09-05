Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66909C83F33
	for <linux-erofs@archiver.kernel.org>; Tue,  5 Sep 2023 10:03:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Rg1KV10Ldz3c7T
	for <linux-erofs@archiver.kernel.org>; Tue,  5 Sep 2023 20:03:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Rg1Jy64z5z3bhp
	for <linux-erofs@lists.ozlabs.org>; Tue,  5 Sep 2023 20:02:42 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VrPVOvd_1693908156;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VrPVOvd_1693908156)
          by smtp.aliyun-inc.com;
          Tue, 05 Sep 2023 18:02:37 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v6 09/11] erofs-utils: lib: add erofs_inode_is_whiteout() helper
Date: Tue,  5 Sep 2023 18:02:25 +0800
Message-Id: <20230905100227.1072-10-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230905100227.1072-1-jefflexu@linux.alibaba.com>
References: <20230905100227.1072-1-jefflexu@linux.alibaba.com>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Add erofs_inode_is_whiteout() helper checking if given inode is a
whiteout.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 include/erofs/internal.h | 7 +++++++
 lib/tar.c                | 2 --
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index fcc0710..5df689c 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -20,6 +20,7 @@ typedef unsigned short umode_t;
 #include "erofs_fs.h"
 #include <fcntl.h>
 #include <sys/types.h> /* for off_t definition */
+#include <sys/stat.h> /* for S_ISCHR definition */
 #include <stdio.h>
 
 #ifndef PATH_MAX
@@ -427,6 +428,12 @@ static inline u32 erofs_crc32c(u32 crc, const u8 *in, size_t len)
 	return crc;
 }
 
+#define EROFS_WHITEOUT_DEV	0
+static inline bool erofs_inode_is_whiteout(struct erofs_inode *inode)
+{
+	return S_ISCHR(inode->i_mode) && inode->u.i_rdev == EROFS_WHITEOUT_DEV;
+}
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/lib/tar.c b/lib/tar.c
index e0fe2a2..8cb392c 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -13,8 +13,6 @@
 #include "erofs/blobchunk.h"
 #include "erofs/rebuild.h"
 
-#define EROFS_WHITEOUT_DEV	0
-
 static char erofs_libbuf[16384];
 
 struct tar_header {
-- 
2.19.1.6.gb485710b

