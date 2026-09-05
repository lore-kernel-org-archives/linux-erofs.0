Return-Path: <linux-erofs+bounces-4479-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29852C624DB
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Sep 2026 08:45:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hcRk320kgz2ygW;
	Sat, 05 Sep 2026 18:45:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788597931;
	cv=none; b=izuEkxa1V3agvoh9RAjv/ssY/HP+M+zjYmMuP77VIlhbV7HpBIatfp4Qwc81h33qgJowvzHcfW2r4GXJJjji6VDmMQ0ahCVJHTl3LdSRLRijoUvwBB+PMirmaIlZWt6RY4IvJux2iDMQZPv8OISJauEeAiGu9BRS0odty++r49bcOTaEOzSLvirjW4+gdSxBnUywGxSi1eeQu1U5btxbw7lzv9r9iq58sVe1dEa1PO7dogOLaONr9jYgyD5vmDybh5EwKhxgLV3vpElNpfwGzy9uNmURBiKPoLsirk/P8XmIHjnDXA/M3Nwbvm7dC9VymBfqtrCUYFrcE4iRgGusPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788597931; c=relaxed/relaxed;
	bh=RRdpbNuoFopGxQAo+PwRfmXvRKAFbNR0VaX5eXiz7Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DXaaQf+eWpJm5+xRXbkcwjHG3vAeBWMnx/cKJrBxpanO4LUqEg9J4Cdx2YodmmYQdIgYnWaVVaHINS+cnQT9DWWqv/U+xQy5vCLjH2CvlR0fH/I5h/X27iG6GdxLbLfUsHG9uK7wzzlwjMVfdsNmUTVmWOK1AsVEeC9PbE/gXm+ODns6c44/rF93kGdJ1p7lut5mhzsHCa4rt84MqlgklQm4XEDMbTqCoB5TI0PIl+0xaaPLNYuSpnu7iAIOdCiMGvX4F43QZ14DcoTju5tm3NR7b9QgP8qNhGMp+0iiaZZXieFnFzivmByFKAv3uTDiW7Zp2kSyaWGI3Bp0hwU8Bg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=k8yvAdDm; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=k8yvAdDm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hcRk14l44z2ygK
	for <linux-erofs@lists.ozlabs.org>; Sat, 05 Sep 2026 18:45:29 +1000 (AEST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-2cc891373e0so19861115ad.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 05 Sep 2026 01:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788597926; x=1789202726; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RRdpbNuoFopGxQAo+PwRfmXvRKAFbNR0VaX5eXiz7Ac=;
        b=k8yvAdDmIYzMSMq+cRtPewuUT6KbZopAYYKH54+zntYwJALYnxpfYr6K8Ba1SH6oSN
         pCTZxouO7ftgbqXQWEuebwfbart0OAOyhw8Vz3o6AEggZMJGWAYRr67jgigEzpo+xdJd
         vrk5AKj8lFrbhf79EcR34Rpqi6sbuDVgrj2eyB/i8CUTJumEnS58Yo9qZfaBbeVMa+bd
         X2CqLu6NgHlhayZ2wjTRvvxAyjBll3hOKu8gV35IR0ddgrkD6/1u8W8vTTXeKeWzqZMb
         vBlffh/qmM9D6Siz/ulU+Q03djC7vlLQPL/nAxgEpesI2+KZZquOC/706J86AI13Q+Ft
         LHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788597926; x=1789202726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRdpbNuoFopGxQAo+PwRfmXvRKAFbNR0VaX5eXiz7Ac=;
        b=iiexIXb+fu42b2V4N6OG9b8OhoGxDdWD6cYSgWt9uXw1MaXugB9FtH5teFKkPgsOw3
         ddprqwdaa7nW5Tc6gkPidGjSaK5yCUS6fsLHVYY/PSwc8mNDbDp4ZiohZfGrm4jEyKS3
         G/StIVMi5colfURDVe7NY9TmvU7KvNqhbOi1a7ZbDBDrvA1G1bnFeK5C+xbKuKDt2pcV
         xtj1+x5IfMwh701xHhgJzh+14YmdwDPIkCxrC9R5wOz/DIedN1kNNNDbguBU5Oz04EjJ
         FWZWuLQfgbMXJnnPWqxpvUamnV4tMLHMP/bBQjCHZ340EwNEmdZJs2KgNyvhwKWjLab/
         mWuA==
X-Gm-Message-State: AFuF++nHXg/IaIw1FCW1OAUrNSzz42tdXP1x16Pfgl6U5eEibxf/qgvT
	zUl23kF4GTuaGvqGvX/Tg8F370Axyu/YR5T6XxNy37zjri2AX6UrociEz7NZRJh5tag=
X-Gm-Gg: AYBFou1eKJhZ8O7M2A1A+QhQ2q9P39dnUkXGtaqiRzmluQX0qsWvM2lZ1ml8OHPvpB4
	zyJjKnEGONsUjymJyCWwWRJxhbeOwuZklYwIp4k4XnWQCi6a0TN7PJ307SicTzAJ+A8jR5XqLYJ
	qj50GI79PAzsKdI/qAvAxSKL5ECz9ArJAIxaxi1j/YLpYKxYQB5AxhpO96aR5KZbfCj9ZRMpget
	dz1ZvIbygWBmCajkfJby8WR1Kx0VpUVIaM2TYf8Zk5IE6YNf/dL1RW4IpYoJCRY4RZ0c/oFFAbx
	6+s0AqBavQBDRtoTQND8MP2H/pWpugogZOfTj31pDkEfahonbF1Qa0AjQf33MD9VEqD25fP9D7D
	YsW5NbQJ03iBAURwsGtA/T70GFOtRflzw7MORNQME9D/aNgYCYilJrJNbD/ktYTE3YUWNSu2iLP
	XsiKo74NLqvucIQxxlEU4jvmPW/YIAdMvkri51t5j8gGnehF2pkaSpuEperTUDjPQg6IrIvf3/8
	a+GeRD56zmZ9TpvYu7dpTAeutpAy3iVS2LDgZc=
X-Received: by 2002:a17:903:1aec:b0:2d9:6db:9fcb with SMTP id d9443c01a7336-2db125ca3bbmr165244765ad.11.1788597925143;
        Sat, 05 Sep 2026 01:45:25 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db24ccb4a3sm10868435ad.36.2026.09.05.01.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 01:45:24 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH] erofs-utils: mkfs: fix blobdev with metadata zones
Date: Sat,  5 Sep 2026 16:45:20 +0800
Message-ID: <20260905084520.861790-1-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Using --blobdev with --MZ flushes flat inodes before unified device
addresses are assigned, leaving their data addresses unresolved.

Reserve metadata zone space before calculating device addresses, then
flush the zone once those addresses are available.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/importer.c         |  7 ++++++-
 lib/liberofs_metabox.h |  1 +
 lib/metabox.c          | 42 ++++++++++++++++++++++++------------------
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/lib/importer.c b/lib/importer.c
index 89d4d8b..4506040 100644
--- a/lib/importer.c
+++ b/lib/importer.c
@@ -120,7 +120,8 @@ int erofs_importer_flush_all(struct erofs_importer *im)
 	if (err)
 		return err;
 
-	err = erofs_metazone_flush(sbi);
+	/* Include the metadata zone before assigning unified device addresses. */
+	err = erofs_metazone_reserve(sbi);
 	if (err)
 		return err;
 
@@ -132,6 +133,10 @@ int erofs_importer_flush_all(struct erofs_importer *im)
 	if (err)
 		return err;
 
+	err = erofs_metazone_flush(sbi);
+	if (err)
+		return err;
+
 	err = erofs_write_device_table(sbi);
 	if (err)
 		return err;
diff --git a/lib/liberofs_metabox.h b/lib/liberofs_metabox.h
index f966c20..156b651 100644
--- a/lib/liberofs_metabox.h
+++ b/lib/liberofs_metabox.h
@@ -25,6 +25,7 @@ void erofs_metadata_exit(struct erofs_sb_info *sbi);
 int erofs_metadata_init(struct erofs_sb_info *sbi);
 struct erofs_bufmgr *erofs_metadata_bmgr(struct erofs_sb_info *sbi, bool mbox);
 int erofs_metabox_iflush(struct erofs_importer *im);
+int erofs_metazone_reserve(struct erofs_sb_info *sbi);
 int erofs_metazone_flush(struct erofs_sb_info *sbi);
 
 #endif
diff --git a/lib/metabox.c b/lib/metabox.c
index 5c2eada..4750b36 100644
--- a/lib/metabox.c
+++ b/lib/metabox.c
@@ -117,18 +117,16 @@ int erofs_metabox_iflush(struct erofs_importer *im)
 	return 0;
 }
 
-int erofs_metazone_flush(struct erofs_sb_info *sbi)
+int erofs_metazone_reserve(struct erofs_sb_info *sbi)
 {
 	struct erofs_metamgr *m2gr = sbi->m2gr;
 	struct erofs_buffer_head *bh;
-	struct erofs_bufmgr *m2bgr;
-	erofs_blk_t meta_blkaddr;
 	u64 length, pos_out;
-	int ret, count;
 
 	if (!m2gr)
 		return 0;
-	bh = erofs_balloc(sbi->bmgr, DATA, 0, 0);
+	length = erofs_pos(sbi, erofs_mapbh(m2gr->bmgr, NULL));
+	bh = erofs_balloc(sbi->bmgr, DATA, length, 0);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	erofs_mapbh(NULL, bh->block);
@@ -137,29 +135,37 @@ int erofs_metazone_flush(struct erofs_sb_info *sbi)
 		erofs_bdrop(bh, true);
 		return -EFAULT;
 	}
-	meta_blkaddr = pos_out >> sbi->blkszbits;
-	sbi->metazone_startblk = meta_blkaddr;
+	sbi->metazone_startblk = pos_out >> sbi->blkszbits;
+	/* Keep the mapped space; its contents will be copied after inode flush. */
+	erofs_bdrop(bh, false);
+	return 0;
+}
 
-	m2bgr = m2gr->bmgr;
-	ret = erofs_bflush(m2bgr, NULL);
-	if (ret)
-		return ret;
+int erofs_metazone_flush(struct erofs_sb_info *sbi)
+{
+	struct erofs_metamgr *m2gr = sbi->m2gr;
+	u64 length, pos_out;
+	int ret, count;
 
-	length = erofs_mapbh(m2bgr, NULL) << sbi->blkszbits;
-	ret = erofs_bh_balloon(bh, length);
-	if (ret < 0)
+	if (!m2gr)
+		return 0;
+	if (sbi->metazone_startblk == EROFS_META_NEW_ADDR)
+		return -EINVAL;
+
+	ret = erofs_bflush(m2gr->bmgr, NULL);
+	if (ret)
 		return ret;
 
+	length = erofs_pos(sbi, erofs_mapbh(m2gr->bmgr, NULL));
+	pos_out = erofs_pos(sbi, sbi->metazone_startblk);
 	do {
 		count = min_t(erofs_off_t, length, INT_MAX);
 		ret = erofs_io_xcopy(sbi->bmgr->vf, (off_t)pos_out,
 				     &m2gr->vf, count, false);
 		if (ret < 0)
-			break;
+			return ret;
 		pos_out += count;
 	} while (length -= count);
-	bh->op = &erofs_drop_directly_bhops;
-	erofs_bdrop(bh, false);
-	sbi->meta_blkaddr += meta_blkaddr;
+	sbi->meta_blkaddr += sbi->metazone_startblk;
 	return 0;
 }
-- 
2.55.0


