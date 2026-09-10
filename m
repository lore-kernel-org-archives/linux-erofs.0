Return-Path: <linux-erofs+bounces-4528-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC24C79F9F
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Sep 2026 11:59:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hgbp12hLjz2xjM;
	Thu, 10 Sep 2026 21:59:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789041593;
	cv=none; b=TrgefXXvAtMOrp6TU92JmRkobn4py+2fziw36tmkT/PbHSsFwIChxEFwB46LxhZLF6L/2EgVuU/bI/eY5t4e4Seg1Lv+ic/u3PubUcHoMxgor/KYFyt82EIFECYpYz8F07SEVOUrraj9wHdqfx6EhE8/YXqhjxp0xPst+6D0ZTqVrlrgOHPdOM7vcEXTqJADSLUQyAw9JH3oatoL0kXiubiRv/wIdASFa5iUBez5BfYWC7IVIBSxSIs6Vz1ojOoLtxtUMbl9xSzB7OuOvGzrSGeRz4KI46Iyivjt5CNkzjyGiPMmOR+2WUSSy9+bXQtIltz5odTo0LQxMmOyFGk8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789041593; c=relaxed/relaxed;
	bh=XJyIufYUiRZELEI+Rw2ehjJhsQDzahzgWthOe9i4BR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKYel+KBFOkmVSfRbYcUKaocfsTCj2PQOxc+21fDDWjLDD4uyGw55VcUU0L+8QqX1kleJR0n5++dw+qfhUBkOG6TjWoO4AFYmoeQwWXERz/TJD6T4ivslDNV3vdRJXKAlupwVjezH80spQXCYybncDGCHkQiHhHSO/Yk7IXYQfEqINTW751z6krbyBkXTQxgKq4Rj7TfEyIY9ZZbMnqm7WAsNkeng4ebtIJ0kPjT4KC1VftNADoniKsVgoAlyrUTv9AQcT851nTFD6Q0dB+nY1wUaWasFrn74gcmcDikgvOv8U15mhjbC1/9Ga6XCo+tcIT7SvKaFrYDZSIJaWy79Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOC7KKO5; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOC7KKO5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hgbny6LyJz2xLq
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 21:59:50 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 784AE413C2
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 11:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987981F000FF;
	Thu, 10 Sep 2026 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789041586;
	bh=XJyIufYUiRZELEI+Rw2ehjJhsQDzahzgWthOe9i4BR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOC7KKO5lrIKd4jhEFHxXh2Kb9DhCMbPGIAyW/r1Or1i9ZHGcQcB6H1YFEwtnN7lA
	 7hdi0zB+OUW4mRY9xjWMeqZ/INqGdDr/WPM5e8SPjjxQ2lif0tHQjxD+hNz6OeHJ0r
	 VWlbyBMAMfDd6eOzk+ZjgxaAzMMJR8hqhwxnqkJXkoV15n6842MQG/DQ4cxprW+iT3
	 twkovyGrmA/VbXr7KcjL3Gzjdq25aGW1r26a45tlvwKgAqH0Lh9ETuGJ0w+ML4mL5E
	 dUdnNC3ImKupOGvWi2Ct9sMFJqZ9CyBG3lB5t9KyGaa3oWZ2JK3/OeVnacZtcICUGG
	 3b3PWIpzjMYLA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH 2/2] erofs-utils: mkfs: enable `--blobdev` for compressed inode layouts
Date: Thu, 10 Sep 2026 19:58:52 +0800
Message-ID: <20260910115852.149572-2-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910115852.149572-1-xiang@kernel.org>
References: <20260910115852.149572-1-xiang@kernel.org>
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

Add metadata-only image support for compressed inode layouts, e.g.:
 $ mkfs.erofs -zlz4 --blobdev blob.erofs fsmeta.erofs foo/

Note that `-Efragments` and `-Ededupe` haven't supported yet.

Follow-up: support rebuild mode for compressed inode layouts.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/dedupe.h   |  1 +
 include/erofs/internal.h | 12 ++-----
 lib/compress.c           | 67 +++++++++++++++++++++++++++++-----------
 lib/data.c               | 16 ++++++++++
 lib/inode.c              |  5 +--
 lib/super.c              |  6 ++--
 lib/tar.c                |  2 +-
 lib/xattr.c              |  2 +-
 8 files changed, 77 insertions(+), 34 deletions(-)

diff --git a/include/erofs/dedupe.h b/include/erofs/dedupe.h
index 267d9b9..14dd7dc 100644
--- a/include/erofs/dedupe.h
+++ b/include/erofs/dedupe.h
@@ -16,6 +16,7 @@ struct z_erofs_inmem_extent {
 	erofs_off_t pstart;
 	unsigned int plen;
 	unsigned int length;
+	unsigned short device_id;
 	bool raw, partial, inlined;
 };
 
diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 0de71fb..3ca5553 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -513,6 +513,8 @@ static inline int erofs_get_occupied_size(const struct erofs_inode *inode,
 }
 
 /* data.c */
+int erofs_dev_write(struct erofs_sb_info *sbi, int device_id,
+		    const void *buf, u64 offset, size_t len);
 int erofs_getxattr(struct erofs_inode *vi, const char *name, char *buffer,
 		   size_t buffer_size);
 int erofs_listxattr(struct erofs_inode *vi, char *buffer, size_t buffer_size);
@@ -533,18 +535,10 @@ int erofs_blob_open_ro(struct erofs_sb_info *sbi, const char *dev);
 ssize_t erofs_dev_read(struct erofs_sb_info *sbi, int device_id,
 		       void *buf, u64 offset, size_t len);
 
-static inline int erofs_dev_write(struct erofs_sb_info *sbi, const void *buf,
-				  u64 offset, size_t len)
-{
-	if (erofs_io_pwrite(&sbi->bdev, buf, offset, len) != (ssize_t)len)
-		return -EIO;
-	return 0;
-}
-
 static inline int erofs_blk_write(struct erofs_sb_info *sbi, const void *buf,
 				  erofs_blk_t blkaddr, u32 nblocks)
 {
-	return erofs_dev_write(sbi, buf, erofs_pos(sbi, blkaddr),
+	return erofs_dev_write(sbi, 0, buf, erofs_pos(sbi, blkaddr),
 			       erofs_pos(sbi, nblocks));
 }
 
diff --git a/lib/compress.c b/lib/compress.c
index bcb064f..956bf80 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -51,6 +51,7 @@ struct z_erofs_compress_ictx {		/* inode context */
 	/* fields for write indexes */
 	u8 *metacur;
 	struct list_head extents;
+	u16 device_id;
 	u16 clusterofs;
 	int seg_num;
 	u32 max_compressed_extent_size;
@@ -174,6 +175,7 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 	unsigned int d0 = 0, d1 = (clusterofs + count) >> bbits;
 	struct z_erofs_lcluster_index di;
 	unsigned int type, advise;
+	erofs_blk_t blkaddr;
 
 	DBG_BUGON(!count);
 	DBG_BUGON(e->pstart & (BIT(bbits) - 1));
@@ -192,10 +194,14 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 			Z_EROFS_LCLUSTER_TYPE_HEAD1;
 		di.di_advise = cpu_to_le16(type);
 
-		if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL && !e->plen)
+		if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL && !e->plen) {
 			di.di_u.blkaddr = cpu_to_le32(inode->fragmentoff >> 32);
-		else
-			di.di_u.blkaddr = cpu_to_le32(e->pstart >> bbits);
+		} else {
+			blkaddr = e->pstart >> bbits;
+			if (e->device_id)
+				blkaddr += sbi->devs[e->device_id - 1].uniaddr;
+			di.di_u.blkaddr = cpu_to_le32(blkaddr);
+		}
 		memcpy(ctx->metacur, &di, sizeof(di));
 		ctx->metacur += sizeof(di);
 
@@ -237,10 +243,14 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 				Z_EROFS_LCLUSTER_TYPE_HEAD1;
 
 			if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL &&
-			    !e->plen)
+			    !e->plen) {
 				di.di_u.blkaddr = cpu_to_le32(inode->fragmentoff >> 32);
-			else
-				di.di_u.blkaddr = cpu_to_le32(e->pstart >> bbits);
+			} else {
+				blkaddr = e->pstart >> bbits;
+				if (e->device_id)
+					blkaddr += sbi->devs[e->device_id - 1].uniaddr;
+				di.di_u.blkaddr = cpu_to_le32(blkaddr);
+			}
 
 			if (e->partial) {
 				DBG_BUGON(e->raw);
@@ -257,7 +267,7 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 
 		++d0;
 		--d1;
-	} while (clusterofs + count >= 1 << bbits);
+	} while (clusterofs + count >= (1 << bbits));
 
 	ctx->clusterofs = clusterofs + count;
 }
@@ -396,6 +406,8 @@ static int write_uncompressed_block(struct z_erofs_compress_sctx *ctx,
 	struct erofs_sb_info *sbi = inode->sbi;
 	unsigned int count = min(erofs_blksiz(sbi), len);
 	unsigned int interlaced_offset, rightpart;
+	unsigned int device_id = ctx->ictx->device_id;
+	unsigned int bs = erofs_blksiz(sbi);
 	int ret;
 
 	/* write interlaced uncompressed data if needed */
@@ -417,7 +429,7 @@ static int write_uncompressed_block(struct z_erofs_compress_sctx *ctx,
 	} else {
 		erofs_dbg("Writing %u uncompressed data to %llu", count,
 			  ctx->pstart | 0ULL);
-		ret = erofs_dev_write(sbi, dst, ctx->pstart, erofs_blksiz(sbi));
+		ret = erofs_dev_write(sbi, device_id, dst, ctx->pstart, bs);
 		if (ret)
 			return ret;
 	}
@@ -454,6 +466,7 @@ static int write_uncompressed_extents(struct z_erofs_compress_sctx *ctx,
 			.plen = round_up(count, erofs_blksiz(inode->sbi)),
 			.raw = true,
 			.pstart = ctx->pstart,
+			.device_id = ctx->ictx->device_id,
 		};
 		if (ctx->pstart != EROFS_NULL_ADDR)
 			ctx->pstart += ei->e.plen;
@@ -586,6 +599,7 @@ static int __z_erofs_compress_one(struct z_erofs_compress_sctx *ctx,
 	bool may_inline = (params->ztailpacking && !data_unaligned && tsg &&
 			   final && !may_packing);
 	unsigned int compressedsize;
+	int device_id = ictx->device_id;
 	int ret;
 
 	DBG_BUGON(ctx->pivot);
@@ -736,8 +750,8 @@ frag_packing:
 			erofs_dbg("Writing %u compressed data to %llu of %u bytes",
 				  e->length, ctx->pstart, e->plen);
 
-			ret = erofs_dev_write(sbi, dst - padding, ctx->pstart,
-					      e->plen);
+			ret = erofs_dev_write(sbi, device_id, dst - padding,
+					      ctx->pstart, e->plen);
 			if (ret)
 				return ret;
 		}
@@ -750,6 +764,7 @@ frag_packing:
 	e->pstart = ctx->pstart;
 	if (ctx->pstart != EROFS_NULL_ADDR)
 		ctx->pstart += e->plen;
+	e->device_id = device_id;
 	if (!may_inline && !may_packing && !is_packed_inode)
 		(void)z_erofs_dedupe_insert(e, ctx->queue + ctx->head);
 	ctx->head += e->length;
@@ -1183,6 +1198,7 @@ static void z_erofs_write_extents(struct erofs_inode *inode,
 				  struct list_head *extents, u8 *metabuf)
 {
 	unsigned int recsz = z_erofs_extent_recsize(inode->z_advise);
+	struct erofs_sb_info *sbi = inode->sbi;
 	struct z_erofs_extent_item *ei, *n;
 	erofs_off_t pstart, lstart;
 	unsigned int moff;
@@ -1205,16 +1221,22 @@ static void z_erofs_write_extents(struct erofs_inode *inode,
 	list_for_each_entry_safe(ei, n, extents, list) {
 		struct z_erofs_extent de;
 		u32 fmt, plen;
+		int devid;
 
 		plen = ei->e.plen;
 		if (!plen) {
 			plen = inode->fragmentoff;
-			ei->e.pstart = inode->fragmentoff >> 32;
+			pstart = inode->fragmentoff >> 32;
 		} else {
 			fmt = ei->e.raw ? 0 : inode->z_algorithmtype[0] + 1;
 			plen |= fmt << Z_EROFS_EXTENT_PLEN_FMT_BIT;
 			if (ei->e.partial)
 				plen |= Z_EROFS_EXTENT_PLEN_PARTIAL;
+			pstart = ei->e.pstart;
+			devid = ei->e.device_id;
+			if (devid)
+				pstart += (erofs_off_t)sbi->devs[devid - 1].uniaddr
+					<< sbi->blkszbits;
 		}
 		de = (struct z_erofs_extent) {
 			.plen = cpu_to_le32(plen),
@@ -1453,6 +1475,8 @@ char *z_erofs_write_metadata(struct erofs_inode *inode)
 	DBG_BUGON(list_empty(&mctx->extents));
 	ei = list_first_entry(&mctx->extents, struct z_erofs_extent_item, list);
 	pstart = ei->e.pstart;
+	if (ei->e.device_id)
+		pstart += sbi->devs[ei->e.device_id - 1].uniaddr << sbi->blkszbits;
 
 	list_for_each_entry_safe(ei, n, &mctx->extents, list) {
 		DBG_BUGON(ei->list.next != &mctx->extents &&
@@ -1657,8 +1681,8 @@ int z_erofs_merge_segment(struct z_erofs_compress_ictx *ictx,
 		}
 		erofs_dbg("Writing %u %scompressed data of %s to %llu", ei->e.length,
 			  ei->e.raw ? "un" : "", ictx->inode->i_srcpath, ei->e.pstart);
-		ret2 = erofs_dev_write(sbi, sctx->membuf + off, ei->e.pstart,
-				       ei->e.plen);
+		ret2 = erofs_dev_write(sbi, ei->e.device_id, sctx->membuf + off,
+				       ei->e.pstart, ei->e.plen);
 		off += ei->e.plen;
 		if (ret2)
 			ret = ret2;
@@ -1751,9 +1775,11 @@ int erofs_mt_write_compressed_file(struct z_erofs_compress_ictx *ictx)
 	struct erofs_buffer_head *bh = NULL;
 	struct erofs_compress_work *head = ictx->mtworks, *cur;
 	erofs_off_t pstart, ptotal = 0;
+	struct erofs_bufmgr *bmgr = ictx->device_id ?
+		sbi->devs[ictx->device_id - 1].bmgr : sbi->bmgr;
 	int ret;
 
-	bh = erofs_balloc(sbi->bmgr, DATA, 0, 0);
+	bh = erofs_balloc(bmgr, DATA, 0, 0);
 	if (IS_ERR(bh)) {
 		ret = PTR_ERR(bh);
 		goto out;
@@ -1910,6 +1936,11 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 	}
 	ictx->im = im;
 	ictx->inode = inode;
+	ictx->device_id = !params->fragments && !params->dedupe &&
+		!erofs_is_packed_inode(inode) &&
+		!erofs_is_metabox_inode(inode) &&
+		params->ddev_id_def && S_ISREG(inode->i_mode) ?
+		params->ddev_id_def : 0;
 	if (erofs_is_metabox_inode(inode))
 		ictx->ccfg = &sbi->zmgr->ccfg[cfg.c_mkfs_metabox_algid];
 	else
@@ -2161,7 +2192,7 @@ static int z_erofs_build_compr_cfgs(struct erofs_importer *im,
 			return PTR_ERR(bh);
 		}
 		erofs_mapbh(NULL, bh->block);
-		ret = erofs_dev_write(sbi, &lz4alg, erofs_btell(bh, false),
+		ret = erofs_dev_write(sbi, 0, &lz4alg, erofs_btell(bh, false),
 				      sizeof(lz4alg));
 		bh->op = &erofs_drop_directly_bhops;
 	}
@@ -2185,7 +2216,7 @@ static int z_erofs_build_compr_cfgs(struct erofs_importer *im,
 			return PTR_ERR(bh);
 		}
 		erofs_mapbh(NULL, bh->block);
-		ret = erofs_dev_write(sbi, &lzmaalg, erofs_btell(bh, false),
+		ret = erofs_dev_write(sbi, 0, &lzmaalg, erofs_btell(bh, false),
 				      sizeof(lzmaalg));
 		bh->op = &erofs_drop_directly_bhops;
 	}
@@ -2209,7 +2240,7 @@ static int z_erofs_build_compr_cfgs(struct erofs_importer *im,
 			return PTR_ERR(bh);
 		}
 		erofs_mapbh(NULL, bh->block);
-		ret = erofs_dev_write(sbi, &zalg, erofs_btell(bh, false),
+		ret = erofs_dev_write(sbi, 0, &zalg, erofs_btell(bh, false),
 				      sizeof(zalg));
 		bh->op = &erofs_drop_directly_bhops;
 	}
@@ -2232,7 +2263,7 @@ static int z_erofs_build_compr_cfgs(struct erofs_importer *im,
 			return PTR_ERR(bh);
 		}
 		erofs_mapbh(NULL, bh->block);
-		ret = erofs_dev_write(sbi, &zalg, erofs_btell(bh, false),
+		ret = erofs_dev_write(sbi, 0, &zalg, erofs_btell(bh, false),
 				      sizeof(zalg));
 		bh->op = &erofs_drop_directly_bhops;
 	}
diff --git a/lib/data.c b/lib/data.c
index fa2907b..c73cbe3 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -8,8 +8,24 @@
 #include "erofs/internal.h"
 #include "erofs/trace.h"
 #include "erofs/decompress.h"
+#include "liberofs_cache.h"
 #include "liberofs_fragments.h"
 
+int erofs_dev_write(struct erofs_sb_info *sbi, int device_id,
+		    const void *buf, u64 offset, size_t len)
+{
+	ssize_t ret;
+
+	ret = erofs_io_pwrite(device_id ?
+				sbi->devs[device_id - 1].bmgr->vf : &sbi->bdev,
+			      buf, offset, len);
+	if (ret < 0)
+		return ret;
+	if (ret != (ssize_t)len)
+		return -EIO;
+	return 0;
+}
+
 void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 {
 	struct erofs_sb_info *sbi = buf->sbi;
diff --git a/lib/inode.c b/lib/inode.c
index 4f6b961..6fd92cd 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -511,7 +511,7 @@ static int erofs_rebuild_inode_fix_pnid(struct erofs_inode *parent,
 
 		if (!fixed)
 			continue;
-		err = erofs_dev_write(dir.sbi, buf,
+		err = erofs_dev_write(dir.sbi, 0, buf,
 			(off + bsz > dir.i_size &&
 				dir.datalayout == EROFS_INODE_FLAT_INLINE ?
 				erofs_iloc(&dir) + isz : boff + off), count);
@@ -2488,7 +2488,8 @@ int erofs_fixup_root_inode(struct erofs_inode *root)
 		return -ENOMEM;
 	err = erofs_dev_read(sbi, 0, ibuf, erofs_iloc(root), ondisk_size);
 	if (err >= 0)
-		err = erofs_dev_write(sbi, ibuf, erofs_iloc(&oi), ondisk_size);
+		err = erofs_dev_write(sbi, 0, ibuf, erofs_iloc(&oi),
+				      ondisk_size);
 	free(ibuf);
 	return err;
 }
diff --git a/lib/super.c b/lib/super.c
index 1358101..71b9f4f 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -270,7 +270,7 @@ int erofs_writesb(struct erofs_sb_info *sbi)
 	}
 	memcpy(buf + EROFS_SUPER_OFFSET, &sb, sbi->sb_size);
 
-	ret = erofs_dev_write(sbi, buf, sb_bh ? erofs_btell(sb_bh, false) : 0,
+	ret = erofs_dev_write(sbi, 0, buf, sb_bh ? erofs_btell(sb_bh, false) : 0,
 			      EROFS_SUPER_OFFSET + sbi->sb_size);
 	free(buf);
 	if (sb_bh)
@@ -352,7 +352,7 @@ int erofs_enable_sb_chksum(struct erofs_sb_info *sbi, u32 *crc)
 	/* set up checksum field to erofs_super_block */
 	sb->checksum = cpu_to_le32(*crc);
 
-	ret = erofs_dev_write(sbi, buf, EROFS_SUPER_OFFSET, len);
+	ret = erofs_dev_write(sbi, 0, buf, EROFS_SUPER_OFFSET, len);
 	if (ret) {
 		erofs_err("failed to write checksummed superblock: %s",
 			  erofs_strerror(ret));
@@ -460,7 +460,7 @@ int erofs_write_device_table(struct erofs_sb_info *sbi)
 		};
 
 		memcpy(dis.tag, di->tag, sizeof(dis.tag));
-		ret = erofs_dev_write(sbi, &dis, pos, sizeof(dis));
+		ret = erofs_dev_write(sbi, 0, &dis, pos, sizeof(dis));
 		if (ret)
 			return ret;
 		pos += sizeof(dis);
diff --git a/lib/tar.c b/lib/tar.c
index f027532..f24ad95 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -705,7 +705,7 @@ static int tarerofs_write_uncompressed_file(struct erofs_inode *inode,
 				ret = -EIO;
 			break;
 		}
-		if (erofs_dev_write(sbi, buf,
+		if (erofs_dev_write(sbi, 0, buf,
 				    erofs_pos(sbi, inode->u.i_blkaddr) + pos,
 				    ret)) {
 			ret = -EIO;
diff --git a/lib/xattr.c b/lib/xattr.c
index af45075..3cf8c79 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1055,7 +1055,7 @@ int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *pa
 	xamgr->shared_xattrs = sorted_n[0];
 	free(sorted_n);
 	bh->op = &erofs_drop_directly_bhops;
-	ret = erofs_dev_write(sbi, buf, erofs_btell(bh, false), shared_xattrs_size);
+	ret = erofs_dev_write(sbi, 0, buf, erofs_btell(bh, false), shared_xattrs_size);
 	free(buf);
 	erofs_bdrop(bh, false);
 	return ret;
-- 
2.47.3


