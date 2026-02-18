Return-Path: <linux-erofs+bounces-2333-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F3AE9A03B
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Feb 2026 12:13:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fGFmN056Fz2xlq;
	Wed, 18 Feb 2026 23:13:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771416835;
	cv=none; b=dipEgjyy7uv9XLzKg55lakAUYLrNblSutN5ydH13Z/HIJ3Hlu+cf0CtpWibjlj6dyYybsLX/IyavVcCDfww3kZzYiHEZEfP4IJGUGzo79zvUoZL4K2h1vvACkrJ9QNhgHR6T1iPtohnmJYLNKBZS4GxNKA7GLD4Zvqys+SL+HmC7/6Fl6Fy1qP9+IDOwRMj9wcPjz2Y9odwV3DTca/bbrfs5OjDW0ge58AoBUaOSYlN6VsLSgwcw1qSmr58MyIiofZ9kJrNLlARwxnWogcBZ7arlhDCpdJbW6rS/TL9NzX936vsOjkE7qvtpVmZ5q1DpggDo7B10wjvmZZ7pd1IWpw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771416835; c=relaxed/relaxed;
	bh=IwndmcRaO/FGUSe6ZKUnn+9nkg6OLFaotqdh8XFufow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h30m/bZD6LJMrNcWzs+xntKkG7Bxf3pZxH16Ag3hE4TO/2BLAPdW3bJhbWFnhV4W1RsRtKtIT1eBmzjY9ttxlbMmqg1ChwRnVJySnjpTZ04n3EXYx6nf9Tow/t+qpWOaO+Bb2sd3bZ64aiDwt6ImfsTdDh24Z3+sPZvCEanxXX2j13gBozAWM8/LvB9XRHnHYTSBhwSiCB/EzEV33TbRnab1rdURjtrm59swkA+SLqYtCZTspaAhZcnJQJhRs9zLeCGbfTRtVitYCueZyb0s11eZ6o343Nbo3jSZxhdWacfJKf3F9Jta6rzGk0S/PrRb3dfbZc3kuwUOJE34Mef2xQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GnX2ylOB; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GnX2ylOB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fGFmK0WjGz2x99
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Feb 2026 23:13:51 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771416825; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=IwndmcRaO/FGUSe6ZKUnn+9nkg6OLFaotqdh8XFufow=;
	b=GnX2ylOB/BXUrn+q2BVriwHxu10wjriW7dBzHcR+dgt1hD6AlL6puirzgVO9/bv4Rf/gKHUSB61LOSMppMv1EfDH6raitj8mhTOpckH5xxPBTlkyy+/9YTCDKJNUeUKm+ODQib8szlFraOWv5m4YjryT/Y5k3ie80bVQbzDZf6I=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzSY5V9_1771416820 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Feb 2026 20:13:44 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: mkfs: fix `-Efragments` performance regression
Date: Wed, 18 Feb 2026 20:13:39 +0800
Message-ID: <20260218121339.273715-1-hsiangkao@linux.alibaba.com>
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

Fixes: c75cfaf6956d ("erofs-utils: mkfs: Turn off deduplication under chunk mode with '-E^dedupe'")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index 995bc602b145..4a0d890ae87d 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -634,7 +634,7 @@ retry_aligned:
 			may_packing = false;
 			e->length = min_t(u32, e->length, ctx->pclustersize);
 nocompression:
-			if (params->dedupe != EROFS_DEDUPE_FORCE_OFF)
+			if (params->dedupe == EROFS_DEDUPE_FORCE_ON)
 				ret = write_uncompressed_block(ctx, len, dst);
 			else
 				ret = write_uncompressed_extents(ctx, len,
@@ -1382,7 +1382,7 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 
 	if (ptotal)
 		(void)erofs_bh_balloon(bh, ptotal);
-	else if (!params->fragments && params->dedupe == EROFS_DEDUPE_FORCE_OFF)
+	else if (!params->fragments && params->dedupe != EROFS_DEDUPE_FORCE_ON)
 		DBG_BUGON(!inode->idata_size);
 
 	erofs_info("compressed %s (%llu bytes) into %llu bytes",
@@ -1887,7 +1887,7 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 			params->max_compressed_extent_size;
 		ictx->data_unaligned = false;
 	}
-	if (params->fragments && params->dedupe == EROFS_DEDUPE_FORCE_OFF &&
+	if (params->fragments && params->dedupe != EROFS_DEDUPE_FORCE_ON &&
 	    !ictx->data_unaligned)
 		inode->z_advise |= Z_EROFS_ADVISE_INTERLACED_PCLUSTER;
 
-- 
2.43.5


