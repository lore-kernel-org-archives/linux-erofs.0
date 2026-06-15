Return-Path: <linux-erofs+bounces-3594-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BFECD98DE
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jun 2026 08:40:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gf3V20VqKz2xnK;
	Mon, 15 Jun 2026 18:40:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781512826;
	cv=none; b=e39npI5Br1sOgB9N9XrEGKFr0MTt9w9FaD5G1myJHIUAVdQtxQZay++1epGHEmDZnfgRmvpe/z4vMWXHZoJr58JdS1zC+Puv9OFczo787MHUmP4hFhj9N4mS0QpwUMOu6aGpqG4dHjamVXfhwSA/eppflZtqSRhuosgM49kKn+zCyujbgtz9vQxQAulvDlj49SF+6Q6vXWX6eRKjzmY4w5YeqF7xZ90DT6suG6H2bfSoJlZ0kjoQfSEdxTSqCKcKg1C0wKH7gz7SEwn442kJ+TUoeMFYgLlHi1+vjDFS7L2cVAnkNB/6Cm8TUrlUz/EzDEslH7I1Pyyxd2r3ZEaq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781512826; c=relaxed/relaxed;
	bh=+VEDbZcJY3LGjzJwYn5HFIkHP4CJ3ClwbwiAr04okjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEOyGVZskoGGr6ue/pKbDPI2sToyERAWO56ZkqB0L9FwngwJzwbRoXLMqDOxDCPNKeAAI4cbgsGlzKHtdxOCh6KG7vHgMngE3rgdjK3gVzXjUVKeHYyf3ecvSamegRpaZkUsTaprqoHmN52JBsLMbm36UKU0bAgRDr/uqVvdWmFoLi4iCMLKU2G1dJBPlL0H4k+NLIKG31F7bV+YSP/vm0K3PDsftULeuyVHJ/UnBjAdkVc70gDxlMUE6cXJJZdYwk581oQ/eMjSiy7cqOSi5aVVPdbPbIcs7vqb1PBvq3VAzbBupdfQ6NDk9GXsSFP8PVFD5a1dnh4EkSSYRsQ1rA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HvJg78FD; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HvJg78FD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gf3Tz505Pz3bqD
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 18:40:22 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781512819; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=+VEDbZcJY3LGjzJwYn5HFIkHP4CJ3ClwbwiAr04okjY=;
	b=HvJg78FDmnjxCF8kaWibppR5q43SaBUZLnY60Ol3QFM3lazTE/BG966V9aWay9GRg8wZ6oxMDUJrLUUpiiUf73TQq55+5Jg+G04ywMd1q2neX04NtfPLGDYHt2JAsTIIkw9lKbEs6acQTtO6wIQ/J4goKXsylVBp2gYwDeYvImQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X4s4J.m_1781512817;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4s4J.m_1781512817 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 16:40:17 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Tristan <TristanInSec@gmail.com>
Subject: [PATCH 3/3] erofs-utils: fsck: fix potential overflow due to u64-to-u32 truncation
Date: Mon, 15 Jun 2026 16:40:11 +0800
Message-ID: <20260615084011.325686-3-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260615084011.325686-1-hsiangkao@linux.alibaba.com>
References: <20260615084011.325686-1-hsiangkao@linux.alibaba.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems possible but no reproducible way made into public.

Reported-by: Tristan <TristanInSec@gmail.com>
Closes: https://lore.kernel.org/r/CAA1XrhPMekMqAnRkC-jV9rTsO4LHjzh=kxn6zQKMgBrqfrnp8A@mail.gmail.com/2-u64-to-u32-truncation-overflow.txt
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fsck/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsck/main.c b/fsck/main.c
index 87eeb81136ff..fc64e6e263d8 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -513,7 +513,7 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd)
 	bool compressed;
 	erofs_off_t pos = 0;
 	u64 pchunk_len = 0;
-	unsigned int raw_size = 0, buffer_size = 0;
+	u64 raw_size = 0, buffer_size = 0;
 	char *raw = NULL, *buffer = NULL;
 
 	erofs_dbg("verify data chunk of nid(%llu): type(%d)",
-- 
2.43.5


