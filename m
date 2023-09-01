Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 688E6CA0FE3
	for <linux-erofs@archiver.kernel.org>; Fri,  1 Sep 2023 03:16:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RcNVR0SBhz3bxZ
	for <linux-erofs@archiver.kernel.org>; Fri,  1 Sep 2023 13:16:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RcNVL2N95z2xm5
	for <linux-erofs@lists.ozlabs.org>; Fri,  1 Sep 2023 13:16:41 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Vr.9YVf_1693538195;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vr.9YVf_1693538195)
          by smtp.aliyun-inc.com;
          Fri, 01 Sep 2023 11:16:36 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH RESEND] erofs-utils: lib: fix `last_mapped_block` in erofs_bflush()
Date: Fri,  1 Sep 2023 11:16:34 +0800
Message-Id: <20230901031634.115999-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20230901031244.108189-1-hsiangkao@linux.alibaba.com>
References: <20230901031244.108189-1-hsiangkao@linux.alibaba.com>
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

Currently, calling erofs_bflush() multiple times is broken due to
outdated `last_mapped_block`.

Fixes: 82dee4501c5a ("erofs-utils: mkfs: enable xattr name filter feature by default")
Fixes: 185b0bcdef4b ("erofs-utils: optimize buffer allocation logic")
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
RESEND:
 - fix my mismatch svb.

 lib/cache.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/lib/cache.c b/lib/cache.c
index d6e9b47..925054a 100644
--- a/lib/cache.c
+++ b/lib/cache.c
@@ -349,6 +349,18 @@ erofs_blk_t erofs_mapbh(struct erofs_buffer_block *bb)
 	return tail_blkaddr;
 }
 
+static void erofs_bfree(struct erofs_buffer_block *bb)
+{
+	DBG_BUGON(!list_empty(&bb->buffers.list));
+
+	if (bb == last_mapped_block)
+		last_mapped_block = list_prev_entry(bb, list);
+
+	list_del(&bb->mapped_list);
+	list_del(&bb->list);
+	free(bb);
+}
+
 bool erofs_bflush(struct erofs_buffer_block *bb)
 {
 	const unsigned int blksiz = erofs_blksiz(&sbi);
@@ -384,13 +396,8 @@ bool erofs_bflush(struct erofs_buffer_block *bb)
 			dev_fillzero(&sbi, erofs_pos(&sbi, blkaddr) - padding,
 				     padding, true);
 
-		DBG_BUGON(!list_empty(&p->buffers.list));
-
 		erofs_dbg("block %u to %u flushed", p->blkaddr, blkaddr - 1);
-
-		list_del(&p->mapped_list);
-		list_del(&p->list);
-		free(p);
+		erofs_bfree(p);
 	}
 	return true;
 }
@@ -412,12 +419,7 @@ void erofs_bdrop(struct erofs_buffer_head *bh, bool tryrevoke)
 	if (!list_empty(&bb->buffers.list))
 		return;
 
-	if (bb == last_mapped_block)
-		last_mapped_block = list_prev_entry(bb, list);
-
-	list_del(&bb->mapped_list);
-	list_del(&bb->list);
-	free(bb);
+	erofs_bfree(bb);
 
 	if (rollback)
 		tail_blkaddr = blkaddr;
-- 
2.24.4

