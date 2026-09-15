Return-Path: <linux-erofs+bounces-4561-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C98C88E53
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Sep 2026 06:22:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hkX4d4fw2z2ygp;
	Tue, 15 Sep 2026 16:22:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789453361;
	cv=none; b=GSm9NbJKobauYSoRGF7f40DC9iR/1I5K6zYdLIidbEvS8OEsqKPMLVRfchJPDIYk7cNiivivQ3BmcHWY1z1WAnFd87FVDd1Ho0vUDpPs1n2rsoRQeykHuTff33oiXC+f8aNQ+uJwMnavQz90bxRv6M8dagH7LGq38VIDvuDyEpyyUJvZjy8Z2mmMRjTySz5Y3I2Pr8zlfUyJVtDcbqKi60PQD4+hJcEH1zdET+1u5AEfHnbk3C4dwF3Htoyo6WfhIXUzrai7Hhf4FzkxtxbPEm7Ljy7ECof1AWoR303ttCVfH+oleqFn/dXstu1lmgqTUCZMuH058RMQLR7Cipvz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789453361; c=relaxed/relaxed;
	bh=6Z9jSu2OGJ7KpqbGHG2iXiRkugSBpY6cTh3M+7Hyic4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IF6cKIp6MDtWA5CkzLrPwjLd6s8indsvz5b/5b5znuDD4nIoYDq240ACb+9IykyH2eoZNni5QE4RW2px9YG0Z7NhYE2s1YETtD98uw551fy3dib514Nrs8Wzm0j1UD5EKiDvMavsNScvSl6DL78yJftulkeWkQw+RyUID9CEyJvXFIA4fttclgYmXrwkU9tjxOppQiFoEAf0l3lxUk1QUbWM0OAEJ6glqbg/mYKYAOgn9gQati/QoMniVxY8dtDVqF9HNcuqO4LvGq/lkGUqByMLjFy+bW8YodbYRJJAtrHpPnvdh6P3t+/7pJ8oxFlB4m92oghyp6ilK7Wa9nai8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TVySvF9M; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TVySvF9M;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hkX4c5YwDz2yFW
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Sep 2026 16:22:40 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6915C423D5
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Sep 2026 06:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BFA1F000FF;
	Tue, 15 Sep 2026 06:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789453358;
	bh=6Z9jSu2OGJ7KpqbGHG2iXiRkugSBpY6cTh3M+7Hyic4=;
	h=From:To:Cc:Subject:Date;
	b=TVySvF9MQ0AzSX5zrh1l5ZvFSqYpuDHLVOAuyXCtv0LHkt5O30WFxsTnIlnETYwXb
	 H0DKkl9id6oC0iJpioBkkFLvasKWDax2ytaqrt1KzSt7EpRSwGfiMKgd5973WCkGT2
	 5Ywh2T+HDesGTHIH1K5oSFhbKump41bjKI+okO0TV0T3Zar61tjOfobS+8nREDyNEa
	 RQmFohjcxn8p4WDruHbVBg1uCP/XF9s0hpP+JTyOLASt0Y3AB6HarjPD8Eu8XetydW
	 14hUOoTUCBg8RfbU2MM/NF1xkedXh/RpOb5HnPCTVsQTopsLbnlv/Bs7zo3xjhifaj
	 ZrJg0mnDOfshQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2 1/4] erofs-utils: record algorithm id in in-memory compression extents
Date: Tue, 15 Sep 2026 14:21:36 +0800
Message-ID: <20260915062139.54810-1-xiang@kernel.org>
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


