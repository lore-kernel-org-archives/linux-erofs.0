Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15FC606A31E
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2026 04:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=XbB/tXqw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbKYg6SGsz2y2h;
	Fri, 27 Nov 2026 15:04:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::330"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795752279;
	cv=none; b=idwyFiGnmtl6FMbRX1m7/5aqFyk3FsauQcCCMMJJVA4KemqxSEWTOi/3EUeaRIa4eGTDp7DYshYsnPczWm7pOB4eF++c+n2JlC4RF+1jeKvcf7GAzGzcIEGq4k5Tu1QHPysaIrLdFvHYYjLgBy8LhzcFndqZv9dHHf3Di0aoinztXGnwRt8usFRyD9VrnlHBvFrjozzGo/5UnmLjfO8Ar7fmiGGPdAaiS+od0I6BaoJNkUurvxrMGOCMh2D8QhhG2czxEeRyBxJKiJMncL7+PyK+2VzkoG0SYhzTwYkutCwyRl7F4h73F1fCiObZmAgSIs+Eb5oQmz5/h1glcPdQmA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795752279; c=relaxed/relaxed;
	bh=qJazdTLT7k1Ag/5mlWbC+zySB8AKp2ciT5By/Fr7p1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9IYUKvpa04eOP2hwzlc8oG2+jbf51mLWqWnXqnCaiBQmht4TmfSK10qfSJdhbwDXwCmRpeT4QyRDuoTX/pdsXZ7T3UwCp6Jg5D7I5lFGglacvTAUy5fTMHin3pGGnTgrl+S6HQ/9YPvj0/JTdRWje8lVDhQ3KpebPQZuEJkn7DAdTxlSR6EVoUkxxDShZvcLYoal8OU59P4B159AxSVdCNz2x4uNYlMwXwKKuw+bQ9LmuzPhlLLlAnEg/ITNKt5/fg2WBMRztJsmqbtEJjTiY0hZKJ5RfED3zDJA6dx60FbAIdcgEm93q5GEmWT31sGODG0g5PpV/hKHCMrDpf63g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=XbB/tXqw; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=XbB/tXqw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbKYf169tz2xLg
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 15:04:37 +1100 (AEDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso75253945e9.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 20:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795752273; x=1796357073; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qJazdTLT7k1Ag/5mlWbC+zySB8AKp2ciT5By/Fr7p1o=;
        b=XbB/tXqwAEh5Lf6lzq8/fQ89RCsVeBA3+arYixjl4vhaxg9w4TJDT3OAG2yFWt6qP8
         9RRC0IqOm3an8n9zcV9mA1ZmLn+MBH/xMd8nwFnWNjxJdtUXh6g74SoCqjftRlidXgC3
         z4BNIxDlWufwkJ0TMsui8JH4YzLZuD6Dh40icbtfREcmGxeU33MELKjUPm+ZuUUGzReY
         nSEAkEc29Cmk5I+gq3/XxO4qf9OGHlcOg2D2xNET3fYZp+XMFFmBk9Od/YukT4Durd6x
         vbdpdN+wB2pHP03un/+7osLTAdmQm+rS033cyME+/JziHtkI7NepmYUZOfHJHz2IfbA1
         mcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752273; x=1796357073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qJazdTLT7k1Ag/5mlWbC+zySB8AKp2ciT5By/Fr7p1o=;
        b=QOn9PkUfkNMbBjkury8d3uNBNt7bfVCUZoYvhN4IPTPT9g3bt5yXoB0Kr7dOfAbKHM
         jA23AAXk/7Ob1zU7Qerkjo2f2ofcbEqke9H9b8rt60pQb+69zMJU2sVWqC8s2e0SP61M
         s/mbgZKQqy9FHK1G74RRrIrhynvjftVj0ZPqsfElqxOsbCX7+kd4to4H20ByHdfohvG7
         WY30KtrhLh4zNL7JAmYgEtVH7z40UhZm5UMt492meGSUcfXZSTKna6TPgruvmpRYHzXY
         6wL+pwiYcEuOdZWHaahiUYyBb5A5n7kcUQzvtIPCz1K/HSsBWban8BUf2Q6VcjQoEEzr
         1x+Q==
X-Gm-Message-State: APuU4Z+AgTn4Y/1WtyZ0/c3ZIt1vJ7TeoO04kLH5/daVGAkXujUBJoV4
	nPYnvvIRGLL/Xs3BAAiY1OCN0/hdln5GzhcmPR2fzUuwXp+Tuz+/AFY/Xptnch9PAaewxAL0DAB
	dv+L6J/I=
X-Gm-Gg: AZFdTZdbw02aUgRphk92P71qVw/gG/sUY4+/f/kpPtTVpoJv/rImtsUT7WuWjigxZd2
	ww72PFDjqd/lahkV0ce9tjAJdrEe8VMolRK6zf8MLEmyACrT3mah5SZSJHwlnYCOcja0IXKTGFq
	Nzd2pU46Ve2E7eEg6x5ds20T1U+C8ctBxClyTxppwlUbgkpCFqcDx7Q+GBHyCYljfYAi3V6Yb0o
	NTqdFoIrvxl07/ZTLJY4q01h4D/wZub/RWf9Q+4EMos73pCy1KQe/XrEgeEFNbozwZHSvxq2DYi
	LPGwWRDtLvJIgbdSPLZ0Za5V6hLqqteAB6m9d735NdkbKa5IcPIVLuTOEiinfedeaMEkZ0C7849
	FT7VeZYdSSVJzC3nJFQh0DekN6hikgN86YESfZjqdDUP0f6EL7bslCflSFglyjvdefPqv1dCiGZ
	HP/4jkgCzHxdac1AKuon+Y8PxUiXs/MSD1a5zTIa0ZNgm00JXWJG7K3HhCIFpDn8xaI/CIf0hcJ
	ZFNkW6+kXO2hTQKkxzcy2DgcaiYHK8aGv0j/1N//Fhbz70MnTF1V9HeTr+P8ysufFh95+NoPpPJ
	VH5LzLPbSWVeNhKk+84b1T/YS/f/Pf3H/Vs76x7FKIAdyFkUOQV9tWZ+rRb6S61CVi7I
X-Received: by 2002:a05:600c:5303:b0:4ba:4928:8aec with SMTP id 5b1f17b1804b1-4bb88807d7cmr433686425e9.9.1795752273346;
        Thu, 26 Nov 2026 20:04:33 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5cef:65d5:b333:e710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm388721725e9.2.2026.11.26.20.04.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 20:04:33 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v4 08/10] erofs-utils: lib: add file-delta alignment callback
Date: Fri, 27 Nov 2026 05:04:25 +0100
Message-ID: <20261127040427.99710-2-xiang.gao@docker.com>
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

In order to select chunk sizes for file-delta updates, add a
get_alignment callback reporting the greatest power-of-two alignment
shared by replacement boundaries.

Accumulate these boundaries when adding dm-snapshot exceptions and
keep the exception array and counters in the snapshot handle.

Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/deltas/dm_persistent.c | 58 ++++++++++++++++++++++----------------
 lib/liberofs_file_delta.h  | 10 ++++++-
 2 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/lib/deltas/dm_persistent.c b/lib/deltas/dm_persistent.c
index 9e4c5c7..21f4f0d 100644
--- a/lib/deltas/dm_persistent.c
+++ b/lib/deltas/dm_persistent.c
@@ -24,17 +24,15 @@ struct erofs_dm_exception {
 	erofs_off_t offset, source_offset;
 };
 
-/* Sorted by logical file offset after opening the snapshot. */
-struct erofs_dm_exceptions {
-	struct erofs_dm_exception *entries;
-	size_t count, capacity;
-};
-
 struct erofs_dm_snap_persistent {
 	struct erofs_file_delta fdl;
-	struct erofs_dm_exceptions exceptions;
+	struct {
+		/* Sorted by logical file offset after opening the snapshot. */
+		struct erofs_dm_exception *entries;
+		size_t count, capacity;
+	} exceptions;
 	struct erofs_vfile *vf;
-	erofs_off_t target_size, chunk_bytes;
+	erofs_off_t target_size, chunk_bytes, boundary;
 };
 
 static const struct erofs_file_delta_ops erofs_file_delta_dm_persistent_ops;
@@ -46,35 +44,35 @@ static int erofs_dm_exception_cmp(const void *a, const void *b)
 	return cmpsgn(ea->offset, eb->offset);
 }
 
-static int erofs_dm_add_exception(struct erofs_dm_exceptions *exceptions,
+static int erofs_dm_add_exception(struct erofs_dm_snap_persistent *dsp,
 				 erofs_off_t offset,
 				 erofs_off_t source_offset)
 {
 	struct erofs_dm_exception *p;
 	size_t capacity;
 
-	if (exceptions->count == exceptions->capacity) {
-		capacity = exceptions->capacity ? exceptions->capacity * 2 : 64;
-		if (capacity < exceptions->capacity)
+	if (dsp->exceptions.count == dsp->exceptions.capacity) {
+		capacity = dsp->exceptions.capacity ? dsp->exceptions.capacity * 2 : 64;
+		if (capacity < dsp->exceptions.capacity)
 			return -E2BIG;
 		if (capacity > SIZE_MAX / sizeof(*p))
 			return -E2BIG;
-		p = realloc(exceptions->entries, capacity * sizeof(*p));
+		p = realloc(dsp->exceptions.entries, capacity * sizeof(*p));
 		if (!p)
 			return -ENOMEM;
-		exceptions->entries = p;
-		exceptions->capacity = capacity;
+		dsp->exceptions.entries = p;
+		dsp->exceptions.capacity = capacity;
 	}
-	exceptions->entries[exceptions->count++] = (struct erofs_dm_exception) {
+	dsp->exceptions.entries[dsp->exceptions.count++] = (struct erofs_dm_exception) {
 		.offset = offset,
 		.source_offset = source_offset,
 	};
+	dsp->boundary |= offset | (offset + dsp->chunk_bytes);
 	return 0;
 }
 
 static int erofs_dm_parse_exceptions(struct erofs_dm_snap_persistent *dsp)
 {
-	struct erofs_dm_exceptions *exceptions = &dsp->exceptions;
 	erofs_off_t chunk_bytes = dsp->chunk_bytes;
 	/* Read metadata in bounded batches, independently of the dm chunk size. */
 	struct erofs_dm_disk_exception buf[256];
@@ -121,8 +119,8 @@ static int erofs_dm_parse_exceptions(struct erofs_dm_snap_persistent *dsp)
 					goto out;
 				}
 				source_offset = new_chunk * chunk_bytes;
-				ret = erofs_dm_add_exception(exceptions,
-							     offset, source_offset);
+				ret = erofs_dm_add_exception(dsp, offset,
+							     source_offset);
 				if (ret)
 					goto out;
 			}
@@ -134,16 +132,16 @@ static int erofs_dm_parse_exceptions(struct erofs_dm_snap_persistent *dsp)
 	}
 terminated:
 	/* Exceptions are stored in commit order, not logical file order. */
-	if (exceptions->count > 1)
-		qsort(exceptions->entries, exceptions->count,
-		      sizeof(*exceptions->entries), erofs_dm_exception_cmp);
+	if (dsp->exceptions.count > 1)
+		qsort(dsp->exceptions.entries, dsp->exceptions.count,
+		      sizeof(*dsp->exceptions.entries), erofs_dm_exception_cmp);
 	/*
 	 * The kernel reuses existing exceptions on repeated writes, but its
 	 * loader does not reject duplicate origin chunks.  Reject them here
 	 * rather than choosing an ambiguous mapping.
 	 */
-	for (n = 1; n < exceptions->count; ++n) {
-		if (exceptions->entries[n - 1].offset == exceptions->entries[n].offset)
+	for (n = 1; n < dsp->exceptions.count; ++n) {
+		if (dsp->exceptions.entries[n - 1].offset == dsp->exceptions.entries[n].offset)
 			return -EINVAL;
 	}
 	ret = 0;
@@ -151,6 +149,17 @@ out:
 	return ret;
 }
 
+static erofs_off_t erofs_dm_persistent_get_alignment(struct erofs_file_delta *fdl)
+{
+	struct erofs_dm_snap_persistent *dsp =
+		container_of(fdl, struct erofs_dm_snap_persistent, fdl);
+	erofs_off_t boundary = dsp->boundary;
+
+	if (!dsp->exceptions.count)
+		return 0;
+	return boundary ? (boundary & -boundary) : BIT_ULL(63);
+}
+
 static int erofs_dm_persistent_map(struct erofs_file_delta *fdl,
 				   struct erofs_delta_map *map)
 {
@@ -233,6 +242,7 @@ struct erofs_file_delta *erofs_dm_persistent_open(struct erofs_vfile *vf)
 }
 
 static const struct erofs_file_delta_ops erofs_file_delta_dm_persistent_ops = {
+	.get_alignment = erofs_dm_persistent_get_alignment,
 	.map = erofs_dm_persistent_map,
 	.close = erofs_dm_persistent_close,
 	.name = "dm-persistent",
diff --git a/lib/liberofs_file_delta.h b/lib/liberofs_file_delta.h
index 6112a1c..ab6d54c 100644
--- a/lib/liberofs_file_delta.h
+++ b/lib/liberofs_file_delta.h
@@ -15,7 +15,15 @@ struct erofs_delta_map {
 struct erofs_file_delta;
 
 struct erofs_file_delta_ops {
-	/* Find a replacement at or after map->offset; length 0 means none. */
+	/*
+	 * Maximum power-of-two boundary alignment in bytes; 0 means no updates.
+	 * EOF need not be aligned. BIT_ULL(63) means no boundary constraint.
+	 */
+	erofs_off_t (*get_alignment)(struct erofs_file_delta *fdl);
+	/*
+	 * Find a replacement at or after map->offset; length 0 means none.
+	 * Mappings remain stable until close; callers may scan them again.
+	 */
 	int (*map)(struct erofs_file_delta *fdl, struct erofs_delta_map *map);
 	void (*close)(struct erofs_file_delta *fdl);
 	const char *name;		/* delta format name */
-- 
2.54.0 (Apple Git-157)


