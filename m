Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1DBC282C5
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Mar 2025 05:43:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Z5nlt0RNqz3blV
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Mar 2025 16:43:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1740980584;
	cv=none; b=lHYVnS2yPLneGMBwy8O05Oyxj95N4fp56EAE0JE/HX9l+TEf4NsifAi86YvAMDTPnTRx7L08veNgzZFeRJFXxWhHlq+tWM9balIWtIiNAZiuQT1SqI35c17NK8DifZiWjwzosFua4bmB1AQqWeFL9JNiCmlyv4Q7hnu3jofKScqliZw+MC/MXREM5YMPa/cyJu/czn/f7ykFO/+QxGaE2ulNvRKb5qAHlk9l5x1CwpKZJaFzfD45Hpk4ydUGo4mmQeM6V/40LPfIAIEE/ikaVIjVs0b/xDg7RGGgjUc1PUHD/Ad4qXCgNoDXj1QTTZJzFcvWp4DNKXAOgIe228dISg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1740980584; c=relaxed/relaxed;
	bh=Hovz5iYN+RQTKu/p7aS1h3p6UZ+ufqDhGf+OPmcUi3M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TdVXZ7EDXMn2pfznT0Oi/DBc3ntLEWi2cS6UDjJAmVHYrjyMn1gcX4n6zxRagSfNxhk4l6h3dkPs4Lkz/8PprSc9p7BCHbjtpY+x9Dpbk/woVqBQhzTD+oBuKOnRbCwEuJi0lGxxOkFu7CsCm23K8pPT5d/pO2Cqhh+tW5PtAOR6C6hAHOXTNQtspl7YJB3fAPfgwDFDBifvftPZWhrWasThn608SmV1IgnKmcotQzJgL6p9QgjYngWdOS7H8lViUCp4Wv17C4RA80uitZosro2Gl6h4lCnHT3GGPTQI2ET5UPRMbUGa1cmOGTmbtkpV5YWmY3S34L+1bxr2V7zF+g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d7vQKtTy; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d7vQKtTy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Z5nlp5T6xz2xdL
	for <linux-erofs@lists.ozlabs.org>; Mon,  3 Mar 2025 16:43:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740980576; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Hovz5iYN+RQTKu/p7aS1h3p6UZ+ufqDhGf+OPmcUi3M=;
	b=d7vQKtTyRI7SZYQ8kUToqzpld8jGfSIJRoF29Hkae/OuxPyW+gs5bmfYXxUMxshMCa7tPm8QmO2Gj8/6y4gxg6jo8eACbFcqtvKplW9HQZy2tSEAoATzRu47fZLcwZV6KcX6stR1t3Rvs7XDFOl2Nl5oGSYvSmyZJKHWbe3tNAI=
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WQYkAcI_1740980574 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 03 Mar 2025 13:42:55 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: lib: fix inappropriate initialization in cache.c
Date: Mon,  3 Mar 2025 13:42:53 +0800
Message-ID: <20250303054253.1154648-1-hongzhen@linux.alibaba.com>
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

This patch fixes the inappropriate initialization of `dsunit` and
`bktmap` in cache.c.

Fixes: 8bb6de4e7c41 ("erofs-utils: mkfs: support data alignment")
Fixes: ca0f040f98b6 ("erofs-utils: lib: use bitmaps to accelerate bucket selection")
Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
 lib/cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/cache.c b/lib/cache.c
index ca1061bc7f29..eddf21f49893 100644
--- a/lib/cache.c
+++ b/lib/cache.c
@@ -44,13 +44,15 @@ struct erofs_bufmgr *erofs_buffer_init(struct erofs_sb_info *sbi,
 		for (j = 0; j < ARRAY_SIZE(bmgr->watermeter[0]); j++) {
 			for (k = 0; k < blksiz; k++)
 				init_list_head(&bmgr->watermeter[i][j][k]);
-			memset(bmgr->bktmap[i][j], 0, blksiz / BITS_PER_LONG);
+			memset(bmgr->bktmap[i][j], 0,
+			       (blksiz / BITS_PER_LONG) * sizeof(unsigned long));
 		}
 	}
 	init_list_head(&bmgr->blkh.list);
 	bmgr->blkh.blkaddr = NULL_ADDR;
 	bmgr->tail_blkaddr = startblk;
 	bmgr->last_mapped_block = &bmgr->blkh;
+	bmgr->dsunit = 0;
 	return bmgr;
 }
 
-- 
2.43.5

