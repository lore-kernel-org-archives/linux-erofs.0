Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 298EFC3DA64
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Aug 2024 02:28:56 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VMr+XtUF;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WcgNl1r0Pz3cXM
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Aug 2024 12:28:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VMr+XtUF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WcgNZ6fgSz3c5W
	for <linux-erofs@lists.ozlabs.org>; Mon,  5 Aug 2024 12:28:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1722824919; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=sgLrA3O5tk8JXM+FWfLnl7ZZqZd/LZ+uPjVkkdOzbGo=;
	b=VMr+XtUFaLXXOFfnIkQiPydZK5Hz18AEDO/7/sMCKseSwjF4bbWZVGv0jP6kDNMJhlzPBzR2vk9MvvMOS5OlmxBPb2rwEEE/jH4TdOdjfuEbSrAZK4Us4Ssyjt7DPpmvD77hSGU3GGAvhaI3FK6pjAeSGLFM399eMrNvuSur0rY=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033068173054;MF=hongzhen@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0WC22PIW_1722824918;
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WC22PIW_1722824918)
          by smtp.aliyun-inc.com;
          Mon, 05 Aug 2024 10:28:38 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: fix extra argument to erofs_err()
Date: Mon,  5 Aug 2024 10:28:26 +0800
Message-ID: <20240805022826.2581887-1-hongzhen@linux.alibaba.com>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Coverity-id: 502380

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
 mkfs/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index f9ac4bd..14dfdf9 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1067,7 +1067,7 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 			return ret;
 		}
 		if (src->extra_devices > 1) {
-			erofs_err("%s: unsupported number of extra devices",
+			erofs_err("%s: unsupported number %u of extra devices",
 				  src->devname, src->extra_devices);
 			return -EOPNOTSUPP;
 		}
-- 
2.43.5

