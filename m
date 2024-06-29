Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C51C27C4F
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Jun 2024 18:58:20 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KXmPpH92;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WBM5P1WbCz3cW1
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Jun 2024 04:58:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KXmPpH92;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WBM5F5Hqnz30Wm
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Jun 2024 04:58:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1719687484; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=iQNmjx9aMgLa1f79E0y6SIn1TUROyrKh2kuEUUI4uHQ=;
	b=KXmPpH92ceTJnUs92JPNdsXakWMkA23iOrUaYw4+ujajfib/falnDIrYdwadAoHkt+A68EYAx3b/26cUUnnDpNEfv5+b1AA3tOjBURO8iRiFqyFz/UMZ1GuIY9Z5tqsIelFDeJQBD1PcVkeHotbG9DAAIQs4efZQJ+NClkuWeEw=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W9ThmIU_1719687464;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W9ThmIU_1719687464)
          by smtp.aliyun-inc.com;
          Sun, 30 Jun 2024 02:58:02 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org,
	Chao Yu <chao@kernel.org>
Subject: [PATCH] erofs: ensure m_llen is reset to 0 if metadata is invalid
Date: Sun, 30 Jun 2024 02:57:43 +0800
Message-ID: <20240629185743.2819229-1-hsiangkao@linux.alibaba.com>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Sometimes, the on-disk metadata might be invalid due to storage
failure or other unknown issues.

In that case, z_erofs_map_blocks_iter() may still return a valid
m_llen while other fields remain invalid (e.g., m_plen can be 0).

Due to the return value of z_erofs_scan_folio() in some path will
be ignored on purpose, the following z_erofs_scan_folio() could
then use the invalid value by accident.

Let's reset m_llen to 0 to prevent this.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 9b248ee5fef2..74d3d7bffcf3 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -711,6 +711,8 @@ int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
 
 	err = z_erofs_do_map_blocks(inode, map, flags);
 out:
+	if (err)
+		map->m_llen = 0;
 	trace_z_erofs_map_blocks_iter_exit(inode, map, flags, err);
 	return err;
 }
-- 
2.43.5

