Return-Path: <linux-erofs+bounces-4566-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E91F2C88E77
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Sep 2026 07:12:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hl97J49vsz2y2Q;
	Wed, 16 Sep 2026 17:12:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789542732;
	cv=none; b=Oln6thVdbQg76CPsjTUNcjU5wlU6Lbh9JThwJ2CnK0ap+qzNe6woZXQdxZOnmciB96Q5l2CbV/pyDcNLsgpun/It71JHACrG1KU7W68Y+9MEFcO9BDw4xDO52C+ov+aeTyqMS/8Xz/o84dxOKEFqYDNY+SS+klomspeuuJNNSyJAB/dHqLxfKhQigeFMHjNpJRNM9DaidrzkwxEbQmtBU0x0yd+e2N3tyLiOXGMVXqmii/UtyupSHMbiZ/1qrWWzu2BXivvwKLHmgc8iuOODYj8nQ3N1r3Vkhdi6wClzyRojZtRjX1wrw+hKBckV9z3B98YUXPGalhPPL7Zl9oN1/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789542732; c=relaxed/relaxed;
	bh=6Z9jSu2OGJ7KpqbGHG2iXiRkugSBpY6cTh3M+7Hyic4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLB5mBuMwDDjOznuzaCUilCVk/TXjoNXj/aq+Q8PKwQPDZqSK0TCGeq7oPufq0ZJTCsVrWyniEP3f8+dNamcJyGNO/OMx3FBicFcXvrPp2GgufoAuLrXv3JGNCwb+S1o/D3aO34czTry4fYtjmdEABf+ojYZPHWqE9xnC5siM8VcwrmJxvq5mUZYG8xaDR8Wn3QAUkGM2z/exz8Mu00CdW6V5kTqNEBR8fVar+4H2jOG6F+KNv7L1FYIcMg4wp2vxNJWzToXFHno8bdHjX3jXxR+rAalyXs1VxHs6VA58g1bQLTw4PSltJIki1Lpn/ZpMfNe0dqyp4b7iNkKsL9ReQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CJsfwO/u; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CJsfwO/u;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hl97H4Nq6z2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 17:12:11 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61C6C6020C
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 07:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E6E1F000FF;
	Wed, 16 Sep 2026 07:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789542729;
	bh=6Z9jSu2OGJ7KpqbGHG2iXiRkugSBpY6cTh3M+7Hyic4=;
	h=From:To:Cc:Subject:Date;
	b=CJsfwO/uDHlebbQEfVU19oCN8azoEAHJaf5YY9vVovZXrLCWxrk6VFTyv3SGBEx8k
	 m2gfWF6tIdqPAnR6LDzJ4Ck3z6S3BxOrhlGQxndaTJOpmzEWg03xFKsJoxWfqcn/7i
	 2P4QxStDXWeC7IpjBNKV+KtUVoUcN/xy4w6qL4459RcxC9T9Ilu5Jg4ADFGCzeQubS
	 50mQ5rnxZNsUR/aKdSYTHH2l3RilazQ9PKott4My2iJEmwFd+3tuX4FubE1rL+yfnB
	 xntGrjQzkd7ELAdYV85BphlS+xWSJ/rj4jj1rZlBW6TrROO1TaL6OP/IGnGd/I6MuU
	 CA1Kg5yH5ThzQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v3 1/4] erofs-utils: record algorithm id in in-memory compression extents
Date: Wed, 16 Sep 2026 15:11:13 +0800
Message-ID: <20260916071116.66291-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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

In order to enable the rebuild mode for compressed inodes.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/dedupe.h |  1 +
 lib/compress.c         | 13 ++++++++++---
 lib/dedupe.c           |  3 +++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/erofs/dedupe.h b/include/erofs/dedupe.h
index 14dd7dc..dbcb37c 100644
--- a/include/erofs/dedupe.h
+++ b/include/erofs/dedupe.h
@@ -18,6 +18,7 @@ struct z_erofs_inmem_extent {
 	unsigned int length;
 	unsigned short device_id;
 	bool raw, partial, inlined;
+	char algofmt;
 };
 
 struct z_erofs_dedupe_ctx {
diff --git a/lib/compress.c b/lib/compress.c
index ae09e86..3e8f9b6 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -189,7 +189,9 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 		DBG_BUGON(!e->raw && !inode->idata_size && !inode->fragment_size);
 		DBG_BUGON(e->partial);
 		type = e->raw ? Z_EROFS_LCLUSTER_TYPE_PLAIN :
-			Z_EROFS_LCLUSTER_TYPE_HEAD1;
+			(e->algofmt == inode->z_algorithmtype[0] ?
+				Z_EROFS_LCLUSTER_TYPE_HEAD1 :
+				Z_EROFS_LCLUSTER_TYPE_HEAD2);
 		di.di_advise = cpu_to_le16(type);
 
 		if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL && !e->plen) {
@@ -238,7 +240,9 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 			di.di_u.delta[1] = cpu_to_le16(d1);
 		} else {
 			type = e->raw ? Z_EROFS_LCLUSTER_TYPE_PLAIN :
-				Z_EROFS_LCLUSTER_TYPE_HEAD1;
+				(e->algofmt == inode->z_algorithmtype[0] ?
+					Z_EROFS_LCLUSTER_TYPE_HEAD1 :
+					Z_EROFS_LCLUSTER_TYPE_HEAD2);
 
 			if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL &&
 			    !e->plen) {
@@ -700,6 +704,7 @@ frag_packing:
 		e->inlined = true;
 		e->plen = blksz;
 		e->raw = false;
+		e->algofmt = inode->z_algorithmtype[0];
 	} else {
 		unsigned int padding;
 
@@ -755,6 +760,7 @@ frag_packing:
 		}
 		ctx->poff += e->plen;
 		e->raw = false;
+		e->algofmt = inode->z_algorithmtype[0];
 		may_inline = false;
 		may_packing = false;
 	}
@@ -1233,7 +1239,7 @@ static void z_erofs_write_extents(struct erofs_inode *inode,
 			plen = inode->fragmentoff;
 			pstart = inode->fragmentoff >> 32;
 		} else {
-			fmt = ei->e.raw ? 0 : inode->z_algorithmtype[0] + 1;
+			fmt = ei->e.raw ? 0 : ei->e.algofmt + 1;
 			plen |= fmt << Z_EROFS_EXTENT_PLEN_FMT_BIT;
 			if (ei->e.partial)
 				plen |= Z_EROFS_EXTENT_PLEN_PARTIAL;
@@ -1350,6 +1356,7 @@ int z_erofs_compress_segment(struct z_erofs_compress_sctx *ctx,
 			.raw = false,
 			.partial = false,
 			.pstart = ctx->pstart,
+			.algofmt = inode->z_algorithmtype[0],
 		};
 		init_list_head(&ei->list);
 		z_erofs_commit_extent(ctx, ei);
diff --git a/lib/dedupe.c b/lib/dedupe.c
index 5166f26..ec9e2bb 100644
--- a/lib/dedupe.c
+++ b/lib/dedupe.c
@@ -77,6 +77,7 @@ struct z_erofs_dedupe_item {
 
 	int		original_length;
 	bool		partial, raw;
+	char		algofmt;
 	u8		extra_data[];
 };
 
@@ -144,6 +145,7 @@ int z_erofs_dedupe_match(struct z_erofs_dedupe_ctx *ctx)
 		ctx->e.inlined = false;
 		ctx->e.pstart = e->pstart;
 		ctx->e.plen = e->plen;
+		ctx->e.algofmt = e->algofmt;
 		return 0;
 	}
 	return -ENOENT;
@@ -183,6 +185,7 @@ int z_erofs_dedupe_insert(struct z_erofs_inmem_extent *e,
 	di->plen = e->plen;
 	di->partial = e->partial;
 	di->raw = e->raw;
+	di->algofmt = e->algofmt;
 	di->chain = dedupe_subtree;
 	dedupe_subtree = di;
 	list_add_tail(&di->list, p);
-- 
2.47.3


