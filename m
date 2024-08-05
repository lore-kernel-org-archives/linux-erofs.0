Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81FEC3DA4A
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Aug 2024 07:40:14 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=D9Wv5Jv9;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WcpHx2cCNz3cT9
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Aug 2024 17:40:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=D9Wv5Jv9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WcpHl1j5qz3cWG
	for <linux-erofs@lists.ozlabs.org>; Mon,  5 Aug 2024 17:40:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1722843597; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=CJeY/tc91uVPSoZQHjZwqd1dsdG42SzXhhySkqxbDGg=;
	b=D9Wv5Jv9c4Idksu22pywdYLpCXRbk1rU5qA27QzfytVe74zcpBRx3gawCIgjjXww5VAbf7LZ5pH0MpBo34Y+qjm6bh0pEliux2XP6kPpAE2Tw/T5qF5zBPuHWo+MtuxFfKk/YxRJsNWQRU9xyLlo3o+qpwdUWDxrykwzmj9xQ4k=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032019045;MF=hongzhen@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0WC6A5rs_1722843594;
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WC6A5rs_1722843594)
          by smtp.aliyun-inc.com;
          Mon, 05 Aug 2024 15:39:55 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: mkfs: fix uninitialized nblocks
Date: Mon,  5 Aug 2024 15:39:53 +0800
Message-ID: <20240805073953.2864289-1-hongzhen@linux.alibaba.com>
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

Coverity-id: 502376

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
 mkfs/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index f9ac4bd..3605e64 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1142,7 +1142,7 @@ int main(int argc, char **argv)
 	int err = 0;
 	struct erofs_buffer_head *sb_bh;
 	struct erofs_inode *root = NULL;
-	erofs_blk_t nblocks;
+	erofs_blk_t nblocks = 0;
 	struct timeval t;
 	FILE *packedfile = NULL;
 	FILE *blklst = NULL;
-- 
2.43.5

