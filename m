Return-Path: <linux-erofs+bounces-4727-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76319CA9ED2
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 08:35:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3nj05kx4z3bqh;
	Tue, 13 Oct 2026 19:35:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::630"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791880532;
	cv=none; b=iC3NudhOTQDHG3nhpNoktR7Wz503FI3Jjbdpao9HeXrvcUgpDnxKECArrAkLREUmJb8L/fEEz7JEWQsWbXk/VoBZ/WJJ0acArUKFY25hbIujo3lgnPUjlowdOs2gYhMeYky/R2Z1puuuIG0UNW5SC2ILyaUTL8x5oj9TNE++BY3f04jtI5eJRD0cvF3rWiw1iFmtWZ0zx8+BZy1BQst2N193zDCMdQis2Cln8f7LjKPXPT1Rf96oYyXU6EdMOVP1nj50lEaL87B+m1OX07B9GfkDlJN8MLWPmiWn7zH/OkS7dcFeAH0UTJxSfJfD3pFha/RfmEVKab/3pWA21O1uLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791880532; c=relaxed/relaxed;
	bh=sLU/3bwE6c2wqlZD7EqyDF4UZUsoHZIKWfxxEhj/K04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KPTXeBpgofetFKNNOaStO0ycl5LWvD5i2HUKicKnniuhvfnW1ZU9bShwirKN0SUmhPbEL5k/0KByp7yQrAUR1ZELW/bWYbTiO3Ez9i1ryT459gqySaUpMIUqDD0pILQ13vssyYvg27IjeH4wE0vOnmxGtCnAiTEpFt1bKjvTJXWVWmd48fampaCZs6bRuaQp3HTqDsbJGTzodzD9YotnUPh26RZqfKn2SMn5/Mcnz7wtMvdH9+PtywtU1XRWTepPh5fu0dAisjlB/jO8QEN0IuG/RQ8w0dbE4hTe5qT14hem1HpNRcRCOocbrwuakpL+LUgv9RwDl0LYEXT5iESr5A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ryP8acTh; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ryP8acTh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3nhz1Jyfz3bgK
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 19:35:29 +1100 (AEDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-2e623eda81cso15661345ad.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791880527; x=1792485327; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sLU/3bwE6c2wqlZD7EqyDF4UZUsoHZIKWfxxEhj/K04=;
        b=ryP8acThM37UsrtZDk9plfasL8+mF/hYY8v9KfIutj1o/LPmSCfGVBlLynt6LKkHV1
         peYr/sjL5AchXvtmXRsQuiPuvEMqhWSa3EzNZsjjXhGOSIKJkfkfSmRFsxVK6q0Ll4X8
         F15OYmZeazmR+8Z0Z03ShVtQkw/55O2cIM0vPoH+cxFLvJUobiyuNKYfilXe7mb9eQ/X
         /lPZIsuujlpAfcmwGL9m2m3kKnzlDx5p/DOuhxlr446sXfnpGSvNAH9Vj7zvleAxSeso
         KqvZJdFlxTXZ5gPKSO2rO76i1rXGHBBrnwSCUBMKo8gXmUm28vAQrerzCshGsuU9JWa5
         l9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791880527; x=1792485327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sLU/3bwE6c2wqlZD7EqyDF4UZUsoHZIKWfxxEhj/K04=;
        b=zGgMEb88hw34+kEIErj8oC53G0AIhiPDMQTzig52AxGxAWYDG64cegNpIK0xavJXxs
         g5YJt/BzF5Hpiq0oYfWQwD3LACmt2Tknep2BvSnb77MQACp/QV8Bkjpa9OG0IZj99R7Z
         7yytmQwCOJdAffKNg5vGqlGDCFvr685Gze/FUEdBh3ATiNulVpri2eD1OGD4TYgalRGF
         cx6mHKCj15b3T3LGBjiivzkkQaJQyH0pUIajqJzHRZJHjtonw9tz0zbvm90PbQeTq7On
         uI0utJPpJTNmEow5skolD2FxQ7ZqP4VDmjaPlvYCcH0rDkTC3EjGLg9X1T848omM7SK0
         6MoQ==
X-Gm-Message-State: AFq9FYIAmlZId/RcqrDsrNsu+eEYjYStJwRmUfnO6/H8K1SPIxgUj0A7
	JJr3G5tzXU7H+wULgXS0KS6cMBnc71JSiaOuhqf5YolBGalUbmPrIDD6msqhv3Gifdw=
X-Gm-Gg: AYBFou09cc54jjgiNzJVxzeyowXCg+S2mHHifrlp8PnHtsSNTZqYsOOWUV/iknSNuoN
	k6C6YtkDXk7kGg75MGa2EPFYocjazPCtW9z2xig9D2V268UscU6hgOqcVtWW17QehAYme6XH4wU
	oK4G3OR0vCOnPMgzYiyuivrpUI0imL2i0JZdma2pDDQr2KB94gNDEoQ/G9ixVM4zaecKBdPyisx
	bPy+U4Y97kbfs+zxNLzFKRc8eMf4adTbLlq2qXCS702esxpn0FpWPS5FNUqxVW4vGHx/LOFsOxC
	BblbVIDU7DtR0toUDP59Sgceo+rrQ6k6MCHa/v0hcdxYeytb/l7CPUq4LIEVeU7y/1/bvlEDg1I
	p7yq0xB5MKj3GfzA3Ica/Xgcur9eKTzc14YrtGvr6LlrTAtEp3DW6MRNpvvcF4T5/oFJY8EahB/
	G1nOgVN/fWJlq2jF8+OZk9WEQjRkSubODJV+TpKBMM/XKJmdXitK1Ced3ZotVXCK8+nWEFrVzno
	OA+NmHYzBTyhmLkLpc6YDKCGOLYVILNzSAFPRSs1/9m/Wp9ew==
X-Received: by 2002:a17:90b:55cb:b0:3ac:403d:6239 with SMTP id 98e67ed59e1d1-3ac403d6baamr1022405a91.43.1791880526658;
        Tue, 13 Oct 2026 01:35:26 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([2406:da16:fb5:6000:18dd:9662:938a:f20c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36fdc75esm20669441a91.12.2026.10.13.01.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:35:26 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH] erofs-utils: lib: fix reads for chunk-based files
Date: Tue, 13 Oct 2026 16:35:17 +0800
Message-ID: <20261013083517.2435363-1-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Use erofs_io_read() to handle chunk read errors and short reads while
retrying EINTR without corrupting the buffer position.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/blobchunk.c | 9 ++++++---
 lib/io.c        | 5 +++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 8f43dd0..50e4f7e 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -325,6 +325,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 				  erofs_off_t startoff, int device_id)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
+	struct erofs_vfile vf = { .fd = fd };
 	unsigned int chunkbits = inode->u.chunkbits;
 	unsigned int count, unit;
 	struct erofs_chunkitem *chunk, *lastch;
@@ -332,7 +333,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 	erofs_off_t pos, len, chunksize, interval_start;
 	erofs_blk_t minextblks;
 	u8 *chunkdata;
-	int ret;
+	ssize_t ret;
 
 	/* if the file is fully sparsed, use one big chunk instead */
 	if (lseek(fd, startoff, SEEK_DATA) < 0 && errno == ENXIO) {
@@ -407,8 +408,10 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 		}
 
 		len = min_t(u64, inode->i_size - pos, chunksize);
-		ret = read(fd, chunkdata, len);
-		if (ret < len) {
+		ret = erofs_io_read(&vf, chunkdata, len);
+		if (ret < 0)
+			goto err;
+		if (ret != len) {
 			ret = -EIO;
 			goto err;
 		}
diff --git a/lib/io.c b/lib/io.c
index 193b869..3333170 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -551,11 +551,12 @@ ssize_t erofs_io_read(struct erofs_vfile *vf, void *buf, size_t bytes)
 					  strerror(errno));
 				return -errno;
 			}
+			continue;
 		}
 		bytes -= ret;
 		i += ret;
-        }
-        return i;
+	}
+	return i;
 }
 
 ssize_t erofs_io_write(struct erofs_vfile *vf, void *buf, size_t len)
-- 
2.56.0


