Return-Path: <linux-erofs+bounces-4745-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E729CCA490
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Oct 2026 02:31:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j65QX40P6z30Sx;
	Sat, 17 Oct 2026 13:31:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792204260;
	cv=none; b=RBUA2R5+dcEECydwbmmtgH730FAW54/rJdcl7jlErZKu4huOwmy0GFOUOZf9lEAOM/KsUKRkSIpvimsaUzfxu09YgE3X+cSUbJbvKRjPedLkYeP9tEJWi5fwzqHj3XZwNdXya7/5IZKkDJANI7qU8ROcfAXW3Rwnj7mVL4ylVjPMCBLi2jrEcTbIv6cjd9qfo87qW9p7DHlF2aJXlEMFRVd0lI/wihKgIM5Hk9rAniBNWfgsyl1WhoHuHJAXgux3jXCK4HqVsqFoWG3BIIU0twmdT5xDbsmWo36M44n9uVsVbmex9oPwCKGuDXn++4JN+7OT58UKpu2hUqv73aK3GA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792204260; c=relaxed/relaxed;
	bh=vDFZfFeh8MW7h24p6NGDgKKpgB35iNrZFUAZBOP4lPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cjc/2nJSitYfsyQto72Elhqnijj9GJ2cUR79MU5hmfCe9lUN9IddIRULDBoZkNycPxLoDtl1EF11fLXbeI1LVAeHRI87JoOA9y9XyTPRlxFIYMAm6hKET2FB4KDVkN5NtaHF6TYog45Gb0AytBdvPmUP3I4pBuqhyj7KfxzxT+WSj2p5teO06TUPZ/8XKp58tNpPg88G+Hb3ls1hstsyZXN15xOVR1FX8eAn7POL4Smi5NI6CKcCfLCTXjEflR6WdLswc4vSF2i+3Znna/6f7B2DTdUGYG2cULLuPf3KiuOiTYtzrTjxZxNZ8ycN7JtgOZw+1TmQOgmSqSMW9wJN8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ROvsnPhw; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ROvsnPhw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j65QW3SJKz2yqx
	for <linux-erofs@lists.ozlabs.org>; Sat, 17 Oct 2026 13:30:59 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C9C5401DA
	for <linux-erofs@lists.ozlabs.org>; Sat, 17 Oct 2026 02:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AB31F000C4;
	Sat, 17 Oct 2026 02:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792204255;
	bh=vDFZfFeh8MW7h24p6NGDgKKpgB35iNrZFUAZBOP4lPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROvsnPhwIMfG5y8ZQP4Uxm3Xz25BooeUfkiQE3JQdTBvV9YkNOMeFzDIlwZ/TCwMY
	 gcId42gF6aS7HOZAWhk81c6LqZsfanzQxjvtIG96NVg1Fg9fNFq6M+XPN5ordtwm2d
	 9zSvtr3HFwrkISJaerQbZasxj5bxRu6ZZ1ag0iD7p5Iox9uPSrvW7H5FG6PI7aG9CO
	 rSm4iBhRuPQ/m2VagkvqlBcM/8DJdvEyfFHQ7ByIlICUG/fxZrd37bW+0lqKjikhou
	 RAy8EsnaMrjFyrW+Ze3+4aGGmr90xSH0yBBJQWqA4cm3wH4AVjCqVzLFXWm8tBXk0X
	 9VpHGB3OkikDw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH v4] erofs: enable iomap for file-backed mounts on unencoded inodes
Date: Sat, 17 Oct 2026 04:30:03 +0200
Message-ID: <20261017023004.67445-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017002758.52193-1-xiang@kernel.org>
References: <20261017002758.52193-1-xiang@kernel.org>
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

Iomap supports non-bdev I/O through fs-provided callbacks since
commit b2f35ac4146d ("iomap: add caller-provided callbacks for read
and readahead"), making it suitable for file-backed mounts on unencoded
inodes.

Enable iomap for this case to support sub-folio buffered I/Os on
file-backed mounts and simplify the codebase.

Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
---
v4:
 - update i_blkbits of ishare inodes for sub-page block sizes found by sashiko.

 fs/erofs/data.c     |  29 ++++----
 fs/erofs/fileio.c   | 157 ++++++++++++++------------------------------
 fs/erofs/internal.h |  11 ++--
 fs/erofs/ishare.c   |   1 +
 4 files changed, 71 insertions(+), 127 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index a726be5e27ca..f09c152d5516 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -281,12 +281,6 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
 	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));
 }
 
-struct erofs_iomap_iter_ctx {
-	struct page *page;
-	void *base;
-	struct inode *realinode;
-};
-
 static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
@@ -308,6 +302,7 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	iomap->length = map.m_llen;
 	iomap->flags = 0;
 	iomap->addr = IOMAP_NULL_ADDR;
+	iomap->private = NULL;
 	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
 		iomap->type = IOMAP_HOLE;
 		return 0;
@@ -322,6 +317,7 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		if (ret)
 			return ret;
 
+		iomap->private = mdev.m_dif;
 		if (flags & IOMAP_DAX)
 			iomap->dax_dev = mdev.m_dif->dax_dev;
 		else
@@ -396,14 +392,16 @@ int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
  */
 static int erofs_read_folio(struct file *file, struct folio *folio)
 {
-	struct iomap_read_folio_ctx read_ctx = {
-		.ops		= &iomap_bio_read_ops,
-		.cur_folio	= folio,
-	};
 	bool need_iput;
 	struct erofs_iomap_iter_ctx iter_ctx = {
 		.realinode = erofs_real_inode(folio_inode(folio), &need_iput),
 	};
+	struct erofs_sb_info *sbi = EROFS_I_SB(iter_ctx.realinode);
+	struct iomap_read_folio_ctx read_ctx = {
+		.ops = erofs_is_fileio_mode(sbi) ?
+			&erofs_fileio_iomap_read_ops : &iomap_bio_read_ops,
+		.cur_folio = folio,
+	};
 
 	trace_erofs_read_folio(iter_ctx.realinode, folio, true);
 	iomap_read_folio(&erofs_iomap_ops, &read_ctx, &iter_ctx);
@@ -414,14 +412,16 @@ static int erofs_read_folio(struct file *file, struct folio *folio)
 
 static void erofs_readahead(struct readahead_control *rac)
 {
-	struct iomap_read_folio_ctx read_ctx = {
-		.ops		= &iomap_bio_read_ops,
-		.rac		= rac,
-	};
 	bool need_iput;
 	struct erofs_iomap_iter_ctx iter_ctx = {
 		.realinode = erofs_real_inode(rac->mapping->host, &need_iput),
 	};
+	struct erofs_sb_info *sbi = EROFS_I_SB(iter_ctx.realinode);
+	struct iomap_read_folio_ctx read_ctx = {
+		.ops = erofs_is_fileio_mode(sbi) ?
+			&erofs_fileio_iomap_read_ops : &iomap_bio_read_ops,
+		.rac = rac,
+	};
 
 	trace_erofs_readahead(iter_ctx.realinode, readahead_index(rac),
 			      readahead_count(rac), true);
@@ -457,7 +457,6 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return filemap_read(iocb, to, 0);
 }
 
-/* for uncompressed (aligned) files and raw access for other files */
 const struct address_space_operations erofs_aops = {
 	.read_folio = erofs_read_folio,
 	.readahead = erofs_readahead,
diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index ebb81a7ffd4c..c36a90a1a4cb 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2024, Alibaba Cloud
+ * Copyright 2026 Docker, Inc.
  */
 #include "internal.h"
 #include <trace/events/erofs.h>
@@ -30,7 +31,8 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 	if (!rq->bio.bi_end_io) {
 		bio_for_each_folio_all(fi, &rq->bio) {
 			DBG_BUGON(folio_test_uptodate(fi.folio));
-			erofs_onlinefolio_end(fi.folio, ret < 0, false);
+			iomap_finish_folio_read(fi.folio, fi.offset, fi.length,
+						ret < 0 ? ret : 0);
 		}
 	} else if (ret < 0 && !rq->bio.bi_status) {
 		rq->bio.bi_status = errno_to_blk_status(ret);
@@ -64,137 +66,76 @@ static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
 		kfree(rq);
 }
 
-static struct erofs_fileio_rq *erofs_fileio_rq_alloc(struct erofs_map_dev *mdev)
+static struct erofs_fileio_rq *erofs_fileio_rq_alloc(struct super_block *sb,
+						     struct file *file)
 {
 	struct erofs_fileio_rq *rq = kzalloc_obj(*rq, GFP_KERNEL | __GFP_NOFAIL);
 
 	bio_init(&rq->bio, NULL, rq->bvecs, ARRAY_SIZE(rq->bvecs), REQ_OP_READ);
-	rq->iocb.ki_filp = mdev->m_dif->file;
-	rq->sb = mdev->m_sb;
+	rq->iocb.ki_filp = file;
+	rq->sb = sb;
 	refcount_set(&rq->ref, 2);
 	return rq;
 }
 
 struct bio *erofs_fileio_bio_alloc(struct erofs_map_dev *mdev)
 {
-	return &erofs_fileio_rq_alloc(mdev)->bio;
+	return &erofs_fileio_rq_alloc(mdev->m_sb, mdev->m_dif->file)->bio;
 }
 
 void erofs_fileio_submit_bio(struct bio *bio)
 {
-	return erofs_fileio_rq_submit(container_of(bio, struct erofs_fileio_rq,
-						   bio));
+	erofs_fileio_rq_submit(container_of(bio, struct erofs_fileio_rq, bio));
 }
 
-static int erofs_fileio_scan_folio(struct erofs_fileio *io,
-				   struct inode *inode, struct folio *folio)
+static void erofs_fileio_iomap_submit_read(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx)
 {
-	struct erofs_map_blocks *map = &io->map;
-	unsigned int cur = 0, end = folio_size(folio), len, attached = 0;
-	loff_t pos = folio_pos(folio), ofs;
-	int err = 0;
-
-	erofs_onlinefolio_init(folio);
-	while (cur < end) {
-		if (!in_range(pos + cur, map->m_la, map->m_llen)) {
-			map->m_la = pos + cur;
-			map->m_llen = end - cur;
-			err = erofs_map_blocks(inode, map);
-			if (err)
-				break;
-		}
-
-		ofs = folio_pos(folio) + cur - map->m_la;
-		len = min_t(loff_t, map->m_llen - ofs, end - cur);
-		if (map->m_flags & EROFS_MAP_META) {
-			struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
-			void *src;
-
-			src = erofs_read_metabuf(&buf, inode->i_sb,
-				map->m_pa + ofs, erofs_inode_in_metabox(inode));
-			if (IS_ERR(src)) {
-				err = PTR_ERR(src);
-				break;
-			}
-			memcpy_to_folio(folio, cur, src, len);
-			erofs_put_metabuf(&buf);
-		} else if (!(map->m_flags & EROFS_MAP_MAPPED)) {
-			folio_zero_segment(folio, cur, cur + len);
-			attached = 0;
-		} else {
-			if (io->rq && (map->m_pa + ofs != io->dev.m_pa ||
-				       map->m_deviceid != io->dev.m_deviceid)) {
-io_retry:
-				erofs_fileio_rq_submit(io->rq);
-				io->rq = NULL;
-			}
-
-			if (!io->rq) {
-				io->dev = (struct erofs_map_dev) {
-					.m_pa = io->map.m_pa + ofs,
-					.m_deviceid = io->map.m_deviceid,
-				};
-				err = erofs_map_dev(inode->i_sb, &io->dev);
-				if (err)
-					break;
-				io->rq = erofs_fileio_rq_alloc(&io->dev);
-				io->rq->bio.bi_iter.bi_sector =
-					(io->dev.m_dif->fsoff + io->dev.m_pa) >> 9;
-				attached = 0;
-			}
-			if (!bio_add_folio(&io->rq->bio, folio, len, cur))
-				goto io_retry;
-			if (!attached++)
-				erofs_onlinefolio_split(folio);
-			io->dev.m_pa += len;
-		}
-		cur += len;
-	}
-	erofs_onlinefolio_end(folio, err, false);
-	return err;
+	erofs_fileio_rq_submit((struct erofs_fileio_rq *)ctx->read_ctx);
+	ctx->read_ctx = NULL;
 }
 
-static int erofs_fileio_read_folio(struct file *file, struct folio *folio)
+static int erofs_fileio_iomap_read_folio_range(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx, size_t plen)
 {
-	bool need_iput;
-	struct inode *realinode = erofs_real_inode(folio_inode(folio), &need_iput);
-	struct erofs_fileio io = {};
-	int err;
-
-	trace_erofs_read_folio(realinode, folio, true);
-	err = erofs_fileio_scan_folio(&io, realinode, folio);
-	erofs_fileio_rq_submit(io.rq);
-	if (need_iput)
-		iput(realinode);
-	return err;
+	struct erofs_iomap_iter_ctx *iter_ctx = iter->private;
+	struct folio *folio = ctx->cur_folio;
+	struct erofs_fileio_rq *rq = ctx->read_ctx;
+	sector_t sector = iomap_sector(&iter->iomap, iter->pos);
+
+	if (!rq || bio_end_sector(&rq->bio) != sector ||
+	    !bio_add_folio(&rq->bio, folio, plen,
+			   offset_in_folio(folio, iter->pos))) {
+		struct super_block *sb = iter_ctx->realinode->i_sb;
+		struct erofs_device_info *dif = iter->iomap.private;
+
+		/* submit the existing range if there was one. */
+		if (ctx->read_ctx)
+			erofs_fileio_iomap_submit_read(iter, ctx);
+		rq = erofs_fileio_rq_alloc(sb, dif->file);
+		rq->bio.bi_iter.bi_sector = sector;
+		bio_add_folio_nofail(&rq->bio, folio, plen,
+				offset_in_folio(folio, iter->pos));
+		ctx->read_ctx = rq;
+		ctx->read_ctx_file_offset = iter->pos;
+	}
+	return 0;
 }
 
-static void erofs_fileio_readahead(struct readahead_control *rac)
+const struct iomap_read_ops erofs_fileio_iomap_read_ops = {
+	.read_folio_range	= erofs_fileio_iomap_read_folio_range,
+	.submit_read		= erofs_fileio_iomap_submit_read,
+};
+
+static void erofs_fileio_meta_endio(struct bio *bio)
 {
-	bool need_iput;
-	struct inode *realinode = erofs_real_inode(rac->mapping->host, &need_iput);
-	struct erofs_fileio io = {};
-	struct folio *folio;
-	int err;
+	bool uptodate = !bio->bi_status;
+	struct folio_iter fi;
 
-	trace_erofs_readahead(realinode, readahead_index(rac),
-			      readahead_count(rac), true);
-	while ((folio = readahead_folio(rac))) {
-		err = erofs_fileio_scan_folio(&io, realinode, folio);
-		if (err && err != -EINTR)
-			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
-				  folio->index, EROFS_I(realinode)->nid);
-	}
-	erofs_fileio_rq_submit(io.rq);
-	if (need_iput)
-		iput(realinode);
+	bio_for_each_folio_all(fi, bio)
+		folio_end_read(fi.folio, uptodate);
 }
 
-const struct address_space_operations erofs_fileio_aops = {
-	.read_folio = erofs_fileio_read_folio,
-	.readahead = erofs_fileio_readahead,
-};
-
 int erofs_read_meta_folio(struct file *file, struct folio *folio)
 {
 	struct erofs_fileio io = {
@@ -207,10 +148,10 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
 	if (err)
 		return err;
 
-	io.rq = erofs_fileio_rq_alloc(&io.dev);
+	io.rq = erofs_fileio_rq_alloc(inode->i_sb, io.dev.m_dif->file);
+	io.rq->bio.bi_end_io = erofs_fileio_meta_endio;
 	io.rq->bio.bi_iter.bi_sector =
 		(io.dev.m_dif->fsoff + io.dev.m_pa) >> 9;
-	erofs_onlinefolio_init(folio);
 	bio_add_folio_nofail(&io.rq->bio, folio, folio_size(folio), 0);
 	erofs_fileio_rq_submit(io.rq);
 	return 0;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index da58053c1116..924b37e06e1c 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -380,7 +380,6 @@ struct erofs_map_dev {
 
 extern const struct super_operations erofs_sops;
 extern const struct address_space_operations erofs_aops;
-extern const struct address_space_operations erofs_fileio_aops;
 extern const struct address_space_operations z_erofs_aops;
 
 extern const struct inode_operations erofs_generic_iops;
@@ -392,7 +391,14 @@ extern const struct file_operations erofs_file_fops;
 extern const struct file_operations erofs_dir_fops;
 extern const struct file_operations erofs_ishare_fops;
 
+struct erofs_iomap_iter_ctx {
+	struct page *page;
+	void *base;
+	struct inode *realinode;
+};
+
 extern const struct iomap_ops z_erofs_iomap_report_ops;
+extern const struct iomap_read_ops erofs_fileio_iomap_read_ops;
 
 int erofs_setup_managed_cache(struct super_block *sb);
 #ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
@@ -450,9 +456,6 @@ erofs_get_aops(struct inode *realinode)
 			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
 		return &z_erofs_aops;
 	}
-	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) &&
-	    erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
-		return &erofs_fileio_aops;
 	return &erofs_aops;
 }
 
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index a1cf2aff8d32..8db5d35c0989 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -54,6 +54,7 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 		si->i_mapping->a_ops = aops;
 		si->i_mode = 0444 | S_IFREG;
 		si->i_size = inode->i_size;
+		si->i_blkbits = inode->i_blkbits;
 		mapping_set_large_folios(si->i_mapping);
 		unlock_new_inode(si);
 	} else {
-- 
2.47.3


