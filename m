Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24744606A31E
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2026 04:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=oDCVha/v
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbKYj5C4vz2yGT;
	Fri, 27 Nov 2026 15:04:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::336"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795752281;
	cv=none; b=HDi6cmU3Wgnvj4b9t0bFqTYBP3wtZlIbikVrDhyJWvYG0D5CAWr3KvUDx9STKBJdaC3ZCXhjao01lV0TLvgnAVx918J/2/h5J8jp9kQalw3hEbnMl84eYyvNTYQneUZmK8BP2V9+q+C61EiVv2bj7vkbGLWhQix22+yubD6MVzd5KgJKlvhSsPNofZ/pIe92ziz7CCqlyafTxUoX94R3/0e25/j/elqNY06sSBUijdFeKcVpNUAQVjI2Q2QdwLHiXwI2s9MdYJvkEJKduDTnYydeGDLd62RJJg22O/ODB2VP1vmF6cq9m0AOGlfByA+texPRp4/W6RXVT0e7Lue30A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795752281; c=relaxed/relaxed;
	bh=NG6GGQAtikUw2rAX3rwc3FSGgngzqeUdZD3qmtQ3lg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4AbYUxn/uWCFg06DUbShjnUWtzEAOjnpH8sz17vq3E7+6pfW5pH/CxfP8R8TJldelm2fOqTzBwW/2fF8Ao8vKJZDQupyRWCcHrWoqpnDKxk1p38N0TvdbiYvBa48naIul/HtaGm4IJyGrd0J25h4ZLwnIV3dOCWYjxrt4Ks0SdjX0c4AFjXy9c06dwPCcbcmlwUDdKi6uQsLnFexwZfNWmvaimRtOM2E2Ea0zmx0Kn5oGVr1ELVojHLy1D9bTDe4eU+W10+unAxP3V1M2Z5Pm+bbLSNc2ao1NQp+y3FSaPxTaeqs918JwAWl992ftieqfCfu8zuS0eKCTEh4JlwwA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=oDCVha/v; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=oDCVha/v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbKYg2rg1z2xqh
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 15:04:39 +1100 (AEDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4b467581b98so73903735e9.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 20:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795752276; x=1796357076; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NG6GGQAtikUw2rAX3rwc3FSGgngzqeUdZD3qmtQ3lg8=;
        b=oDCVha/vAURjXaJBUH43YB1mKRE2nZchBZ2NU6hN47IK6db1NdC/xeBHzLtKEREUqW
         WOsZmaf0hLkZOw0hfgyMREnNCCYh61PEEZw2WsJoE5wDnyKV+0mRKjwvgrqWSU+gNxyf
         lrWEanUEIYOEcMSBDGzovUGOBoKmwxAhKHZywQ5ymCv/lxawkBgkXfwaBF5w3n22LzvS
         pDL935XdgIFbxdXj9bfWTmPsjIt9tojI6UJ+6tnUbpDxi4F9ZZmz7RDdLdZPLBWHKoRC
         HxxIKjNrLa7yhztCZUo98NX8VpZk+r6G6DOdKLBi5gga99B3fGB9UXeJ28+Fu/JY7Y/p
         Uihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752276; x=1796357076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NG6GGQAtikUw2rAX3rwc3FSGgngzqeUdZD3qmtQ3lg8=;
        b=kobIgaqkVJOOOdhQfCaU+uZbGxpWVbUYaWrIcjarFZW7HAq1J9SnPSdK4Jp8cxTNIG
         1hyNYr8rcDVuAMMS2gobJKM3vZk8q1IXwUU5kF2BdI08ZXjRe+F30B6560WfeeUXPNfD
         jm/Xq3c6AWKLyiyMBWIm2JIaCQvGww81GKjwz20skjYCFbuBkXh4kE0SHMPL6/ORBTot
         uy6xpX6ET3KjhQWy0/sRLQyrmdaMIZD5kL9EBd1A6cL21iJgyr15Ah5WYjti8nUAx2no
         zQCZqyKybCmZ/e5UaPGQQvJ6tEL7il+PBJAPfYYk/lvgobUhoTFVoYKxPv4uYk6/5k7Q
         1//g==
X-Gm-Message-State: APuU4Z8mWWiYOU5weIjCsZTcKHUeRmcZXo7SzEDf+1st3APzjqZWJIW2
	4gDMFmtWPdJu3LavTepLK8TyCI/3EXwwu4wgxzcc4wyKZPdYrFVKIWkArAzf2wDI72XRFWXket/
	u+O9U++o=
X-Gm-Gg: AZFdTZf+pghvln2LCExlu4YZ0ESXuLxSrxe0sxJp32fAl81ax+1VOz7ZVaM5J7PHsxk
	bZE+FWUzMHXIY50QTgHypg57/FynFxlkkbALBYoJzaIw14FFLK5xwgHCkWuSfXf3SZDVEkT1aUF
	tjoJ4mSfDxeGhvfKaqTBh3q19nXI2233GV872F0x12zQ60hSagghzNwJSPHkfFYc+nX4Boing8l
	9Ldvk+1TzdTo/JaDW3EZAJBRsAP8wyYX1qvAj4aA7hs6cReWDb8YdzHQcVCc7fas6yj9XqnoSku
	lqkYZzjOjVyLHcLpJEG0jII/Dbtel39SpLMwfSOq4iNYGEBlXBQGIh7OSDrq05HQyi9FHfhMqDW
	6W+KXuBgQL23vevAj/WPs9uhHcObPJvf7K9McLc64J126R1nPI08H2gq14YGkjOlCJHlJuPC4vq
	ZQR30+9dPLT8d09s1bG/6Z5gM1MG50rPuC6I2OmXXx/bWdZEY1IFBgj+VVG3JsDCSL8YXPf7E2O
	zGj2IKmydfoKgBhxmF7xpBzQo8aRSnmtyNtpiOUlcXBcUm4s067RzEmgSlfi4Ykh1kk9F9PRmU/
	aPKqyzF/Jpo9TYqbmnJpmhe3K7o8umBdlzJdyiEYLAZjnwA2RT6jcKYR9AbRVvLD38gW
X-Received: by 2002:a05:600c:1389:b0:4bb:7347:d5c0 with SMTP id 5b1f17b1804b1-4bb88826937mr421473685e9.9.1795752275851;
        Thu, 26 Nov 2026 20:04:35 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5cef:65d5:b333:e710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm388721725e9.2.2026.11.26.20.04.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 20:04:35 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v4 09/10] erofs-utils: mkfs: support multiple data devices per source
Date: Fri, 27 Nov 2026 05:04:26 +0100
Message-ID: <20261127040427.99710-3-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261127040427.99710-1-xiang.gao@docker.com>
References: <20261126120221.4384-1-xiang.gao@docker.com>
 <20261127040427.99710-1-xiang.gao@docker.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support source images that store file data in both the primary device
and external devices.

This changes the device list for TarFS fsmerge: source primary devices
are now included by default.  Use `--omit-fsmeta` to keep the previous
behavior, referencing only tar blobs.  Fail if data refers to an omitted
device.  Sources without external devices keep their primary device.

Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/compress.c         |  17 ++++--
 lib/liberofs_rebuild.h |   1 +
 lib/rebuild.c          |  58 +++++++++++++++-----
 man/mkfs.erofs.1       |   5 ++
 mkfs/main.c            | 117 +++++++++++++++++++++++++----------------
 5 files changed, 135 insertions(+), 63 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index e764e44..fac15b5 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -24,6 +24,7 @@
 #endif
 #include "liberofs_cache.h"
 #include "liberofs_compress.h"
+#include "liberofs_rebuild.h"
 #include "liberofs_fragments.h"
 #include "liberofs_metabox.h"
 #include "erofs/decompress.h"
@@ -2496,9 +2497,10 @@ int z_erofs_compress_exit(struct erofs_sb_info *sbi)
 	return 0;
 }
 
-int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
+int z_erofs_rebuild_load_metadata(struct erofs_rebuild_params *params,
 				  struct erofs_inode *inode)
 {
+	struct erofs_sb_info *dst_sbi = params->mergeroot->sbi;
 	struct erofs_sb_info *sbi = inode->sbi;
 	struct erofs_map_blocks map = {
 		.buf = __EROFS_BUF_INITIALIZER,
@@ -2532,6 +2534,15 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 		if (err)
 			goto err_out;
 
+		if (params->force_omit_fsmeta && (map.m_flags & EROFS_MAP_MAPPED) &&
+		    !(map.m_flags & (EROFS_MAP_META | __EROFS_MAP_FRAGMENT)) &&
+		    !mdev.m_deviceid) {
+			erofs_err("%s: file data refers to the source primary device",
+				  inode->i_srcpath);
+			err = -EINVAL;
+			goto err_out;
+		}
+
 		raw = (map.m_algorithmformat >= Z_EROFS_COMPRESSION_MAX);
 
 		ei = malloc(sizeof(*ei));
@@ -2562,7 +2573,7 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 				.length = map.m_llen,
 				.plen = erofs_blksiz(sbi),
 				.pstart = (pend != EROFS_NULL_ADDR ? pend : 0),
-				.device_id = inode->dev,	/* FIXME! */
+				.device_id = device_id < 0 ? 0 : device_id,
 				.raw = raw,
 				.inlined = true,
 			};
@@ -2575,7 +2586,7 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 				.length = map.m_llen,
 				.plen = map.m_plen,
 				.pstart = mdev.m_pa,
-				.device_id = inode->dev,	/* FIXME! */
+				.device_id = sbi->dev + mdev.m_deviceid - params->force_omit_fsmeta,
 				.partial = map.m_flags & EROFS_MAP_PARTIAL_REF,
 				.raw = raw,
 				.inlined = false,
diff --git a/lib/liberofs_rebuild.h b/lib/liberofs_rebuild.h
index 2cf228e..38b0b82 100644
--- a/lib/liberofs_rebuild.h
+++ b/lib/liberofs_rebuild.h
@@ -14,6 +14,7 @@ struct erofs_rebuild_params {
 	struct erofs_inode *mergeroot;
 	struct erofs_sb_info *sbi;
 	enum erofs_rebuild_datamode datamode;
+	bool force_omit_fsmeta;	/* reject data references to the primary device */
 };
 
 struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 6a4aff6..6161c12 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -243,12 +243,14 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 					  to_head, 0);
 }
 
-static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
+static int erofs_rebuild_load_chunk_index(struct erofs_rebuild_params *params,
 					  struct erofs_inode *inode)
 {
+	struct erofs_sb_info *dst_sb = params->mergeroot->sbi;
 	int ret;
-	unsigned int count, unit, chunkbits, i;
-	struct erofs_inode_chunk_index *idx;
+	unsigned int unit, chunkbits;
+	struct erofs_chunkitem **idx;
+	u64 count, i;
 	erofs_off_t chunksize;
 	erofs_blk_t blkaddr;
 
@@ -274,11 +276,13 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 	}
 
 	chunksize = 1ULL << chunkbits;
-	count = DIV_ROUND_UP(inode->i_size, chunksize);
+	count = inode->i_size / chunksize + !!(inode->i_size % chunksize);
 
 	unit = sizeof(struct erofs_inode_chunk_index);
+	if (count > min_t(u64, UINT_MAX, SSIZE_MAX) / unit)
+		return -E2BIG;
 	inode->extent_isize = count * unit;
-	idx = calloc(count, max(sizeof(*idx), sizeof(void *)));
+	idx = calloc(count, max_t(size_t, sizeof(*idx), unit));
 	if (!idx)
 		return -ENOMEM;
 	inode->chunkindexes = idx;
@@ -294,16 +298,43 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 		if (ret)
 			goto err;
 
-		blkaddr = erofs_blknr(dst_sb, map.m_pa);
-		chunk = erofs_get_unhashed_chunk(dst_sb, inode->dev, blkaddr, 0);
+		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+			chunk = erofs_get_unhashed_chunk(dst_sb, 0, EROFS_NULL_ADDR, 0);
+		} else {
+			struct erofs_sb_info *src = inode->sbi;
+			struct erofs_map_dev mdev = {
+				.m_deviceid = map.m_deviceid,
+				.m_pa = map.m_pa,
+			};
+
+			ret = erofs_map_dev(src, &mdev);
+			if (ret)
+				goto err;
+			blkaddr = erofs_blknr(src, mdev.m_pa);
+			/* dif->blocks may be 0; only uniaddr is valid for mapping */
+			if (erofs_blkoff(src, mdev.m_pa)) {
+				ret = -EFSCORRUPTED;
+				goto err;
+			}
+			if (params->force_omit_fsmeta && !mdev.m_deviceid) {
+				erofs_err("%s: file data refers to the source primary device",
+					  inode->i_srcpath);
+				ret = -EINVAL;
+				goto err;
+			}
+			chunk = erofs_get_unhashed_chunk(dst_sb,
+				params->sbi->dev + mdev.m_deviceid - params->force_omit_fsmeta,
+				blkaddr, 0);
+		}
 		if (IS_ERR(chunk)) {
 			ret = PTR_ERR(chunk);
 			goto err;
 		}
-		*(void **)idx++ = chunk;
+		*idx++ = chunk;
 
 	}
 	inode->datalayout = EROFS_INODE_CHUNK_BASED;
+	inode->u.chunkbits = chunkbits;
 	inode->u.chunkformat = EROFS_CHUNK_FORMAT_INDEXES;
 	inode->u.chunkformat |= chunkbits - dst_sb->blkszbits;
 	return 0;
@@ -313,15 +344,15 @@ err:
 	return ret;
 }
 
-static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
+static int erofs_rebuild_write_blob_index(struct erofs_rebuild_params *params,
 					  struct erofs_inode *inode)
 {
-	int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sb,
+	int z_erofs_rebuild_load_metadata(struct erofs_rebuild_params *params,
 					  struct erofs_inode *inode);
 
 	if (is_inode_layout_compression(inode))
-		return z_erofs_rebuild_load_metadata(dst_sb, inode);
-	return erofs_rebuild_load_chunk_index(dst_sb, inode);
+		return z_erofs_rebuild_load_metadata(params, inode);
+	return erofs_rebuild_load_chunk_index(params, inode);
 }
 
 static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
@@ -392,7 +423,6 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 static int erofs_rebuild_update_inode(struct erofs_rebuild_params *params,
 				      struct erofs_inode *inode)
 {
-	struct erofs_sb_info *dst_sb = params->mergeroot->sbi;
 	enum erofs_rebuild_datamode datamode = params->datamode;
 	int err = 0;
 
@@ -432,7 +462,7 @@ static int erofs_rebuild_update_inode(struct erofs_rebuild_params *params,
 			break;
 		}
 		if (datamode == EROFS_REBUILD_DATA_BLOB_INDEX)
-			err = erofs_rebuild_write_blob_index(dst_sb, inode);
+			err = erofs_rebuild_write_blob_index(params, inode);
 		else if (datamode == EROFS_REBUILD_DATA_RESVSP)
 			inode->datasource = EROFS_INODE_DATA_SOURCE_RESVSP;
 		else if (datamode == EROFS_REBUILD_DATA_FULL)
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 65ec807..a66025c 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -349,6 +349,11 @@ time.
 .BI "\-\-mount-point=" path
 Specify the prefix of target filesystem path (default: /).
 .TP
+.B \-\-omit-fsmeta
+Omit source fsmeta devices, e.g. for TarFS fsmerge with only tar blobs.
+Fail if data refers to an omitted device.
+Sources without external devices keep their primary device.
+.TP
 .BI "\-\-oci\fR[\fP=<f|i>\fR]\fP"
 Generate a full (f) or index-only (i) image from OCI remote source.
 Additional options can be specified:
diff --git a/mkfs/main.c b/mkfs/main.c
index ce93166..8ea18be 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -107,6 +107,7 @@ static struct option long_options[] = {
 	{"xattr-prefix", required_argument, NULL, 538},
 	{"xattr-inode-digest", optional_argument, NULL, 539},
 	{"manifest", required_argument, NULL, 540},
+	{"omit-fsmeta", no_argument, NULL, 541},
 	{0, 0, 0, 0},
 };
 
@@ -216,6 +217,7 @@ static void usage(int argc, char **argv)
 		" --max-extent-bytes=#   set maximum decompressed extent size # in bytes\n"
 		" --manifest=X           build an image from a manifest file X and DATADIR\n"
 		" --mount-point=X        X=prefix of target fs path (default: /)\n"
+		" --omit-fsmeta          omit source fsmeta devices in blob-index rebuilds\n"
 		" --preserve-mtime       keep per-file modification time strictly\n"
 		" --offset=#             skip # bytes at the beginning of IMAGE.\n"
 		" --root-xattr-isize=#   ensure the inline xattr size of the root directory is # bytes at least\n"
@@ -290,6 +292,7 @@ static struct erofsmkfs_cfg {
 	long inlinexattr_tolerance;
 	bool inode_metazone;
 	char chunkbits;
+	bool omit_fsmeta;
 	u64 unix_timestamp;
 	unsigned int total_zcfgs;
 } mkfscfg = {
@@ -1514,6 +1517,9 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			manifest_file = optarg;
 			source_mode = EROFS_MKFS_SOURCE_MANIFEST;
 			break;
+		case 541:
+			mkfscfg.omit_fsmeta = true;
+			break;
 		case 'V':
 			version();
 			exit(0);
@@ -1572,6 +1578,12 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			return err;
 	}
 
+	if (mkfscfg.omit_fsmeta && (source_mode != EROFS_MKFS_SOURCE_REBUILD ||
+			    dataimport_mode != EROFS_MKFS_DATA_IMPORT_DEFAULT)) {
+		erofs_err("--omit-fsmeta requires blob-index rebuild mode");
+		return -EINVAL;
+	}
+
 	if (quiet) {
 		cfg.c_dbg_lvl = EROFS_ERR;
 		cfg.c_showprogress = false;
@@ -1683,12 +1695,13 @@ void erofs_show_progs(int argc, char *argv[])
 
 static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 {
+	struct erofs_rebuild_params params = {
+		.mergeroot = root,
+	};
 	struct erofs_device_info *devs;
 	struct erofs_sb_info *src;
 	unsigned int extra_devices = 0;
-	erofs_blk_t nblocks;
 	int ret, idx;
-	struct erofs_rebuild_params params = { .mergeroot = root };
 
 	switch (dataimport_mode) {
 	case EROFS_MKFS_DATA_IMPORT_DEFAULT:
@@ -1704,59 +1717,71 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		return -EINVAL;
 	}
 
+	if (params.datamode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+		bool omit_fsmeta;
+
+		/* Assign device ranges in command-line order. */
+		list_for_each_entry_reverse(src, &rebuild_src_list, list) {
+			ret = erofs_read_superblock(src);
+			if (ret)
+				return ret;
+			if (src->blkszbits != g_sbi.blkszbits) {
+				erofs_err("%s: source block size differs from the output",
+					  src->dif0.src_path);
+				return -EINVAL;
+			}
+			omit_fsmeta = mkfscfg.omit_fsmeta && src->extra_devices;
+			if (src->extra_devices >= ARRAY_SIZE(src->blobfd) ||
+			    src->extra_devices + !omit_fsmeta > UINT16_MAX - extra_devices)
+				return -E2BIG;
+			src->dev = extra_devices + 1;
+			extra_devices += src->extra_devices + !omit_fsmeta;
+		}
+		ret = erofs_mkfs_init_devices(&g_sbi, extra_devices);
+		if (ret)
+			return ret;
+		list_for_each_entry(src, &rebuild_src_list, list) {
+			omit_fsmeta = mkfscfg.omit_fsmeta && src->extra_devices;
+			if (!omit_fsmeta) {
+				devs = g_sbi.devs + src->dev - 1;
+				devs->blocks = src->dif0.blocks;
+				/* Preserve the source filename for --vmdk-desc extent paths. */
+				devs->src_path = strdup(src->dif0.src_path);
+				if (!devs->src_path)
+					return -ENOMEM;
+				erofs_uuid_unparse_as_tag(src->uuid, (char *)devs->tag);
+			}
+			for (idx = 0; idx < src->extra_devices; ++idx) {
+				devs = g_sbi.devs + src->dev + idx - omit_fsmeta;
+				devs->blocks = src->devs[idx].blocks;
+				memcpy(devs->tag, src->devs[idx].tag, sizeof(devs->tag));
+				if (omit_fsmeta && !idx && !devs->tag[0])
+					erofs_uuid_unparse_as_tag(src->uuid, (char *)devs->tag);
+			}
+		}
+	}
+
 	list_for_each_entry(src, &rebuild_src_list, list) {
+		if (params.datamode == EROFS_REBUILD_DATA_FULL) {
+			ret = erofs_read_superblock(src);
+			if (ret)
+				return ret;
+			/* TODO: read file data from the actual source device. */
+			if (src->extra_devices) {
+				erofs_err("%s: full-data rebuilds with external devices are not supported",
+					  src->dif0.src_path);
+				return -EOPNOTSUPP;
+			}
+		}
 		src->xamgr = g_sbi.xamgr;
 		params.sbi = src;
+		params.force_omit_fsmeta = mkfscfg.omit_fsmeta && src->extra_devices;
 		ret = erofs_rebuild_load_tree(&params);
 		src->xamgr = NULL;
 		if (ret) {
 			erofs_err("failed to load %s", src->dif0.src_path);
 			return ret;
 		}
-		if (src->extra_devices > 1) {
-			erofs_err("%s: unsupported number %u of extra devices",
-				  src->dif0.src_path, src->extra_devices);
-			return -EOPNOTSUPP;
-		}
-		extra_devices += src->extra_devices;
-	}
-
-	if (params.datamode == EROFS_REBUILD_DATA_RESVSP)
-		return 0;
-
-	/* Each blob has either no extra device or only one device for TarFS */
-	if (extra_devices && extra_devices != rebuild_src_count) {
-		erofs_err("extra_devices(%u) is mismatched with source images(%u)",
-			  extra_devices, rebuild_src_count);
-		return -EOPNOTSUPP;
-	}
-
-	if (params.datamode == EROFS_REBUILD_DATA_FULL)
-		return 0;
-
-	ret = erofs_mkfs_init_devices(&g_sbi, rebuild_src_count);
-	if (ret)
-		return ret;
-
-	devs = g_sbi.devs;
-	list_for_each_entry(src, &rebuild_src_list, list) {
-		u8 *tag = NULL;
-
-		DBG_BUGON(src->dev < 1);
-		idx = src->dev - 1;
-		if (extra_devices) {
-			nblocks = src->devs[0].blocks;
-			tag = src->devs[0].tag;
-		} else {
-			nblocks = src->dif0.blocks;
-			devs[idx].src_path = strdup(src->dif0.src_path);
-		}
-		devs[idx].blocks = nblocks;
-		if (tag && *tag)
-			memcpy(devs[idx].tag, tag, sizeof(devs[0].tag));
-		else
-			/* convert UUID of the source image to a hex string */
-			erofs_uuid_unparse_as_tag(src->uuid, (char *)devs[idx].tag);
 	}
 	return 0;
 }
-- 
2.54.0 (Apple Git-157)


