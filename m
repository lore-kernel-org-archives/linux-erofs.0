Return-Path: <linux-erofs+bounces-2523-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718B8F47CA9
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Mar 2026 18:13:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fRd2k4Zb8z3c5y;
	Fri, 06 Mar 2026 05:13:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::536"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772734430;
	cv=none; b=BHsjd7fyusSVnBlklKXfVJC6fvllWfX2R6fKs/+Pax7r8u9eDg56RRi9jFoG8BQ40+xegbTM4yyu1nJRRiL6h0K9LpcTG5JSP5sy3jc4yypBcbDAlfmOKEad5uIYKaM4IDu3gaXLqY+a6NZfmFPD/INJhupMpgHRR39qMsxFH4C6x+xaUOcW3PyPO7orrZsOlpdhQGRie6NG7BW8ZhwoiGWk6hsg6pfIozxdlN+gr/BT1zrlhp52+EVUX38gyvg1DUVCay79u2nl0OTSoKr0BPWBv00E03N/VGFszPtOLl3Zz95h/6pdkIMq3NGEGf+OUyWIzlo0WWGuB4BiuH1aWg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772734430; c=relaxed/relaxed;
	bh=iUT77A8bZwmqp8DK7vi7T5rdZZs+EbpQDSHCKghSAY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XNUwyJjt+j+zRQ366SGNraCbWR/zLtJZ599fZ2VOZdK+S97ehgQL3bpN7S8VhsiW2quCt0a6aa5k3oyYKkMzqzvCo9ww5EmW8ByBk/bKKuqZ+E5mfR+2y7iCPGo3WWfIVwXIslDN0laQyQaO5OVrTUVWhbnduWrZyJlPLp5m6NbGDilrdWimp4xrnDmdwZwwLqrb/u3zeeo5clyB15MQOXIsaGjI8lNT0e5c3BNsEpMSOhD/yQO5zDvVqyHoFL9RtnxeKJ6sJM5bKti/BmGIubL3o5SIWQuvJ3PvG8D0jlQRhyxIu/O2mDcHINYwNOlAWLoUvfqN/7R49oJxWdjZaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=Oho2M1x2; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::536; helo=mail-pg1-x536.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=Oho2M1x2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::536; helo=mail-pg1-x536.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fRd2j3gd0z3bhG
	for <linux-erofs@lists.ozlabs.org>; Fri, 06 Mar 2026 05:13:48 +1100 (AEDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-c6de5ea6879so244321a12.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 05 Mar 2026 10:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772734426; x=1773339226; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iUT77A8bZwmqp8DK7vi7T5rdZZs+EbpQDSHCKghSAY4=;
        b=Oho2M1x2eBkUg6AID5UtaFW7PMksGVVvkTxRuRpVIM3rCsfnHEcdrS/ZO84fixbbJY
         rV0/GqC78HiOsQvMGA6FYCjrGiq0hx1nFblWnW5WPp9P1OggDc3DXzByLeTYiTs+L2Wz
         j0hUBK0f+sl6BneZBBYWzmtj6cAPpL/tTgR/1MCZoIjITKlbaVaPVFdRgrbe1RrEx+6U
         Fs0YCFGt0SSGnREYhK22X2fsmJPEQ8+NoV4aY6s3TEZDwpBKyWYhH3pNfFIQ1J1qxdqx
         8dya/06K6W7arX9mRc36EzAJNwITqwfIWIQhtJtNlynsta0qBny006IOFSsN6DSWaVms
         72ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772734426; x=1773339226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUT77A8bZwmqp8DK7vi7T5rdZZs+EbpQDSHCKghSAY4=;
        b=gSR951rxlDWFBQ6PXs01mhokbfc8G5zOtl+c2bjYIyAtQxETQ/DpPcU/8BR+pEW1L9
         35fdSaMA8lC7Vj49i24mbpEV8Y2zaKNw8Zy6OD666AsyhyQCBNy3PQpUHXQrhyke3wWg
         cO1Ub6g+HZUsZZ6z9C8+lrGm23bSsucf40fJmZXD93ew9/A47rKAz8zOV2kRj38NHVrK
         qLPE+jrr/E8yF60UXve0QjxY5gXUBH6E3/kIkUH1LI43HwyPTCNf/ABzksHDktTxuo8m
         HFha0SrDqMIUQRMf3YS5xQCc84SWU6oVzEwrX7OkaHdJeGKdy+YHk80dPf8/a5U6bqcN
         U+TA==
X-Gm-Message-State: AOJu0YwlwEftZQZSLFsvgq/jlCkl69U3iM3Z41XQLZe04Q2CEJMBbEqV
	FrFKGeS9bZiuGmFaCNR2orpzmy3L9PoVcp4eNyGWAbiDCz63TL74cGl7Zj+hDI6b
X-Gm-Gg: ATEYQzxJmBSvDxeF5eq4OrzFN/yxvrKhU+HUVsaMUgcl6Bf0iRotXKNt9ZiZvmb6pAb
	/GWA3WnkyPcNAfOMmfLa85BDeKazUoJWUHp1zR+k8dykRrxq32Ro1T9R/UIalD2lffVSsJMACjL
	0DKAu5h8WFmxDKypj76Cnv53of+sWTB9minE5Tas/lDhdKTrI1U2uzDg8DV+wgpTeZLDqx4MsmJ
	HKemRClg7POmQuWCp5+jPVhlkiTuEL35N+2NSZOwyvdOb50q/qcV1Ye/jjQ+DnbRUNjzh76FemN
	bi9mqgaXb65iC/VHkna4KYWaGmAOG/P8sYwAoEEcMH/EWRK38BJPuHPHCvNSDooAettqdCjDdmR
	jatnraGAzqFzSR/yYoDb2YrV7HCk5xbLcezxKP596LbTXsZCEBNq+CdW+QXuZaeH1/bxO4WPn4m
	MQXJtRanJjWCDPgXmdH8aR1nHV/PvbtK/USn5llxfOv9huPwEbZEbokg4ohDUO94c3Bw+V7EbJT
	PMBKH9HqBPdAuYZjZVtkDe+SoDGb/QHOo/c6OYdS2x4k7mA
X-Received: by 2002:a17:903:18d4:b0:2ae:7edc:9234 with SMTP id d9443c01a7336-2ae7edc94femr4629585ad.1.1772734425584;
        Thu, 05 Mar 2026 10:13:45 -0800 (PST)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae51bb9da6sm119930125ad.36.2026.03.05.10.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 10:13:45 -0800 (PST)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib: fix potential shift UB in z_erofs lclusterbits handling
Date: Thu,  5 Mar 2026 18:13:39 +0000
Message-ID: <20260305181339.28042-1-singhutkal015@gmail.com>
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

z_lclusterbits is computed from on-disk h_clusterbits without an upper
bound check: blkszbits + (h_clusterbits & 15). While blkszbits is
validated in erofs_read_superblock(), EROFS_MAX_BLOCK_SIZE can be
overridden at compile time (e.g. 64K pages on ARM64), making
blkszbits up to 16 and z_lclusterbits up to 31.

Several places in z_erofs_map_blocks_ext() and related functions use
'1 << lclusterbits' where the literal 1 has type int (32-bit signed).
Per C11 6.5.7p4, left-shifting a signed positive value such that the
result is not representable is undefined behavior.

Fix this by:
 - Adding a validation check rejecting z_lclusterbits > 30 as
   filesystem corruption, since no valid EROFS image uses logical
   clusters larger than 1 GiB.
 - Changing all '1 << lclusterbits' to '1U << lclusterbits' to
   use unsigned arithmetic, matching the kernel EROFS driver style.

This hardens the z_erofs metadata parsing path against crafted images.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/zmap.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/lib/zmap.c b/lib/zmap.c
index 0e7af4e..42e982d 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -45,7 +45,7 @@ static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
 	advise = le16_to_cpu(di->di_advise);
 	m->type = advise & Z_EROFS_LI_LCLUSTER_TYPE_MASK;
 	if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
-		m->clusterofs = 1 << vi->z_lclusterbits;
+		m->clusterofs = 1U << vi->z_lclusterbits;
 		m->delta[0] = le16_to_cpu(di->di_u.delta[0]);
 		if (m->delta[0] & Z_EROFS_LI_D0_CBLKCNT) {
 			if (!(vi->z_advise & (Z_EROFS_ADVISE_BIG_PCLUSTER_1 |
@@ -60,7 +60,7 @@ static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
 	} else {
 		m->partialref = !!(advise & Z_EROFS_LI_PARTIAL_REF);
 		m->clusterofs = le16_to_cpu(di->di_clusterofs);
-		if (m->clusterofs >= 1 << vi->z_lclusterbits) {
+		if (m->clusterofs >= 1U << vi->z_lclusterbits) {
 			DBG_BUGON(1);
 			return -EFSCORRUPTED;
 		}
@@ -168,7 +168,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 	lo = decode_compactedbits(lobits, in, encodebits * i, &type);
 	m->type = type;
 	if (type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
-		m->clusterofs = 1 << lclusterbits;
+		m->clusterofs = 1U << lclusterbits;
 
 		/* figure out lookahead_distance: delta[1] if needed */
 		if (lookahead)
@@ -423,7 +423,7 @@ static int z_erofs_map_blocks_fo(struct erofs_inode *vi,
 		return 0;
 	}
 	initial_lcn = ofs >> lclusterbits;
-	endoff = ofs & ((1 << lclusterbits) - 1);
+	endoff = ofs & ((1U << lclusterbits) - 1);
 
 	err = z_erofs_load_lcluster_from_disk(&m, initial_lcn, false);
 	if (err)
@@ -561,12 +561,12 @@ static int z_erofs_map_blocks_ext(struct erofs_inode *vi,
 			pos += sizeof(__le64);
 			lstart = 0;
 		} else {
-			lstart = round_down(map->m_la, 1 << vi->z_lclusterbits);
+			lstart = round_down(map->m_la, 1U << vi->z_lclusterbits);
 			pos += (lstart >> vi->z_lclusterbits) * recsz;
 			pa = EROFS_NULL_ADDR;
 		}
 
-		for (; lstart <= map->m_la; lstart += 1 << vi->z_lclusterbits) {
+		for (; lstart <= map->m_la; lstart += 1U << vi->z_lclusterbits) {
 			ext = erofs_read_metabuf(&map->buf, sbi, pos, in_mbox);
 			if (IS_ERR(ext))
 				return PTR_ERR(ext);
@@ -579,9 +579,9 @@ static int z_erofs_map_blocks_ext(struct erofs_inode *vi,
 			}
 			pos += recsz;
 		}
-		last = (lstart >= round_up(lend, 1 << vi->z_lclusterbits));
+		last = (lstart >= round_up(lend, 1U << vi->z_lclusterbits));
 		lend = min(lstart, lend);
-		lstart -= 1 << vi->z_lclusterbits;
+		lstart -= 1U << vi->z_lclusterbits;
 	} else {
 		lstart = lend;
 		for (l = 0, r = vi->z_extents; l < r; ) {
@@ -673,6 +673,13 @@ static int z_erofs_fill_inode_lazy(struct erofs_inode *vi)
 
 	vi->z_advise = le16_to_cpu(h->h_advise);
 	vi->z_lclusterbits = sbi->blkszbits + (h->h_clusterbits & 15);
+
+	if (vi->z_lclusterbits > 30) {
+		erofs_err("invalid lclusterbits %u of nid %llu",
+			  vi->z_lclusterbits, vi->nid | 0ULL);
+		err = -EFSCORRUPTED;
+		goto out_put_metabuf;
+	}
 	if (vi->datalayout == EROFS_INODE_COMPRESSED_FULL &&
 	    (vi->z_advise & Z_EROFS_ADVISE_EXTENTS)) {
 		vi->z_extents = le32_to_cpu(h->h_extents_lo) |
-- 
2.43.0


