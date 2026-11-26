Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8913606A31E
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H1OntcLt
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCg0LwPz2yLY;
	Thu, 26 Nov 2026 23:02:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::433"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694559;
	cv=none; b=H8NrNIPSAHFEtv3QocBAcw2N5Pnga2FhyJlWr/EKimCBlfMtlnz9PsENXOupTbW6n+YwltgFBq41rXWYk42FDDDLjtPFW0zLhDdrpBinvDm/8wHrKMoYjlXZlb1n7YSxzuEBWaH+VBSJVE743poGECCWxUO5NBfumOMLVGAT5Ch+6l/hgp3bQ6If0WYYExDk97LUDZ4ZSHu7i8guuBskv8Vdn7DCxRR4FCVWcOheMZcXDIVFuTWrKJPbtIOwgQHLrdXZA2pefO3HC/ohOkan/IF1SNniVH5gAs9DDaDdSBU08MLSFcRMh/fsObvLjJzuq0U2COcLN0sLmdHDN42caA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694559; c=relaxed/relaxed;
	bh=zxhG9bkNBCJCYfo3ctL4MkzaNA8rCd27AtnqQGg/eDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cT030mxTUz04VLfeq0K1wcHzRv8xGBjw/uBAsxUrv3n9DiDLp+sDLATeSdaB0KStpxxjU0BN5ed1qsjyo7eT3b2yPjqTrthFrHQ48ZX4vk5N88EjEPg5RF8QUAyz4kXIazXFol1Lo97Q7tiysX6CD9nnbey5E/IGG6C0mC2d+vllF8exowAZpODWYTHgVColvGUOEamjUuilgg1598Mm3upLNTS0oTO9kt57I7IEr11kw3Z9DwipBviQCcBKBHDzg+ooy+E/hTn0LNcSMOcyBvH2i1Lj7jnrdstBKy83qnoc+/qPFXFOzGQzvi6K3EebqDTGjTSetyojZefRzLFvhw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H1OntcLt; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::433; helo=mail-wr1-x433.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H1OntcLt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::433; helo=mail-wr1-x433.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCf0vR7z2yR1
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:38 +1100 (AEDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-4a5024b3c28so4565878f8f.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694555; x=1796299355; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zxhG9bkNBCJCYfo3ctL4MkzaNA8rCd27AtnqQGg/eDo=;
        b=H1OntcLtq/MKgJJGVVQOgP/o2HQInC0UtZizSoyBZJ/4beF4wgerVZVLFyNKuULbdI
         tF0DHa3GNcTLqfpP7B/wfoh86SzLAfjrZHDLGrJzNTpTYq2xmwVEZyX2nJTjG0xuLNl1
         gq2Bk5e7DURN0nLvy+DeWvmHs5aIrYaMQp1FpWEWldQ+gRG+BUBfbvG1X+1S1MdjM6CO
         jqgbJnJ9yBRFghYTnnYkdSstKfyluJKar3lVcNqe/SALCdgfOnc82ed7IMgMoav95b3t
         S/WbKkOwA0KCsPs+2jnTAC+tyskpin0Er+ziiWGdva+Qdw1+CmN8PJ6GvMRV0Hl6s0to
         lDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694555; x=1796299355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zxhG9bkNBCJCYfo3ctL4MkzaNA8rCd27AtnqQGg/eDo=;
        b=GWUiV4GXnTNzfTGcltdZyFmkgKfD4Dk/2QVHpotZljaoBu/Mu2eDfDF5V/Qlrba7gY
         HJyY+NndMhUHldzQfhWZt/gyBmhH8YVs7HWOxkA6nd+yBO9GlUPTA6wgRkCGQ2l7eVzV
         ObdjP3ailnUhWIJlMF29030QgYfv3DDQRK5V4A+fRLVXGSJjbmXpH80EHOf9hMn+5fBj
         qQB1pdxfyyd3w0vR3SGAX/u6VKukgXut31RmfALsV3x4JoCLUVFzf9a0bHJYqxhBzMda
         WMIaT1K0Sb3gyN3+5vIJ7NSL7uoxKDlk/wtfImhm+/vgthbGmuT5LP1mI47CVDu+yygT
         GEJQ==
X-Gm-Message-State: APuU4Z+cX5h4V9jTEBntRAUvdCO5pRVVyCu6LP62WWscNdfYAaMcKvMd
	ydomIXqMHLJeOw3+cOR7hJ4+q+QgytuBTKcacfJwx++ScEwz+kkQ9NZoq/ws3riSKi1sJDh99bx
	6ZFz+4q4=
X-Gm-Gg: AZFdTZcQdzYwgw0KuxwHE/oO+blIOA2UKWD+Q4LTgQ5XXjC7pDf/m2/9V3+jAcADLbD
	Y//Oati0SjJtwkGHI2ufCr5WKQycNsc9dks8sdKGfEgBjvoERzpZ+JGxWRtxs4vvyxWsVEGRVYR
	aNVg1AU32P6lgQEr1ThPYfT+36Fw6UZtkRETfFcP0nssVRArWWTTdFQuYTwmn/M9LSgoIHX9FRs
	TBsOyKhhFWdtC5X0Vv1YV2BviuiQ8onNc+Unr+hoCLADAolTnjCcfBoeiE79rBbgeQnui7XpTqd
	CBVQrmRU8rEAwgiAXgq1JEWANoSZVFIOV+rTsrW5yWClu9dhs6jSk8ihH8B/sTCltRS8y89/yw4
	MKKUCZlOplOXNgTogrgyBXpMWUttmahFK8gE4fWg/mD9dM0M2tTHilOTjrMtYexPAP+l6y6vxrd
	Ik1aQ/qKkyTXX8vHN+iQkX1FwFUA09TSDBSt5lXauRFTxcg9wjqWf2H4hipT3wHPK5OfiNgf52P
	xgRZ/CbDngcamwp/pX9eWo9WzHE4rQsuyjzW9pzvE3QiMho7OFq/IsD1mtfXQn7SJsiChtuAdV5
	MxJirWm/niFBD7us1PVuMyWZ08d17mPfBDgGOIgmlr6lE3XCxq8lQIBHWxihNT+y6LiD
X-Received: by 2002:a05:600c:a085:b0:4bb:85d9:156e with SMTP id 5b1f17b1804b1-4bb8880fe46mr413723155e9.11.1795694554769;
        Thu, 26 Nov 2026 04:02:34 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:34 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 08/10] erofs-utils: lib: add file-delta alignment callback
Date: Thu, 26 Nov 2026 13:02:19 +0100
Message-ID: <20261126120221.4384-8-xiang.gao@docker.com>
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
index 17fb0d5..307086e 100644
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


