Return-Path: <linux-erofs+bounces-2433-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A04FC5910
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Feb 2026 09:10:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fM5Jh3FvQz2yFc;
	Thu, 26 Feb 2026 20:10:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::643"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772097012;
	cv=none; b=lmXj5c3nM0djYz4twqP/s3U2tl99kZimcPlyw83cNMk8uHQgr2mhXlsX079ZisUaKZq9Co10mKuow3FhJ+QygDpjHhnT0N8YXH03iqGOoanU/qz9v3j+/RcJBulFgnnITzvvFRW/8Gr4RdTb8WCE71Qi8pW7BPH7437ra6FesOjFz21XhM36GMa2luybIhCLKcIvnz2Di2QvgNOCor/Cu6GCjxOq/rzA/NCIGnhO5YdF3ebhwYzy0wnnBp/+VAZD1IPNiD/rMOcUGhWosjxD+ccbdYV4Kwg8i4TdV8Rrjw5bY5OflS3muhZNSGP4BvD+CDTsXzgd/QFF98aLQK7Cfw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772097012; c=relaxed/relaxed;
	bh=4Tpq3s738ysu0U1EheNOw1sCR0wRmBxQ92Kaez61/Bk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SXze0wOf/zuqAnnlB14MmfPvEGeN5onZTxnYTen+YNKuwqsF9wzmb4lR1oT+f6mlPqIQqQX9rPEZk/5Y04PrwpKhN08xE7h9Eq8CiWHBq2S6YxEAUIna/KMDMWY48AOgntOFyV6ZARN7yp7Z8xmweoy8u61AjgSHqQKsBpXPVKtGPHH+EsPNM5Qi2FulTAKwEFcBJfQgNn+x2G3qQlp75/n2quVb44l/YSA1qh7vgGPFcvkb4Cix4Uu2p5zbymvT10SAX5F3fqlRuqXGu76LXpRrkukQMjxn9KxHZqpjv/1nC019ugWs+6hPj5JMBgU11guVpId6hLIfJeJo+1Fs+Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=QXP5wEea; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::643; helo=mail-pl1-x643.google.com; envelope-from=shengyong2021@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=QXP5wEea;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::643; helo=mail-pl1-x643.google.com; envelope-from=shengyong2021@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fM5Jf2ytkz2xMt
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 20:10:09 +1100 (AEDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-2ad9a9be502so4140815ad.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 01:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772097006; x=1772701806; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=4Tpq3s738ysu0U1EheNOw1sCR0wRmBxQ92Kaez61/Bk=;
        b=QXP5wEeaEz2JU0sfijF3g8Jhr4bVEz2jn5oiZkVCJ/QHofjz4rc61+G5/o17Tqcx4m
         HQt4OWCE5IvaYCGwn8358cnz4XzkUqwkXOoBQCxkvXrHNsyiHTVXjlQK2FatGVvSvquG
         iWBXS0X9b0ZFLhIkercTbrn3A2+rh5Eol6Iu7kVM5CoklLIewvefFEGueS9yEDORAD2w
         QlbOwzwWUMqdr1ZH/ZET5LgxMaQCQqFM1zJk4yWSMwCkMf/WeZxjSWSzUrskSLlc2+QV
         Opn1n8LTy5x/y1qu3pK1X0ped2qQEXPqqXVOKXkFAiLr30LCsthOnnPWoCjeYBWUKKR+
         4NvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772097006; x=1772701806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Tpq3s738ysu0U1EheNOw1sCR0wRmBxQ92Kaez61/Bk=;
        b=mqHcwYp4CF6E2bBD6zfPA7fEOck2XwHkLZ1JE2csywRuwA8Ekt/adDoDB0w+lAMnVi
         WLI4BE4dOLUofU5ZyE427RygmY6MZj/1VBLWbQw8cb6aHLLkmXVJfi1l1KxFlwC/TJbO
         nr6gI075A9025u/onBvab0aDVa3d2sVTk66sFImR6N2W+sW6s/rxN5RfGSDQY3GewRMJ
         nNlq/X8/rmZfFxh6i06BHRRYedDHTsbUcR4OSnpDSyoga61ttC/MwCuMUs9SmzIPEjWU
         vSPVwdERq4iNuR9p/z9D9etHIT7MqA4Iv18fB3VidvDXuakvDRMNpQ0SBmaGw5gLGHc1
         I5Cg==
X-Gm-Message-State: AOJu0YziDNFtz+jtuATz2coUP0s+93iqT8RHtpSEDaXFYuTiBv1nQ9oU
	aX6K7R+riRJVhe/a/HCHVceX1CfJ0tkuxb3BmrAi1xnZJckT3RI1hCOQVrfUvDjV
X-Gm-Gg: ATEYQzwQ4eRulg1VW6Xni/FPL+sQ/8+xeoUgwi+6mzfI7VgmNrm4cpXfC3ZgTDER2ht
	6f+H6eYVwPHUnMOgBxbT9C9c0IFlbzaxzszpHrVPQJRRS3025HWYaAPsvdYTPYxvPviN7qtFAA1
	mIiJXRZPRAtEFgeJJkuWjYUSB4tnUcFYB4ZD9KZz8OvAtBTuth4eYqD/hGTdqHHyMb2uY+lHw4i
	xAIVMncJ2d0tu+hLjkJTlIisDrt9pxGgjIaqNUc3836uBVg+Z7dFyO9uUAGPXa5lO+NzWQXHMR9
	QdTTSHZPUT/IGr/rwNoGR24Ruav6KINgriuzDHclZfVYRtpHv0KCjYYyWTMLCRYRFN8Gwn+lbEV
	JvEcgVlcIGDDIBs3tBePf/drMKqA+BUiWvoxXoWFNYbXFLzYvmmBWT6yjLCZPzlyvcBax7a9RBh
	8Oo/I8s3a7pcEGR1iVwKPHK0/ryMQLIEg7y33aX5vq
X-Received: by 2002:a17:903:22d2:b0:2aa:d6a1:e18b with SMTP id d9443c01a7336-2ade998e04dmr39818555ad.18.1772097005936;
        Thu, 26 Feb 2026 01:10:05 -0800 (PST)
Received: from PC.mioffice.cn ([43.224.245.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b53f4sm17826275ad.18.2026.02.26.01.10.04
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 01:10:05 -0800 (PST)
From: Sheng Yong <shengyong2021@gmail.com>
X-Google-Original-From: Sheng Yong <shengyong1@xiaomi.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: mark fileio folios uptodate based on the number of bytes read
Date: Thu, 26 Feb 2026 17:09:46 +0800
Message-ID: <20260226090947.2808686-1-shengyong1@xiaomi.com>
X-Mailer: git-send-email 2.43.0
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

From: Sheng Yong <shengyong1@xiaomi.com>

For file-backed mount, IO requests are handled by vfs_iocb_iter_read().
However, it can be interrupted by SIGKILL, returning the number of
bytes actually copied. Although unused folios are zero filled, they
are unexpectedly marked as uptodate.
This patch addresses this by setting folios uptodate based on the actual
number of bytes read for the plain backing file. And for the compressed
backing file, there may not have sufficient data for decompression,
in such case, the bio is marked with an error directly.

Fixes: ce63cb62d794 ("erofs: support unencoded inodes for fileio")
Reported-by: chenguanyou <chenguanyou@xiaomi.com>
Signed-off-by: Yunlei He <heyunlei@xiaomi.com>
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
---
 fs/erofs/fileio.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index abe873f01297..172444ae4ede 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -24,18 +24,30 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 	struct erofs_fileio_rq *rq =
 			container_of(iocb, struct erofs_fileio_rq, iocb);
 	struct folio_iter fi;
+	bool bio_advanced = false;
 
 	if (ret >= 0 && ret != rq->bio.bi_iter.bi_size) {
 		bio_advance(&rq->bio, ret);
 		zero_fill_bio(&rq->bio);
+		bio_advanced = true;
 	}
 	if (!rq->bio.bi_end_io) {
 		bio_for_each_folio_all(fi, &rq->bio) {
 			DBG_BUGON(folio_test_uptodate(fi.folio));
-			erofs_onlinefolio_end(fi.folio, ret < 0, false);
+			if (likely(!bio_advanced ||
+				   ret >= (long)folio_size(fi.folio))) {
+				erofs_onlinefolio_end(fi.folio, 0, false);
+				ret -= folio_size(fi.folio);
+			} else {
+				erofs_onlinefolio_end(fi.folio, -EIO, false);
+			}
 		}
 	} else if (ret < 0 && !rq->bio.bi_status) {
 		rq->bio.bi_status = errno_to_blk_status(ret);
+	} else if (bio_advanced &&
+		   ret + iocb->ki_pos < i_size_read(file_inode(iocb->ki_filp))) {
+		/* may not have sufficient data for decompression */
+		rq->bio.bi_status = -EIO;
 	}
 	bio_endio(&rq->bio);
 	bio_uninit(&rq->bio);
-- 
2.43.0


