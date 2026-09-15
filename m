Return-Path: <linux-erofs+bounces-4562-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB43EC88E53
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Sep 2026 06:22:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hkX4m3Q7qz2yhD;
	Tue, 15 Sep 2026 16:22:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789453368;
	cv=none; b=XIXnsAX/EI82zV7KzpUryxSFl0JQIfPHOqMwqxLVZeZ8mhvyfTz4Bo8tU4m/FDsRFOiXE4MqvGRLbYKUxQYryTBDagjtwds3EqwFQ5WegpWriHJ97zn5t0XwuHcCV3A+ZtfbYOI8pekJEafdS2t6eOEioJJ/ue/fBviEMkVmPfkscvSevHNddvfR3NQ+mEImK7QDeiK5zBCuEA81rDLZZGCSvRzd+QOaUHgLUM8QPknxyNukpuK6j5PAMlQnOkhcwonGpz/PPzQ9J0aP8LaEBzzpRyDZKVA0x5kCFc4654NubwGBOgDqKhXKKNq6fGiBucUHRFcU52p+oWJ8qOCm7g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789453368; c=relaxed/relaxed;
	bh=snyA65R5P1SYRXEf1agThcp57P9/AzUVdJPP2ReyZzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUT3qxe8//CXKBIo1adapJK3dmdWdoq1S0TYofzyDqo+qr3Wg2Z+Yk9umUxR0kJUcEeWn1bdqzzmkWVIZJLFGuvfhFATSevyKCXQPRK48AgZ2TlqQWavRVFMReEVFWJ23OvAV3ZTJA3d89qHyYRsYzbXgmDuza1xPszTgsIb2ZBZCM/M7UHHXxC7CG4ALV00Pt1lSrRUsFbWoyyvBz2dQkQVMjAFzk7zwUSu4M7IHvZDXF9BlPKCsZxpQt77XAfbzm/1X/+V3x1HTy+tlMJZuTqDAf96xK//lsNta9gZJwgV/16N17e4Ao+kKDj5n70LBvJkhqFmPiwpuw6jQM/PZg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AbHQTEvL; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AbHQTEvL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hkX4l4PTwz2yFW
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Sep 2026 16:22:47 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96C34600D1
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Sep 2026 06:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA4A1F000FF;
	Tue, 15 Sep 2026 06:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789453364;
	bh=snyA65R5P1SYRXEf1agThcp57P9/AzUVdJPP2ReyZzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbHQTEvLsDgezwqJEZ2RtBc/bz25ksu/ejXBPPsINF4YuMqXfsf7+v3ugoAxjM70t
	 C9OpBbgQqoTOBg/A7cJPc2doeEeUAM6858DFKj1gmXKqODE1RdstLpe/KwHEzXsI3Y
	 HmMUnSCKqbwvRKDNPnHOMXf3v34xOFcgTM8kkqDquPMXM2J2SzveKMmRYsLKaeZ2rx
	 w6QRLZ7qYSiQFidhPU2O9ZZOODup5j925mdZ1vHFNbM6kJ39M3BXIDDpXFJ0qOz9kb
	 WdHswhCR80B70rgE0zepuFXj9tbDtecCXxCCypTAG49XD/z1XZcfqgpPwPb6fye1ac
	 Pubyp2XHIrSbw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2 2/4] erofs-utils: lib: improve ztailinline fallback
Date: Tue, 15 Sep 2026 14:21:37 +0800
Message-ID: <20260915062139.54810-2-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915062139.54810-1-xiang@kernel.org>
References: <20260915062139.54810-1-xiang@kernel.org>
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

Currently, on-disk metadata is dumped in the end,so there is no need
to limit the ztailinline fallback to the last lcluster since we could
adjust the last in-memory extents.

Drop `eof_tailraw` and decompress the inline data instead when
falling back.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/internal.h |  4 ---
 lib/compress.c           | 56 +++++++++++++++++++++++++++-------------
 lib/inode.c              | 10 ++++---
 lib/liberofs_compress.h  |  2 +-
 4 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 3ca5553..d905077 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -285,10 +285,6 @@ struct erofs_inode {
 
 	void *idata;
 
-	/* (ztailpacking) in order to recover uncompressed EOF data */
-	void *eof_tailraw;
-	unsigned int eof_tailrawsize;
-
 	union {
 		void *chunkindexes;
 		struct {
diff --git a/lib/compress.c b/lib/compress.c
index 3e8f9b6..ef79eaa 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -26,6 +26,7 @@
 #include "liberofs_compress.h"
 #include "liberofs_fragments.h"
 #include "liberofs_metabox.h"
+#include "erofs/decompress.h"
 
 #define Z_EROFS_DESTBUF_SZ	(Z_EROFS_PCLUSTER_MAX_SIZE + EROFS_MAX_BLOCK_SIZE * 2)
 
@@ -688,15 +689,6 @@ frag_packing:
 		ictx->fragemitted = true;
 	/* tailpcluster should be less than 1 block */
 	} else if (may_inline && len == e->length && compressedsize < blksz) {
-		if (ctx->clusterofs + len <= blksz) {
-			inode->eof_tailraw = malloc(len);
-			if (!inode->eof_tailraw)
-				return -ENOMEM;
-
-			memcpy(inode->eof_tailraw, ctx->queue + ctx->head, len);
-			inode->eof_tailrawsize = len;
-		}
-
 		ret = z_erofs_fill_inline_data(inode, dst,
 				compressedsize, false);
 		if (ret < 0)
@@ -1267,25 +1259,53 @@ static void z_erofs_write_extents(struct erofs_inode *inode,
 	DBG_BUGON(metacur - metabuf != inode->extent_isize);
 }
 
-void z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
+int z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
 {
+	struct erofs_sb_info *sbi = inode->sbi;
 	struct z_erofs_metadata_ctx *ctx = inode->compressmeta;
 	struct z_erofs_extent_item *ei;
+	char raw[EROFS_MAX_BLOCK_SIZE];
+	unsigned int rawsz, encsz;
+	int err;
 
 	inode->z_advise &= ~Z_EROFS_ADVISE_INLINE_PCLUSTER;
-	if (!inode->eof_tailraw)
-		return;
-	DBG_BUGON(inode->idata_type == EROFS_IDATA_TYPE_RAW);
+	if (inode->idata_type == EROFS_IDATA_TYPE_RAW ||
+	    (inode->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER))
+		return 0;
 
 	ei = list_last_entry(&ctx->extents, struct z_erofs_extent_item, list);
 	DBG_BUGON(ei->e.raw);
-	ei->e.raw = true;
+
+	rawsz = ei->e.length;
+	if (rawsz > erofs_blksiz(sbi))
+		return 0;
+	encsz = inode->idata_size;
+
+	erofs_err("ballooning tail inline data of %s from %u to %u bytes",
+		  inode->i_srcpath, encsz, rawsz);
+	err = z_erofs_decompress(&(struct z_erofs_decompress_req) {
+		.sbi = sbi,
+		.in = inode->idata,
+		.out = raw,
+		.decodedskip = 0,
+		.interlaced_offset = 0,
+		.inputsize = encsz,
+		.decodedlength = rawsz,
+		.alg = ei->e.algofmt,
+		.partial_decoding = false,
+	});
+	if (err < 0)
+		return err;
 	free(inode->idata);
-	/* replace idata with prepared uncompressed data */
-	inode->idata = inode->eof_tailraw;
-	inode->idata_size = inode->eof_tailrawsize;
+	inode->idata_size = 0;
+	inode->idata = malloc(rawsz);
+	if (!inode->idata)
+		return -ENOMEM;
+	memcpy(inode->idata, raw, rawsz);
+	inode->idata_size = rawsz;
 	inode->idata_type = EROFS_IDATA_TYPE_RAW;
-	inode->eof_tailraw = NULL;
+	ei->e.raw = true;
+	return 0;
 }
 
 int z_erofs_compress_segment(struct z_erofs_compress_sctx *ctx,
diff --git a/lib/inode.c b/lib/inode.c
index 62958d1..1e497a0 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -150,7 +150,6 @@ unsigned int erofs_iput(struct erofs_inode *inode)
 		free(d);
 
 	z_erofs_free_metadata(inode);
-	free(inode->eof_tailraw);
 	erofs_remove_ihash(inode);
 	if (!erofs_is_special_identifier(inode->i_srcpath))
 		free(inode->i_srcpath);
@@ -1050,10 +1049,13 @@ static int erofs_prepare_inode_buffer(struct erofs_importer *im,
 	if (bh == ERR_PTR(-ENOSPC)) {
 		int ret;
 
-		if (is_inode_layout_compression(inode))
-			z_erofs_drop_inline_pcluster(inode);
-		else
+		if (is_inode_layout_compression(inode)) {
+			ret = z_erofs_drop_inline_pcluster(inode);
+			if (ret)
+				return ret;
+		} else {
 			inode->datalayout = EROFS_INODE_FLAT_PLAIN;
+		}
 noinline:
 		/* expend an extra block for tail-end data */
 		ret = erofs_prepare_tail_block(inode);
diff --git a/lib/liberofs_compress.h b/lib/liberofs_compress.h
index 50b3804..43227a2 100644
--- a/lib/liberofs_compress.h
+++ b/lib/liberofs_compress.h
@@ -14,7 +14,7 @@
 
 struct z_erofs_compress_ictx;
 
-void z_erofs_drop_inline_pcluster(struct erofs_inode *inode);
+int z_erofs_drop_inline_pcluster(struct erofs_inode *inode);
 void *erofs_prepare_compressed_file(struct erofs_importer *im,
 				    struct erofs_inode *inode);
 void erofs_bind_compressed_file_with_fd(struct z_erofs_compress_ictx *ictx,
-- 
2.47.3


