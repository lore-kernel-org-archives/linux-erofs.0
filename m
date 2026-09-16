Return-Path: <linux-erofs+bounces-4573-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69033C88E5C
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Sep 2026 09:10:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hlClY49XNz2yGT;
	Wed, 16 Sep 2026 19:10:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789549817;
	cv=none; b=B5xerPswCSht/pNyNQlFHMr0aErEu8rgsZe2O2ksSbanVroDwwfb8IAQLid1KNflS6yagDoliF0fekt2KjMaK6lUdmwdOiCwQ4foUKjSIYbYiwUdVzBfzQuN6DMhJTWZ9x3KgaQPNf9sQY78RX+yanYOZXdjm71Y0T1EIUD/Ti3NRWLAykX1TKCeEUMKX/if4W/kObRS+3Xm04TBOrvTIjUCe+aE0r81NiUoolL7LUaOOBXHcmolpKc/p8r10L611dRnExW33saJ3pPpG8Rri4SQyMD3s+GIRRBHo0CyfhFP9rM6NIvCxV2ffdRk6fmlSB47cANc8D0XdL+u0Xczww==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789549817; c=relaxed/relaxed;
	bh=xAHkVdVpTvr24jiaynpxp4fC5jaQgg2/IJV+8qSitXA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afRa0eMZun10tN+ycJWY51kn9hlTRkQiB5SUvNAAwojCJfP8DX8KfAYXYR5x8yhAKIFb7PWAFfxE7sxsRdo4tRD2Xcs+p3nySYSIgwT8SIfQLhb7qyBfSoEAb9ju9vRQEqznoWRToZML0Vp5dWN/GT7N4MvIWBx7THJUbcaVVIqgNJ18cBJZzL0qdxsqXpDWM6Ir9TTkpUxVoW0XvBR19RVuiZSyEuyr0CLgKlpKPJ/KQs8CL9RyOLBi913Y7M+tifJAcVpNthmwyJWUZmYJBnMaBh7PlOAoLBz+O/ExOb4BoJi8gcS0xt750Dx9AUM+qtBR77GForPvJUde4B7JRw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d1NdK/SD; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::d; helo=mail-pz2-x0d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d1NdK/SD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::d; helo=mail-pz2-x0d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x0d.google.com (mail-pz2-x0d.google.com [IPv6:2607:f8b0:4864:3b::d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hlClT2n91z2y2W
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 19:10:13 +1000 (AEST)
Received: by mail-pz2-x0d.google.com with SMTP id d2e1a72fcca58-85469d249c4so536082b3a.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 02:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789549811; x=1790154611; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xAHkVdVpTvr24jiaynpxp4fC5jaQgg2/IJV+8qSitXA=;
        b=d1NdK/SD+riC9ADWFVM2cRxNXteeEqc7XQBezlO+QQPHA01KTvV6fZZnjIRfq2J/8t
         QZIZHJMgmzxsDWt66RUn5s9UyM/lcyivitqsMbnes5SHSZjkWwtbRjYQSO0zNE1Bshmq
         y7WYv4JWXQ4RbchnU8m3UxkZj7l3bKXR8gshsk7avtDOQp/m5OvbgQrmDYZ34pbvpwWJ
         1xGjlOSonYDkXjbYgSvIup4O5iPPxS7sBI2V9lPPFWy6ChTiK6XH7bJQlWdb5TpGEY2e
         GWuvYsmHkZULa3LN4+9FKS6A2IPpuAtN4Lli6ms+zeSB3PNPHW9rmLcM4ObhKRn0MB9G
         +Kfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789549811; x=1790154611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xAHkVdVpTvr24jiaynpxp4fC5jaQgg2/IJV+8qSitXA=;
        b=bxCAPNwdT+gqJebG5HK9y6B3R2ktXMrZbIuyITxzTdU9krrw1v6JAFjIYdVKUj90Uj
         Y4zL98VazaMH4YNJSloL7N22CCTbJoQU0QTOVF2XVjfgpKn83R6+dyJdH+xXkTOgIfJB
         yI4O+PNf383UfH/3VfdO9UofuTv3x6LQrTrULMaqO6Ax6l2TaafitJ80YsQbS3nCInwS
         mXLVHs8bhXXt2okFamaV4pY6VbgMZ+eRFN1x2vgXzHiUJFvImGIzTb36R/MQK3l2xi+w
         X2aulHsT+XhkWEXntCoeLB2DUpwJJKUhlH+JCvcKpIfyzTecbKJAVae5Z92FiNtByzIo
         lJgQ==
X-Gm-Message-State: AFuF++mpFC6QNcJiXlEHhFyjX4czXqMstvta31BJbgnS9drzwBp6AELg
	1+LJW7tkao09qvhsANFAwOm2AD0qoteviohBsYdmlBzEaqqwWvPRCCHGyPCUbIir6Hs=
X-Gm-Gg: AYBFou1V6VWya2CQURpR3Ko8RToetS3L6eF0LawcFSkEIULEjkA13fiYYwTEG2cKho1
	ZXCdrCxJ8WaaiG93w/Qc6nOFNQADtH8p0/vYvWxtjD5EPRPn9jNTAEdPbKC3vz5EbpdRWSs95Yn
	b2GjYUiwScxVAQ7pIk4T61XiS7MQvdHeXdjfl/eHPO00SzMW3yoFhWRVZxrQHrtofGOU/XtvLvE
	C0cojsOQIttxrb4uhAwHEudn1xqZ6z7JUObnDRIGtVBDTMKtQa+mQttih4Ni7BnX3ENrzV/m1cj
	fhny+P64ztquGCcXLlaYYwD1cUazdsPhc/3xfY3gnrGxry3ju4n68NoczqJ2IaKzw1w7AcL65+7
	xcUGv896HC7dHevQsTyC/vClRAaT3NDg/DMEp1wnFV2WLbt3MsVyBI9ATjgtbva4iq6lWOKtrA4
	ZKU1tcJByOmsQcquPbZptiiInefhQHGimTIhN+5RxKiMvyhrfYJcT9EF7hmxZv3W1a8A8n7MG9I
	Mdrqn9g7KJtCQlxMPluvAdM1D1Kh5a7Op17D2c1cdo7bLiDJV+EZRTctbI=
X-Received: by 2002:a05:6a21:e8a:b0:3d3:b00b:50fc with SMTP id adf61e73a8af0-3dd5f7b3ab7mr4924489637.28.1789549809973;
        Wed, 16 Sep 2026 02:10:09 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50ab50d67sm1215277a12.6.2026.09.16.02.10.08
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 02:10:09 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
X-Google-Original-From: Yifan Zhao <yifan.yfzhao@foxmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH RFC 1/2] erofs-utils: mkfs: add file-delta framework
Date: Wed, 16 Sep 2026 17:10:02 +0800
Message-ID: <3edac55e6ef611e13f595c9c5dcc427e35a1db38.1789545930.git.stopire@gmail.com>
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

Add source operations for reading logical updates and layout operations for
inheriting parent mappings, writing updates and publishing output indexes.
Keep the parent read view separate from the output inode and its superblock.

Implement the Chunk layout backend with independent parent, update and
output granularities.  Split inherited large chunks without copying their
data, retain historical device references and allow parent chunk merging.
Store changed nonzero data in the output primary and zero updates as holes.

Match targets by parent inode, including hard-linked files.
Reject unsupported 48-bit layouts and block ranges.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <yifan.yfzhao@foxmail.com>
---
 include/erofs/internal.h  |   2 +
 lib/Makefile.am           |   4 +-
 lib/blobchunk.c           |  25 +++++
 lib/file_delta.c          | 214 ++++++++++++++++++++++++++++++++++++++
 lib/file_delta_chunk.c    | 203 ++++++++++++++++++++++++++++++++++++
 lib/liberofs_chunk.h      |   2 +
 lib/liberofs_file_delta.h |  81 +++++++++++++++
 lib/rebuild.c             |  34 +++++-
 man/mkfs.erofs.1          |  56 ++++++++++
 mkfs/main.c               | 111 +++++++++++++++++++-
 10 files changed, 725 insertions(+), 7 deletions(-)
 create mode 100644 lib/file_delta.c
 create mode 100644 lib/file_delta_chunk.c
 create mode 100644 lib/liberofs_file_delta.h

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 973bb96..6251a3e 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -94,6 +94,7 @@ struct erofs_xattrmgr;
 struct z_erofs_mgr;
 struct erofs_metamgr;
 struct erofs_chunkmgr;
+struct erofs_file_delta_manager;
 
 struct erofs_sb_info {
 	struct erofs_sb_lz4_info lz4;
@@ -154,6 +155,7 @@ struct erofs_sb_info {
 	struct erofs_xattrmgr *xamgr;
 	struct z_erofs_mgr *zmgr;
 	struct erofs_chunkmgr *chunkmgr;
+	struct erofs_file_delta_manager *file_delta_mgr;
 	struct erofs_metamgr *m2gr, *mxgr;
 	struct erofs_packed_inode *packedinode;
 	struct erofs_buffer_head *bh_sb;
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 0a82915..3d562f4 100644
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
+		      vmdk.c metabox.c global.c importer.c base64.c file_delta.c \
+		      file_delta_chunk.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 8f43dd0..8150fd4 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -161,6 +161,31 @@ static struct erofs_chunkitem *erofs_get_chunk(struct erofs_sb_info *sbi,
 	return chunk;
 }
 
+struct erofs_chunkitem *erofs_blob_write_chunk(struct erofs_sb_info *sbi,
+		const void *buf, erofs_off_t chunksize, int device_id)
+{
+	struct erofs_chunkmgr *cmgr = sbi->chunkmgr;
+	struct erofs_chunkitem *chunk;
+
+	if (!cmgr || !chunksize || chunksize > INT_MAX || device_id < 0)
+		return ERR_PTR(-EINVAL);
+	if (device_id &&
+	    (device_id > sbi->extra_devices ||
+	     !sbi->devs[device_id - 1].bmgr))
+		return ERR_PTR(-EINVAL);
+	if (!device_id && !sbi->bmgr)
+		return ERR_PTR(-EINVAL);
+	chunk = erofs_get_chunk(sbi, device_id, (u8 *)buf, chunksize);
+	if (IS_ERR(chunk))
+		return chunk;
+	if (chunk->blkaddr >= UINT32_MAX ||
+	    BLK_ROUND_UP(sbi, chunksize) > UINT32_MAX - chunk->blkaddr) {
+		erofs_err("file-delta output exceeds the 32-bit block range");
+		return ERR_PTR(-EFBIG);
+	}
+	return chunk;
+}
+
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode)
 {
 	unsigned int unit, src;
diff --git a/lib/file_delta.c b/lib/file_delta.c
new file mode 100644
index 0000000..2d7653d
--- /dev/null
+++ b/lib/file_delta.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#define _GNU_SOURCE
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+#include <config.h>
+#include "erofs/print.h"
+#include "liberofs_file_delta.h"
+
+static void erofs_file_delta_free(struct erofs_file_delta *delta)
+{
+	delta->ops->close(delta);
+	free(delta->target);
+	free(delta->source_path);
+	free(delta);
+}
+
+int erofs_file_delta_parse_spec(struct list_head *deltas, const char *arg,
+		const struct erofs_file_delta_source_ops * const *backends)
+{
+	const struct erofs_file_delta_source_ops *ops;
+	struct erofs_file_delta *delta;
+	const char *first, *second;
+	size_t target_len, namelen;
+	int ret;
+
+	first = strchr(arg, ':');
+	if (!first || first == arg)
+		return -EINVAL;
+	namelen = first - arg;
+	while ((ops = *backends++)) {
+		if (strlen(ops->name) == namelen &&
+		    !memcmp(ops->name, arg, namelen))
+			break;
+	}
+	if (!ops)
+		return -EOPNOTSUPP;
+	second = strchr(first + 1, ':');
+	if (!second || !second[1])
+		return -EINVAL;
+	target_len = second - (first + 1);
+	if (!target_len)
+		return -EINVAL;
+
+	delta = calloc(1, sizeof(*delta));
+	if (!delta)
+		return -ENOMEM;
+	delta->ops = ops;
+	delta->target = strndup(first + 1, target_len);
+	delta->source_path = strdup(second + 1);
+	if (!delta->target || !delta->source_path) {
+		ret = -ENOMEM;
+		goto err_free_delta;
+	}
+	list_add_tail(&delta->list, deltas);
+	return 0;
+
+err_free_delta:
+	erofs_file_delta_free(delta);
+	return ret;
+}
+
+void erofs_file_delta_cleanup(struct list_head *deltas)
+{
+	struct erofs_file_delta *delta, *n;
+
+	list_for_each_entry_safe(delta, n, deltas, list) {
+		list_del(&delta->list);
+		erofs_file_delta_free(delta);
+	}
+}
+
+int erofs_file_delta_manager_init(struct erofs_file_delta_manager *mgr,
+		struct erofs_sb_info *parent, erofs_off_t unit_size)
+{
+	struct erofs_file_delta *delta, *pos;
+	int ret;
+
+	list_for_each_entry(delta, &mgr->deltas, list) {
+		delta->lower_inode = (struct erofs_inode) { .sbi = parent };
+		ret = erofs_ilookup(delta->target, &delta->lower_inode);
+		if (ret) {
+			erofs_err("file-delta TARGET %s cannot be read: %s",
+				  delta->target, erofs_strerror(ret));
+			return ret;
+		}
+		list_for_each_entry(pos, &mgr->deltas, list) {
+			if (pos == delta)
+				break;
+			if (pos->lower_inode.nid == delta->lower_inode.nid) {
+				erofs_err("file-delta TARGET %s refers to the same file as %s",
+					  delta->target, pos->target);
+				return -EEXIST;
+			}
+		}
+		if (!S_ISREG(delta->lower_inode.i_mode)) {
+			erofs_err("file-delta TARGET %s is not a regular file",
+				  delta->target);
+			return -EINVAL;
+		}
+		if (!delta->lower_inode.i_size) {
+			erofs_err("file-delta TARGET %s is empty", delta->target);
+			return -EINVAL;
+		}
+
+		delta->unit_size = unit_size;
+		ret = delta->ops->open(delta, delta->lower_inode.i_size,
+				       unit_size);
+		if (ret) {
+			erofs_err("file-delta %s source %s failed validation: %s",
+				  delta->ops->name, delta->source_path,
+				  erofs_strerror(ret));
+			return ret;
+		}
+	}
+	return 0;
+}
+
+struct erofs_file_delta *erofs_file_delta_lookup_target(
+		struct erofs_file_delta_manager *mgr, const struct erofs_inode *inode)
+{
+	struct erofs_file_delta *delta;
+
+	if (!mgr)
+		return NULL;
+	list_for_each_entry(delta, &mgr->deltas, list)
+		if (delta->lower_inode.sbi == inode->sbi &&
+		    delta->lower_inode.nid == inode->nid)
+			return delta;
+	return NULL;
+}
+
+static int erofs_file_delta_read_update(const struct erofs_file_delta *delta,
+		size_t index, erofs_off_t size, void *buf,
+		struct erofs_file_delta_update *update)
+{
+	u64 unit_index;
+	int ret;
+
+	ret = delta->ops->read(delta, index, &unit_index, buf);
+	if (ret)
+		return ret;
+	if (__builtin_mul_overflow(unit_index, delta->unit_size,
+				   &update->offset) || update->offset >= size)
+		return -EINVAL;
+	update->length = min_t(erofs_off_t, delta->unit_size,
+				 size - update->offset);
+	update->data = buf;
+	return 0;
+}
+
+int erofs_file_delta_apply(struct erofs_file_delta *delta,
+		const struct erofs_file_delta_layout_ops *ops,
+		const struct erofs_inode *parent, struct erofs_inode *inode)
+{
+	struct erofs_file_delta_apply_ctx ctx = {
+		.parent = parent,
+		.inode = inode,
+	};
+	void *buf = NULL;
+	size_t i, nr_changes;
+	int ret;
+
+	DBG_BUGON(parent == inode || parent->i_size != inode->i_size);
+	DBG_BUGON(delta && (delta->applied || !delta->unit_size ||
+			   delta->unit_size > SIZE_MAX));
+
+	nr_changes = delta ? delta->ops->count(delta) : 0;
+	if (nr_changes)
+		ctx.update_unit = delta->unit_size;
+	ret = ops->prepare(&ctx);
+	if (ret)
+		goto out;
+	if (nr_changes) {
+		buf = malloc(delta->unit_size);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+	for (i = 0; i < nr_changes; ++i) {
+		struct erofs_file_delta_update update;
+
+		ret = erofs_file_delta_read_update(delta, i, parent->i_size,
+						  buf, &update);
+		if (ret)
+			goto out;
+		ret = ops->update(&ctx, &update);
+		if (ret)
+			goto out;
+	}
+	ret = ops->finish(&ctx);
+	if (!ret && delta)
+		delta->applied = true;
+out:
+	ops->release(&ctx);
+	free(buf);
+	return ret;
+}
+
+int erofs_file_delta_manager_finish(struct erofs_file_delta_manager *mgr)
+{
+	struct erofs_file_delta *delta;
+
+	if (!mgr)
+		return 0;
+	list_for_each_entry(delta, &mgr->deltas, list) {
+		if (!delta->applied) {
+			erofs_err("file-delta TARGET %s was not applied", delta->target);
+			return -ENOENT;
+		}
+	}
+	return 0;
+}
diff --git a/lib/file_delta_chunk.c b/lib/file_delta_chunk.c
new file mode 100644
index 0000000..d43edb4
--- /dev/null
+++ b/lib/file_delta_chunk.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#include <config.h>
+#include <stdlib.h>
+#include "erofs/print.h"
+#include "liberofs_chunk.h"
+#include "liberofs_file_delta.h"
+
+struct erofs_file_delta_chunk {
+	struct erofs_inode parent_cursor;
+	struct erofs_chunkitem **indexes;
+	size_t count;
+	unsigned int chunkbits;
+};
+
+static struct erofs_chunkitem *erofs_file_delta_chunk_import(
+		struct erofs_file_delta_apply_ctx *ctx, erofs_off_t offset)
+{
+	struct erofs_file_delta_chunk *state = ctx->private;
+	struct erofs_inode *parent = &state->parent_cursor;
+	struct erofs_sb_info *src = parent->sbi, *dst = ctx->inode->sbi;
+	struct erofs_map_blocks map = { .buf = __EROFS_BUF_INITIALIZER };
+	struct erofs_map_dev mdev;
+	struct erofs_device_info *dif;
+	erofs_off_t within, length;
+	erofs_blk_t startblk, nblocks;
+	unsigned int device_id;
+	int ret;
+
+	map.m_la = offset;
+	ret = erofs_map_blocks(parent, &map, 0);
+	if (ret)
+		return ERR_PTR(ret);
+	length = min_t(erofs_off_t, 1ULL << state->chunkbits,
+			parent->i_size - offset);
+	if (offset < map.m_la)
+		return ERR_PTR(-EFSCORRUPTED);
+	within = offset - map.m_la;
+	if (within >= map.m_llen || length > map.m_llen - within)
+		return ERR_PTR(-EFSCORRUPTED);
+	if (!(map.m_flags & EROFS_MAP_MAPPED))
+		return erofs_get_unhashed_chunk(dst, 0, EROFS_NULL_ADDR, 0);
+
+	DBG_BUGON(erofs_blkoff(src, map.m_pa));
+	mdev = (struct erofs_map_dev) {
+		.m_deviceid = map.m_deviceid,
+		.m_pa = map.m_pa,
+	};
+	ret = erofs_map_dev(src, &mdev);
+	if (ret)
+		return ERR_PTR(ret);
+	/* The parent primary device precedes its inherited external devices. */
+	device_id = mdev.m_deviceid + 1;
+	DBG_BUGON(device_id > dst->extra_devices);
+	dif = mdev.m_deviceid ? &src->devs[mdev.m_deviceid - 1] : &src->dif0;
+	startblk = erofs_blknr(src, mdev.m_pa);
+	nblocks = BLK_ROUND_UP(src, map.m_plen);
+	if (startblk >= dif->blocks || nblocks > dif->blocks - startblk) {
+		if (mdev.m_deviceid)
+			erofs_err("%s: parent chunk range exceeds external device %u",
+				  ctx->inode->i_srcpath, mdev.m_deviceid);
+		else
+			erofs_err("%s: parent chunk range exceeds the primary device",
+				  ctx->inode->i_srcpath);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+	/* map describes the parent chunk, which may cover several output chunks. */
+	return erofs_get_unhashed_chunk(dst, device_id,
+				       startblk + erofs_blknr(src, within), 0);
+}
+
+static int erofs_file_delta_chunk_prepare(struct erofs_file_delta_apply_ctx *ctx)
+{
+	const struct erofs_inode *parent = ctx->parent;
+	struct erofs_sb_info *sbi = ctx->inode->sbi;
+	struct erofs_file_delta_chunk *state;
+	unsigned int chunkbits;
+	erofs_off_t chunksize;
+	u64 count;
+	size_t i;
+	int ret;
+
+	DBG_BUGON(parent->datalayout != EROFS_INODE_CHUNK_BASED);
+	if (!(parent->u.chunkformat & EROFS_CHUNK_FORMAT_INDEXES)) {
+		erofs_err("%s: parent file has no explicit chunk indexes",
+			  ctx->inode->i_srcpath);
+		return -EOPNOTSUPP;
+	}
+	if (parent->u.chunkformat & EROFS_CHUNK_FORMAT_48BIT) {
+		erofs_err("%s: file-delta does not support 48-bit chunk indexes",
+			  ctx->inode->i_srcpath);
+		return -EOPNOTSUPP;
+	}
+	DBG_BUGON(parent->sbi->blkszbits != sbi->blkszbits);
+	chunkbits = parent->u.chunkbits;
+	if (ctx->update_unit) {
+		DBG_BUGON(ctx->update_unit & (ctx->update_unit - 1) ||
+			  ctx->update_unit < erofs_blksiz(sbi));
+		chunkbits = min_t(unsigned int, chunkbits, ilog2(ctx->update_unit));
+	}
+	if (chunkbits < sbi->blkszbits ||
+	    chunkbits - sbi->blkszbits > EROFS_CHUNK_FORMAT_BLKBITS_MASK)
+		return -EINVAL;
+	chunksize = 1ULL << chunkbits;
+	count = parent->i_size / chunksize + !!(parent->i_size % chunksize);
+	if (count > INT_MAX / sizeof(struct erofs_inode_chunk_index) ||
+	    count > SIZE_MAX / sizeof(struct erofs_chunkitem *)) {
+		erofs_err("%s: too many chunk indexes", ctx->inode->i_srcpath);
+		return -E2BIG;
+	}
+	state = calloc(1, sizeof(*state));
+	if (!state)
+		return -ENOMEM;
+	ctx->private = state;
+	state->parent_cursor = *parent;
+	state->chunkbits = chunkbits;
+	state->count = count;
+	state->indexes = calloc(count, sizeof(*state->indexes));
+	if (!state->indexes)
+		return -ENOMEM;
+	ret = erofs_blob_init(sbi, 0);
+	if (ret)
+		return ret;
+	for (i = 0; i < state->count; ++i) {
+		struct erofs_chunkitem *chunk;
+
+		chunk = erofs_file_delta_chunk_import(ctx, (erofs_off_t)i << chunkbits);
+		if (IS_ERR(chunk))
+			return PTR_ERR(chunk);
+		state->indexes[i] = chunk;
+	}
+	return 0;
+}
+
+static bool erofs_file_delta_chunk_is_zero(const void *buf, size_t len)
+{
+	const u8 *p = buf;
+
+	while (len--)
+		if (*p++)
+			return false;
+	return true;
+}
+
+static int erofs_file_delta_chunk_update(struct erofs_file_delta_apply_ctx *ctx,
+		const struct erofs_file_delta_update *update)
+{
+	struct erofs_file_delta_chunk *state = ctx->private;
+	struct erofs_sb_info *sbi = ctx->inode->sbi;
+	const erofs_off_t chunksize = 1ULL << state->chunkbits;
+	const u8 *data = update->data;
+	size_t pos, len;
+
+	DBG_BUGON(update->offset & (chunksize - 1) ||
+		  ((update->length & (chunksize - 1)) &&
+		   update->offset + update->length != ctx->inode->i_size));
+	for (pos = 0; pos < update->length; pos += len) {
+		struct erofs_chunkitem *chunk;
+
+		len = min_t(erofs_off_t, chunksize, update->length - pos);
+		if (erofs_file_delta_chunk_is_zero(data + pos, len))
+			chunk = erofs_get_unhashed_chunk(sbi, 0, EROFS_NULL_ADDR, 0);
+		else
+			chunk = erofs_blob_write_chunk(sbi, data + pos, len, 0);
+		if (IS_ERR(chunk))
+			return PTR_ERR(chunk);
+		state->indexes[(update->offset + pos) >> state->chunkbits] = chunk;
+	}
+	return 0;
+}
+
+static int erofs_file_delta_chunk_finish(struct erofs_file_delta_apply_ctx *ctx)
+{
+	struct erofs_file_delta_chunk *state = ctx->private;
+	struct erofs_inode *inode = ctx->inode;
+
+	inode->chunkindexes = state->indexes;
+	inode->extent_isize = state->count * sizeof(struct erofs_inode_chunk_index);
+	inode->datalayout = EROFS_INODE_CHUNK_BASED;
+	inode->u.chunkbits = state->chunkbits;
+	inode->u.chunkformat = EROFS_CHUNK_FORMAT_INDEXES |
+		(state->chunkbits - inode->sbi->blkszbits);
+	state->indexes = NULL;
+	return 0;
+}
+
+static void erofs_file_delta_chunk_release(struct erofs_file_delta_apply_ctx *ctx)
+{
+	struct erofs_file_delta_chunk *state = ctx->private;
+
+	if (!state)
+		return;
+	/* Chunk objects belong to the destination chunk manager. */
+	free(state->indexes);
+	free(state);
+	ctx->private = NULL;
+}
+
+const struct erofs_file_delta_layout_ops erofs_file_delta_chunk_layout_ops = {
+	.prepare = erofs_file_delta_chunk_prepare,
+	.update = erofs_file_delta_chunk_update,
+	.finish = erofs_file_delta_chunk_finish,
+	.release = erofs_file_delta_chunk_release,
+};
diff --git a/lib/liberofs_chunk.h b/lib/liberofs_chunk.h
index 16f3d05..8dfeeb2 100644
--- a/lib/liberofs_chunk.h
+++ b/lib/liberofs_chunk.h
@@ -17,6 +17,8 @@ extern "C"
 struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
 		unsigned int device_id, erofs_blk_t blkaddr,
 		erofs_off_t sourceoffset);
+struct erofs_chunkitem *erofs_blob_write_chunk(struct erofs_sb_info *sbi,
+		const void *buf, erofs_off_t chunksize, int device_id);
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode);
 int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 			      erofs_off_t off);
diff --git a/lib/liberofs_file_delta.h b/lib/liberofs_file_delta.h
new file mode 100644
index 0000000..e03bd6c
--- /dev/null
+++ b/lib/liberofs_file_delta.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_LIB_LIBEROFS_FILE_DELTA_H
+#define __EROFS_LIB_LIBEROFS_FILE_DELTA_H
+
+#include "erofs/internal.h"
+
+struct erofs_file_delta;
+
+struct erofs_file_delta_source_ops {
+	const char *name;
+	int (*open)(struct erofs_file_delta *delta, u64 target_size,
+		    erofs_off_t unit_size);
+	void (*close)(struct erofs_file_delta *delta);
+	/* Updates are ordered by logical unit, without duplicates. */
+	size_t (*count)(const struct erofs_file_delta *delta);
+	/* Read one complete source unit into the caller's buffer. */
+	int (*read)(const struct erofs_file_delta *delta, size_t index,
+		    u64 *unit_index, void *buf);
+};
+
+struct erofs_file_delta {
+	struct list_head list;
+	const struct erofs_file_delta_source_ops *ops;
+	char *target;
+	char *source_path;
+	struct erofs_inode lower_inode;
+	erofs_off_t unit_size;
+	void *private;
+	bool applied;
+};
+
+struct erofs_file_delta_manager {
+	struct list_head deltas;
+};
+
+struct erofs_file_delta_update {
+	erofs_off_t offset;
+	size_t length;
+	/* Borrowed until the layout's update callback returns. */
+	const void *data;
+};
+
+struct erofs_file_delta_apply_ctx {
+	const struct erofs_inode *parent;
+	/* A separate output inode, already bound to the destination sbi. */
+	struct erofs_inode *inode;
+	/* Logical source unit size; zero for inheritance without updates. */
+	erofs_off_t update_unit;
+	void *private;
+};
+
+struct erofs_file_delta_layout_ops {
+	int (*prepare)(struct erofs_file_delta_apply_ctx *ctx);
+	int (*update)(struct erofs_file_delta_apply_ctx *ctx,
+		      const struct erofs_file_delta_update *update);
+	/* Transfer the completed layout to the output inode on success. */
+	int (*finish)(struct erofs_file_delta_apply_ctx *ctx);
+	/* Called after every prepare attempt, including partial failure. */
+	void (*release)(struct erofs_file_delta_apply_ctx *ctx);
+};
+
+extern const struct erofs_file_delta_layout_ops
+	erofs_file_delta_chunk_layout_ops;
+
+int erofs_file_delta_parse_spec(struct list_head *deltas, const char *arg,
+		const struct erofs_file_delta_source_ops * const *backends);
+void erofs_file_delta_cleanup(struct list_head *deltas);
+
+/* Prepare the collected tasks; the caller also cleans up on failure. */
+int erofs_file_delta_manager_init(struct erofs_file_delta_manager *mgr,
+		struct erofs_sb_info *parent, erofs_off_t unit_size);
+int erofs_file_delta_manager_finish(struct erofs_file_delta_manager *mgr);
+
+struct erofs_file_delta *erofs_file_delta_lookup_target(
+		struct erofs_file_delta_manager *mgr, const struct erofs_inode *inode);
+/* A NULL delta inherits the parent mapping without applying updates. */
+int erofs_file_delta_apply(struct erofs_file_delta *delta,
+		const struct erofs_file_delta_layout_ops *ops,
+		const struct erofs_inode *parent, struct erofs_inode *inode);
+
+#endif
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 7d28c1e..9c38204 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -15,6 +15,7 @@
 #include "erofs/internal.h"
 #include "erofs/io.h"
 #include "liberofs_chunk.h"
+#include "liberofs_file_delta.h"
 #include "liberofs_rebuild.h"
 #include "liberofs_uuid.h"
 
@@ -198,7 +199,7 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 			.buf = __EROFS_BUF_INITIALIZER,
 		};
 
-		map.m_la = i << chunkbits;
+		map.m_la = (erofs_off_t)i << chunkbits;
 		ret = erofs_map_blocks(inode, &map, 0);
 		if (ret)
 			goto err;
@@ -233,6 +234,28 @@ static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
 	return erofs_rebuild_load_chunk_index(dst_sb, inode);
 }
 
+static int erofs_rebuild_apply_file_delta(struct erofs_sb_info *dst_sb,
+		struct erofs_inode *inode)
+{
+	const struct erofs_file_delta_layout_ops *ops;
+	struct erofs_file_delta *delta;
+	struct erofs_inode parent = *inode;
+
+	switch (parent.datalayout) {
+	case EROFS_INODE_CHUNK_BASED:
+		ops = &erofs_file_delta_chunk_layout_ops;
+		break;
+	default:
+		erofs_err("%s: unsupported file-delta datalayout %u",
+			  inode->i_srcpath, parent.datalayout);
+		return -EOPNOTSUPP;
+	}
+	delta = erofs_file_delta_lookup_target(dst_sb->file_delta_mgr, &parent);
+	inode->sbi = dst_sb;
+	return erofs_file_delta_apply(delta, ops,
+			delta ? &delta->lower_inode : &parent, inode);
+}
+
 static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 {
 	struct erofs_sb_info *src_sbi = inode->sbi;
@@ -339,9 +362,12 @@ static int erofs_rebuild_update_inode(struct erofs_sb_info *dst_sb,
 			inode->u.i_blkaddr = EROFS_NULL_ADDR;
 			break;
 		}
-		if (datamode == EROFS_REBUILD_DATA_BLOB_INDEX)
-			err = erofs_rebuild_write_blob_index(dst_sb, inode);
-		else if (datamode == EROFS_REBUILD_DATA_RESVSP)
+		if (datamode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+			if (dst_sb->file_delta_mgr)
+				err = erofs_rebuild_apply_file_delta(dst_sb, inode);
+			else
+				err = erofs_rebuild_write_blob_index(dst_sb, inode);
+		} else if (datamode == EROFS_REBUILD_DATA_RESVSP)
 			inode->datasource = EROFS_INODE_DATA_SOURCE_RESVSP;
 		else if (datamode == EROFS_REBUILD_DATA_FULL)
 			err = erofs_rebuild_write_full_data(inode);
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 65ec807..dcac6f0 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -339,6 +339,62 @@ Note that \fBrvsp\fR takes precedence over \fB--tar=i\fR or \fB--tar=headerball\
 Only \fBrvsp\fR is supported.
 .RE
 .TP
+.BI "\-\-file-delta=" FORMAT:TARGET:SOURCE
+Rebuild exactly one parent image while applying a backend-specific delta
+\fISOURCE\fR to \fITARGET\fR.  This option requires
+.BR \-Eforce-chunk-indexes ,
+.BR \-\-chunksize .
+It cannot be used with
+.BR \-\-incremental
+or non-default rebuild data modes, and it cannot be combined with
+.BR \-\-blobdev .
+It also rejects
+.BR \-\-xattr-inode-digest
+and parents carrying inode-digest xattrs because historical image devices are
+not opened to recompute full-file digests.
+
+\fITARGET\fR is resolved from the root of the parent image.  It must name
+a non-empty regular file using \fBCHUNK_BASED\fR layout with
+explicit chunk indexes.
+Updating a hard-linked target updates all links to that inode.
+\fB\-\-chunksize\fR specifies the logical update unit of \fISOURCE\fR;
+the parent may use a different chunk size, including merged larger chunks.
+A target file can be specified only once, even through different path spellings.
+TARGET cannot contain a colon.
+\fIFORMAT\fR determines how \fISOURCE\fR is validated and read.
+
+File-delta currently supports only the non-48-bit format.  Parents and
+chunk indexes using 48-bit features are rejected, as are options enabling
+those features.  The output must fit within the 32-bit block range;
+file-delta does not automatically enable 48-bit support.
+
+Each delta record replaces a logical byte range.  The output uses the smaller
+of the parent chunk size and the source update unit for the entire target
+inode.  Inherited mappings are split as needed without reading or rewriting
+their data.  Files without updates retain their parent chunk size.
+\fB\-Eforce-chunk-indexes\fR selects explicit indexes and allows contiguous
+chunks to be merged when building a parent image.
+Non-zero payload is stored compactly in the output image's primary device;
+identical chunks in this new
+layer can share one physical location.  The output inode inherits every clean
+chunk index from the parent and points changed non-zero chunks to its own
+primary device.  Changed zero chunks become holes and consume no data space.
+
+The parent's primary device becomes external device 1.  Its existing external
+devices are shifted up by one slot, and every inherited chunk device ID is
+incremented accordingly.  Historical images are therefore ordered newest
+first: the direct parent is device 1, its parent is device 2, and so on.  The
+output image depends on all of them.  Each inherited mapping must fit within
+its source device, and the output is limited to 256 external devices.
+\fISOURCE\fR is build input only and is not referenced by the output image.
+
+The filesystem block size is derived from the parent, so sub-4096-byte
+parent and delta chunk geometries do not require a redundant \fB-b\fR option.
+
+The source specification is the remainder after the second colon, so it may
+itself contain colons.  Repeated file-delta options must refer to distinct target
+files.  A source may be reused when the selected backend permits it.
+.TP
 .BI "\-\-max-extent-bytes=" #
 Specify maximum decompressed extent size in bytes. The default is unlimited.
 .TP
diff --git a/mkfs/main.c b/mkfs/main.c
index f0d3d8c..7598f0a 100644
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
@@ -328,6 +331,12 @@ static enum {
 
 static unsigned int rebuild_src_count;
 static LIST_HEAD(rebuild_src_list);
+static struct erofs_file_delta_manager file_delta_mgr = {
+	.deltas = LIST_HEAD_INIT(file_delta_mgr.deltas),
+};
+static const struct erofs_file_delta_source_ops * const file_delta_backends[] = {
+	NULL,
+};
 static u8 fixeduuid[16];
 static bool valid_fixeduuid;
 static unsigned int dsunit;
@@ -1497,6 +1506,15 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return err;
 			}
 			break;
+		case 540:
+			err = erofs_file_delta_parse_spec(&file_delta_mgr.deltas, optarg,
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
@@ -1552,6 +1570,26 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			return err;
 	}
 
+	if (!list_empty(&file_delta_mgr.deltas)) {
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
@@ -1567,7 +1605,8 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 		params->pclusterblks_max = pclustersize_max >> mkfs_blkszbits;
 		params->pclusterblks_def = params->pclusterblks_max;
 	}
-	if (mkfscfg.chunkbits && mkfscfg.chunkbits < mkfs_blkszbits) {
+	if (list_empty(&file_delta_mgr.deltas) && mkfscfg.chunkbits &&
+	    mkfscfg.chunkbits < mkfs_blkszbits) {
 		erofs_err("chunksize %u must be larger than block size",
 			  1u << mkfscfg.chunkbits);
 		return -EINVAL;
@@ -1683,6 +1722,39 @@ static int erofs_mkfs_rebuild_load_trees(struct erofs_inode *root)
 		return -EINVAL;
 	}
 
+	if (!list_empty(&file_delta_mgr.deltas)) {
+		unsigned int output_devices;
+
+		src = list_first_entry(&rebuild_src_list,
+				       struct erofs_sb_info, list);
+		DBG_BUGON(datamode != EROFS_REBUILD_DATA_BLOB_INDEX ||
+			  rebuild_src_count != 1);
+
+		output_devices = src->extra_devices + 1;
+		ret = erofs_mkfs_init_devices(&g_sbi, output_devices);
+		if (ret)
+			return ret;
+		g_sbi.devs[0].blocks = src->dif0.blocks;
+		erofs_uuid_unparse_as_tag(src->uuid,
+					  (char *)g_sbi.devs[0].tag);
+		for (idx = 0; idx < src->extra_devices; ++idx) {
+			g_sbi.devs[idx + 1].blocks = src->devs[idx].blocks;
+			memcpy(g_sbi.devs[idx + 1].tag, src->devs[idx].tag,
+			       sizeof(g_sbi.devs[idx + 1].tag));
+		}
+		ret = erofs_file_delta_manager_init(&file_delta_mgr, src,
+						    1ULL << mkfscfg.chunkbits);
+		if (ret)
+			return ret;
+		root->sbi->file_delta_mgr = &file_delta_mgr;
+		src->xamgr = g_sbi.xamgr;
+		ret = erofs_rebuild_load_tree(root, src, datamode);
+		src->xamgr = NULL;
+		if (ret)
+			return ret;
+		return erofs_file_delta_manager_finish(&file_delta_mgr);
+	}
+
 	list_for_each_entry(src, &rebuild_src_list, list) {
 		src->xamgr = g_sbi.xamgr;
 		ret = erofs_rebuild_load_tree(root, src, datamode);
@@ -1856,6 +1928,31 @@ int main(int argc, char **argv)
 			goto exit;
 		}
 		mkfs_blkszbits = src->blkszbits;
+		if (!list_empty(&file_delta_mgr.deltas)) {
+			if (erofs_sb_has_ishare_xattrs(src)) {
+				erofs_err("file-delta parent uses inode digest xattrs");
+				err = -EOPNOTSUPP;
+				goto exit;
+			}
+			if (mkfscfg.chunkbits < mkfs_blkszbits) {
+				erofs_err("chunksize %u must be at least parent block size %u",
+					  1U << mkfscfg.chunkbits,
+					  1U << mkfs_blkszbits);
+				err = -EINVAL;
+				goto exit;
+			}
+			if (erofs_sb_has_48bit(src)) {
+				erofs_err("file-delta does not support 48-bit parents");
+				err = -EOPNOTSUPP;
+				goto exit;
+			}
+			if (src->extra_devices >= EROFS_MAX_BLOB_DEVS) {
+				erofs_err("file-delta supports at most %u external devices",
+					  EROFS_MAX_BLOB_DEVS);
+				err = -E2BIG;
+				goto exit;
+			}
+		}
 	} else if (mkfs_oci_tarindex_mode) {
 		mkfs_blkszbits = 9;
 		tar_index_512b = true;
@@ -1942,7 +2039,8 @@ int main(int argc, char **argv)
 		importer_params.ddev_id_def = mkfscfg.blobdev_path ? 1 : 0;
 	}
 
-	if (tar_index_512b || mkfscfg.chunkbits) {
+	if ((tar_index_512b || mkfscfg.chunkbits) &&
+	    list_empty(&file_delta_mgr.deltas)) {
 		err = erofs_blob_init(&g_sbi, mkfscfg.chunkbits);
 		if (err)
 			goto exit;
@@ -2059,6 +2157,13 @@ int main(int argc, char **argv)
 	erofs_iput(root);
 	root = NULL;
 
+	if (g_sbi.file_delta_mgr &&
+	    (erofs_sb_has_48bit(&g_sbi) || g_sbi.dif0.blocks > UINT32_MAX)) {
+		erofs_err("file-delta output requires 48-bit support");
+		err = -EFBIG;
+		goto exit;
+	}
+
 	err = erofs_writesb(&g_sbi);
 	if (err)
 		goto exit;
@@ -2077,6 +2182,8 @@ int main(int argc, char **argv)
 exit:
 	if (root)
 		erofs_iput(root);
+	g_sbi.file_delta_mgr = NULL;
+	erofs_file_delta_cleanup(&file_delta_mgr.deltas);
 	z_erofs_dedupe_exit();
 	blklst = erofs_blocklist_close();
 	if (blklst)
-- 
2.55.0


