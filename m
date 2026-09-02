Return-Path: <linux-erofs+bounces-4411-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB81C624D0
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 02:52:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZS202K1Hz2yfH;
	Wed, 02 Sep 2026 12:52:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788317544;
	cv=none; b=kSI0cFre98pH+wzAtkUSAtc6hRmjD1cJK+UCtNVfNhV6ZUgobXw//cmNg6bKHQ6lofo0Kwt7Bc7is58Zz7CjqWRBjyH+NQZTvCVtROn9A0pEMXROc8PKJyB53cCxzGaKrFTwJuUXY8m9VGrkxuzHrXFS+E4qO8DPOZAOT6iu6DzG4zGDOc1bEd9KHptiOkt0ka9joWhKx7UBR1AXH9Jlp3VKv9iUf1moK2nHfD4etWaAd86Odwkg15gStvPeKd+3sHZwyLR04dkHmnezZX+0PoFjjKDjoFbMB7glysWYqbjjKacQpCTb2mDXqKr46s0MnqsK+OtuC3I/P31E8uKBUw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788317544; c=relaxed/relaxed;
	bh=nDIA4ijc/CEWUyiq9lyUopnMNqkwYSHs3wkuws4VqOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV5iUoBN+Opp/b0onKRevC9bryPDr3nKWHOlPrXJZh8vUy6Bc8ySoRr8k9XnKXRvYkUacxZ2XAtBg4yVC49EObZ03pGgPebA35vtbQjeqKyQdJgTA9lASlbWtw70b99BGkO+YeXwKquFewr3RAY2OhZyWAMnIwLbqJC8aKB6ZImGP6dtfaBSegZ+WByVtLpSL+4c3F/RO2eiaJ39JS/0r6wcbGg70iWHjWuIrtvOl4aN4GGO68Kh135Q/FiVQWn+YM6asW9wDPACjXYVLH5i41WuGgmFXFGt8vgmUoRLm7gNqKQ61pBW34PBxJ4KnQxwCIjFRfCXP5eKI9yDMG/UXg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQmD2smd; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQmD2smd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZS1z2ZZNz2x9g
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 12:52:23 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC98B43FCE;
	Wed,  2 Sep 2026 02:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BE51F00A3F;
	Wed,  2 Sep 2026 02:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788317541;
	bh=nDIA4ijc/CEWUyiq9lyUopnMNqkwYSHs3wkuws4VqOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQmD2smdc3Il7uWuXUKr5dLoWOdP+qwDT93NZLB+28qapfBsKpB7N4CUBl7J0aYDW
	 YqG66fgtMVlW3lEBVvodmwo59mbTli85AXquWoWGsF2QdyE7uNnCcssObhxmvoMKb6
	 CjUyPxiIFmHjZsl4FPceAgMMvqICQ+CeDHpfA0bJ/o0SGE4E18qBHFLBl1yL0Z2Upe
	 /ad/lR4+knU5B+fIvCDFSf5GDDE8cRS55RKV5nWsHcK9Bn6A6epntNuemdmFezpJbh
	 43sJeEE1oIh68Kx/zKxUg3+4qsy+KhDctMfdwMrrb0aOn41lOXBJS8RQjJ2uxuWXaS
	 8BGpvaWcxV4nQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 5/5] erofs-utils: mkfs: enable `--blobdev` for flat inode layouts
Date: Wed,  2 Sep 2026 10:50:30 +0800
Message-ID: <20260902025031.50499-5-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902025031.50499-1-xiang@kernel.org>
References: <20260902025031.50499-1-xiang@kernel.org>
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

Add metadata-only image support for PLAIN/INLINE inode layouts:
 $ mkfs.erofs --blobdev blob.erofs fsmeta.erofs foo/

Follow-up: add `--blobdev` support for compressed inode layouts.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/inode.h    |  2 +-
 include/erofs/internal.h |  1 +
 lib/blobchunk.c          | 12 ----------
 lib/importer.c           |  5 +++++
 lib/inode.c              | 48 ++++++++++++++++++++++++----------------
 lib/liberofs_chunk.h     |  1 -
 lib/remotes/s3.c         |  2 +-
 lib/super.c              | 37 ++++++++++++++++++++-----------
 lib/tar.c                |  2 +-
 mkfs/main.c              | 24 ++++++++------------
 10 files changed, 71 insertions(+), 63 deletions(-)

diff --git a/include/erofs/inode.h b/include/erofs/inode.h
index bf089e8..23848e8 100644
--- a/include/erofs/inode.h
+++ b/include/erofs/inode.h
@@ -39,7 +39,7 @@ int erofs_iflush(struct erofs_inode *inode);
 struct erofs_dentry *erofs_d_alloc(struct erofs_inode *parent,
 				   const char *name);
 int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
-				 bool in_metazone);
+				 int device_id);
 bool erofs_dentry_is_wht(struct erofs_sb_info *sbi, struct erofs_dentry *d);
 int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 		       struct stat *st, const char *path);
diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 95f5627..4d09c58 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -461,6 +461,7 @@ void erofs_put_super(struct erofs_sb_info *sbi);
 int erofs_writesb(struct erofs_sb_info *sbi);
 struct erofs_buffer_head *erofs_reserve_sb(struct erofs_bufmgr *bmgr);
 int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices);
+int erofs_update_all_devices(struct erofs_sb_info *sbi);
 int erofs_write_device_table(struct erofs_sb_info *sbi);
 int erofs_enable_sb_chksum(struct erofs_sb_info *sbi, u32 *crc);
 int erofs_superblock_csum_verify(struct erofs_sb_info *sbi);
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 3a641f3..47a0c05 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -554,18 +554,6 @@ int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset)
 	return 0;
 }
 
-int erofs_mkfs_dump_blobs(struct erofs_sb_info *sbi)
-{
-	struct erofs_device_info *di;
-
-	for (di = sbi->devs; di < sbi->devs + sbi->extra_devices; ++di) {
-		if (!di->bmgr)
-			continue;
-		di->blocks = erofs_mapbh(di->bmgr, NULL);
-	}
-	return 0;
-}
-
 static int erofs_insert_zerochunk(struct erofs_chunkmgr *cmgr,
 				  unsigned int cbitsdef)
 {
diff --git a/lib/importer.c b/lib/importer.c
index 2a635d2..89d4d8b 100644
--- a/lib/importer.c
+++ b/lib/importer.c
@@ -127,6 +127,11 @@ int erofs_importer_flush_all(struct erofs_importer *im)
 	fsalignblks = im->params->fsalignblks ?
 		roundup_pow_of_two(im->params->fsalignblks) : 1;
 	sbi->dif0.blocks = roundup(erofs_mapbh(sbi->bmgr, NULL), fsalignblks);
+
+	err = erofs_update_all_devices(sbi);
+	if (err)
+		return err;
+
 	err = erofs_write_device_table(sbi);
 	if (err)
 		return err;
diff --git a/lib/inode.c b/lib/inode.c
index a3fc181..b3aa066 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -198,26 +198,33 @@ struct erofs_dentry *erofs_d_alloc(struct erofs_inode *parent,
 
 /* allocate main data for an inode */
 int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
-				 bool in_metazone)
+				 int device_id)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
-	struct erofs_bufmgr *bmgr = in_metazone ?
+	struct erofs_bufmgr *bmgr = device_id ?
 		erofs_metadata_bmgr(sbi, false) : sbi->bmgr;
 	struct erofs_buffer_head *bh;
 	int ret, type;
 
+	if (device_id < 0)
+		bmgr = erofs_metadata_bmgr(sbi, false);
+	else if (!device_id)
+		bmgr = sbi->bmgr;
+	else
+		bmgr = sbi->devs[device_id - 1].bmgr;
+
+	if (!bmgr) {
+		erofs_err("cannot allocate data in unavailable device %d for %s",
+			  device_id, inode->i_srcpath);
+		return -EINVAL;
+	}
+
 	if (!nblocks) {
 		/* it has only tail-end data */
 		inode->u.i_blkaddr = EROFS_NULL_ADDR;
 		return 0;
 	}
 
-	if (in_metazone && !bmgr) {
-		erofs_err("cannot allocate data in the metazone when unavailable for %s",
-			  inode->i_srcpath);
-		return -EINVAL;
-	}
-
 	/* allocate main data buffer */
 	type = S_ISDIR(inode->i_mode) ? DIRA : DATA;
 	bh = erofs_balloc(bmgr, type, erofs_pos(sbi, nblocks), 0);
@@ -232,8 +239,10 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
 	DBG_BUGON(ret < 0);
 
 	/* write blocks except for the tail-end block */
-	inode->u.i_blkaddr = bh->block->blkaddr | (in_metazone ?
-		(sbi->extra_devices + 1ULL) << EROFS_I_BLKADDR_DEV_ID_BIT : 0);
+	if (device_id < 0)
+		device_id = sbi->extra_devices + 1;
+	inode->u.i_blkaddr = bh->block->blkaddr |
+		((u64)device_id << EROFS_I_BLKADDR_DEV_ID_BIT);
 	return 0;
 }
 
@@ -604,7 +613,7 @@ int erofs_write_file_from_buffer(struct erofs_inode *inode, char *buf)
 
 	inode->datalayout = EROFS_INODE_FLAT_INLINE;
 
-	ret = erofs_allocate_inode_bh_data(inode, nblocks, false);
+	ret = erofs_allocate_inode_bh_data(inode, nblocks, 0);
 	if (ret)
 		return ret;
 
@@ -635,7 +644,7 @@ static bool erofs_file_is_compressible(struct erofs_importer *im,
 
 static int erofs_write_unencoded_data(struct erofs_inode *inode,
 				      struct erofs_vfile *vf, erofs_off_t fpos,
-				      bool noseek, bool in_metazone)
+				      bool noseek, int device_id)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
 	struct erofs_buffer_head *bh;
@@ -646,7 +655,7 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 
 	if (!noseek && erofs_sb_has_48bit(sbi)) {
 		if (erofs_io_lseek(vf, fpos, SEEK_DATA) == -ENXIO) {
-			ret = erofs_allocate_inode_bh_data(inode, 0, false);
+			ret = erofs_allocate_inode_bh_data(inode, 0, 0);
 			if (ret)
 				return ret;
 			inode->datalayout = EROFS_INODE_FLAT_PLAIN;
@@ -663,7 +672,7 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 	remaining = inode->i_size - inode->idata_size;
 
 	ret = erofs_allocate_inode_bh_data(inode, remaining >> sbi->blkszbits,
-					   in_metazone);
+					   device_id);
 	if (ret)
 		return ret;
 
@@ -724,13 +733,14 @@ static int erofs_write_unencoded_file(const struct erofs_importer *im,
 	if (inode->datasource == EROFS_INODE_DATA_SOURCE_REBUILD_BLOB) {
 		if (erofs_io_lseek(&vf, fpos, SEEK_SET) != (off_t)fpos)
 			return -EIO;
-		return erofs_write_unencoded_data(inode, &vf, fpos, true, false);
+		return erofs_write_unencoded_data(inode, &vf, fpos, true, device_id);
 	}
 
 	inode->datalayout = EROFS_INODE_FLAT_INLINE;
 	/* fallback to all data uncompressed */
 	return erofs_write_unencoded_data(inode, &vf, fpos,
-			inode->datasource == EROFS_INODE_DATA_SOURCE_DISKBUF, false);
+			inode->datasource == EROFS_INODE_DATA_SOURCE_DISKBUF,
+			device_id);
 }
 
 static int erofs_write_dir_file(const struct erofs_importer *im,
@@ -749,7 +759,7 @@ static int erofs_write_dir_file(const struct erofs_importer *im,
 	} else {
 		DBG_BUGON(dir->idata_size != (dir->i_size & (bsz - 1)));
 		err = erofs_write_unencoded_data(dir, vf, 0, true,
-					im->params->dirdata_in_metazone);
+				im->params->dirdata_in_metazone ? -1 : 0);
 	}
 	erofs_io_close(vf);
 	return err;
@@ -1135,7 +1145,7 @@ static int erofs_write_tail_end(struct erofs_importer *im,
 				params->dirdata_in_metazone;
 
 			ret = erofs_allocate_inode_bh_data(inode, 1,
-							   in_metazone);
+					in_metazone ? -1 : params->ddev_id_def);
 			if (ret)
 				return ret;
 			bh = inode->bh_data;
@@ -2412,7 +2422,7 @@ struct erofs_inode *erofs_mkfs_build_special_from_fd(struct erofs_importer *im,
 	ret = erofs_write_unencoded_data(inode,
 			&(struct erofs_vfile){ .fd = fd }, 0,
 			inode->datasource == EROFS_INODE_DATA_SOURCE_DISKBUF,
-			false);
+			0);
 	if (ret)
 		return ERR_PTR(ret);
 out:
diff --git a/lib/liberofs_chunk.h b/lib/liberofs_chunk.h
index ff31891..16f3d05 100644
--- a/lib/liberofs_chunk.h
+++ b/lib/liberofs_chunk.h
@@ -24,7 +24,6 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 				  erofs_off_t startoff, int device_id);
 int erofs_write_zero_inode(struct erofs_inode *inode);
 int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset);
-int erofs_mkfs_dump_blobs(struct erofs_sb_info *sbi);
 int erofs_blob_init(struct erofs_sb_info *sbi, unsigned int chunkbits_zero);
 int erofs_blob_init_device(struct erofs_sb_info *sbi, int device_id);
 int erofs_chunkmgr_exit(struct erofs_sb_info *sbi);
diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index b3352df..56ab808 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -1058,7 +1058,7 @@ static int s3erofs_remote_getobject(struct erofs_importer *im,
 		inode->idata_size = 0;
 		ret = erofs_allocate_inode_bh_data(inode,
 				DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits),
-				false);
+				im->params->ddev_id_def);
 		if (ret)
 			return ret;
 		resp.vf = &sbi->bdev;
diff --git a/lib/super.c b/lib/super.c
index 9e52dd8..2bb22ac 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -414,15 +414,30 @@ int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
 	return 0;
 }
 
+int erofs_update_all_devices(struct erofs_sb_info *sbi)
+{
+	struct erofs_device_info *di;
+	erofs_blk_t last_uniaddr = sbi->dif0.blocks;
+
+	for (di = sbi->devs; di < sbi->devs + sbi->extra_devices; ++di) {
+		if (di->bmgr)
+			di->blocks = erofs_mapbh(di->bmgr, NULL);
+		di->uniaddr = last_uniaddr;
+		last_uniaddr += di->blocks;
+	}
+	sbi->total_blocks = last_uniaddr;
+	return 0;
+}
+
 int erofs_write_device_table(struct erofs_sb_info *sbi)
 {
-	erofs_blk_t nblocks = sbi->dif0.blocks;
 	struct erofs_buffer_head *bh = sbi->bh_devt;
+	struct erofs_device_info *di = sbi->devs;
 	erofs_off_t pos;
-	unsigned int i, ret;
+	unsigned int ret;
 
 	if (!sbi->extra_devices)
-		goto out;
+		return 0;
 	if (!bh) {
 		if (erofs_sb_has_device_table(sbi))
 			return 0;
@@ -435,28 +450,24 @@ int erofs_write_device_table(struct erofs_sb_info *sbi)
 		return -EINVAL;
 	}
 
-	i = 0;
 	do {
 		struct erofs_deviceslot dis = {
-			.uniaddr_lo = cpu_to_le32(nblocks),
-			.blocks_lo = cpu_to_le32(sbi->devs[i].blocks),
-			.blocks_hi = cpu_to_le16(sbi->devs[i].blocks >> 32),
-			.uniaddr_hi = cpu_to_le16(nblocks >> 32),
+			.uniaddr_lo = cpu_to_le32(di->uniaddr),
+			.blocks_lo = cpu_to_le32(di->blocks),
+			.blocks_hi = cpu_to_le16(di->blocks >> 32),
+			.uniaddr_hi = cpu_to_le16(di->uniaddr >> 32),
 		};
 
-		memcpy(dis.tag, sbi->devs[i].tag, sizeof(dis.tag));
+		memcpy(dis.tag, di->tag, sizeof(dis.tag));
 		ret = erofs_dev_write(sbi, &dis, pos, sizeof(dis));
 		if (ret)
 			return ret;
 		pos += sizeof(dis);
-		nblocks += sbi->devs[i].blocks;
-	} while (++i < sbi->extra_devices);
+	} while (++di < sbi->devs + sbi->extra_devices);
 
 	bh->op = &erofs_drop_directly_bhops;
 	erofs_bdrop(bh, false);
 	sbi->bh_devt = NULL;
-out:
-	sbi->total_blocks = nblocks;
 	return 0;
 }
 
diff --git a/lib/tar.c b/lib/tar.c
index cbe9f40..f027532 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -691,7 +691,7 @@ static int tarerofs_write_uncompressed_file(struct erofs_inode *inode,
 	inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 	nblocks = DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits);
 
-	ret = erofs_allocate_inode_bh_data(inode, nblocks, false);
+	ret = erofs_allocate_inode_bh_data(inode, nblocks, 0);
 	if (ret)
 		return ret;
 
diff --git a/mkfs/main.c b/mkfs/main.c
index 6b32e90..4acfb9a 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1508,11 +1508,6 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		}
 	}
 
-	if (mkfscfg.blobdev_path && mkfscfg.chunkbits < mkfs_blkszbits) {
-		erofs_err("--blobdev must be used together with --chunksize");
-		return -EINVAL;
-	}
-
 	/* TODO: can be implemented with (deviceslot) mapped_blkaddr */
 	if (mkfscfg.blobdev_path &&
 	    cfg.c_force_chunkformat == FORCE_INODE_BLOCK_MAP) {
@@ -1533,6 +1528,11 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		err = mkfs_parse_sources(argc, argv, optind);
 		if (err)
 			return err;
+
+		if (mkfscfg.blobdev_path && source_mode == EROFS_MKFS_SOURCE_REBUILD) {
+			erofs_err("--blobdev is currently incompatible with rebuild mode");
+			return -EINVAL;
+		}
 	} else if (source_mode != EROFS_MKFS_SOURCE_TAR) {
 		erofs_err("missing argument: SOURCE(s)");
 		return -EINVAL;
@@ -1925,10 +1925,7 @@ int main(int argc, char **argv)
 				  erofs_strerror(err));
 			goto exit;
 		}
-	}
-
-	if (tar_index_512b || mkfscfg.chunkbits) {
-		if (g_sbi.extra_devices && mkfscfg.blobdev_path) {
+		if (mkfscfg.blobdev_path) {
 			g_sbi.devs[0].src_path = strdup(mkfscfg.blobdev_path);
 			if (!g_sbi.devs[0].src_path) {
 				err = -ENOMEM;
@@ -1941,6 +1938,9 @@ int main(int argc, char **argv)
 
 		}
 		importer_params.ddev_id_def = mkfscfg.blobdev_path ? 1 : 0;
+	}
+
+	if (tar_index_512b || mkfscfg.chunkbits) {
 		err = erofs_blob_init(&g_sbi, mkfscfg.chunkbits);
 		if (err)
 			goto exit;
@@ -2051,12 +2051,6 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (erofstar.index_mode || mkfscfg.chunkbits || g_sbi.extra_devices) {
-		err = erofs_mkfs_dump_blobs(&g_sbi);
-		if (err)
-			goto exit;
-	}
-
 	err = erofs_importer_flush_all(&importer);
 	if (err)
 		goto exit;
-- 
2.47.3


