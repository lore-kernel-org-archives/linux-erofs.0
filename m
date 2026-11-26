Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E851E606A321
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=x3hN1UxE
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCf3W4zz2yRM;
	Thu, 26 Nov 2026 23:02:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694558;
	cv=none; b=eVC+sYCNFgBWhIzHpiFr4CHm4SRVh7UQd/Q0DfNIppK/zB35FrljyZpiaw7sjMgmZSiAqX+m+Vx8jVrV4Ia/o33GLkUrJwtn252sK4qwRRzp1De11vjOyNb2lmzn9n+GYSvzM9nHF9N3hovzcQFCvoKqRHfYGkZxUvnIs4TyJoUcmXhX697i5AGvTcHLJa06oy4CwcOO6crPO+7mSD8nOAbM+o1bc+NsoFUM2xdj2w5zB8EKRtYmwvbAhcvwfN/RxvjyzNDJ9yARhGosTZDot9dQyzjeN51qLu4QiHhlhFf2rG9jn270KFoLbMK5Q+YU3wpKFVSx1erZs/8w7Ccazw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694558; c=relaxed/relaxed;
	bh=1CAE8hE3SQTI/TU/fSI+kfkW4OF+uTZX5RAkPzs+Rvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLzocJGD+sfn5jb+qj0GvLfMg1K7hNSiPLA/MLDlB/PYsk8o07Fu6rKMdKBG8UdK9xDjcQaGQSzeRHr/5ZG6Yall61OEVzQVRw3EgDn6rd1/hM4qpd7vCriceBCnS5BaAxLQpjUr7RC5z65cfDDc5GTKMlNrWHBZeS/AXRVZt761RY/CuvYKbJITt3fMCkk+SPpTU0ThKiKRWeRjOdTYu9uVyiWWboWjGWWu+kyY9rO3brgIQoYQaM1Oo/Fz0iPRIaIt8YICVVKbqb4MDglNjatM6e3oOISDBD9TLparHmyODJAz5HbpzqWH5Rnl91Tb8s3CyOF8U39LqEvxk7k7qQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=x3hN1UxE; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=x3hN1UxE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCc3tdjz2yLY
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:36 +1100 (AEDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so65063685e9.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694553; x=1796299353; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1CAE8hE3SQTI/TU/fSI+kfkW4OF+uTZX5RAkPzs+Rvo=;
        b=x3hN1UxEIaDcOC+rd8mfxgCh73vokFoFACosyT4MARwvdTN7WiQGQSqeJoHAXcwApL
         tR+mTn5U2L6qpswTo3BjawE9kQ9w+237a3njYWnOXRMaUSz38wk3iyMpkVgm4aGodBh1
         nYI1fBK5lAUX+WAOa/dI41BNkNLXVWoGB72iehdNeil6qW5eMs0llVjmBEU0Do3L17d0
         cqHSqV7l5eTYzVesJyDnykeuYmgXHHc+je2AOebLwGk2rVMdbl0/bv+aGgGifgICOiDc
         zJdZAEWn9bDMBV7+1qJDBQ7lX42H0Xaypz4wkQQm4G1HFuSgkaA51j0aMNq5rUw/Zj+t
         A6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694553; x=1796299353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1CAE8hE3SQTI/TU/fSI+kfkW4OF+uTZX5RAkPzs+Rvo=;
        b=pQowKm6Bg+nsVhHv40sYjFiaJJxe6ZYweWbKpvqd/YaJ7EoSNjguh+AnNAwiL07hxh
         P2DPEbxM60ZY1Ofsk/w5+WymzGCHZmEGA+FvAoB9fLfTaGN6iRDDCS6BZkMKAeZdiRsj
         xgKZTOCMHbZS9o1n+FpHsru7yYYLA/c5VWpTMg/8JuPoD6+OigWJDlw5yeB61xMRjL8M
         J633iAq3OMhjCYxiPKfQNC7IJxzSV2n12pjpIeqnrp1PnWp4XiB3ZGbQq/P+Q96XkhEG
         FY/4K15W40cjsg9XpwGVrp3mpSagF/9sQTpRO8m1Xf3qB4Cmem3olKVfxM119MdwW1ix
         os5Q==
X-Gm-Message-State: APuU4Z8KNGVfzbH1vGjpO40Pe1GgszTcKquJfFifWDALHtseqyFqmS81
	MyOFAqUld5Ke7LJvofO9ONyyRP2khY9ofpqgDDIna/kvq7gtBXt9EKm3Hvd9p2/JIiBp+XKnKbz
	C+1/v/Dw=
X-Gm-Gg: AZFdTZcs2dhjcDEq3pAIPZJC2wteK/r/eQQ2qX3srzMrRQ2ncO67KndFoQvrO3I1fTc
	tJIROocfxEMJPtz9pR78knnLihAivWqHa/VhR+u12B2U46x2BFOvHWz9WrIxaV2Oy2kGKFwp0JF
	TXVZfdL4Up2vYEjy1balWn0Tce6luFvlieKtiHK95cjRBnwKsNYCfZQvNZGDLd8mUxNxnvDA7Rf
	jvhxLpVFRAmEYJHSCgDXkPQVj8ezxhcXbMA19MBLIJrYFxKAwVlKD2Ne4U5qGkVu4Wdc5fMawuf
	CY519a2m9mGuPyIm8U6uaTfihhJuDJLbLBPCFhIU4w/6IsigJ1kbwZ0izRstSkyqLcD7TR3ynC4
	gWu4Q5yKXxoAev4XzOfWf4bZKQarfOE48HGhkH9rMnsHOFnmy+rNdcaeQbRBXOCFjWvTiK9h7mU
	JpQom9iAS9ALcxQTNsgaOzsRaof1DM9/afxXNHKP5M4TJN0yvx7isgP3B4GHaLqYFBzuGq2ueRQ
	qehPCgp9mqj6lp2DII/tnSwhuNwX9hhSKO7hz048BlpqaPmWqcZEdTZlZdxjevR63lIAJPUHv5U
	2kYidAprZVgNSMWXNuxu0eZYeQ3WXblO8JFxfOEX1QhOdvNwmfNDqfb2tVDNTIR/vmIN
X-Received: by 2002:a05:600c:4f42:b0:4bb:5c5c:8130 with SMTP id 5b1f17b1804b1-4bb8881c726mr536250135e9.5.1795694553325;
        Thu, 26 Nov 2026 04:02:33 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:32 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 07/10] erofs-utils: lib: add persistent dm-snapshot parser
Date: Thu, 26 Nov 2026 13:02:18 +0100
Message-ID: <20261126120221.4384-7-xiang.gao@docker.com>
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

Add file-delta support for version 1 dm-snapshot-persistent stores.
Validate the header and exception records, sort exceptions by logical
offset and derive the covered range from them.

The parser borrows the COW vfile from its caller.  Rebuild integration
will follow.

Assisted-by: Codex:gpt-6-astra
Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/Makefile.am            |   4 +-
 lib/deltas/dm_persistent.c | 239 +++++++++++++++++++++++++++++++++++++
 lib/liberofs_file_delta.h  |  32 +++++
 3 files changed, 274 insertions(+), 1 deletion(-)
 create mode 100644 lib/deltas/dm_persistent.c
 create mode 100644 lib/liberofs_file_delta.h

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 8654479..e84030d 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -28,6 +28,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/lib/liberofs_cache.h \
       $(top_srcdir)/lib/liberofs_chunk.h \
       $(top_srcdir)/lib/liberofs_compress.h \
+      $(top_srcdir)/lib/liberofs_file_delta.h \
       $(top_srcdir)/lib/liberofs_fragments.h \
       $(top_srcdir)/lib/liberofs_private.h \
       $(top_srcdir)/lib/liberofs_rebuild.h \
@@ -48,7 +49,8 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      compress_hints.c sha256.c blobchunk.c dir.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
 		      block_list.c rebuild.c diskbuf.c bitops.c dedupe_ext.c \
-		      vmdk.c metabox.c global.c importer.c base64.c manifest.c
+		      vmdk.c metabox.c global.c importer.c base64.c manifest.c \
+		      deltas/dm_persistent.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
diff --git a/lib/deltas/dm_persistent.c b/lib/deltas/dm_persistent.c
new file mode 100644
index 0000000..9e4c5c7
--- /dev/null
+++ b/lib/deltas/dm_persistent.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#include <config.h>
+#include <limits.h>
+#include "erofs/print.h"
+#include "liberofs_file_delta.h"
+
+#define EROFS_DM_SNAP_MAGIC	0x70416e53U
+#define EROFS_DM_DISK_VERSION	1U
+#define EROFS_DM_SECTOR_SIZE	512U
+
+struct erofs_dm_disk_header {
+	__le32 magic;
+	__le32 valid;
+	__le32 version;
+	__le32 chunk_size;
+} __packed;
+
+struct erofs_dm_disk_exception {
+	__le64 old_chunk;
+	__le64 new_chunk;
+} __packed;
+
+struct erofs_dm_exception {
+	erofs_off_t offset, source_offset;
+};
+
+/* Sorted by logical file offset after opening the snapshot. */
+struct erofs_dm_exceptions {
+	struct erofs_dm_exception *entries;
+	size_t count, capacity;
+};
+
+struct erofs_dm_snap_persistent {
+	struct erofs_file_delta fdl;
+	struct erofs_dm_exceptions exceptions;
+	struct erofs_vfile *vf;
+	erofs_off_t target_size, chunk_bytes;
+};
+
+static const struct erofs_file_delta_ops erofs_file_delta_dm_persistent_ops;
+
+static int erofs_dm_exception_cmp(const void *a, const void *b)
+{
+	const struct erofs_dm_exception *ea = a, *eb = b;
+
+	return cmpsgn(ea->offset, eb->offset);
+}
+
+static int erofs_dm_add_exception(struct erofs_dm_exceptions *exceptions,
+				 erofs_off_t offset,
+				 erofs_off_t source_offset)
+{
+	struct erofs_dm_exception *p;
+	size_t capacity;
+
+	if (exceptions->count == exceptions->capacity) {
+		capacity = exceptions->capacity ? exceptions->capacity * 2 : 64;
+		if (capacity < exceptions->capacity)
+			return -E2BIG;
+		if (capacity > SIZE_MAX / sizeof(*p))
+			return -E2BIG;
+		p = realloc(exceptions->entries, capacity * sizeof(*p));
+		if (!p)
+			return -ENOMEM;
+		exceptions->entries = p;
+		exceptions->capacity = capacity;
+	}
+	exceptions->entries[exceptions->count++] = (struct erofs_dm_exception) {
+		.offset = offset,
+		.source_offset = source_offset,
+	};
+	return 0;
+}
+
+static int erofs_dm_parse_exceptions(struct erofs_dm_snap_persistent *dsp)
+{
+	struct erofs_dm_exceptions *exceptions = &dsp->exceptions;
+	erofs_off_t chunk_bytes = dsp->chunk_bytes;
+	/* Read metadata in bounded batches, independently of the dm chunk size. */
+	struct erofs_dm_disk_exception buf[256];
+	u64 per_area = chunk_bytes / sizeof(buf[0]), stride = per_area + 1;
+	erofs_off_t metadata_chunk = 1, metadata_offset, offset, source_offset;
+	u64 i, j, nr;
+	size_t n;
+	int ret;
+
+	for (;;) {
+		/* Chunk 0 is the header; metadata areas start at 1 + n * stride. */
+		if (metadata_chunk > UINT64_MAX / chunk_bytes) {
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		metadata_offset = metadata_chunk * chunk_bytes;
+		for (i = 0; i < per_area; i += nr) {
+			nr = min_t(u64, per_area - i, ARRAY_SIZE(buf));
+			ret = erofs_pread(dsp->vf, buf, nr * sizeof(buf[0]),
+					  metadata_offset + i * sizeof(buf[0]));
+			if (ret)
+				goto out;
+			for (j = 0; j < nr; ++j) {
+				u64 old_chunk, new_chunk;
+
+				old_chunk = le64_to_cpu(buf[j].old_chunk);
+				new_chunk = le64_to_cpu(buf[j].new_chunk);
+
+				/* The first zero new_chunk terminates the exception table. */
+				if (!new_chunk)
+					goto terminated;
+				if (new_chunk % stride == 1) {
+					ret = -EFSCORRUPTED;
+					goto out;
+				}
+				if (old_chunk >= UINT64_MAX / chunk_bytes) {
+					ret = -EFSCORRUPTED;
+					goto out;
+				}
+				offset = old_chunk * chunk_bytes;
+				dsp->target_size = max(dsp->target_size, offset + chunk_bytes);
+				if (new_chunk > UINT64_MAX / chunk_bytes) {
+					ret = -EFSCORRUPTED;
+					goto out;
+				}
+				source_offset = new_chunk * chunk_bytes;
+				ret = erofs_dm_add_exception(exceptions,
+							     offset, source_offset);
+				if (ret)
+					goto out;
+			}
+		}
+		if (check_add_overflow(metadata_chunk, stride, &metadata_chunk)) {
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+	}
+terminated:
+	/* Exceptions are stored in commit order, not logical file order. */
+	if (exceptions->count > 1)
+		qsort(exceptions->entries, exceptions->count,
+		      sizeof(*exceptions->entries), erofs_dm_exception_cmp);
+	/*
+	 * The kernel reuses existing exceptions on repeated writes, but its
+	 * loader does not reject duplicate origin chunks.  Reject them here
+	 * rather than choosing an ambiguous mapping.
+	 */
+	for (n = 1; n < exceptions->count; ++n) {
+		if (exceptions->entries[n - 1].offset == exceptions->entries[n].offset)
+			return -EINVAL;
+	}
+	ret = 0;
+out:
+	return ret;
+}
+
+static int erofs_dm_persistent_map(struct erofs_file_delta *fdl,
+				   struct erofs_delta_map *map)
+{
+	struct erofs_dm_snap_persistent *dsp =
+		container_of(fdl, struct erofs_dm_snap_persistent, fdl);
+	const struct erofs_dm_exception *e;
+	erofs_off_t offset = map->offset, end;
+	size_t lo = 0, hi = dsp->exceptions.count;
+
+	map->length = 0;
+	map->vf = NULL;
+	map->sourceoffset = 0;
+	if (offset >= dsp->target_size)
+		return 0;
+
+	/* Find the first replacement whose end is past the requested offset. */
+	while (lo < hi) {
+		size_t mid = lo + (hi - lo) / 2;
+
+		e = &dsp->exceptions.entries[mid];
+		if (offset >= e->offset && offset - e->offset >= dsp->chunk_bytes)
+			lo = mid + 1;
+		else
+			hi = mid;
+	}
+	if (lo == dsp->exceptions.count)
+		return 0;
+	e = &dsp->exceptions.entries[lo];
+	end = e->offset + dsp->chunk_bytes;
+	map->offset = max(offset, e->offset);
+	map->length = end - map->offset;
+	map->vf = dsp->vf;
+	map->sourceoffset = e->source_offset + map->offset - e->offset;
+	return 0;
+}
+
+static void erofs_dm_persistent_close(struct erofs_file_delta *fdl)
+{
+	struct erofs_dm_snap_persistent *dsp =
+		container_of(fdl, struct erofs_dm_snap_persistent, fdl);
+
+	free(dsp->exceptions.entries);
+	free(dsp);
+}
+
+struct erofs_file_delta *erofs_dm_persistent_open(struct erofs_vfile *vf)
+{
+	struct erofs_dm_disk_header header;
+	struct erofs_dm_snap_persistent *dsp;
+	erofs_off_t chunk_bytes;
+	u32 sectors;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(header) != 16);
+	BUILD_BUG_ON(sizeof(struct erofs_dm_disk_exception) != 16);
+	ret = erofs_pread(vf, &header, sizeof(header), 0);
+	if (ret)
+		return ERR_PTR(ret);
+	if (le32_to_cpu(header.magic) != EROFS_DM_SNAP_MAGIC ||
+	    le32_to_cpu(header.version) != EROFS_DM_DISK_VERSION)
+		return ERR_PTR(-EFSCORRUPTED);
+	if (le32_to_cpu(header.valid) != 1)
+		return ERR_PTR(-EINVAL);
+	sectors = le32_to_cpu(header.chunk_size);
+	if (!sectors || (sectors & (sectors - 1)) || sectors > (INT_MAX >> 9))
+		return ERR_PTR(-EFSCORRUPTED);
+	chunk_bytes = (erofs_off_t)sectors * EROFS_DM_SECTOR_SIZE;
+	dsp = calloc(1, sizeof(*dsp));
+	if (!dsp)
+		return ERR_PTR(-ENOMEM);
+	dsp->fdl.ops = &erofs_file_delta_dm_persistent_ops;
+	dsp->vf = vf;
+	dsp->chunk_bytes = chunk_bytes;
+	ret = erofs_dm_parse_exceptions(dsp);
+	if (ret) {
+		erofs_dm_persistent_close(&dsp->fdl);
+		return ERR_PTR(ret);
+	}
+	return &dsp->fdl;
+}
+
+static const struct erofs_file_delta_ops erofs_file_delta_dm_persistent_ops = {
+	.map = erofs_dm_persistent_map,
+	.close = erofs_dm_persistent_close,
+	.name = "dm-persistent",
+};
diff --git a/lib/liberofs_file_delta.h b/lib/liberofs_file_delta.h
new file mode 100644
index 0000000..17fb0d5
--- /dev/null
+++ b/lib/liberofs_file_delta.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_LIB_LIBEROFS_FILE_DELTA_H
+#define __EROFS_LIB_LIBEROFS_FILE_DELTA_H
+
+#include "erofs/internal.h"
+
+/* A logical replacement; gaps between extents inherit the parent contents. */
+struct erofs_delta_map {
+	erofs_off_t offset, length;
+	/* Borrowed raw container, never a guest-addressed view. NULL for ZERO. */
+	struct erofs_vfile *vf;
+	erofs_off_t sourceoffset;
+};
+
+struct erofs_file_delta;
+
+struct erofs_file_delta_ops {
+	/* Find a replacement at or after map->offset; length 0 means none. */
+	int (*map)(struct erofs_file_delta *fdl, struct erofs_delta_map *map);
+	void (*close)(struct erofs_file_delta *fdl);
+	const char *name;		/* delta format name */
+};
+
+struct erofs_file_delta {
+	const struct erofs_file_delta_ops *ops;
+	u8 private[];
+};
+
+/* The caller retains ownership of vf. Return ERR_PTR() on failure. */
+struct erofs_file_delta *erofs_dm_persistent_open(struct erofs_vfile *vf);
+
+#endif
-- 
2.54.0 (Apple Git-157)


