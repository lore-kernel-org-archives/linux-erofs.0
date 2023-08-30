Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E79C6FA8F
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Aug 2023 23:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1693437391;
	bh=Cg0sUiOxI0MDXHpxuayzueyStn3AV8t6PD5Vh4L+pIQ=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=oRBEdhmd03TRxxkeJhXCiFOXoD0qObsVPR7k7OFMiVWEdwcQkoTC6XGDniIDt33to
	 I7IMU1kv/WqhqnCTQ/8Uk54obmBdh4o0r3iM6mz5+pkWHRVpyPxHtxo6uBrbK9la/7
	 tbc2NO8qRtx0pYJJVmEMSARmwqc3xXZoqLN3TFd1Ytl9pkD/bccbSFVS8Cuvqxgl8P
	 9HY2eczTwl4fPBpieCon5IBTopJeMrYQxFUxQklZuefw8G38LPDMTzC7yaSXU38Ned
	 KwxNVKKS5F+snk+mG8wCkRykASrnzkWquOEzCRCuxKBNJAMPjBhGjVuj1f2q2WQk0O
	 lb5EMW6Qh2dwg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RbgCg4bYNz30NN
	for <linux-erofs@archiver.kernel.org>; Thu, 31 Aug 2023 09:16:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20221208 header.b=wYW6pW+H;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--dhavale.bounces.google.com (client-ip=2607:f8b0:4864:20::449; helo=mail-pf1-x449.google.com; envelope-from=3xs3vzackc08uyrcr2vx55x2v.t532z4be-v85w92z9a9.5g2rs9.58x@flex--dhavale.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RbgCZ6l5sz2yVd
	for <linux-erofs@lists.ozlabs.org>; Thu, 31 Aug 2023 09:16:25 +1000 (AEST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68bec515fa9so188862b3a.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 30 Aug 2023 16:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693437383; x=1694042183;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cg0sUiOxI0MDXHpxuayzueyStn3AV8t6PD5Vh4L+pIQ=;
        b=BiuhCkr+qSqExH0v2HGhq7gxC29iCWVeUbwyYyN1/YzNPKIYsJPuvuI/xiuL75NU+z
         kM2DH27MuuBboTEbQIwjZKarpHjptp0Wi+m5RXZ+NNjKlIUp+JwJp1dQHS18RFdSthKm
         CS0xJTNAhS3aR3hlR3KbK26jaBlMPDODB+E4IJ+05MpQHJaFDXNul6tRVui63taUhQeH
         AwZA+m9jeTgr02fLB/LbP0yAzGcCF6lgpu9sdf4a7rolxjTSRZSIQRGXR9K+1mba1wt8
         omnv3/wdlh3LDnPmG4h3p7ad0zpu2bq5jTRX7JAcnl+ja22tfyHYOA3ZB5GISRBe8uO4
         dWcw==
X-Gm-Message-State: AOJu0YxAdY8Sr06r0b69Mi2Q9AhODSxxvyYDWrgY1C58WWT4971laFyu
	6IXhMpxMz4fbkgl4hUaUNDQVwDZfwC7HSMDH85hrC8gSqH/diV9DhLLhnW1QOtuDxIyu51KKu3k
	0tB5SBPGSX33X52Hlz5awduOwMrD9WCa9mNooXDy+tmkWD48ubmizglwh5BxwxkJAJPafZN8Y
X-Google-Smtp-Source: AGHT+IEtH7K7C9cH82KUHYq7QBzie6EccthcSDfHR8v37I73W8nYuk5CD3jL0ojjcHmtrtdyfxkE6fmgWGO1
X-Received: from dhavale-ctop.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5e39])
 (user=dhavale job=sendgmr) by 2002:a05:6a00:21d1:b0:68c:4a78:d32e with SMTP
 id t17-20020a056a0021d100b0068c4a78d32emr975007pfj.5.1693437382590; Wed, 30
 Aug 2023 16:16:22 -0700 (PDT)
Date: Wed, 30 Aug 2023 16:16:05 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230830231606.3783734-1-dhavale@google.com>
Subject: [PATCH v1 1/2] erofs-utils: Relax the hardchecks on the blocksize
To: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Sandeep Dhavale via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Sandeep Dhavale <dhavale@google.com>
Cc: kernel-team@android.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

As erofs-utils supports different block sizes upto
EROFS_MAX_BLOCK_SIZE, relax the checks so same tools
can be used to create images for platforms where
page size can be greater than 4096.

Signed-off-by: Sandeep Dhavale <dhavale@google.com>
---
 lib/namei.c | 2 --
 mkfs/main.c | 9 +++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/namei.c b/lib/namei.c
index 2bb1d4c..45dbcd3 100644
--- a/lib/namei.c
+++ b/lib/namei.c
@@ -144,8 +144,6 @@ int erofs_read_inode_from_disk(struct erofs_inode *vi)
 		vi->u.chunkbits = sbi->blkszbits +
 			(vi->u.chunkformat & EROFS_CHUNK_FORMAT_BLKBITS_MASK);
 	} else if (erofs_inode_is_data_compressed(vi->datalayout)) {
-		if (erofs_blksiz(vi->sbi) != EROFS_MAX_BLOCK_SIZE)
-			return -EOPNOTSUPP;
 		return z_erofs_fill_inode(vi);
 	}
 	return 0;
diff --git a/mkfs/main.c b/mkfs/main.c
index c03a7a8..37bf658 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -550,10 +550,11 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
 		cfg.c_dbg_lvl = EROFS_ERR;
 		cfg.c_showprogress = false;
 	}
-	if (cfg.c_compr_alg[0] && erofs_blksiz(&sbi) != EROFS_MAX_BLOCK_SIZE) {
-		erofs_err("compression is unsupported for now with block size %u",
-			  erofs_blksiz(&sbi));
-		return -EINVAL;
+	if (cfg.c_compr_alg[0] && erofs_blksiz(&sbi) != getpagesize()) {
+		erofs_warn("subpage blocksize with compression is not yet "
+			"supported. Compressed image will only work with "
+			"arch pagesize = blocksize = %u bytes",
+			erofs_blksiz(&sbi));
 	}
 	if (pclustersize_max) {
 		if (pclustersize_max < erofs_blksiz(&sbi) ||
-- 
2.42.0.283.g2d96d420d3-goog

