Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08E8EE14D3
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Sep 2023 05:06:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Rh6dl0bZZz3bwg
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Sep 2023 15:06:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Rh6dc4zpnz2yDM
	for <linux-erofs@lists.ozlabs.org>; Thu,  7 Sep 2023 15:05:54 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VrWCVhu_1694063143;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VrWCVhu_1694063143)
          by smtp.aliyun-inc.com;
          Thu, 07 Sep 2023 13:05:48 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: fix memory leak of LZMA global compressed deduplication
Date: Thu,  7 Sep 2023 13:05:42 +0800
Message-Id: <20230907050542.97152-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

When stressing microLZMA EROFS images with the new global compressed
deduplication feature enabled (`-Ededupe`), I found some short-lived
temporary pages weren't properly released, which could slowly cause
unexpected OOMs hours later.

Let's fix it now (LZ4 and DEFLATE don't have this issue.)

Fixes: 5c2a64252c5d ("erofs: introduce partial-referenced pclusters")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/decompressor_lzma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 73091fbe3ea4..dee10d22ada9 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -217,9 +217,12 @@ int z_erofs_lzma_decompress(struct z_erofs_decompress_req *rq,
 			strm->buf.out_size = min_t(u32, outlen,
 						   PAGE_SIZE - pageofs);
 			outlen -= strm->buf.out_size;
-			if (!rq->out[no] && rq->fillgaps)	/* deduped */
+			if (!rq->out[no] && rq->fillgaps) {	/* deduped */
 				rq->out[no] = erofs_allocpage(pagepool,
 						GFP_KERNEL | __GFP_NOFAIL);
+				set_page_private(rq->out[no],
+						 Z_EROFS_SHORTLIVED_PAGE);
+			}
 			if (rq->out[no])
 				strm->buf.out = kmap(rq->out[no]) + pageofs;
 			pageofs = 0;
-- 
2.24.4

