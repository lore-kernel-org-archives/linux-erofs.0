Return-Path: <linux-erofs+bounces-3509-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D4FCD6E5D
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jun 2026 02:06:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gVWK12zvYz2xg3;
	Wed, 03 Jun 2026 12:06:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780452389;
	cv=none; b=N0C5P6iGqeLTM2p3WYsuidLazNsskYCeQNrQWC+p7YxgT626cCVHKxuueZpsTtHtBxoPRnI5m3pDgEL1JpXE2m57XfZXkNjhidGsL7kCTQBfnpmGB4f9EqMiY+XZHThioHpFL6oLFM5ZTfdct5gTTGFZ63gw5lz8I+54lapLXCXhwy7Uwse8hKnO6BVQx9mtLVbl8jqPneQsW59gy7MjmUUKHY+FRISGCtZPQL9Rle0DSHnTzZ/f/LZxLJe/4VubIJRKpsXTiWQt3EekDD5tdxd2hPkrDDh8W5SZXmYu/+maVbVs3QiHajII30uYWFyJqLcDupFxQy6yuiafIJPNVg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780452389; c=relaxed/relaxed;
	bh=wklCdgcCOUgpYZZkeky9ktyPzP2fKBHSAtH4gW7FTTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cGjmo9ahkcr1srzvBDIMWwQEQq+NixHljcBmoPtXsSi79Z/OZIHvJrkaRIu8mYU6Apg4p0z6xFNa3nS+6IpknMpiZarkJcl0Mr6ovEI0kbdTybHdeuDbCZBsii/S0wj9+QxCcdOjVCIGW0rhGWs0uCUwqMrZ6+rbjBtydRdzA0U5WY6T2Inh5Tff4vDxN8LD+1Kutc5KGMrRs7kGQSkSNsaQ7BJ/gkUesFBWKQ3sDBcmySrZpecBzTKYK1yLtyjdVPrBivuplpgd59NB8gc+V/J/6qYoywSGwYNuiurdQpLrWWyskYCVUM0d3nEZxb1p/IrLJXqS5CWGCQqUm/NFIA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cDhD8zKl; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cDhD8zKl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gVWJy67crz2xc2
	for <linux-erofs@lists.ozlabs.org>; Wed, 03 Jun 2026 12:06:24 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780452380; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wklCdgcCOUgpYZZkeky9ktyPzP2fKBHSAtH4gW7FTTQ=;
	b=cDhD8zKlYu986V4pskem0+dZKvPVOWKZO4DmLcl74K1Ud2yMvhf3BD4UN2/LvkUQWqTQ805m3+bhPpSPGFySRAjTPrT1qIT6oYU5SH05WflQPwrnS0FDgE5rCJM/wyAbSY7MRS1KjnS4KZWj158g/X1RojQx6a8EzMgTNWQrno4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X45rI3T_1780452374;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X45rI3T_1780452374 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Jun 2026 10:06:18 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: s3: use CURLINFO_CONTENT_LENGTH_DOWNLOAD_T if possible
Date: Wed,  3 Jun 2026 10:06:13 +0800
Message-ID: <20260603020613.1974534-1-hsiangkao@linux.alibaba.com>
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

To resolve the following warning:

remotes/s3.c: In function 's3erofs_get_object_size':
remotes/s3.c:1352:9: warning: 'CURLINFO_CONTENT_LENGTH_DOWNLOAD' is deprecated: since 7.55.0. Use CURLINFO_CONTENT_LENGTH_DOWNLOAD_T [-Wdeprecated-declarations]
 1352 |         ret = curl_easy_getinfo(curl, CURLINFO_CONTENT_LENGTH_DOWNLOAD,
      |         ^~~

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/remotes/s3.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index 870e0971b6ee..245efe5c77d8 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -1325,7 +1325,11 @@ static int s3erofs_get_object_size(struct s3erofs_vfile *s3vf)
 	struct erofs_s3 *s3 = s3vf->s3;
 	CURL *curl = s3->easy_curl;
 	long http_code = 0;
+#if (LIBCURL_VERSION_NUM >= 0x073700)
+	curl_off_t content_length;
+#else
 	double content_length = 0;
+#endif
 	int ret;
 
 	ret = s3erofs_prepare_url(&req, s3->endpoint, s3vf->bucket,
@@ -1349,7 +1353,11 @@ static int s3erofs_get_object_size(struct s3erofs_vfile *s3vf)
 		return -EIO;
 	}
 
+#if (LIBCURL_VERSION_NUM >= 0x073700)
+	ret = curl_easy_getinfo(curl, CURLINFO_CONTENT_LENGTH_DOWNLOAD_T,
+#else
 	ret = curl_easy_getinfo(curl, CURLINFO_CONTENT_LENGTH_DOWNLOAD,
+#endif
 				&content_length);
 	if (ret != CURLE_OK)
 		return -EIO;
-- 
2.43.5


