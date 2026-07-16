Return-Path: <linux-erofs+bounces-3901-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03771C44507
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jul 2026 03:24:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h0z0x0XT4z2yRF;
	Thu, 16 Jul 2026 13:24:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784172257;
	cv=none; b=MwyiEa6v6rW+OHr83yt6Ifgbvtyfk0kASF/nboLVcUngMZBdjEmq0ujVZtcIcTIefVbsP/areWj4O7W8NTiA5wWlmOU+sYCuNnxphO2XGgIosMmmCgANJx/yrnBd21Dyth4GxSAJczOCfaJZJJAthWE/iRgrvpy3H5G5CUt4z4QPYUmgOyv53C6p8z9rkKup2vHTfgMuXYUKyYcesrFXnShOg2wDj03BzgE8kG8S0A/tdcL/SCQHXnPJzrVgEG5jq7SVYFqzF/yw8X1yF8rU136NDe22uxn26aSALxpLIwmJNCRX9Cc7S5vNhH2YDUDVRbvFrrzkpsgOcI+aIUftPw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784172257; c=relaxed/relaxed;
	bh=WoMJfgAJjFPPq74NvtBEBqYRNzjw1z2CyqRCnWBtoNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qwn4gl39cW6ltoLz51LJXAQ9qs5/tg/8tAVaum6FJaj1oM/U2AYDsjz8quulzcuBJ42S9pFt1Ei8VAR7EVQhd82f0wwJ05bEqVIVQ+fn3SJ2UDBfgyXZgJ+E7BN4ifcBk4X5fiywEP1lbGkTqm5pXhAZAVN5gMSabV4GiMgYTnd9mRCwkZGjE4m7ukak3HqHeqXShgDmVn4/FfbCV2E8uLlTaMCYTsFguO7K5joZLafWHA1PDKkQjEvAyoVM1BPHIGUECmkHITV0Yo6Z2AkcSYafvo1FuYNECihlJgytwrooHppVoeguDZ9SEHyqHIFS9F6SVraTPg7YLNbULrFr2g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T4Mh1b6v; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T4Mh1b6v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h0z0t50wTz2xVY
	for <linux-erofs@lists.ozlabs.org>; Thu, 16 Jul 2026 13:24:12 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784172248; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WoMJfgAJjFPPq74NvtBEBqYRNzjw1z2CyqRCnWBtoNs=;
	b=T4Mh1b6vrwJLgwQoqIkXAFFYEchbhUbL3RS135Mi5gVkmA2cKUrxcfvedaMtLIBWCYnmka3zs0XVrFLMPH4G4VrAC+c+4DDGZaUWi0D4q1k+Izq/5gxQYIkGy3A3wn1MuZoOk6os8JfRe2CDRKfSZGgh0TuHfIn/u9FG/TY0UGg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X7BHQ.k_1784172242;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7BHQ.k_1784172242 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 11:24:06 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: tar: fix overly large size in tar header
Date: Thu, 16 Jul 2026 11:24:01 +0800
Message-ID: <20260716032401.4172874-1-hsiangkao@linux.alibaba.com>
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

As @oscarjhk reported:

When tar-index mode is used, the inode chunk count will be calculated
as 0 if a crafted GNU base-256 size is UINT64_MAX, which will cause
a heap out-of-bounds write.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/blobchunk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 0523873570a2..5e0fb70be687 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -507,7 +507,9 @@ int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset)
 		datablob_size += round_up(inode->i_size, erofs_blksiz(sbi));
 	}
 	chunksize = 1ULL << chunkbits;
-	count = DIV_ROUND_UP(inode->i_size, chunksize);
+	/* e.g. DIV_ROUND_UP(UINT64_MAX, 1 TiB) can overflow */
+	count = (inode->i_size >> chunkbits) +
+		!!(inode->i_size & (chunksize - 1));
 
 	inode->extent_isize = count * unit;
 	idx = calloc(count, max(sizeof(*idx), sizeof(void *)));
-- 
2.43.5


