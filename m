Return-Path: <linux-erofs+bounces-2412-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE12FD3763
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Feb 2026 14:18:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLcC34SV6z3f4b;
	Thu, 26 Feb 2026 01:18:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772029119;
	cv=none; b=ouX/jCd+cqfabN9y4INi/nVlj/xVnyFv00TmvzO+1fRjtKS9uqC/82Q+bxnHNM0XZfJQ1D0oEMM4bFs4C39Tz4HwSAH3n6NwOH3B/XH4ujGnxJO7UWhmTWyyvGqcTaMWBZizlY0KqXsuDp/Ydw3Tuu5GITrNF9FyLEOMiXnZHmGIEirc6Qx77z/Sc2uAS7xR1P0JaeHMrl2zFAyJGVMF7aM2BHb97ZQpXDrL1WIQcNRqOz+cA+ZRJFS1wBDvEmDkPzWMc08gTckbH9xiv2JGSuZ88wZAfQgXqjYEUUUj6ynk/kmtlESyHw9extEPV2u+mUC90bzXLs/fUjFWxUTqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772029119; c=relaxed/relaxed;
	bh=L95wrIKVa6v1TwctFgaKbTwBmW2hwLtw32z+bqB7Qik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UlajL1JalKTDe/LtPdg2m67regeenVJn4TuL/dpJJZMvqmkdNH8lE+E4gVvzU+qlxXMBHMnsHPssUNnZ/BwQjp/YeXh4rJj8KVIdAzg51VJkXKue+sSxo10vBPs+o5s6cM1lrsbg9mSHHz71hdoNUqWap3+wp6Zy56/L2D7ijTzAXX90ZMvzfpAnbGmw7dA0pI7RtpM+OyJnaiLBs2lHX58CSJxZPpfKWE0C9h6sC/t6HdvaywcaIKrLChAx6kqtS6hpwL85p2KcELE6pSGHMG2PpzHQLONwOWPJ7BqDmMeOrHFon1Reo8Kr8217zVWzPPop5RfJ7zUCutGP6KlyLA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FO4yrXVG; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FO4yrXVG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fLcC02gNyz3f3G
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 01:18:34 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772029109; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=L95wrIKVa6v1TwctFgaKbTwBmW2hwLtw32z+bqB7Qik=;
	b=FO4yrXVG53qf3enAzmiVoIY84k8ClmkplmyW2MuxBLh1DMNp4yUwXUK0rGBEeIll2Foob2fjaBhlNgSqZB6j9piQdVCVctN5nL8do8m9u5/wxYp7RV2gI38BiTnwOTZFyXTxXYHUxGymJne2AnYo03Mj41YGYP2UesDucDcqMMs=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzmnPPO_1772029102 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Feb 2026 22:18:25 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: mkfs: do not enable lz4_0padding for plain images
Date: Wed, 25 Feb 2026 22:18:20 +0800
Message-ID: <20260225141821.668836-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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

This is a new regression introduced in erofs-utils 1.9.

Fixes: 16a77fed8511 ("erofs-utils: lib: unexport z_erofs_compress_{init,exit}")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mkfs/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index aaf5358fc735..b84d1b46f4dc 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1678,7 +1678,7 @@ static void erofs_mkfs_default_options(struct erofs_importer_params *params)
 	mkfs_blkszbits = ilog2(min_t(u32, getpagesize(), EROFS_MAX_BLOCK_SIZE));
 	params->pclusterblks_max = 1U;
 	params->pclusterblks_def = 1U;
-	g_sbi.feature_incompat = EROFS_FEATURE_INCOMPAT_LZ4_0PADDING;
+	g_sbi.feature_incompat = 0;
 	g_sbi.feature_compat = EROFS_FEATURE_COMPAT_SB_CHKSUM |
 			     EROFS_FEATURE_COMPAT_MTIME;
 }
-- 
2.43.5


