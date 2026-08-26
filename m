Return-Path: <linux-erofs+bounces-4350-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9115CC5DF97
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 13:44:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVQqX6Ybwz2y8F;
	Wed, 26 Aug 2026 23:44:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787751864;
	cv=none; b=R+L04bcAydN+pNk6grfvseCuyDANCghAGpzIUdvkZMZ2QswQP4CXyvc/9GphAhOtWfzMPIsMfhn94zrfqtfj6D4UbcDFqK6JXTcyOHDjWbdSuqUbxoj7gb7e+Jm0rP20ZHK3vOjXyZTTsGvs9iEeus0QdlToiLy0IORF6uZmsYTYCauwzukz/Vrjvi6J1wIo8CMfzaa7THVPBJW0mjFvUQLnlIqYcY5yx18ErVQhTCbfq1vwkNkJqGyYQtlfrXzVNSK5Ft4aKzyMROBIgPCzOTm0o/A67glJEZ1h1mMDEduDuYt/buoOMAH7hfNxfgUj60qJAivNgO7BIxhHjA+G4A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787751864; c=relaxed/relaxed;
	bh=bpgRjUFWbeiBaB/hl9FBmnMbF3/nhhhz7NbvY+HEacc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyq9Pr0k4d+fwk4Gd5VaGHxD3bP5mPIRj2yC9Wbmx2UqBVDV6Eonsl70GQl6odsC3PzJnndXSnW/4JoaEFNW1reARTMxxa3dAXrTNHzA3w40EvXhv2aa/3JVYhuMoi1T+CmHjvnRufIsZNZnc6wpDsfSQvu1hEBb9+bCWE6XUgI8xpktd36moVkf0pv7AS8TyAH1vlLT9OAklIs0nF336+VVf/lO06kW/Ssup4rGoA6JrZ5T7rFnEoBAtHssgU2DeUsetgq9xdd33/1oBIraXCnav0XPg1qkJWaOUoJQxAnryfSyKaYOwilQzmkFdVojepDgjWpiw52ZemKRu33tfQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oSTZPE3Q; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oSTZPE3Q;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVQqV0pgQz2xLG
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 23:44:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 328FC437C5;
	Wed, 26 Aug 2026 13:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF34F1F000E9;
	Wed, 26 Aug 2026 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787751858;
	bh=bpgRjUFWbeiBaB/hl9FBmnMbF3/nhhhz7NbvY+HEacc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSTZPE3QrEGlD82bxcNXBzHyVpiqv6EhnvHTJSlEu0Y6cDIGYVH0dP+uoOUXh1kAw
	 1H0o3MXDZ9QsGwLyhuEODG+xSeBPfIJQfE9WSfa0egjdRmyeBmFT3+atxCaaEwciWH
	 KL71yNF2iSjkSbEcsRPCSNp1L/FXpJ4JXcqyize7vthddJRHzCHfzCYAIcQUV8yORT
	 /LqzaOqb7l45kmrth/G7gaoBOUM3XAUP/0/lvED8I9PnNsDaYQyr6I8Xp1EEolh2o+
	 vXyv0nLvDDCXnkjtrMCbC1LWpvwFLGx5+9GpmMjlcuO4fNBM6BQ/KmQ677pyMZ+N1g
	 GlpGOqllHB8EQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Daniel Colascione <dancol@dancol.org>,
	Friendy Su <friendy.su@sony.com>
Subject: [PATCH 3/4] erofs-utils: lib: refactor unencoded chunk handling
Date: Wed, 26 Aug 2026 21:43:19 +0800
Message-ID: <20260826134321.11835-3-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826134321.11835-1-xiang@kernel.org>
References: <20260826134321.11835-1-xiang@kernel.org>
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

Switch global variables to per-sb and/or per-device structures, replace
the hashmap with a bucket-list hash table, and replace open-coded blobfile
raw I/O with the buffer allocator and vfile I/O so that blob chunks won't
rely on temporary files on /tmp [1].

Future follow-ups: Optimize to the PLAIN/INLINE inode layout if no valid
deduplication chunk is found.

[ Gao Xiang: need to check if `--dsunit` works as expected in this new
             implementation. ]
Reported-by: Daniel Colascione <dancol@dancol.org>
Closes: https://github.com/erofs/erofs-utils/issues/35  [1]
Cc: Friendy Su <friendy.su@sony.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/blobchunk.h |  11 +-
 include/erofs/internal.h  |   5 +-
 lib/blobchunk.c           | 422 ++++++++++++++++++++------------------
 lib/rebuild.c             |   4 +-
 lib/super.c               |  12 +-
 mkfs/main.c               |  27 ++-
 6 files changed, 262 insertions(+), 219 deletions(-)

diff --git a/include/erofs/blobchunk.h b/include/erofs/blobchunk.h
index 1761fdd..1c8d77d 100644
--- a/include/erofs/blobchunk.h
+++ b/include/erofs/blobchunk.h
@@ -14,8 +14,9 @@ extern "C"
 
 #include "erofs/internal.h"
 
-struct erofs_blobchunk *erofs_get_unhashed_chunk(unsigned int device_id,
-		erofs_blk_t blkaddr, erofs_off_t sourceoffset);
+struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
+		unsigned int device_id, erofs_blk_t blkaddr,
+		erofs_off_t sourceoffset);
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode);
 int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 			      erofs_off_t off);
@@ -24,8 +25,10 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 int erofs_write_zero_inode(struct erofs_inode *inode);
 int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset);
 int erofs_mkfs_dump_blobs(struct erofs_sb_info *sbi);
-void erofs_blob_exit(void);
-int erofs_blob_init(const char *blobfile_path, erofs_off_t chunksize);
+int erofs_blob_exit(struct erofs_sb_info *sbi);
+int erofs_blob_init(struct erofs_sb_info *sbi, int blobdev_id,
+		    unsigned int chunkbits_def);
+int erofs_blob_init_device(struct erofs_sb_info *sbi, int device_id);
 
 #ifdef __cplusplus
 }
diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 30dae41..95f5627 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -67,8 +67,9 @@ struct erofs_buffer_head;
 struct erofs_bufmgr;
 
 struct erofs_device_info {
-	char *src_path;
 	u8 tag[64];
+	char *src_path;
+	struct erofs_bufmgr *bmgr;
 	erofs_blk_t blocks;
 	erofs_blk_t uniaddr;
 };
@@ -90,6 +91,7 @@ struct erofs_packed_inode;
 struct erofs_xattrmgr;
 struct z_erofs_mgr;
 struct erofs_metamgr;
+struct erofs_chunkmgr;
 
 struct erofs_sb_info {
 	struct erofs_sb_lz4_info lz4;
@@ -151,6 +153,7 @@ struct erofs_sb_info {
 	struct erofs_bufmgr *bmgr;
 	struct erofs_xattrmgr *xamgr;
 	struct z_erofs_mgr *zmgr;
+	struct erofs_chunkmgr *chunkmgr;
 	struct erofs_metamgr *m2gr, *mxgr;
 	struct erofs_packed_inode *packedinode;
 	struct erofs_buffer_head *bh_sb;
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 0523873..d307a4f 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2021, Alibaba Cloud
  */
 #define _GNU_SOURCE
-#include "erofs/hashmap.h"
+#include "erofs/print.h"
 #include "erofs/blobchunk.h"
 #include "erofs/block_list.h"
 #include "erofs/importer.h"
@@ -14,63 +14,98 @@
 #include "liberofs_sha256.h"
 #include <unistd.h>
 
-struct erofs_blobchunk {
-	union {
-		struct hashmap_entry ent;
-		struct list_head list;
-	};
-	char		sha256[32];
-	unsigned int	device_id;
-	union {
-		erofs_off_t	chunksize;
-		erofs_off_t	sourceoffset;
+struct erofs_chunkitem {
+	u8 sha256[32];
+	struct list_head list;
+	struct {
+		unsigned int device_id;
+		union {
+			u64 chunksize;
+			erofs_off_t sourceoffset;
+		};
+		erofs_blk_t	blkaddr;
 	};
-	erofs_blk_t	blkaddr;
 };
 
-static struct hashmap blob_hashmap;
-static int blobfile = -1;
-static erofs_blk_t remapped_base;
-static erofs_off_t datablob_size;
-struct erofs_blobchunk erofs_holechunk = {
+struct erofs_chunkitem erofs_holechunk = {
 	.blkaddr = EROFS_NULL_ADDR,
 };
-static LIST_HEAD(unhashed_blobchunks);
 
-struct erofs_blobchunk *erofs_get_unhashed_chunk(unsigned int device_id,
-		erofs_blk_t blkaddr, erofs_off_t sourceoffset)
+struct erofs_chunkmgr {
+	struct list_head chunks[65536];
+	struct list_head unhashed_chunks;
+	int device_id;
+};
+
+#define EROFS_CHUNK_NR_BUCKETS	\
+	ARRAY_SIZE(((struct erofs_chunkmgr *)0)->chunks)
+
+struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
+		unsigned int device_id, erofs_blk_t blkaddr,
+		erofs_off_t sourceoffset)
 {
-	struct erofs_blobchunk *chunk;
+	struct erofs_chunkmgr *chunkmgr = sbi->chunkmgr;
+	struct erofs_chunkitem *chunk;
+	int ret;
 
-	chunk = calloc(1, sizeof(struct erofs_blobchunk));
+	if (__erofs_unlikely(!chunkmgr)) {
+		ret = erofs_blob_init(sbi, 0, 0);
+		if (ret)
+			return ERR_PTR(ret);
+		chunkmgr = sbi->chunkmgr;
+	}
+	chunk = calloc(1, sizeof(*chunk));
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 
 	chunk->device_id = device_id;
 	chunk->blkaddr = blkaddr;
 	chunk->sourceoffset = sourceoffset;
-	list_add_tail(&chunk->list, &unhashed_blobchunks);
+	list_add_tail(&chunk->list, &chunkmgr->unhashed_chunks);
 	return chunk;
 }
 
-static struct erofs_blobchunk *erofs_blob_getchunk(struct erofs_sb_info *sbi,
-						u8 *buf, erofs_off_t chunksize)
+#define FNV32_BASE ((unsigned int)0x811c9dc5)
+#define FNV32_PRIME ((unsigned int)0x01000193)
+
+static unsigned int memhash(const void *buf, size_t len)
+{
+	unsigned int hash = FNV32_BASE;
+	unsigned char *ucbuf = (unsigned char *)buf;
+
+	while (len--) {
+		unsigned int c = *ucbuf++;
+
+		hash = (hash * FNV32_PRIME) ^ c;
+	}
+	return hash;
+}
+
+static struct erofs_chunkitem *erofs_get_chunk(struct erofs_sb_info *sbi,
+					       int device_id,
+					       u8 *buf, u64 size)
 {
+	struct erofs_bufmgr *bmgr = device_id ? sbi->devs[device_id - 1].bmgr : sbi->bmgr;
+	struct erofs_chunkmgr *chunkmgr = sbi->chunkmgr;
 	static u8 zeroed[EROFS_MAX_BLOCK_SIZE];
-	struct erofs_blobchunk *chunk;
+	struct erofs_chunkitem *chunk;
+	struct erofs_buffer_head *bh;
 	unsigned int hash, padding;
+	struct list_head *head;
+	erofs_blk_t pos;
 	u8 sha256[32];
-	erofs_off_t blkpos;
 	int ret;
 
-	erofs_sha256(buf, chunksize, sha256);
+	erofs_sha256(buf, size, sha256);
 	hash = memhash(sha256, sizeof(sha256));
+	head = &chunkmgr->chunks[hash & (EROFS_CHUNK_NR_BUCKETS - 1)];
 	if (cfg.c_dedupe != EROFS_DEDUPE_FORCE_OFF) {
-		chunk = hashmap_get_from_hash(&blob_hashmap, hash, sha256);
-		if (chunk) {
-			DBG_BUGON(chunksize != chunk->chunksize);
-
-			sbi->saved_by_deduplication += chunksize;
+		list_for_each_entry(chunk, head, list) {
+			if (chunk->chunksize != size)
+				continue;
+			if (memcmp(chunk->sha256, sha256, sizeof(sha256)))
+				continue;
+			sbi->saved_by_deduplication += size;
 			if (chunk->blkaddr == erofs_holechunk.blkaddr) {
 				chunk = &erofs_holechunk;
 				erofs_dbg("Found duplicated hole chunk");
@@ -82,29 +117,34 @@ static struct erofs_blobchunk *erofs_blob_getchunk(struct erofs_sb_info *sbi,
 		}
 	}
 
-	chunk = malloc(sizeof(struct erofs_blobchunk));
+	chunk = malloc(sizeof(*chunk));
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 
-	chunk->chunksize = chunksize;
+	chunk->chunksize = size;
 	memcpy(chunk->sha256, sha256, sizeof(sha256));
-	blkpos = lseek(blobfile, 0, SEEK_CUR);
-	DBG_BUGON(erofs_blkoff(sbi, blkpos));
 
-	if (sbi->extra_devices)
-		chunk->device_id = 1;
-	else
-		chunk->device_id = 0;
-	chunk->blkaddr = erofs_blknr(sbi, blkpos);
-
-	erofs_dbg("Writing chunk (%llu bytes) to %llu", chunksize | 0ULL,
-		  chunk->blkaddr | 0ULL);
-	ret = __erofs_io_write(blobfile, buf, chunksize);
-	if (ret == chunksize) {
-		padding = erofs_blkoff(sbi, chunksize);
+	chunk->device_id = device_id;
+	bh = erofs_balloc(bmgr, DATA, size, 0);
+	if (IS_ERR(bh)) {
+		free(chunk);
+		return ERR_CAST(bh);
+	}
+	bh->op = &erofs_drop_directly_bhops;
+	erofs_mapbh(NULL, bh->block);
+	pos = erofs_btell(bh, false);
+	chunk->blkaddr = pos >> sbi->blkszbits;
+
+	erofs_dbg("Writing chunk (%llu bytes) to %llu (device %d)",
+		  size | 0ULL, chunk->blkaddr | 0ULL, chunk->device_id);
+
+	ret = erofs_io_pwrite(bmgr->vf, buf, pos, size);
+	if (ret == size) {
+		padding = erofs_blkoff(sbi, size);
 		if (padding) {
 			padding = erofs_blksiz(sbi) - padding;
-			ret = __erofs_io_write(blobfile, zeroed, padding);
+			ret = erofs_io_pwrite(bmgr->vf, zeroed,
+					      pos + size, padding);
 			if (ret > 0 && ret != padding)
 				ret = -EIO;
 		}
@@ -113,29 +153,15 @@ static struct erofs_blobchunk *erofs_blob_getchunk(struct erofs_sb_info *sbi,
 	}
 
 	if (ret < 0) {
+		erofs_bdrop(bh, true);
 		free(chunk);
 		return ERR_PTR(ret);
 	}
-
-	hashmap_entry_init(&chunk->ent, hash);
-	hashmap_add(&blob_hashmap, chunk);
+	list_add(&chunk->list, head);
+	erofs_bdrop(bh, false);
 	return chunk;
 }
 
-static int erofs_blob_hashmap_cmp(const void *a, const void *b,
-				  const void *key)
-{
-	const struct erofs_blobchunk *ec1 =
-			container_of((struct hashmap_entry *)a,
-				     struct erofs_blobchunk, ent);
-	const struct erofs_blobchunk *ec2 =
-			container_of((struct hashmap_entry *)b,
-				     struct erofs_blobchunk, ent);
-
-	return memcmp(ec1->sha256, key ? key : ec2->sha256,
-		      sizeof(ec1->sha256));
-}
-
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode)
 {
 	unsigned int unit, src;
@@ -153,17 +179,12 @@ void erofs_inode_fixup_chunkformat(struct erofs_inode *inode)
 
 	extent_count = inode->extent_isize / unit;
 	for (src = 0; src < extent_count; ++src) {
-		struct erofs_blobchunk *chunk =
+		struct erofs_chunkitem *chunk =
 			*(void **)(inode->chunkindexes + src * sizeof(void *));
 
 		if (chunk->blkaddr == EROFS_NULL_ADDR)
 			continue;
-		if (chunk->device_id) {
-			if (chunk->blkaddr > UINT32_MAX) {
-				_48bit = true;
-				break;
-			}
-		} else if (remapped_base + chunk->blkaddr > UINT32_MAX) {
+		if (chunk->blkaddr > UINT32_MAX) {
 			_48bit = true;
 			break;
 		}
@@ -193,7 +214,7 @@ int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 	_48bit = inode->u.chunkformat & EROFS_CHUNK_FORMAT_48BIT;
 	for (dst = src = 0; dst < inode->extent_isize;
 	     src += sizeof(void *), dst += unit) {
-		struct erofs_blobchunk *chunk;
+		struct erofs_chunkitem *chunk;
 		erofs_blk_t startblk;
 
 		chunk = *(void **)(inode->chunkindexes + src);
@@ -205,7 +226,7 @@ int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 			startblk = chunk->blkaddr;
 			extent_start = EROFS_NULL_ADDR;
 		} else {
-			startblk = remapped_base + chunk->blkaddr;
+			startblk = chunk->blkaddr;
 		}
 
 		if (extent_start == EROFS_NULL_ADDR || startblk != extent_end) {
@@ -286,8 +307,8 @@ static void erofs_update_minextblks(struct erofs_sb_info *sbi,
 		*minextblks = lb;
 }
 static bool erofs_blob_can_merge(struct erofs_sb_info *sbi,
-				 struct erofs_blobchunk *lastch,
-				 struct erofs_blobchunk *chunk)
+				 struct erofs_chunkitem *lastch,
+				 struct erofs_chunkitem *chunk)
 {
 	if (!lastch)
 		return true;
@@ -300,13 +321,16 @@ static bool erofs_blob_can_merge(struct erofs_sb_info *sbi,
 
 	return false;
 }
+
 int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 				  erofs_off_t startoff)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
-	unsigned int chunkbits = cfg.c_chunkbits;
+	struct erofs_chunkmgr *cmgr = sbi->chunkmgr;
+	int device_id = cmgr->device_id;
+	unsigned int chunkbits = inode->u.chunkbits;
 	unsigned int count, unit;
-	struct erofs_blobchunk *chunk, *lastch;
+	struct erofs_chunkitem *chunk, *lastch;
 	struct erofs_inode_chunk_index *idx;
 	erofs_off_t pos, len, chunksize, interval_start;
 	erofs_blk_t minextblks;
@@ -324,7 +348,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 	chunksize = 1ULL << chunkbits;
 	count = DIV_ROUND_UP(inode->i_size, chunksize);
 
-	if (sbi->extra_devices)
+	if (device_id)
 		inode->u.chunkformat |= EROFS_CHUNK_FORMAT_INDEXES;
 	if (inode->u.chunkformat & EROFS_CHUNK_FORMAT_INDEXES)
 		unit = sizeof(struct erofs_inode_chunk_index);
@@ -346,26 +370,6 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 	minextblks = BLK_ROUND_UP(sbi, inode->i_size);
 	interval_start = 0;
 
-	/*
-	 * If dsunit <= chunksize, deduplication will not cause misalignment,
-	 * so it's uncontroversial to apply the current data alignment policy.
-	 */
-	if (sbi->bmgr->dsunit > 1 &&
-	    sbi->bmgr->dsunit <= (1u << (chunkbits - sbi->blkszbits))) {
-		off_t off = lseek(blobfile, 0, SEEK_CUR);
-
-		off = roundup(off, sbi->bmgr->dsunit * erofs_blksiz(sbi));
-		if (lseek(blobfile, off, SEEK_SET) != off) {
-			ret = -errno;
-			erofs_err("failed to lseek blobdev@0x%llx: %s", off,
-				  erofs_strerror(ret));
-			goto err;
-		}
-		erofs_dbg("Align /%s on block #%llu (0x%llx)",
-			  erofs_fspath(inode->i_srcpath),
-			  erofs_blknr(sbi, off) | 0ULL, off);
-	}
-
 	for (pos = 0; pos < inode->i_size; pos += len) {
 		off_t offset = lseek(fd, pos + startoff, SEEK_DATA);
 
@@ -411,7 +415,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 			goto err;
 		}
 
-		chunk = erofs_blob_getchunk(sbi, chunkdata, len);
+		chunk = erofs_get_chunk(sbi, device_id, chunkdata, len);
 		if (IS_ERR(chunk)) {
 			ret = PTR_ERR(chunk);
 			goto err;
@@ -462,10 +466,10 @@ int erofs_write_zero_inode(struct erofs_inode *inode)
 	inode->chunkindexes = idx;
 
 	for (pos = 0; pos < inode->i_size; pos += len) {
-		struct erofs_blobchunk *chunk;
+		struct erofs_chunkitem *chunk;
 
 		len = min_t(erofs_off_t, inode->i_size - pos, chunksize);
-		chunk = erofs_get_unhashed_chunk(0, EROFS_NULL_ADDR, -1);
+		chunk = erofs_get_unhashed_chunk(sbi, 0, EROFS_NULL_ADDR, -1);
 		if (IS_ERR(chunk)) {
 			free(inode->chunkindexes);
 			inode->chunkindexes = NULL;
@@ -483,9 +487,10 @@ int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset)
 	struct erofs_sb_info *sbi = inode->sbi;
 	unsigned int chunkbits = ilog2(inode->i_size - 1) + 1;
 	unsigned int count, unit, device_id;
+	struct erofs_inode_chunk_index *idx;
+	struct erofs_buffer_head *bh;
 	erofs_off_t chunksize, len, pos;
 	erofs_blk_t blkaddr;
-	struct erofs_inode_chunk_index *idx;
 
 	if (chunkbits < sbi->blkszbits)
 		chunkbits = sbi->blkszbits;
@@ -502,9 +507,14 @@ int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset)
 	} else {
 		device_id = 0;
 		unit = EROFS_BLOCK_MAP_ENTRY_SIZE;
-		DBG_BUGON(erofs_blkoff(sbi, datablob_size));
-		blkaddr = erofs_blknr(sbi, datablob_size);
-		datablob_size += round_up(inode->i_size, erofs_blksiz(sbi));
+		bh = erofs_balloc(sbi->bmgr, DATA,
+				  round_up(inode->i_size, erofs_blksiz(sbi)), 0);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+		bh->op = &erofs_drop_directly_bhops;
+		erofs_mapbh(NULL, bh->block);
+		blkaddr = erofs_btell(bh, false) >> sbi->blkszbits;
+		erofs_bdrop(bh, false);
 	}
 	chunksize = 1ULL << chunkbits;
 	count = DIV_ROUND_UP(inode->i_size, chunksize);
@@ -516,11 +526,11 @@ int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset)
 	inode->chunkindexes = idx;
 
 	for (pos = 0; pos < inode->i_size; pos += len) {
-		struct erofs_blobchunk *chunk;
+		struct erofs_chunkitem *chunk;
 
 		len = min_t(erofs_off_t, inode->i_size - pos, chunksize);
 
-		chunk = erofs_get_unhashed_chunk(device_id, blkaddr,
+		chunk = erofs_get_unhashed_chunk(sbi, device_id, blkaddr,
 						 data_offset);
 		if (IS_ERR(chunk)) {
 			free(inode->chunkindexes);
@@ -548,93 +558,24 @@ int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset)
 
 int erofs_mkfs_dump_blobs(struct erofs_sb_info *sbi)
 {
-	struct erofs_buffer_head *bh;
-	ssize_t length, ret;
-	u64 pos_in, pos_out;
-
-	if (blobfile >= 0) {
-		length = lseek(blobfile, 0, SEEK_CUR);
-		if (length < 0)
-			return -errno;
-
-		if (sbi->extra_devices)
-			sbi->devs[0].blocks = erofs_blknr(sbi, length);
-		else
-			datablob_size = length;
-	}
-
-	if (sbi->extra_devices)
-		return 0;
-
-	bh = erofs_balloc(sbi->bmgr, DATA, datablob_size, 0);
-	if (IS_ERR(bh))
-		return PTR_ERR(bh);
-
-	erofs_mapbh(NULL, bh->block);
-
-	pos_out = erofs_btell(bh, false);
-	remapped_base = erofs_blknr(sbi, pos_out);
-	pos_out += sbi->bdev.offset;
-	if (blobfile >= 0) {
-		pos_in = 0;
-		do {
-			length = min_t(erofs_off_t, datablob_size,  SSIZE_MAX);
-			ret = erofs_copy_file_range(blobfile, &pos_in,
-					sbi->bdev.fd, &pos_out, length);
-		} while (ret > 0 && (datablob_size -= ret));
-
-		if (ret >= 0) {
-			if (datablob_size) {
-				erofs_err("failed to append the remaining %llu-byte chunk data",
-					  datablob_size);
-				ret = -EIO;
-			} else {
-				ret = 0;
-			}
-		}
-	} else {
-		ret = erofs_io_ftruncate(&sbi->bdev, pos_out + datablob_size);
-	}
-	bh->op = &erofs_drop_directly_bhops;
-	erofs_bdrop(bh, false);
-	return ret;
-}
-
-void erofs_blob_exit(void)
-{
-	struct hashmap_iter iter;
-	struct hashmap_entry *e;
-	struct erofs_blobchunk *bc, *n;
-
-	if (blobfile >= 0)
-		close(blobfile);
-
-	/* Disable hashmap shrink, effectively disabling rehash.
-	 * This way we can iterate over entire hashmap efficiently
-	 * and safely by using hashmap_iter_next() */
-	hashmap_disable_shrink(&blob_hashmap);
-	e = hashmap_iter_first(&blob_hashmap, &iter);
-	while (e) {
-		bc = container_of((struct hashmap_entry *)e,
-				  struct erofs_blobchunk, ent);
-		DBG_BUGON(hashmap_remove(&blob_hashmap, e) != e);
-		free(bc);
-		e = hashmap_iter_next(&iter);
-	}
-	DBG_BUGON(hashmap_free(&blob_hashmap));
+	struct erofs_device_info *di;
 
-	list_for_each_entry_safe(bc, n, &unhashed_blobchunks, list) {
-		list_del(&bc->list);
-		free(bc);
+	for (di = sbi->devs; di < sbi->devs + sbi->extra_devices; ++di) {
+		if (!di->bmgr)
+			continue;
+		di->blocks = erofs_mapbh(di->bmgr, NULL);
 	}
+	return 0;
 }
 
-static int erofs_insert_zerochunk(erofs_off_t chunksize)
+static int erofs_insert_zerochunk(struct erofs_chunkmgr *cmgr,
+				  unsigned int cbitsdef)
 {
-	u8 *zeros;
-	struct erofs_blobchunk *chunk;
-	u8 sha256[32];
+	erofs_off_t chunksize = 1ULL << cbitsdef;
+	struct erofs_chunkitem *chunk;
+	struct list_head *head;
 	unsigned int hash;
+	u8 sha256[32], *zeros;
 	int ret = 0;
 
 	zeros = calloc(1, chunksize);
@@ -644,7 +585,7 @@ static int erofs_insert_zerochunk(erofs_off_t chunksize)
 	erofs_sha256(zeros, chunksize, sha256);
 	free(zeros);
 	hash = memhash(sha256, sizeof(sha256));
-	chunk = malloc(sizeof(struct erofs_blobchunk));
+	chunk = malloc(sizeof(*chunk));
 	if (!chunk)
 		return -ENOMEM;
 
@@ -653,21 +594,96 @@ static int erofs_insert_zerochunk(erofs_off_t chunksize)
 	chunk->blkaddr = erofs_holechunk.blkaddr;
 	memcpy(chunk->sha256, sha256, sizeof(sha256));
 
-	hashmap_entry_init(&chunk->ent, hash);
-	hashmap_add(&blob_hashmap, chunk);
+	head = &cmgr->chunks[hash & (EROFS_CHUNK_NR_BUCKETS - 1)];
+	list_add(&chunk->list, head);
 	return ret;
 }
 
-int erofs_blob_init(const char *blobfile_path, erofs_off_t chunksize)
+int erofs_blob_init_device(struct erofs_sb_info *sbi, int device_id)
 {
-	if (!blobfile_path)
-		blobfile = erofs_tmpfile();
-	else
-		blobfile = open(blobfile_path, O_WRONLY | O_CREAT |
-						O_TRUNC | O_BINARY, 0666);
-	if (blobfile < 0)
-		return -errno;
+	struct erofs_bufmgr *bmgr;
+	struct erofs_vfile *vf;
+	int fd, ret;
+
+	if (!device_id || sbi->devs[device_id - 1].bmgr)
+		return 0;
+
+	/* TODO: move it into (struct erofs_device_info) */
+	vf = malloc(sizeof(struct erofs_vfile));
+	if (!vf)
+		return -ENOMEM;
 
-	hashmap_init(&blob_hashmap, erofs_blob_hashmap_cmp, 0);
-	return erofs_insert_zerochunk(chunksize);
+	fd = open(sbi->devs[device_id - 1].src_path,
+		  O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0666);
+	if (fd < 0) {
+		ret = -errno;
+		goto err_vf;
+	}
+	*vf = (struct erofs_vfile){ .fd = fd };
+	bmgr = erofs_buffer_init(sbi, 0, vf);
+	if (!bmgr) {
+		ret = -ENOMEM;
+		goto err_fd;
+	}
+	sbi->devs[device_id - 1].bmgr = bmgr;
+	return 0;
+
+err_fd:
+	close(fd);
+err_vf:
+	free(vf);
+	return ret;
+}
+
+int erofs_blob_init(struct erofs_sb_info *sbi, int blobdev_id,
+		    unsigned int chunkbits_zero)
+{
+	struct erofs_chunkmgr *cmgr;
+	int i, ret;
+
+	if (!sbi->chunkmgr) {
+		cmgr = malloc(sizeof(*cmgr));
+		if (!cmgr)
+			return -ENOMEM;
+
+		for (i = 0; i < EROFS_CHUNK_NR_BUCKETS; ++i)
+			init_list_head(&cmgr->chunks[i]);
+		init_list_head(&cmgr->unhashed_chunks);
+
+		if (chunkbits_zero) {
+			ret = erofs_insert_zerochunk(cmgr, chunkbits_zero);
+			if (ret)
+				goto err_out;
+		}
+		cmgr->device_id = blobdev_id;
+		sbi->chunkmgr = cmgr;
+	}
+	return 0;
+err_out:
+	free(cmgr);
+	return ret;
+}
+
+int erofs_blob_exit(struct erofs_sb_info *sbi)
+{
+	struct erofs_chunkmgr *cmgr = sbi->chunkmgr;
+	struct erofs_chunkitem *bc, *n;
+	int i;
+
+	if (!cmgr)
+		return 0;
+	for (i = 0; i < EROFS_CHUNK_NR_BUCKETS; ++i) {
+		list_for_each_entry_safe(bc, n, &cmgr->chunks[i], list) {
+			list_del(&bc->list);
+			free(bc);
+		}
+	}
+
+	list_for_each_entry_safe(bc, n, &cmgr->unhashed_chunks, list) {
+		list_del(&bc->list);
+		free(bc);
+	}
+	free(cmgr);
+	sbi->chunkmgr = NULL;
+	return 0;
 }
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 6b03a52..55681f9 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -193,7 +193,7 @@ static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
 	inode->chunkindexes = idx;
 
 	for (i = 0; i < count; i++) {
-		struct erofs_blobchunk *chunk;
+		struct erofs_chunkitem *chunk;
 		struct erofs_map_blocks map = {
 			.buf = __EROFS_BUF_INITIALIZER,
 		};
@@ -204,7 +204,7 @@ static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
 			goto err;
 
 		blkaddr = erofs_blknr(dst_sb, map.m_pa);
-		chunk = erofs_get_unhashed_chunk(inode->dev, blkaddr, 0);
+		chunk = erofs_get_unhashed_chunk(dst_sb, inode->dev, blkaddr, 0);
 		if (IS_ERR(chunk)) {
 			ret = PTR_ERR(chunk);
 			goto err;
diff --git a/lib/super.c b/lib/super.c
index ead4170..25116fe 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -189,8 +189,18 @@ void erofs_put_super(struct erofs_sb_info *sbi)
 		int i;
 
 		DBG_BUGON(!sbi->extra_devices);
-		for (i = 0; i < sbi->extra_devices; ++i)
+		for (i = 0; i < sbi->extra_devices; ++i) {
+			struct erofs_bufmgr *bmgr = sbi->devs[i].bmgr;
+			struct erofs_vfile *vf;
+
+			if (bmgr) {
+				vf = bmgr->vf;
+				erofs_buffer_exit(bmgr);
+				close(vf->fd);
+				free(vf);
+			}
 			free(sbi->devs[i].src_path);
+		}
 		free(sbi->devs);
 		sbi->devs = NULL;
 	}
diff --git a/mkfs/main.c b/mkfs/main.c
index 5bf7b8f..b6d215b 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1915,12 +1915,6 @@ int main(int argc, char **argv)
 	}
 
 	cfg.c_dedupe = importer_params.dedupe;
-	if (cfg.c_chunkbits) {
-		err = erofs_blob_init(cfg.c_blobdev_path, 1 << cfg.c_chunkbits);
-		if (err)
-			goto exit;
-	}
-
 	if (tar_index_512b || cfg.c_blobdev_path) {
 		err = erofs_mkfs_init_devices(&g_sbi, 1);
 		if (err) {
@@ -1930,6 +1924,24 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (tar_index_512b || cfg.c_chunkbits) {
+		if (g_sbi.extra_devices && cfg.c_blobdev_path) {
+			g_sbi.devs[0].src_path = strdup(cfg.c_blobdev_path);
+			if (!g_sbi.devs[0].src_path) {
+				err = -ENOMEM;
+				goto exit;
+			}
+
+			err = erofs_blob_init_device(&g_sbi, 1);
+			if (err)
+				goto exit;
+
+		}
+		err = erofs_blob_init(&g_sbi, cfg.c_blobdev_path ? 1 : 0, cfg.c_chunkbits);
+		if (err)
+			goto exit;
+	}
+
 	if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR) {
 		err = erofs_load_shared_xattrs_from_path(&g_sbi, cfg.c_src_path,
 						mkfscfg.inlinexattr_tolerance);
@@ -2072,8 +2084,7 @@ exit:
 		fclose(blklst);
 	erofs_cleanup_compress_hints();
 	erofs_cleanup_exclude_rules();
-	if (cfg.c_chunkbits || source_mode == EROFS_MKFS_SOURCE_REBUILD)
-		erofs_blob_exit();
+	erofs_blob_exit(&g_sbi);
 	erofs_xattr_cleanup_name_prefixes();
 	erofs_rebuild_cleanup();
 	erofs_diskbuf_exit();
-- 
2.47.3


