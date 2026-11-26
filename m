Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA72606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Nov 2026 12:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=MOkQqRg+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jZwCX5FWvz2yMn;
	Thu, 26 Nov 2026 23:02:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::430"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795694552;
	cv=none; b=EN1BqpNIwdpcGh9TyVrr2zEquhuLEKdJ/knTcAUgG8R/UP5mtUiKYB/RAW2Rfi+L9qgs9HOIuZ99s1xBOtZDPArn7oJUmEKLA9SiA7sW9JCrBx2QP/evAxxOeyTbmOlyDgjieU8MetocSBKcHoEymKcsn/lVVUww2lhLc2wOzSZMmYrfNWsm5mvpfw9AecfKhk/hS/MPS0/9TfC1j3tx4stRgsA9ArzhA1aZAIbYZcG3IpWoj8b2kaSQ4GLXCV6ep0rV9eKUU5NHeO049RjkqwIW328QSUELpJ/kLLAo70oeGxxtPS+GziYgQU6N4RnzYAPDKXt4siWRDLfRW2otMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795694552; c=relaxed/relaxed;
	bh=5WitMIIPBMQ+fy11e7KoLi9kf18Fj8BbYz+JxjBvR5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFRCtr9YmT9SHsXZ2EXH5LyJaRA5XEGQfQmTNNwZPXGoV8FMKqRz/jXNdGrIQpe8SLW64qrvkGWcAUzCey8aFuPHceZ3XLi0I6/JmBmvh4tJ1aWAeZcD7J8yhfg2iEWNRsLA/R2cM0WhxXS+U9LfpVCw7so0i+hgGkpBBW+3LoFQquo27AbVWvDVL3qmfoyMDlF2IijEAYDW8tPXNPHSgVCNu3WxJzITlodp4VMlufCvKSboz3ONp7fccTW4w01uI9IIH5tYUM3xxxjUsGGweGKUePjnwDoTnFDxiaIXSjcoOcJKFVkzsvpS9bK59a13ei4nwleXnqgqbwBo7TFFqQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=MOkQqRg+; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::430; helo=mail-wr1-x430.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=MOkQqRg+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::430; helo=mail-wr1-x430.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jZwCW2bGPz2yLH
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 23:02:31 +1100 (AEDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-4a5024b3c28so4565765f8f.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 26 Nov 2026 04:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795694548; x=1796299348; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5WitMIIPBMQ+fy11e7KoLi9kf18Fj8BbYz+JxjBvR5k=;
        b=MOkQqRg+sVnKPHkzW/+ZWcTlm24TSR0cP49Lh87wpjhiLzo68XNMp9VTQJlnNwAvga
         IfUd3RwIR6svUp+xn1s791P7NbFXq8yJey/j3sliZvzWji4i2E3AjyTWR+LdoXYPPdC0
         jUvVO+x4tVdtCR6InsFV7qqAq3osOuHhd1DvlCZRX7ZhDzHrf0viEmbD+bY3zvPhVqv0
         lv7Syn1hN5t1UMbVg1WsEg5aFS2YT33D8sxVa01E39ViCc20TVALG0yXf2gzLCHRH8qg
         gDYa/twQ1PX7/A1ccENRJUCGKLIwyubNyOZjgMBgx4vF52xrgO689ComqdWCkCjhvSku
         aQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694548; x=1796299348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5WitMIIPBMQ+fy11e7KoLi9kf18Fj8BbYz+JxjBvR5k=;
        b=aie4dorS1oBtD+CdDoy3PKnLW+fSq1Rx5inBQxeoZ7T1S4sn/c6v8x0MLueMSexbjv
         aZMoZkl200TZSCQpJN0QPCM2Iab/P5DsvzLfHfsJvJ+92V0VVKSKw9+qLziLgUOO+8Mb
         EwZVAtfYLm63FmSoUJ8DgV5JJemo6lgadRyND1gENuwKy0CbgtBrIXdmjohYoRc1koF9
         5MaxqhD4SbcdfmJWwfeAlWhcxzcbcj07BMMtWnlfBV8WYP5hRJNKoLmhZiJYDLoE6Bav
         a62cTqBr7fpHD5o6VU6AaWOFo6ODr70VNXVA9S5YAUYcaMNG9kiSBivS9k14imQ2qdIR
         bCzw==
X-Gm-Message-State: APuU4Z9fHfsXIqO015xNyKtQWORfFFvP5tsRQeyiUO31+C8Bu6209UTk
	sy5Cc5TxHf7nWDbQL6YoPPCduA4GPA/Eqm/mXecGQZD/szH1qYaGlI9DMHx7j+OZ4rOSmJSFWY7
	zAR2B/b8=
X-Gm-Gg: AZFdTZdrdDIVcQLYOw52jbOSN3zESzmWSOz3LAo/QfAn3w/L5nlQfDQ802kauv+3Ppg
	9XJh1BH6pIMljmD+e58DURmh7w+D/V4wSpOMW/jyXPOUJvck7rEbEG6MwQhOWiw5uJQ19GEKjFu
	Bi8S4NUZtAiwX6r7CITRbGugb47qgUPM7IdnXfUzfujBRqnnwwoCegXpfhKsAY6WNQP+cJt9U50
	TzLe9lALitk+Y12enZFo6uEhGPm6SJk0BRfGZhTX3Djz3005ITTadmZsxlSS7XgKlI2LDEB8t3J
	7tsyQ8hiotYXf9KMNLb8BPVk4oe7xALS5yG+gV8RVRMK420O4KBGJUhnpwT0Uk0MEyGRjvPQCAo
	7uZdJ/OfJIWR9kXV2rKXLLIX/5bhvXulk9sO8S5Y6RD7xvRFor3cmgxL75mOsz9dH77lalSJ6ix
	Zl+McGKc6oo/ZMFWPWHw4MNMBf7XRk8Tk+tp+zmLoMebZqAYPL1YJnHcWhafc9RaMEtS/BbZcN1
	gXs2Alod5t58+gqZas1JHOWMxnbvYkySHwHcBsd6N33kDcW2WzBZvyvgZd21yoTYpucjThEcZAG
	xX9NjPDVcr+7DfO6L8ddwDUQygExEMzUO900lg6pvEHZMTMKGoks2jS7cyovBVofKyYr1nGs/nA
	hp2YC5H+zsyTXMA==
X-Received: by 2002:a05:600c:c086:b0:4bb:ab2c:67f7 with SMTP id 5b1f17b1804b1-4bbab2c6d69mr25656945e9.8.1795694547661;
        Thu, 26 Nov 2026 04:02:27 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:6060:1d3a:5489:cf84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm819402455e9.13.2026.11.26.04.02.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:02:27 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v3 03/10] erofs-utils: lib: fix large chunk index writes
Date: Thu, 26 Nov 2026 13:02:14 +0100
Message-ID: <20261126120221.4384-3-xiang.gao@docker.com>
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

For large chunk index tables, int cannot hold the write result and the
32-bit offset into the chunk pointer array can wrap around.  Inode
metadata size calculations can overflow as well.

Use 64-bit types for the write result, buffer offsets and metadata size.
Use erofs_inode_meta_size() for the root inode size check too.

Fixes: 03cbf7b8f7f7 ("erofs-utils: mkfs: support chunk-based uncompressed files")
Fixes: bbebbbda4b27 ("erofs-utils: lib: consolidate erofs_iflush()")
Assisted-by: Codex:gpt-6.1-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/blobchunk.c      |  7 ++++---
 lib/inode.c          | 19 +++++++++----------
 lib/liberofs_chunk.h |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 8217512..a3a88d3 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -192,8 +192,8 @@ void erofs_inode_fixup_chunkformat(struct erofs_inode *inode)
 		inode->u.chunkformat |= EROFS_CHUNK_FORMAT_48BIT;
 }
 
-int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
-			      erofs_off_t off)
+s64 erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
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
+	u64 dst, src;
 	bool _48bit;
 
 	if (inode->u.chunkformat & EROFS_CHUNK_FORMAT_INDEXES)
diff --git a/lib/inode.c b/lib/inode.c
index ad6f081..ef39a4e 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -799,7 +799,8 @@ int erofs_iflush(struct erofs_inode *inode)
 	struct iovec iov[2];
 	char *xattrs = NULL;
 	bool nlink_1 = true;
-	int ret, fmt;
+	int fmt;
+	s64 ret;
 
 	DBG_BUGON(inode->nid == EROFS_NID_UNALLOCATED);
 	DBG_BUGON(bh && erofs_btell(bh, false) != off);
@@ -981,11 +982,11 @@ static bool erofs_inode_need_48bit(struct erofs_inode *inode)
 	return false;
 }
 
-static unsigned int erofs_inode_meta_size(struct erofs_inode *inode)
+static u64 erofs_inode_meta_size(struct erofs_inode *inode)
 {
-	unsigned int inodesize;
+	u64 inodesize;
 
-	inodesize = inode->inode_isize + inode->xattr_isize;
+	inodesize = inode->inode_isize + (u64)inode->xattr_isize;
 	if (inode->extent_isize)
 		inodesize = roundup(inodesize, 8) + inode->extent_isize;
 	return inodesize;
@@ -997,7 +998,7 @@ static int erofs_prepare_inode_buffer(struct erofs_importer *im,
 	const struct erofs_importer_params *params = im->params;
 	struct erofs_sb_info *sbi = im->sbi;
 	struct erofs_bufmgr *ibmgr;
-	unsigned int inodesize;
+	u64 inodesize;
 	struct erofs_buffer_head *bh, *ibh;
 
 	DBG_BUGON(inode->bh || inode->bh_inline);
@@ -2443,7 +2444,8 @@ int erofs_fixup_root_inode(struct erofs_inode *root)
 {
 	struct erofs_sb_info *sbi = root->sbi;
 	struct erofs_inode oi;
-	unsigned int ondisk_capacity, ondisk_size;
+	unsigned int ondisk_capacity;
+	erofs_off_t ondisk_size;
 	char *ibuf;
 	int err;
 
@@ -2471,10 +2473,7 @@ int erofs_fixup_root_inode(struct erofs_inode *root)
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
index 16f3d05..4ef6640 100644
--- a/lib/liberofs_chunk.h
+++ b/lib/liberofs_chunk.h
@@ -18,8 +18,8 @@ struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
 		unsigned int device_id, erofs_blk_t blkaddr,
 		erofs_off_t sourceoffset);
 void erofs_inode_fixup_chunkformat(struct erofs_inode *inode);
-int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
-			      erofs_off_t off);
+s64 erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
+				 erofs_off_t off);
 int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 				  erofs_off_t startoff, int device_id);
 int erofs_write_zero_inode(struct erofs_inode *inode);
-- 
2.54.0 (Apple Git-157)


