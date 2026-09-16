Return-Path: <linux-erofs+bounces-4572-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F8CC982C7
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Sep 2026 09:10:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hlClX5Jy7z2xlY;
	Wed, 16 Sep 2026 19:10:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789549816;
	cv=none; b=g3bhgW3yQlTsdwN7llH2Ydu4nR7WeiwrOVag0eEo9ZosC1LPZKDaKuF0IFk+3+j/HkfATtTGeESPVklliH08G0WP/BINaxruzrbdjbqnL6A3tl2Yd4qrWyy1aRpVdSU3bWu0uCx0vSp+CSAifvdEZltMmnDbgJ/keniZPUq6w95OlzRB7Fyl5ufnp9U5HjRcrJ+Ui7x3lTQLOTZhQyR4WToZwSI7LQ6iPsvoH7p44pK9cdaxnqpvhBDqi3JXqES1zVM87Xx6n/dF0hxJTd7cH2uF4UJcguR06umPwhd+9Mpc+L6opSNyALpI8uC71gRcJ1DHWMln6O6XkhBOCfXVbw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789549816; c=relaxed/relaxed;
	bh=fzi+ff7sjg0LKQ+gihfcQCfI4YCidG/8VZKQqVly/Fs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9FOZw5LpeMQBPeCkOailnnzFVKnVkQPPYjCJmjVRYk0PsA5RoatXKi5NqLVhTYLQHh+3BNVl39XikJ1Gg4WWrcl02gB/IH4uRkk8no7cTj04GVT1GhtQF3XWCG1SpBvoZksCJGTO5bAfA2+HQNz66B6C6HDE7issAlQVrjlan41ln/XDjGwj2YKmEdPSaSwv7CnL7TWIhp2oQ9Vqa2NttjfO+CoEwQFuxqjevMw8YHOqd/K0YbGeIigDruhN2j3W6YHUiEVtWUnSWWg+o10R2z7gWHpZcxtH3PdWGXg7YlnemXYgS3ZZCc5KT9OGpgt3TRk8LuyJh1tzLFl8lGYkw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VGTVcdo3; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::d; helo=mail-pz2-x0d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VGTVcdo3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::d; helo=mail-pz2-x0d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x0d.google.com (mail-pz2-x0d.google.com [IPv6:2607:f8b0:4864:3b::d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hlClV12hJz2yGT
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 19:10:13 +1000 (AEST)
Received: by mail-pz2-x0d.google.com with SMTP id d2e1a72fcca58-85469f204f6so403311b3a.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 02:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789549812; x=1790154612; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fzi+ff7sjg0LKQ+gihfcQCfI4YCidG/8VZKQqVly/Fs=;
        b=VGTVcdo3zm2cruWeDfvehydzG1P9MsIeJ8J09osRSxU/Bz2aVS9xizlyFD4gvINb0T
         ktY+9TwoDm6nc781/7tt/DSB9T2HP8DUcNL4PyQPyVEPEGpUwzTiUlqP1le/oh/ZYOVr
         SUEXZB28hLH2tUiJjZZeLPwtvqAHNoSqANd/XkNrlRF8Y9Mvj7iPfHkOpaYXwtQ+hpdc
         vjqVmUIhHUo53/ib1dEmUjV6SbmgEVnOLXTlBLOKAIORc7SY1JulxlkkQ3Oyz5Ntz8Mw
         FhVgU+1qD5o+8prttrdM4KemiY8puDcZZ1o8K82bSXnVKGsR4V7tQrcUknTvFmOzgdKb
         /eAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789549812; x=1790154612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fzi+ff7sjg0LKQ+gihfcQCfI4YCidG/8VZKQqVly/Fs=;
        b=CTb7PUZMCDkLhAolOKrNCZ8PN+E1019ir8BWffooUCw1DLtcvE2bLq2oFiW4a60m89
         t04pqOraoq/FNL8n4QJyT5P1e161CkfUD2JHBcpJUKXxuOrftUgdWFpSXtOUuk4h+1TK
         YrCfNe7tuqLTePx5tzGe+Ktej3g1AjiHpyHnjdYm3c5XksGEIN2GZECSHVnALzQnJlBM
         X6ig8/KUdbz2puTX9PF0POagEzDVxQskJniMVNKzfVJoEUn8EJMUJRmud/seDkBPffl+
         Tae53z2cBwxT4YLYhLex9+aPpYro5/In+GEOSvaBqx6hGZA3sYAxbdw2D+QkWB9PaR7G
         3dnw==
X-Gm-Message-State: AFuF++mlJLj4om81mBdIddq75F20jxwV/sHC864vRl0uSiw03ZnTn1GU
	KHf9/y11v8Veo4LlzwbKLc+N0RjBSt0OQdHgEg6K218/2TKH7iaei2rbdFXg7U7iMGg=
X-Gm-Gg: AYBFou00oVTKS7NB4pxedhT3kX78OFI0b1vBQq87xxZSCcc+mlTXXIZVa3H07uHYStr
	nBYK4HkPJjEK+SPJrOQwrxJk56l47y20iH2TqLlfZNm67FF2YlPpRHHvSlfsQrxn1q6TsVkTh7/
	AC44b5CkXVvCeEIva6WwDZotF+WnFK0NDGNBI5FHxn+wK6se/JgjV7WbcT76H+t3nDJZ/9mfhIk
	QQILdkHGkpDwv6xdIh/Z3hJPNi/8Bpah+wPvbAilx/McR3hQT89WQsIqjoEKtROUp3x9unj08VM
	qu/pJK3ZF8qt2v4pbtcGFiE7LgLRKs17xcAGEseEw/yvBNDQ0aS6w5EHQgJPY1ybNftxEkRbu0g
	x3Zr+M9k+yNQ5TfEUBXyzWvXm58771IljehGkyQqNjEixV51e5RL7qqt/4kb/CdSVt6sNWVzwWC
	owONmLKsqqU3DyCniHX6BQ0sNo0G6gIeb9dG8zTZ6Mk6vLhTMexXfH5cWKOY1SRGnHvAPT76MZV
	Wbz18pCyBJF7//109B5sJ4TMH8rPeOkrKRzdifj4lV7Drcr3Ykr97aDaE/X66TTya71sw==
X-Received: by 2002:a05:6a20:430a:b0:3da:6bdd:2308 with SMTP id adf61e73a8af0-3dd5f5d673emr4147377637.18.1789549811722;
        Wed, 16 Sep 2026 02:10:11 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50ab50d67sm1215277a12.6.2026.09.16.02.10.10
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 02:10:11 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
X-Google-Original-From: Yifan Zhao <yifan.yfzhao@foxmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH RFC 2/2] erofs-utils: mkfs: support dm-persistent file deltas
Date: Wed, 16 Sep 2026 17:10:03 +0800
Message-ID: <e61f4a905e4c375f2be89c60a9656ea55aa72ae7.1789545930.git.stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789545930.git.stopire@gmail.com>
References: <cover.1789545930.git.stopire@gmail.com>
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

Parse and validate version 1 dm-persistent snapshot exception stores, then
expose their logical update units through the file-delta source operations.
The source unit size is independent of the parent chunk geometry.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <yifan.yfzhao@foxmail.com>
---
 lib/Makefile.am              |   3 +-
 lib/dm_persistent.c          | 396 +++++++++++++++++++++++++++++++++++
 lib/liberofs_dm_persistent.h |   9 +
 man/mkfs.erofs.1             |  15 ++
 mkfs/main.c                  |   2 +
 5 files changed, 424 insertions(+), 1 deletion(-)
 create mode 100644 lib/dm_persistent.c
 create mode 100644 lib/liberofs_dm_persistent.h

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 3d562f4..24e7d0b 100644
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
 		      vmdk.c metabox.c global.c importer.c base64.c file_delta.c \
-		      file_delta_chunk.c
+		      file_delta_chunk.c dm_persistent.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
diff --git a/lib/dm_persistent.c b/lib/dm_persistent.c
new file mode 100644
index 0000000..0b0cfeb
--- /dev/null
+++ b/lib/dm_persistent.c
@@ -0,0 +1,396 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <config.h>
+#ifdef HAVE_LINUX_FS_H
+#include <linux/fs.h>
+#endif
+#include "erofs/print.h"
+#include "liberofs_dm_persistent.h"
+
+#ifndef EFSCORRUPTED
+#ifdef EUCLEAN
+#define EFSCORRUPTED EUCLEAN
+#else
+#define EFSCORRUPTED EIO
+#endif
+#endif
+
+#ifndef O_CLOEXEC
+#define O_CLOEXEC 0
+#endif
+#ifndef O_BINARY
+#define O_BINARY 0
+#endif
+
+#define EROFS_DM_SNAP_MAGIC		0x70416e53U
+#define EROFS_DM_DISK_VERSION		1U
+#define EROFS_DM_SECTOR_SIZE		512U
+
+struct erofs_dm_exception {
+	u64 old_chunk;
+	u64 new_chunk;
+};
+
+struct erofs_dm_delta {
+	int fd;
+	u64 store_size;
+	u64 target_size;
+	u64 chunk_bytes;
+	u64 exceptions_per_area;
+	size_t nr_exceptions;
+	struct erofs_dm_exception *exceptions;
+};
+
+static void erofs_dm_persistent_close(struct erofs_dm_delta *delta);
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
+static int erofs_dm_get_store_size(int fd, const struct stat *st, u64 *size)
+{
+	if (S_ISREG(st->st_mode)) {
+		if (st->st_size < 0)
+			return -EOVERFLOW;
+		*size = st->st_size;
+		return 0;
+	}
+	if (!S_ISBLK(st->st_mode))
+		return -ENOTSUP;
+
+#ifdef BLKGETSIZE64
+	if (!ioctl(fd, BLKGETSIZE64, size))
+		return 0;
+#endif
+#ifdef BLKGETSIZE
+	{
+		unsigned long sectors;
+
+		if (!ioctl(fd, BLKGETSIZE, &sectors)) {
+			if ((u64)sectors > UINT64_MAX >> 9)
+				return -EOVERFLOW;
+			*size = (u64)sectors << 9;
+			return 0;
+		}
+	}
+#endif
+#if defined(BLKGETSIZE64) || defined(BLKGETSIZE)
+	return -errno;
+#else
+	return -ENOTSUP;
+#endif
+}
+
+static int erofs_dm_pread_exact(int fd, void *buf, size_t len, u64 offset)
+{
+	size_t done = 0;
+
+	if (offset > INT64_MAX || len > INT64_MAX - offset)
+		return -EOVERFLOW;
+	while (done < len) {
+		ssize_t ret;
+
+#ifdef HAVE_PREAD64
+		ret = pread64(fd, (char *)buf + done, len - done,
+			      (off64_t)(offset + done));
+#else
+		ret = pread(fd, (char *)buf + done, len - done,
+			    (off_t)(offset + done));
+#endif
+		if (ret < 0) {
+			if (errno == EINTR)
+				continue;
+			return -errno;
+		}
+		if (!ret)
+			return -EIO;
+		done += ret;
+	}
+	return 0;
+}
+
+static int erofs_dm_exception_cmp(const void *a, const void *b)
+{
+	const struct erofs_dm_exception *ea = a, *eb = b;
+
+	return (ea->old_chunk > eb->old_chunk) -
+	       (ea->old_chunk < eb->old_chunk);
+}
+
+static int erofs_dm_append_exception(struct erofs_dm_delta *delta,
+				     size_t *capacity, u64 max_target_chunks,
+				     u64 old_chunk, u64 new_chunk)
+{
+	struct erofs_dm_exception *p;
+	size_t new_capacity, bytes;
+
+	if (delta->nr_exceptions >= max_target_chunks)
+		return -EINVAL;
+	if (delta->nr_exceptions < *capacity)
+		goto add;
+
+	new_capacity = *capacity ? *capacity << 1 : 64;
+	if (new_capacity < *capacity)
+		return -E2BIG;
+	if (new_capacity > max_target_chunks)
+		new_capacity = max_target_chunks;
+	if (new_capacity <= *capacity ||
+	    __builtin_mul_overflow(new_capacity, sizeof(*p), &bytes))
+		return -E2BIG;
+	p = realloc(delta->exceptions, bytes);
+	if (!p)
+		return -ENOMEM;
+	delta->exceptions = p;
+	*capacity = new_capacity;
+add:
+	delta->exceptions[delta->nr_exceptions++] =
+		(struct erofs_dm_exception) {
+			.old_chunk = old_chunk,
+			.new_chunk = new_chunk,
+		};
+	return 0;
+}
+
+static int erofs_dm_parse_exceptions(struct erofs_dm_delta *delta)
+{
+	u64 max_target_chunks = delta->target_size / delta->chunk_bytes;
+	struct erofs_dm_disk_exception *area_buf;
+	size_t capacity = 0;
+	u64 area, stride;
+	int ret = 0;
+	bool partial = delta->target_size % delta->chunk_bytes;
+
+	stride = delta->exceptions_per_area + 1;
+	max_target_chunks += partial;
+
+	area_buf = malloc(delta->chunk_bytes);
+	if (!area_buf)
+		return -ENOMEM;
+
+	for (area = 0; ; ++area) {
+		u64 metadata_chunk, metadata_offset, metadata_end;
+		u64 i;
+
+		if (__builtin_mul_overflow(stride, area, &metadata_chunk) ||
+		    check_add_overflow(metadata_chunk, (u64)1, &metadata_chunk) ||
+		    __builtin_mul_overflow(metadata_chunk, delta->chunk_bytes,
+					   &metadata_offset) ||
+		    check_add_overflow(metadata_offset, delta->chunk_bytes,
+				       &metadata_end) ||
+		    metadata_end > delta->store_size) {
+			ret = -EFSCORRUPTED;
+			break;
+		}
+		ret = erofs_dm_pread_exact(delta->fd, area_buf,
+					   delta->chunk_bytes, metadata_offset);
+		if (ret) {
+			if (ret == -EIO)
+				ret = -EFSCORRUPTED;
+			break;
+		}
+
+		for (i = 0; i < delta->exceptions_per_area; ++i) {
+			u64 old_chunk = le64_to_cpu(area_buf[i].old_chunk);
+			u64 new_chunk = le64_to_cpu(area_buf[i].new_chunk);
+			u64 payload_offset, payload_end;
+
+			if (!new_chunk)
+				goto terminated;
+			if (new_chunk % stride == 1 ||
+			    __builtin_mul_overflow(new_chunk,
+						   delta->chunk_bytes,
+						   &payload_offset) ||
+			    check_add_overflow(payload_offset, delta->chunk_bytes,
+					       &payload_end) ||
+			    payload_end > delta->store_size) {
+				ret = -EFSCORRUPTED;
+				goto out;
+			}
+			if (old_chunk >= max_target_chunks) {
+				ret = -EINVAL;
+				goto out;
+			}
+			ret = erofs_dm_append_exception(delta, &capacity,
+					max_target_chunks, old_chunk, new_chunk);
+			if (ret)
+				goto out;
+		}
+	}
+	goto out;
+
+terminated:
+	if (delta->nr_exceptions > 1)
+		qsort(delta->exceptions, delta->nr_exceptions,
+		      sizeof(*delta->exceptions), erofs_dm_exception_cmp);
+	for (area = 1; area < delta->nr_exceptions; ++area) {
+		if (delta->exceptions[area - 1].old_chunk ==
+		    delta->exceptions[area].old_chunk) {
+			ret = -EINVAL;
+			break;
+		}
+	}
+out:
+	free(area_buf);
+	return ret;
+}
+
+static int erofs_dm_persistent_open(struct erofs_dm_delta *delta,
+				    const char *path, u64 target_size,
+				    erofs_off_t unit_size)
+{
+	struct erofs_dm_disk_header header;
+	struct stat st;
+	u32 sectors;
+	u64 chunk_bytes;
+	int flags, ret;
+
+	BUILD_BUG_ON(sizeof(header) != 16);
+	BUILD_BUG_ON(sizeof(struct erofs_dm_disk_exception) != 16);
+	*delta = (struct erofs_dm_delta) { .fd = -1 };
+	delta->target_size = target_size;
+
+	delta->fd = open(path, O_RDONLY | O_BINARY | O_CLOEXEC | O_NONBLOCK);
+	if (delta->fd < 0) {
+		ret = -errno;
+		goto err;
+	}
+	if (fstat(delta->fd, &st)) {
+		ret = -errno;
+		goto err;
+	}
+	ret = erofs_dm_get_store_size(delta->fd, &st, &delta->store_size);
+	if (ret)
+		goto err;
+	flags = fcntl(delta->fd, F_GETFL);
+	if (flags < 0 || fcntl(delta->fd, F_SETFL, flags & ~O_NONBLOCK)) {
+		ret = -errno;
+		goto err;
+	}
+	ret = erofs_dm_pread_exact(delta->fd, &header, sizeof(header), 0);
+	if (ret) {
+		if (ret == -EIO)
+			ret = -EFSCORRUPTED;
+		goto err;
+	}
+	if (le32_to_cpu(header.magic) != EROFS_DM_SNAP_MAGIC ||
+	    le32_to_cpu(header.version) != EROFS_DM_DISK_VERSION) {
+		ret = -EFSCORRUPTED;
+		goto err;
+	}
+	if (le32_to_cpu(header.valid) != 1) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	sectors = le32_to_cpu(header.chunk_size);
+	if (!sectors || (sectors & (sectors - 1)) ||
+	    sectors > (INT_MAX >> 9)) {
+		ret = -EFSCORRUPTED;
+		goto err;
+	}
+	chunk_bytes = (u64)sectors * EROFS_DM_SECTOR_SIZE;
+	if (chunk_bytes != unit_size) {
+		erofs_err("file-delta source %s chunk size %llu does not match %llu",
+			  path, chunk_bytes | 0ULL, unit_size | 0ULL);
+		ret = -EINVAL;
+		goto err;
+	}
+	delta->chunk_bytes = chunk_bytes;
+	delta->exceptions_per_area = chunk_bytes /
+					    sizeof(struct erofs_dm_disk_exception);
+	ret = erofs_dm_parse_exceptions(delta);
+	if (ret)
+		goto err;
+	return 0;
+err:
+	erofs_dm_persistent_close(delta);
+	return ret;
+}
+
+static void erofs_dm_persistent_close(struct erofs_dm_delta *delta)
+{
+	if (delta->fd >= 0)
+		close(delta->fd);
+	free(delta->exceptions);
+	*delta = (struct erofs_dm_delta) { .fd = -1 };
+}
+
+static int erofs_dm_persistent_read_payload(const struct erofs_dm_delta *delta,
+					    size_t exception_index, void *buf)
+{
+	u64 offset = delta->exceptions[exception_index].new_chunk *
+		     delta->chunk_bytes;
+
+	return erofs_dm_pread_exact(delta->fd, buf, delta->chunk_bytes, offset);
+}
+
+static int erofs_file_delta_dm_open(struct erofs_file_delta *delta,
+				    u64 target_size,
+				    erofs_off_t unit_size)
+{
+	struct erofs_dm_delta *dm;
+	int ret;
+
+	dm = malloc(sizeof(*dm));
+	if (!dm)
+		return -ENOMEM;
+	ret = erofs_dm_persistent_open(dm, delta->source_path, target_size,
+				       unit_size);
+	if (ret) {
+		free(dm);
+		return ret;
+	}
+	delta->private = dm;
+	return 0;
+}
+
+static void erofs_file_delta_dm_close(struct erofs_file_delta *delta)
+{
+	struct erofs_dm_delta *dm = delta->private;
+
+	if (!dm)
+		return;
+	erofs_dm_persistent_close(dm);
+	free(dm);
+	delta->private = NULL;
+}
+
+static size_t erofs_file_delta_dm_count(const struct erofs_file_delta *delta)
+{
+	const struct erofs_dm_delta *dm = delta->private;
+
+	return dm->nr_exceptions;
+}
+
+static int erofs_file_delta_dm_read(const struct erofs_file_delta *delta,
+				    size_t index, u64 *chunk, void *buf)
+{
+	const struct erofs_dm_delta *dm = delta->private;
+
+	DBG_BUGON(index >= dm->nr_exceptions || !chunk || !buf);
+	*chunk = dm->exceptions[index].old_chunk;
+	return erofs_dm_persistent_read_payload(dm, index, buf);
+}
+
+const struct erofs_file_delta_source_ops erofs_file_delta_dm_persistent_ops = {
+	.name = "dm-persistent",
+	.open = erofs_file_delta_dm_open,
+	.close = erofs_file_delta_dm_close,
+	.count = erofs_file_delta_dm_count,
+	.read = erofs_file_delta_dm_read,
+};
diff --git a/lib/liberofs_dm_persistent.h b/lib/liberofs_dm_persistent.h
new file mode 100644
index 0000000..1a0f476
--- /dev/null
+++ b/lib/liberofs_dm_persistent.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_LIB_LIBEROFS_DM_PERSISTENT_H
+#define __EROFS_LIB_LIBEROFS_DM_PERSISTENT_H
+
+#include "liberofs_file_delta.h"
+
+extern const struct erofs_file_delta_source_ops erofs_file_delta_dm_persistent_ops;
+
+#endif
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index dcac6f0..e38355d 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -394,6 +394,21 @@ parent and delta chunk geometries do not require a redundant \fB-b\fR option.
 The source specification is the remainder after the second colon, so it may
 itself contain colons.  Repeated file-delta options must refer to distinct target
 files.  A source may be reused when the selected backend permits it.
+.RS
+.TP
+.B dm-persistent
+Treat \fISOURCE\fR as a Linux dm-persistent snapshot exception store version
+1.  Each exception replaces the logical update unit identified by
+\fBold_chunk\fR with the payload at \fBnew_chunk\fR.  The dm chunk size and
+\fB\-\-chunksize\fR must be equal.  An update to the last partial unit is
+clipped to the target file size.
+
+The source can be a regular file or block device and must remain unchanged for
+the complete build.  Its header must have magic \fB0x70416e53\fR,
+\fBvalid=1\fR, version 1, and a power-of-two chunk size.
+FIFOs and other unsupported source object types are rejected without waiting
+for a peer to open them.
+.RE
 .TP
 .BI "\-\-max-extent-bytes=" #
 Specify maximum decompressed extent size in bytes. The default is unlimited.
diff --git a/mkfs/main.c b/mkfs/main.c
index 7598f0a..d6d3e9d 100644
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
@@ -335,6 +336,7 @@ static struct erofs_file_delta_manager file_delta_mgr = {
 	.deltas = LIST_HEAD_INIT(file_delta_mgr.deltas),
 };
 static const struct erofs_file_delta_source_ops * const file_delta_backends[] = {
+	&erofs_file_delta_dm_persistent_ops,
 	NULL,
 };
 static u8 fixeduuid[16];
-- 
2.55.0


