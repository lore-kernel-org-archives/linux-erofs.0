Return-Path: <linux-erofs+bounces-4465-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3A8C624A4
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 07:57:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbBly3wV4z2yth;
	Thu, 03 Sep 2026 17:57:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::635"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788422270;
	cv=none; b=Yb6HNKu3Bx7xcqElo4BI7Zbx1vbc2a/UF1zSdj6QVYhxxIthn+2yvv/UvmwDAn7Unz7vVflzoQriQLDlrOQzGkl8zr0ToshKCYCO1h97KeSFsH85SRissyefM/WQJZCCgrr7n8PQ+zMY8GEOzxynoyHlYNvzR/VPwsk6X41XutLkNQxN6PBMfo2nlpHNrO8y5XLtxRb2ZhVfmBZ+lWL9/w926T3JeNM7HMT0pP1+0tzlc7Hz/h/8iAQcxHIsCwaL1MRBhFVIWR+zjSnL02oJkfjUPxXYjYykzihy0tvZ8iBqp/SsqKlXiRalvBytL8zDt0JZ3fp/qYduMEH2lqCFbA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788422270; c=relaxed/relaxed;
	bh=Gw/umm7tHENtSub+pGACDpts0inv1zMKKIWoW2NANGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al/eKm/EhkF/9ttgn6Yds7/upDOf1leAyIi27/rAvZaFGRjf26OG9tAds3CzUkbNoTMDqT/KWsLrK24ebA4rnwFBBVzeP566mNrXrHuDmopFBMo2kUS/tcfKGMb1gwc5RxS95luEafYSrs7piAMIu2+Ggx3CzeTOlM/2T4GDOwn+AFUL4BdZMj/vR8XaCvzlCD0brCtdk5Cjdtv7Kh3Uci6/7MwRaUgQ7hYMMe295RejT7xvGYiRAH2JJUrtE3yxQ2fSPTX5ys2kEERlbOzLpM7CyeSXFnijc4gO+/zHE9rcODYBz2CWapXRyv0izSrN78z9i5zitdQeAJtTDZXTeg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AEFuezr/; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AEFuezr/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbBlw2vnyz2yrF
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 17:57:47 +1000 (AEST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-2d9520b9155so19442565ad.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 00:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788422265; x=1789027065; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gw/umm7tHENtSub+pGACDpts0inv1zMKKIWoW2NANGM=;
        b=AEFuezr/z/XXuUr0+e8tUaUO9SVOPVLl81XkP6ujWfnFY5qRk2Ncq/bzQFb6yvOafm
         5nO08t5Eh+wYl0oJ+ev//IVSiBTTcZuw+TeFHrGjtiPHvCoTjvO3dSEdZOkD/QrhkQzu
         DxMz7gVNjN9CN/dBvFYVCCyTwU4oB4UnLhNDTzhTCyXd+2bgct/+/1CYAE/NDQjtqO+E
         jgSHW6Vufs0UDLn0paznpDrSSmZweKR/k6ERa3v8zfsnROIEq+vnZjpYKZhEPmqTyCdg
         QcubZXCN2MxZTTb+xLe+BzMkxrqwxZq/806G2P/G2Zi3Zh045EMtAAF3o0Agm3BJCEsQ
         oOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788422265; x=1789027065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gw/umm7tHENtSub+pGACDpts0inv1zMKKIWoW2NANGM=;
        b=BcTHJO0c8fnflenHO1VR92D6eTSw/0iXAT6uGb6spZTg7ofw6SjSUq4kCnCZLcekHY
         PsYZzaJJBJtSR/NdoiP4UpqRNl3fsrH3t+phRkAdbKdkB3T83/hXnqt/tNSLhZiSPNfL
         aGFygHjx8bhYE5+FdKIJvGtntnPLu/UZyvghxaroUrHc5tYVFY1zFqr2pErxtX/b8exy
         kuB78U9IIFQhcrm8L7JGMQwmNqwfJqEHJjJvEQEN7tVKMsa76Fwkezqd0QCwWyBwppiZ
         mrb/yw8SQSzaQddBP4cJcgU4PjH/eCDrk9p0EghqdPUfx8ncMnrrDX6QOTxuDNz2WCHj
         WjVw==
X-Gm-Message-State: AFuF++mwpV0Im50fhx6PL/wo8p0sqmJtfFAkS/EOSTp0/Iql9newPQ39
	EKSjJmptxG5dKicGJ5Nn/xNfqMDhYeYcjX5mpWKJ4nxB9IOPVFWKecYD1bqjQD/VOxg=
X-Gm-Gg: AYBFou1zBRJGBfc72WKjECqxrD0pgvM+z9qRrANkOb+BZi1FrWlpBv6wF6OZGQAvCQT
	LlylHon5q/k+nFsaHPYBNRrLK1hA2KBWsngClu5nj3BLjgcBX99KaHoFxkTRu98RzAimJnOcf7Q
	uwKlW7DR5tUwRsL798K8MQl/ptDXJsGtRtwOEmm9yg55uZy01u+whZ8ZdVtwASBHvwmyI93A+7h
	l+UeU92Ki54WulsRrk6On6wPG5o/lqEbWzNzmbEwtDKwSuNNX4CWohIWHFIBCph74FGvuaCNPDk
	U79E4QZ9HbQ6Fphguo6jSNGCDTqI3lOOe29BujZDPbNfsuqfQmVnaKaEi+I8wFAZ8vQHNF8eNFz
	QSzCUCtDq0on4hzfqTzp+ZOiJ9T07aHhtjxZjt35+FnUxjWKbzFrBxkqUZaEzY7/e4x3KgJ/M25
	0SmgCHykxm2ZU818rQOinxYi1hG3Tkklvk4/Zn3y7ruse5Habjk5vW38kIhY49UoHyCHXmSd7tI
	RrPhckmtU9du+ClkMoa0l/A51GUFtU6gZF2GAfx6TPeTz8Y1g==
X-Received: by 2002:a17:903:2290:b0:2d6:ffa1:429b with SMTP id d9443c01a7336-2daec62c280mr135204735ad.7.1788422264686;
        Thu, 03 Sep 2026 00:57:44 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db0b175f04sm189005ad.65.2026.09.03.00.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 00:57:44 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
Subject: [PATCH v3] erofs-utils: mkfs: enable `--blobdev` for flat inode layouts
Date: Thu,  3 Sep 2026 15:57:39 +0800
Message-ID: <20260903075739.288589-1-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902155333.57247-3-xiang@kernel.org>
References: <20260902155333.57247-3-xiang@kernel.org>
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

From: Gao Xiang <xiang@kernel.org>

Add metadata-only image support for PLAIN/INLINE inode layouts:
 $ mkfs.erofs --blobdev blob.erofs fsmeta.erofs foo/

Follow-up: add `--blobdev` support for compressed inode layouts.

Link: https://patch.msgid.link/20260902155333.57247-3-xiang@kernel.org
Signed-off-by: Gao Xiang <xiang@kernel.org>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
I would suggest v3 which disables three paths or combinations that
cannot currently work correctly:
- Flat `--blobdev` with `-m` or `--MZ=i` and no `--chunksize`.
- Direct S3 writes when inode data targets an extra device.
- The tar no-reorder fast path when inode data targets an extra device.

Interdiff against v2:
  diff --git a/lib/inode.c b/lib/inode.c
  index 24be613..d71a9d1 100644
  --- a/lib/inode.c
  +++ b/lib/inode.c
  @@ -201,8 +201,7 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
   				 int device_id)
   {
  	struct erofs_sb_info *sbi = inode->sbi;
  -	struct erofs_bufmgr *bmgr = device_id ?
  -		erofs_metadata_bmgr(sbi, false) : sbi->bmgr;
  +	struct erofs_bufmgr *bmgr;
  	struct erofs_buffer_head *bh;
  	int ret, type;
  
  diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
  index 56ab808..1f2a5e0 100644
  --- a/lib/remotes/s3.c
  +++ b/lib/remotes/s3.c
  @@ -1053,12 +1053,13 @@ static int s3erofs_remote_getobject(struct erofs_importer *im,
  		return -EIO;
  
  	resp.pos = 0;
  -	if (!sbi->available_compr_algs && im->params->no_datainline) {
  +	if (!sbi->available_compr_algs && im->params->no_datainline &&
  +	    !im->params->ddev_id_def) {
  		inode->datalayout = EROFS_INODE_FLAT_PLAIN;
  		inode->idata_size = 0;
  		ret = erofs_allocate_inode_bh_data(inode,
  				DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits),
  -				im->params->ddev_id_def);
  +				0);
  		if (ret)
  			return ret;
  		resp.vf = &sbi->bdev;
  diff --git a/lib/tar.c b/lib/tar.c
  index f027532..b979d5a 100644
  --- a/lib/tar.c
  +++ b/lib/tar.c
  @@ -1207,7 +1207,8 @@ new_inode:
  					ret = -EIO;
  			} else if (tar->try_no_reorder &&
  				   !sbi->available_compr_algs &&
  -				   params->no_datainline) {
  +				   params->no_datainline &&
  +				   !params->ddev_id_def) {
  				ret = tarerofs_write_uncompressed_file(inode, tar);
  			} else {
  				ret = tarerofs_write_file_data(inode, tar);
  diff --git a/mkfs/main.c b/mkfs/main.c
  index cfdffa5..3d1c5a7 100644
  --- a/mkfs/main.c
  +++ b/mkfs/main.c
  @@ -1903,6 +1903,12 @@ int main(int argc, char **argv)
  		erofs_err("Compression is not enabled.  Turn on chunk-based data deduplication instead.");
  		mkfscfg.chunkbits = g_sbi.blkszbits;
  	}
  +	if (mkfscfg.blobdev_path && !mkfscfg.chunkbits &&
  +	    (erofs_sb_has_metabox(&g_sbi) || mkfscfg.inode_metazone)) {
  +		erofs_err("--blobdev without --chunksize cannot be used with -m or --MZ=i");
  +		err = -EINVAL;
  +		goto exit;
  +	}
  	importer_params.chunkszbits_def = mkfscfg.chunkbits;
  	err = erofs_importer_init(&importer);
  	if (err)

 include/erofs/inode.h    |  2 +-
 include/erofs/internal.h |  1 +
 lib/blobchunk.c          | 12 ----------
 lib/importer.c           |  5 ++++
 lib/inode.c              | 49 ++++++++++++++++++++++++----------------
 lib/liberofs_chunk.h     |  1 -
 lib/remotes/s3.c         |  5 ++--
 lib/super.c              | 37 +++++++++++++++++++-----------
 lib/tar.c                |  5 ++--
 mkfs/main.c              | 30 ++++++++++++------------
 10 files changed, 81 insertions(+), 66 deletions(-)

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
index 5a90991..8f43dd0 100644
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
index a3fc181..d71a9d1 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -198,26 +198,32 @@ struct erofs_dentry *erofs_d_alloc(struct erofs_inode *parent,
 
 /* allocate main data for an inode */
 int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
-				 bool in_metazone)
+				 int device_id)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
-	struct erofs_bufmgr *bmgr = in_metazone ?
-		erofs_metadata_bmgr(sbi, false) : sbi->bmgr;
+	struct erofs_bufmgr *bmgr;
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
+		erofs_err("cannot allocate data on unavailable device %d for %s",
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
@@ -232,8 +238,10 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
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
 
@@ -604,7 +612,7 @@ int erofs_write_file_from_buffer(struct erofs_inode *inode, char *buf)
 
 	inode->datalayout = EROFS_INODE_FLAT_INLINE;
 
-	ret = erofs_allocate_inode_bh_data(inode, nblocks, false);
+	ret = erofs_allocate_inode_bh_data(inode, nblocks, 0);
 	if (ret)
 		return ret;
 
@@ -635,7 +643,7 @@ static bool erofs_file_is_compressible(struct erofs_importer *im,
 
 static int erofs_write_unencoded_data(struct erofs_inode *inode,
 				      struct erofs_vfile *vf, erofs_off_t fpos,
-				      bool noseek, bool in_metazone)
+				      bool noseek, int device_id)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
 	struct erofs_buffer_head *bh;
@@ -646,7 +654,7 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 
 	if (!noseek && erofs_sb_has_48bit(sbi)) {
 		if (erofs_io_lseek(vf, fpos, SEEK_DATA) == -ENXIO) {
-			ret = erofs_allocate_inode_bh_data(inode, 0, false);
+			ret = erofs_allocate_inode_bh_data(inode, 0, 0);
 			if (ret)
 				return ret;
 			inode->datalayout = EROFS_INODE_FLAT_PLAIN;
@@ -663,7 +671,7 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 	remaining = inode->i_size - inode->idata_size;
 
 	ret = erofs_allocate_inode_bh_data(inode, remaining >> sbi->blkszbits,
-					   in_metazone);
+					   device_id);
 	if (ret)
 		return ret;
 
@@ -724,13 +732,14 @@ static int erofs_write_unencoded_file(const struct erofs_importer *im,
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
@@ -749,7 +758,7 @@ static int erofs_write_dir_file(const struct erofs_importer *im,
 	} else {
 		DBG_BUGON(dir->idata_size != (dir->i_size & (bsz - 1)));
 		err = erofs_write_unencoded_data(dir, vf, 0, true,
-					im->params->dirdata_in_metazone);
+				im->params->dirdata_in_metazone ? -1 : 0);
 	}
 	erofs_io_close(vf);
 	return err;
@@ -1135,7 +1144,7 @@ static int erofs_write_tail_end(struct erofs_importer *im,
 				params->dirdata_in_metazone;
 
 			ret = erofs_allocate_inode_bh_data(inode, 1,
-							   in_metazone);
+					in_metazone ? -1 : params->ddev_id_def);
 			if (ret)
 				return ret;
 			bh = inode->bh_data;
@@ -2412,7 +2421,7 @@ struct erofs_inode *erofs_mkfs_build_special_from_fd(struct erofs_importer *im,
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
index b3352df..1f2a5e0 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -1053,12 +1053,13 @@ static int s3erofs_remote_getobject(struct erofs_importer *im,
 		return -EIO;
 
 	resp.pos = 0;
-	if (!sbi->available_compr_algs && im->params->no_datainline) {
+	if (!sbi->available_compr_algs && im->params->no_datainline &&
+	    !im->params->ddev_id_def) {
 		inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 		inode->idata_size = 0;
 		ret = erofs_allocate_inode_bh_data(inode,
 				DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits),
-				false);
+				0);
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
index cbe9f40..b979d5a 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -691,7 +691,7 @@ static int tarerofs_write_uncompressed_file(struct erofs_inode *inode,
 	inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 	nblocks = DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits);
 
-	ret = erofs_allocate_inode_bh_data(inode, nblocks, false);
+	ret = erofs_allocate_inode_bh_data(inode, nblocks, 0);
 	if (ret)
 		return ret;
 
@@ -1207,7 +1207,8 @@ new_inode:
 					ret = -EIO;
 			} else if (tar->try_no_reorder &&
 				   !sbi->available_compr_algs &&
-				   params->no_datainline) {
+				   params->no_datainline &&
+				   !params->ddev_id_def) {
 				ret = tarerofs_write_uncompressed_file(inode, tar);
 			} else {
 				ret = tarerofs_write_file_data(inode, tar);
diff --git a/mkfs/main.c b/mkfs/main.c
index 688e474..3d1c5a7 100644
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
@@ -1903,6 +1903,12 @@ int main(int argc, char **argv)
 		erofs_err("Compression is not enabled.  Turn on chunk-based data deduplication instead.");
 		mkfscfg.chunkbits = g_sbi.blkszbits;
 	}
+	if (mkfscfg.blobdev_path && !mkfscfg.chunkbits &&
+	    (erofs_sb_has_metabox(&g_sbi) || mkfscfg.inode_metazone)) {
+		erofs_err("--blobdev without --chunksize cannot be used with -m or --MZ=i");
+		err = -EINVAL;
+		goto exit;
+	}
 	importer_params.chunkszbits_def = mkfscfg.chunkbits;
 	err = erofs_importer_init(&importer);
 	if (err)
@@ -1926,10 +1932,7 @@ int main(int argc, char **argv)
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
@@ -1942,6 +1945,9 @@ int main(int argc, char **argv)
 
 		}
 		importer_params.ddev_id_def = mkfscfg.blobdev_path ? 1 : 0;
+	}
+
+	if (tar_index_512b || mkfscfg.chunkbits) {
 		err = erofs_blob_init(&g_sbi, mkfscfg.chunkbits);
 		if (err)
 			goto exit;
@@ -2052,12 +2058,6 @@ int main(int argc, char **argv)
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
2.55.0

