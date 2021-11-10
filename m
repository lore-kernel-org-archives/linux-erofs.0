Return-Path: <SRS0=O9pT=P5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF76C433EF
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Nov 2021 06:50:36 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 79A456117A
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Nov 2021 06:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 79A456117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HpwTk1Jqvz2yY0
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Nov 2021 17:50:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.43;
 helo=out30-43.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HpwTb1HPJz2xRp
 for <linux-erofs@lists.ozlabs.org>; Wed, 10 Nov 2021 17:50:25 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R561e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=2; SR=0; TI=SMTPD_---0UvsTLUG_1636527009; 
Received: from
 e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UvsTLUG_1636527009) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 10 Nov 2021 14:50:09 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: fsck: use "--extract" instead of "-c"
Date: Wed, 10 Nov 2021 14:50:08 +0800
Message-Id: <20211110065008.182193-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211110064931.181727-1-hsiangkao@linux.alibaba.com>
References: <20211110064931.181727-1-hsiangkao@linux.alibaba.com>
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

Keep in sync with fsck.cramfs naming.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fsck/main.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index d05dd55833aa..ae6c00202a69 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -23,6 +23,7 @@ static struct erofsfsck_cfg fsckcfg;
 
 static struct option long_options[] = {
 	{"help", no_argument, 0, 1},
+	{"extract", no_argument, 0, 2},
 	{0, 0, 0, 0},
 };
 
@@ -30,11 +31,11 @@ static void usage(void)
 {
 	fputs("usage: [options] IMAGE\n\n"
 	      "Check erofs filesystem integrity of IMAGE, and [options] are:\n"
-	      " -V      print the version number of fsck.erofs and exit.\n"
-	      " -d#     set output message level to # (maximum 9)\n"
-	      " -p      print total compression ratio of all files\n"
-	      " -c      check if all compressed files are well decompressed\n"
-	      " --help  display this help and exit.\n",
+	      " -V              print the version number of fsck.erofs and exit.\n"
+	      " -d#             set output message level to # (maximum 9)\n"
+	      " -p              print total compression ratio of all files\n"
+	      " --extract       check if all files are well decoded\n"
+	      " --help          display this help and exit.\n",
 	      stderr);
 }
 
@@ -47,7 +48,7 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 {
 	int opt, i;
 
-	while ((opt = getopt_long(argc, argv, "Vd:pc",
+	while ((opt = getopt_long(argc, argv, "Vd:p",
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'V':
@@ -64,12 +65,12 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 		case 'p':
 			fsckcfg.print_comp_ratio = true;
 			break;
-		case 'c':
-			fsckcfg.check_decomp = true;
-			break;
 		case 1:
 			usage();
 			exit(0);
+		case 2:
+			fsckcfg.check_decomp = true;
+			break;
 		default:
 			return -EINVAL;
 		}
-- 
2.24.4

