Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E431A606A326
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=mFhwP7ld
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCs2XCQz2yMl;
	Thu, 26 Nov 2026 23:02:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::335"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694569;
	cv=none; b=klBl364z19hlC/+wkGySctHLF7ie2oGXggg2bE+etFPpPs7kG7dlhytaJ8auMrcPPEoYr6se30vWsME1Nnph2STzWph7PM6qX0sIi/GT79RYXKAnf6mH+LPCrw+Y81bnMRy49xCli6TmSKMAgjbUe1ojhwavhpgohGn/55yFPLgWf1oaTHsp8uT8QU5/3Wp4My/jarL8Z2ZLmkQ2+Ra61XoEBNQPDNCQIa8t93eOxs3K9yF6ebkuEKyoRZN6RbWNdEmxboKZMoOtGx4file89lLSVKndPu5mp/w+Mo7SzD6A8p7wHPPRtsRPqrVOvF92dT+gSQXyiO29q/ffcNao5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694569; c=relaxed/relaxed;
	bh=Y1BfP1Fhdfle3zGcSZvfiYezJqRJeJa4gNaX31gTDg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERlEtBrsZ94flzoN7EVal9aQLUvCZwrIN8+cpyqpJjC824QOaDe9x9zK/H0w8wVcqEAwrUyeq146+q+wkvX1Q+6WvSGTsgGqkh9YOBKdkph+R3sNA0/vzwu+SPjlzH2IlTArQhziqAq6jQlA/jEX1koDBEG3eycenOjU5Zz9c+JrmBV64PdJWs75eX8BFo7Oh6nw3F6dLa2FKZrUbSvYz038KGSgtAGb90JBCpuBX+8Nx9FGTvkc4uswly7UP2CYMi6v+uOihGKjSyFDGyN3gKT2TxNJLbBc4VNyxrbGdyAiUr5MvLkcPW9v7/dohJpEHWurOsuD+QVrEmpj/BYzTQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=mFhwP7ld; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=mFhwP7ld;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::335; helo=mail-wm1-x335.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCq4c0nz2yMk
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:47 +1100 (AEDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso66102995e9.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694563; x=1796299363; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y1BfP1Fhdfle3zGcSZvfiYezJqRJeJa4gNaX31gTDg0=;
        b=mFhwP7ldv9/J+HjbwpD+KlmANCGarfVb/RaeNtU27upyubJQBCK7s33JEHoko+lPNr
         RE/SGQpl2NZZA8N4DBsIpKaaazTKlmTvSceROgujWE4/M45alkHuMzGc3WYV26LkiMPG
         oQOmJDEcnESAHgGhvi6dT0jSCtSwgVcaQXmJKK41QMABwRC4LMZ+QeLbqaziK+0pRq6s
         IGUHknv/57wfXiTip5NrQBvdsquoEfyx73tQis2E/mx3oifUGzuCQxkK6HMJQS62lYWl
         cM8X6gdu6ra4JYoMqQHK3zFQUQqndqJXMVKGnqpTJGKXCEmrmQfKjhA40LmM1cytF9QW
         ORQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694563; x=1796299363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y1BfP1Fhdfle3zGcSZvfiYezJqRJeJa4gNaX31gTDg0=;
        b=PwhVjeUXiAE0hu/7oBe9BO0fkB6OzYmgo+PKQtDKbGl72ihtLnKy4Q5na7wpCYChea
         VFh1pkFtiMybeAwKhW8YAksd6w1YAg47VaLsHRu4vHbIHLdZI49S/OvBXkXq3pDW2xDK
         GLQ92800ZL/3S+ElDRd41NohhYDwGAxbhUb57SCXJGm38KnPy/dzSF2Nybw4Z+VtzRnG
         7hPlijmK2mxUPpQluWMG5b3/2ZElWFP7yJMwut1xJxudJyjoYF42XKkj6SlGw6lqtNFY
         bOcvpnoAiOmInebC85gb85P4MAkWyZHMSAB/q6waUW8Ftff11bhBMwZyLz+nAADF4tnt
         i3uA==
X-Gm-Message-State: APuU4Z++jLaNqWzStG10m6SJaYDgSY+NMIqxstq43R0XxW90PL48YaQV
	HsDq8pQzO/+JtmKJvKNbZTm+awHALvVA3P9JFPDoCfSxItFMCf0O8wrJs29ypMmypDco2WvpCnk
	sOAl9XL0=
X-Gm-Gg: AZFdTZf7x0D7WMWaYwnv7tTB8yCNly5mtP+R+3n2x4Ei86gfZdV1yEZdSgEenekZ8R2
	s8S3R6NAqFZOKYH0ruHDjuj8WYmMeVht2NbNS9w+2e4+rn/xuBn6y0dmwJG1Cokyzoxo1f1OuYK
	gVbCMFparfYppwgkj82Z9GlzyE49IfLmXjBgVtmYPr3OrQ1O+c9OE6jawDecZNTk808EEd3dxRa
	i3gYKeF3YUL2iNj7iXMKyNHlDHKjSjJLTUc4AuUZuIIiUbKaJr7CDnEtbIOqnkkPbAhquDgIr9o
	SKGUZF4TGldC+sgs9zl8xsghSMe8ImFPZrHX0MPXsngucRNj8d4RcuQ36paaImPiRp1ZrKEUW8S
	DKFEuS32uYBGUqyk2O3jH1HoF6niON5O0khTNWEOJoKClFu4Vbo7Fe9M1u/WVDbqa0o3RiefK4+
	Z8ntU2daWUXPENbmvL7mr14z1Dj6ZmSn2oxS2shK+ZIfl/v8Yx4SQUqfnyriQ1i69Q270wvA3bU
	UFQQ7T5Ed/TQ5LgFSpVcuR2hZDplhd6g6EaXM1fBxIvk0npGkHEUta1bBoAQCCsfBqA8Z4S5fQy
	qcnAuYazkzC+o9s6/0uYMToQ5b5T7nK94i3GbHidfi7RsowDRAXR51kNLe+9k8HLpvQV
X-Received: by 2002:a05:600c:5308:b0:4bb:76d6:1f5d with SMTP id 5b1f17b1804b1-4bb887ca192mr428184725e9.2.1795694558452;
        Thu, 26 Nov 2026 04:02:38 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:37 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 10/10] erofs-utils: mkfs: support file deltas in manifests
Date: Thu, 26 Nov 2026 13:02:21 +0100
Message-ID: <20261126120221.4384-10-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261126120221.4384-1-xiang.gao@docker.com>
References: <20261126120221.4384-1-xiang.gao@docker.com>
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

  DIFF[DM_SNAP] /disk.img changes.cow

Then apply it to the merged source tree:

  mkfs.erofs --manifest=foo.m l2.erofs l0.erofs l1.erofs datadir/

Reuse unchanged chunk indexes and split inherited chunks as needed to
match replacement boundaries.  Write changed data to the primary device
and turn all-zero replacement chunks into holes.  Preserve file sizes
and hard links.  Apply records in manifest order, with later records
overriding overlapping changes to the same inode.

Updates currently require prepared chunk indexes.  Preparing targets
from local files, full-data or reserved-space imports, and refreshing
inode-digest xattrs remain TODOs.

Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/blobchunk.c      | 130 ++++++++++++++++++++++++++++++++++++++++++-
 lib/liberofs_chunk.h |   3 +
 lib/manifest.c       | 124 ++++++++++++++++++++++++++++++-----------
 lib/rebuild.c        |  12 ++--
 mkfs/main.c          | 118 ++++++++++++++++++++++++---------------
 5 files changed, 302 insertions(+), 85 deletions(-)

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
index 827c588..169fe93 100644
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
@@ -119,15 +122,50 @@ static int erofs_manifest_load_local(struct erofs_importer *im,
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
@@ -208,34 +246,49 @@ out_dentry:
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
@@ -253,18 +306,21 @@ static void erofs_manifest_drop_children(struct erofs_inode *dir)
 
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
+		/* Synthesized directories do not belong to the base image. */
+		root->dev = im->sbi->dev + 1;
+	}
 
 	while ((len = getline(&line, &capacity, fp)) >= 0) {
 		++lineno;
@@ -290,13 +346,15 @@ int erofs_manifest_load(struct erofs_importer *im, FILE *fp)
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
index 85f263b..e6f0d13 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -666,7 +666,8 @@ int erofs_rebuild_load_tree(struct erofs_rebuild_params *params)
 		    !erofs_sb_has_big_pcluster(dst_sbi)) {
 			erofs_err("failed to load tree from image %d with big pclusters",
 				  sbi->dev);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto out;
 		}
 		if (erofs_sb_has_48bit(sbi))
 			erofs_sb_set_48bit(dst_sbi);
@@ -677,11 +678,13 @@ int erofs_rebuild_load_tree(struct erofs_rebuild_params *params)
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
@@ -690,6 +693,7 @@ int erofs_rebuild_load_tree(struct erofs_rebuild_params *params)
 		.params = params,
 	};
 	ret = erofs_iterate_dir(&ctx.ctx, false);
+out:
 	free(inode.i_srcpath);
 	return ret;
 }
diff --git a/mkfs/main.c b/mkfs/main.c
index e9613cb..3799d1d 100644
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
@@ -214,7 +215,7 @@ static void usage(int argc, char **argv)
 		" --hard-dereference     dereference hardlinks, add links as separate inodes\n"
 		" --ignore-mtime         use build time instead of strict per-file modification time\n"
 		" --max-extent-bytes=#   set maximum decompressed extent size # in bytes\n"
-		" --manifest=X           build an image from a manifest file X and DATADIR\n"
+		" --manifest=X           build from manifest X and DATADIR, optionally with base images\n"
 		" --mount-point=X        X=prefix of target fs path (default: /)\n"
 		" --preserve-mtime       keep per-file modification time strictly\n"
 		" --offset=#             skip # bytes at the beginning of IMAGE.\n"
@@ -327,12 +328,12 @@ static enum {
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
@@ -973,10 +974,14 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
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
@@ -985,16 +990,15 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
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
@@ -1077,6 +1081,18 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
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
 
@@ -1512,7 +1528,6 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return -EOPNOTSUPP;
 			}
 			manifest_file = optarg;
-			source_mode = EROFS_MKFS_SOURCE_MANIFEST;
 			break;
 		case 'V':
 			version();
@@ -1526,6 +1541,9 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		}
 	}
 
+	if (manifest_file && source_mode != EROFS_MKFS_SOURCE_LOCALDIR)
+		return -EINVAL;
+
 	/* TODO: can be implemented with (deviceslot) mapped_blkaddr */
 	if (mkfscfg.blobdev_path &&
 	    cfg.c_force_chunkformat == FORCE_INODE_BLOCK_MAP) {
@@ -1551,7 +1569,7 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			erofs_err("--blobdev is currently incompatible with rebuild mode");
 			return -EINVAL;
 		}
-	} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
+	} else if (manifest_file) {
 		erofs_err("missing argument: DATADIR");
 		return -EINVAL;
 	} else if (source_mode != EROFS_MKFS_SOURCE_TAR) {
@@ -1572,6 +1590,13 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			return err;
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
@@ -1587,7 +1612,8 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		params->pclusterblks_max = pclustersize_max >> mkfs_blkszbits;
 		params->pclusterblks_def = params->pclusterblks_max;
 	}
-	if (mkfscfg.chunkbits && mkfscfg.chunkbits < mkfs_blkszbits) {
+	if (source_mode != EROFS_MKFS_SOURCE_REBUILD && mkfscfg.chunkbits &&
+	    mkfscfg.chunkbits < mkfs_blkszbits) {
 		erofs_err("chunksize %u must be larger than block size",
 			  1u << mkfscfg.chunkbits);
 		return -EINVAL;
@@ -1869,6 +1895,11 @@ int main(int argc, char **argv)
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
@@ -1918,6 +1949,8 @@ int main(int argc, char **argv)
 		mkfscfg.chunkbits = g_sbi.blkszbits;
 	}
 	importer_params.chunkszbits_def = mkfscfg.chunkbits;
+	if (mkfs_manifest_rebuild && !mkfscfg.chunkbits)
+		importer_params.chunkszbits_def = g_sbi.blkszbits;
 	err = erofs_importer_init(&importer);
 	if (err)
 		goto exit;
@@ -1955,13 +1988,13 @@ int main(int argc, char **argv)
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
@@ -1993,14 +2026,6 @@ int main(int argc, char **argv)
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
@@ -2018,29 +2043,7 @@ int main(int argc, char **argv)
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
@@ -2087,7 +2090,30 @@ int main(int argc, char **argv)
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


