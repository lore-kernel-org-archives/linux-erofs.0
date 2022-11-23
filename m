Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E31C433FE
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Nov 2022 02:30:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NH4qZ5ZS2z3cMy
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Nov 2022 13:30:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.42; helo=out30-42.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NH4qV0yvtz2xJN
	for <linux-erofs@lists.ozlabs.org>; Wed, 23 Nov 2022 13:30:44 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VVUjrCF_1669170634;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VVUjrCF_1669170634)
          by smtp.aliyun-inc.com;
          Wed, 23 Nov 2022 10:30:39 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs-utils: lib: fix missing CBLKCNT for big pcluster dedupe
Date: Wed, 23 Nov 2022 10:30:34 +0800
Message-Id: <20221123023034.123095-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20221122064527.26563-1-hsiangkao@linux.alibaba.com>
References: <20221122064527.26563-1-hsiangkao@linux.alibaba.com>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Yue Hu <huyue2@coolpad.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

CBLKCNT needs to be stored for big pcluster dedupe.  Otherwise,
the decompression could fail due to incomplete compressed data.

Reported-by: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
changes since v1:
 - fix potential data corruption of v1

 lib/compress.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/lib/compress.c b/lib/compress.c
index 17b3213..8f4c63a 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -186,12 +186,22 @@ static int z_erofs_compress_dedupe(struct erofs_inode *inode,
 		if (z_erofs_dedupe_match(&dctx))
 			break;
 
+		delta = ctx->queue + ctx->head - dctx.cur;
+		/*
+		 * For big pcluster dedupe, leave two indices at least to store
+		 * CBLKCNT as the first step.  Even laterly, an one-block
+		 * decompresssion could be done as another try in practice.
+		 */
+		if (dctx.e.compressedblks > 1 &&
+		    (ctx->clusterofs + ctx->e.length - delta) % EROFS_BLKSIZ +
+			dctx.e.length < 2 * EROFS_BLKSIZ)
+			break;
+
 		/* fall back to noncompact indexes for deduplication */
 		inode->z_advise &= ~Z_EROFS_ADVISE_COMPACTED_2B;
 		inode->datalayout = EROFS_INODE_FLAT_COMPRESSION_LEGACY;
 		erofs_sb_set_dedupe();
 
-		delta = ctx->queue + ctx->head - dctx.cur;
 		if (delta) {
 			DBG_BUGON(delta < 0);
 			DBG_BUGON(!ctx->e.length);
-- 
2.24.4

