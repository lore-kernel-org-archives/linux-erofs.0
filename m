Return-Path: <linux-erofs+bounces-4585-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C077C982DA
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 03:04:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hp7PJ36Gmz2yDc;
	Mon, 21 Sep 2026 13:04:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789959876;
	cv=none; b=Tc+nyV9eIhJZ/IZl6i8OfweFlmyKX8BTb3KDs73UTsklfdNP4kCwd5+Eil+m3sWm6meQ4eUgVI6OiLo+epDmBvDMbm0EIL8+Wd6z6JLXLB0E4URp23bry95jX0khks1ENfO89rB6GqXuEEuB021I728d6bTxqk3NeYOGqzImWJwfzMTWI7AJNAg6a5zWgA85P5yg2xAuBP9RR7mIOI9HsowmZCNZSbpqUjwpv/xCVPqLNdL8TbjwSP+/W5pjeMB46LQaMZ1VN5m4jN3+GKvyKitiNaF4tKCbq1WdBLR6Tt6aRY5PVsEMFkyNyk7ayatNKqpCfsvyFt/kkMvLUbfNDA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789959876; c=relaxed/relaxed;
	bh=+z7vJSmIDRGlrTXW1s9PrMcTHptumEg3JUs/vpMf91k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BAw7+8AJLjxCy4nggHsFrRkJd+J6jfmVP+WEFrrrUzA1J1fohYPkzghDCMSJg3IphYbgDNELPioIBcSPnEjKZd/69yAdoegVSkzcedwvFJTSyUbAg4NtAJjow1ahPp+VS7M++qRlnnutl8XMKD3Rk2ydwPCGKN1Qo/ZiegUzCIogJkzey5GqbrA5akJvfu2p7NhmjZfs+/7SDA9sEv1VHaS3B6QV3R6Ot6A1BecjKYdHLswy+qzqaDqD6UhRfsjr5MftWzXXRetVsaLeUEhv7niLvy90M7mLY0CF4NcB9ePZfLqd5Fer9W0lk9uvxfsrtrFEH5B8Xm+K+2DdjkF4Jg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Q11DP+dl; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Q11DP+dl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hp7PF29nQz2xk7
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 13:04:31 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789959865; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=+z7vJSmIDRGlrTXW1s9PrMcTHptumEg3JUs/vpMf91k=;
	b=Q11DP+dlbih6Q905DCPpFlJup8aq1AJ93jXsXU3tLFNXJcEEFlwyrnynLFxC+ledRtx+gMxBlPAzOy7WoqljrnPQG7nfzqDWBZD13aMMBGJKPmqrd4zdlsYh4o4Gq5hyYCt1jq9OGa9F8vH08C7MKtY4YiRqpX2uFn3ZMSURGIY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0XBHM.sF_1789959863;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0XBHM.sF_1789959863 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 21 Sep 2026 11:04:24 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: linux-kernel@vger.kernel.org,
	xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org
Subject: [PATCH] MAINTAINERS: erofs: update my email address
Date: Mon, 21 Sep 2026 11:04:17 +0800
Message-Id: <20260921030417.87932-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

From: Jingbo Xu <jefflexu@163.com>

This email address will not be available in a few days.
Update my own email address to jefflexu@163.com.

Signed-off-by: Jingbo Xu <jefflexu@163.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b..1008e14254c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9681,7 +9681,7 @@ EROFS FILE SYSTEM
 M:	Gao Xiang <xiang@kernel.org>
 M:	Chao Yu <chao@kernel.org>
 R:	Yue Hu <zbestahu@gmail.com>
-R:	Jeffle Xu <jefflexu@linux.alibaba.com>
+R:	Jingbo Xu <jefflexu@163.com>
 R:	Sandeep Dhavale <dhavale@google.com>
 R:	Hongbo Li <hongbohbli@tencent.com>
 R:	Chunhai Guo <guochunhai@vivo.com>
-- 
2.55.0


