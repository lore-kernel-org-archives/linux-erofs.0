Return-Path: <linux-erofs+bounces-4589-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3CCC982EE
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 13:35:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hpPPc4DrDz2y71;
	Mon, 21 Sep 2026 23:35:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789997748;
	cv=none; b=DpaX4zW2mPS4Bj+LUkTci6jG5AKz/r3vvN25nytw0JhFMc4IB449PL9s9a2igdoFBWf/ewVbuVQHgbELbTK3iBI2v8ondRkZvGO5WAyPEJaxw7ossVHVZc97aVOupTojvK9qTar0oZQ9B3DvEWpuN5lj1gaFmyrQSUIteGXD3vh3xBkJEP306YFGZc83xETdjLDwTGyS7ITuR6gTJx27XSb5mVGur+jYPcLelLhVvtwqg2ELU1nAPa/9OFN0J0+2aW8JPChJw2yl8RSuo+yISYa8FiYu8PgywcjhSf09Cjj2aGrSyEvNyEDhnIRD6KevWMwvUKBzB2VGbB6VVg8c9w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789997748; c=relaxed/relaxed;
	bh=zt/UHq8fsx5ZTnozNus0fxzOTKZYPum3/4nSGv7yXts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJK6fFTKZ/sjrCRu7hlcqfgmfjexchoSbse9VOzjsSkgQ1rAeWl5V85ihuA4Hc2wxrD6+J8nfVqkGLB/lgIgmrha/F9IuR/Hrkf6EtNNcKCUvIFzRIKjm8eW/pXwN4JltOp6k4MYyTHzVIckjMAdLopirGjitLsuy45MvZfAFHFXcOYiQ3EGh4+Vp7v5eMqW2xLZppWaRmTB3YO5607BU7uBwPXoolTq+RTKjBvR+gK+gAIBdPXXdR4bQSMu+CsLX6FvwbOKVD9RoP8GSTftyZmV4ybp7NvBstUGStRkIw+eRBGeYgt7EUgEiYwO4vB6HYrn78hM979DdcwMDf42NQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qvYfdVp+; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::f; helo=mail-pj2-x0f.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qvYfdVp+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::f; helo=mail-pj2-x0f.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0f.google.com (mail-pj2-x0f.google.com [IPv6:2607:f8b0:4864:39::f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hpPPZ6jGWz2xk7
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 23:35:46 +1000 (AEST)
Received: by mail-pj2-x0f.google.com with SMTP id 98e67ed59e1d1-39b31b4281eso2926432a91.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 06:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997744; x=1790602544; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zt/UHq8fsx5ZTnozNus0fxzOTKZYPum3/4nSGv7yXts=;
        b=qvYfdVp+Qe4RrfzlwNR+ZMPPBMHjCOloCCE6baZ/OFtk6oPneuJ8mbU0aYZRJzQVd+
         geCf0wEYBeUMc/eeJD8GVX5wYNdBmmSQMCQ2LLxof1tppFdtIIIHOIz2CwEwwkQFl6Ri
         3p+FsbS/ECxNm2gx+RXRSPNJLtwMkSlCZ6A2mAcRhRvac3chnYV4zm1Ll+/SEsBAN7Vo
         L1n8GEZN/rQ8qv3q1SBhf7oElmw96+mvfdgL8ALlsb56yPOcsVK1kuURayWeydDoMy7r
         NMB+Fgqq/WcJe1LhNOceyU5T3LlZvfyHYJTg4V9S/WZz71144/RiHJNNABgCVQYscPRj
         r/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997744; x=1790602544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zt/UHq8fsx5ZTnozNus0fxzOTKZYPum3/4nSGv7yXts=;
        b=IuLf8eMzKxzUH3lTdsZdygcurb/NOZd8Z8Gu2eZ07LYCoLhDZiBaTnE23l9thzPQTQ
         Y89wsSzqGVIZB6cZSr2/HjJ91J2stcnNrAw9/oZ+QX6AlhD/uHnYmxZDJL9jOCSS7MUY
         ObuVW90MQ6V/SXRxuXjhJ/Yd/WXVxj9pZxpcSTqZqCqBr6ew9tMIOsE7lZqTrtf/AgkM
         URNiyneuqCF132P9QwSZteBgcWQNnOUdsmHEuIXjD7iVW6S2g3HSINt4a4xQRfEMoYh3
         ac8UCi5y/lq5in+oCe0pBRRju9a7ipE1iHvaqtgWVirFNoW9NcUj081II9icg77i2wbK
         /Bog==
X-Gm-Message-State: AFuF++lmu8Zc++s1R2fGIp+VXkyWakv9poVpj88dW9/vqcDdhOPys+4N
	jZC0l6RY9SNqEQeiLG5jrtQ+30KuKYq04TmnvtcdM9w9Q1wsKnRfK077AAXXNA==
X-Gm-Gg: AYBFou2iTBNDhrs6BRheoCWI+PGtTgbe5fxvQUxI+P3e9weUH9KQ8NCLdtwDzpc4WZj
	7Z/8tGkNp4PbBdND+HD/XbhV4vuH2KkPBx0zJ60YQ6aokFLsubLzXRDLRMhpQINkX5M0gQGNmcS
	6wI4F8Yf5p2f3Of7qyFKFTmkoc1EyEGcEI+Yi8tjppMaMw69YpG+Tb4GaaqE/gWNT3gjexzWeyS
	IEYD7YlHvdfsejg28f9ArUJ9LI1L95WeD0HgbUFP13xlnoLlSFD35W7pT5Yb4O0op0XCqzGtCfC
	FdMGP8CZsCQvqU4er3mbiCsj/e1WVp2RtJc4CY5XASw1Z2SAVU9ZN6MPSb/Cxb+WZenHYquT7VF
	GhmJuRcJiY5qOOss4Sgwiq0Ab0UKql3+0+XqqpFSyCttDycJH3HRkTVxHQ8AZif8N0zOsmuw7Cl
	Ng0LuSfN7L+IUCO/CBSyBXfsAoCuST7Vk1j2jsQm0JkllJRWDuBHEjTuMGAQNBspZsLaCQ6ulgV
	fD9nVvj40BaDuvfThKq5OY/tE+9iaID7LZ4hrO74qhXF8OA2Q==
X-Received: by 2002:a17:90b:3ccb:b0:39e:4c7e:f03e with SMTP id 98e67ed59e1d1-39e54f2158bmr16124737a91.27.1789997743817;
        Mon, 21 Sep 2026 06:35:43 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06369372csm179385a91.1.2026.09.21.06.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:35:43 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH v2 2/4] erofs-utils: lib: fix large chunk index writes
Date: Mon, 21 Sep 2026 21:35:33 +0800
Message-ID: <20260921133535.2381246-2-stopire@gmail.com>
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

Use ssize_t for chunk index write results in erofs_write_chunk_indexes()
and erofs_iflush().  Widen index buffer offsets and inode metadata size
calculations to avoid truncation with large index tables.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/blobchunk.c      |  7 ++++---
 lib/inode.c          | 19 +++++++++----------
 lib/liberofs_chunk.h |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 8f43dd0..2f42541 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -192,8 +192,8 @@ void erofs_inode_fixup_chunkformat(struct erofs_inode *inode)
 		inode->u.chunkformat |= EROFS_CHUNK_FORMAT_48BIT;
 }
 
-int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
-			      erofs_off_t off)
+ssize_t erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
+				 erofs_off_t off)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
 	erofs_blk_t remaining_blks = BLK_ROUND_UP(sbi, inode->i_size);
@@ -201,7 +201,8 @@ int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 	erofs_blk_t extent_end = EROFS_NULL_ADDR, chunkblks, addrmask;
 	erofs_blk_t extent_start = EROFS_NULL_ADDR;
 	erofs_off_t source_offset;
-	unsigned int dst, src, unit, zeroedlen;
+	unsigned int unit, zeroedlen;
+	size_t dst, src;
 	bool _48bit;
 
 	if (inode->u.chunkformat & EROFS_CHUNK_FORMAT_INDEXES)
diff --git a/lib/inode.c b/lib/inode.c
index ec96556..0cf09b8 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -816,7 +816,8 @@ int erofs_iflush(struct erofs_inode *inode)
 	struct iovec iov[2];
 	char *xattrs = NULL;
 	bool nlink_1 = true;
-	int ret, fmt;
+	ssize_t ret;
+	int fmt;
 
 	DBG_BUGON(inode->nid == EROFS_NID_UNALLOCATED);
 	DBG_BUGON(bh && erofs_btell(bh, false) != off);
@@ -998,11 +999,11 @@ static bool erofs_inode_need_48bit(struct erofs_inode *inode)
 	return false;
 }
 
-static unsigned int erofs_inode_meta_size(struct erofs_inode *inode)
+static erofs_off_t erofs_inode_meta_size(struct erofs_inode *inode)
 {
-	unsigned int inodesize;
+	erofs_off_t inodesize;
 
-	inodesize = inode->inode_isize + inode->xattr_isize;
+	inodesize = inode->inode_isize + (erofs_off_t)inode->xattr_isize;
 	if (inode->extent_isize)
 		inodesize = roundup(inodesize, 8) + inode->extent_isize;
 	return inodesize;
@@ -1014,7 +1015,7 @@ static int erofs_prepare_inode_buffer(struct erofs_importer *im,
 	const struct erofs_importer_params *params = im->params;
 	struct erofs_sb_info *sbi = im->sbi;
 	struct erofs_bufmgr *ibmgr;
-	unsigned int inodesize;
+	erofs_off_t inodesize;
 	struct erofs_buffer_head *bh, *ibh;
 
 	DBG_BUGON(inode->bh || inode->bh_inline);
@@ -2456,7 +2457,8 @@ int erofs_fixup_root_inode(struct erofs_inode *root)
 {
 	struct erofs_sb_info *sbi = root->sbi;
 	struct erofs_inode oi;
-	unsigned int ondisk_capacity, ondisk_size;
+	unsigned int ondisk_capacity;
+	erofs_off_t ondisk_size;
 	char *ibuf;
 	int err;
 
@@ -2484,10 +2486,7 @@ int erofs_fixup_root_inode(struct erofs_inode *root)
 	if (oi.datalayout == EROFS_INODE_FLAT_INLINE)
 		ondisk_capacity += erofs_blkoff(sbi, oi.i_size);
 
-	ondisk_size = root->inode_isize + root->xattr_isize;
-	if (root->extent_isize)
-		ondisk_size = roundup(ondisk_size, 8) + root->extent_isize;
-	ondisk_size += root->idata_size;
+	ondisk_size = erofs_inode_meta_size(root) + root->idata_size;
 
 	if (ondisk_size > ondisk_capacity) {
 		erofs_err("no enough room for the root inode from nid %llu",
diff --git a/lib/liberofs_chunk.h b/lib/liberofs_chunk.h
index 16f3d05..64e7ec8 100644
--- a/lib/liberofs_chunk.h
+++ b/lib/liberofs_chunk.h
@@ -18,8 +18,8 @@ struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
 		unsigned int device_id, erofs_blk_t blkaddr,
 		erofs_off_t sourceoffset);
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode);
-int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
-			      erofs_off_t off);
+ssize_t erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
+				 erofs_off_t off);
 int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 				  erofs_off_t startoff, int device_id);
 int erofs_write_zero_inode(struct erofs_inode *inode);
-- 
2.55.0


