Return-Path: <linux-erofs+bounces-4545-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B02A5C88E50
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 12:22:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hhDF75dv7z2yd7;
	Fri, 11 Sep 2026 22:22:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789129323;
	cv=none; b=BGBzyAgNzVMBm/VSd7+NdzCtW3UDF3vpXO/TRQwoB2v1NGAkYn+yLQtPDxVHQHk+XK31Oe/dThB6ddbdqhBDvHucqs/8M0lAUKWhxPqct7Yvo3DLsfbqadb456kFb4D7JfmalTnDDHYjlRh8PkeeE1inWhYDKPfqZVBJBEaiSFVXtwGpi8qo9usQAV9qydMX2lEQ6ndQtyRjyjcpj/wBFE2mJix9uzP3uo9f2BWgVswQNm6kmR50UN5luuichVbHwJtX9PQRWtcs5OM2RCtHcAX1LXTbjOvEWQ0g/gfSuKXAH/ChaY95lrG7XZa2BSU6u/zk9udg3HeV7ivZphMMhw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789129323; c=relaxed/relaxed;
	bh=xgPlo9fMuaWNGHCpN9Xd9U0iJnfInp8a61KqhAPospY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/R7R21vHe2RD8/ZGm1q43SWs+CUV9BsbLT5Ri+2QF5hYkhr927ouWfKk3fC/9xuyEdLjsrL0AiUkv6UGx9RFRBn5+QFDkpDRxstsBQcsAcX53DrqYoamCD8RsrnshZ3eXohXAPo4q9lZRuFO/8rFj3paRx/dboWr6KnS25nM3FNHvCxMINfGkxzuvgD0iWe69jwpeVAjLXKn65mHXZYxlFbS+QLd8BRms0lb2Z4sJ3u2eHe3gC+ol/H3dJ6zY0SeKeqjjS25CoWImzMyn2Rtl+5XTdtj1AgaTW9cXSsWEJ7EQOJI6YTc43MO5fCOZK3F6etAaJIhihGnc4eJ9CXYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VtmMfNzL; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VtmMfNzL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hhDF65wBQz2xpv
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 22:22:02 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1A9140B91;
	Fri, 11 Sep 2026 12:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2811F000FF;
	Fri, 11 Sep 2026 12:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789129320;
	bh=xgPlo9fMuaWNGHCpN9Xd9U0iJnfInp8a61KqhAPospY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtmMfNzLKeGYdLSO6Ck06uhyNELhcswr3zKzTG/+xdyap8ASbWeoeuBTk1ovKCbiZ
	 En3HC00CGSM5f9efSsZyWvj4GVq6PyI1Ko9Txadw/WU6aN5fN1M2u7IWrWqgRZDRPY
	 U4WXY5ub8kSCulK0x7szlpgSrE3cWIpZ9B5IM+7bQMiys3JOZV/lM6HaCWEX7FV9Yd
	 RQs06YO4IrSZ7SLHMOYVnWgvxyOU0+YrxPlEwVcckbEssyIplX3vMUF4dQlpyF+z23
	 G8SfMfTCLYYU/9rqiSfxuv5hzFzQFBfvyMd9zoum8JsaVmFwZ/OMk0T8f5fpvZ52BC
	 e11H1gBXPjDdw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Jonathan Calmels <jcalmels@nvidia.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [RFC PATCH v2 2/2] erofs-utils: mkfs: support rebuild mode for compressed inodes
Date: Fri, 11 Sep 2026 20:21:10 +0800
Message-ID: <20260911122110.189175-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911120914.185958-2-xiang@kernel.org>
References: <20260911120914.185958-2-xiang@kernel.org>
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
 lib/compress.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/rebuild.c  |  22 ++++++++++-
 2 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/lib/compress.c b/lib/compress.c
index 3e8f9b6..fb0f92e 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -2435,3 +2435,103 @@ int z_erofs_compress_exit(struct erofs_sb_info *sbi)
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
+	int err, device_id;
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
+		init_list_head(&ei->list);
+		ei->e = (struct z_erofs_inmem_extent) {
+			.length = map.m_llen,
+			.plen = map.m_plen,
+			.pstart = mdev.m_pa,
+			.device_id = inode->dev,	/* FIXME! */
+			.partial = map.m_flags & EROFS_MAP_PARTIAL_REF,
+			.raw = raw,
+			.inlined = map.m_flags & EROFS_MAP_META,
+		};
+		if (!raw) {
+			ei->e.algofmt = map.m_algorithmformat;
+			if (!(dst_sbi->available_compr_algs & (1 << ei->e.algofmt))) {
+				err = -EOPNOTSUPP;
+				goto err_free_ei;
+			}
+		}
+
+		if (map.m_flags & __EROFS_MAP_FRAGMENT) {
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
+			DBG_BUGON(map.m_la + map.m_llen != inode->i_size);
+		} else {
+			if (pend != EROFS_NULL_ADDR && (pend != ei->e.pstart ||
+			                                device_id != ei->e.device_id))
+				consecutive = false;
+			pend = ei->e.pstart + ei->e.plen;
+			device_id = ei->e.device_id;
+		}
+		list_add_tail(&ei->list, &extents);
+		map.m_la += map.m_llen;
+	}
+
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
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 38ced3c..b431bd4 100644
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
@@ -514,6 +525,15 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		return ret;
 	}
 
+	if (erofs_sb_has_dedupe(sbi))
+		erofs_sb_set_dedupe(root->sbi);
+	if (erofs_sb_has_big_pcluster(sbi) &&
+	    !erofs_sb_has_big_pcluster(root->sbi)) {
+		erofs_err("failed to load tree from image %d with big pclusters",
+			  sbi->dev);
+		return -EOPNOTSUPP;
+	}
+
 	inode.nid = sbi->root_nid;
 	inode.sbi = sbi;
 	ret = erofs_read_inode_from_disk(&inode);
-- 
2.47.3


