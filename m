Return-Path: <linux-erofs+bounces-4527-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFEDC79FB9
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Sep 2026 11:59:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hgbnw26Czz2xRs;
	Thu, 10 Sep 2026 21:59:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789041588;
	cv=none; b=kOWmFOXB4jRmeVmaPFWPmlcMHShco0eac6m/RaSU6GhC/lhPSRihJtyl0yltFpgEJXUgrTjRls8t9ZiMX6+KyD1q72IjQWw0+2IGgtuR4bGo6tyiMmZcx6m0k4m+TqwfTdO/tKKhAQ/zRVTF5X85G+dFnUE/g9eF5vAr/ob6v1227/fSqnWZxwEDicJYqEpWu8umM10UKfc9xnRqcD65tpQyFNgPh97FH75Bc4+VuzLKSbFIkcAE9zgz2d3tgOB3EIOlBGtZkRsUBcekSgd1MylxZjUF20ISqeDMy0Oamt+0If6F8YcYb/2FHd2w8fkePzlLo8axSf7EQBBoBukaKw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789041588; c=relaxed/relaxed;
	bh=AVvXTCJTomjVEi8SSyDAjvQ1aYg/kcc3p1FeJnIaY3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dqmoMVFo2OKYKOwJQdgqqAIYldwai0xQCPqxYefsHyG90HbY736oXRZNGHANIRJytpo0cyv+11AR6DOo9wkT5wDH+/D4v6t/igd4k9Gm9wFZfYgJnht3V0xldAN6GetkK8u8n+ct9MtjPSqXESvt2C9Yw8s4uchnqsvlCppudcwG7ncEDypTV0TdINWMtHF7leEmbG74vVixbbPjM0x451iaZ+KHORcjsRk9uBg4Q1aRSdk+6Ltj/gcr07l0gvIdX7ZvVieGWn3NapiHhwfNf8f2LRyePB6ODBlimK+QF4kbyHvB+BqzYWLvW+2roaeOCN8dbllln70u/SXeocyxKA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tinb5IHu; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tinb5IHu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hgbnt4zLKz2xLq
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 21:59:46 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ECCF601F0
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 11:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237361F00893;
	Thu, 10 Sep 2026 11:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789041582;
	bh=AVvXTCJTomjVEi8SSyDAjvQ1aYg/kcc3p1FeJnIaY3g=;
	h=From:To:Cc:Subject:Date;
	b=Tinb5IHu8aQ0DpLQnwt9xThj8l285LjhukvgELUVJSqaiAl7q6VBOa8hg7BvDHsdu
	 cJ59ICkXvvRUooGTUhKaukbHJETfAN0psSzprtbK5DBQvC2Ukvn51wrTuerDoU55Yb
	 5TMUdMRQCTrBcNNA5+wxmm1ck2YGxxsHSWcy0dMWzE24RPt+uAVZzmV8sAQapI7WLt
	 Q/ubG8PgEzzWEwWh2QGKNRSN6HnYOsaqT3zxzOlTachChtIsr8gEjFwHTfgb5IIoIH
	 OykKia0dgahCwveR1aoZRF5vf/+wZ0Aaq2NyHrfFcOGa4gK0IdCXEo5qalW8YJK//H
	 ZbhOT/2wvIyUA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH 1/2] erofs-utils: mkfs: defer compressed metadata generation
Date: Thu, 10 Sep 2026 19:58:51 +0800
Message-ID: <20260910115852.149572-1-xiang@kernel.org>
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

Generally, unique addresses should be assigned after the size of
the primary device is decided.

Defer compressed metadata generation until after
erofs_update_all_devices().  This is used to support multi-device
compressed filesystems (including fsmerge support for compressed
images.)

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/internal.h |   1 -
 lib/compress.c           | 462 +++++++++++++++++++++------------------
 lib/inode.c              |   8 +-
 lib/liberofs_compress.h  |   1 +
 4 files changed, 261 insertions(+), 211 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 84a7590..0de71fb 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -212,7 +212,6 @@ struct erofs_diskbuf;
 enum erofs_idata_type {
 	EROFS_IDATA_TYPE_RAW,
 	EROFS_IDATA_TYPE_COMPRESSED_DEFAULT,
-	EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B,
 };
 
 #define EROFS_I_BLKADDR_DEV_ID_BIT		48
diff --git a/lib/compress.c b/lib/compress.c
index 9bbb127..bcb064f 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -141,7 +141,13 @@ static bool z_erofs_mt_enabled;
 
 #define Z_EROFS_LEGACY_MAP_HEADER_SIZE	Z_EROFS_FULL_INDEX_START(0)
 
-static void z_erofs_fini_full_indexes(struct z_erofs_compress_ictx *ctx)
+struct z_erofs_index_writer {
+	struct erofs_inode *inode;
+	u8 *metacur;
+	unsigned short clusterofs;
+};
+
+static void z_erofs_fini_full_indexes(struct z_erofs_index_writer *ctx)
 {
 	const unsigned int type = Z_EROFS_LCLUSTER_TYPE_PLAIN;
 	struct z_erofs_lcluster_index di;
@@ -157,10 +163,9 @@ static void z_erofs_fini_full_indexes(struct z_erofs_compress_ictx *ctx)
 	ctx->metacur += sizeof(di);
 }
 
-static void z_erofs_write_full_indexes(struct z_erofs_compress_ictx *ctx,
+static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 				       struct z_erofs_inmem_extent *e)
 {
-	const struct erofs_importer_params *params = ctx->im->params;
 	struct erofs_inode *inode = ctx->inode;
 	struct erofs_sb_info *sbi = inode->sbi;
 	unsigned int clusterofs = ctx->clusterofs;
@@ -181,7 +186,7 @@ static void z_erofs_write_full_indexes(struct z_erofs_compress_ictx *ctx,
 		 * A lcluster cannot have three parts with the middle one which
 		 * is well-compressed for !ztailpacking cases.
 		 */
-		DBG_BUGON(!e->raw && !params->ztailpacking && !params->fragments);
+		DBG_BUGON(!e->raw && !inode->idata_size && !inode->fragment_size);
 		DBG_BUGON(e->partial);
 		type = e->raw ? Z_EROFS_LCLUSTER_TYPE_PLAIN :
 			Z_EROFS_LCLUSTER_TYPE_HEAD1;
@@ -895,15 +900,15 @@ static void *write_compacted_indexes(u8 *out,
 	return out + destsize * vcnt;
 }
 
-int z_erofs_convert_to_compacted_format(struct erofs_inode *inode,
-					erofs_off_t pstart,
-					unsigned int legacymetasize,
-					void *compressmeta)
+int z_erofs_convert_to_compact_format(struct erofs_inode *inode,
+				      erofs_off_t pstart,
+				      unsigned int fullmetasz,
+				      void *metabuf)
 {
 	const unsigned int mpos = roundup(inode->inode_isize +
 					  inode->xattr_isize, 8) +
 				  sizeof(struct z_erofs_map_header);
-	const unsigned int totalidx = (legacymetasize -
+	const unsigned int totalidx = (fullmetasz -
 			Z_EROFS_LEGACY_MAP_HEADER_SIZE) /
 				sizeof(struct z_erofs_lcluster_index);
 	const unsigned int logical_clusterbits = inode->z_lclusterbits;
@@ -953,7 +958,15 @@ int z_erofs_convert_to_compacted_format(struct erofs_inode *inode,
 		compacted_4b_end = totalidx;
 	}
 
-	out = in = compressmeta;
+	if (!metabuf) {
+		out = (u8 *)sizeof(struct z_erofs_map_header);
+		out += 4 * compacted_4b_initial;
+		out += 2 * compacted_2b;
+		out += 4 * round_up(compacted_4b_end, 2);
+		return out - (u8 *)metabuf;
+	}
+
+	out = in = metabuf;
 
 	out += sizeof(struct z_erofs_map_header);
 	in += Z_EROFS_LEGACY_MAP_HEADER_SIZE;
@@ -977,9 +990,6 @@ int z_erofs_convert_to_compacted_format(struct erofs_inode *inode,
 
 	/* generate compacted_2b */
 	if (compacted_2b) {
-		if (!compacted_4b_end && inode->idata_size &&
-		    inode->idata_type != EROFS_IDATA_TYPE_RAW)
-			inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B;
 		do {
 			in = parse_legacy_indexes(cv, 16, in);
 			out = write_compacted_indexes(out, cv, &blkaddr,
@@ -1006,8 +1016,7 @@ int z_erofs_convert_to_compacted_format(struct erofs_inode *inode,
 					      4, logical_clusterbits, true,
 					      &dummy_head, big_pcluster);
 	}
-	inode->extent_isize = out - (u8 *)compressmeta;
-	return 0;
+	return out - (u8 *)metabuf;
 }
 
 static void z_erofs_write_mapheader(struct erofs_inode *inode,
@@ -1044,9 +1053,8 @@ static void z_erofs_write_mapheader(struct erofs_inode *inode,
 			h.h_fragmentoff = cpu_to_le32(inode->fragmentoff);
 		else
 			h.h_idata_size = cpu_to_le16(inode->idata_size);
-
-		memset(compressmeta, 0, Z_EROFS_LEGACY_MAP_HEADER_SIZE);
 	}
+	memset(compressmeta, 0, Z_EROFS_LEGACY_MAP_HEADER_SIZE);
 	/* write out map header */
 	memcpy(compressmeta, &h, sizeof(struct z_erofs_map_header));
 }
@@ -1055,67 +1063,146 @@ static void z_erofs_write_mapheader(struct erofs_inode *inode,
 	(BLK_ROUND_UP(inode->sbi, inode->i_size) * \
 	 sizeof(struct z_erofs_lcluster_index) + Z_EROFS_LEGACY_MAP_HEADER_SIZE)
 
-static void *z_erofs_write_extents(struct z_erofs_compress_ictx *ctx)
+struct z_erofs_metadata_ctx {
+	struct list_head extents;
+};
+
+static int z_erofs_prepare_layout(struct erofs_inode *inode,
+				  struct list_head *extents,
+				  bool consecutive, bool no_compact)
 {
-	struct erofs_inode *inode = ctx->inode;
 	struct erofs_sb_info *sbi = inode->sbi;
-	struct z_erofs_extent_item *ei, *n;
-	unsigned int lclusterbits, nexts;
-	bool pstart_hi = false, unaligned_data = false;
-	erofs_off_t pstart, pend, lstart;
-	unsigned int recsz, metasz, moff;
-	void *metabuf;
-
-	ei = list_first_entry(&ctx->extents, struct z_erofs_extent_item,
-			      list);
-	lclusterbits = max_t(u8, ilog2(ei->e.length - 1) + 1, sbi->blkszbits);
-	pend = pstart = ei->e.pstart;
-	nexts = 0;
-	list_for_each_entry(ei, &ctx->extents, list) {
-		pstart_hi |= (ei->e.pstart > UINT32_MAX);
-		if ((ei->e.pstart | ei->e.plen) & ((1U << sbi->blkszbits) - 1))
-			unaligned_data = true;
-		if (pend != ei->e.pstart)
-			pend = EROFS_NULL_ADDR;
-		else
-			pend += ei->e.plen;
-		if (ei->e.length != 1 << lclusterbits) {
-			if (ei->list.next != &ctx->extents ||
-			    ei->e.length > 1 << lclusterbits)
-				lclusterbits = 0;
+	struct z_erofs_metadata_ctx *ctx;
+	unsigned int metasz;
+	int ret;
+
+	ctx = malloc(sizeof(*ctx));
+	if (!ctx)
+		return -ENOMEM;
+	init_list_head(&ctx->extents);
+	list_splice_tail(extents, &ctx->extents);
+
+	/* TODO: support writing encoded extents for ztailpacking later. */
+	if (erofs_sb_has_48bit(sbi) && !inode->idata_size) {
+		bool pstart_hi = false, unaligned_data = false;
+		unsigned int lclusterbits, nexts;
+		struct z_erofs_extent_item *ei;
+		erofs_off_t pstart, pend;
+		unsigned int recsz, moff;
+
+		ei = list_first_entry(&ctx->extents, struct z_erofs_extent_item,
+				      list);
+		lclusterbits = max_t(u8, ilog2(ei->e.length - 1) + 1, sbi->blkszbits);
+		pend = pstart = ei->e.pstart;
+		nexts = 0;
+		list_for_each_entry(ei, &ctx->extents, list) {
+			pstart_hi |= (ei->e.pstart > UINT32_MAX);
+			if ((ei->e.pstart | ei->e.plen) & ((1U << sbi->blkszbits) - 1))
+				unaligned_data = true;
+			if (pend != ei->e.pstart)
+				pend = EROFS_NULL_ADDR;
+			else
+				pend += ei->e.plen;
+			if (ei->e.length != 1 << lclusterbits) {
+				if (ei->list.next != &ctx->extents ||
+				    ei->e.length > 1 << lclusterbits)
+					lclusterbits = 0;
+			}
+			++nexts;
 		}
-		++nexts;
+		inode->z_extents = nexts;
+		recsz = inode->i_size > UINT32_MAX ? 32 : 16;
+		if (lclusterbits) {
+			if (pend != EROFS_NULL_ADDR)
+				recsz = 4;
+			else if (recsz <= 16 && !pstart_hi)
+				recsz = 8;
+		}
+
+		moff = Z_EROFS_MAP_HEADER_END(inode->inode_isize + inode->xattr_isize);
+		moff = round_up(moff, recsz) -
+			Z_EROFS_MAP_HEADER_START(inode->inode_isize + inode->xattr_isize);
+		metasz = moff + recsz * nexts + 8 * (recsz <= 4);
+		if (unaligned_data || metasz < EROFS_FULL_INDEXES_SZ(inode)) {
+			inode->z_lclusterbits = lclusterbits;
+			inode->z_extents = nexts;
+			inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
+			inode->z_advise |= Z_EROFS_ADVISE_EXTENTS |
+				((ilog2(recsz) - 2) << Z_EROFS_ADVISE_EXTRECSZ_BIT);
+			goto out;
+		}
+	}
+
+	/* if the entire file is a fragment, a simplified form is used. */
+	if (inode->i_size <= inode->fragment_size) {
+		DBG_BUGON(inode->i_size < inode->fragment_size);
+		DBG_BUGON(inode->fragmentoff >> 63);
+		inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
+		metasz = Z_EROFS_LEGACY_MAP_HEADER_SIZE;
+		goto out;
+	}
+
+	/*
+	 * If the packed inode is larger than 4GiB, the full fragmentoff
+	 * will be recorded by switching to the noncompact layout anyway.
+	 */
+	if (inode->fragment_size && inode->fragmentoff >> 32) {
+		inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
+	} else if (!no_compact && consecutive &&
+		   inode->z_lclusterbits <= 14) {
+		if (inode->z_lclusterbits <= 12)
+			inode->z_advise |= Z_EROFS_ADVISE_COMPACTED_2B;
+		inode->datalayout = EROFS_INODE_COMPRESSED_COMPACT;
+	} else {
+		inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
 	}
 
-	recsz = inode->i_size > UINT32_MAX ? 32 : 16;
-	if (lclusterbits) {
-		if (pend != EROFS_NULL_ADDR)
-			recsz = 4;
-		else if (recsz <= 16 && !pstart_hi)
-			recsz = 8;
+	if (erofs_sb_has_big_pcluster(sbi)) {
+		inode->z_advise |= Z_EROFS_ADVISE_BIG_PCLUSTER_1;
+		if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT)
+			inode->z_advise |= Z_EROFS_ADVISE_BIG_PCLUSTER_2;
 	}
 
+	metasz = EROFS_FULL_INDEXES_SZ(inode);
+
+	if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT) {
+		ret = z_erofs_convert_to_compact_format(inode, 0, metasz,
+							NULL);
+		if (ret < 0)
+			return ret;
+		metasz = ret;
+	}
+
+out:
+	inode->extent_isize = metasz;
+	inode->compressmeta = ctx;
+	return 0;
+}
+
+static void z_erofs_write_extents(struct erofs_inode *inode,
+				  struct list_head *extents, u8 *metabuf)
+{
+	unsigned int recsz = z_erofs_extent_recsize(inode->z_advise);
+	struct z_erofs_extent_item *ei, *n;
+	erofs_off_t pstart, lstart;
+	unsigned int moff;
+	u8 *metacur;
+	u64 nexts;
+
 	moff = Z_EROFS_MAP_HEADER_END(inode->inode_isize + inode->xattr_isize);
 	moff = round_up(moff, recsz) -
 		Z_EROFS_MAP_HEADER_START(inode->inode_isize + inode->xattr_isize);
-	metasz = moff + recsz * nexts + 8 * (recsz <= 4);
-	if (!unaligned_data && metasz > EROFS_FULL_INDEXES_SZ(inode))
-		return ERR_PTR(-EAGAIN);
-
-	metabuf = malloc(metasz);
-	if (!metabuf)
-		return ERR_PTR(-ENOMEM);
-	inode->z_lclusterbits = lclusterbits;
-	inode->z_extents = nexts;
-	ctx->metacur = metabuf + moff;
+	metacur = metabuf + moff;
 	if (recsz <= 4) {
-		*(__le64 *)ctx->metacur	= cpu_to_le64(pstart);
-		ctx->metacur += sizeof(__le64);
+		ei = list_first_entry(extents, struct z_erofs_extent_item, list);
+		pstart = ei->e.pstart;
+		*(__le64 *)metacur = cpu_to_le64(pstart);
+		metacur += sizeof(__le64);
 	}
 
 	nexts = 0;
 	lstart = 0;
-	list_for_each_entry_safe(ei, n, &ctx->extents, list) {
+	list_for_each_entry_safe(ei, n, extents, list) {
 		struct z_erofs_extent de;
 		u32 fmt, plen;
 
@@ -1136,128 +1223,30 @@ static void *z_erofs_write_extents(struct z_erofs_compress_ictx *ctx)
 			.pstart_hi = cpu_to_le32(ei->e.pstart >> 32),
 			.lstart_hi = cpu_to_le32(lstart >> 32),
 		};
-		memcpy(ctx->metacur, &de, recsz);
-		ctx->metacur += recsz;
+		memcpy(metacur, &de, recsz);
+		metacur += recsz;
 		lstart += ei->e.length;
 		list_del(&ei->list);
 		free(ei);
+		++nexts;
 	}
-	inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
-	inode->z_advise |= Z_EROFS_ADVISE_EXTENTS |
-		((ilog2(recsz) - 2) << Z_EROFS_ADVISE_EXTRECSZ_BIT);
-	return metabuf;
-}
-
-static void *z_erofs_write_indexes(struct z_erofs_compress_ictx *ctx)
-{
-	const struct erofs_importer_params *params = ctx->im->params;
-	struct erofs_inode *inode = ctx->inode;
-	struct erofs_sb_info *sbi = inode->sbi;
-	struct z_erofs_extent_item *ei, *n;
-	void *metabuf;
-
-	/* TODO: support writing encoded extents for ztailpacking later. */
-	if (erofs_sb_has_48bit(sbi) && !inode->idata_size) {
-		metabuf = z_erofs_write_extents(ctx);
-		if (metabuf != ERR_PTR(-EAGAIN)) {
-			if (IS_ERR(metabuf))
-				return metabuf;
-			goto out;
-		}
-	}
-
-	/*
-	 * If the packed inode is larger than 4GiB, the full fragmentoff
-	 * will be recorded by switching to the noncompact layout anyway.
-	 */
-	if (inode->fragment_size && inode->fragmentoff >> 32) {
-		inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
-	} else if (!params->no_zcompact && !ctx->dedupe &&
-		   inode->z_lclusterbits <= 14) {
-		if (inode->z_lclusterbits <= 12)
-			inode->z_advise |= Z_EROFS_ADVISE_COMPACTED_2B;
-		inode->datalayout = EROFS_INODE_COMPRESSED_COMPACT;
-	} else {
-		inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
-	}
-
-	if (erofs_sb_has_big_pcluster(sbi)) {
-		inode->z_advise |= Z_EROFS_ADVISE_BIG_PCLUSTER_1;
-		if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT)
-			inode->z_advise |= Z_EROFS_ADVISE_BIG_PCLUSTER_2;
-	}
-
-	metabuf = malloc(BLK_ROUND_UP(inode->sbi, inode->i_size) *
-			 sizeof(struct z_erofs_lcluster_index) +
-			 Z_EROFS_LEGACY_MAP_HEADER_SIZE);
-	if (!metabuf)
-		return ERR_PTR(-ENOMEM);
-
-	ctx->metacur = metabuf + Z_EROFS_LEGACY_MAP_HEADER_SIZE;
-	ctx->clusterofs = 0;
-	list_for_each_entry_safe(ei, n, &ctx->extents, list) {
-		DBG_BUGON(ei->list.next != &ctx->extents &&
-			  ctx->clusterofs + ei->e.length < erofs_blksiz(sbi));
-		z_erofs_write_full_indexes(ctx, &ei->e);
-
-		list_del(&ei->list);
-		free(ei);
-	}
-	z_erofs_fini_full_indexes(ctx);
-out:
-	z_erofs_write_mapheader(inode, metabuf);
-	return metabuf;
+	DBG_BUGON(inode->z_extents && nexts != inode->z_extents);
+	DBG_BUGON(metacur - metabuf != inode->extent_isize);
 }
 
 void z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
 {
-	struct erofs_sb_info *sbi = inode->sbi;
-	const unsigned int type = Z_EROFS_LCLUSTER_TYPE_PLAIN;
-	struct z_erofs_map_header *h = inode->compressmeta;
+	struct z_erofs_metadata_ctx *ctx = inode->compressmeta;
+	struct z_erofs_extent_item *ei;
 
-	h->h_advise = cpu_to_le16(le16_to_cpu(h->h_advise) &
-				  ~Z_EROFS_ADVISE_INLINE_PCLUSTER);
-	DBG_BUGON(inode->idata_size != le16_to_cpu(h->h_idata_size));
-	h->h_idata_size = 0;
+	inode->z_advise &= ~Z_EROFS_ADVISE_INLINE_PCLUSTER;
 	if (!inode->eof_tailraw)
 		return;
 	DBG_BUGON(inode->idata_type == EROFS_IDATA_TYPE_RAW);
 
-	/* patch the EOF lcluster to uncompressed type first */
-	if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL) {
-		struct z_erofs_lcluster_index *di =
-			(inode->compressmeta + inode->extent_isize) -
-			sizeof(struct z_erofs_lcluster_index);
-
-		di->di_advise = cpu_to_le16(type);
-	} else if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT) {
-		/* handle the last compacted 4B/2B pack */
-		unsigned int lclusterbits = inode->z_lclusterbits;
-		unsigned int lobits, eofs, base, pos, v;
-		u8 *out;
-
-		lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
-
-		if (inode->idata_type == EROFS_IDATA_TYPE_COMPRESSED_DEFAULT) {
-			eofs = inode->extent_isize -
-				(4 << (BLK_ROUND_UP(sbi, inode->i_size) & 1));
-			base = round_down(eofs, 8);
-			pos = 16 /* encodebits */ * ((eofs - base) / 4);
-			out = inode->compressmeta + base + pos / 8;
-		} else {
-			out = inode->compressmeta + inode->extent_isize -
-				sizeof(__le32) - sizeof(__le16);
-			lobits = 16 - 14 /* encodebits */ + lobits;
-		}
-
-		v = (get_unaligned_le16(out) & (BIT(lobits) - 1)) |
-			(type << lobits);
-		*out = v & 0xff;
-		*(out + 1) = v >> 8;
-	} else {
-		DBG_BUGON(1);
-		return;
-	}
+	ei = list_last_entry(&ctx->extents, struct z_erofs_extent_item, list);
+	DBG_BUGON(ei->e.raw);
+	ei->e.raw = true;
 	free(inode->idata);
 	/* replace idata with prepared uncompressed data */
 	inode->idata = inode->eof_tailraw;
@@ -1348,8 +1337,7 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 	struct erofs_inode *inode = ictx->inode;
 	const struct erofs_importer_params *params = ictx->im->params;
 	struct erofs_sb_info *sbi = inode->sbi;
-	unsigned int legacymetasize, bbits = sbi->blkszbits;
-	u8 *compressmeta;
+	unsigned int bbits = sbi->blkszbits;
 	int ret;
 
 	if (inode->fragment_size) {
@@ -1367,16 +1355,14 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 	DBG_BUGON(pstart < (!!inode->idata_size) << bbits);
 	ptotal -= (u64)(!!inode->idata_size) << bbits;
 
-	compressmeta = z_erofs_write_indexes(ictx);
-	if (!compressmeta) {
-		ret = -ENOMEM;
+	ret = z_erofs_prepare_layout(inode, &ictx->extents, !ictx->dedupe,
+				     params->no_zcompact);
+	if (ret)
 		goto err_free_idata;
-	}
 
-	legacymetasize = ictx->metacur - compressmeta;
 	/* estimate if data compression saves space or not */
 	if (!inode->fragment_size && ptotal + inode->idata_size +
-	    legacymetasize >= inode->i_size) {
+	    inode->extent_isize >= inode->i_size) {
 		z_erofs_dedupe_ext_commit(true);
 		z_erofs_dedupe_commit(true);
 		ret = EROFS_RETVAL_FALLBACK;
@@ -1388,16 +1374,6 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 	if (!ictx->fragemitted)
 		sbi->saved_by_deduplication += inode->fragment_size;
 
-	/* if the entire file is a fragment, a simplified form is used. */
-	if (inode->i_size <= inode->fragment_size) {
-		DBG_BUGON(inode->i_size < inode->fragment_size);
-		DBG_BUGON(inode->fragmentoff >> 63);
-		*(__le64 *)compressmeta =
-			cpu_to_le64(inode->fragmentoff | 1ULL << 63);
-		inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
-		legacymetasize = Z_EROFS_LEGACY_MAP_HEADER_SIZE;
-	}
-
 	if (ptotal)
 		(void)erofs_bh_balloon(bh, ptotal);
 	else if (!params->fragments && params->dedupe != EROFS_DEDUPE_FORCE_ON)
@@ -1414,21 +1390,12 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 	}
 
 	inode->u.i_blocks = BLK_ROUND_UP(sbi, ptotal);
-
-	if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL) {
-		inode->extent_isize = legacymetasize;
-	} else {
-		ret = z_erofs_convert_to_compacted_format(inode, pstart,
-							  legacymetasize,
-							  compressmeta);
-		DBG_BUGON(ret);
-	}
-	inode->compressmeta = compressmeta;
 	return 0;
 
 err_free_meta:
-	free(compressmeta);
+	free(inode->compressmeta);
 	inode->compressmeta = NULL;
+	inode->extent_isize = 0;
 err_free_idata:
 	erofs_bdrop(bh, true);	/* revoke buffer */
 	if (inode->idata) {
@@ -1438,6 +1405,89 @@ err_free_idata:
 	return ret;
 }
 
+char *z_erofs_write_metadata(struct erofs_inode *inode)
+{
+	struct erofs_sb_info *sbi = inode->sbi;
+	struct z_erofs_metadata_ctx *mctx = inode->compressmeta;
+	struct z_erofs_extent_item *ei, *n;
+	struct z_erofs_index_writer ctx;
+	unsigned int metasz =
+		inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT ?
+		EROFS_FULL_INDEXES_SZ(inode) : inode->extent_isize;
+	erofs_off_t pstart;
+	u8 *metabuf;
+	int err = 0;
+
+	metabuf = malloc(metasz);
+	if (!metabuf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* if the entire file is a fragment, a simplified form is used. */
+	if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL &&
+	    inode->i_size <= inode->fragment_size) {
+		DBG_BUGON(inode->i_size < inode->fragment_size);
+		DBG_BUGON(inode->fragmentoff >> 63);
+		*(__le64 *)metabuf = cpu_to_le64(inode->fragmentoff | 1ULL << 63);
+		goto out;
+	}
+
+	if (__erofs_unlikely(!mctx)) {
+		DBG_BUGON(1);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL &&
+	    (inode->z_advise & Z_EROFS_ADVISE_EXTENTS)) {
+		z_erofs_write_extents(inode, &mctx->extents, metabuf);
+		z_erofs_write_mapheader(inode, metabuf);
+		goto out;
+	}
+
+	ctx = (struct z_erofs_index_writer) {
+		.inode = inode,
+		.metacur = metabuf + Z_EROFS_LEGACY_MAP_HEADER_SIZE,
+	};
+
+	DBG_BUGON(list_empty(&mctx->extents));
+	ei = list_first_entry(&mctx->extents, struct z_erofs_extent_item, list);
+	pstart = ei->e.pstart;
+
+	list_for_each_entry_safe(ei, n, &mctx->extents, list) {
+		DBG_BUGON(ei->list.next != &mctx->extents &&
+			  ctx.clusterofs + ei->e.length < erofs_blksiz(sbi));
+		z_erofs_write_full_indexes(&ctx, &ei->e);
+
+		list_del(&ei->list);
+		free(ei);
+	}
+	z_erofs_fini_full_indexes(&ctx);
+	DBG_BUGON(metasz != ctx.metacur - metabuf);
+	z_erofs_write_mapheader(inode, metabuf);
+
+	if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT) {
+		err = z_erofs_convert_to_compact_format(inode, pstart,
+							metasz, metabuf);
+		if (err < 0) {
+			DBG_BUGON(1);
+			goto out;
+		}
+		metasz = err;
+	}
+	DBG_BUGON(metasz != inode->extent_isize);
+out:
+	if (mctx) {
+		list_for_each_entry_safe(ei, n, &mctx->extents, list) {
+			list_del(&ei->list);
+			free(ei);
+		}
+		free(mctx);
+	}
+	inode->compressmeta = NULL;
+	return err < 0 ? ERR_PTR(err) : metabuf;
+}
+
 static struct z_erofs_compress_ictx g_ictx;
 
 #ifdef EROFS_MT_ENABLED
@@ -2066,7 +2116,6 @@ int erofs_begin_compress_dir(struct erofs_importer *im,
 
 int erofs_write_compress_dir(struct erofs_inode *inode, struct erofs_vfile *vf)
 {
-	void *compressmeta;
 	int err;
 
 	if (inode->datalayout != EROFS_INODE_COMPRESSED_FULL ||
@@ -2081,13 +2130,8 @@ int erofs_write_compress_dir(struct erofs_inode *inode, struct erofs_vfile *vf)
 	err = erofs_fragment_commit(inode, ~0);
 	if (err)
 		return err;
-
-	compressmeta = calloc(1, Z_EROFS_LEGACY_MAP_HEADER_SIZE);
-	if (!compressmeta)
-		return -ENOMEM;
-	*(__le64 *)compressmeta =
-		cpu_to_le64(inode->fragmentoff | 1ULL << 63);
-	inode->compressmeta = compressmeta;
+	DBG_BUGON(inode->fragment_size != inode->i_size);
+	DBG_BUGON(inode->compressmeta);
 	return 0;
 }
 
diff --git a/lib/inode.c b/lib/inode.c
index 2cd7bed..4f6b961 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -925,9 +925,15 @@ int erofs_iflush(struct erofs_inode *inode)
 		if (inode->datalayout == EROFS_INODE_CHUNK_BASED) {
 			ret = erofs_write_chunk_indexes(inode, ibmgr->vf, off);
 		} else {	/* write compression metadata */
+			char *metabuf;
+
 			off = roundup(off, 8);
-			ret = erofs_io_pwrite(ibmgr->vf, inode->compressmeta,
+			metabuf = z_erofs_write_metadata(inode);
+			if (IS_ERR(metabuf))
+				return PTR_ERR(metabuf);
+			ret = erofs_io_pwrite(ibmgr->vf, metabuf,
 					      off, inode->extent_isize);
+			free(metabuf);
 		}
 		if (ret != inode->extent_isize)
 			return ret < 0 ? ret : -EIO;
diff --git a/lib/liberofs_compress.h b/lib/liberofs_compress.h
index da6eb1a..7ca1f86 100644
--- a/lib/liberofs_compress.h
+++ b/lib/liberofs_compress.h
@@ -19,6 +19,7 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 				    struct erofs_inode *inode);
 void erofs_bind_compressed_file_with_fd(struct z_erofs_compress_ictx *ictx,
 					int fd, u64 fpos);
+char *z_erofs_write_metadata(struct erofs_inode *inode);
 int erofs_begin_compressed_file(struct z_erofs_compress_ictx *ictx);
 int erofs_write_compressed_file(struct z_erofs_compress_ictx *ictx);
 
-- 
2.47.3


