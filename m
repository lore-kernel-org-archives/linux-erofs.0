Return-Path: <linux-erofs+bounces-4567-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6059C88E77
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Sep 2026 07:41:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hl9nc6DdSz2y2Q;
	Wed, 16 Sep 2026 17:41:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789544516;
	cv=none; b=envMCW1qXjmastOrbGO5STiP8tlsnvYsCCJPREQCC8KXlzOzSULUbB5mc+ftD1FuT0gw2hN+uCYbI8hl2CbpqIV22bLEJg9uaEoeGMs7VRukRNapAY284xO55pVuwpQ5xwcR1W1L4FWvPnQOevhR/WtWhgT3fwYtVRC6aTzSd0gACiX1mFD26aDYR90uovx+5wNs44XsrZ/d8AVtTXDY5wtVwf/ikXtFN1eedsOV6ytNAyj8VBIORUFg7Dtm8YU6fPWVadvFXQWMmB0nL0LeiOpP2qJ2sfd1ZnNXGF0nRce0qATiOrnQEe8bAFZ7J0FXSzejaJyl8JiHTnTAZQYhLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789544516; c=relaxed/relaxed;
	bh=6Z9jSu2OGJ7KpqbGHG2iXiRkugSBpY6cTh3M+7Hyic4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S1M8s6kZb1sHYbzjeYWnQKLaflWNC79z6WYEl+RE6f4gp/kFQd0pbxTLoMq7kLrxi683w+/m5nPopyksZPDswkvjWP7PCM+466IhLC4drISQVnzH/hQEYUusc7Sq6Dt4QVysZctNWQrPrGt9ymt9gVvCSIBW11DGxh1IXJSV6PRdTpuL+rLypaCcTkbFg8hlF9ECfwszMuwLt8VDFNFV+LYm2Pk5O+iguiDUMaDSwLu5bVVceorDOG6H6sSVEPW0JGhMvdhrNvkOt1BOPsu3iNWCSlkp5HLXAsseagjes0ORbPpqOVCPm6ZsLj/8shMHD4msPPSwW4mNBR1PV1TXXA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThYIirvT; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThYIirvT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hl9nb4kDcz2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 17:41:55 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 001E240730
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 07:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8064D1F00893;
	Wed, 16 Sep 2026 07:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789544512;
	bh=6Z9jSu2OGJ7KpqbGHG2iXiRkugSBpY6cTh3M+7Hyic4=;
	h=From:To:Cc:Subject:Date;
	b=ThYIirvTFMomggwVrsc804eW4ukJYfcLt8d9z1nSGgRBuq12fJhEMk97LJUAVV1BD
	 wh3Q9WbX37jT8QWL3BQSy8s2HctlI/hQuJedAO4gGU58SMTTDIh/df5THzflbVaZNu
	 VFn2KdyexuGyYWn3jvimDOmvcRXgkZ9/TWKuF5hi5PDLuIG3VhRgWobXVpg/ls25Ui
	 U5jhJfJEBCJBRxanXKlMTAIGzmr15AruY2UB9MAARVbph0eZ21ulqknkbsF60pwX3r
	 PP0rc0LD/QqZVEu/SlV3dcIjbgTLjN4Hx1vxZaqJFQHuE2oWn9kFV693DjHk4kC+2v
	 IdnBFK4WjcBnQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v3 1/4] erofs-utils: record algorithm id in in-memory compression extents
Date: Wed, 16 Sep 2026 15:40:58 +0800
Message-ID: <20260916074101.66357-1-xiang@kernel.org>
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


