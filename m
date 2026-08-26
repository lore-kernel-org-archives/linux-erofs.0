Return-Path: <linux-erofs+bounces-4348-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E392C61DC2
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 13:44:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVQqQ4c16z2yb9;
	Wed, 26 Aug 2026 23:44:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787751858;
	cv=none; b=aNshSLml0kq10WHhy2fwo7Vu/O4fBBkP2UTOWKgT++/SbTWugK915VaDDUc1zvMO3erjTpLofOdIIbe66RW6R9/k2kAwvoWG6GccTLxlNYfujU+gqHzVJ1PFZ4zL0SpurGRvqiv5WNExQVlsQP1ocXh1vfWZW0Dke6AJ+96yAkGwAA9e8t8GZPN8jtaue9I08WAdUkwRZxafXe7ddS7w2WIRAzRotQrWE7GKwW8UBPXtySuKU7k/bQ0+aMfnR8L7QhOKMMHM91/ixTzMM4kvDe6Wl/xZQzIAOGcI/J7nQ97gB+DYS9p0ewvmY3zlMn/QY3FiwHkL422I0V05nylvrA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787751858; c=relaxed/relaxed;
	bh=6NOwEveV9pV7iE3fJYE1wOvj9NTnZUbKLN3K8E+oA9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzrMtFAB+OB58B2sYBtBY8yKmoA7Hp70DDlWUWE5R3CQ3OynvfnIndXuSziGEyORi+qNkW0GpMJP2XukNIYbG7YGI6CtecKm2KJtT4JYG0EYgr7i1XT/3lwLbW8dUI60QM/o9Rct3W5w8Nv9D2/mPmmoOo01v53ekD4u19E6chGnRMHvUGfxcisoZvH04QOZpqAq9MjaDqVRIDLlqbRLo3KiHn3MuWYzuHtolUMZol4IAEHdfAw/mie332mLNm+m1wM18OdZVcQgofYdhtGIuSUYW/Pid538+34mOGH5Sj+WkryzPiunQIx96qIT+vWxRhhcfoDfr4BSiFAyqd0A7Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oV5sCTCd; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oV5sCTCd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVQqP63QKz2xLG
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 23:44:17 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00C3E6011F
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 13:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDB11F000E9;
	Wed, 26 Aug 2026 13:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787751855;
	bh=6NOwEveV9pV7iE3fJYE1wOvj9NTnZUbKLN3K8E+oA9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oV5sCTCdCU15se9VU3Q9w52OVE5WMitj+Wa2OPtPcNJOUvX0ljhCVe8FbW6emGkta
	 Ft74JPMxGdK24sfqvg5k5na9AO5qfVaNE9NMtwXqdt5p370VCuLuYl9l4NP9IrcyNL
	 bXdGvXwoqzej5YWujzrgx8mb8eZAUWCFjco6E4iotCkdnhyvufE5iutYZniqNnb71e
	 5HHcraD4AZK17ck4VYfPMB+fQZQXcamTy9NCotyoeyqwEDXRTdqm9eo0A1kzAXPZvy
	 N5b7ppkDW0lLujSzYUgLj1jv7mLVTB3IQQ8vxKX+HNztF7gxSlCrMrK+sSWWor4JK4
	 8ZFE7ZbFOKv/Q==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH 2/4] erofs-utils: lib: use `struct erofs_device_info` for the primary device
Date: Wed, 26 Aug 2026 21:43:18 +0800
Message-ID: <20260826134321.11835-2-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826134321.11835-1-xiang@kernel.org>
References: <20260826134321.11835-1-xiang@kernel.org>
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

Source kernel commit: 7b00af2c5414dc01e0718deef7ead81102867636

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/internal.h |  4 +---
 lib/importer.c           |  3 +--
 lib/io.c                 |  8 ++++----
 lib/rebuild.c            |  6 +++---
 lib/super.c              | 18 +++++++++---------
 lib/vmdk.c               |  4 ++--
 mkfs/main.c              | 12 ++++++------
 7 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 514cfbd..30dae41 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -93,11 +93,9 @@ struct erofs_metamgr;
 
 struct erofs_sb_info {
 	struct erofs_sb_lz4_info lz4;
-	struct erofs_device_info *devs;
-	char *devname;
+	struct erofs_device_info *devs, dif0;
 
 	u64 total_blocks;
-	u64 primarydevice_blocks;
 
 	s32 meta_blkaddr;
 	u32 xattr_blkaddr;
diff --git a/lib/importer.c b/lib/importer.c
index c404b0f..2a635d2 100644
--- a/lib/importer.c
+++ b/lib/importer.c
@@ -126,8 +126,7 @@ int erofs_importer_flush_all(struct erofs_importer *im)
 
 	fsalignblks = im->params->fsalignblks ?
 		roundup_pow_of_two(im->params->fsalignblks) : 1;
-	sbi->primarydevice_blocks = roundup(erofs_mapbh(sbi->bmgr, NULL),
-					    fsalignblks);
+	sbi->dif0.blocks = roundup(erofs_mapbh(sbi->bmgr, NULL), fsalignblks);
 	err = erofs_write_device_table(sbi);
 	if (err)
 		return err;
diff --git a/lib/io.c b/lib/io.c
index 3ba45cc..5c5449f 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -368,8 +368,8 @@ repeat:
 	}
 
 out:
-	sbi->devname = strdup(dev);
-	if (!sbi->devname) {
+	sbi->dif0.src_path = strdup(dev);
+	if (!sbi->dif0.src_path) {
 		close(fd);
 		return -ENOMEM;
 	}
@@ -381,8 +381,8 @@ out:
 void erofs_dev_close(struct erofs_sb_info *sbi)
 {
 	erofs_io_close(&sbi->bdev);
-	free(sbi->devname);
-	sbi->devname = NULL;
+	free(sbi->dif0.src_path);
+	sbi->dif0.src_path = NULL;
 	sbi->bdev.fd = -1;
 }
 
diff --git a/lib/rebuild.c b/lib/rebuild.c
index a5308dc..6b03a52 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -233,7 +233,7 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 				return -EFSCORRUPTED;
 			return 0;
 		}
-		inode->rebuild_blobpath = strdup(src_sbi->devname);
+		inode->rebuild_blobpath = strdup(src_sbi->dif0.src_path);
 		if (!inode->rebuild_blobpath)
 			return -ENOMEM;
 		inode->rebuild_src_dataoff =
@@ -244,7 +244,7 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 		unsigned int inline_size = inode->i_size % erofs_blksiz(src_sbi);
 
 		if (nblocks > 0 && inode->u.i_blkaddr != EROFS_NULL_ADDR) {
-			inode->rebuild_blobpath = strdup(src_sbi->devname);
+			inode->rebuild_blobpath = strdup(src_sbi->dif0.src_path);
 			if (!inode->rebuild_blobpath)
 				return -ENOMEM;
 			inode->rebuild_src_dataoff =
@@ -500,7 +500,7 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 	struct erofs_inode inode = {};
 	struct erofs_rebuild_dir_context ctx;
 	char uuid_str[37];
-	char *fsid = sbi->devname;
+	char *fsid = sbi->dif0.src_path;
 	int ret;
 
 	if (!fsid) {
diff --git a/lib/super.c b/lib/super.c
index d138f84..ead4170 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -33,7 +33,7 @@ static int erofs_init_devices(struct erofs_sb_info *sbi,
 	erofs_off_t pos;
 	bool _48bit = erofs_sb_has_48bit(sbi);
 
-	sbi->total_blocks = sbi->primarydevice_blocks;
+	sbi->total_blocks = sbi->dif0.blocks;
 
 	if (!erofs_sb_has_device_table(sbi))
 		ondisk_extradevs = 0;
@@ -118,14 +118,14 @@ int erofs_read_superblock(struct erofs_sb_info *sbi)
 		erofs_err("invalid sb_extslots %u", dsb->sb_extslots);
 		return -EINVAL;
 	}
-	sbi->primarydevice_blocks = le32_to_cpu(dsb->blocks_lo);
+	sbi->dif0.blocks = le32_to_cpu(dsb->blocks_lo);
 	sbi->meta_blkaddr = le32_to_cpu(dsb->meta_blkaddr);
 	sbi->xattr_blkaddr = le32_to_cpu(dsb->xattr_blkaddr);
 	sbi->xattr_prefix_start = le32_to_cpu(dsb->xattr_prefix_start);
 	sbi->xattr_prefix_count = dsb->xattr_prefix_count;
 	if (erofs_sb_has_48bit(sbi) && dsb->rootnid_8b) {
 		sbi->root_nid = le64_to_cpu(dsb->rootnid_8b);
-		sbi->primarydevice_blocks = sbi->primarydevice_blocks |
+		sbi->dif0.blocks = sbi->dif0.blocks |
 				((u64)le16_to_cpu(dsb->rb.blocks_hi) << 32);
 	} else {
 		sbi->root_nid = le16_to_cpu(dsb->rb.rootnid_2b);
@@ -230,10 +230,10 @@ int erofs_writesb(struct erofs_sb_info *sbi)
 	char *buf;
 	int ret;
 
-	sb.blocks_lo	= cpu_to_le32(sbi->primarydevice_blocks);
-	if (sbi->primarydevice_blocks > UINT32_MAX ||
+	sb.blocks_lo	= cpu_to_le32(sbi->dif0.blocks);
+	if (sbi->dif0.blocks > UINT32_MAX ||
 	    sbi->root_nid > UINT16_MAX) {
-		sb.rb.blocks_hi = cpu_to_le16(sbi->primarydevice_blocks >> 32);
+		sb.rb.blocks_hi = cpu_to_le16(sbi->dif0.blocks >> 32);
 		sb.rootnid_8b = cpu_to_le64(sbi->root_nid);
 	}
 	memcpy(sb.uuid, sbi->uuid, sizeof(sb.uuid));
@@ -404,7 +404,7 @@ int erofs_mkfs_init_devices(struct erofs_sb_info *sbi, unsigned int devices)
 
 int erofs_write_device_table(struct erofs_sb_info *sbi)
 {
-	erofs_blk_t nblocks = sbi->primarydevice_blocks;
+	erofs_blk_t nblocks = sbi->dif0.blocks;
 	struct erofs_buffer_head *bh = sbi->bh_devt;
 	erofs_off_t pos;
 	unsigned int i, ret;
@@ -484,7 +484,7 @@ int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
 	erofs_warn("EXPERIMENTAL incremental build in use. Use at your own risk!");
 	err = erofs_read_superblock(sbi);
 	if (err) {
-		erofs_err("failed to read superblock of %s: %s", sbi->devname,
+		erofs_err("failed to read superblock of %s: %s", sbi->dif0.src_path,
 			  erofs_strerror(err));
 		return err;
 	}
@@ -493,7 +493,7 @@ int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
 	if (!err && S_ISREG(u.st.st_mode))
 		u.startblk = DIV_ROUND_UP(u.st.st_size, erofs_blksiz(sbi));
 	else
-		u.startblk = sbi->primarydevice_blocks;
+		u.startblk = sbi->dif0.blocks;
 
 	bmgr = erofs_buffer_init(sbi, u.startblk, NULL);
 	if (!bmgr)
diff --git a/lib/vmdk.c b/lib/vmdk.c
index 316a8ff..28381c8 100644
--- a/lib/vmdk.c
+++ b/lib/vmdk.c
@@ -51,8 +51,8 @@ int erofs_dump_vmdk_desc(FILE *f, struct erofs_sb_info *sbi)
 	int ret, i;
 
 	fprintf(f, desc_template_1, cid, parent_cid, subformat);
-	sectors = sbi->primarydevice_blocks << (sbi->blkszbits - 9);
-	ret = erofs_vmdk_desc_add_extent(f, sectors, (char *)sbi->devname, 0);
+	sectors = sbi->dif0.blocks << (sbi->blkszbits - 9);
+	ret = erofs_vmdk_desc_add_extent(f, sectors, (char *)sbi->dif0.blocks, 0);
 	if (ret)
 		return ret;
 	total_sectors = sectors;
diff --git a/mkfs/main.c b/mkfs/main.c
index 929ce7c..5bf7b8f 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1685,12 +1685,12 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		ret = erofs_rebuild_load_tree(root, src, datamode);
 		src->xamgr = NULL;
 		if (ret) {
-			erofs_err("failed to load %s", src->devname);
+			erofs_err("failed to load %s", src->dif0.src_path);
 			return ret;
 		}
 		if (src->extra_devices > 1) {
 			erofs_err("%s: unsupported number %u of extra devices",
-				  src->devname, src->extra_devices);
+				  src->dif0.src_path, src->extra_devices);
 			return -EOPNOTSUPP;
 		}
 		extra_devices += src->extra_devices;
@@ -1723,8 +1723,8 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 			nblocks = src->devs[0].blocks;
 			tag = src->devs[0].tag;
 		} else {
-			nblocks = src->primarydevice_blocks;
-			devs[idx].src_path = strdup(src->devname);
+			nblocks = src->dif0.blocks;
+			devs[idx].src_path = strdup(src->dif0.src_path);
 		}
 		devs[idx].blocks = nblocks;
 		if (tag && *tag)
@@ -1849,7 +1849,7 @@ int main(int argc, char **argv)
 			goto exit;
 		err = erofs_read_superblock(src);
 		if (err) {
-			erofs_err("failed to read superblock of %s", src->devname);
+			erofs_err("failed to read superblock of %s", src->dif0.src_path);
 			goto exit;
 		}
 		mkfs_blkszbits = src->blkszbits;
@@ -2051,7 +2051,7 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
-	err = erofs_dev_resize(&g_sbi, g_sbi.primarydevice_blocks);
+	err = erofs_dev_resize(&g_sbi, g_sbi.dif0.blocks);
 
 	if (!err && erofs_sb_has_sb_chksum(&g_sbi)) {
 		err = erofs_enable_sb_chksum(&g_sbi, &crc);
-- 
2.47.3


