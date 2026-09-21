Return-Path: <linux-erofs+bounces-4592-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E65C982F0
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 13:35:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hpPPh5Wzzz2xbQ;
	Mon, 21 Sep 2026 23:35:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789997752;
	cv=none; b=VjS/fiYaoCn1jn3ih1Dl9Il9nnRSZ+ItsK5PuChE8WlmfvC8AIYW4j3h+aW5LySrW0Jmu6ccJ2ciTaGJ+4acFtNZZ8FMQqLkYAsOFLbfX0LWS1ujdWAbMmvS0QudruKVZtomBqLM9GW3T0LcLlxr5JPCHN6as/GMlm4Fqu2B7D3MKKAMWtR6IgM3GJ/5iUL7pzEEcrKWxtPrqnoV7VgoYYscrVefScGEzaZPp1fpkWzPcv8Z6kLPsgt0n71+ns35v3BxUQsiKHHnB+m+kmwm+/culVXgKJ1OJkX5X1S0KUiM76oW9zcqF9h0ftHBdDU5X30/nvAzP0Nu7vKI380oSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789997752; c=relaxed/relaxed;
	bh=etcR5MYce2nIIh+lp1D2wnNkKg2ufpSp4Fqy1kXT6FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag1/wKteI4ZfiyghZgoVcID2BUmfL/wvCFJkQRY9FGjU38U2qxhkk8mGxYxeWCcYSduN4qmWDTg5ZGpLL4jkUur0/xorVpmRW+HwJiJfMG0HOqP9GmEkw2PGC0PQ1QOgFPi6Nepy9BLBiMRN6vfTiRpoacSWsNeTb6Hp7aTskNzwEHniNyDyo03jFh+jevMkPg6WQo7PHactuE7n16Eh/q0AvZv0hPZux4Sf+XvJI2fMWnhtK7tVJaWh4sDcoe1F1/rKyWIN8VybFotS8QNMVsyDyJGuq4jg3EZFJSSId5APRPP/VnCVsmNdp18mzyliI0tfPwTaTBH1ht5QzVxNKQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OE9Dcs6t; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::f; helo=mail-pj2-x0f.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OE9Dcs6t;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::f; helo=mail-pj2-x0f.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0f.google.com (mail-pj2-x0f.google.com [IPv6:2607:f8b0:4864:39::f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hpPPg3yRnz2xk7
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 23:35:51 +1000 (AEST)
Received: by mail-pj2-x0f.google.com with SMTP id 98e67ed59e1d1-396ccb1a98fso2682235a91.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 06:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997749; x=1790602549; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=etcR5MYce2nIIh+lp1D2wnNkKg2ufpSp4Fqy1kXT6FI=;
        b=OE9Dcs6t2dnwerNFJSSrLUoqREn1ljnsDk1e+UncTtL72p2dBzTlO0SHmw6vnKm9ee
         uXgAdbfjdzYd7RRqxAIQLaXFPLxcBnzgnM56cms2PVeHuW1uNQ4UtgX6lhQ+JEMdcMgY
         YChSPTpdBhPw3Aj89kp9hyjlNcez26OxR06WXhf87aVSqprNcP+sT04UCZGE2caTjCh6
         a3fk9USpPDaQr1g40TMBECByz5RxAvbwWYH4ZazsK+WlwTBXANKQNMM+lvrt9TNzTR/j
         7ww5Eg3yQ8+voiwcZjSsAinRYHS3J6aAjq0VzIdotBvdQ/v4QDm8nJfywUwP3JJtsN+6
         F7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997749; x=1790602549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=etcR5MYce2nIIh+lp1D2wnNkKg2ufpSp4Fqy1kXT6FI=;
        b=nNQadx91vXWvGS3CD0J6/VBScepLAh9Zu9vAaouBiGDwdNMxcUjFoa6bNvhPj3w2R1
         O4+EUNq8CtCS/dXFBJ0QRvyLaVK4EuK2DR5nsjtqobSyY5q7raSDRyiNUW3A2CKXKyBL
         z3lQJvazcIv7SI1Ugk8dFZfOfySupH60tCZmauIuPhMeX1mzSlOIzB78ZboersUK44Qi
         HnVW30UcHJdlbruXOb71Tjy9sxNHIRMN15KgGgI/CaO+Q3DOJSJX3Z/F3GXN0q8EWTry
         oY6kNH9Qzo5Wbm8nPFS6mO25WNWZ6zmufxa7RmsIoLW9OFSyeiYQFDPbLfD6qUkUqXFk
         BWRw==
X-Gm-Message-State: AFuF++n0nRcasqummzJG5y5wEDSCsfe8426I1VKLaLEPQCVPC9C4xEjv
	sHqgc124ifxQOMylQACIHqz2WdYzE0GHGzaGdNDkQOnMLIjL8o4Wue3pC1VBuPys
X-Gm-Gg: AYBFou3mZAFp33c4qFld4XyLZlfY1zdGkb1oIid8MMHQLAPiguu2MM+VHanLR6teBpT
	0VucI/RhK4f2ypM3JdrheqkaRrdl1HLa5tl/y4XoJ5LjThyDxU9xETQLMbDlywg2GrmWAI3pI5h
	VIC3JApu0QM3A9E9x/MkqDEoyShNjK/soUI4w9HJiat/qdSsYpF6DNIa1yGjsJURIplx4uoSFW5
	Yb2NqpC5GJBFCOHBYQZsBOQNaX7DmXeH/sT10YSTXkIFakzCj9Hb3M3UzU0c+v/vvCFyh7kXjSg
	b9j7QJ4vFa+cYAd4diRCHgSG6cxA1qDkuKwCblHS8/Ch223dHNtX99Q9WVXWiB+mO2IJjJl5JuR
	fpAcWx91CwAq/eKdHLR2rwP9kUnwUo8+qrgQ457wMhtYngM0PKKY9Sfzx9Q5S4IzXbN2VtRv1IL
	qkkeTfWPS4O0VWQSCtulM8XEw/qjRiHxCr2oxLFTfdRLp2bRZ+VovRz3OhzFKtJhbpfCFQ/L5e1
	77CxyMQQ+VqFnIYBwCqv5opGYzL3n1jKN5pR4gwc0N2We7cnw==
X-Received: by 2002:a17:90b:1e0d:b0:39e:6a80:b798 with SMTP id 98e67ed59e1d1-39e6a80b869mr9815743a91.40.1789997749439;
        Mon, 21 Sep 2026 06:35:49 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06369372csm179385a91.1.2026.09.21.06.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:35:48 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH v2 4/4] erofs-utils: mkfs: support dm-persistent file deltas
Date: Mon, 21 Sep 2026 21:35:35 +0800
Message-ID: <20260921133535.2381246-4-stopire@gmail.com>
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

Parse and validate version 1 dm-persistent snapshot exception stores,
then convert exceptions into sorted DATA extents.  Inherit ranges
without exceptions and clip the last update to the target file size.

Require the source chunk size to match --chunksize, independently of the
parent chunk geometry.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/Makefile.am              |   3 +-
 lib/deltas/dm_persistent.c   | 199 +++++++++++++++++++++++++++++++++++
 lib/liberofs_dm_persistent.h |   9 ++
 man/mkfs.erofs.1             |   8 ++
 mkfs/main.c                  |   2 +
 5 files changed, 220 insertions(+), 1 deletion(-)
 create mode 100644 lib/deltas/dm_persistent.c
 create mode 100644 lib/liberofs_dm_persistent.h

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 7f86409..7d7411e 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -24,6 +24,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/lib/liberofs_cache.h \
       $(top_srcdir)/lib/liberofs_chunk.h \
       $(top_srcdir)/lib/liberofs_compress.h \
+      $(top_srcdir)/lib/liberofs_dm_persistent.h \
       $(top_srcdir)/lib/liberofs_file_delta.h \
       $(top_srcdir)/lib/liberofs_fragments.h \
       $(top_srcdir)/lib/liberofs_private.h \
@@ -46,7 +47,7 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
 		      block_list.c rebuild.c diskbuf.c bitops.c dedupe_ext.c \
 		      vmdk.c metabox.c global.c importer.c base64.c \
-		      file_delta.c
+		      file_delta.c deltas/dm_persistent.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
diff --git a/lib/deltas/dm_persistent.c b/lib/deltas/dm_persistent.c
new file mode 100644
index 0000000..d09bd89
--- /dev/null
+++ b/lib/deltas/dm_persistent.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#include <config.h>
+#include "erofs/print.h"
+#include "liberofs_dm_persistent.h"
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
+/* Temporary sorting storage, released before the parser returns. */
+struct erofs_dm_exceptions {
+	struct erofs_dm_exception *entries;
+	size_t count, capacity;
+};
+
+static int erofs_dm_pread(struct erofs_vfile *vf, erofs_off_t size,
+			 void *buf, size_t len, erofs_off_t offset)
+{
+	const struct erofs_delta_extent source = { .vf = vf, .length = size };
+	int ret;
+
+	ret = erofs_delta_read(&source, offset, buf, len);
+	return ret == -EINVAL || ret == -EIO ? -EFSCORRUPTED : ret;
+}
+
+static int erofs_dm_exception_cmp(const void *a, const void *b)
+{
+	const struct erofs_dm_exception *ea = a, *eb = b;
+
+	return (ea->offset > eb->offset) - (ea->offset < eb->offset);
+}
+
+static int erofs_dm_add_exception(struct erofs_dm_exceptions *exceptions,
+				 u64 max_chunks, erofs_off_t offset,
+				 erofs_off_t source_offset)
+{
+	struct erofs_dm_exception *p;
+	size_t capacity;
+
+	if (exceptions->count >= max_chunks)
+		return -EINVAL;
+	if (exceptions->count == exceptions->capacity) {
+		capacity = exceptions->capacity ? exceptions->capacity * 2 : 64;
+		if (capacity < exceptions->capacity)
+			return -E2BIG;
+		if (capacity > max_chunks)
+			capacity = max_chunks;
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
+static int erofs_dm_parse_exceptions(struct erofs_vfile *vf,
+				     erofs_off_t source_size,
+				     erofs_off_t target_size,
+				     erofs_off_t chunk_bytes,
+				     struct list_head *extents)
+{
+	/* Read metadata in bounded batches, independently of the dm chunk size. */
+	struct erofs_dm_disk_exception buf[256];
+	struct erofs_dm_exceptions exceptions = {};
+	u64 per_area = chunk_bytes / sizeof(buf[0]), stride = per_area + 1;
+	u64 source_chunks = source_size / chunk_bytes;
+	u64 max_chunks = target_size / chunk_bytes + !!(target_size % chunk_bytes);
+	erofs_off_t metadata_chunk = 1, metadata_offset, offset, source_offset;
+	u64 i, j, nr;
+	size_t n;
+	int ret;
+
+	for (;;) {
+		/* Chunk 0 is the header; metadata areas start at 1 + n * stride. */
+		if (metadata_chunk >= source_chunks) {
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		metadata_offset = metadata_chunk * chunk_bytes;
+		for (i = 0; i < per_area; i += nr) {
+			nr = min_t(u64, per_area - i, ARRAY_SIZE(buf));
+			ret = erofs_dm_pread(vf, source_size, buf, nr * sizeof(buf[0]),
+					      metadata_offset + i * sizeof(buf[0]));
+			if (ret)
+				goto out;
+			for (j = 0; j < nr; ++j) {
+				u64 old_chunk = le64_to_cpu(buf[j].old_chunk);
+				u64 new_chunk = le64_to_cpu(buf[j].new_chunk);
+
+				/* The first zero new_chunk terminates the exception table. */
+				if (!new_chunk)
+					goto terminated;
+				if (new_chunk % stride == 1 ||
+				    new_chunk >= source_chunks) {
+					ret = -EFSCORRUPTED;
+					goto out;
+				}
+				if (old_chunk >= max_chunks) {
+					ret = -EINVAL;
+					goto out;
+				}
+				offset = old_chunk * chunk_bytes;
+				source_offset = new_chunk * chunk_bytes;
+				ret = erofs_dm_add_exception(&exceptions, max_chunks,
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
+	if (exceptions.count > 1)
+		qsort(exceptions.entries, exceptions.count,
+		      sizeof(*exceptions.entries), erofs_dm_exception_cmp);
+	for (n = 0; n < exceptions.count; ++n) {
+		const struct erofs_dm_exception *e = &exceptions.entries[n];
+
+		if (n && exceptions.entries[n - 1].offset == e->offset) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = erofs_delta_add(extents, false, e->offset,
+				      min_t(erofs_off_t, chunk_bytes, target_size - e->offset),
+				      vf, e->source_offset);
+		if (ret)
+			goto out;
+	}
+	ret = 0;
+out:
+	free(exceptions.entries);
+	return ret;
+}
+
+static int erofs_dm_persistent_parse(struct erofs_vfile *vf,
+				     erofs_off_t source_size,
+				     erofs_off_t target_size,
+				     erofs_off_t expected_unit,
+				     struct list_head *extents)
+{
+	struct erofs_dm_disk_header header;
+	erofs_off_t chunk_bytes;
+	u32 sectors;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(header) != 16);
+	BUILD_BUG_ON(sizeof(struct erofs_dm_disk_exception) != 16);
+	ret = erofs_dm_pread(vf, source_size, &header, sizeof(header), 0);
+	if (ret)
+		return ret;
+	if (le32_to_cpu(header.magic) != EROFS_DM_SNAP_MAGIC ||
+	    le32_to_cpu(header.version) != EROFS_DM_DISK_VERSION)
+		return -EFSCORRUPTED;
+	if (le32_to_cpu(header.valid) != 1)
+		return -EINVAL;
+	sectors = le32_to_cpu(header.chunk_size);
+	if (!sectors || (sectors & (sectors - 1)) || sectors > (INT_MAX >> 9))
+		return -EFSCORRUPTED;
+	chunk_bytes = (erofs_off_t)sectors * EROFS_DM_SECTOR_SIZE;
+	if (chunk_bytes != expected_unit) {
+		erofs_err("dm-persistent chunk size %llu does not match %llu",
+			  chunk_bytes | 0ULL, expected_unit | 0ULL);
+		return -EINVAL;
+	}
+	return erofs_dm_parse_exceptions(vf, source_size, target_size,
+					chunk_bytes, extents);
+}
+
+const struct erofs_delta_spec_ops erofs_file_delta_dm_persistent_ops = {
+	.name = "dm-persistent",
+	.parse = erofs_dm_persistent_parse,
+};
diff --git a/lib/liberofs_dm_persistent.h b/lib/liberofs_dm_persistent.h
new file mode 100644
index 0000000..190468b
--- /dev/null
+++ b/lib/liberofs_dm_persistent.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_LIB_LIBEROFS_DM_PERSISTENT_H
+#define __EROFS_LIB_LIBEROFS_DM_PERSISTENT_H
+
+#include "liberofs_file_delta.h"
+
+extern const struct erofs_delta_spec_ops erofs_file_delta_dm_persistent_ops;
+
+#endif
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index b599232..217abfa 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -357,6 +357,14 @@ unsupported.
 Changed data is stored in the output image.  The output requires the parent as
 external device 1, followed by the parent's existing external devices in order.
 \fISOURCE\fR is needed only during the build.
+.RS
+.TP
+.B dm-persistent
+\fISOURCE\fR must be a valid Linux dm-snapshot persistent v1 exception store,
+provided as a regular file or block device and unchanged throughout the build.
+Its chunk size must match \fB\-\-chunksize\fR.  Ranges without exceptions
+inherit the parent contents.
+.RE
 .TP
 .BI "\-\-max-extent-bytes=" #
 Specify maximum decompressed extent size in bytes. The default is unlimited.
diff --git a/mkfs/main.c b/mkfs/main.c
index 199762a..1328492 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -26,6 +26,7 @@
 #include "erofs/compress_hints.h"
 #include "../lib/compressor.h"
 #include "../lib/liberofs_chunk.h"
+#include "../lib/liberofs_dm_persistent.h"
 #include "../lib/liberofs_file_delta.h"
 #include "../lib/liberofs_gzran.h"
 #include "../lib/liberofs_metabox.h"
@@ -333,6 +334,7 @@ static unsigned int rebuild_src_count;
 static LIST_HEAD(rebuild_src_list);
 static LIST_HEAD(file_delta_specs);
 static const struct erofs_delta_spec_ops * const file_delta_backends[] = {
+	&erofs_file_delta_dm_persistent_ops,
 	NULL,
 };
 static u8 fixeduuid[16];
-- 
2.55.0


