Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C054FC2BD05
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jun 2024 11:59:42 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xV+pdR+8;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4W762h26Swz3cVZ
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jun 2024 21:59:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xV+pdR+8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4W762Z3QRSz3cBN
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Jun 2024 21:59:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1719230370; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wz6u/fTcdEji3ZqkZDkRBVxVjUoqUKxaxvH3pLaEQK8=;
	b=xV+pdR+8lw6/dL75kAocRvfVnId+bC+JsTAm2xvNrgZUuMaBwPRDbVjyXnCY2vgmCIOIwx67HCCQsi+U82GnNEkKSxph8vObwAWj5xYrlJ5wrVm2ARnbq8w6qIaxl889zrG1m8WPWcDnZyslatnHm5NTTboBfb7eqObWsS8t1cA=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W9960mi_1719230368;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W9960mi_1719230368)
          by smtp.aliyun-inc.com;
          Mon, 24 Jun 2024 19:59:29 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: introduce `payload` field in `struct erofs_vfile`
Date: Mon, 24 Jun 2024 19:59:23 +0800
Message-Id: <20240624115923.4090196-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240624115923.4090196-1-hsiangkao@linux.alibaba.com>
References: <20240624115923.4090196-1-hsiangkao@linux.alibaba.com>
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

Allow customized `vfile` with non-NULL `ops` utilizing `payload`
for additional information.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 include/erofs/io.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/erofs/io.h b/include/erofs/io.h
index 6167bdf..f53abed 100644
--- a/include/erofs/io.h
+++ b/include/erofs/io.h
@@ -37,10 +37,16 @@ struct erofs_vfops {
 		     struct erofs_vfile *vin, int len, bool noseek);
 };
 
+/* don't extend this; instead, use payload for any extra information */
 struct erofs_vfile {
 	struct erofs_vfops *ops;
-	u64 offset;
-	int fd;
+	union {
+		struct {
+			u64 offset;
+			int fd;
+		};
+		u8 payload[16];
+	};
 };
 
 int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf);
-- 
2.39.3

