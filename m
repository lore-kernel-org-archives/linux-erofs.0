Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B43C678DB
	for <linux-erofs@archiver.kernel.org>; Sun,  5 Mar 2023 13:45:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PV2yr11ZYz3cJn
	for <linux-erofs@archiver.kernel.org>; Mon,  6 Mar 2023 00:45:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PV2yk5K24z3c5D
	for <linux-erofs@lists.ozlabs.org>; Mon,  6 Mar 2023 00:45:17 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Vd6Wt0b_1678023896;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vd6Wt0b_1678023896)
          by smtp.aliyun-inc.com;
          Sun, 05 Mar 2023 21:45:05 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: fix wrong kunmap when using LZMA on HIGHMEM platforms
Date: Sun,  5 Mar 2023 21:44:55 +0800
Message-Id: <20230305134455.88236-1-hsiangkao@linux.alibaba.com>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

As the call trace shown, the root cause is kunmap incorrect pages:

 BUG: kernel NULL pointer dereference, address: 00000000
 CPU: 1 PID: 40 Comm: kworker/u5:0 Not tainted 6.2.0-rc5 #4
 Workqueue: erofs_worker z_erofs_decompressqueue_work
 EIP: z_erofs_lzma_decompress+0x34b/0x8ac
  z_erofs_decompress+0x12/0x14
  z_erofs_decompress_queue+0x7e7/0xb1c
  z_erofs_decompressqueue_work+0x32/0x60
  process_one_work+0x24b/0x4d8
  ? process_one_work+0x1a4/0x4d8
  worker_thread+0x14c/0x3fc
  kthread+0xe6/0x10c
  ? rescuer_thread+0x358/0x358
  ? kthread_complete_and_exit+0x18/0x18
  ret_from_fork+0x1c/0x28
 ---[ end trace 0000000000000000 ]---

The bug is trivial and should be fixed now.  It has no impact on
!HIGHMEM platforms.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: <stable@vger.kernel.org> # 5.16+
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/decompressor_lzma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 091fd5adf818..5cd612a8f858 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -278,7 +278,7 @@ int z_erofs_lzma_decompress(struct z_erofs_decompress_req *rq,
 		}
 	}
 	if (no < nrpages_out && strm->buf.out)
-		kunmap(rq->in[no]);
+		kunmap(rq->out[no]);
 	if (ni < nrpages_in)
 		kunmap(rq->in[ni]);
 	/* 4. push back LZMA stream context to the global list */
-- 
2.24.4

