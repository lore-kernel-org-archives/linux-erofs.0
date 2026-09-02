Return-Path: <linux-erofs+bounces-4421-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89753C624D4
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 15:54:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZnNN4cPDz2xlY;
	Thu, 03 Sep 2026 01:54:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788364468;
	cv=none; b=WOvGtV2TwhUQ7QrnJ5OMmRBoP/W8KfCIkQlxpl5HAjJ6OzuDRKMGvsFbMCa66tXBJwqjGHrS9Kyil/1x1gQf2awluxjpRW5LnpX0VJP1s/mF3OTqjyK1vom967glakvPksfkqet9wD32YZB1w8AXK+2HqCZUkEjeWVSYBeS5EBI7qSQVtYwRnRFgUZ3ZhBs42Y+T1aCNMpsLH2hyWhkBlUZxWNSTfyLBqjnqRIxJz8zjRhIVBQVKmalOBE90mVOng8QeiHy9AAdqYWcdYIbU3bJGCUzQi+jDzhtEIMl9cudzbrrcWYykxYLs+iRDnMBYCkPmuC6eQKpH38GvcG0jiw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788364468; c=relaxed/relaxed;
	bh=nMpTw1cGxmuHbShNSS66GGQWmh3WJPFsr0/rfgDZJsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LcMmEIUdRKY02zI/aoWOIPC8IYFvNNXDp3otpTJ/L1kkZFJOE0BaK+9uDAoHtuh7p0zt7XFYbeWC7LN1U06lkNiRxEXwO4lXlyp1sPtox54Rfbxr7cSXXaXBd4LOR4LxstLEfdj69V/H5qtr7Gs68H268idKCw/XyNFB/tWWzC9HuFh+6hwaRTpmfanIqoEB6vDhUDoYRj39yScIcseR0WqrjncAWLM2gEhxbvO4DBHxxGjChP7my/k0rFulwqaDM87n8t5DZ1DGiYQh14NQZ3yhLDaW1E0pOt84jVqQJc+A+fxObQn/KYToHmwpK4GSiowZsXotr2aQZJE3koCVuA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQVwwKz7; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQVwwKz7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZnNM23Snz2x98
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 01:54:27 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCEA2600C8
	for <linux-erofs@lists.ozlabs.org>; Wed,  2 Sep 2026 15:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742671F00A3A;
	Wed,  2 Sep 2026 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788364463;
	bh=nMpTw1cGxmuHbShNSS66GGQWmh3WJPFsr0/rfgDZJsU=;
	h=From:To:Cc:Subject:Date;
	b=BQVwwKz75Rv/aEtrp+YGFK6/kO5njyoh70D+++g9hb1dEJ0eZtRhZ97lPREX5+OiE
	 vLpgkKK9Ga2pG/fFuPcuIsc30AoWDngC4at4JVxSXrMaz+R18PgU9AoautZ889LGfm
	 /7BeQ0B6QU0+KUMPvmFrPgsDoTpFI/dvqp0wDNifyiU1Cw4qGADGDINxVQZtoCnbnf
	 8u9UJnSagOfsNaTWCllTZQeKR9DKtKaDZ8MDJCPpETek6sY+eLBNxVprDMBOKGQ49T
	 4TGaD+TfdNptgTe+wpMxfPNLiTWAAEzJMXKXCadempsbS/v9N5ltBLkYJP8EU+r15S
	 Qinp4TqriIu3g==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2 1/3] erofs-utils: lib: migrate `c_chunkbits` and `c_blobdev_path`
Date: Wed,  2 Sep 2026 23:53:30 +0800
Message-ID: <20260902155333.57247-1-xiang@kernel.org>
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

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
address Xusheng's comments:
  https://lore.kernel.org/r/20260902071406.3292294-1-zhanxusheng@xiaomi.com

 include/erofs/config.h   |  2 --
 include/erofs/importer.h |  1 +
 lib/inode.c              | 25 +++++++++--------
 mkfs/main.c              | 58 +++++++++++++++++++++-------------------
 4 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/include/erofs/config.h b/include/erofs/config.h
index 95d7e9f..c796c95 100644
--- a/include/erofs/config.h
+++ b/include/erofs/config.h
@@ -34,7 +34,6 @@ struct erofs_configure {
 	int c_dbg_lvl;
 	bool c_dry_run;
 	char c_timeinherit;
-	char c_chunkbits;
 	char c_dedupe;
 	bool c_showprogress;
 	bool c_extra_ea_name_prefixes;
@@ -46,7 +45,6 @@ struct erofs_configure {
 	/* related arguments for mkfs.erofs */
 	char *c_img_path;
 	char *c_src_path;
-	char *c_blobdev_path;
 	char *c_compress_hints_file;
 	char c_force_chunkformat;
 	u8 c_mkfs_metabox_algid;
diff --git a/include/erofs/importer.h b/include/erofs/importer.h
index 07e40b4..c09b169 100644
--- a/include/erofs/importer.h
+++ b/include/erofs/importer.h
@@ -63,6 +63,7 @@ struct erofs_importer_params {
 	bool all_fragments;
 	bool compress_dir;
 	char fragdedupe;
+	char chunkszbits_def;
 };
 
 struct erofs_importer {
diff --git a/lib/inode.c b/lib/inode.c
index ea3277b..728040a 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -704,13 +704,15 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 	return 0;
 }
 
-int erofs_write_unencoded_file(struct erofs_inode *inode, int fd, u64 fpos)
+static int erofs_write_unencoded_file(const struct erofs_importer *im,
+				      struct erofs_inode *inode, int fd, u64 fpos)
 {
 	struct erofs_vfile vf = { .fd = fd };
+	char chunkbits = im->params->chunkszbits_def;
 
-	if (cfg.c_chunkbits &&
+	if (chunkbits &&
 	    inode->datasource != EROFS_INODE_DATA_SOURCE_REBUILD_BLOB) {
-		inode->u.chunkbits = cfg.c_chunkbits;
+		inode->u.chunkbits = chunkbits;
 		/* chunk indexes when explicitly specified */
 		inode->u.chunkformat = 0;
 		if (cfg.c_force_chunkformat == FORCE_INODE_CHUNK_INDEXES)
@@ -1491,6 +1493,11 @@ static int erofs_inode_reserve_data_blocks(struct erofs_inode *inode)
 	return 0;
 }
 
+struct erofs_mkfs_btctx {
+	struct erofs_importer *im;
+	bool rebuild, incremental;
+};
+
 struct erofs_mkfs_job_ndir_ctx {
 	struct erofs_inode *inode;
 	void *ictx;
@@ -1498,7 +1505,8 @@ struct erofs_mkfs_job_ndir_ctx {
 	u64 fpos;
 };
 
-static int erofs_mkfs_job_write_file(struct erofs_mkfs_job_ndir_ctx *ctx)
+static int erofs_mkfs_job_write_file(const struct erofs_mkfs_btctx *btctx,
+				     struct erofs_mkfs_job_ndir_ctx *ctx)
 {
 	struct erofs_inode *inode = ctx->inode;
 	int ret;
@@ -1519,7 +1527,7 @@ static int erofs_mkfs_job_write_file(struct erofs_mkfs_job_ndir_ctx *ctx)
 		}
 	}
 	/* fallback to all data uncompressed */
-	ret = erofs_write_unencoded_file(inode, ctx->fd, ctx->fpos);
+	ret = erofs_write_unencoded_file(btctx->im, inode, ctx->fd, ctx->fpos);
 out:
 	if (inode->datasource == EROFS_INODE_DATA_SOURCE_DISKBUF) {
 		erofs_diskbuf_close(inode->i_diskbuf);
@@ -1539,11 +1547,6 @@ out:
 	return ret;
 }
 
-struct erofs_mkfs_btctx {
-	struct erofs_importer *im;
-	bool rebuild, incremental;
-};
-
 static int erofs_mkfs_handle_nondirectory(const struct erofs_mkfs_btctx *btctx,
 					  struct erofs_mkfs_job_ndir_ctx *ctx)
 {
@@ -1575,7 +1578,7 @@ static int erofs_mkfs_handle_nondirectory(const struct erofs_mkfs_btctx *btctx,
 		if (inode->datasource == EROFS_INODE_DATA_SOURCE_RESVSP)
 			ret = erofs_inode_reserve_data_blocks(inode);
 		else if (ctx->fd >= 0)
-			ret = erofs_mkfs_job_write_file(ctx);
+			ret = erofs_mkfs_job_write_file(btctx, ctx);
 	}
 	if (ret)
 		return ret;
diff --git a/mkfs/main.c b/mkfs/main.c
index 8da3753..ce29319 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -282,9 +282,11 @@ static void version(void)
 
 static struct erofsmkfs_cfg {
 	struct z_erofs_paramset zcfgs[EROFS_MAX_COMPR_CFGS + 1];
+	char *blobdev_path;
 	/* < 0, xattr disabled and >= INT_MAX, always use inline xattrs */
 	long inlinexattr_tolerance;
 	bool inode_metazone;
+	char chunkbits;
 	u64 unix_timestamp;
 	unsigned int total_zcfgs;
 } mkfscfg = {
@@ -1265,8 +1267,8 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				erofs_err("invalid chunksize %s", optarg);
 				return -EINVAL;
 			}
-			cfg.c_chunkbits = ilog2(i);
-			if ((1 << cfg.c_chunkbits) != i) {
+			mkfscfg.chunkbits = ilog2(i);
+			if ((1 << mkfscfg.chunkbits) != i) {
 				erofs_err("chunksize %s must be a power of two",
 					  optarg);
 				return -EINVAL;
@@ -1277,7 +1279,7 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			quiet = true;
 			break;
 		case 13:
-			cfg.c_blobdev_path = optarg;
+			mkfscfg.blobdev_path = optarg;
 			break;
 		case 14:
 			params->ignore_mtime = true;
@@ -1506,13 +1508,13 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		}
 	}
 
-	if (cfg.c_blobdev_path && cfg.c_chunkbits < mkfs_blkszbits) {
+	if (mkfscfg.blobdev_path && mkfscfg.chunkbits < mkfs_blkszbits) {
 		erofs_err("--blobdev must be used together with --chunksize");
 		return -EINVAL;
 	}
 
 	/* TODO: can be implemented with (deviceslot) mapped_blkaddr */
-	if (cfg.c_blobdev_path &&
+	if (mkfscfg.blobdev_path &&
 	    cfg.c_force_chunkformat == FORCE_INODE_BLOCK_MAP) {
 		erofs_err("--blobdev cannot work with block map currently");
 		return -EINVAL;
@@ -1564,9 +1566,9 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		params->pclusterblks_max = pclustersize_max >> mkfs_blkszbits;
 		params->pclusterblks_def = params->pclusterblks_max;
 	}
-	if (cfg.c_chunkbits && cfg.c_chunkbits < mkfs_blkszbits) {
+	if (mkfscfg.chunkbits && mkfscfg.chunkbits < mkfs_blkszbits) {
 		erofs_err("chunksize %u must be larger than block size",
-			  1u << cfg.c_chunkbits);
+			  1u << mkfscfg.chunkbits);
 		return -EINVAL;
 	}
 
@@ -1579,10 +1581,10 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 	 * unaligned. Therefore, let's issue a warning here and still skip
 	 * alignment for now.
 	 */
-	if (cfg.c_chunkbits && dsunit &&
-	    (1u << (cfg.c_chunkbits - g_sbi.blkszbits)) < dsunit) {
+	if (mkfscfg.chunkbits && dsunit &&
+	    (1u << (mkfscfg.chunkbits - g_sbi.blkszbits)) < dsunit) {
 		erofs_warn("chunksize %u bytes is smaller than dsunit %u blocks, ignore dsunit !",
-			   1u << cfg.c_chunkbits, dsunit);
+			   1u << mkfscfg.chunkbits, dsunit);
 	}
 
 	if (pclustersize_packed) {
@@ -1896,26 +1898,28 @@ int main(int argc, char **argv)
 	importer_params.source = cfg.c_src_path;
 	importer_params.no_datainline = mkfs_no_datainline;
 	importer_params.dot_omitted = mkfs_dot_omitted;
+	if (importer_params.dedupe == EROFS_DEDUPE_FORCE_ON &&
+	    !mkfscfg.chunkbits && !mkfscfg.total_zcfgs) {
+		erofs_err("Compression is not enabled.  Turn on chunk-based data deduplication instead.");
+		mkfscfg.chunkbits = g_sbi.blkszbits;
+	}
+	importer_params.chunkszbits_def = mkfscfg.chunkbits;
 	err = erofs_importer_init(&importer);
 	if (err)
 		goto exit;
 
-	if (importer_params.dedupe == EROFS_DEDUPE_FORCE_ON) {
-		if (!g_sbi.available_compr_algs) {
-			erofs_err("Compression is not enabled.  Turn on chunk-based data deduplication instead.");
-			cfg.c_chunkbits = g_sbi.blkszbits;
-		} else {
-			err = z_erofs_dedupe_init(erofs_blksiz(&g_sbi));
-			if (err) {
-				erofs_err("failed to initialize deduplication: %s",
-					  erofs_strerror(err));
-				goto exit;
-			}
+	if (importer_params.dedupe == EROFS_DEDUPE_FORCE_ON &&
+	    g_sbi.available_compr_algs) {
+		err = z_erofs_dedupe_init(erofs_blksiz(&g_sbi));
+		if (err) {
+			erofs_err("failed to initialize deduplication: %s",
+				  erofs_strerror(err));
+			goto exit;
 		}
 	}
 
 	cfg.c_dedupe = importer_params.dedupe;
-	if (tar_index_512b || cfg.c_blobdev_path) {
+	if (tar_index_512b || mkfscfg.blobdev_path) {
 		err = erofs_mkfs_init_devices(&g_sbi, 1);
 		if (err) {
 			erofs_err("failed to generate device table: %s",
@@ -1924,9 +1928,9 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (tar_index_512b || cfg.c_chunkbits) {
-		if (g_sbi.extra_devices && cfg.c_blobdev_path) {
-			g_sbi.devs[0].src_path = strdup(cfg.c_blobdev_path);
+	if (tar_index_512b || mkfscfg.chunkbits) {
+		if (g_sbi.extra_devices && mkfscfg.blobdev_path) {
+			g_sbi.devs[0].src_path = strdup(mkfscfg.blobdev_path);
 			if (!g_sbi.devs[0].src_path) {
 				err = -ENOMEM;
 				goto exit;
@@ -1937,7 +1941,7 @@ int main(int argc, char **argv)
 				goto exit;
 
 		}
-		err = erofs_blob_init(&g_sbi, cfg.c_blobdev_path ? 1 : 0, cfg.c_chunkbits);
+		err = erofs_blob_init(&g_sbi, mkfscfg.blobdev_path ? 1 : 0, mkfscfg.chunkbits);
 		if (err)
 			goto exit;
 	}
@@ -2047,7 +2051,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (erofstar.index_mode || cfg.c_chunkbits || g_sbi.extra_devices) {
+	if (erofstar.index_mode || mkfscfg.chunkbits || g_sbi.extra_devices) {
 		err = erofs_mkfs_dump_blobs(&g_sbi);
 		if (err)
 			goto exit;
-- 
2.47.3


