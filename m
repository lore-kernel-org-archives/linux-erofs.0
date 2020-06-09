Return-Path: <SRS0=Vk8v=7W=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBFFC433DF
	for <linux-erofs@archiver.kernel.org>; Tue,  9 Jun 2020 15:23:39 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DEFA22072F
	for <linux-erofs@archiver.kernel.org>; Tue,  9 Jun 2020 15:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="KZT+uk7V";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="RZRHj+WP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEFA22072F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49hDRF24VbzDqTT
	for <linux-erofs@archiver.kernel.org>; Wed, 10 Jun 2020 01:23:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1591716217;
	bh=tHAyYRsZnwHpziX5HOydpaoroRXmqLftMDS8OnhZ1W4=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=KZT+uk7VDdTcmuQqs8ZeOcX4to2rYmHU2lKOuAGTnxVnIjth2Ze3/71sFzVBMvxAM
	 Ekfq1ZBbD/SkvhYhCBisZQjvV2OeslvkOymDrFy0LmYuRGScW79O7iYEBuElWa2yZI
	 hHRqCLtjPMh7jz/zDoP8IS2K6Rl1xVU7L0cdyip+jAGptmor/6jpQUkAPbxbx80Xy3
	 i9G8FZ0vu23kET7ffc4LOPANMDkCkGxB9nAtBFY87EwvGSyxjLvpD1CkckWaJobGrm
	 ZXOFR/mnTlj1xT8Bt46vtmBEtF96annaBbgUXba4otAMqLg4Ky/0RZjZC9q3tL1rst
	 DQupxuItSr1aw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.16;
 helo=out30-16.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=RZRHj+WP; dkim-atps=neutral
Received: from out30-16.freemail.mail.aliyun.com
 (out30-16.freemail.mail.aliyun.com [115.124.30.16])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49hDR214DwzDqSH
 for <linux-erofs@lists.ozlabs.org>; Wed, 10 Jun 2020 01:23:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1591716198; h=From:To:Subject:Date:Message-Id;
 bh=FYfUO5xzIXLR8MXFKCsJ8WsDzhKfb/E7wuzuJT5IOzE=;
 b=RZRHj+WPX4USpi0qIo5dXxPEmc4FzRrb7bL2PcFg1JrdG074dyQY7kn3QuobtTt4VpX1vYAeMGpYKS6y1T2zVnSd1Qjucr6kwiTsJwodcSumeCl9Y56nPh3pqooLqHRJSzTh50RgXMB0MFI6h4CkVXDrf+S+gbvzNG3tk8r5PoM=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.07357813|-1; CH=green;
 DM=|CONTINUE|false|; DS=CONTINUE|ham_alarm|0.175732-0.000525378-0.823743;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04394; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0U.6LfUt_1591716194; 
Received: from localhost(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0U.6LfUt_1591716194) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 09 Jun 2020 23:23:15 +0800
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: add a compress limit to source input stream
Date: Tue,  9 Jun 2020 23:22:57 +0800
Message-Id: <20200609152257.4305-1-bluce.lee@aliyun.com>
X-Mailer: git-send-email 2.17.1
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

It cause a differential amplification when create binary diff
image for upgrade. Give a limits to cut compress, so the amplification
will be limit in the given size.

Signed-off-by: Li Guifu <bluce.lee@aliyun.com>
---
 include/erofs/internal.h |  1 +
 lib/compress.c           | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 41da189..367c0b0 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -41,6 +41,7 @@ typedef unsigned short umode_t;
 
 #define EROFS_ISLOTBITS		5
 #define EROFS_SLOTSIZE		(1U << EROFS_ISLOTBITS)
+#define EROFS_COMPR_LIMITS	(1024U * EROFS_BLKSIZ)
 
 typedef u64 erofs_off_t;
 typedef u64 erofs_nid_t;
diff --git a/lib/compress.c b/lib/compress.c
index 6cc68ed..9fe1428 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -150,7 +150,7 @@ static int vle_compress_one(struct erofs_inode *inode,
 {
 	struct erofs_compress *const h = &compresshandle;
 	unsigned int len = ctx->tail - ctx->head;
-	unsigned int count;
+	unsigned int count = 0;
 	int ret;
 	static char dstbuf[EROFS_BLKSIZ * 2];
 	char *const dst = dstbuf + EROFS_BLKSIZ;
@@ -159,7 +159,7 @@ static int vle_compress_one(struct erofs_inode *inode,
 		bool raw;
 
 		if (len <= EROFS_BLKSIZ) {
-			if (final)
+			if (!count || final)
 				goto nocompression;
 			break;
 		}
@@ -392,7 +392,7 @@ int erofs_write_compressed_file(struct erofs_inode *inode)
 {
 	struct erofs_buffer_head *bh;
 	struct z_erofs_vle_compress_ctx ctx;
-	erofs_off_t remaining;
+	erofs_off_t remaining, comprlimits;
 	erofs_blk_t blkaddr, compressed_blocks;
 	unsigned int legacymetasize;
 	int ret, fd;
@@ -422,6 +422,7 @@ int erofs_write_compressed_file(struct erofs_inode *inode)
 	ctx.head = ctx.tail = 0;
 	ctx.clusterofs = 0;
 	remaining = inode->i_size;
+	comprlimits = EROFS_COMPR_LIMITS;
 
 	while (remaining) {
 		const u64 readcount = min_t(u64, remaining,
@@ -434,11 +435,19 @@ int erofs_write_compressed_file(struct erofs_inode *inode)
 		}
 		remaining -= readcount;
 		ctx.tail += readcount;
+		comprlimits -= readcount;
 
+compr_continue:
 		/* do one compress round */
 		ret = vle_compress_one(inode, &ctx, false);
 		if (ret)
 			goto err_bdrop;
+		if (!comprlimits) {
+			if (ctx.head != ctx.tail)
+				goto compr_continue;
+			ctx.clusterofs = 0;
+			comprlimits = EROFS_COMPR_LIMITS;
+		}
 	}
 
 	/* do the final round */
-- 
2.17.1

