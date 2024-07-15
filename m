Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEE4C2BD09
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jul 2024 03:38:56 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=V3H/yusZ;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WMnxB0yS8z3cfK
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jul 2024 13:38:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=V3H/yusZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WMnx10WhDz30Wh
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jul 2024 13:38:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1721014718; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=oxst+QyFw5XGV7UneSmXYYRtYVSol+kuGdaHg8fM4Vw=;
	b=V3H/yusZ25p4813M+qo6JBL/HUId3nIBEiBf1ZKjRtEujseAz79kN7Az6v7hSIPpXvxZXy/ag5e1Ur6LFHf8DMy4j9fRpDrv6oCgs/QcmchDe21feMcns1sRNB108kGiutYLraTPHDRohAYwc36TfptlfEOerprYnUcrGa7RG3U=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0WAV5j7f_1721014710;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WAV5j7f_1721014710)
          by smtp.aliyun-inc.com;
          Mon, 15 Jul 2024 11:38:37 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: manpages: add more description for --extract option
Date: Mon, 15 Jul 2024 11:38:29 +0800
Message-ID: <20240715033829.2338056-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Especially, extract files to a specific directory.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 man/fsck.erofs.1 | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/man/fsck.erofs.1 b/man/fsck.erofs.1
index c94fff9..9cb14e2 100644
--- a/man/fsck.erofs.1
+++ b/man/fsck.erofs.1
@@ -27,15 +27,17 @@ You may give multiple
 .B --device
 options in the correct order.
 .TP
-.B \-\-extract
-Check if all files are well encoded. This read all compressed files,
-and hence create more I/O load,
-so it might take too much time depending on the image.
+.BI "\-\-extract" "[=directory]"
+Test to extract the whole file system. It scans all inode data, including
+compressed inode data, which leads to more I/O and CPU load, so it might
+take a long time depending on the image.
+
+Optionally extract contents of the \fIIMAGE\fR to \fIdirectory\fR.
 .TP
 \fB\-h\fR, \fB\-\-help\fR
 Display help string and exit.
 .TP
-\fB\-a\fR, \fB\-A\fR, \fB-y\R
+\fB\-a\fR, \fB\-A\fR, \fB-y\fR
 These options do nothing at all; they are provided only for compatibility with
 the fsck programs of other filesystems.
 .SH AUTHOR
-- 
2.43.5

