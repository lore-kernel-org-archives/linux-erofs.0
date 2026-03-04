Return-Path: <linux-erofs+bounces-2495-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF95FEFCE2A
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Mar 2026 18:21:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fR1G52dF6z3btf;
	Thu, 05 Mar 2026 05:21:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772648493;
	cv=none; b=jS0wWmSb1FhVDAXHm8Qys+sHE4IwzZdfTb1L+6ChKcn4G0+/Jaqr6fGWbK7Gt5OsRuM0xfF5Barl8TPSPJ6rDo8l85Ffp2SMaRJyMw7gtbiuoaPpuI48RAL4ZrXF/S+/Ad+zcLPWFicUBvj9Z4CxMdO0deHAbVVrhd1ZfzDAUc/sciSNfw+WzvQxk48UQDnTXP4NTs9eCtIwwYZffVr6s7z7w5c6tnTmRmx+aZsg7P9d7fJYBsoE0Yc67WwUA/xXhr+vQegySsDYR4cnDQsYcQUq4VFkxkNX/k+sZILyRBuJODWgrSBqGFK+6OCFVFw1t0CQ+PtYI0jA5IZCULEpTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772648493; c=relaxed/relaxed;
	bh=xQcr0ctsdk91yHeIqHcUipIE9mH3AHMowGAbPZn3O6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=erb14xvjDp9dISxGoPsjjtouyN/qxCk2p/bDcNQF9g0+8gp4PZHfXYTl8ZSHSpXL2YgnBAPL7M3/PW+mkMK2mHzso/UJIRtyL7GlSmTcpBuY1tPjft57vNtB+1LfG35yj9KjL3IPDuTAtzAxmzu2MvGAFcC8sHgP/9TojgY8BmjP5rNI6JRMNavO2wn+76DQc+3pX1bi1WtwJAxbhfZTrHqYKKL+l01baUIhK8hTlkuJSWb6HTKkQbOS4G7Ejdg8m7P1sPUqaENuFyGwKg03BSs6oxvgmKzHwo3bXTceDPCET/LbBk2Pj7ux+WyzNo9qvPDKZ8mfwCtmvWaJoEVC3Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=RVOxgmoC; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62d; helo=mail-pl1-x62d.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=RVOxgmoC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62d; helo=mail-pl1-x62d.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fR1G439qdz30hq
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Mar 2026 05:21:31 +1100 (AEDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-2ae471aabdaso2067455ad.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 04 Mar 2026 10:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772648488; x=1773253288; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xQcr0ctsdk91yHeIqHcUipIE9mH3AHMowGAbPZn3O6A=;
        b=RVOxgmoC91ziyasOdp4/0yGQdfQvjQGgQS8kxBqOBWjHTpBXC7AIVL1wgokBQ3tjEB
         BBz4Ji0N5DgRhj6YjmQS93LPF7WqMUnlccKx9SGq9iq/5EapAr7GgzRngFoziMlf5H+w
         KottAX9BfUwpmWPT8gOb1SOeIv5tDHVcF/zzxQDYxW15VBzO2l9CrUNiLjsXCyfGfocm
         Z61FSxDln3K/rzEt4vHPm1N4ofJVpcJ/Khsban4W1eQkUoOqWG8l7iuCtU4oDVE4dMom
         hdKFnpOouTSr/YPVYeNsccnEA1BLTq0u/R/372CRPreqEVAW9vW1gVig0ezgPQud5VAn
         +SIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772648488; x=1773253288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQcr0ctsdk91yHeIqHcUipIE9mH3AHMowGAbPZn3O6A=;
        b=SX/v+daNJRUyJLnM/Snan1q3MxGnPlKj3454CnKVt3WboLrDC1UNomYEynSbFmIfeg
         RUT5xnXshDaXmQSPhH6WC1dyABIjxAMXJc4e6mtv4g2BQ+4gDZa5LEPQTU1SZaRK0FTu
         DRCh0JwndGhZSpXi9d2mANRTP0pjPQ/yNtcqK2xDYDAvrLetnPXGKY/s7twD1TcOZJs2
         HAICneRnX8XuIAFpfd765ab6sbWTEH7f6DOweLIDqGfYSZV+MtA0D0ynr3Yd91fXp9U2
         gN1ja+4CNbwwdGc3ohaH+pVgr1vc0T81x+hS7obpAyuSfW4oEksl15RvlBVqa0t0gLSm
         Ss4g==
X-Gm-Message-State: AOJu0YzCbQYo6+IFfvy7UWhFgyaaVsheLoRIBVkRWqJ7b2E7BisSD4GS
	79Wnzvl8RMa15PTt/OW3ptjrkNJ33O02Wtic2iKs+UdGKWj4LrKrF+iid/axeDE8zV0=
X-Gm-Gg: ATEYQzxwkeFqUrxMPmS018qi2MeiAJz87mGDeZQG5/KL0cu7uYpl7YhTdPU0CTj8liP
	foIcq8+T3iP6dWs0P0BAAgFf3f/wwrIf6vtDm2e/F3lucv8CUF/r4xRqpKSACIRm/Bq4zU2h5LX
	VphxLdy5bWKQsRtTaCWyRTPhkRnKHJ8qYVj8nFjjGLiz/6yFvkN1xyrfQGmDK30KkKjwRpRkam3
	V9Gc4V82bF82ou5y+7TL1Mug0Kyz72zqeVJI2wSBEQF/swQgTbL28+GmhuthzVmu1ErUA/WEE33
	yFPQekpY7+SRQYO8uhbDDNo/FfZFdBy7QA490YiVVNQ+pD5erjhrmxPDciVYvK3tc4tY55A55EZ
	Qtejyd8eIiRljL/Nvy6hVXRnnsIn1dV+Sl51Dqod9HK1kdLH2xW/LAsUjNDdHNScagAVpYkJAAJ
	n+FzxykwqSQFn+HeeGFFIRAhvBF/FL2hiGYwiI7yLhAKSdd91B1nRb1nyMF5XL/2Lnxh0WC/Ev0
	XfU4b1XIcFwG9wXkogvcFp9r2iPk4L8Ha60CA==
X-Received: by 2002:a17:902:d483:b0:2ae:6220:1539 with SMTP id d9443c01a7336-2ae6aba1da6mr18771525ad.6.1772648488175;
        Wed, 04 Mar 2026 10:21:28 -0800 (PST)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69f244sm214306885ad.59.2026.03.04.10.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 10:21:27 -0800 (PST)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib: validate inode offset bounds in erofs_read_inode_from_disk()
Date: Wed,  4 Mar 2026 18:21:21 +0000
Message-ID: <20260304182121.44834-1-singhutkal015@gmail.com>
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

A crafted EROFS image can contain an out-of-range node ID in directory
entries or the superblock root_nid that causes erofs_iloc() to compute
an inode offset beyond the image size. This leads to out-of-bounds
reads in erofs_read_metabuf(), potentially crashing fsck.erofs,
erofsfuse, or dump.erofs.

Add a bounds check at the start of erofs_read_inode_from_disk() to
verify that the computed inode offset plus the minimum on-disk inode
size (erofs_inode_compact) does not exceed the primary device size.
Return -EFSCORRUPTED if the check fails.

This also deduplicates the erofs_iloc() computation which was
previously evaluated twice.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/namei.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/namei.c b/lib/namei.c
index 896e348..8a83166 100644
--- a/lib/namei.c
+++ b/lib/namei.c
@@ -25,8 +25,9 @@ static dev_t erofs_new_decode_dev(u32 dev)
 int erofs_read_inode_from_disk(struct erofs_inode *vi)
 {
 	struct erofs_sb_info *sbi = vi->sbi;
-	erofs_blk_t blkaddr = erofs_blknr(sbi, erofs_iloc(vi));
-	unsigned int ofs = erofs_blkoff(sbi, erofs_iloc(vi));
+	erofs_off_t inode_loc = erofs_iloc(vi);
+	erofs_blk_t blkaddr;
+	unsigned int ofs;
 	bool in_mbox = erofs_inode_in_metabox(vi);
 	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
 	erofs_blk_t addrmask = BIT_ULL(48) - 1;
@@ -36,6 +37,18 @@ int erofs_read_inode_from_disk(struct erofs_inode *vi)
 	void *ptr;
 	int err = 0;
 
+	if (!in_mbox && sbi->primarydevice_blocks &&
+	    inode_loc + sizeof(struct erofs_inode_compact) >
+	    erofs_pos(sbi, sbi->primarydevice_blocks)) {
+		erofs_err("invalid nid %llu (inode location %llu beyond image size %llu)",
+			  vi->nid | 0ULL, inode_loc | 0ULL,
+			  erofs_pos(sbi, sbi->primarydevice_blocks) | 0ULL);
+		return -EFSCORRUPTED;
+	}
+
+	blkaddr = erofs_blknr(sbi, inode_loc);
+	ofs = erofs_blkoff(sbi, inode_loc);
+
 	ptr = erofs_read_metabuf(&buf, sbi, erofs_pos(sbi, blkaddr), in_mbox);
 	if (IS_ERR(ptr)) {
 		err = PTR_ERR(ptr);
-- 
2.43.0


