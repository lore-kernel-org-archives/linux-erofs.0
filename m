Return-Path: <SRS0=9fD6=AL=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371A5C433E0
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jun 2020 17:28:28 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0ACA206C0
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jun 2020 17:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="mKJlOCHO";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="r3pIElQD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0ACA206C0
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49xBCZ1FnxzDqPT
	for <linux-erofs@archiver.kernel.org>; Wed,  1 Jul 2020 03:28:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1593538106;
	bh=OtKxRnDoBqQgLAKzYyVlhISW+kOZx55YTkuE/fntDcg=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=mKJlOCHO0BqPTy3LW3JR8ZRFAszAtweIDPeqsZOmWTiGFBrmyoJNwRDob8KRaLXhg
	 QHLNYtuLrzPzaNsIeSfIN9Rxzp4lMevSVzTXfUNJKg9p4XJkg38Qu8ife+7PMh0EbV
	 YuzeuulDrhdRrh1p49/kwR4Xk66HHs3kjMIqBxrV1WGvzGHo39jn5YxjNDA+EGDkLm
	 odKi9bW2eLaxVvaJSFH1jwA/rpzxm8OiiTAWgcspWcVCjwBTM8Aaua9ryUcDLqfIQe
	 c4YsijvijbovAO8Cof7osCi/9jxBcStWKQTBL/2RSPAGUvHaN9nGCxMK+mkihXMC8W
	 hyQkGKNx83+Dw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.40;
 helo=out30-40.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=r3pIElQD; dkim-atps=neutral
Received: from out30-40.freemail.mail.aliyun.com
 (out30-40.freemail.mail.aliyun.com [115.124.30.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49xBCP1Pc2zDqPT
 for <linux-erofs@lists.ozlabs.org>; Wed,  1 Jul 2020 03:28:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1593538086; h=From:To:Subject:Date:Message-Id;
 bh=pbtC2huLa55ZHd9wlGlfNR9c/seYgoGyytCqjDmLlpY=;
 b=r3pIElQDuzhT8hiaX/StogLO7v1FTf57vcHqwhl/eJApJEmFg3D+5WGwFF6YOvgGFa1Oe4hXDbmABCKtYislFSzIEXegnq/H564LcF/BZOwGbLRxOpnL34EDpLi9ElZFeLy++z3JbhbOUZve37ZexQr6EYtaUMNY2XWbGJz5UUU=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.06357798|-1; CH=green;
 DM=|CONTINUE|false|; DS=CONTINUE|ham_alarm|0.0020056-8.76702e-05-0.997907;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e07425; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0U1CRvln_1593538083; 
Received: from localhost(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0U1CRvln_1593538083) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 01 Jul 2020 01:28:03 +0800
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v10] erofs-utils: introduce segment compression
Date: Wed,  1 Jul 2020 01:27:58 +0800
Message-Id: <20200630172758.6533-1-bluce.lee@aliyun.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621143711.GA27245@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20200621143711.GA27245@hsiangkao-HP-ZHAN-66-Pro-G1>
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
From: Li Guifu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li Guifu <bluce.lee@aliyun.com>
Cc: Li Guifu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Support segment compression which seperates files in several logic
units (segments) and each segment is compressed independently.

Advantages:
 - more friendly for data differencing;
 - it can also be used for parallel compression in the same file later.

Signed-off-by: Li Guifu <bluce.lee@aliyun.com>
---
 include/erofs/config.h |  1 +
 lib/compress.c         | 29 +++++++++++++++++++++++------
 lib/config.c           |  1 +
 man/mkfs.erofs.1       |  4 ++++
 mkfs/main.c            | 16 +++++++++++++++-
 5 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/erofs/config.h b/include/erofs/config.h
index 2f09749..e5f1bfb 100644
--- a/include/erofs/config.h
+++ b/include/erofs/config.h
@@ -35,6 +35,7 @@ struct erofs_configure {
 	char *c_img_path;
 	char *c_src_path;
 	char *c_compr_alg_master;
+	u64 c_compr_seg_size;
 	int c_compr_level_master;
 	int c_force_inodeversion;
 	/* < 0, xattr disabled and INT_MAX, always use inline xattrs */
diff --git a/lib/compress.c b/lib/compress.c
index 6cc68ed..2ea5809 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -32,6 +32,7 @@ struct z_erofs_vle_compress_ctx {
 
 	erofs_blk_t blkaddr;	/* pointing to the next blkaddr */
 	u16 clusterofs;
+	u64 segavail;
 };
 
 #define Z_EROFS_LEGACY_MAP_HEADER_SIZE	\
@@ -116,7 +117,7 @@ static void vle_write_indexes(struct z_erofs_vle_compress_ctx *ctx,
 }
 
 static int write_uncompressed_block(struct z_erofs_vle_compress_ctx *ctx,
-				    unsigned int *len,
+				    unsigned int *len, unsigned int *ucomproft,
 				    char *dst)
 {
 	int ret;
@@ -125,14 +126,19 @@ static int write_uncompressed_block(struct z_erofs_vle_compress_ctx *ctx,
 	/* reset clusterofs to 0 if permitted */
 	if (!erofs_sb_has_lz4_0padding() &&
 	    ctx->head >= ctx->clusterofs) {
+		*ucomproft = ctx->clusterofs;
 		ctx->head -= ctx->clusterofs;
 		*len += ctx->clusterofs;
 		ctx->clusterofs = 0;
+		count = min(EROFS_BLKSIZ, *len);
+	} else {
+		*ucomproft = 0;
+		count = min_t(u64, ctx->segavail, *len);
+		if (count > EROFS_BLKSIZ)
+			count = EROFS_BLKSIZ;
 	}
 
 	/* write uncompressed data */
-	count = min(EROFS_BLKSIZ, *len);
-
 	memcpy(dst, ctx->queue + ctx->head, count);
 	memset(dst + count, 0, EROFS_BLKSIZ - count);
 
@@ -157,14 +163,21 @@ static int vle_compress_one(struct erofs_inode *inode,
 
 	while (len) {
 		bool raw;
+		unsigned int ucomproft = 0;
+
+		if (ctx->segavail <= EROFS_BLKSIZ) {
+			if (len < ctx->segavail && !final)
+				break;
+
+			goto nocompression;
+		}
 
 		if (len <= EROFS_BLKSIZ) {
 			if (final)
 				goto nocompression;
 			break;
 		}
-
-		count = len;
+		count = min_t(u64, len, ctx->segavail);
 		ret = erofs_compress_destsize(h, compressionlevel,
 					      ctx->queue + ctx->head,
 					      &count, dst, EROFS_BLKSIZ);
@@ -175,7 +188,7 @@ static int vle_compress_one(struct erofs_inode *inode,
 					  erofs_strerror(ret));
 			}
 nocompression:
-			ret = write_uncompressed_block(ctx, &len, dst);
+			ret = write_uncompressed_block(ctx, &len, &ucomproft, dst);
 			if (ret < 0)
 				return ret;
 			count = ret;
@@ -202,6 +215,9 @@ nocompression:
 
 		++ctx->blkaddr;
 		len -= count;
+		ctx->segavail -= count - ucomproft;
+		if (!ctx->segavail)
+			ctx->segavail = cfg.c_compr_seg_size;
 
 		if (!final && ctx->head >= EROFS_CONFIG_COMPR_MAX_SZ) {
 			const unsigned int qh_aligned =
@@ -422,6 +438,7 @@ int erofs_write_compressed_file(struct erofs_inode *inode)
 	ctx.head = ctx.tail = 0;
 	ctx.clusterofs = 0;
 	remaining = inode->i_size;
+	ctx.segavail = cfg.c_compr_seg_size;
 
 	while (remaining) {
 		const u64 readcount = min_t(u64, remaining,
diff --git a/lib/config.c b/lib/config.c
index da0c260..721ff61 100644
--- a/lib/config.c
+++ b/lib/config.c
@@ -23,6 +23,7 @@ void erofs_init_configure(void)
 	cfg.c_force_inodeversion = 0;
 	cfg.c_inline_xattr_tolerance = 2;
 	cfg.c_unix_timestamp = -1;
+	cfg.c_compr_seg_size = -1;
 }
 
 void erofs_show_config(void)
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 891c5a8..2a4ef71 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -52,6 +52,10 @@ Forcely generate extended inodes (64-byte inodes) to output.
 Set all files to the given UNIX timestamp. Reproducible builds requires setting
 all to a specific one.
 .TP
+.BI "\-S " #
+Set max input stream size for each individual segment (disabled if 0).
+The default value is 0. It has be aligned with blocksize.
+.TP
 .BI "\-\-exclude-path=" path
 Ignore file that matches the exact literal path.
 You may give multiple `--exclude-path' options.
diff --git a/mkfs/main.c b/mkfs/main.c
index 94bf1e6..cded973 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -61,6 +61,7 @@ static void usage(void)
 	      " -x#               set xattr tolerance to # (< 0, disable xattrs; default 2)\n"
 	      " -EX[,...]         X=extended options\n"
 	      " -T#               set a fixed UNIX timestamp # to all files\n"
+	      " -S#               Set max input stream size # for each individual segment\n"
 	      " --exclude-path=X  avoid including file X (X = exact literal path)\n"
 	      " --exclude-regex=X avoid including files that match X (X = regular expression)\n"
 #ifdef HAVE_LIBSELINUX
@@ -138,7 +139,7 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 	char *endptr;
 	int opt, i;
 
-	while((opt = getopt_long(argc, argv, "d:x:z:E:T:",
+	while((opt = getopt_long(argc, argv, "d:x:z:E:T:S:",
 				 long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'z':
@@ -188,6 +189,19 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 				return -EINVAL;
 			}
 			break;
+		case 'S':
+			i = strtoll(optarg, &endptr, 0);
+			if (*endptr != '\0') {
+				erofs_err("invalid compress segment size %s",
+					  optarg);
+				return -EINVAL;
+			}
+			if (!i) {
+				cfg.c_compr_seg_size = -1;
+			} else {
+				cfg.c_compr_seg_size = i * EROFS_BLKSIZ;
+			}
+			break;
 		case 2:
 			opt = erofs_parse_exclude_path(optarg, false);
 			if (opt) {
-- 
2.17.1

