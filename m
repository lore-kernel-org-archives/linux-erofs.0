Return-Path: <linux-erofs+bounces-2698-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E938D58B08
	for <linux-erofs@archiver.kernel.org>; Sun, 15 Mar 2026 07:38:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYVSr5HW8z2yYy;
	Sun, 15 Mar 2026 18:38:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1032"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773560300;
	cv=none; b=SE9L1tYdw14S4tv1q4iW2yf0Vrz0XP/hPeMMAoi7HddQVwbrB+ateT1Jf+2c+tyxoynNPehXiVo+zgmnpacwy+fMD1PBrx5YP/wZUx31Onl0Z681RuS9xpkoPw0u0tZgkP/f9/vBirAhuxTOBuloUOYMdVBkY52Jp/sJ5iVfArTbvr8wfrR8NuVpZSXflaOzH8jcXCatJ/PP2Md9EKvqB5+hIn3Wrssn77aVEJ8KklhLDOmi/DM9qKUXDRXUfV7FoNd2DSWchoirSG0FGrJ7W5hZTcyA5d4GY4vyY581MaMQIFl2SuC/mqjYoR5ItasnkeXFH1/yirFc8BJoleNPNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773560300; c=relaxed/relaxed;
	bh=xOc88+p4ZxMDipD+pnCWBppHlZx0z5TH1NQEMJryy7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FiEtnZXg4fL1CmXfDslWlIR/5xGc2+9IAX01uVAUWXaZ+qEs3pMMghZDMHYNt8EM9y6Nl2/q6DCZR9wQ4vVKFp+FaPb2hTBTvfcL2jvnTBXKV0al3SR+7HaHwHFLgbY5FVoBQQfMOOOtlGRM9pCUdcTM2gLhS0+vAmbabNgeAgaknI5cbylDSw+TR0FjyFWX/VUYKSwltk1X+KyS/4DuXGt/Wkty12qtCJWvYQ2kwozqmxTmYwAMwD7wsFG1wARAgh/zyzvaI/ReMfnnst0yZI0hHHzImIuG/E4YrOaeCwhcPLtcOjmfo8nUE+546+z3fwnQWbL0Asmxcn0vz8nPMw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=EeknoNWG; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1032; helo=mail-pj1-x1032.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=EeknoNWG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1032; helo=mail-pj1-x1032.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYVSq3yxWz2xlM
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 18:38:18 +1100 (AEDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-35a034ca40cso369184a91.1
        for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 00:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773560296; x=1774165096; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xOc88+p4ZxMDipD+pnCWBppHlZx0z5TH1NQEMJryy7w=;
        b=EeknoNWG0DEvAzJFR2uAuYNY/HCMsl9MuitxqxJXEn1hM/lfLLR5EMD3zx/62ffHlr
         PDYKrCRKEUNzBzy0GPpE1zynvjlJ7p7Km95yJk5MHdSRmGlXC76Duid7udfojz+hO4K2
         SBOU1zoKNaCHoXWCHAEqSdBe0LcSPov06/3YWaTkh6NFJqJlEc3+U73b8XaDxH2eD4Ac
         Nd/2hvm/hnv8SWyJWozOUCY8U9OvK8ljad2PJChL22nTuUN1SijxwZGUpzM1VcVdSZEI
         ZsDfpcm33qGmH6t9Us9wjQnOoJQwuXfneuNqOGpxHl86Gdp/YBr/+1jI4tKC90G7fheV
         msxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773560296; x=1774165096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOc88+p4ZxMDipD+pnCWBppHlZx0z5TH1NQEMJryy7w=;
        b=CWVR16fm39wTu0hXfNJmbHGzJutPX1vxwwSC8kIRFgR60zENP262tkUVWZkfT2Uz58
         cDXbEJoO3Px4HRgbdwQdpO17yD5aUHEPwJ8HaMVgkE69oVm0hYLvMslRZqZcaww9f6K6
         7UgtRV2e5AKwS3S4/AHZFdlNeHspnIr5E6rUWrGAmXvc2F1dmFTkF7WNVq6BeY1jk7+M
         YQfX+0QLsOdE9THalO0LeZkAqw07x2kX6devtpdEFFh5HjU8m2n7ydq5pEfA+uU5ldn0
         TGRcU8IqyQk/rCGLLkp5jgR1gp35v3du/Cz8h8Csw9Ga7VdoueMXf6+GSqK9fJMQBmlx
         qsbQ==
X-Gm-Message-State: AOJu0Yy14IkbDtj4S+nxJJNtJBihgdPflCEMqrxCg7qMr6h04zBFghM7
	u6uWHkhzCq3/tRD8iFMjHwOPPlqgV2v0yQG+GW8PLPzlzTYUaS4A6zUk
X-Gm-Gg: ATEYQzy+Xvioy0cnLyS76Cym+KQTJzI1BgruiL2TOC7cKiHmHCigSTYNLGC/tt23U2D
	0wu05u2QEA7rKFIh/3pbBUKamKv5GA26O42AFeahZyKJT4OJiRvefKzH+hLJUlcCqnvxj69d+93
	MmFojalMHKO+zQqbvdAMG1nfjdkhwLxKSeOAv7hiHTTBeQOeRYB5yohbmeajOTe/uPrWoLIdFEw
	WlZlcOAcXTpMwc/Irbk0bp3maXq7Jefc1jDIBH2RwyBVKwCvZK7Ygs688kPPNCl/toVR63xt6jg
	bdCT8nPIGos/1WVAfYzckb18dD+O0IgdsVEPTfwcsqKYyR5v7xMOzRX0ex99NoyELNrNHk6b7JD
	XkkO547NTof4ag/5mipyjU/SV1u3AQ0aCYHsBgQ6bEOVwsaKXaJwGSUjYl78RNln9ftoQ7ujCKg
	8wTKJz98pBAm+kMkPUxUNnyx3JmfIpQp2/ma5qA1vwIV89N0WkZ+eUoA9TmB7B/X1Ad85ZbpwBr
	jOZRv4lCVT7/Y6N8V1f5xmGjaVWqQV6nB1J
X-Received: by 2002:a17:903:2ed0:b0:2ae:3f3f:67c4 with SMTP id d9443c01a7336-2aeca793a50mr63949515ad.0.1773560296161;
        Sun, 15 Mar 2026 00:38:16 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([112.196.126.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed9cdsm73690145ad.60.2026.03.15.00.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 00:38:15 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: hsiangkao@linux.alibaba.com
Cc: linux-erofs@lists.ozlabs.org,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] fsck.erofs: xattr: validate h_shared_count before shared entry loop
Date: Sun, 15 Mar 2026 07:38:11 +0000
Message-ID: <20260315073811.26665-1-singhutkal015@gmail.com>
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

The h_shared_count field in erofs_xattr_ibody_header is a raw u8 read
directly from the on-disk image.  erofs_verify_xattr() subtracts
h_shared_count * sizeof(erofs_xattr_entry) from 'remaining' without
first checking whether that product fits within the available space:

  remaining -= xattr_hdr_size;           /* remaining = xattr_isize - 12 */
  for (i = 0; i < xattr_shared_count; ++i) {
          ...
          remaining -= xattr_entry_size; /* can go deeply negative */
  }
  while (remaining > 0) {               /* silently skipped! */
          /* inline xattr validation never runs */
  }

A crafted image with h_shared_count=100 and xattr_isize=12 causes
remaining to reach -400.  The subsequent while(remaining > 0) loop
is never entered, so all inline xattr entries are silently skipped
and fsck.erofs reports the image as clean despite corruption.

Fix by checking that h_shared_count * xattr_entry_size does not
exceed the remaining space before the loop, returning -EFSCORRUPTED
on violation.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 fsck/main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fsck/main.c b/fsck/main.c
index 16cc627..a3cd50d 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -378,6 +378,20 @@ static int erofs_verify_xattr(struct erofs_inode *inode)
 	ofs = erofs_blkoff(sbi, addr) + xattr_hdr_size;
 	addr += xattr_hdr_size;
 	remaining -= xattr_hdr_size;
+	/* Validate shared count fits within remaining xattr space.
+	 * h_shared_count is a raw u8 from disk; if it exceeds the
+	 * available space, remaining goes negative and the inline
+	 * xattr validation loop at line 396 is silently skipped,
+	 * causing fsck to miss structurally corrupt xattr data.
+	 */
+	if ((unsigned int)xattr_shared_count * xattr_entry_size >
+	    (unsigned int)remaining) {
+		erofs_err("nid %llu: h_shared_count %u exceeds xattr_isize %u",
+			  (unsigned long long)inode->nid,
+			  xattr_shared_count, inode->xattr_isize);
+		ret = -EFSCORRUPTED;
+		goto out;
+	}
 	for (i = 0; i < xattr_shared_count; ++i) {
 		if (ofs >= erofs_blksiz(sbi)) {
 			if (ofs != erofs_blksiz(sbi)) {
-- 
2.43.0


