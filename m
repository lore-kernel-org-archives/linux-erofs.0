Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C5E606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=mC86S49a
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbKYm66FCz2xLg;
	Fri, 27 Nov 2026 15:04:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795752284;
	cv=none; b=BmUNXKYkvKWIo2u2e23dfOUOlOnBqgSBcktIMO9NB3pB4aJvOjxyjZiZuLzJetCcp2MX37WXTi9buQr2DFBU9cVN/F5D3MvDcMtpWAY0HyHS1kIP35WUJzCqYavh1psI9MC5zbfINlK6kjmjphbF7NJ45GQH7zTBPyPQByspHrWe0SguVvzgVYgW6WSCY0ZyOq/Voic/f5eiqsitCiPItxRHh70k5Sk8WYHx85NlldQdtab32WeA+QfnemymjXAUpBL9Oj6usKFWN26UlsUba2Yf2z0lKgjnJd0dag60Je+aAN9fdzb9d/zisQ1oqz4Xh2P/fZXFZFa6nMJxC4WvCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795752284; c=relaxed/relaxed;
	bh=4w80lilRd3pVzEEkOUb0yHHuHYKCxHb156GYjQQX5cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUNCzEf5vooxP+ZGNHO56OsSGQz+qeL3x/qOuGaO1Kn1z5gOiMl4HrXiph1Uw/Uc6ayeqBuvNThy5ByYjAuWvkROymrKaStnNQtj91op6R+gcXgF1zmcc/EXnEB2oxKGLwpaZJX3e1mpOlprZaxvyoa9F1y+WKyrhIyhBr0VUUjY8BzOYbOb3R1P2FwmxoRdNcIQn8BH1Juqg7MSDciuTT7ogTliAyFoqRWMrrfZ+FNyIX8Q17GVs0vnWG76y46ORyK+vIvRfAmGUfXBKdKF8b5LZ8oyp4H10NpMs7y6iUoB4p0prm5fXgUYBZ7K0iFeDkmVuieAp6vDPliKb8tmwQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=mC86S49a; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=mC86S49a;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbKYk4Ljpz2xqh
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 15:04:42 +1100 (AEDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so77206685e9.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 20:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795752279; x=1796357079; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4w80lilRd3pVzEEkOUb0yHHuHYKCxHb156GYjQQX5cE=;
        b=mC86S49aMpk9ip5nLCTF6uJJPeVhdbeBwYZvpbwqW6rBQiV6h1att8uwf1+rhJruR4
         EbxhvZaIgRpO0tjkUbllF8r5gXNeF8ywN7nNfrzJS/7Oa3BsvDhWDR6kzyddO3sfnkTQ
         vmS5/UbD6+etrCVw4sInbiZZzGmljNeg9aGW76cBjLD2WLShPqGdMS9K7rufhNeHZOn3
         4Ifc60Xbl4dxls7FDmA8IPNphbYlHEQEWe+liAHOi4N6aLIx+omhjy1F9+MYvHivL5BD
         i0uArv7uqp7iFKWmZoPSWhgB6VJX02zjVJ38savWzxPYxNK6U911Xag1UhH/9jawKwVY
         ekcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752279; x=1796357079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4w80lilRd3pVzEEkOUb0yHHuHYKCxHb156GYjQQX5cE=;
        b=GP3rsvA6ytCej3wRnf1nTxctL6Pcvj4OGK11pwRd1J8udKsB02PFKkQivgDUqsuDbW
         G0AyqQtt+3zUrggZflSG4n3LwtPoAEt0xdSuRaC1uu1NpejFWr4qxtFCX8rTmRwnHUvA
         L8xSszAqNNbkhuDuIKQotf27C43lUQw7bdcDS/mBFSlTnWI7Q6PFe6LWrFm19UFbazxe
         xKrsKtAzZC29jzJajQU31brPWh3EyQKosaIhT+670St8Xrjsik6FCvvAYUF6pznqzH/M
         FXgTb96VkI985dTnjY2GAbYMY20AxFHM+5f7VQYvAk7CbazQGqtuYFHhZm3w5W9iOH/z
         NaZA==
X-Gm-Message-State: APuU4Z92UdqLR+nAhev2r3/r6d7B/3L/IVKoUDpOP58JTNjQIxKsGnhL
	dJs1TAAA1nMbSFEQUsC3527CNLpZMP+ExK4BQ1/oymce7ZzoVDyeG66n7MT1dNgtitc9Z4y7K25
	iT8mpa1A=
X-Gm-Gg: AZFdTZfI0e9JfdnHqvFhstrlg38Uo7pbMcGrD1CZ223VrOItyswfXA6e9nUVFcwEHPt
	6GfXAcB5aSUnvSxUC7myv0QUdFLxShtzrKqPW6/nc32vv/zyfdp+H+ayRHU2s/ylxVnx16Pkq7+
	XS7SFs5R+uXJJtpro7LRFkMeiDlEz81plIJ5Zred1g0aZO06XMvQRZ51o/sfadgiH2s3mzwG7L/
	icKR5LnQminN57FQTvjHXAExuVBeHoxNxMBAICtq3n7lNRHTSCKvt15Q5BAnqz5IwcsccB5QNJB
	B2mXhjL1+duEaPisBPppiVGx+Mok5lg5MC4FzFQASQpgBIRP1nDXLs0MMTjud4vU/Pt6BOh3bp+
	2fQMA2WVythF8s2q4fYpFjNFqU4X7HqsJhCaq1GuIDc40oVxHoqqWt2/nnCbarkalFCU7Dp+Xp+
	zz+QvgxvxKm4vkXosFafIacEAhum8aaKtnhmvj6ZWBlaq7GNiq+oPE07TWwpvkhWY1Z7LwvA7Fi
	rnCPvRh4BHOalII16nsiamPsy3Y3H/8BVLPsINje4NV6mO71rJ4uwpD9YOxOzA9TFdaFHb29+tJ
	YpiqAmT2CRr13deDYX3zr4fPBg4AUS2V3b6wcxeQVu5XPET9kUXfy4J+58WIl2qhj1cw
X-Received: by 2002:a05:600c:1da9:b0:4b1:2026:6b41 with SMTP id 5b1f17b1804b1-4bb88819294mr478016535e9.30.1795752279123;
        Thu, 26 Nov 2026 20:04:39 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5cef:65d5:b333:e710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm388721725e9.2.2026.11.26.20.04.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 20:04:37 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v4 10/10] erofs-utils: mkfs: support file deltas in manifests
Date: Fri, 27 Nov 2026 05:04:27 +0100
Message-ID: <20261127040427.99710-4-xiang.gao@docker.com>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yifan Zhao <stopire@gmail.com>

Add DIFF[format] manifest records to apply file updates after merging
source images.  Initially support DM_SNAP for sealed dm-persistent
snapshot COW stores, with COW paths relative to the manifest data
directory.

For example, add the following record to `foo.m`:

  DIFF[DM_SNAP] /disk disk_cow

Then apply it to the merged source tree:

  mkfs.erofs --manifest=foo.m l2.erofs l0.erofs l1.erofs datadir/

Note that delta updates currently require a chunk-based inode layout:

 - Reuse unchanged chunk indexes and split inherited chunks as needed
   to match replacement boundaries;

 - Write changed data to the primary device and turn all-zero
   replacement chunks into holes;

 - Preserve file sizes and hard links;

 - Apply records in manifest order, with later records overriding
   overlapping changes to the same inode.

Other on-disk layouts like PLAIN, INLINE, and, most importantly,
COMPRESSED will be implemented as follow-ups.  Preparing targets
from local files, full-data or reserved-space imports, and refreshing
inode-digest xattrs remain TODOs.

Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 include/erofs/xattr.h |   1 +
 lib/blobchunk.c       | 130 ++++++++++++++++++++++++++++++++++++++++-
 lib/inode.c           |   4 +-
 lib/liberofs_chunk.h  |   3 +
 lib/manifest.c        | 131 +++++++++++++++++++++++++++++++-----------
 lib/rebuild.c         |  12 ++--
 lib/xattr.c           |  17 ++++++
 mkfs/main.c           | 119 +++++++++++++++++++++++---------------
 8 files changed, 330 insertions(+), 87 deletions(-)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index c1cfd01..d46d9cc 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -34,6 +34,7 @@ ssize_t erofs_sys_lsetxattr(const char *path, const char *name,
 int erofs_xattr_init(struct erofs_sb_info *sbi);
 int erofs_scan_file_xattrs(struct erofs_inode *inode);
 void erofs_inode_clear_xattrs(struct erofs_inode *inode);
+void erofs_inode_clear_digest(struct erofs_inode *inode);
 int erofs_prepare_xattr_ibody(struct erofs_inode *inode, bool noroom);
 char *erofs_export_xattr_ibody(struct erofs_inode *inode);
 int erofs_load_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *path,
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index a3a88d3..5b51d93 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -10,6 +10,7 @@
 #include "erofs/importer.h"
 #include "liberofs_cache.h"
 #include "liberofs_chunk.h"
+#include "liberofs_file_delta.h"
 #include "liberofs_private.h"
 #include "liberofs_sha256.h"
 #include <unistd.h>
@@ -81,8 +82,7 @@ static unsigned int memhash(const void *buf, size_t len)
 }
 
 static struct erofs_chunkitem *erofs_get_chunk(struct erofs_sb_info *sbi,
-					       int device_id,
-					       u8 *buf, u64 size)
+					       int device_id, u8 *buf, u64 size)
 {
 	struct erofs_bufmgr *bmgr = device_id ? sbi->devs[device_id - 1].bmgr : sbi->bmgr;
 	struct erofs_chunkmgr *chunkmgr = sbi->chunkmgr;
@@ -161,6 +161,132 @@ static struct erofs_chunkitem *erofs_get_chunk(struct erofs_sb_info *sbi,
 	return chunk;
 }
 
+/* Bound the buffer for a single newly written chunk, even after extent merging. */
+#define EROFS_DELTA_CHUNK_MAX_BITS	26
+
+int erofs_chunk_apply_deltas(struct erofs_inode *inode,
+			     struct erofs_file_delta *fdl)
+{
+	struct erofs_sb_info *sbi = inode->sbi;
+	struct erofs_delta_map delta;
+	struct erofs_chunkitem **indexes, **old = inode->chunkindexes, *chunk;
+	erofs_off_t pos, alignment, len;
+	unsigned int oldbits, chunkbits;
+	u64 count, i;
+	size_t buflen;
+	u8 *buf = NULL;
+	int ret;
+
+	if (inode->datalayout != EROFS_INODE_CHUNK_BASED)
+		return -EOPNOTSUPP;
+	if (!fdl)
+		return 0;
+	alignment = fdl->ops->get_alignment(fdl);
+	if (!alignment)
+		return 0;
+	DBG_BUGON(!old);
+	oldbits = inode->u.chunkbits;
+	chunkbits = min_t(unsigned int, oldbits, ilog2(alignment));
+	chunkbits = min_t(unsigned int, chunkbits, EROFS_DELTA_CHUNK_MAX_BITS);
+	if (chunkbits < sbi->blkszbits)
+		return -EOPNOTSUPP;
+	count = round_up(inode->i_size, 1ULL << chunkbits) >> chunkbits;
+	if (count > min_t(u64, UINT_MAX, SSIZE_MAX) /
+		    sizeof(struct erofs_inode_chunk_index))
+		return -E2BIG;
+	indexes = calloc(count, sizeof(*indexes));
+	if (!indexes)
+		return -ENOMEM;
+	ret = erofs_blob_init(sbi, 0);
+	if (ret)
+		goto out;
+	for (i = 0; i < count; ++i) {
+		erofs_off_t within;
+
+		pos = i << chunkbits;
+		chunk = old[pos >> oldbits];
+		within = pos & ((1ULL << oldbits) - 1);
+		if (within && chunk->blkaddr != EROFS_NULL_ADDR) {
+			chunk = erofs_get_unhashed_chunk(sbi, chunk->device_id,
+				chunk->blkaddr + erofs_blknr(sbi, within), 0);
+			if (IS_ERR(chunk)) {
+				ret = PTR_ERR(chunk);
+				goto out;
+			}
+		}
+		indexes[i] = chunk;
+	}
+	delta.offset = 0;
+	while (delta.offset < inode->i_size) {
+		pos = delta.offset;
+		ret = fdl->ops->map(fdl, &delta);
+		if (ret)
+			goto out;
+		if (!delta.length)
+			break;
+		if (delta.offset < pos) {
+			ret = -EINVAL;
+			goto out;
+		}
+		if (delta.offset >= inode->i_size)
+			break;
+		delta.length = min(delta.length, inode->i_size - delta.offset);
+		if (delta.vf && delta.sourceoffset > UINT64_MAX - delta.length) {
+			ret = -EINVAL;
+			goto out;
+		}
+		if (delta.vf && !buf) {
+			buflen = min_t(erofs_off_t, 1ULL << chunkbits, inode->i_size);
+			buf = malloc(buflen);
+			if (!buf) {
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+		for (pos = 0; pos < delta.length; pos += len) {
+			bool zero = !delta.vf;
+
+			len = min_t(erofs_off_t, 1ULL << chunkbits, delta.length - pos);
+			if (!zero) {
+				const u8 *p = buf, *end = buf + len;
+
+				ret = erofs_pread(delta.vf, buf, len,
+						  delta.sourceoffset + pos);
+				if (ret)
+					goto out;
+				while (p < end && !*p)
+					++p;
+				zero = p == end;
+			}
+			/* All-zero chunks collapse into a hole. */
+			if (zero)
+				chunk = erofs_get_unhashed_chunk(sbi, 0, EROFS_NULL_ADDR, 0);
+			else
+				chunk = erofs_get_chunk(sbi, 0, buf, len);
+			if (IS_ERR(chunk)) {
+				ret = PTR_ERR(chunk);
+				goto out;
+			}
+			indexes[(delta.offset + pos) >> chunkbits] = chunk;
+		}
+		delta.offset += delta.length;
+	}
+	free(old);
+	inode->chunkindexes = indexes;
+	inode->extent_isize = count * sizeof(struct erofs_inode_chunk_index);
+	inode->datalayout = EROFS_INODE_CHUNK_BASED;
+	inode->u.chunkbits = chunkbits;
+	inode->u.chunkformat = (inode->u.chunkformat & EROFS_CHUNK_FORMAT_48BIT) |
+		EROFS_CHUNK_FORMAT_INDEXES |
+		(chunkbits - sbi->blkszbits);
+	indexes = NULL;
+	ret = 0;
+out:
+	free(buf);
+	free(indexes);
+	return ret;
+}
+
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode)
 {
 	unsigned int unit, src;
diff --git a/lib/inode.c b/lib/inode.c
index ef39a4e..10fc336 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1021,8 +1021,10 @@ static int erofs_prepare_inode_buffer(struct erofs_importer *im,
 		goto noinline;
 
 	/* TODO: tailpacking inline of chunk-based format isn't finalized */
-	if (inode->datalayout == EROFS_INODE_CHUNK_BASED)
+	if (inode->datalayout == EROFS_INODE_CHUNK_BASED) {
+		erofs_sb_set_chunked_file(sbi);
 		goto noinline;
+	}
 
 	if (!is_inode_layout_compression(inode)) {
 		if (params->no_datainline && S_ISREG(inode->i_mode)) {
diff --git a/lib/liberofs_chunk.h b/lib/liberofs_chunk.h
index 4ef6640..bf73bc6 100644
--- a/lib/liberofs_chunk.h
+++ b/lib/liberofs_chunk.h
@@ -17,6 +17,9 @@ extern "C"
 struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
 		unsigned int device_id, erofs_blk_t blkaddr,
 		erofs_off_t sourceoffset);
+struct erofs_file_delta;
+int erofs_chunk_apply_deltas(struct erofs_inode *inode,
+			     struct erofs_file_delta *fdl);
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode);
 s64 erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 				 erofs_off_t off);
diff --git a/lib/manifest.c b/lib/manifest.c
index 827c588..f6f84ce 100644
--- a/lib/manifest.c
+++ b/lib/manifest.c
@@ -11,6 +11,8 @@
 #include "erofs/print.h"
 #include "erofs/manifest.h"
 #include "liberofs_rebuild.h"
+#include "liberofs_file_delta.h"
+#include "liberofs_chunk.h"
 
 #ifndef HAVE_STRSEP
 static char *__erofs_strsep(char **stringp, const char *delim)
@@ -111,7 +113,8 @@ static int erofs_manifest_decode(char *s)
 }
 
 static int erofs_manifest_load_local(struct erofs_importer *im,
-		struct erofs_inode *root, char *imagepath, const char *srcpath)
+		struct erofs_inode *root,
+		char *imagepath, const char *srcpath, bool delta_fmt)
 {
 	struct erofs_inode *inode, *parent;
 	struct erofs_dentry *d;
@@ -119,15 +122,52 @@ static int erofs_manifest_load_local(struct erofs_importer *im,
 	bool dumb, existing;
 	int ret;
 
-	ret = erofs_os_lstat(srcpath, &st) ? -errno : 0;
-	if (ret)
-		return ret;
-
+	if (delta_fmt && cfg.c_force_chunkformat == FORCE_INODE_BLOCK_MAP)
+		return -EOPNOTSUPP;
 	d = erofs_rebuild_get_dentry(root, imagepath, false,
 				      &dumb, &dumb, false);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 	existing = !d || d->type != EROFS_FT_UNKNOWN;
+
+	if (delta_fmt) {
+		struct erofs_file_delta *fdl;
+		struct erofs_vfile input = {};
+
+		if (!existing) {
+			ret = -ENOENT;
+			goto out_dentry;
+		}
+		inode = d ? d->inode : root;
+		if (!S_ISREG(inode->i_mode) || !inode->i_size)
+			return -EINVAL;
+		/* TODO: prepare chunk indexes for locally imported targets. */
+		if (inode->datalayout != EROFS_INODE_CHUNK_BASED || !inode->chunkindexes)
+			return -EOPNOTSUPP;
+		input.fd = erofs_os_open(srcpath, O_RDONLY | O_BINARY);
+		if (input.fd < 0)
+			return -errno;
+		fdl = erofs_dm_persistent_open(&input);
+		if (IS_ERR(fdl)) {
+			ret = PTR_ERR(fdl);
+		} else {
+			ret = erofs_chunk_apply_deltas(inode, fdl);
+			/* TODO: update inode digest xattrs after COW updates. */
+			if (!ret)
+				erofs_inode_clear_digest(inode);
+			fdl->ops->close(fdl);
+		}
+		erofs_io_close(&input);
+		return ret;
+	}
+
+	ret = erofs_os_lstat(srcpath, &st) ? -errno : 0;
+	if (ret) {
+		if (!existing)
+			goto out_dentry;
+		return ret;
+	}
+
 	if (existing) {
 		inode = d ? d->inode : root;
 		/* Allow updating directory meta while preserving existing children */
@@ -208,34 +248,49 @@ out_dentry:
 }
 
 static int erofs_manifest_parse_record(struct erofs_importer *im,
-				 struct erofs_inode *root, char *line)
+		struct erofs_inode *root,
+		char *line)
 {
-	char *fields[2], *token, *path;
-	int i, ret;
+	char *fields[3], *token, *imagepath, *srcpath;
+	unsigned int nr = 0;
+	bool dm_snap = false;
+	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(fields); ++i) {
-		do {
-			token = strsep(&line, " ");
-		} while (token && !*token);
-		if (!token)
+	while ((token = strsep(&line, " "))) {
+		if (!*token)
+			continue;
+		if (nr == ARRAY_SIZE(fields))
 			return -EINVAL;
-		fields[i] = token;
+		fields[nr++] = token;
 	}
-	while ((token = strsep(&line, " ")))
-		if (*token)
-			return -EINVAL;
+	if (!nr)
+		return -EINVAL;
+	if (!strncmp(fields[0], "DIFF[", 5)) {
+		size_t len = strlen(fields[0]);
 
-	if (erofs_manifest_decode(fields[0]) || *fields[0] != '/' ||
-	    erofs_manifest_decode(fields[1]))
+		if (len <= 6 || fields[0][len - 1] != ']' || nr != 3)
+			return -EINVAL;
+		fields[0][len - 1] = '\0';
+		if (strcmp(fields[0] + 5, "DM_SNAP"))
+			return -EOPNOTSUPP;
+		dm_snap = true;
+	}
+	if (nr != (dm_snap ? 3 : 2))
 		return -EINVAL;
-	if (asprintf(&path, "%s/%s", im->params->source, fields[1]) < 0)
+	imagepath = fields[dm_snap ? 1 : 0];
+	token = fields[dm_snap ? 2 : 1];
+	if (erofs_manifest_decode(imagepath) || *imagepath != '/' ||
+	    erofs_manifest_decode(token))
+		return -EINVAL;
+	if (asprintf(&srcpath, "%s/%s", im->params->source, token) < 0)
 		return -ENOMEM;
-	ret = erofs_manifest_load_local(im, root, fields[0], path);
-	free(path);
+	ret = erofs_manifest_load_local(im, root,
+				       imagepath, srcpath, dm_snap);
+	free(srcpath);
 	return ret;
 }
 
-/* The importer has not taken ownership of the tree on a parse error. */
+/* The importer has not taken ownership of a new tree on a load error. */
 static void erofs_manifest_drop_children(struct erofs_inode *dir)
 {
 	struct erofs_dentry *d, *next;
@@ -253,18 +308,26 @@ static void erofs_manifest_drop_children(struct erofs_inode *dir)
 
 int erofs_manifest_load(struct erofs_importer *im, FILE *fp)
 {
-	struct erofs_inode *root;
+	struct erofs_inode *root = im->root;
+	bool newroot = !root;
 	char *line = NULL;
 	size_t capacity = 0;
 	unsigned long lineno = 0;
 	ssize_t len;
 	int ret = 0;
 
-	root = erofs_make_empty_root_inode(im, im->sbi);
-	if (IS_ERR(root))
-		return PTR_ERR(root);
-	/* Synthesized directories do not belong to the base image. */
-	root->dev = im->sbi->dev + 1;
+	if (newroot) {
+		root = erofs_make_empty_root_inode(im, im->sbi);
+		if (IS_ERR(root))
+			return PTR_ERR(root);
+	}
+	/*
+	 * Directories created for manifest paths inherit root->dev but have
+	 * no base NID.
+	 * Keep them out of base directory reads until incremental merging
+	 * finds an existing directory and sets its device and NID.
+	 */
+	root->dev = UINT32_MAX;
 
 	while ((len = getline(&line, &capacity, fp)) >= 0) {
 		++lineno;
@@ -290,13 +353,15 @@ int erofs_manifest_load(struct erofs_importer *im, FILE *fp)
 	if (!ret && !lineno)
 		ret = -EINVAL;
 	if (ret) {
-		erofs_manifest_drop_children(root);
-		erofs_iput(root);
+		if (newroot) {
+			erofs_manifest_drop_children(root);
+			erofs_iput(root);
+		}
 		erofs_err("failed to parse manifest at line %lu: %s",
 			  lineno, erofs_strerror(ret));
-	} else {
-		im->root = root;
 	}
+	if (!ret)
+		im->root = root;
 	free(line);
 	return ret;
 }
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 6161c12..5249968 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -673,7 +673,8 @@ int erofs_rebuild_load_tree(struct erofs_rebuild_params *params)
 		    !erofs_sb_has_big_pcluster(dst_sbi)) {
 			erofs_err("failed to load tree from image %d with big pclusters",
 				  sbi->dev);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto out;
 		}
 		if (erofs_sb_has_48bit(sbi))
 			erofs_sb_set_48bit(dst_sbi);
@@ -684,11 +685,13 @@ int erofs_rebuild_load_tree(struct erofs_rebuild_params *params)
 	ret = erofs_read_inode_from_disk(&inode);
 	if (ret) {
 		erofs_err("failed to read root inode of %s", fsid);
-		return ret;
+		goto out;
 	}
 	inode.i_srcpath = strdup("/");
-	if (!inode.i_srcpath)
-		return -ENOMEM;
+	if (!inode.i_srcpath) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	ctx = (struct erofs_rebuild_dir_context) {
 		.ctx.dir = &inode,
@@ -697,6 +700,7 @@ int erofs_rebuild_load_tree(struct erofs_rebuild_params *params)
 		.params = params,
 	};
 	ret = erofs_iterate_dir(&ctx.ctx, false);
+out:
 	free(inode.i_srcpath);
 	return ret;
 }
diff --git a/lib/xattr.c b/lib/xattr.c
index 0647b3b..95158e5 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -597,6 +597,23 @@ static void erofs_removexattr(struct erofs_inode *inode, const char *key)
 	}
 }
 
+void erofs_inode_clear_digest(struct erofs_inode *inode)
+{
+	u8 prefix = inode->sbi->ishare_xattr_prefix_id;
+	struct erofs_inode_xattr_node *node, *n;
+
+	if (!prefix)
+		return;
+	list_for_each_entry_safe(node, n, &inode->i_xattrs, list) {
+		if (node->item->prefix != prefix ||
+		    node->item->len[0] != node->item->prefix_len)
+			continue;
+		list_del(&node->list);
+		put_xattritem(node->item);
+		free(node);
+	}
+}
+
 static const char * const erofs_ovl_xattr_names[] = {
 	[EROFS_OVL_XATTR_OPAQUE] = OVL_XATTR_OPAQUE,
 	[EROFS_OVL_XATTR_ORIGIN] = OVL_XATTR_ORIGIN,
diff --git a/mkfs/main.c b/mkfs/main.c
index 8ea18be..0601b83 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -27,6 +27,7 @@
 #include "erofs/manifest.h"
 #include "../lib/compressor.h"
 #include "../lib/liberofs_chunk.h"
+#include "../lib/liberofs_file_delta.h"
 #include "../lib/liberofs_gzran.h"
 #include "../lib/liberofs_metabox.h"
 #include "../lib/liberofs_oci.h"
@@ -215,7 +216,7 @@ static void usage(int argc, char **argv)
 		" --hard-dereference     dereference hardlinks, add links as separate inodes\n"
 		" --ignore-mtime         use build time instead of strict per-file modification time\n"
 		" --max-extent-bytes=#   set maximum decompressed extent size # in bytes\n"
-		" --manifest=X           build an image from a manifest file X and DATADIR\n"
+		" --manifest=X           build from manifest X and DATADIR, optionally with base images\n"
 		" --mount-point=X        X=prefix of target fs path (default: /)\n"
 		" --omit-fsmeta          omit source fsmeta devices in blob-index rebuilds\n"
 		" --preserve-mtime       keep per-file modification time strictly\n"
@@ -330,12 +331,12 @@ static enum {
 	EROFS_MKFS_SOURCE_S3,
 	EROFS_MKFS_SOURCE_OCI,
 	EROFS_MKFS_SOURCE_REBUILD,
-	EROFS_MKFS_SOURCE_MANIFEST,
 } source_mode;
 
 static const char *manifest_file;
 static unsigned int rebuild_src_count;
 static LIST_HEAD(rebuild_src_list);
+static bool mkfs_manifest_rebuild;
 static u8 fixeduuid[16];
 static bool valid_fixeduuid;
 static unsigned int dsunit;
@@ -976,10 +977,14 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 {
 	erofs_os_stat_t st;
 	int err, fd;
-	char *s;
+	char *s, *datadir = NULL;
 
+	if (manifest_file) {
+		datadir = argv[--argc];
+		if (optind == argc)
+			goto out_datadir;
+	}
 	switch (source_mode) {
-	case EROFS_MKFS_SOURCE_MANIFEST:
 	case EROFS_MKFS_SOURCE_LOCALDIR:
 		err = erofs_os_lstat((s = argv[optind++]), &st);
 		if (err) {
@@ -988,16 +993,15 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 			return -ENOENT;
 		}
 		if (S_ISDIR(st.st_mode)) {
+			if (datadir)
+				return -EINVAL;
 			cfg.c_src_path = erofs_os_realpath(s, NULL);
 			if (!cfg.c_src_path) {
 				erofs_err("failed to parse source directory: %s",
 					  erofs_strerror(-errno));
 				return -ENOENT;
 			}
-			if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR)
-				erofs_set_fs_root(cfg.c_src_path);
-		} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
-			return -ENOTDIR;
+			erofs_set_fs_root(cfg.c_src_path);
 		} else {
 			cfg.c_src_path = strdup(s);
 			if (!cfg.c_src_path)
@@ -1080,6 +1084,18 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 		erofs_err("unexpected argument: %s\n", argv[optind]);
 		return -EINVAL;
 	}
+out_datadir:
+	if (datadir) {
+		if (erofs_os_stat(datadir, &st))
+			return -errno;
+		if (!S_ISDIR(st.st_mode))
+			return -ENOTDIR;
+		s = erofs_os_realpath(datadir, NULL);
+		if (!s)
+			return -errno;
+		free(cfg.c_src_path);
+		cfg.c_src_path = s;
+	}
 	return 0;
 }
 
@@ -1286,7 +1302,6 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 					  optarg);
 				return -EINVAL;
 			}
-			erofs_sb_set_chunked_file(&g_sbi);
 			break;
 		case 12:
 			quiet = true;
@@ -1515,7 +1530,6 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return -EOPNOTSUPP;
 			}
 			manifest_file = optarg;
-			source_mode = EROFS_MKFS_SOURCE_MANIFEST;
 			break;
 		case 541:
 			mkfscfg.omit_fsmeta = true;
@@ -1532,6 +1546,9 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		}
 	}
 
+	if (manifest_file && source_mode != EROFS_MKFS_SOURCE_LOCALDIR)
+		return -EINVAL;
+
 	/* TODO: can be implemented with (deviceslot) mapped_blkaddr */
 	if (mkfscfg.blobdev_path &&
 	    cfg.c_force_chunkformat == FORCE_INODE_BLOCK_MAP) {
@@ -1557,7 +1574,7 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			erofs_err("--blobdev is currently incompatible with rebuild mode");
 			return -EINVAL;
 		}
-	} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
+	} else if (manifest_file) {
 		erofs_err("missing argument: DATADIR");
 		return -EINVAL;
 	} else if (source_mode != EROFS_MKFS_SOURCE_TAR) {
@@ -1584,6 +1601,13 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		return -EINVAL;
 	}
 
+	/*
+	 * TODO: prepare COW target chunk indexes for full-data and
+	 * reserved-space imports.
+	 */
+	mkfs_manifest_rebuild = manifest_file &&
+		source_mode == EROFS_MKFS_SOURCE_REBUILD && !incremental_mode;
+
 	if (quiet) {
 		cfg.c_dbg_lvl = EROFS_ERR;
 		cfg.c_showprogress = false;
@@ -1599,7 +1623,8 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		params->pclusterblks_max = pclustersize_max >> mkfs_blkszbits;
 		params->pclusterblks_def = params->pclusterblks_max;
 	}
-	if (mkfscfg.chunkbits && mkfscfg.chunkbits < mkfs_blkszbits) {
+	if (source_mode != EROFS_MKFS_SOURCE_REBUILD && mkfscfg.chunkbits &&
+	    mkfscfg.chunkbits < mkfs_blkszbits) {
 		erofs_err("chunksize %u must be larger than block size",
 			  1u << mkfscfg.chunkbits);
 		return -EINVAL;
@@ -1903,6 +1928,11 @@ int main(int argc, char **argv)
 			goto exit;
 		}
 		mkfs_blkszbits = src->blkszbits;
+		if (mkfscfg.chunkbits && mkfscfg.chunkbits < src->blkszbits) {
+			erofs_err("chunksize must be at least the source block size");
+			err = -EINVAL;
+			goto exit;
+		}
 	} else if (mkfs_oci_tarindex_mode) {
 		mkfs_blkszbits = 9;
 		tar_index_512b = true;
@@ -1952,6 +1982,8 @@ int main(int argc, char **argv)
 		mkfscfg.chunkbits = g_sbi.blkszbits;
 	}
 	importer_params.chunkszbits_def = mkfscfg.chunkbits;
+	if (mkfs_manifest_rebuild && !mkfscfg.chunkbits)
+		importer_params.chunkszbits_def = g_sbi.blkszbits;
 	err = erofs_importer_init(&importer);
 	if (err)
 		goto exit;
@@ -1989,13 +2021,13 @@ int main(int argc, char **argv)
 		importer_params.ddev_id_def = mkfscfg.blobdev_path ? 1 : 0;
 	}
 
-	if (tar_index_512b || mkfscfg.chunkbits) {
-		err = erofs_blob_init(&g_sbi, mkfscfg.chunkbits);
+	if (tar_index_512b || importer_params.chunkszbits_def) {
+		err = erofs_blob_init(&g_sbi, importer_params.chunkszbits_def);
 		if (err)
 			goto exit;
 	}
 
-	if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR) {
+	if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR && !manifest_file) {
 		erofs_os_stat_t st;
 
 		err = erofs_load_shared_xattrs_from_path(&g_sbi, cfg.c_src_path,
@@ -2027,14 +2059,6 @@ int main(int argc, char **argv)
 		err = erofs_fill_inode(&importer, root, &st, cfg.c_src_path);
 		if (err)
 			goto exit;
-	} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST)  {
-		err = erofs_xattr_flush_name_prefixes(&importer,
-						      mkfs_plain_xattr_pfx);
-		if (err) {
-			erofs_err("failed to flush long xattr prefixes: %s",
-				  erofs_strerror(err));
-			goto exit;
-		}
 	} else {
 		err = erofs_xattr_flush_name_prefixes(&importer,
 						      mkfs_plain_xattr_pfx);
@@ -2052,29 +2076,7 @@ int main(int argc, char **argv)
 	}
 
 	importer.root = root;
-	if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
-		FILE *fp = fopen(manifest_file, "r");
-
-		if (!fp) {
-			err = -errno;
-			erofs_err("cannot open manifest %s: %s",
-				  manifest_file, erofs_strerror(err));
-			goto exit;
-		}
-		err = erofs_manifest_load(&importer, fp);
-		fclose(fp);
-		if (err)
-			goto exit;
-		root = importer.root;
-
-		if (!incremental_mode) {
-			err = erofs_build_shared_xattrs(&g_sbi, mkfscfg.inlinexattr_tolerance);
-			if (err) {
-				erofs_err("failed to build shared xattrs: %s", erofs_strerror(err));
-				goto exit;
-			}
-		}
-	} else if (source_mode == EROFS_MKFS_SOURCE_TAR) {
+	if (source_mode == EROFS_MKFS_SOURCE_TAR) {
 		while (!(err = tarerofs_parse_tar(&importer, &erofstar)))
 			;
 	} else if (source_mode == EROFS_MKFS_SOURCE_REBUILD) {
@@ -2121,7 +2123,30 @@ int main(int argc, char **argv)
 	if (err < 0)
 		goto exit;
 
-	err = erofs_importer_load_tree(&importer,
+	if (manifest_file) {
+		FILE *fp = fopen(manifest_file, "r");
+
+		if (!fp) {
+			err = -errno;
+			erofs_err("cannot open manifest %s: %s", manifest_file,
+				  erofs_strerror(err));
+			goto exit;
+		}
+		err = erofs_manifest_load(&importer, fp);
+		fclose(fp);
+		if (err)
+			goto exit;
+		root = importer.root;
+		if (!incremental_mode) {
+			err = erofs_build_shared_xattrs(&g_sbi, mkfscfg.inlinexattr_tolerance);
+			if (err) {
+				erofs_err("failed to build shared xattrs: %s", erofs_strerror(err));
+				goto exit;
+			}
+		}
+	}
+
+	err = erofs_importer_load_tree(&importer, manifest_file ||
 				       source_mode != EROFS_MKFS_SOURCE_LOCALDIR,
 				       incremental_mode);
 	if (err)
-- 
2.54.0 (Apple Git-157)


