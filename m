Return-Path: <linux-erofs+bounces-4422-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD06C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 15:54:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZnNp0673z2xpn;
	Thu, 03 Sep 2026 01:54:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788364489;
	cv=none; b=YOtbzvE1j0JcGfkmfDrbfFj5EgDwKmiZPhN3aurgj6AA/cWHKqC0mB/bqu66gcuo1zDYwBX3lKR8aU2ujUQr5t8YE0Fr7+e2fgcRxek9Ta3fY8YtJvNY3+p1zBIzGOb5KCMGgU8sgMnOwQ7vARMvRwsv6oOHcdW9YQwZLqU+ZrzRPS8xR2OUKPIfZ7YTr/HZ6yz9Q0dVPA1rLyMtbdeXa99Ns9yKZ7ecSuvVn+SAfhYp8Rt59Dpeehhexyogd5hl12jioYc8h3db2NI1PC5oiVcFX79/PWAjbKfcrnhQQ1Z6LJOGUrFLvnEt/+lDm+iAKPhPHfS65CmBsLamaBElXA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788364489; c=relaxed/relaxed;
	bh=vI/d03uy8NICRBExxJm9qpO7rp+8ccUNbCg0JW6dW7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhsFQpzdJ4pS9kkb+giG2ErkSman8DyYHURDHzNFqdMDtgMj7vh1q4N5D2MSN0VFQcTXz2LWMBZSfrL3+3k8AvczLm7UR8vcr1ICVNyKwB8h0Up4Y9meb5HRm8EXaDRg9TXAlZqAGGQQBGUidCxM2i1fdwmotfyzWp2VA5ESJiciVGmTY5a5RRJY7rHHDpwZgMAtbzrDeCV/L/zvcGSkKez1TMbGtE44lkzRBJDffaCNAB1MI1GvzbFmpbLEbugy1iQgoHikBmOrh29uG0K2mjYeMiE+KeRBCHf7TR+t4znk1zdbg93MogsW01PJ5kymlXgZCaZI0crt+DpK9Vmqxg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKxXzTpB; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKxXzTpB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZnNm65pbz2x98
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 01:54:48 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED732600C8
	for <linux-erofs@lists.ozlabs.org>; Wed,  2 Sep 2026 15:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECD21F00A3A;
	Wed,  2 Sep 2026 15:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788364486;
	bh=vI/d03uy8NICRBExxJm9qpO7rp+8ccUNbCg0JW6dW7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKxXzTpBHFVRr1xMFDKB71ZPo8bxKItkx9tu3JbQp93TGP60hXgQS4POQLp0flZPK
	 c2T+av/I3Os854FkkZ5XrzyQWdM+NC5iKi1MOxfl6AjO7+dIlaQynVwlU/V1QHdt9K
	 ARtYjGwGjgChcfXHeLq0uXERVB8VLcFzXKti40boR9/W0FQ36/cLnf/pDbD+8/DADr
	 P3lr8K+byBT81vyGwkHks1zQ4WhFBMoqTwlKy9dxQsCxADVfA5GFci01FtscALhJEW
	 sLgf/LJ95/jRhPqJUPFdpC0oTuPsZpZMuOGfqLB27Xq1NP2ZsNo+e83fZy3VcYigrl
	 FYQrN11NDNPrQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2 2/3] erofs-utils: mkfs: introduce ddev_id_def
Date: Wed,  2 Sep 2026 23:53:31 +0800
Message-ID: <20260902155333.57247-2-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902155333.57247-1-xiang@kernel.org>
References: <20260902155333.57247-1-xiang@kernel.org>
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
index dcb7dfe..5a90991 100644
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
index ce29319..688e474 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1941,7 +1941,8 @@ int main(int argc, char **argv)
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


