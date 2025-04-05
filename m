Return-Path: <linux-erofs+bounces-146-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C87C36010
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Apr 2025 18:57:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ZVPq60tS2z2xS0;
	Sun,  6 Apr 2025 04:57:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1743879441;
	cv=none; b=F/kT4+3M7CfqvSUQ3k60mK2UMoFMrfDavQ7p9TK8ywcoq3ceS5DdCaCJvqVnskhKU9auw6lmZdoTi3h3WPmZ3O/f0oD13h2lvS/Ff5N/QO1zTLCCfRfCusPfnvODW4Icdk8IRumvQkkZKd22fBOIUfu4saROt0EyctmiU3LzyF6XAea/Brj0tdX1xZE80Rb3byA21QA0k2fl//YOJ6T+nneuuygRX760iksp+rhbh35FmZ4o90jGLjRHBmPsahTu6LGKPiaxAWYE+V/KmCFlYX6gf04cMxNKnL3xTS4HikV1KTpiAmpqstfgt/0UMut2ddPNRYrHT73Os6dB7F33+g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1743879441; c=relaxed/relaxed;
	bh=kSP2L7i94RPGXOkl6f9jM/KBjQLf3D72Xuz/cKl6IYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzOGVGXysrGGm4MFl3YrnNUxH+9oa3tTFGG2ygQzdGhvoF06Bz5ewdK/DYRKWPpD0SV1Q8RKOaKFi/BMGPyv0DDzcfDXD/JZ6Wfe+Ibcss0VJ6U1RhTMC7jPbKRjxDSMF3IeViXRRG1DgyxAPaPyEDwTS/Ex2VDK49Y+ujA17Njc8Oip8Biw3xtF3neG6JSVYyeaZb4xrBc+ldyYY7BWQ9PnkbWIHB0xQ4/RPpmdK9Bhcjci448lEuDrLDhnf1w74qi9vpPuF0MPTOlLXPBtdVOga9czMQcJHRxKjJA8ab7EqL52ZiKYr11c5Ze6lLp6silcz1MEApxSYuNn30Elyg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A3AlPXxq; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A3AlPXxq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ZVPq40cMNz2xGw
	for <linux-erofs@lists.ozlabs.org>; Sun,  6 Apr 2025 04:57:19 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1743879435; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kSP2L7i94RPGXOkl6f9jM/KBjQLf3D72Xuz/cKl6IYA=;
	b=A3AlPXxq0bTgb+UMpffR4PNBleOzSWuV24xc3IE57uCtVJt9KlyeZzFyEWkvriE/GPbAvM1zbkgtP3U1xZ6VhejmHyL6OhLxO/v7cM4WbwM9EcNfKM/RsxjvX18prHXeqqNCv4cZO9T+l0W9XHvNsLC3eYYRNwNAyKCf43fv6WY=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WVLL3OC_1743879434 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 06 Apr 2025 02:57:14 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 4/4] erofs-utils: lib: fix two integer handling issues
Date: Sun,  6 Apr 2025 02:57:07 +0800
Message-ID: <20250405185707.3202298-4-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250405185707.3202298-1-hsiangkao@linux.alibaba.com>
References: <20250405185707.3202298-1-hsiangkao@linux.alibaba.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Coverity-id: 548918
Coverity-id: 548919
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index a7d5e53..9f71022 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1169,7 +1169,7 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 
 	/* fall back to no compression mode */
 	DBG_BUGON(pstart < (!!inode->idata_size) << bbits);
-	ptotal -= (!!inode->idata_size) << bbits;
+	ptotal -= (u64)(!!inode->idata_size) << bbits;
 
 	compressmeta = z_erofs_write_indexes(ictx);
 	if (!compressmeta) {
@@ -1687,7 +1687,7 @@ int erofs_write_compressed_file(struct z_erofs_compress_ictx *ictx)
 		ret = PTR_ERR(bh);
 		goto err_free_idata;
 	}
-	pstart = erofs_mapbh(NULL, bh->block) << sbi->blkszbits;
+	pstart = erofs_pos(sbi, erofs_mapbh(NULL, bh->block));
 
 	ictx->seg_num = 1;
 	sctx = (struct z_erofs_compress_sctx) {
-- 
2.43.5


