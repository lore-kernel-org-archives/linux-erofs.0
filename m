Return-Path: <linux-erofs+bounces-3188-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 112B4D73093
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Apr 2026 03:34:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fn48X4ZR3z2yVP;
	Fri, 03 Apr 2026 14:34:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1036"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775187260;
	cv=none; b=HxrQcQX4NAjY2ps8dHEg0MJMRddO+qUZalgLENgSC7jM7gJ9j3pfOhAYYyZ1t8I1lkY4SA/TyrrEPKruj6ddc1XkmUn8vAqAWG8CYR8AxLk5GNYhPkD1M9AmiNjtOV0kNdjiAVLUC6DM1aY8X+RJCVrUYqD6VKJvVQCHFZSQ55O1q7x/FhEmmjDcRYO0CqpM37NXTbbPs0C9upXwDAoXDB1tyWKFypLrktrpbHgt3tJVvrHSGbm9OxFgjs+XRlgs9YPeS014LppUPL8+HBx9K0dytxI+1LnzITwUfLZCbfHc9El9nYPD/XBurN4jEV7pzeo4OXb1NVomnLI63OMjQA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775187260; c=relaxed/relaxed;
	bh=MLJOW2uio0l4V1rabuDMkmWkdxrZh2Qy/LsLVe1bvVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sg8J9X/Ppq50XllkM+qy+AVJD+5ONoNHmAjkjTo1JUSkCd9GjswdJ8bTrLPLI/8Tpp0BUTxa1EgZ3SUvu4D2r0tDCEeC72MzP2nEHs0d9pe7zfnDQKKNEn72VEffYs2zXdnDLIzEi9qHdUD10hobMhXjG0zP8TIe61momxMWDWkeyf7fSjdTOqQjSdE4d7WeU5pM3MOSE8ooswGKeM+AMU87D7q0j6SErVE2ff7zeDTuLrlrDBCA9TvZSAjUmKndnG0thMl9jy+yewOnQWDvZTzvOh5xVH7PH5uN4D7tKkserUi2VIy5om/Nx0nWT0xfAtRnqXRpLATLEXHznXEiag==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qo6p7Vya; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1036; helo=mail-pj1-x1036.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qo6p7Vya;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1036; helo=mail-pj1-x1036.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fn48W2j2Dz2xQD
	for <linux-erofs@lists.ozlabs.org>; Fri, 03 Apr 2026 14:34:18 +1100 (AEDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so1223287a91.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 02 Apr 2026 20:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775187256; x=1775792056; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MLJOW2uio0l4V1rabuDMkmWkdxrZh2Qy/LsLVe1bvVs=;
        b=qo6p7Vya+l5TH96jx0GAgEr4B1WHBEUO9mBsl4Tk6zsLHaS79i44nTinXD7SLFB8pc
         AwqoUBCML8rgc3jCS9L49OSwxNKRkCALZSqm5ghDeioSbVZBwrQh9gbnfKmaYpW6BjmR
         tJDEGFR0mRCLNGMuGalIwT9dRq1WXvuGh5Fe15dk0V6kUyfP6kiJ2J+sDXWlOoSjJDYR
         Uef/XMwzkCMmtivHTFP+hVT5ooYH19yNlbl6R8DVoVMn5+8rsncsi2+inxymRTM2qpbh
         FV6qnQmDf8hSYnur1J56OIPjmeHquuX7hKePkQI+CpTjyWjmF3iSPQZsqC04TagHnOFG
         A2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775187256; x=1775792056;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLJOW2uio0l4V1rabuDMkmWkdxrZh2Qy/LsLVe1bvVs=;
        b=cb2CzmRj3kzQ8mfYPoRl3u+ioeFwneRPN35a8YbwdS10lyrsr9rxN9W//Us4KY+++X
         DVuhDYsbhxYHdVyj7FDgN7eApoAfQnbhES+Ku5j4ictbgcD7khMsJV7LjvOSyFeNSZ8l
         nrz+zdDmu1NVhDyTBUbLU5+AULR+v8TYxSpFxISqeCC9WdhYNMyoCHNNRF7cOc0/rFRg
         LelfRmqCnF1SCpkeTGW8O3cKpOrnpxfGv6Es8ueRyVZygZiLxywwgrqL/xDEI8ONsBrA
         D45yXShtrV1OIJFN1c6qwBf/BzDoyWIHBKhs1h5RILKqLfn4citCZQy/FO4CR1/iGPbD
         e5xA==
X-Gm-Message-State: AOJu0YxnH8iVQOmMDSx4AOOpJJr20mgy0eomUAKnlni0Ex6yqjJqTowq
	woeZR/XGGys9wuDKIUKFFTI6rjCyaT0V689rgs74NXzeSx8Sy5XEY+fE
X-Gm-Gg: AeBDievmFQ9hDL07jfPOuAlRIdyUn3RWiJhgIZk47HzvHyrA8uVz/k8lTcxoJujazfN
	wHumnaQUvM/8ToaJQnrxHdrT9RLDCRG/nH6+tc+pa804fnUF3m5ssdVd1nhKE1vFujiqNhZlcAE
	3Ic1ISIHkiPu7ZM09c0VgkQ+JTDsrGujIXnsYOxlcx6HWjV2WZydvJtliK678ken676MXAyk4kN
	+NpMamCjrf6DRmhoh8bkHpAKg2xmn5/s0gI9kHtEFMAtS8b5hqgr2g8/7kXULit8I/iz6v0T/UT
	NK4ZtKhJ8EZuJu156maqe7tLwu2ryUbFBxALvLQC5OAoafIGZusQeS3m9QltWmyTOMZUhwWD023
	At7QzYT+WY608C4ebKAGIaC3Fec0Tu6tSaxFRT/XkwG50A0GxgZ3i3dNhwCw+4L6Mt5BY8xPhRC
	9UqJY9HDWmyowpJ1Phh7I4llMSkHo4f4r3L0cqLRv8odf80Xc=
X-Received: by 2002:a17:90b:5104:b0:35d:9efd:7956 with SMTP id 98e67ed59e1d1-35de6844943mr1470065a91.11.1775187256260;
        Thu, 02 Apr 2026 20:34:16 -0700 (PDT)
Received: from DESKTOP-MOQC9AF.mioffice.cn ([43.224.245.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe95abc3sm10230843a91.15.2026.04.02.20.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 20:34:15 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH] erofs: handle 48-bit blocks/uniaddr for extra devices
Date: Fri,  3 Apr 2026 11:34:09 +0800
Message-ID: <20260403033409.70704-1-zhanxusheng@xiaomi.com>
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

erofs_init_device() only reads blocks_lo and uniaddr_lo from the
on-disk device slot, ignoring blocks_hi and uniaddr_hi that were
introduced alongside the 48-bit block addressing feature.

For the primary device (dif0), erofs_read_superblock() already handles
this correctly by combining blocks_lo with blocks_hi when 48-bit
layout is enabled.  But the same logic was not applied to extra
devices.

With a 48-bit EROFS image using extra devices whose uniaddr or blocks
exceed 32-bit range, the truncated values cause erofs_map_dev() to
compute wrong physical addresses, leading to silent data corruption.

Fix this by reading blocks_hi and uniaddr_hi in erofs_init_device()
when 48-bit layout is enabled, consistent with the primary device
handling.

Fixes: 61ba89b57905 ("erofs: add 48-bit block addressing on-disk support")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
Note: erofs-utils also needs corresponding fixes for the write path
(erofs_mkfs_format_devices) and a swapped hi/lo read in
erofs_read_superblock, which will be sent separately.
---
 fs/erofs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 972a0c82198d..a04e70ef4fcc 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -177,6 +177,10 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 
 	dif->blocks = le32_to_cpu(dis->blocks_lo);
 	dif->uniaddr = le32_to_cpu(dis->uniaddr_lo);
+	if (erofs_sb_has_48bit(sbi)) {
+		dif->blocks |= (u64)le32_to_cpu(dis->blocks_hi) << 32;
+		dif->uniaddr |= (u64)le16_to_cpu(dis->uniaddr_hi) << 32;
+	}
 	sbi->total_blocks += dif->blocks;
 	*pos += EROFS_DEVT_SLOT_SIZE;
 	return 0;
-- 
2.43.0


