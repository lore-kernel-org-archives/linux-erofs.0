Return-Path: <SRS0=xEWh=I6=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC41C433ED
	for <linux-erofs@archiver.kernel.org>; Thu,  1 Apr 2021 03:30:21 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD398610E6
	for <linux-erofs@archiver.kernel.org>; Thu,  1 Apr 2021 03:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD398610E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4F9pbb3Smnz303J
	for <linux-erofs@archiver.kernel.org>; Thu,  1 Apr 2021 14:30:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=WH4G9nIv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=WH4G9nIv; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4F9pbY5Wwzz30KL
 for <linux-erofs@lists.ozlabs.org>; Thu,  1 Apr 2021 14:30:17 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50A91610D2;
 Thu,  1 Apr 2021 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617247815;
 bh=QEUBS2zczij3ArtTdghjLRfheNOhvp84S+Ht6X8gywM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WH4G9nIv93zRV3ciwcmNXinfPXtcE+6uD6mBMwLHmuhMX7PDfSscq2+hq20okXjq2
 Ets5ds9Q7aKvMMwvR8TpHSk4po54iaf6Kah3RemTNBLfEyZK87JCpV3kBQPINe3bP7
 qH+ymFKaeuHP/MpztC9gqZapSzShBmm0/RHCMJ2BsqdTJZkitv2fzVF8+l95QwWd9E
 QX48rWX95ltT8JwLFhVJWAeeS7vHgZXL1k4ktYMsrjVEvoPOWNwwXZgr9VKL8IsoFJ
 Fb0W/ywAuKYzY4c9StnNGXqO4KisY5eBsCNK0jQsgsVZa21KxWjPj+6MiDi0meJQSX
 L4ZhlXVAuJI0Q==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>,
 Chao Yu <chao@kernel.org>
Subject: [PATCH v2 06/10] erofs: adjust per-CPU buffers according to
 max_pclusterblks
Date: Thu,  1 Apr 2021 11:29:50 +0800
Message-Id: <20210401032954.20555-7-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210401032954.20555-1-xiang@kernel.org>
References: <20210401032954.20555-1-xiang@kernel.org>
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@redhat.com>

Adjust per-CPU buffers on demand since big pcluster definition is
available. Also, bail out unsupported pcluster size according to
Z_EROFS_PCLUSTER_MAX_SIZE.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/decompressor.c | 16 ++++++++++++----
 fs/erofs/internal.h     |  2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index fb4838c0f0df..5d9f9dbd3681 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -32,6 +32,7 @@ int z_erofs_load_lz4_config(struct super_block *sb,
 			    struct erofs_super_block *dsb,
 			    struct z_erofs_lz4_cfgs *lz4, int size)
 {
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	u16 distance;
 
 	if (lz4) {
@@ -40,16 +41,23 @@ int z_erofs_load_lz4_config(struct super_block *sb,
 			return -EINVAL;
 		}
 		distance = le16_to_cpu(lz4->max_distance);
+
+		sbi->lz4.max_pclusterblks = le16_to_cpu(lz4->max_pclusterblks);
+		if (sbi->lz4.max_pclusterblks >
+		    Z_EROFS_PCLUSTER_MAX_SIZE / EROFS_BLKSIZ) {
+			erofs_err(sb, "too large lz4 pcluster blocks %u",
+				  sbi->lz4.max_pclusterblks);
+			return -EINVAL;
+		}
 	} else {
 		distance = le16_to_cpu(dsb->u1.lz4_max_distance);
+		sbi->lz4.max_pclusterblks = 1;
 	}
 
-	EROFS_SB(sb)->lz4.max_distance_pages = distance ?
+	sbi->lz4.max_distance_pages = distance ?
 					DIV_ROUND_UP(distance, PAGE_SIZE) + 1 :
 					LZ4_MAX_DISTANCE_PAGES;
-
-	/* TODO: use max pclusterblks after bigpcluster is enabled */
-	return erofs_pcpubuf_growsize(1);
+	return erofs_pcpubuf_growsize(sbi->lz4.max_pclusterblks);
 }
 
 static int z_erofs_lz4_prepare_destpages(struct z_erofs_decompress_req *rq,
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index c4b3938a7e56..f1305af50f67 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -63,6 +63,8 @@ struct erofs_fs_context {
 struct erofs_sb_lz4_info {
 	/* # of pages needed for EROFS lz4 rolling decompression */
 	u16 max_distance_pages;
+	/* maximum possible blocks for pclusters in the filesystem */
+	u16 max_pclusterblks;
 };
 
 struct erofs_sb_info {
-- 
2.20.1

