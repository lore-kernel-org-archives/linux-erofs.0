Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE5FC43217
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Oct 2022 04:51:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MnKwx3nzvz3bls
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Oct 2022 15:51:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.44; helo=out30-44.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MnKwr1Ymmz2xgb
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Oct 2022 15:51:06 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VS-GD.8_1665550256;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VS-GD.8_1665550256)
          by smtp.aliyun-inc.com;
          Wed, 12 Oct 2022 12:51:01 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org,
	Chao Yu <chao@kernel.org>
Subject: [PATCH] erofs: shouldn't churn the mapping page for duplicated copies
Date: Wed, 12 Oct 2022 12:50:56 +0800
Message-Id: <20221012045056.13421-1-hsiangkao@linux.alibaba.com>
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

If other duplicated copies exist in one decompression shot, should
leave the old page as is rather than replace it with the new duplicated
one.  Otherwise, the following cold path to deal with duplicated copies
will use the invalid bvec.  It impacts compressed data deduplication.

Also, shift the onlinepage EIO bit to avoid touching the signed bit.

Fixes: 267f2492c8f7 ("erofs: introduce multi-reference pclusters (fully-referenced)")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zdata.c | 8 +++-----
 fs/erofs/zdata.h | 6 +++---
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index cce56dde135c..8d6ff8bcffdd 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -887,15 +887,13 @@ static void z_erofs_do_decompressed_bvec(struct z_erofs_decompress_backend *be,
 
 	if (!((bvec->offset + be->pcl->pageofs_out) & ~PAGE_MASK)) {
 		unsigned int pgnr;
-		struct page *oldpage;
 
 		pgnr = (bvec->offset + be->pcl->pageofs_out) >> PAGE_SHIFT;
 		DBG_BUGON(pgnr >= be->nr_pages);
-		oldpage = be->decompressed_pages[pgnr];
-		be->decompressed_pages[pgnr] = bvec->page;
-
-		if (!oldpage)
+		if (!be->decompressed_pages[pgnr]) {
+			be->decompressed_pages[pgnr] = bvec->page;
 			return;
+		}
 	}
 
 	/* (cold path) one pcluster is requested multiple times */
diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
index e7f04c4fbb81..d98c95212985 100644
--- a/fs/erofs/zdata.h
+++ b/fs/erofs/zdata.h
@@ -126,10 +126,10 @@ static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
 }
 
 /*
- * bit 31: I/O error occurred on this page
- * bit 0 - 30: remaining parts to complete this page
+ * bit 30: I/O error occurred on this page
+ * bit 0 - 29: remaining parts to complete this page
  */
-#define Z_EROFS_PAGE_EIO			(1 << 31)
+#define Z_EROFS_PAGE_EIO			(1 << 30)
 
 static inline void z_erofs_onlinepage_init(struct page *page)
 {
-- 
2.24.4

