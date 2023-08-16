Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A2BC001DE
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Aug 2023 02:14:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RQWsg2RXpz3cP2
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Aug 2023 12:14:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RQWsL0tSYz300f
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Aug 2023 12:13:57 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Vptqv7n_1692152031;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0Vptqv7n_1692152031)
          by smtp.aliyun-inc.com;
          Wed, 16 Aug 2023 10:13:52 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 04/12] erofs-utils: lib: fix erofs_init_devices() in multidev mode
Date: Wed, 16 Aug 2023 10:13:39 +0800
Message-Id: <20230816021347.126886-5-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230816021347.126886-1-jefflexu@linux.alibaba.com>
References: <20230816021347.126886-1-jefflexu@linux.alibaba.com>
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

Fix the missing le32_to_cpu().  Read and cache blocks of each device for
later use.

Initialize sbi->extra_devices from on-disk extra_devices.

Fixes: 0ce853a01123 ("erofs-utils: fuse: add multiple device support")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 lib/super.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/super.c b/lib/super.c
index e8e84aa..54ab29b 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -36,11 +36,7 @@ static int erofs_init_devices(struct erofs_sb_info *sbi,
 	else
 		ondisk_extradevs = le16_to_cpu(dsb->extra_devices);
 
-	if (ondisk_extradevs != sbi->extra_devices) {
-		erofs_err("extra devices don't match (ondisk %u, given %u)",
-			  ondisk_extradevs, sbi->extra_devices);
-		return -EINVAL;
-	}
+	sbi->extra_devices = ondisk_extradevs;
 	if (!ondisk_extradevs)
 		return 0;
 
@@ -59,8 +55,9 @@ static int erofs_init_devices(struct erofs_sb_info *sbi,
 			return ret;
 		}
 
-		sbi->devs[i].mapped_blkaddr = dis.mapped_blkaddr;
-		sbi->total_blocks += dis.blocks;
+		sbi->devs[i].mapped_blkaddr = le32_to_cpu(dis.mapped_blkaddr);
+		sbi->devs[i].blocks = le32_to_cpu(dis.blocks);
+		sbi->total_blocks += sbi->devs[i].blocks;
 		pos += EROFS_DEVT_SLOT_SIZE;
 	}
 	return 0;
-- 
2.19.1.6.gb485710b

