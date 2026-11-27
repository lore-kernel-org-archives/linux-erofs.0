Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73904606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2026 04:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=x3fJh6CB
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbKYl1NrZz2yLF;
	Fri, 27 Nov 2026 15:04:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::334"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795752283;
	cv=none; b=QQl0brhGQ+69bggDROFc+5Dkrao/s8J0f21YIH7z7/hUVuN6B0VDOjEauMdMjnitVe4G3YUilr9c9ScHi3R6r5fd4OL4sNfU9T2rPowG9n8GELJ7Ped5OchNO3sTXo1StDIypqTU5GBCdAwVUw2sIzkDTZ8Wr7Ck7yMmvflINzuemGSLpuXpgGTHm0+WAcOiaEVPcJ4cb317Pyjq1qJ9NZY4gu6R6ggorVd2JH7wq9j4rRKLDkjzpAsaNDqfAGqPEuZn+HEw2Qok1DoXvtm8sIQioiizyIGKAZ6v89ol4lKZ3ZxLN7rDEI5iwzT1xxUaWN5MTzS8+NxOk1YCWUGF0w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795752283; c=relaxed/relaxed;
	bh=0AMkdLeevrKJmy4rVuyHmiPh01w/B4IRb8uS7VATihI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfJ2/rKBMZ/gKdhGzZZQfBObbjSDo44R1tk6aRoyWs/JRY5Z1Cvzt5eLY7gZNOegKWW0z4IR8NfauMyuhoU5AaYP+nncqJCzyJvCKS6z8n6SaeOfSLZ3l6TCnCY3sypvWKtVRewiFNAsHXz/CxlybUbII7gBaNrkvU/w+ki6LeZffg8T6PmymjDYOLXBAp+kArRU42iO378xS6rul6tJ43Qdo5nIA4oEUDzO9/ecNAPVYMANsw3SxRgRihyIDrKo8DccrocB3mXkPidz8eZHzFMkKgdjl298qdOqDrSWqTXhlRZx1Bwo1NWud4bmH+wgMKOnjcBa0PqrK3IJqTDs4g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=x3fJh6CB; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=x3fJh6CB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbKYh53s2z2xLg
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 15:04:40 +1100 (AEDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so47642655e9.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 20:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795752272; x=1796357072; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0AMkdLeevrKJmy4rVuyHmiPh01w/B4IRb8uS7VATihI=;
        b=x3fJh6CB0Mj1WMAqe2uiCxvuKPPt9z8/sa6DfjMo9bo73teryGFdqRE7EFZ4l3vKyW
         oSzD0u9DJeHLVCDITsZFEKFnL07RAwMXxGtrh1jEvloqYIJnI5NntWOYazJmvM0/vAhC
         mb5S1sGwvbDdgP/QwKMwIVKFxuPkcxUBY3/irDFceVPRgpb64+Qoc9iUiYaWSWHDfK5Z
         Un8xHVo4MWmHGb9qhmg/2Omunxt60F3OQtEK5Kjhcr5N+kBw3KwWOT/JyErCmuTPj6RP
         pDxHCl8uDJCha2xSYLFdVKUQtTc4v/sQTHeZ6J5A6jVhrvHdt85jVnh7Belm+5r6+g3c
         Qp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752272; x=1796357072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0AMkdLeevrKJmy4rVuyHmiPh01w/B4IRb8uS7VATihI=;
        b=RMoVp+yscPyN/z76FDgBlIgOS6g48obkcqbuibukbYJUs2pBi1d3nwY5sX1wLzTi5p
         dXzbIAdoo8IeW+otvBGfBcVYgUh73X4aRAosIjEiJxGvYa4fk3Kn2Arz2TNjjF27O4uD
         if8gJGW6J+OuNg4+q1ndu/yv28coh7vjCAZ6Ye2eDZWtoJtZrwEPTxKMUjbM/GHaXdRW
         Fu/ZbqIJULL2S9wGromLzzyiqvtQpT876BlnFbo1KE5rmSumjnPeNaY82vZ07IV+XRfT
         c4zyDoKXCr7wPRnZE1FBak94yAlU72ipSjEqEsfgJz6Yi8zFIz0AOFbBQUVOKiHvXrYM
         q9DA==
X-Gm-Message-State: APuU4Z+EmLq7dKvs3TcuwsTkVUCSNn9B2iz/D5dmpEJxpuC+1Sl6BVxI
	x+if2SNgUjJRRHMFNTLhX7scZbD1IdHP3PzqrxR3t3L+jLcD1UNe4rUn4Z0idLjorTckF5kOHle
	sAOsgWvI=
X-Gm-Gg: AZFdTZc9jwNx9WVV915mqD5bKMbhK/OuRugsHWQ8RiLXv8Rauai7C3aaPy9QNLqAvW7
	YPvyyDqavCKcfTeXJ4qjBqnMVrRdPLDzYN3IXMA9o+Petb1uZ7/KFrRc11Us/BncHyc5Skq6ElG
	Yf0CQpdol4b8863xLHIlvxvlCMKoL9YknWVNTKAaj6AXkr+gI9Hdzl68LRVSkPlzM/JiHcHibTW
	PmspTR7fMoDhFnigwEmKqNFuWjJzpYLXANh2DEDHExUscWzRL+bLKW3C3Ey8kZIWCwERyN+mR8K
	Qkx8ZvAzSdPbGQc4SS1VzRkPonB8uQwwi3J4eoPfhkQ9wzWJCWAxd9aC43AxWnoMq/SldLQikWC
	e2UBUm2e4rdMIazUfwjy7ciRyQzWJmx80ixPf47T3l6LRRz70eSbNd1uUoKGqnM51Mlvd1YUQKX
	YNL9bNm06OQrhgyP7J0uQoEeYYQ+5xuY6k2KuoB9znr/we5L/+pbJOMMji9hfUsvxT4i+9eK4nC
	UPo7THvIk6bEJHH+J/wm50+MLNcPesMWCS3FEL2RoXbXkMRzqzVQH3d4yF0Hk6pllAAaupKpeiR
	t/1BWz4JtPC4xRFZfRDDlznpJg/mQAtIEiGaf43bl37ovrl+7lGRMmpRSRTAnlqvamf5
X-Received: by 2002:a05:600c:a087:b0:4bb:60bd:53b2 with SMTP id 5b1f17b1804b1-4bb887fe7bdmr470654975e9.6.1795752271749;
        Thu, 26 Nov 2026 20:04:31 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5cef:65d5:b333:e710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm388721725e9.2.2026.11.26.20.04.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 20:04:31 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v4 07/10] erofs-utils: lib: add persistent dm-snapshot parser
Date: Fri, 27 Nov 2026 05:04:24 +0100
Message-ID: <20261127040427.99710-1-xiang.gao@docker.com>
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
index 0000000..6112a1c
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
+	u8 private[0];
+};
+
+/* The caller retains ownership of vf. Return ERR_PTR() on failure. */
+struct erofs_file_delta *erofs_dm_persistent_open(struct erofs_vfile *vf);
+
+#endif
-- 
2.54.0 (Apple Git-157)


