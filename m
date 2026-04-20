Return-Path: <linux-erofs+bounces-3334-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F8FF557FE
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Apr 2026 10:11:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fzh9T6zwPz2yqT;
	Mon, 20 Apr 2026 20:11:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776679917;
	cv=none; b=im5vFudART2oh2ljmItalrKPkqYr1r1wO+rIOhsxb7khKrX8W1Azk8uicYFLHf6MT9in3oo9vvihDZXWmOpr7dPDXklM2WWJQr0V6c9UIaNnIGOw8El9d1ggTlzeAWHTZnobFlznbFUHIrA2y3gQAkWcZrHhig9INMsjmkDZNpTjS1p5reUfNZ351p6YKrDKoO4dOLv1VoSLox44qKUOGziq6wkBdmZ0phZezl7BGou1VvB2TlBiNX0NyWNn7GOF52MLYzV/x1j7FrE2eU8klOo+C/ES8Mv0htYmxxPFbfU2x2LET9/SjrCM7ZJrY9TSH4KP4HPY/Sspp5q0Z46y3g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776679917; c=relaxed/relaxed;
	bh=q1mLRfj46AfSk/H+1p54oLfcyRecT0auHAGSov+MSSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nyy1uyyK3OG5CH58690EVJRWAJHantC697L+bKax8yTCAI0uIImIZtlmCBdCS8XlRWo6Va2oLxOFyiDLnc2WtG519+r0JBDRDorLOyHiJDaUEvVdY5/+tS6puNUSmxH3D3vIeyYWQzjO4QqMWfNg9KBdBbjbv9pPlviTBgTqNBb21BaPgvtXDHr/Vlu7QuL6X3xttQ+twLD8jg2dMbPeWYBwTwsRcB0ZVUGsUAlDfjmVGWCDCgAFjeKdK8IeHBDU1TsBeBt+eFHRXWqDetzI+w4L6x8aEyJb+LBd0q+8dhXx3x7L7MED49GXkjzO22P5tvnoSZvmzKtyrp0pYvk8xA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ipg/rMkV; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ipg/rMkV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fzh9R2lSfz2ynn
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Apr 2026 20:11:52 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776679908; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=q1mLRfj46AfSk/H+1p54oLfcyRecT0auHAGSov+MSSk=;
	b=Ipg/rMkVqj89PPgNP9RaRjAeaD3llhuCMtYVjkIOFHkw0o/sffyfNvPeYEOelfxaB3W/7aQ2w4hNdM9aceGI83kNOB2R92DqWRHOj7UfUcpdRdQt+h/T4wLjs9S1H+UIoQvwJmYaAJLAG5zF4YS9hKWs0aXQn8X01elVMtPhZ8c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X1KSTIw_1776679903;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1KSTIw_1776679903 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 18:11:47 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs: unify lcn as u64 for 32-bit platforms
Date: Mon, 20 Apr 2026 18:11:42 +0800
Message-ID: <20260420101142.2440026-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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

As sashiko reported [1], `lcn` was typed as `unsigned long` (or
`unsigned int` sometimes), which is only 32 bits wide on 32-bit
platforms, which causes `(lcn << lclusterbits)` to be truncated
at 4 GiB.

In order to consolidate the logic, just use `u64` consistently
around the codebase.

[1] https://sashiko.dev/r/20260420034612.1899973-1-hsiangkao%40linux.alibaba.com

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zmap.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 30775502b56d..abf7ddc64c63 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -10,7 +10,7 @@
 struct z_erofs_maprecorder {
 	struct inode *inode;
 	struct erofs_map_blocks *map;
-	unsigned long lcn;
+	u64 lcn;
 	/* compression extent information gathered */
 	u8  type, headtype;
 	u16 clusterofs;
@@ -20,8 +20,7 @@ struct z_erofs_maprecorder {
 	bool partialref, in_mbox;
 };
 
-static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
-				      unsigned long lcn)
+static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m, u64 lcn)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -94,7 +93,7 @@ static int get_compacted_la_distance(unsigned int lobits,
 }
 
 static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
-					 unsigned long lcn, bool lookahead)
+					 u64 lcn, bool lookahead)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -234,7 +233,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 }
 
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
-					   unsigned int lcn, bool lookahead)
+					   u64 lcn, bool lookahead)
 {
 	struct erofs_inode *vi = EROFS_I(m->inode);
 	int err;
@@ -249,7 +248,7 @@ static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 		return err;
 
 	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
-		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
+		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %llu of nid %llu",
 			  m->type, lcn, EROFS_I(m->inode)->nid);
 		DBG_BUGON(1);
 		return -EOPNOTSUPP;
@@ -269,7 +268,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 	const unsigned int lclusterbits = vi->z_lclusterbits;
 
 	while (m->lcn >= lookback_distance) {
-		unsigned long lcn = m->lcn - lookback_distance;
+		u64 lcn = m->lcn - lookback_distance;
 		int err;
 
 		if (!lookback_distance)
@@ -286,7 +285,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 		m->map->m_la = (lcn << lclusterbits) | m->clusterofs;
 		return 0;
 	}
-	erofs_err(sb, "bogus lookback distance %u @ lcn %lu of nid %llu",
+	erofs_err(sb, "bogus lookback distance %u @ lcn %llu of nid %llu",
 		  lookback_distance, m->lcn, vi->nid);
 	DBG_BUGON(1);
 	return -EFSCORRUPTED;
@@ -300,7 +299,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	struct erofs_inode *vi = EROFS_I(inode);
 	bool bigpcl1 = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
 	bool bigpcl2 = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_2;
-	unsigned long lcn = m->lcn + 1;
+	u64 lcn = m->lcn + 1;
 	int err;
 
 	DBG_BUGON(m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD);
@@ -331,7 +330,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 		  m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD);
 
 	if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD && m->delta[0] != 1) {
-		erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
+		erofs_err(sb, "bogus CBLKCNT @ lcn %llu of nid %llu", lcn, vi->nid);
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
 	}
-- 
2.43.5


