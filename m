Return-Path: <linux-erofs+bounces-3787-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BCCC43638
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jun 2026 02:52:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gq73r46kkz2xHK;
	Tue, 30 Jun 2026 12:52:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782787960;
	cv=none; b=cOdMnKiu484n7c+UzgA3pbcUfhIt+0LnV0ZzQO8DrmLeaknNPLqHrtwuxG6Fwkhvnl19B3kW87N/G42XONyC3ldgM/EgQttQzzhabGu1PtlrFcu4lzVseOP0z57il1uvXEEMePI94fadEPqq3pDs1VSGg+d+tyb82DgemzgYU15ECEE5t7zVkdndl5KM4MMt3TDLX0Ve0xsafdowrgiCfB7dcawmsGRuhdCJ2iIXOV3c+MmpbfG3kaVfytXTAbmxHfKK30C7B6B7a9fUB8qB2cBWnLfrqFQUh+vuGf6OJTRaQeE49kppFpD/KP+b/DgRmICNLuHGtv9Uz7zU6H+oQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782787960; c=relaxed/relaxed;
	bh=OGVZlrDg6gXKcEAbbEvD1WBHleNRRMtLiM+LXawwryI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8L3hoGQGljA8ZyVKwi0w9tjlRVT4LKgtEibKJfY+e/2azjtbpbf5gTIxOx2t0tz0MUF+EyzlPiNHAZz2FKpP/dBo9gW1Yc3zv9AqmWNnYxFS2ig/dY0PwJCTDYcVssl1LaOwEbtsfIhnvJI5/pg7ZINW4Ou6yJPaehX4VXJOs1l+9agVbwTM/rK/RXYEUz4eJILvg5uEUfJXEkfHrRwbMrB1mQmTpQUTTIFUfQhwYvsA39K+cpsiDXUeS/1T1S4yrxxvZUGGfWPQeWIK/yoEVS6pN0bxpAkSBpNBn37bTkY3Zd5H+fvjdV4DOatbsRPXHRf1qNwbUhHUJn/iH8hlw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vBi+Pswy; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vBi+Pswy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gq73q5VC4z2yZ6
	for <linux-erofs@lists.ozlabs.org>; Tue, 30 Jun 2026 12:52:39 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782787956; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=OGVZlrDg6gXKcEAbbEvD1WBHleNRRMtLiM+LXawwryI=;
	b=vBi+PswyhpRDyEyGt9u/qqiEmAXEQZiJIc98sYLDMdAICKXUwN1pl3KvwEJEkjX283qXgoPSWo7r+Ng7maFKDdjNcPuznG2UzvEglOuy/ZDrm6xz1jLHQ6EsAf/BaE2nZlYjdsTI2V6hRdoS2jvc0vImvXdjhfK/IpL30ndeGUQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X5zS2q2_1782787952;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5zS2q2_1782787952 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Jun 2026 10:52:33 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 5/7] erofs-utils: lib: fix `STRING_NULL` in nbd.c
Date: Tue, 30 Jun 2026 10:52:22 +0800
Message-ID: <20260630025224.3955763-5-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260630025224.3955763-1-hsiangkao@linux.alibaba.com>
References: <20260630025224.3955763-1-hsiangkao@linux.alibaba.com>
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

Coverity-id: 647257
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/backends/nbd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/backends/nbd.c b/lib/backends/nbd.c
index c488053d99d3..db0df44990b6 100644
--- a/lib/backends/nbd.c
+++ b/lib/backends/nbd.c
@@ -82,6 +82,7 @@ long erofs_nbd_in_service(int nbdnum)
 		return err;
 	}
 	close(fd);
+	s[sizeof(s) - 1] = '\0';
 	return strtol(s, NULL, 10);
 }
 
-- 
2.43.5


