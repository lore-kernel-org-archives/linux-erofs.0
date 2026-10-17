Return-Path: <linux-erofs+bounces-4742-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5377DCCA46C
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Oct 2026 00:28:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j62jd1fw1z2yVL;
	Sat, 17 Oct 2026 11:28:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792196933;
	cv=none; b=nVCYo+Z++xIjKgaWHXgiIEFH8A9kiMWk+D/cYU4Ttqv43kuBP99VCfSFBsCfkb7eaRUbSJ7MGsYqOStiEmh7me2RSHNTVlrKfPHW8n/sVqswFKZXfJ+dm3W8zSj1o00LVY7RG/BX0xAZa8PXHIsqcKFbO6EWX1CjzoWsqpuZvymAZeDP8NqK5Lv3BR13xW+KShKHn76L3FUIDEYKc7Lke0MoPvCs5Ja2PVlt9teS3J8x+CpnSmz+fsDn2caCrCAcb/OkdY+l8wNIMaC9MF8Gu1kf/EBflPRfvhdu81KjtxaPQEqQ1csfbRBxKgj93Zz4fhBaRbywIvcaUggt2ne7rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792196933; c=relaxed/relaxed;
	bh=GnbkRq1p0p88yP86RNOTbQA93+fATu/eBciwdGfzIqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CBhcryxXWJt0v5f0yeg3VqccGLo6TIohc7NOMdysU/F3rc5QIZuDq7liwpXF20ck95Tsu3WJmMNw0kAbH6qzY7pWf0XDFrpFXHDlFgxbO6A7PlkGqmKCU109s10WeqWznrg0YG9jPR55moUoywYtO6jglC8+phDhf6fRA8WISCyUQBtMf+8spUPCdiVr0F0thiosTm3z9ChvcnP5VApEN4rn6LqqKaQQShczN4i1qL0sJmMw/6Z3+3ROCfXPxN+GyeazET50ZBq4RUEB4OLORVdWsm4GvqTfjv2kJRzfcuCK80YaJ45bq41FWoOTyjWeqANQem8a4yNVgeHlQJm86Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HNB/ne0y; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HNB/ne0y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j62jb6c6wz2yPq
	for <linux-erofs@lists.ozlabs.org>; Sat, 17 Oct 2026 11:28:51 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F7FC60A8C
	for <linux-erofs@lists.ozlabs.org>; Sat, 17 Oct 2026 00:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2878F1F000C4;
	Sat, 17 Oct 2026 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792196928;
	bh=GnbkRq1p0p88yP86RNOTbQA93+fATu/eBciwdGfzIqw=;
	h=From:To:Cc:Subject:Date;
	b=HNB/ne0ynZAsc3Yp5slqsCpcDoSC5yEk2xaZ1F/jYJAg77R0U6WChsWFxdwiZn2tr
	 WF3p2DPN2p0ZspqDNhiVJYOuqc/4Eit8k44E2pdoCFCpfCmOtJx54KA3Tsb7Wn/LhK
	 QC3kHeUOXsLcXtSYBecZvN+82aqkaMSJ8OHejQnP5MeP34g/nUaiaYuoOPAGKvAnPf
	 z/rSu2g+e/78caazcadi3VZDAXTjSqpuzuIUoSCzRVOfw1kHAf61NeNoxv879gKW2T
	 52L2jUhvS9rJMuGMkCyozO/MorE663iOrF+pPXUxjRidS8d076xxrjqi9w4EWfzj7G
	 s2ywWtl4kIEOA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs: enable iomap for file-backed mounts on unencoded inodes
Date: Sat, 17 Oct 2026 02:27:58 +0200
Message-ID: <20261017002758.52193-1-xiang@kernel.org>
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

Iomap supports non-bdev I/O through fs-provided callbacks since
commit b2f35ac4146d ("iomap: add caller-provided callbacks for read
and readahead"), making it suitable for file-backed mounts on unencoded
inodes.

Enable iomap for this case to support sub-folio buffered I/Os on
file-backed mounts and simplify the codebase.

Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
---
 fs/erofs/data.c     |  23 ++++---
 fs/erofs/fileio.c   | 144 ++++++++++++--------------------------------
 fs/erofs/internal.h |   5 +-
 3 files changed, 53 insertions(+), 119 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index a726be5e27ca..fd09dc2ae3b7 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -308,6 +308,7 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	iomap->length = map.m_llen;
 	iomap->flags = 0;
 	iomap->addr = IOMAP_NULL_ADDR;
+	iomap->private = NULL;
 	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
 		iomap->type = IOMAP_HOLE;
 		return 0;
@@ -322,6 +323,7 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		if (ret)
 			return ret;
 
+		iomap->private = mdev.m_dif;
 		if (flags & IOMAP_DAX)
 			iomap->dax_dev = mdev.m_dif->dax_dev;
 		else
@@ -396,14 +398,16 @@ int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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
@@ -414,14 +418,16 @@ static int erofs_read_folio(struct file *file, struct folio *folio)
 
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
@@ -457,7 +463,6 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return filemap_read(iocb, to, 0);
 }
 
-/* for uncompressed (aligned) files and raw access for other files */
 const struct address_space_operations erofs_aops = {
 	.read_folio = erofs_read_folio,
 	.readahead = erofs_readahead,
diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index ebb81a7ffd4c..aa5a80cec41c 100644
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
@@ -64,135 +65,66 @@ static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
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
+	struct erofs_fileio_rq *rq = ctx->read_ctx;
 
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
+	erofs_fileio_rq_submit(rq);
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
-}
-
-static void erofs_fileio_readahead(struct readahead_control *rac)
-{
-	bool need_iput;
-	struct inode *realinode = erofs_real_inode(rac->mapping->host, &need_iput);
-	struct erofs_fileio io = {};
-	struct folio *folio;
-	int err;
-
-	trace_erofs_readahead(realinode, readahead_index(rac),
-			      readahead_count(rac), true);
-	while ((folio = readahead_folio(rac))) {
-		err = erofs_fileio_scan_folio(&io, realinode, folio);
-		if (err && err != -EINTR)
-			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
-				  folio->index, EROFS_I(realinode)->nid);
+	struct folio *folio = ctx->cur_folio;
+	struct erofs_fileio_rq *rq = ctx->read_ctx;
+
+	if (!rq ||
+	    !bio_add_folio(&rq->bio, folio, plen,
+			   offset_in_folio(folio, iter->pos))) {
+		struct super_block *sb = iter->inode->i_sb;
+		const struct iomap *iomap = &iter->iomap;
+		struct erofs_device_info *dif = iomap->private;
+
+		/* submit the existing range if there was one. */
+		if (ctx->read_ctx)
+			erofs_fileio_iomap_submit_read(iter, ctx);
+		rq = erofs_fileio_rq_alloc(sb, dif->file);
+		rq->bio.bi_iter.bi_sector = iomap_sector(iomap, iter->pos);
+		bio_add_folio_nofail(&rq->bio, folio, plen,
+				offset_in_folio(folio, iter->pos));
+		ctx->read_ctx = rq;
+		ctx->read_ctx_file_offset = iter->pos;
 	}
-	erofs_fileio_rq_submit(io.rq);
-	if (need_iput)
-		iput(realinode);
+	return 0;
 }
 
-const struct address_space_operations erofs_fileio_aops = {
-	.read_folio = erofs_fileio_read_folio,
-	.readahead = erofs_fileio_readahead,
+const struct iomap_read_ops erofs_fileio_iomap_read_ops = {
+	.read_folio_range	= erofs_fileio_iomap_read_folio_range,
+	.submit_read		= erofs_fileio_iomap_submit_read,
 };
 
 int erofs_read_meta_folio(struct file *file, struct folio *folio)
@@ -207,7 +139,7 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
 	if (err)
 		return err;
 
-	io.rq = erofs_fileio_rq_alloc(&io.dev);
+	io.rq = erofs_fileio_rq_alloc(inode->i_sb, io.dev.m_dif->file);
 	io.rq->bio.bi_iter.bi_sector =
 		(io.dev.m_dif->fsoff + io.dev.m_pa) >> 9;
 	erofs_onlinefolio_init(folio);
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index da58053c1116..666c7294a0f3 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -380,7 +380,6 @@ struct erofs_map_dev {
 
 extern const struct super_operations erofs_sops;
 extern const struct address_space_operations erofs_aops;
-extern const struct address_space_operations erofs_fileio_aops;
 extern const struct address_space_operations z_erofs_aops;
 
 extern const struct inode_operations erofs_generic_iops;
@@ -393,6 +392,7 @@ extern const struct file_operations erofs_dir_fops;
 extern const struct file_operations erofs_ishare_fops;
 
 extern const struct iomap_ops z_erofs_iomap_report_ops;
+extern const struct iomap_read_ops erofs_fileio_iomap_read_ops;
 
 int erofs_setup_managed_cache(struct super_block *sb);
 #ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
@@ -450,9 +450,6 @@ erofs_get_aops(struct inode *realinode)
 			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
 		return &z_erofs_aops;
 	}
-	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) &&
-	    erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
-		return &erofs_fileio_aops;
 	return &erofs_aops;
 }
 
-- 
2.47.3


