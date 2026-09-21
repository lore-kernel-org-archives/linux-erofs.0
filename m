Return-Path: <linux-erofs+bounces-4591-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4333EC982EE
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 13:35:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hpPPh13Jwz2yKp;
	Mon, 21 Sep 2026 23:35:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::11"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789997752;
	cv=none; b=SI4tsZu1j/NsZqfhKTnVsOypA433sfOfO6P0X75Mav4EiF9fiY2nGNRm3US0pCmgH3OVOd+K4p21E4l0xJZFk0Z056bCrFKddMlcouc0HUcERoIyuvi5eEyWTn+vh/wK/kpFxeov6KYwmRuDCBLBd7q5QP5va3+0U/6z2eC8CUuwDdleJSV7KDxOuvH9ecwWhyqKmsLFrKQFkdTSg9sxK6qWDpLMJreHy+Z2H5DqoBCeRZ60/k+RT5dc0edpKe94ZdwOe5dcsbZQH0SPAlvcQ/ZyAR+gXxWZ85zwaBnLBE7AD9/p/HeiKsBfkS2oBI8slJ26IQvN73BQjliX5zVmpA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789997752; c=relaxed/relaxed;
	bh=5EUAm29g5hC0Eh9CD5Ex3WRfRE0RGUr34VwXfCik4Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jK7xTFP5pZXCF0R3hvTx4SRNmfRmzWiOZzjBthEkMWIYlpFgBLWFdiSGzH2WZ3gkzU761RTkC2C9xjgRSyrxviSpDcEBnpr4idG7vuJpemhzw/ZzHeVDRTKDK0taJS4d7S2doDZ+A864jM1a/KtEjJZnXOJWLHxXouwPDB21PVYnpO6LLMeP3nV+tb455sKys8S+JTz6gqI05C4a3kELSeTORGM+Z2bywlNrW4AYErseLlsG5EcVFEGUiaxRaUFg+GcQ0OCtOttXzxfaPjk0YMSWKTTEgjsd7p/HOdSDl/94tw5P0U1L/oE44DJaBM+ty9WgY0AmsZ5QQjxDIJ7Z3Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FKGC/nei; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FKGC/nei;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x11.google.com (mail-pj2-x11.google.com [IPv6:2607:f8b0:4864:39::11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hpPPc6nZdz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 23:35:48 +1000 (AEST)
Received: by mail-pj2-x11.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so2582220a91.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 06:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997746; x=1790602546; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5EUAm29g5hC0Eh9CD5Ex3WRfRE0RGUr34VwXfCik4Vg=;
        b=FKGC/nei5Y/HBX3rDSSTv0np6X2Evqi3SLMWZLFxCLiNxgTOct8iHflVQHW7bNF+3z
         BTFMdH6xb9ksOaHWavVroHSM/ow++w4hpdxgnPcIzT8mb6HtpKEbPruOf+hOxkaghq8o
         VEDQaopsKVPEZETZFdbxCXIWBjGB26I045FaZwbdpjMteGM6RMD91xIdHHBRFzXB03nK
         GOUXMVgnOHJ6ZTFmzEieNvh0ACLbQb9lKgwQ1kszlmdayawMABtGEmYnRxAUW7A0gDBe
         hdpHSy4aNzMaORWkPbjdEq5pF0mxL57vnheALaTN6f51Am/FrgZvjFc2nJ+UOBBuRd4O
         w3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997746; x=1790602546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5EUAm29g5hC0Eh9CD5Ex3WRfRE0RGUr34VwXfCik4Vg=;
        b=gVc674NWyZUQTesxzau2cx75NjDKrJOqayKnG+5Q3lrx3HZ80x48k0EDSM4VgYuPlN
         UIvhi95iqd3rS/XT2nU+Fm6dxU5vKrkqids1iW8uqdoXnkFLos/5xja8bWkSYg17XeGP
         NfU35vCgzp9zIW7lqH5HoBu8AtYOIzvNzBCl/+Y2kbis3r9s/+kOTG9ABmC458LVTfYo
         VF4IrcNvzd1xtBTuVQD+ILx4mTdOPrNNrYQTo8E/WPV0E8hDK3/Rlq3HACUb4awONYDq
         AMwo7w34d2/TbIaWhzxtX0uJjdrwOPRonrGkkwfHF6PzSOSAvx/cZF6lo5wOueovxJuc
         CBTA==
X-Gm-Message-State: AFuF++nCAnaDsg0JNlRuS4yBP6AyUriZmvXmFPkyXVoUV+5uoLJ/RQXR
	5Fw+iKP29qfm+nIloEzUk+EmB5JU8aq/F/SEp1kxsTKI7c5DBsv4I55OYh2uY5Bw
X-Gm-Gg: AYBFou38dBfZ9zjs4ZEDCZQJGkZ/yeamLsYl764sXwz519dAo7ev0UKmRcB4Xc/OS8d
	BtjkTSjqwtuXExY4lkIP0MfUDFUCsZ40kvXvg4UaTEFHZPjhyEMJr84PMCab5HREHFFx+G4mG5T
	MixEMpOT+60aAcGml5F0rt1nDx9p4suLvzDDZjk5qvdAVxR5WDKjBKm5PMpivr+wGe5qE9U9l09
	QCf3+AfJ9sZUqT/ItY3EAQHfxzrczzDZ8d1SGUK4LM6Of2VfCQ2hvwI+ffYao6v2ojUr1l9/av2
	yL23NwQ781VG+CGUw89jVv5+E7VWK4Dx9AwoHJMBCxRH47sBczc1Jz3hJSPoI4t/094nUvN7M5S
	nmTTmHrAlI/OVzw3kWHmSsXC9+EyMvI7/aoIm026lZXJS3aV+1Rgt+17V7aqiCuC943fcsOX6Za
	TJ3pRqmZHZyjobR/5BcCIvFYb5d8oc2eRsb7Fovbsdn9RcdsGKWLDxNNAryE1h1/juPAoaVC7+b
	npjVc7CZAktZ3n5o+cP4SM1yO/aaDK0BkewDiogL5I52sfShw==
X-Received: by 2002:a17:90b:5623:b0:39e:53a:c8d4 with SMTP id 98e67ed59e1d1-39e54d160b7mr18686772a91.12.1789997746086;
        Mon, 21 Sep 2026 06:35:46 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06369372csm179385a91.1.2026.09.21.06.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:35:45 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH v2 3/4] erofs-utils: mkfs: add file-delta framework
Date: Mon, 21 Sep 2026 21:35:34 +0800
Message-ID: <20260921133535.2381246-3-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921133535.2381246-1-stopire@gmail.com>
References: <20260921133535.2381246-1-stopire@gmail.com>
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

Add --file-delta to rebuild a parent image with logical file updates.
Represent updates as DATA or ZERO extents, separating input parsing from
file layout handling.  Keep delta state in the rebuild context.

Implement Chunk updates with independent parent, update and output
granularities.  Split inherited large chunks without copying their data
and retain historical device references.  Store changed nonzero data in
the output primary device and zero updates as holes.

Match targets by parent inode, including hard links.  Reject unsupported
48-bit layouts and output block ranges.

For example, using the dm-persistent backend from the next patch:

  mkfs.erofs -Eforce-chunk-indexes --chunksize=4096 \
    parent.erofs rootdir/
  mkfs.erofs -Eforce-chunk-indexes --chunksize=4096 \
    --file-delta=dm-persistent:/disk.img:changes.cow \
    updated.erofs parent.erofs

Here rootdir/disk.img is the base file and changes.cow is a sealed
COW store with 4 KiB chunks.  The output inherits unchanged data from
parent.erofs.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 include/erofs/io.h        |   1 +
 lib/Makefile.am           |   4 +-
 lib/blobchunk.c           |   5 +-
 lib/file_delta.c          | 324 ++++++++++++++++++++++++++++++++++++++
 lib/io.c                  |   2 +-
 lib/liberofs_chunk.h      |   2 +
 lib/liberofs_file_delta.h |  51 ++++++
 lib/liberofs_rebuild.h    |   9 +-
 lib/rebuild.c             | 183 ++++++++++++++++++---
 man/mkfs.erofs.1          |  19 +++
 mkfs/main.c               | 126 +++++++++++++--
 11 files changed, 692 insertions(+), 34 deletions(-)
 create mode 100644 lib/file_delta.c
 create mode 100644 lib/liberofs_file_delta.h

diff --git a/include/erofs/io.h b/include/erofs/io.h
index 96309fd..52713dc 100644
--- a/include/erofs/io.h
+++ b/include/erofs/io.h
@@ -70,6 +70,7 @@ struct erofs_vfile {
 
 ssize_t __erofs_io_write(int fd, const void *buf, size_t len);
 int __erofs_0write(int fd, size_t len);
+int erofs_get_bdev_size(int fd, u64 *bytes);
 
 int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf);
 ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf, u64 pos, size_t len);
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 0a82915..7f86409 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -24,6 +24,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/lib/liberofs_cache.h \
       $(top_srcdir)/lib/liberofs_chunk.h \
       $(top_srcdir)/lib/liberofs_compress.h \
+      $(top_srcdir)/lib/liberofs_file_delta.h \
       $(top_srcdir)/lib/liberofs_fragments.h \
       $(top_srcdir)/lib/liberofs_private.h \
       $(top_srcdir)/lib/liberofs_rebuild.h \
@@ -44,7 +45,8 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      compress_hints.c sha256.c blobchunk.c dir.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
 		      block_list.c rebuild.c diskbuf.c bitops.c dedupe_ext.c \
-		      vmdk.c metabox.c global.c importer.c base64.c
+		      vmdk.c metabox.c global.c importer.c base64.c \
+		      file_delta.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 2f42541..fae12f3 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -80,9 +80,8 @@ static unsigned int memhash(const void *buf, size_t len)
 	return hash;
 }
 
-static struct erofs_chunkitem *erofs_get_chunk(struct erofs_sb_info *sbi,
-					       int device_id,
-					       u8 *buf, u64 size)
+struct erofs_chunkitem *erofs_get_chunk(struct erofs_sb_info *sbi,
+				      int device_id, u8 *buf, u64 size)
 {
 	struct erofs_bufmgr *bmgr = device_id ? sbi->devs[device_id - 1].bmgr : sbi->bmgr;
 	struct erofs_chunkmgr *chunkmgr = sbi->chunkmgr;
diff --git a/lib/file_delta.c b/lib/file_delta.c
new file mode 100644
index 0000000..62e3800
--- /dev/null
+++ b/lib/file_delta.c
@@ -0,0 +1,324 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#define _GNU_SOURCE
+#include <config.h>
+#include <limits.h>
+#include "erofs/print.h"
+#include "liberofs_chunk.h"
+#include "liberofs_file_delta.h"
+
+int erofs_delta_add(struct list_head *extents, bool zero,
+		    erofs_off_t offset, erofs_off_t length,
+		    struct erofs_vfile *vf, erofs_off_t source_offset)
+{
+	struct erofs_delta_extent *e = malloc(sizeof(*e));
+
+	if (!e)
+		return -ENOMEM;
+	*e = (struct erofs_delta_extent) {
+		.zero = zero,
+		.offset = offset,
+		.length = length,
+		.vf = vf,
+		.source_offset = source_offset,
+	};
+	list_add_tail(&e->list, extents);
+	return 0;
+}
+
+void erofs_delta_cleanup(struct list_head *extents)
+{
+	struct erofs_delta_extent *e, *n;
+
+	list_for_each_entry_safe(e, n, extents, list) {
+		list_del(&e->list);
+		free(e);
+	}
+}
+
+int erofs_delta_validate(const struct list_head *extents, erofs_off_t size)
+{
+	const struct erofs_delta_extent *e;
+	erofs_off_t end = 0;
+
+	list_for_each_entry(e, extents, list) {
+		if (!e->length || e->offset < end || e->offset >= size ||
+		    e->length > size - e->offset)
+			return -EINVAL;
+		if (!e->zero) {
+			if (!e->vf || e->source_offset > UINT64_MAX - e->length)
+				return -EINVAL;
+		} else if (e->vf || e->source_offset) {
+			return -EINVAL;
+		}
+		end = e->offset + e->length;
+	}
+	return 0;
+}
+
+int erofs_delta_read(const struct erofs_delta_extent *e,
+		     erofs_off_t within, void *buf, size_t len)
+{
+	erofs_off_t pos, limit;
+
+	if (e->zero || !e->vf ||
+	    within > e->length || len > e->length - within)
+		return -EINVAL;
+	if (check_add_overflow(e->source_offset, within, &pos) ||
+	    len > UINT64_MAX - pos)
+		return -EOVERFLOW;
+	if (len > SSIZE_MAX)
+		return -EOVERFLOW;
+	if (e->vf->ops) {
+		if (!e->vf->ops->pread)
+			return -EOPNOTSUPP;
+	} else {
+#ifdef HAVE_PREAD64
+		limit = INT64_MAX;
+#else
+		limit = (1ULL << (sizeof(off_t) * CHAR_BIT - 1)) - 1;
+#endif
+		if (check_add_overflow(pos, e->vf->offset, &pos) ||
+		    pos > limit || len > limit - pos)
+			return -EOVERFLOW;
+		pos -= e->vf->offset;
+	}
+	return erofs_pread(e->vf, buf, len, pos);
+}
+
+int erofs_delta_spec_parse(struct list_head *specs, const char *arg,
+		const struct erofs_delta_spec_ops * const *backends)
+{
+	const struct erofs_delta_spec_ops *ops;
+	struct erofs_delta_spec *spec;
+	const char *first = strchr(arg, ':'), *second;
+	size_t namelen;
+
+	if (!first || first == arg)
+		return -EINVAL;
+	second = strchr(first + 1, ':');
+	if (!second || second == first + 1 || !second[1])
+		return -EINVAL;
+	namelen = first - arg;
+	while ((ops = *backends++))
+		if (strlen(ops->name) == namelen && !memcmp(ops->name, arg, namelen))
+			break;
+	if (!ops)
+		return -EOPNOTSUPP;
+	spec = calloc(1, sizeof(*spec));
+	if (!spec)
+		return -ENOMEM;
+	spec->ops = ops;
+	spec->target_path = strndup(first + 1, second - first - 1);
+	spec->spec_path = strdup(second + 1);
+	if (!spec->target_path || !spec->spec_path) {
+		free(spec->target_path);
+		free(spec->spec_path);
+		free(spec);
+		return -ENOMEM;
+	}
+	list_add_tail(&spec->list, specs);
+	return 0;
+}
+
+void erofs_delta_spec_cleanup(struct list_head *specs)
+{
+	struct erofs_delta_spec *spec, *n;
+
+	list_for_each_entry_safe(spec, n, specs, list) {
+		list_del(&spec->list);
+		free(spec->target_path);
+		free(spec->spec_path);
+		free(spec);
+	}
+}
+
+int erofs_delta_spec_open(struct erofs_vfile *vf, const char *path,
+			 erofs_off_t *size)
+{
+	struct stat st;
+	int fd, ret, flags = O_RDONLY | O_BINARY | O_NONBLOCK;
+
+#ifdef O_CLOEXEC
+	flags |= O_CLOEXEC;
+#endif
+	fd = open(path, flags);
+	if (fd < 0)
+		return -errno;
+	if (fstat(fd, &st)) {
+		ret = -errno;
+		goto out;
+	}
+	if (S_ISREG(st.st_mode)) {
+		if (st.st_size < 0) {
+			ret = -EOVERFLOW;
+			goto out;
+		}
+		*size = st.st_size;
+	} else if (S_ISBLK(st.st_mode)) {
+		ret = erofs_get_bdev_size(fd, size);
+		if (ret)
+			goto out;
+	} else {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0 || fcntl(fd, F_SETFL, flags & ~O_NONBLOCK)) {
+		ret = -errno;
+		goto out;
+	}
+	*vf = (struct erofs_vfile) { .fd = fd };
+	return 0;
+out:
+	close(fd);
+	return ret;
+}
+
+/* Bound the buffer for a single newly written chunk, even after extent merging. */
+#define EROFS_DELTA_CHUNK_MAX_BITS	26
+
+int erofs_chunk_apply_deltas(struct erofs_inode *parent,
+		struct erofs_inode *inode, const struct list_head *extents)
+{
+	struct erofs_sb_info *sbi = inode->sbi, *src = parent->sbi;
+	const struct erofs_delta_extent *e;
+	struct erofs_chunkitem **indexes, *chunk;
+	erofs_off_t chunksize, pos, boundary, len;
+	unsigned int chunkbits = parent->u.chunkbits;
+	u64 count, i;
+	size_t buflen;
+	u8 *buf = NULL;
+	int ret;
+
+	if (!(parent->u.chunkformat & EROFS_CHUNK_FORMAT_INDEXES) ||
+	    (parent->u.chunkformat & EROFS_CHUNK_FORMAT_48BIT))
+		return -EOPNOTSUPP;
+	list_for_each_entry(e, extents, list) {
+		/*
+		 * Combine the start and end offsets in boundary so the chosen
+		 * chunk size aligns with both.  EOF may end in a partial chunk.
+		 */
+		boundary = e->offset;
+		if (e->offset + e->length != parent->i_size)
+			boundary |= e->offset + e->length;
+		while (chunkbits && (boundary & ((1ULL << chunkbits) - 1)))
+			--chunkbits;
+		if (!e->zero)
+			chunkbits = min_t(unsigned int, chunkbits,
+					  EROFS_DELTA_CHUNK_MAX_BITS);
+	}
+	if (chunkbits < sbi->blkszbits)
+		return -EOPNOTSUPP;
+	chunksize = 1ULL << chunkbits;
+	count = DIV_ROUND_UP(parent->i_size, chunksize);
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
+		struct erofs_map_blocks map = { .buf = __EROFS_BUF_INITIALIZER };
+		erofs_off_t within;
+
+		pos = i << chunkbits;
+		map.m_la = pos;
+		ret = erofs_map_blocks(parent, &map, 0);
+		if (ret)
+			goto out;
+		len = min_t(erofs_off_t, chunksize, parent->i_size - pos);
+		if (pos < map.m_la) {
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		within = pos - map.m_la;
+		if (within >= map.m_llen || len > map.m_llen - within) {
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+			chunk = erofs_get_unhashed_chunk(sbi, 0, EROFS_NULL_ADDR, 0);
+		} else {
+			struct erofs_map_dev mdev = {
+				.m_deviceid = map.m_deviceid,
+				.m_pa = map.m_pa,
+			};
+			struct erofs_device_info *dif;
+			erofs_blk_t startblk, nblocks;
+
+			if (erofs_blkoff(src, map.m_pa)) {
+				ret = -EFSCORRUPTED;
+				goto out;
+			}
+			ret = erofs_map_dev(src, &mdev);
+			if (ret)
+				goto out;
+			dif = mdev.m_deviceid ? &src->devs[mdev.m_deviceid - 1] : &src->dif0;
+			startblk = erofs_blknr(src, mdev.m_pa);
+			nblocks = BLK_ROUND_UP(src, map.m_plen);
+			if (startblk >= dif->blocks || nblocks > dif->blocks - startblk) {
+				erofs_err("parent chunk range exceeds device %u", mdev.m_deviceid);
+				ret = -EFSCORRUPTED;
+				goto out;
+			}
+			/* Parent primary becomes device 1; its external devices follow it. */
+			chunk = erofs_get_unhashed_chunk(sbi, mdev.m_deviceid + 1,
+						       startblk + erofs_blknr(src, within), 0);
+		}
+		if (IS_ERR(chunk)) {
+			ret = PTR_ERR(chunk);
+			goto out;
+		}
+		indexes[i] = chunk;
+	}
+	list_for_each_entry(e, extents, list) {
+		if (!e->zero && !buf) {
+			buflen = min_t(erofs_off_t, chunksize, parent->i_size);
+			buf = malloc(buflen);
+			if (!buf) {
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+		for (pos = 0; pos < e->length; pos += len) {
+			bool zero = e->zero;
+
+			len = min_t(erofs_off_t, chunksize, e->length - pos);
+			if (!zero) {
+				const u8 *p = buf, *end = buf + len;
+
+				ret = erofs_delta_read(e, pos, buf, len);
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
+			indexes[(e->offset + pos) >> chunkbits] = chunk;
+		}
+	}
+	inode->chunkindexes = indexes;
+	inode->extent_isize = count * sizeof(struct erofs_inode_chunk_index);
+	inode->datalayout = EROFS_INODE_CHUNK_BASED;
+	inode->u.chunkbits = chunkbits;
+	inode->u.chunkformat = EROFS_CHUNK_FORMAT_INDEXES |
+		(chunkbits - sbi->blkszbits);
+	indexes = NULL;
+	ret = 0;
+out:
+	free(buf);
+	free(indexes);
+	return ret;
+}
diff --git a/lib/io.c b/lib/io.c
index f62129f..115dabb 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -250,7 +250,7 @@ ssize_t erofs_io_pread(struct erofs_vfile *vf, void *buf, size_t len, u64 pos)
 	return read;
 }
 
-static int erofs_get_bdev_size(int fd, u64 *bytes)
+int erofs_get_bdev_size(int fd, u64 *bytes)
 {
 	errno = ENOTSUP;
 #ifdef BLKGETSIZE64
diff --git a/lib/liberofs_chunk.h b/lib/liberofs_chunk.h
index 64e7ec8..78f909e 100644
--- a/lib/liberofs_chunk.h
+++ b/lib/liberofs_chunk.h
@@ -17,6 +17,8 @@ extern "C"
 struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
 		unsigned int device_id, erofs_blk_t blkaddr,
 		erofs_off_t sourceoffset);
+struct erofs_chunkitem *erofs_get_chunk(struct erofs_sb_info *sbi,
+				      int device_id, u8 *buf, u64 size);
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode);
 ssize_t erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 				 erofs_off_t off);
diff --git a/lib/liberofs_file_delta.h b/lib/liberofs_file_delta.h
new file mode 100644
index 0000000..13c8a98
--- /dev/null
+++ b/lib/liberofs_file_delta.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_LIB_LIBEROFS_FILE_DELTA_H
+#define __EROFS_LIB_LIBEROFS_FILE_DELTA_H
+
+#include "erofs/internal.h"
+
+/* A logical replacement; gaps between extents inherit the parent contents. */
+struct erofs_delta_extent {
+	struct list_head list;
+	erofs_off_t offset, length;
+	bool zero;
+	/* Borrowed raw container, never a guest-addressed view. NULL for ZERO. */
+	struct erofs_vfile *vf;
+	erofs_off_t source_offset;
+};
+
+int erofs_delta_add(struct list_head *extents, bool zero,
+		    erofs_off_t offset, erofs_off_t length,
+		    struct erofs_vfile *vf, erofs_off_t source_offset);
+void erofs_delta_cleanup(struct list_head *extents);
+/* Validate sorted, non-overlapping ranges. Source bounds are parser-specific. */
+int erofs_delta_validate(const struct list_head *extents, erofs_off_t size);
+int erofs_delta_read(const struct erofs_delta_extent *extent,
+		     erofs_off_t within, void *buf, size_t len);
+
+struct erofs_delta_spec_ops {
+	const char *name;
+	int (*parse)(struct erofs_vfile *vf, erofs_off_t source_size,
+		     erofs_off_t target_size, erofs_off_t expected_unit,
+		     struct list_head *extents);
+};
+
+/* Immutable for the duration of rebuild. */
+struct erofs_delta_spec {
+	struct list_head list;
+	const struct erofs_delta_spec_ops *ops;
+	char *target_path;
+	char *spec_path;
+};
+
+int erofs_delta_spec_parse(struct list_head *specs, const char *arg,
+		const struct erofs_delta_spec_ops * const *backends);
+/* Only for heap-allocated specifications returned by erofs_delta_spec_parse(). */
+void erofs_delta_spec_cleanup(struct list_head *specs);
+int erofs_delta_spec_open(struct erofs_vfile *vf, const char *path,
+			 erofs_off_t *size);
+
+int erofs_chunk_apply_deltas(struct erofs_inode *parent,
+		struct erofs_inode *inode, const struct list_head *extents);
+
+#endif
diff --git a/lib/liberofs_rebuild.h b/lib/liberofs_rebuild.h
index 6459dbd..88117e0 100644
--- a/lib/liberofs_rebuild.h
+++ b/lib/liberofs_rebuild.h
@@ -10,11 +10,18 @@ enum erofs_rebuild_datamode {
 	EROFS_REBUILD_DATA_FULL,
 };
 
+struct erofs_rebuild_options {
+	enum erofs_rebuild_datamode datamode;
+	/* Optional list of erofs_delta_spec, borrowed until return. */
+	const struct list_head *delta_specs;
+	erofs_off_t expected_delta_unit;
+};
+
 struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 		char *path, bool aufs, bool *whout, bool *opq, bool to_head);
 
 int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
-			    enum erofs_rebuild_datamode mode);
+			    const struct erofs_rebuild_options *opts);
 
 int erofs_rebuild_load_basedir(struct erofs_inode *dir, u64 *nr_subdirs,
 			       unsigned int *i_nlink);
diff --git a/lib/rebuild.c b/lib/rebuild.c
index c378885..630487d 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -15,6 +15,7 @@
 #include "erofs/internal.h"
 #include "erofs/io.h"
 #include "liberofs_chunk.h"
+#include "liberofs_file_delta.h"
 #include "liberofs_rebuild.h"
 #include "liberofs_uuid.h"
 
@@ -26,6 +27,134 @@
 #define AUFS_WH_DIROPQ		AUFS_WH_PFX AUFS_DIROPQ_NAME
 #endif
 
+struct erofs_rebuild_delta {
+	struct list_head list, extents;
+	const struct erofs_delta_spec *spec;
+	erofs_nid_t parent_nid;
+	struct erofs_vfile input;
+};
+
+struct erofs_rebuild_ctx {
+	struct erofs_sb_info *sbi;
+	const struct erofs_rebuild_options *opts;
+	struct list_head deltas;
+};
+
+static void erofs_rebuild_cleanup_deltas(struct erofs_rebuild_ctx *ctx)
+{
+	struct erofs_rebuild_delta *delta, *n;
+
+	list_for_each_entry_safe(delta, n, &ctx->deltas, list) {
+		list_del(&delta->list);
+		erofs_delta_cleanup(&delta->extents);
+		if (delta->input.fd >= 0)
+			erofs_io_close(&delta->input);
+		free(delta);
+	}
+}
+
+static int erofs_rebuild_prepare_deltas(struct erofs_rebuild_ctx *ctx,
+				      struct erofs_sb_info *parent)
+{
+	const struct list_head *specs = ctx->opts->delta_specs;
+	const struct erofs_delta_spec *spec;
+	struct erofs_rebuild_delta *delta, *other;
+	struct erofs_delta_extent *e;
+	int ret;
+
+	if (!specs || specs->next == specs)
+		return 0;
+	if (ctx->opts->datamode != EROFS_REBUILD_DATA_BLOB_INDEX ||
+	    erofs_sb_has_48bit(parent) || erofs_sb_has_48bit(ctx->sbi) ||
+	    erofs_sb_has_ishare_xattrs(parent) || erofs_sb_has_ishare_xattrs(ctx->sbi))
+		return -EOPNOTSUPP;
+	if (ctx->sbi->blkszbits != parent->blkszbits ||
+	    ctx->sbi->extra_devices != parent->extra_devices + 1 || !ctx->sbi->devs)
+		return -EINVAL;
+	list_for_each_entry(spec, specs, list) {
+		struct erofs_inode inode = { .sbi = parent };
+		erofs_off_t source_size;
+
+		if (!spec->target_path || !*spec->target_path || !spec->ops ||
+		    !spec->ops->parse || !spec->spec_path)
+			return -EINVAL;
+		delta = calloc(1, sizeof(*delta));
+		if (!delta)
+			return -ENOMEM;
+		delta->spec = spec;
+		delta->input.fd = -1;
+		init_list_head(&delta->extents);
+		list_add_tail(&delta->list, &ctx->deltas);
+		ret = erofs_ilookup(spec->target_path, &inode);
+		if (ret) {
+			erofs_err("file-delta TARGET %s cannot be read: %s",
+				  spec->target_path, erofs_strerror(ret));
+			return ret;
+		}
+		if (!S_ISREG(inode.i_mode) || !inode.i_size)
+			return -EINVAL;
+		delta->parent_nid = inode.nid;
+		list_for_each_entry(other, &ctx->deltas, list) {
+			if (other == delta)
+				break;
+			if (other->parent_nid == delta->parent_nid) {
+				erofs_err("file-delta TARGET %s refers to the same inode as %s",
+					  spec->target_path, other->spec->target_path);
+				return -EEXIST;
+			}
+		}
+		ret = erofs_delta_spec_open(&delta->input, spec->spec_path,
+					   &source_size);
+		if (ret)
+			goto err;
+		ret = spec->ops->parse(&delta->input, source_size, inode.i_size,
+				       ctx->opts->expected_delta_unit, &delta->extents);
+		if (!ret)
+			ret = erofs_delta_validate(&delta->extents, inode.i_size);
+		if (ret)
+			goto err;
+		list_for_each_entry(e, &delta->extents, list) {
+			if (e->zero)
+				continue;
+			if (e->vf != &delta->input || e->source_offset > source_size ||
+			    e->length > source_size - e->source_offset) {
+				ret = -EINVAL;
+				goto err;
+			}
+		}
+	}
+	return 0;
+err:
+	erofs_err("file-delta %s source %s for %s: %s", spec->ops->name,
+		  spec->spec_path, spec->target_path, erofs_strerror(ret));
+	return ret;
+}
+
+static int erofs_rebuild_apply_deltas(struct erofs_rebuild_ctx *ctx,
+				    struct erofs_inode *inode)
+{
+	struct erofs_inode parent = *inode;
+	struct erofs_rebuild_delta *delta, *target = NULL;
+	LIST_HEAD(empty);
+
+	list_for_each_entry(delta, &ctx->deltas, list) {
+		if (delta->parent_nid == parent.nid) {
+			target = delta;
+			break;
+		}
+	}
+	inode->sbi = ctx->sbi;
+	switch (parent.datalayout) {
+	case EROFS_INODE_CHUNK_BASED:
+		return erofs_chunk_apply_deltas(&parent, inode,
+					       target ? &target->extents : &empty);
+	default:
+		erofs_err("%s: unsupported file-delta datalayout %u",
+			  inode->i_srcpath, parent.datalayout);
+		return -EOPNOTSUPP;
+	}
+}
+
 /*
  * These non-existent parent directories are created with the same permissions
  * as their parent directories.  It is expected that a call to create these
@@ -198,7 +327,7 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 			.buf = __EROFS_BUF_INITIALIZER,
 		};
 
-		map.m_la = i << chunkbits;
+		map.m_la = (erofs_off_t)i << chunkbits;
 		ret = erofs_map_blocks(inode, &map, 0);
 		if (ret)
 			goto err;
@@ -298,10 +427,11 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 	return err;
 }
 
-static int erofs_rebuild_update_inode(struct erofs_sb_info *dst_sb,
-				      struct erofs_inode *inode,
-				      enum erofs_rebuild_datamode datamode)
+static int erofs_rebuild_update_inode(struct erofs_rebuild_ctx *ctx,
+				      struct erofs_inode *inode)
 {
+	struct erofs_sb_info *dst_sb = ctx->sbi;
+	enum erofs_rebuild_datamode datamode = ctx->opts->datamode;
 	int err = 0;
 
 	switch (inode->i_mode & S_IFMT) {
@@ -339,9 +469,12 @@ static int erofs_rebuild_update_inode(struct erofs_sb_info *dst_sb,
 			inode->u.i_blkaddr = EROFS_NULL_ADDR;
 			break;
 		}
-		if (datamode == EROFS_REBUILD_DATA_BLOB_INDEX)
-			err = erofs_rebuild_write_blob_index(dst_sb, inode);
-		else if (datamode == EROFS_REBUILD_DATA_RESVSP)
+		if (datamode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+			if (!list_empty(&ctx->deltas))
+				err = erofs_rebuild_apply_deltas(ctx, inode);
+			else
+				err = erofs_rebuild_write_blob_index(dst_sb, inode);
+		} else if (datamode == EROFS_REBUILD_DATA_RESVSP)
 			inode->datasource = EROFS_INODE_DATA_SOURCE_RESVSP;
 		else if (datamode == EROFS_REBUILD_DATA_FULL)
 			err = erofs_rebuild_write_full_data(inode);
@@ -359,8 +492,7 @@ struct erofs_rebuild_dir_context {
 	struct erofs_dir_context ctx;
 	struct erofs_inode *mergedir;	/* parent directory in the merged tree */
 	union {
-		/* indicate how to import inode data */
-		enum erofs_rebuild_datamode datamode;
+		struct erofs_rebuild_ctx *rebuild;
 		struct {
 			u64 *nr_subdirs;
 			unsigned int *i_nlink;
@@ -473,8 +605,7 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 			inode->i_ino[1] = inode->nid;
 			inode->i_nlink = 1;
 
-			ret = erofs_rebuild_update_inode(&g_sbi, inode,
-							 rctx->datamode);
+			ret = erofs_rebuild_update_inode(rctx->rebuild, inode);
 			if (ret) {
 				erofs_iput(inode);
 				goto out;
@@ -499,7 +630,7 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 	}
 
 	/* reset sbi, nid after subdirs are all loaded for the final dump */
-	inode->sbi = &g_sbi;
+	inode->sbi = rctx->rebuild->sbi;
 	inode->nid = EROFS_NID_UNALLOCATED;
 out:
 	free(path);
@@ -507,9 +638,14 @@ out:
 }
 
 int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
-			    enum erofs_rebuild_datamode mode)
+			    const struct erofs_rebuild_options *opts)
 {
 	struct erofs_sb_info *dst_sbi = root->sbi;
+	struct erofs_rebuild_ctx rebuild = {
+		.sbi = dst_sbi,
+		.opts = opts,
+		.deltas = LIST_HEAD_INIT(rebuild.deltas),
+	};
 	struct erofs_inode inode = {};
 	struct erofs_rebuild_dir_context ctx;
 	char uuid_str[37];
@@ -527,7 +663,11 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		return ret;
 	}
 
-	if (mode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+	/* Reject unsupported parents before propagating their features. */
+	ret = erofs_rebuild_prepare_deltas(&rebuild, sbi);
+	if (ret)
+		goto out;
+	if (opts->datamode == EROFS_REBUILD_DATA_BLOB_INDEX) {
 		if (erofs_sb_has_ztailpacking(sbi))
 			erofs_sb_set_ztailpacking(dst_sbi);
 		if (erofs_sb_has_dedupe(sbi))
@@ -536,7 +676,8 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		    !erofs_sb_has_big_pcluster(dst_sbi)) {
 			erofs_err("failed to load tree from image %d with big pclusters",
 				  sbi->dev);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto out;
 		}
 		if (erofs_sb_has_48bit(sbi))
 			erofs_sb_set_48bit(dst_sbi);
@@ -547,20 +688,24 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
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
 		.ctx.cb = erofs_rebuild_dirent_iter,
 		.mergedir = root,
-		.datamode = mode,
+		.rebuild = &rebuild,
 	};
 	ret = erofs_iterate_dir(&ctx.ctx, false);
+out:
 	free(inode.i_srcpath);
+	erofs_rebuild_cleanup_deltas(&rebuild);
 	return ret;
 }
 
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 65ec807..b599232 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -339,6 +339,25 @@ Note that \fBrvsp\fR takes precedence over \fB--tar=i\fR or \fB--tar=headerball\
 Only \fBrvsp\fR is supported.
 .RE
 .TP
+.BI "\-\-file-delta=" FORMAT:TARGET:SOURCE
+Apply a \fIFORMAT\fR delta \fISOURCE\fR to \fITARGET\fR while rebuilding
+a single parent image.  Requires \fB\-\-chunksize\fR,
+\fB\-Eforce-chunk-indexes\fR and the default rebuild data mode.
+
+\fITARGET\fR is relative to the parent image root and must name a non-empty
+regular file.  All non-empty regular files in the parent must use explicit
+chunk indexes.  File sizes are preserved.  This option may be repeated for
+distinct target inodes; hard links are updated together.  TARGET cannot contain
+a colon.
+
+Cannot be combined with \fB\-\-incremental\fR, \fB\-\-blobdev\fR or
+\fB\-\-xattr-inode-digest\fR.  48-bit features and inode-digest xattrs are
+unsupported.
+
+Changed data is stored in the output image.  The output requires the parent as
+external device 1, followed by the parent's existing external devices in order.
+\fISOURCE\fR is needed only during the build.
+.TP
 .BI "\-\-max-extent-bytes=" #
 Specify maximum decompressed extent size in bytes. The default is unlimited.
 .TP
diff --git a/mkfs/main.c b/mkfs/main.c
index f0d3d8c..199762a 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -26,6 +26,7 @@
 #include "erofs/compress_hints.h"
 #include "../lib/compressor.h"
 #include "../lib/liberofs_chunk.h"
+#include "../lib/liberofs_file_delta.h"
 #include "../lib/liberofs_gzran.h"
 #include "../lib/liberofs_metabox.h"
 #include "../lib/liberofs_oci.h"
@@ -105,6 +106,7 @@ static struct option long_options[] = {
 	{"MZ", optional_argument, NULL, 537},
 	{"xattr-prefix", required_argument, NULL, 538},
 	{"xattr-inode-digest", optional_argument, NULL, 539},
+	{"file-delta", required_argument, NULL, 540},
 	{0, 0, 0, 0},
 };
 
@@ -201,6 +203,7 @@ static void usage(int argc, char **argv)
 		" --dsunit=#             align all data block addresses to multiples of #\n"
 		" --exclude-path=X       avoid including file X (X = exact literal path)\n"
 		" --exclude-regex=X      avoid including files that match X (X = regular expression)\n"
+		" --file-delta=X         rebuild TARGET with X=FORMAT:TARGET:SOURCE into the output image\n"
 #ifdef HAVE_LIBSELINUX
 		" --file-contexts=X      specify a file contexts file to setup selinux labels\n"
 #endif
@@ -328,6 +331,10 @@ static enum {
 
 static unsigned int rebuild_src_count;
 static LIST_HEAD(rebuild_src_list);
+static LIST_HEAD(file_delta_specs);
+static const struct erofs_delta_spec_ops * const file_delta_backends[] = {
+	NULL,
+};
 static u8 fixeduuid[16];
 static bool valid_fixeduuid;
 static unsigned int dsunit;
@@ -1497,6 +1504,15 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return err;
 			}
 			break;
+		case 540:
+			err = erofs_delta_spec_parse(&file_delta_specs, optarg,
+						  file_delta_backends);
+			if (err) {
+				erofs_err("invalid --file-delta=%s: %s", optarg,
+					  erofs_strerror(err));
+				return err;
+			}
+			break;
 		case 'V':
 			version();
 			exit(0);
@@ -1552,6 +1568,26 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			return err;
 	}
 
+	if (!list_empty(&file_delta_specs)) {
+		if (erofs_sb_has_48bit(&g_sbi) || mkfs_dot_omitted) {
+			erofs_err("--file-delta does not support 48-bit features");
+			return -EOPNOTSUPP;
+		}
+		if (incremental_mode ||
+		    source_mode != EROFS_MKFS_SOURCE_REBUILD ||
+		    rebuild_src_count != 1 || !mkfscfg.chunkbits ||
+		    cfg.c_force_chunkformat != FORCE_INODE_CHUNK_INDEXES ||
+			dataimport_mode != EROFS_MKFS_DATA_IMPORT_DEFAULT) {
+			erofs_err("--file-delta requires one rebuild parent, --chunksize, "
+				  "-Eforce-chunk-indexes and the default rebuild data mode");
+			return -EINVAL;
+		}
+		if (erofs_sb_has_ishare_xattrs(&g_sbi)) {
+			erofs_err("--xattr-inode-digest is unsupported with --file-delta");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	if (quiet) {
 		cfg.c_dbg_lvl = EROFS_ERR;
 		cfg.c_showprogress = false;
@@ -1567,7 +1603,8 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		params->pclusterblks_max = pclustersize_max >> mkfs_blkszbits;
 		params->pclusterblks_def = params->pclusterblks_max;
 	}
-	if (mkfscfg.chunkbits && mkfscfg.chunkbits < mkfs_blkszbits) {
+	if (list_empty(&file_delta_specs) && mkfscfg.chunkbits &&
+	    mkfscfg.chunkbits < mkfs_blkszbits) {
 		erofs_err("chunksize %u must be larger than block size",
 			  1u << mkfscfg.chunkbits);
 		return -EINVAL;
@@ -1660,6 +1697,60 @@ void erofs_show_progs(int argc, char *argv[])
 		printf("%s %s\n", basename(argv[0]), cfg.c_version);
 }
 
+static int erofs_mkfs_rebuild_check_delta_parent(struct erofs_sb_info *src)
+{
+	if (erofs_sb_has_ishare_xattrs(src)) {
+		erofs_err("file-delta parent uses inode digest xattrs");
+		return -EOPNOTSUPP;
+	}
+	if (mkfscfg.chunkbits < src->blkszbits) {
+		erofs_err("chunksize %u must be at least parent block size %u",
+			  1U << mkfscfg.chunkbits, 1U << src->blkszbits);
+		return -EINVAL;
+	}
+	if (erofs_sb_has_48bit(src)) {
+		erofs_err("file-delta does not support 48-bit parents");
+		return -EOPNOTSUPP;
+	}
+	if (src->extra_devices >= ARRAY_SIZE(src->blobfd)) {
+		erofs_err("file-delta supports at most %zu external devices",
+			  ARRAY_SIZE(src->blobfd));
+		return -E2BIG;
+	}
+	return 0;
+}
+
+static int erofs_mkfs_rebuild_load_delta(struct erofs_inode *root)
+{
+	const struct erofs_rebuild_options opts = {
+		.datamode = EROFS_REBUILD_DATA_BLOB_INDEX,
+		.delta_specs = &file_delta_specs,
+		.expected_delta_unit = 1ULL << mkfscfg.chunkbits,
+	};
+	struct erofs_sb_info *src;
+	unsigned int output_devices;
+	int ret, idx;
+
+	DBG_BUGON(dataimport_mode != EROFS_MKFS_DATA_IMPORT_DEFAULT ||
+		  rebuild_src_count != 1);
+	src = list_first_entry(&rebuild_src_list, struct erofs_sb_info, list);
+	output_devices = src->extra_devices + 1;
+	ret = erofs_mkfs_init_devices(&g_sbi, output_devices);
+	if (ret)
+		return ret;
+	g_sbi.devs[0].blocks = src->dif0.blocks;
+	erofs_uuid_unparse_as_tag(src->uuid, (char *)g_sbi.devs[0].tag);
+	for (idx = 0; idx < src->extra_devices; ++idx) {
+		g_sbi.devs[idx + 1].blocks = src->devs[idx].blocks;
+		memcpy(g_sbi.devs[idx + 1].tag, src->devs[idx].tag,
+		       sizeof(g_sbi.devs[idx + 1].tag));
+	}
+	src->xamgr = g_sbi.xamgr;
+	ret = erofs_rebuild_load_tree(root, src, &opts);
+	src->xamgr = NULL;
+	return ret;
+}
+
 static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 {
 	struct erofs_device_info *devs;
@@ -1667,25 +1758,28 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 	unsigned int extra_devices = 0;
 	erofs_blk_t nblocks;
 	int ret, idx;
-	enum erofs_rebuild_datamode datamode;
+	struct erofs_rebuild_options opts = {};
 
 	switch (dataimport_mode) {
 	case EROFS_MKFS_DATA_IMPORT_DEFAULT:
-		datamode = EROFS_REBUILD_DATA_BLOB_INDEX;
+		opts.datamode = EROFS_REBUILD_DATA_BLOB_INDEX;
 		break;
 	case EROFS_MKFS_DATA_IMPORT_FULLDATA:
-		datamode = EROFS_REBUILD_DATA_FULL;
+		opts.datamode = EROFS_REBUILD_DATA_FULL;
 		break;
 	case EROFS_MKFS_DATA_IMPORT_RVSP:
-		datamode = EROFS_REBUILD_DATA_RESVSP;
+		opts.datamode = EROFS_REBUILD_DATA_RESVSP;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (!list_empty(&file_delta_specs))
+		return erofs_mkfs_rebuild_load_delta(root);
+
 	list_for_each_entry(src, &rebuild_src_list, list) {
 		src->xamgr = g_sbi.xamgr;
-		ret = erofs_rebuild_load_tree(root, src, datamode);
+		ret = erofs_rebuild_load_tree(root, src, &opts);
 		src->xamgr = NULL;
 		if (ret) {
 			erofs_err("failed to load %s", src->dif0.src_path);
@@ -1699,7 +1793,7 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		extra_devices += src->extra_devices;
 	}
 
-	if (datamode == EROFS_REBUILD_DATA_RESVSP)
+	if (opts.datamode == EROFS_REBUILD_DATA_RESVSP)
 		return 0;
 
 	/* Each blob has either no extra device or only one device for TarFS */
@@ -1709,7 +1803,7 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		return -EOPNOTSUPP;
 	}
 
-	if (datamode == EROFS_REBUILD_DATA_FULL)
+	if (opts.datamode == EROFS_REBUILD_DATA_FULL)
 		return 0;
 
 	ret = erofs_mkfs_init_devices(&g_sbi, rebuild_src_count);
@@ -1856,6 +1950,11 @@ int main(int argc, char **argv)
 			goto exit;
 		}
 		mkfs_blkszbits = src->blkszbits;
+		if (!list_empty(&file_delta_specs)) {
+			err = erofs_mkfs_rebuild_check_delta_parent(src);
+			if (err)
+				goto exit;
+		}
 	} else if (mkfs_oci_tarindex_mode) {
 		mkfs_blkszbits = 9;
 		tar_index_512b = true;
@@ -1942,7 +2041,8 @@ int main(int argc, char **argv)
 		importer_params.ddev_id_def = mkfscfg.blobdev_path ? 1 : 0;
 	}
 
-	if (tar_index_512b || mkfscfg.chunkbits) {
+	if ((tar_index_512b || mkfscfg.chunkbits) &&
+	    list_empty(&file_delta_specs)) {
 		err = erofs_blob_init(&g_sbi, mkfscfg.chunkbits);
 		if (err)
 			goto exit;
@@ -2059,6 +2159,13 @@ int main(int argc, char **argv)
 	erofs_iput(root);
 	root = NULL;
 
+	if (!list_empty(&file_delta_specs) &&
+	    (erofs_sb_has_48bit(&g_sbi) || g_sbi.dif0.blocks > UINT32_MAX)) {
+		erofs_err("file-delta output requires 48-bit support");
+		err = -EFBIG;
+		goto exit;
+	}
+
 	err = erofs_writesb(&g_sbi);
 	if (err)
 		goto exit;
@@ -2077,6 +2184,7 @@ int main(int argc, char **argv)
 exit:
 	if (root)
 		erofs_iput(root);
+	erofs_delta_spec_cleanup(&file_delta_specs);
 	z_erofs_dedupe_exit();
 	blklst = erofs_blocklist_close();
 	if (blklst)
-- 
2.55.0


