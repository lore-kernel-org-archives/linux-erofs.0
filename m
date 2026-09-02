Return-Path: <linux-erofs+bounces-4410-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F6FEC624D6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 02:52:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZS1y0fcZz2yYd;
	Wed, 02 Sep 2026 12:52:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788317542;
	cv=none; b=hp8OKgEmGYI2cUAHKsvVEoPdkl6Tdx/SjpW9+GCihz3+wiIqTKWY+eGE6AWK4WEgfDEIQ4uSuCg8RvZpWubNolnQh/kVzTC8wDBifve8MddRDTUJPqGhzs2+tl0PmTLkvIHL9wXt0/5BrKG9+CD3TP/CYblqEdUVvr+H0ac6xwEzxuuiIvAAPBuYsfjMuXBOCQ8EnY/jncOHScrzbzZdVjE0eYvzj/TbhDLJrC9u3AG7VVl8qC+/3ahOoby+slTWak3QbUYjjW1Yqp3Fe4Vn1v64Ne+qR796SsVBVav94t+vkdrBRAVcjkSoy6WghkI5aXYd0MOB8fQWW6WkWRb8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788317542; c=relaxed/relaxed;
	bh=uktcNstozimNyZjZGt6+CPm/fh7G1BRp1/eZyDnX2zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyEJJSRP3q8KFi0sH6AVnN1W+msyuJcoqapCQn4grYKcN6lAMRWMbn05wsMLEH0YIoNCgrBRZDhB1sEWvo2GWa4kC4sRsLAmGph28CqGgatTAbk2US0nneVoHQa4lixckS7nNtZCL0HH4QsBXgAgoe8LkUwbIGl8TRn1XGQ+ynxrUkCsJdBvkN8F+c+OTeSbK+PTqJqBNos7Jhlcdv/tUl/4lcgnOFlmgoN6l4hUmG31kGur8X3+7r0d0vsD1m8skstlqkoaQBqVl81tM8t/vgnFm5N5TzX45zaV+ipDjhb26iE0DuKRuVB/CMmGw4PULES3NxlD6EfvERvxw9deFw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HEqJ+r2g; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HEqJ+r2g;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZS1x0KWHz2x9g
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 12:52:21 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EE9643A8A;
	Wed,  2 Sep 2026 02:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B661F00A3E;
	Wed,  2 Sep 2026 02:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788317539;
	bh=uktcNstozimNyZjZGt6+CPm/fh7G1BRp1/eZyDnX2zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEqJ+r2gEnsISKdM07LwftHeDohh8b/43V0HdBMJ6NL5nwrArPDBfoYY3kSMzcnQ8
	 8c36Kc17o1pzSn4oaKDfJEM86JHmqHkPt9hOIwNBkEaAziQLThgAdCTif5P6MbI5SC
	 XGwwxS8l7rPd1T0RSDcPqFV/MmSdKG4Fy+OezhraEnb5W2WsXt1lTUA+zsKv84xmfI
	 6NATM1COx7n0GQEJafSwkM3Tc9JWOWLo/eef2pgKGfnDz/8bbvUq7gN8NfZFKD1jQs
	 pOkeVZAO1YNoPyxx4zjql5QQ+qbyAgLf9Hy5K8oZe4/U/0zTtc5wkf9cTiW2ediRKB
	 CSycxXabwOhPg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 4/5] erofs-utils: mkfs: introduce ddev_id_def
Date: Wed,  2 Sep 2026 10:50:29 +0800
Message-ID: <20260902025031.50499-4-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902025031.50499-1-xiang@kernel.org>
References: <20260902025031.50499-1-xiang@kernel.org>
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

It indicates the default blob device containing the inode data.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/importer.h |  1 +
 lib/blobchunk.c          | 11 +++--------
 lib/inode.c              |  3 ++-
 lib/liberofs_chunk.h     |  5 ++---
 mkfs/main.c              |  3 ++-
 5 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/erofs/importer.h b/include/erofs/importer.h
index c09b169..5141965 100644
--- a/include/erofs/importer.h
+++ b/include/erofs/importer.h
@@ -64,6 +64,7 @@ struct erofs_importer_params {
 	bool compress_dir;
 	char fragdedupe;
 	char chunkszbits_def;
+	u16 ddev_id_def;		/* target device id for inode data */
 };
 
 struct erofs_importer {
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index d218b38..3a641f3 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -34,7 +34,6 @@ struct erofs_chunkitem erofs_holechunk = {
 struct erofs_chunkmgr {
 	struct list_head chunks[65536];
 	struct list_head unhashed_chunks;
-	int device_id;
 };
 
 #define EROFS_CHUNK_NR_BUCKETS	\
@@ -49,7 +48,7 @@ struct erofs_chunkitem *erofs_get_unhashed_chunk(struct erofs_sb_info *sbi,
 	int ret;
 
 	if (__erofs_unlikely(!chunkmgr)) {
-		ret = erofs_blob_init(sbi, 0, 0);
+		ret = erofs_blob_init(sbi, 0);
 		if (ret)
 			return ERR_PTR(ret);
 		chunkmgr = sbi->chunkmgr;
@@ -323,11 +322,9 @@ static bool erofs_blob_can_merge(struct erofs_sb_info *sbi,
 }
 
 int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
-				  erofs_off_t startoff)
+				  erofs_off_t startoff, int device_id)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
-	struct erofs_chunkmgr *cmgr = sbi->chunkmgr;
-	int device_id = cmgr->device_id;
 	unsigned int chunkbits = inode->u.chunkbits;
 	unsigned int count, unit;
 	struct erofs_chunkitem *chunk, *lastch;
@@ -636,8 +633,7 @@ err_vf:
 	return ret;
 }
 
-int erofs_blob_init(struct erofs_sb_info *sbi, int blobdev_id,
-		    unsigned int chunkbits_zero)
+int erofs_blob_init(struct erofs_sb_info *sbi, unsigned int chunkbits_zero)
 {
 	struct erofs_chunkmgr *cmgr;
 	int i, ret;
@@ -656,7 +652,6 @@ int erofs_blob_init(struct erofs_sb_info *sbi, int blobdev_id,
 			if (ret)
 				goto err_out;
 		}
-		cmgr->device_id = blobdev_id;
 		sbi->chunkmgr = cmgr;
 	}
 	return 0;
diff --git a/lib/inode.c b/lib/inode.c
index 728040a..a3fc181 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -709,6 +709,7 @@ static int erofs_write_unencoded_file(const struct erofs_importer *im,
 {
 	struct erofs_vfile vf = { .fd = fd };
 	char chunkbits = im->params->chunkszbits_def;
+	int device_id = im->params->ddev_id_def;
 
 	if (chunkbits &&
 	    inode->datasource != EROFS_INODE_DATA_SOURCE_REBUILD_BLOB) {
@@ -717,7 +718,7 @@ static int erofs_write_unencoded_file(const struct erofs_importer *im,
 		inode->u.chunkformat = 0;
 		if (cfg.c_force_chunkformat == FORCE_INODE_CHUNK_INDEXES)
 			inode->u.chunkformat = EROFS_CHUNK_FORMAT_INDEXES;
-		return erofs_blob_write_chunked_file(inode, fd, fpos);
+		return erofs_blob_write_chunked_file(inode, fd, fpos, device_id);
 	}
 
 	if (inode->datasource == EROFS_INODE_DATA_SOURCE_REBUILD_BLOB) {
diff --git a/lib/liberofs_chunk.h b/lib/liberofs_chunk.h
index 3af88df..ff31891 100644
--- a/lib/liberofs_chunk.h
+++ b/lib/liberofs_chunk.h
@@ -21,12 +21,11 @@ void erofs_inode_fixup_chunkformat(struct erofs_inode *inode);
 int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 			      erofs_off_t off);
 int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
-				  erofs_off_t startoff);
+				  erofs_off_t startoff, int device_id);
 int erofs_write_zero_inode(struct erofs_inode *inode);
 int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset);
 int erofs_mkfs_dump_blobs(struct erofs_sb_info *sbi);
-int erofs_blob_init(struct erofs_sb_info *sbi, int blobdev_id,
-		    unsigned int chunkbits_def);
+int erofs_blob_init(struct erofs_sb_info *sbi, unsigned int chunkbits_zero);
 int erofs_blob_init_device(struct erofs_sb_info *sbi, int device_id);
 int erofs_chunkmgr_exit(struct erofs_sb_info *sbi);
 
diff --git a/mkfs/main.c b/mkfs/main.c
index c0766d8..6b32e90 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1940,7 +1940,8 @@ int main(int argc, char **argv)
 				goto exit;
 
 		}
-		err = erofs_blob_init(&g_sbi, mkfscfg.blobdev_path ? 1 : 0, mkfscfg.chunkbits);
+		importer_params.ddev_id_def = mkfscfg.blobdev_path ? 1 : 0;
+		err = erofs_blob_init(&g_sbi, mkfscfg.chunkbits);
 		if (err)
 			goto exit;
 	}
-- 
2.47.3


