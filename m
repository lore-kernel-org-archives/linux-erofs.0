Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E78E6EE3F3F
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Sep 2023 22:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1694556748;
	bh=59zuDAzq0ZtpuHw9ci+ZLGOAB1aJduEQseITGta0/qs=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=fC5XA7AvpeDJeiVuLDkPoh6dXdbPmFRz7Oh/vgQSwCNmhxIx9UHFmIIOk7mJFu+rO
	 SJd6/TILm5IFbVrFZNJ0uP0IcGEIUqXiaUP5ifV6l4a0VBzEhwFW1bHMrYXW4KkfBw
	 AHWofLJMCX/ieEBD0GeCbK1bo8m9CD0kWoBCmBCSwpww5jig8wYIqcNBOIv9TkTr0X
	 IVvVTQqf5aQ8mPkM2bxHdxHQWMoYt81YIpFqJmS2Rekbdtw4OXrVZ5qK97juIYKJuu
	 hyNdHhqBP4xH1GzfYHIEISxIqIn4yUWnDFJluGKiRI02/7tJTFiZzbsgYCVhmgHUdD
	 CEFiglbqPPbNQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Rld9m2n1cz3bYx
	for <linux-erofs@archiver.kernel.org>; Wed, 13 Sep 2023 08:12:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20230601 header.b=0BGnKSRh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--dhavale.bounces.google.com (client-ip=2607:f8b0:4864:20::549; helo=mail-pg1-x549.google.com; envelope-from=3puiazqckczuuyrmrcvxffxcv.tfdczelo-vifwjczjkj.fqcrsj.fix@flex--dhavale.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Rld9b2c0dz309t
	for <linux-erofs@lists.ozlabs.org>; Wed, 13 Sep 2023 08:12:17 +1000 (AEST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-57787e29037so2332103a12.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 12 Sep 2023 15:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694556735; x=1695161535;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=59zuDAzq0ZtpuHw9ci+ZLGOAB1aJduEQseITGta0/qs=;
        b=q6v2/Ep211uIsYqQXhenEsAgiSDTdRgAkXR05X6G4wGLfX9GYux9i3ec2baIume5qe
         PXp0GZQEMReXTGlaYGUWmDZUE1dRe1j9MuMCVmos94R18Hkw6fF4UMEktAQvRGbkktyr
         Ie9PYx6BRscfjUGPmEeK6kNhwodAwuq7TkthvppMkoCmHdGcaJTYWweXRkcFFnhDSSd6
         qApL8BX6AfzUOgv5PBfJrFtWV+BTJdj4S4xD6BOo5Pz+TntenVHEp8gut44NutPt9GF9
         H9s8JBBpiQ/ZDaugPTCzVMzDrRVBTNoKuH2fTMicN6oGTf2+7E/krpoJhzw26KLwgCNA
         eQxQ==
X-Gm-Message-State: AOJu0YzHy+//W/Sk1kLvKYeLC97w2fDd/rfB629VXTrtXjaqKjgx0cUv
	Yit5Ju1nprgct9gWj92QVq6r9fAftCAbalYzh3pyO/s9F/sxnKEIGGCzP1QWq4dtU6FYrfFvt4Q
	SXRpAuK3AQ5+JX89K61x6cuKlIoEn/U3xeKmvkXfuPT5t/HET1EtRMV+AEQkxP5qKmp3d1cE+
X-Google-Smtp-Source: AGHT+IHgLY2t8ZGds18cNulk3vGxWZaL/Hw6dwSeYYLM7yY3ZP1wCPXDUDoXYasAuN8oi8nW6NjE5/Ph0PVF
X-Received: from dhavale-ctop.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5e39])
 (user=dhavale job=sendgmr) by 2002:a63:7e58:0:b0:565:dddd:1f65 with SMTP id
 o24-20020a637e58000000b00565dddd1f65mr14797pgn.7.1694556734509; Tue, 12 Sep
 2023 15:12:14 -0700 (PDT)
Date: Tue, 12 Sep 2023 15:12:04 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912221204.52184-1-dhavale@google.com>
Subject: [PATCH v1] erofs-utils: fsck: fix support for 16k block size
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

This basically follows the fix in kernel commit
001b8ccd0650 (erofs: fix compact 4B support for 16k
block size).

Without this patch fsck on images with 16k block size
reports corruption which is not correct.

Fixes: 76b822726ff8 ("erofs-utils: introduce compacted compression
indexes")

Signed-off-by: Sandeep Dhavale <dhavale@google.com>
---
 lib/zmap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/zmap.c b/lib/zmap.c
index cd91ca5..81fa22b 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -244,7 +244,7 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 	u8 *in, type;
 	bool big_pcluster;
 
-	if (1 << amortizedshift == 4)
+	if (1 << amortizedshift == 4 && lclusterbits <= 14)
 		vcnt = 2;
 	else if (1 << amortizedshift == 2 && lclusterbits == 12)
 		vcnt = 16;
@@ -346,7 +346,6 @@ static int compacted_load_cluster_from_disk(struct z_erofs_maprecorder *m,
 {
 	struct erofs_inode *const vi = m->inode;
 	struct erofs_sb_info *sbi = vi->sbi;
-	const unsigned int lclusterbits = vi->z_logical_clusterbits;
 	const erofs_off_t ebase = round_up(erofs_iloc(vi) + vi->inode_isize +
 					   vi->xattr_isize, 8) +
 		sizeof(struct z_erofs_map_header);
@@ -356,9 +355,6 @@ static int compacted_load_cluster_from_disk(struct z_erofs_maprecorder *m,
 	erofs_off_t pos;
 	int err;
 
-	if (lclusterbits != 12)
-		return -EOPNOTSUPP;
-
 	if (lcn >= totalidx)
 		return -EINVAL;
 
-- 
2.42.0.283.g2d96d420d3-goog

