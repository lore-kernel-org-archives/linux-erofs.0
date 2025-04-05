Return-Path: <linux-erofs+bounces-147-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04668C36010
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Apr 2025 18:57:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ZVPq64HQVz2xGw;
	Sun,  6 Apr 2025 04:57:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1743879442;
	cv=none; b=oGVRmfFY1B1f3gLY5gktyYCj4/0WGgHaII+pSeOsrActNRkhmTxg+jUgHSj9ogMgElh1+B/OZaBe6MpltHK19JVMaeZB6XySz1EqqDh8sO7zP9yqXPUNyNTWiB4qLQHZ7yHSZX55/+PkXownWtLjntsv3xhDMEakTOg2BGyI/hMndvpIADdK4bHyeqRkfpy0iyOiC1v2wqLp59dVXEeVUJY8/v6Ll2wz58M/zHyjZAhDafDuj1meoBZ09bb5S2bg8ZIl3tiCypu+ulzIDFQVKYyLpikzNUyDzFZxG183lC66hGNmqxTgmaargV0+7JXgKWduO6yN4HPmq7s1OYbqxA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1743879442; c=relaxed/relaxed;
	bh=sY4h16Rf4M4Y9nfrH5ACRgcuRU+GIvjWjFtiTB/3ij4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HX4EJ7zNuj/+Us2cW8Yfx2cUIuhlOIg8+XdPdF2g952qsdwod5mnL52V+uX6RNaN5pFtfacDh/S4WorgyZfe6Vn+n3DPb7gSF8JalkO9pnaYsy8HBcU9Pa6EnlVYZZS9xoYNHOnJirxCxpy9c49HWlyhxKUQnsr5P+RlSyoYFzB2165PcTHviU5T/jbtLaMIkJ/B9HQZNI9d/UkYXK7XfWtkvJow39ejMoRiTgGTQN1lIpYS0GVkbUdkrqXITQH3XI70/+R6hsLbcYQ/Rgl9dgvY4U5yLUTnr0Zm2cLSJ06u3gpDGQ1aQ6SQS14SHB0+woIKqk9FJF488VBZe3VOQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WmaEZpY3; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WmaEZpY3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ZVPq41cKPz2xRy
	for <linux-erofs@lists.ozlabs.org>; Sun,  6 Apr 2025 04:57:19 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1743879435; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=sY4h16Rf4M4Y9nfrH5ACRgcuRU+GIvjWjFtiTB/3ij4=;
	b=WmaEZpY3eXhjNTjYorfvyu2mu9CEX5IJBxnniTTTDi9N2nMHgJl+7d2EnC/LBtnB3YoJYbj/4WDuNCAhLheGWZyXUWheHglzOEdetig0lyQMvtbAiSpxcD8cfLA/0j6gdYX5TG83T1bCE84R4eanb6mG46WbYmpURElEfnwfcjw=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WVLL3Nv_1743879433 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 06 Apr 2025 02:57:14 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 3/4] erofs-utils: lib: fix an API usage error
Date: Sun,  6 Apr 2025 02:57:06 +0800
Message-ID: <20250405185707.3202298-3-hsiangkao@linux.alibaba.com>
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

Coverity-id: 548920
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index bff0e0b..a7d5e53 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1208,8 +1208,8 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 			DBG_BUGON(!inode->idata_size);
 	}
 
-	erofs_info("compressed %s (%llu bytes) into %u bytes",
-		   inode->i_srcpath, inode->i_size | 0ULL, ptotal);
+	erofs_info("compressed %s (%llu bytes) into %llu bytes",
+		   inode->i_srcpath, inode->i_size | 0ULL, ptotal | 0ULL);
 
 	if (inode->idata_size) {
 		bh->op = &erofs_skip_write_bhops;
-- 
2.43.5


