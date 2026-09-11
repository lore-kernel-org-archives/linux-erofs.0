Return-Path: <linux-erofs+bounces-4544-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D3DCC88E4D
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 12:10:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hhCzZ2gXqz2ygK;
	Fri, 11 Sep 2026 22:10:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789128618;
	cv=none; b=XoAubXSnCqu5W+8qhUsIPNuVIxgw1UvwwMFqM1ZH6AuM4SKLiQlPEze6hQ8LSG0pd5u8vCeuH6WBJh6nvT3jMF43rYPh+hdIv0qs033IsGuFYGgNdpLPshpkCCk0hwV8fRtIcsgMCFnjDanA72bWq09aUs0ie4+TxKLm9s1FA+b2Nxh5jj2CpC5Wyk2mVJ7VKKAtUWZB9PrdLNIYZJMW3GYxLq3g4chJ5QglVYB7x366NFwExdlMpV6+ei+MBTpv7A+Bq6vXU1Oo6I/wKA9rBxrj/+/3m77f2qrmz+Df+hGmMDiBywmnZuSbPLF6SIwiOvy8OiYAuZl2mqSi7a8uDA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789128618; c=relaxed/relaxed;
	bh=2aX0AGi+W1c8BsKMDYePbz1vgn5N9JXDvlg/kNp10Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWKlkWzG8y76mbGpVfY7Lv2ihvhm2QWRnn4dKT/rz68+fCUbPh8gRajEJ/EzjoSqEYuh50l5w+cPUYMQAJQmOuUuPgZOh+iaB8uUGdgs/4NU+VX1OYq6GkKquZAwgWw4s7jwEFhmrBX3Cok3zNo0avMQWBX2PyuxSVBdfGlQtss2NJt3OM2u9nsG+oSvwyK8xZvxkpPnyr8xAP4eXNmR0DcsX6DEWaPdwe9tX8+HY9HLGjVFnDqmy4IdGdFePIi185aEc+zC6pY0rlRNqCX3hNLebcM5wdDuDPRL6A8drokOIxjkcPnB6CxU2AfUc9pS8In21rQVZja4hbRunLhJOg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNLhnmbq; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNLhnmbq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hhCzY2zYBz2xBK
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 22:10:17 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DDF341847;
	Fri, 11 Sep 2026 12:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A001F000FF;
	Fri, 11 Sep 2026 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789128615;
	bh=2aX0AGi+W1c8BsKMDYePbz1vgn5N9JXDvlg/kNp10Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNLhnmbqEP7lNo0q4Dyyo0OxcJdn20dxFD90HbyPjzw0qcm3rUral7xE4DQxJFl87
	 gn8SPL287oRZB/Qr/XxGvy4HVTqYe/jgFXnaoD/yG5VrloREYsoAhkxuIZl2UM2NCG
	 KPDbYPdo4mVY9VETHykydEeyaBZinVdPqwnvkhMdUKGFVgJhrVU9MVFM4+QnebAjVg
	 umerUVZeFQTxjbz4gpepKS9LupN6qeKyaYv0vqq/Uyb/MkKnwGgAWRJ8WQ7vXhnj/5
	 McMDbDIrdUFQ4IsOPENR2kYBxP6V1gI/s1GxVDd8LbwmC/EmD+YP/FidayznaQ3eEE
	 7CzXUF4mMQxRA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Jonathan Calmels <jcalmels@nvidia.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [RFC PATCH 2/2] erofs-utils: mkfs: support rebuild mode for compressed inodes
Date: Fri, 11 Sep 2026 20:09:14 +0800
Message-ID: <20260911120914.185958-2-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911120914.185958-1-xiang@kernel.org>
References: <20260911120914.185958-1-xiang@kernel.org>
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
 lib/rebuild.c  |  16 +++++++-
 2 files changed, 115 insertions(+), 1 deletion(-)

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
index 38ced3c..fac0ab8 100644
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
@@ -514,6 +525,9 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		return ret;
 	}
 
+	if (erofs_sb_has_dedupe(sbi))
+		erofs_sb_set_dedupe(root->sbi);
+
 	inode.nid = sbi->root_nid;
 	inode.sbi = sbi;
 	ret = erofs_read_inode_from_disk(&inode);
-- 
2.47.3


