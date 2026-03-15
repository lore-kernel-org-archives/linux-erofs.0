Return-Path: <linux-erofs+bounces-2694-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E04D0D58B0F
	for <linux-erofs@archiver.kernel.org>; Sun, 15 Mar 2026 07:19:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYV3V0R4bz2yYy;
	Sun, 15 Mar 2026 18:19:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::102f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773559189;
	cv=none; b=dOpzmTDnlS5u8xfEEGfSspIMImIWz990MMIFi2LybVs8AvgRjtBU6+u9hRG8rdYoAcPRj1jnpura4+FaFRiUlb6shrfCeOBTYi4eEJoR+5CP5ibULw0+wzOGHnDXeyOYuuAGFetg8oSPLVf3EzxumIbRS68kuwqX54wCmO/53M0g6JNRCV0T/S1s8mlmzW6yzXrxLfqaMEt0WNuoD/IYiRoNw+esdMFLILpie435JtgvrskqfScpf/WtrmWU3whsn0H0GMZOT2b3Tn+sqMuEQpfgmaYLceESQxgpztrpO6VrLqaUgD/IfJs0M4tZCz8j7jphsbXlMn8yWiAueWaFrA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773559189; c=relaxed/relaxed;
	bh=YsvoXzlgpqgnDGU1qYKZ6J8KGcJys0oqkM599c/HXcc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n8dqxIAYLmtHoFGM88Tx4H9muM1QjSQvJacprhuKW0g4RaItLu2TTD2ErJHxS1iddp60qBMapl1+7hMQSum1QHg3t39tMKcICj6jKYAVxrpOKciVDswsNAdwltwQqXqmw+aVf5y4dj8J/lESm3SUaBp/L0sLVOTuFzfItzL72ZTSAtqGK8RDHCyDa/H1ugX1cSlPNYoS05EzPPvPw7EnuAJRS5aOOQj7r5waJK6sVP4RCQ2HgqYb5MUNWPvMVRJk7Pjjx8PrFR2VoKqfwjrsNeIZuVhstVZ5/sr63brhnSpv91bqasrdASREVyB3Y8bTjGZkZl21BQie2EUQtD9KUA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=iiMYBKaj; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102f; helo=mail-pj1-x102f.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=iiMYBKaj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102f; helo=mail-pj1-x102f.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYV3S5F6Yz2xVT
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 18:19:47 +1100 (AEDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-35a1826cb69so380836a91.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 00:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773559185; x=1774163985; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YsvoXzlgpqgnDGU1qYKZ6J8KGcJys0oqkM599c/HXcc=;
        b=iiMYBKajaPnmiOHdrJ++lgRNKlZQD+cL2Ykg5Gsl9xaZAFhkQyPDwRh2IrTI8axrwT
         S3Lmg8D9kM4z/4ueK8tkPonVC1ESl7KU+6OTZRt/B1giVXWIE7EVkVQWwxj2N6LYWL7l
         21djUU8x2U/1CTvm9aJC/YzUbQPYFUc5+D/Ibv2F7TYi2nfXYGJ3kT73tXhqG/uxPGEw
         jisrkLkg80RC8cmSltnw1OBcfqcuq7+9g9JAScA4Xa2mfql3ErqO8a6kvd4ZHFPdQxXW
         yyIABNiJ9Ilavod0MDOuDT97z0qW2nB/dKh4+2HOVhh1Zo0C6/j1NlpAHZwOCDdvLjTa
         +Lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773559185; x=1774163985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YsvoXzlgpqgnDGU1qYKZ6J8KGcJys0oqkM599c/HXcc=;
        b=hUsGzQXhpvxUVPtC6+jO0Vpod6PYhjeQPNRB30bS803PevDJpvz99qFHOiaDSBWiHn
         GP/to/n4g0pyaBK3CqUuVet54HRrKea3FL40OagvNWB4CARWD7S4VTElSTXi4v18Njn4
         /BbfGhfSBNCy+nZQZxxHpRV9LViYuuT0Oo8uvRdMLZhOJoXLNjTpHbMEmtzAl4L6dTL6
         h5Xg6NMqk3Q09qM7M0dcn7ymt1jDdwuOCAGAqDsVxw3cxD3hZmA1xqiAECG1+p2NF7sy
         nuY7nE+tVlQ2g0hyum2WwSKPKBX0/hMDox/J7Vs58m5A00ATw7GalUP151fgyuMbsAkl
         KubQ==
X-Gm-Message-State: AOJu0YyjsjJsF7oDy952RUVzvvtUWYJDhpPtqEMmBC50WJtXQoIVZZWw
	66lwB6Zi+wqkWLj8Mz2Z5aqcCAE4evnoAITAjQ/Ceo38+CrHXzobU36W
X-Gm-Gg: ATEYQzz6vj/b1HkHiX+z14vQhgQcQKdbPJoArscNNSFThgtcUMKa/p2c7Iq/8RcPj/C
	3ePai3wmCXqpcvLuA3DxZX5CTlpX+pdjG01zk4WKHbLE1fAzJAFFdK/NokMzeODM2rHo/lwoXdb
	NHlpKzaKZcbcUAyKZ1a34QOJ93QN4JzGldVrY2oTm+BTQH+I0vIQ/4spe4jht7bnH6/TEfHNV7C
	jhbtoV/CGvbPl2SD1YxpODU7HSIVmlauJaxeI/3aSmgUuRaMO8ZwwlLmLFl/mQOwnKLTCEk0mQY
	ivyx6pGWhUR1Xcnf5LnJe1Z8TeLoRvOCIxACYSXcANDuDbKwj/VNTKrHI876X4O8FQPuKHnHwlA
	TJjRS0vEg8+3IFDALShVv77yL57hPXXkEHrCCTlByYLFCKER/NPrpCk86PSiBIwcdvM3joEfd3X
	QdOlvfYNw+R/x4JrFDzgpWD7Xg2FcVemAr4gT7XWHMiQvrJxjfXnGqyc9fwKOsmgblNQc0o4eUk
	c7oqNZwtgCk4jQSXDg7KzeluiznA6ehznQElw==
X-Received: by 2002:a17:902:f546:b0:2ae:4f95:df56 with SMTP id d9443c01a7336-2aecaa3eb84mr60638885ad.3.1773559185290;
        Sun, 15 Mar 2026 00:19:45 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece86717asm66952405ad.90.2026.03.15.00.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 00:19:44 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: hsiangkao@linux.alibaba.com
Cc: linux-erofs@lists.ozlabs.org,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: xattr: validate h_shared_count against xattr_isize
Date: Sun, 15 Mar 2026 07:19:41 +0000
Message-ID: <20260315071941.15424-1-singhutkal015@gmail.com>
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

The h_shared_count field in struct erofs_xattr_ibody_header is a raw u8
read directly from the on-disk image without any validation.  The code
currently trusts this value unconditionally:

  vi->xattr_shared_count = ih->h_shared_count;
  vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count * sizeof(uint));

  for (i = 0; i < vi->xattr_shared_count; ++i) {
          it.kaddr = erofs_bread(&it.buf, it.pos, true);
          vi->xattr_shared_xattrs[i] = le32_to_cpu(*(__le32 *)it.kaddr);
          it.pos += sizeof(__le32);
  }

A crafted image with xattr_isize=12 (minimum, header only) and
h_shared_count=50 causes the loop to read 200 bytes past the declared
xattr region into adjacent inode metadata or data blocks.  The harvested
values are later used as raw offsets in erofs_xattr_iter_shared():

  it->pos = erofs_pos(sbi, sbi->xattr_blkaddr) +
            vi->xattr_shared_xattrs[i] * sizeof(__le32);

This creates an arbitrary-read-within-image primitive exploitable via
malicious container images processed by fsck.erofs, erofsfuse, or
dump.erofs.

Fix by validating that all h_shared_count entries fit inside xattr_isize
before allocating or iterating, returning -EFSCORRUPTED on violation.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/xattr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/lib/xattr.c b/lib/xattr.c
index 565070a..64f3f95 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1182,6 +1182,26 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
 
 	ih = it.kaddr;
 	vi->xattr_shared_count = ih->h_shared_count;
+
+	/*
+	 * Validate that the claimed number of shared xattr index entries
+	 * actually fits within the inode's declared xattr_isize.
+	 * h_shared_count is a raw u8 read from the on-disk image; a crafted
+	 * image could set h_shared_count=255 with xattr_isize=12 (header only),
+	 * causing the loop below to read h_shared_count*4 bytes past the xattr
+	 * region into adjacent inode metadata.  Those harvested values are later
+	 * used as block offsets in erofs_xattr_iter_shared(), making this an
+	 * arbitrary-read-within-image primitive.
+	 */
+	if (vi->xattr_shared_count &&
+	    (unsigned int)vi->xattr_shared_count * sizeof(__le32) >
+	    vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) {
+		erofs_err("xattr_shared_count %u exceeds xattr_isize %u for nid %llu",
+			  vi->xattr_shared_count, vi->xattr_isize,
+			  (unsigned long long)vi->nid);
+		erofs_put_metabuf(&it.buf);
+		return -EFSCORRUPTED;
+	}
 	vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count * sizeof(uint));
 	if (!vi->xattr_shared_xattrs) {
 		erofs_put_metabuf(&it.buf);
-- 
2.43.0


