Return-Path: <linux-erofs+bounces-4570-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45981C88E77
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Sep 2026 07:42:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hl9nn1yy0z2yYf;
	Wed, 16 Sep 2026 17:42:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789544525;
	cv=none; b=OcH90t5MQJ23Exc3azRKoJfpNzNI9g4qr4MKWtCmy1k+iSWqas0HL0Md/jh+02pqauzz/NvEpC0nxpYELws6kQxn8q57AHZY3wBzyZ9GWgw2bmeFgX3m4+/ntc/NEVUOdTZzWFlGtjhgew/ZZuM8Psy8dr7Q1uT7X6mbn/WgBNR9RxUkkzY634XrPnh8kzviPxyG4p9FrOCaykVmz6Xu9sFTWZREzXF1S0XbDzJ9SvhRlMQTkRaDX+x59oOnuZVxN+6IgSlpDk5lOp3YtpqwRV30KAxExYXZVAOsjpu7qeQKvw3qhS/6l+HiH7PsonTQfVJbeSPk7ML4i9UlmYgVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789544525; c=relaxed/relaxed;
	bh=O6magiiDyzXVUiBbUPIkeZp+NDraoVTTdGuqEpgfVL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGcYc7Qg3PovCnfcxMwbUJoKEaGKOmAZVm/tcwpyYKOxAz4yqsO8ZvA+T0dSj0hhd/wHoWfNaiUPp9XGgc4qFQe4Ae6/v+3xxnOqoTGJMbpxaiJbkw+rGZisMvn8EFL625ooDCPwyz8WjfU4Tj+d1OMKKxZIr1KNhBhx8j+nEVY0m3gNCO64jx7waJQMfvpdhmn3slHmOMuIa2RzEuaYt5mh7GzOhO2PLoibHwvikSjfE6Hf1VD5/TdYSOOMRhmbq+Xu1npnKgaQ7YmEvvo4+ohXYNjehuQp3VEXVjdW9fLzavY66SdMhV04DL2UKdWOhyUZ6KuWUwEZXMfODiVAEw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RYgy6T7T; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RYgy6T7T;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hl9nm2KCtz2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 17:42:04 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B4FF42AFE;
	Wed, 16 Sep 2026 07:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF2D1F0089B;
	Wed, 16 Sep 2026 07:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789544522;
	bh=O6magiiDyzXVUiBbUPIkeZp+NDraoVTTdGuqEpgfVL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYgy6T7TT1ZN6P+aBDI9mSMcCm1yb7q4aW4ZoysCQoARuIRzcolm70k9+AHFXTzV8
	 zG6XrFvtnQfBPpOc9g3mpVQZ0fo9aW1MVZ3jE5vhTt6JIqqi+8OIlxXmmc6TN7TGNx
	 uUusuT+3aa71tWGkCz6rGaF9fPWLUxDRaJmo54VDg4LGBDMSQN9oOJ8HSVizdYU/x0
	 RMpMHAnCOpM4SaQW9Imanoo9/yVHIa0+j/aw+RWVmcGR07o6dNnIiPFWc91JyDZouw
	 Qcl90MvBBH22xqfjVSYytSaL1hOUQ2edPznFl/Z29b3ET5P1XOHE33/x3Kem50l/Sf
	 LbPbrqMeUBQtQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Jonathan Calmels <jcalmels@nvidia.com>
Subject: [PATCH v3 4/4] erofs-utils: mkfs: support rebuild mode for compressed inodes
Date: Wed, 16 Sep 2026 15:41:01 +0800
Message-ID: <20260916074101.66357-4-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916074101.66357-1-xiang@kernel.org>
References: <20260916074101.66357-1-xiang@kernel.org>
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

Add support for generating a meta-only multidev manifest image with
an overlayfs-like merged tree from multiple compressed EROFS images:

 $ mkfs.erofs -zlz4 -Enoinline_data layerA.erofs layerA/
 $ mkfs.erofs -zlz4 -Enoinline_data layerB.erofs layerB/
 $ mkfs.erofs -zlz4 fsmeta.erofs layerA.erofs layerB.erofs
 # mount -t erofs \
	-odevice=layerA.erofs,device=layerB.erofs
	fsmeta.erofs mnt/

Note that `-Efragments` is not yet supported: it needs further
userspace development.

Cc: Jonathan Calmels <jcalmels@nvidia.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/compress.c | 145 ++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/inode.c    |  18 ++++--
 lib/rebuild.c  |  29 +++++++++-
 3 files changed, 186 insertions(+), 6 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index cda138f..8305543 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1269,11 +1269,36 @@ int z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
 	int err;
 
 	inode->z_advise &= ~Z_EROFS_ADVISE_INLINE_PCLUSTER;
+	ei = list_last_entry(&ctx->extents, struct z_erofs_extent_item, list);
+	if (!inode->bh_data) {
+		struct erofs_buffer_head *bh;
+
+		bh = erofs_balloc(sbi->bmgr, DATA, 0, 0);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+
+		bh->op = &erofs_skip_write_bhops;
+		inode->bh_data = bh;
+		err = erofs_mapbh(NULL, bh->block);
+		if (err < 0) {
+			DBG_BUGON(1);
+			return err;
+		}
+		inode->lazy_tailblock = false;
+		inode->bh_data = bh;
+		ei->e.device_id = 0;
+		ei->e.pstart = erofs_btell(bh, false);
+		if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT) {
+			inode->datalayout = EROFS_INODE_COMPRESSED_FULL;
+			inode->z_advise &= ~Z_EROFS_ADVISE_COMPACTED_2B;
+			inode->extent_isize = EROFS_FULL_INDEXES_SZ(inode);
+		}
+	}
+
 	if (inode->idata_type == EROFS_IDATA_TYPE_RAW ||
 	    (inode->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER))
 		return 0;
 
-	ei = list_last_entry(&ctx->extents, struct z_erofs_extent_item, list);
 	DBG_BUGON(ei->e.raw);
 
 	rawsz = ei->e.length;
@@ -2455,3 +2480,121 @@ int z_erofs_compress_exit(struct erofs_sb_info *sbi)
 	free(sbi->zmgr);
 	return 0;
 }
+
+int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
+				  struct erofs_inode *inode)
+{
+	struct erofs_sb_info *sbi = inode->sbi;
+	struct erofs_map_blocks map = {
+		.buf = __EROFS_BUF_INITIALIZER,
+		.m_la = 0,
+	};
+	struct z_erofs_extent_item *ei, *n;
+	erofs_off_t pend = EROFS_NULL_ADDR;
+	bool consecutive = true;
+	LIST_HEAD(extents);
+	int err, device_id = -1;
+
+	if (sbi->blkszbits != dst_sbi->blkszbits) {
+		erofs_err("filesystem block size mismatch: %d for image %d, target %d",
+			  erofs_blksiz(sbi), sbi->dev, erofs_blksiz(dst_sbi));
+		return -EOPNOTSUPP;
+	}
+
+	while (map.m_la < inode->i_size) {
+		struct erofs_map_dev mdev;
+		bool raw;
+
+		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_FIEMAP);
+		if (err)
+			goto err_out;
+
+		mdev = (struct erofs_map_dev) {
+			.m_deviceid = map.m_deviceid,
+			.m_pa = map.m_pa,
+		};
+		err = erofs_map_dev(sbi, &mdev);
+		if (err)
+			goto err_out;
+
+		raw = (map.m_algorithmformat >= Z_EROFS_COMPRESSION_MAX);
+
+		ei = malloc(sizeof(*ei));
+		if (!ei) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+
+		if (map.m_flags & __EROFS_MAP_FRAGMENT) {
+			DBG_BUGON(!(inode->z_advise &
+					Z_EROFS_ADVISE_FRAGMENT_PCLUSTER));
+			err = -EOPNOTSUPP;
+			goto err_free_ei;
+//			inode->fragment_size = map.m_llen;
+//			DBG_BUGON(inode->fragmentoff != map.m_pa);
+		} else if (map.m_flags & EROFS_MAP_META) {
+			DBG_BUGON(inode->idata_size != map.m_plen);
+			inode->idata = malloc(inode->idata_size);
+			if (!inode->idata) {
+				err = -ENOMEM;
+				goto err_free_ei;
+			}
+			err = erofs_dev_read(sbi, 0, inode->idata, mdev.m_pa,
+					     inode->idata_size);
+			if (err)
+				goto err_free_ei;
+			ei->e = (struct z_erofs_inmem_extent) {
+				.length = map.m_llen,
+				.plen = erofs_blksiz(sbi),
+				.pstart = (pend != EROFS_NULL_ADDR ? pend : 0),
+				.device_id = inode->dev,	/* FIXME! */
+				.raw = raw,
+				.inlined = true,
+			};
+
+			inode->idata_type = (raw ? EROFS_IDATA_TYPE_RAW :
+				EROFS_IDATA_TYPE_COMPRESSED_DEFAULT);
+			DBG_BUGON(map.m_la + map.m_llen != inode->i_size);
+		} else {
+			ei->e = (struct z_erofs_inmem_extent) {
+				.length = map.m_llen,
+				.plen = map.m_plen,
+				.pstart = mdev.m_pa,
+				.device_id = inode->dev,	/* FIXME! */
+				.partial = map.m_flags & EROFS_MAP_PARTIAL_REF,
+				.raw = raw,
+				.inlined = false,
+			};
+			if (pend != EROFS_NULL_ADDR && (pend != ei->e.pstart ||
+						device_id != ei->e.device_id))
+				consecutive = false;
+			pend = ei->e.pstart + ei->e.plen;
+			device_id = ei->e.device_id;
+		}
+
+		if (!raw) {
+			ei->e.algofmt = map.m_algorithmformat;
+			if (!(dst_sbi->available_compr_algs & (1 << ei->e.algofmt))) {
+				err = -EOPNOTSUPP;
+				goto err_free_ei;
+			}
+		}
+		init_list_head(&ei->list);
+		list_add_tail(&ei->list, &extents);
+		map.m_la += map.m_llen;
+	}
+	inode->z_lclusterbits = sbi->blkszbits;
+	err = z_erofs_prepare_layout(inode, &extents, consecutive, false);
+	if (err)
+		goto err_out;
+	return 0;
+
+err_free_ei:
+	free(ei);
+err_out:
+	list_for_each_entry_safe(ei, n, &extents, list) {
+		list_del(&ei->list);
+		free(ei);
+	}
+	return err;
+}
diff --git a/lib/inode.c b/lib/inode.c
index 1e497a0..ec96556 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -998,6 +998,16 @@ static bool erofs_inode_need_48bit(struct erofs_inode *inode)
 	return false;
 }
 
+static unsigned int erofs_inode_meta_size(struct erofs_inode *inode)
+{
+	unsigned int inodesize;
+
+	inodesize = inode->inode_isize + inode->xattr_isize;
+	if (inode->extent_isize)
+		inodesize = roundup(inodesize, 8) + inode->extent_isize;
+	return inodesize;
+}
+
 static int erofs_prepare_inode_buffer(struct erofs_importer *im,
 				      struct erofs_inode *inode)
 {
@@ -1017,9 +1027,7 @@ static int erofs_prepare_inode_buffer(struct erofs_importer *im,
 			inode->inode_isize =
 				sizeof(struct erofs_inode_extended);
 	}
-	inodesize = inode->inode_isize + inode->xattr_isize;
-	if (inode->extent_isize)
-		inodesize = roundup(inodesize, 8) + inode->extent_isize;
+	inodesize = erofs_inode_meta_size(inode);
 
 	if (!erofs_is_special_identifier(inode->i_srcpath) && sbi->mxgr)
 		inode->in_metabox = true;
@@ -1053,6 +1061,7 @@ static int erofs_prepare_inode_buffer(struct erofs_importer *im,
 			ret = z_erofs_drop_inline_pcluster(inode);
 			if (ret)
 				return ret;
+			inodesize = erofs_inode_meta_size(inode);
 		} else {
 			inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 		}
@@ -1069,7 +1078,8 @@ noinline:
 		return PTR_ERR(bh);
 	} else if (inode->idata_size) {
 		if (is_inode_layout_compression(inode)) {
-			DBG_BUGON(!params->ztailpacking);
+			DBG_BUGON(!erofs_sb_has_ztailpacking(sbi) &&
+				  !params->ztailpacking);
 			erofs_dbg("Inline %scompressed data (%u bytes) to %s",
 				  inode->idata_type == EROFS_IDATA_TYPE_RAW ? "un": "",
 				  inode->idata_size, inode->i_srcpath);
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 38ced3c..ebac1c5 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -152,7 +152,7 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 	return d;
 }
 
-static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
+static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 					  struct erofs_inode *inode)
 {
 	int ret;
@@ -222,6 +222,17 @@ err:
 	return ret;
 }
 
+static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
+					  struct erofs_inode *inode)
+{
+	int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sb,
+					  struct erofs_inode *inode);
+
+	if (is_inode_layout_compression(inode))
+		return z_erofs_rebuild_load_metadata(dst_sb, inode);
+	return erofs_rebuild_load_chunk_index(dst_sb, inode);
+}
+
 static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 {
 	struct erofs_sb_info *src_sbi = inode->sbi;
@@ -497,6 +508,7 @@ out:
 int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 			    enum erofs_rebuild_datamode mode)
 {
+	struct erofs_sb_info *dst_sbi = root->sbi;
 	struct erofs_inode inode = {};
 	struct erofs_rebuild_dir_context ctx;
 	char uuid_str[37];
@@ -514,6 +526,21 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		return ret;
 	}
 
+	if (mode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+		if (erofs_sb_has_ztailpacking(sbi))
+			erofs_sb_set_ztailpacking(dst_sbi);
+		if (erofs_sb_has_dedupe(sbi))
+			erofs_sb_set_dedupe(dst_sbi);
+		if (erofs_sb_has_big_pcluster(sbi) &&
+		    !erofs_sb_has_big_pcluster(dst_sbi)) {
+			erofs_err("failed to load tree from image %d with big pclusters",
+				  sbi->dev);
+			return -EOPNOTSUPP;
+		}
+		if (erofs_sb_has_48bit(sbi))
+			erofs_sb_set_48bit(dst_sbi);
+	}
+
 	inode.nid = sbi->root_nid;
 	inode.sbi = sbi;
 	ret = erofs_read_inode_from_disk(&inode);
-- 
2.47.3


