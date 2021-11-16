Return-Path: <SRS0=KC2W=QD=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D30C433F5
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Nov 2021 00:06:57 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA6CE63238
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Nov 2021 00:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DA6CE63238
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HtRFC3Ydkz2yNT
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Nov 2021 11:06:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132;
 helo=out30-132.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HtRF570H9z2xtM
 for <linux-erofs@lists.ozlabs.org>; Tue, 16 Nov 2021 11:06:44 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R631e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=3; SR=0; TI=SMTPD_---0Uwm03mJ_1637021183; 
Received: from
 e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Uwm03mJ_1637021183) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 16 Nov 2021 08:06:28 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: dump: refine file info statistics
Date: Tue, 16 Nov 2021 08:06:19 +0800
Message-Id: <20211116000619.190667-1-hsiangkao@linux.alibaba.com>
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

Also print the file type when dumping file info.

Cc: Guo Xuenan <guoxuenan@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 dump/main.c           | 16 +++++++++-------
 include/erofs/inode.h |  1 +
 lib/inode.c           |  2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/dump/main.c b/dump/main.c
index 401e6841aefb..a7199937b8e0 100644
--- a/dump/main.c
+++ b/dump/main.c
@@ -9,6 +9,7 @@
 #include <getopt.h>
 #include <time.h>
 #include "erofs/print.h"
+#include "erofs/inode.h"
 #include "erofs/io.h"
 
 #ifdef HAVE_LIBUUID
@@ -461,16 +462,17 @@ static void erofsdump_show_fileinfo(bool show_extent)
 		if (((access_mode >> i) & 1) == 0)
 			access_mode_str[8 - i] = '-';
 	fprintf(stdout, "File : %s\n", path);
-	fprintf(stdout, "NID: %" PRIu64 "  ", inode.nid);
-	fprintf(stdout, "Links: %u  ", inode.i_nlink);
-	fprintf(stdout, "Layout: %d\n", inode.datalayout);
+	fprintf(stdout, "Size: %" PRIu64"  On-disk size: %" PRIu64 "  %s\n",
+		inode.i_size, size,
+		file_category_types[erofs_mode_to_ftype(inode.i_mode)]);
+	fprintf(stdout, "NID: %" PRIu64 "   ", inode.nid);
+	fprintf(stdout, "Links: %u   ", inode.i_nlink);
+	fprintf(stdout, "Layout: %d   Compression ratio: %.2f%%\n",
+		inode.datalayout,
+		(double)(100 * size) / (double)(inode.i_size));
 	fprintf(stdout, "Inode size: %d   ", inode.inode_isize);
 	fprintf(stdout, "Extent size: %u   ", inode.extent_isize);
 	fprintf(stdout,	"Xattr size: %u\n", inode.xattr_isize);
-	fprintf(stdout, "File size: %" PRIu64"  ", inode.i_size);
-	fprintf(stdout,	"On-disk size: %" PRIu64 "  ", size);
-	fprintf(stdout, "Compression ratio: %.2f%%\n",
-			(double)(100 * size) / (double)(inode.i_size));
 	fprintf(stdout, "Uid: %u   Gid: %u  ", inode.i_uid, inode.i_gid);
 	fprintf(stdout, "Access: %04o/%s\n", access_mode, access_mode_str);
 	fprintf(stdout, "Timestamp: %s.%09d\n", timebuf, inode.i_ctime_nsec);
diff --git a/include/erofs/inode.h b/include/erofs/inode.h
index a73676212ccf..d5343c242aee 100644
--- a/include/erofs/inode.h
+++ b/include/erofs/inode.h
@@ -10,6 +10,7 @@
 
 #include "erofs/internal.h"
 
+unsigned char erofs_mode_to_ftype(umode_t mode);
 void erofs_inode_manager_init(void);
 unsigned int erofs_iput(struct erofs_inode *inode);
 erofs_nid_t erofs_lookupnid(struct erofs_inode *inode);
diff --git a/lib/inode.c b/lib/inode.c
index 6597a26f7ac4..855a0383f31e 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -37,7 +37,7 @@ static unsigned char erofs_ftype_by_mode[S_IFMT >> S_SHIFT] = {
 	[S_IFLNK >> S_SHIFT]  = EROFS_FT_SYMLINK,
 };
 
-static unsigned char erofs_mode_to_ftype(umode_t mode)
+unsigned char erofs_mode_to_ftype(umode_t mode)
 {
 	return erofs_ftype_by_mode[(mode & S_IFMT) >> S_SHIFT];
 }
-- 
2.24.4

