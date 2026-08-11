Return-Path: <linux-erofs+bounces-4192-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0194BC5CFCF
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 09:08:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hK5Pp2Wh2z301Y;
	Tue, 11 Aug 2026 19:08:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786439294;
	cv=none; b=ovq7p7l89zWco4XdUCX9lmfJKzOn5GPvZng4x1Ar83tfGEdHhI4vWH233MY2iAQRjuimcMb6Trp/g//R77U3ch4hZtETXOX+8Oh12wT+cSm2y4fnW5gN6Witu6AmnuO6sYt7IVVJae+lT6iVIyrmIfWg4VxtxgRlSAiDm67l/LgmPJbN+mNen9vsc/6Ja3Z1Og40oOe7RiQdcl2RZDI7EdM2dzH8bshMw4kebXJDtk6HY0rdoSs6TyVoJYFOi/PXQdXf17mjuA2Ukxpjj0O1wbUXrqkPz3I2hxuqIFVXYbfpTrGi2+AF+hdzl9zk06rugr07b2CEHtPx+2VZItugaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786439294; c=relaxed/relaxed;
	bh=Sir0LhP6dGrBzwhnRx4Za9tP8QkyBOJALnBa8aaWM3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5C/KtgGLtt6DVrLmCNCDKcvXAfrmQ3UMdtTBxBDwDJvSFpdsbkxxnJrk/3SD8p2Tr+3sKES92J6XQ1A0U1h2SktJEs9Pdt2zKlCIINZo9dG5jRd2uD4Cl6CAbY3+Bvq1DdXtP/Gx9+R14FHp9UUyh0kv0zDk4qB/3TAi2PzzBjbEh7p4aKVTmqq2+4kKPV2oTKnNgTqh3tEupWer+IttE9Jsyw7zMmQutIj2R2Hplc9ZyZl5sPSWjsBWmmFcOUYnBcysTUzjKjNuU01R0s2v5hHjAXwh4xtxcyhh8WHFSqqKFhfYvN2IYErgtVIleXL4KfFNQjbD49BnX+DBxuAsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L0Idwn0N; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L0Idwn0N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hK5Pn1rpfz2yvM
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 19:08:13 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A552C43359;
	Tue, 11 Aug 2026 09:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DA01F000E9;
	Tue, 11 Aug 2026 09:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786439290;
	bh=Sir0LhP6dGrBzwhnRx4Za9tP8QkyBOJALnBa8aaWM3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0Idwn0Nv9NiWnMkbEzjX72zkJ7yMUCcvQSStC1qk11fG8JadJpBOmFKlGroGuf/j
	 e6on5bvUmIAUy90VpMX59KbmlhZC/7Dvwr43Pb3FXqoZ1B3iUVb66q66v2E6SXq8qb
	 Cjqq4vyT29O/74YIpPCbag0xc80VhFyDyLy2CSSmAgjYWMnSdUZktxPL/HSu2amP98
	 kYVHGuMlwhfBHCDql/+oEeIncvCjPhsx+yoksBa7De4HfAQwPxWdFSd2b0yd4VNRGa
	 H/IkJtOuuXTK2UTXQFHxLtCSwdaWt7vCWoYhA0tzMwIt3waZWVuPD2cTxOQBKI8FDS
	 iOQp0RnAvikdQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2] erofs: use dedicated meta inodes for file-backed mounts
Date: Tue, 11 Aug 2026 17:07:17 +0800
Message-ID: <20260811090717.29787-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811080852.29418-1-xiang@kernel.org>
References: <20260811080852.29418-1-xiang@kernel.org>
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

Currently, metadata access for file-backed mounts reuses the page cache
of backing inodes directly.

Switch to per-sb dedicated pseudo inodes ("managed cache") for metadata
access on file-backed mounts (although I still don't think it is
necessary due to the EROFS immutable model). As the result, metadata
cache won't use the page cache of backing inodes anymore.

The "managed cache" was originally used to cache physical compressed
data according to the current cache strategy and I/O patterns; since
file-backed mounts also need to access physical data for metadata
access, it's natural to reuse the managed cache for this too, providing
a unique inode for all physical data access.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
v2:
 - move iput(managed_cache) out of #ifdef CONFIG_EROFS_FS_ZIP, reported
   by sashiko:
    https://sashiko.dev/#/patchset/20260811080852.29418-1-xiang%40kernel.org

 fs/erofs/data.c     | 28 ++++++++--------------------
 fs/erofs/fileio.c   | 21 +++++++++++++++++++++
 fs/erofs/internal.h | 12 ++++++++----
 fs/erofs/super.c    | 35 ++++++++++++++++++++++++-----------
 fs/erofs/zdata.c    | 13 ++++---------
 5 files changed, 65 insertions(+), 44 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d1..e3f3073779ac 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -30,20 +30,6 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 {
 	pgoff_t index = (buf->off + offset) >> PAGE_SHIFT;
 	struct folio *folio = NULL;
-	loff_t fpos;
-	int err;
-
-	/*
-	 * Metadata access for file-backed mounts reuses page cache of backing
-	 * fs inodes (only folio data will be needed) to prevent double caching.
-	 * However, the data access range must be verified here in advance.
-	 */
-	if (buf->file) {
-		fpos = (loff_t)index << PAGE_SHIFT;
-		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
-		if (err < 0)
-			return ERR_PTR(err);
-	}
 
 	if (buf->page) {
 		folio = page_folio(buf->page);
@@ -52,7 +38,8 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 	}
 	if (!folio || !folio_contains(folio, index)) {
 		erofs_put_metabuf(buf);
-		folio = read_mapping_folio(buf->mapping, index, buf->file);
+		folio = read_cache_folio(buf->mapping, index,
+				buf->mc ? erofs_read_meta_folio : NULL, NULL);
 		if (IS_ERR(folio))
 			return folio;
 	}
@@ -69,19 +56,20 @@ int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
-	buf->file = NULL;
+	buf->mc = false;
 	if (in_metabox) {
 		if (unlikely(!sbi->metabox_inode))
 			return -EFSCORRUPTED;
 		buf->mapping = sbi->metabox_inode->i_mapping;
 		return 0;
 	}
-	buf->off = sbi->dif0.fsoff;
 	if (erofs_is_fileio_mode(sbi)) {
-		buf->file = sbi->dif0.file;	/* some fs like FUSE needs it */
-		buf->mapping = buf->file->f_mapping;
-	} else
+		buf->mapping = sbi->managed_cache->i_mapping;
+		buf->mc = true;
+	} else {
+		buf->off = sbi->dif0.fsoff;
 		buf->mapping = sb->s_bdev->bd_mapping;
+	}
 	return 0;
 }
 
diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index 98cdaa1cd1a7..ebb81a7ffd4c 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -194,3 +194,24 @@ const struct address_space_operations erofs_fileio_aops = {
 	.read_folio = erofs_fileio_read_folio,
 	.readahead = erofs_fileio_readahead,
 };
+
+int erofs_read_meta_folio(struct file *file, struct folio *folio)
+{
+	struct erofs_fileio io = {
+		.dev = { .m_pa = folio_pos(folio), },
+	};
+	struct inode *inode = folio_inode(folio);
+	int err;
+
+	err = erofs_map_dev(inode->i_sb, &io.dev);
+	if (err)
+		return err;
+
+	io.rq = erofs_fileio_rq_alloc(&io.dev);
+	io.rq->bio.bi_iter.bi_sector =
+		(io.dev.m_dif->fsoff + io.dev.m_pa) >> 9;
+	erofs_onlinefolio_init(folio);
+	bio_add_folio_nofail(&io.rq->bio, folio, folio_size(folio), 0);
+	erofs_fileio_rq_submit(io.rq);
+	return 0;
+}
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 57bd21859c65..6de6e5a58e6b 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -98,11 +98,9 @@ struct erofs_sb_info {
 	unsigned int sync_decompress;	/* strategy for sync decompression */
 	unsigned int shrinker_run_no;
 
-	/* pseudo inode to manage cached pages */
-	struct inode *managed_cache;
-
 	struct erofs_sb_lz4_info lz4;
 #endif	/* CONFIG_EROFS_FS_ZIP */
+	struct inode *managed_cache; /* pseudo inode to cache physical data */
 	struct inode *packed_inode;
 	struct inode *metabox_inode;
 	struct erofs_dev_context *devs;
@@ -176,10 +174,10 @@ enum {
 
 struct erofs_buf {
 	struct address_space *mapping;
-	struct file *file;
 	u64 off;
 	struct page *page;
 	void *base;
+	bool mc;
 };
 #define __EROFS_BUF_INITIALIZER	((struct erofs_buf){ .page = NULL })
 
@@ -399,6 +397,12 @@ extern const struct file_operations erofs_ishare_fops;
 
 extern const struct iomap_ops z_erofs_iomap_report_ops;
 
+int erofs_setup_managed_cache(struct super_block *sb);
+#ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
+int erofs_read_meta_folio(struct file *file, struct folio *folio);
+#else
+#define erofs_read_meta_folio NULL
+#endif
 void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 			  erofs_off_t *offset, int *lengthp);
 void erofs_unmap_metabuf(struct erofs_buf *buf);
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 3d92caec8d3a..33e308e349f6 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -633,6 +633,21 @@ static const struct export_operations erofs_export_ops = {
 	.get_parent = erofs_get_parent,
 };
 
+int erofs_setup_managed_cache(struct super_block *sb)
+{
+	if (!EROFS_SB(sb)->managed_cache) {
+		struct inode *inode = new_inode(sb);
+
+		if (!inode)
+			return -ENOMEM;
+		set_nlink(inode, 1);
+		inode->i_size = OFFSET_MAX;
+		mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);
+		EROFS_SB(sb)->managed_cache = inode;
+	}
+	return 0;
+}
+
 static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -654,7 +669,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	sbi->blkszbits = PAGE_SHIFT;
-	if (!sb->s_bdev) {
+	if (erofs_is_fileio_mode(sbi)) {
 		/*
 		 * (File-backed mounts) EROFS claims it's safe to nest other
 		 * fs contexts (including its own) due to self-controlled RO
@@ -669,19 +684,19 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * It MUST change if another fs plans to support them, which
 		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
 		 */
-		if (erofs_is_fileio_mode(sbi)) {
-			inode = file_inode(sbi->dif0.file);
-			if ((inode->i_sb->s_op == &erofs_sops &&
-			     !inode->i_sb->s_bdev) ||
-			    inode->i_sb->s_stack_depth) {
-				erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
-				return -ENOTBLK;
-			}
+		inode = file_inode(sbi->dif0.file);
+		if ((inode->i_sb->s_op == &erofs_sops &&
+		     !inode->i_sb->s_bdev) || inode->i_sb->s_stack_depth) {
+			erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
+			return -ENOTBLK;
 		}
 		sb->s_blocksize = PAGE_SIZE;
 		sb->s_blocksize_bits = PAGE_SHIFT;
 
 		err = super_setup_bdi(sb);
+		if (err)
+			return err;
+		err = erofs_setup_managed_cache(sb);
 		if (err)
 			return err;
 
@@ -913,10 +928,8 @@ static void erofs_drop_internal_inodes(struct erofs_sb_info *sbi)
 	sbi->packed_inode = NULL;
 	iput(sbi->metabox_inode);
 	sbi->metabox_inode = NULL;
-#ifdef CONFIG_EROFS_FS_ZIP
 	iput(sbi->managed_cache);
 	sbi->managed_cache = NULL;
-#endif
 }
 
 static void erofs_kill_sb(struct super_block *sb)
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 74520e910259..602ba8b7cc79 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -666,21 +666,16 @@ static const struct address_space_operations z_erofs_cache_aops = {
 
 int z_erofs_init_super(struct super_block *sb)
 {
-	struct inode *inode;
 	int err;
 
 	err = z_erofs_init_pcpu_workers(sb);
 	if (err)
 		return err;
 
-	inode = new_inode(sb);
-	if (!inode)
-		return -ENOMEM;
-	set_nlink(inode, 1);
-	inode->i_size = OFFSET_MAX;
-	inode->i_mapping->a_ops = &z_erofs_cache_aops;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);
-	EROFS_SB(sb)->managed_cache = inode;
+	err = erofs_setup_managed_cache(sb);
+	if (err)
+		return err;
+	EROFS_SB(sb)->managed_cache->i_mapping->a_ops = &z_erofs_cache_aops;
 	xa_init(&EROFS_SB(sb)->managed_pslots);
 	return 0;
 }
-- 
2.47.3


