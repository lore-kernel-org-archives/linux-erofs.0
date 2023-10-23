Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19AFC001E0
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Oct 2023 08:13:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SDScF3T1Jz3cSK
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Oct 2023 19:13:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SDSc63Qyhz2xX4
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Oct 2023 19:12:54 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Vuh9U4O_1698048766;
Received: from e69b19392.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vuh9U4O_1698048766)
          by smtp.aliyun-inc.com;
          Mon, 23 Oct 2023 16:12:48 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/3] erofs-utils: get rid of .preflush()
Date: Mon, 23 Oct 2023 16:12:40 +0800
Message-Id: <20231023081241.1946579-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231023081241.1946579-1-hsiangkao@linux.alibaba.com>
References: <20231023081241.1946579-1-hsiangkao@linux.alibaba.com>
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

It's actually never used.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 include/erofs/cache.h | 1 -
 lib/cache.c           | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/include/erofs/cache.h b/include/erofs/cache.h
index de5584e..31f54a4 100644
--- a/include/erofs/cache.h
+++ b/include/erofs/cache.h
@@ -30,7 +30,6 @@ struct erofs_buffer_block;
 #define DEVT		5
 
 struct erofs_bhops {
-	bool (*preflush)(struct erofs_buffer_head *bh);
 	bool (*flush)(struct erofs_buffer_head *bh);
 };
 
diff --git a/lib/cache.c b/lib/cache.c
index 3424e59..e3cf69e 100644
--- a/lib/cache.c
+++ b/lib/cache.c
@@ -380,11 +380,6 @@ bool erofs_bflush(struct erofs_buffer_block *bb)
 		if (p == bb)
 			break;
 
-		/* check if the buffer block can flush */
-		list_for_each_entry(bh, &p->buffers.list, list)
-			if (bh->op->preflush && !bh->op->preflush(bh))
-				return false;
-
 		blkaddr = __erofs_mapbh(p);
 
 		list_for_each_entry_safe(bh, nbh, &p->buffers.list, list) {
-- 
2.39.3

