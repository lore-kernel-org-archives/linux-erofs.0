Return-Path: <linux-erofs+bounces-3589-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658C4CD98C5
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jun 2026 05:10:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gdyqs3wQcz3bqD;
	Mon, 15 Jun 2026 15:10:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781500233;
	cv=none; b=CjhyS4TkXXVBEQDD8k/u2UzYLZsb5SOLQ2MbJZ8BsB3EhKipqhrXcXAxH/J1G9YRdpRyzG4tngJPGwv1FEGRMSg0PHZRWyV/m74hIDHU1AmTql3+TsDxlbtxRjVcqG1PRd9+7M+d0Iil1Ibn5tXn9Hqr2J/kYyvP9fuZHIxJOCxJEzJIaWq3GLKccfFqJoamK6mw9VUBy/uZ/UqEDYUpCeK0+NzsXbdXBoJ4bfxDkJfjSN7BjVmWor0CPVFtVChmyMBWKNwm2YST+FkFWdPYM2BYPcD/R03YPQvBsoqxKx8Y5rckgwEAv1he11OgbVzNecfWDCviWTiCsvoXfIi8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781500233; c=relaxed/relaxed;
	bh=qrZoHhpZ8qiUfDzxaLwT9t9rEuEsMXrsfA9Z/wGiJ8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D60Wc8C/yVJium7H67h3nPGjnudDKg588RmngKPho5cG4wIRBucx0BCgftPp61SoK/J5fthtVAYhrw6Qe37U59+BviwRz7Zid1znh9JW/NlbV+xNvdolMp+TeyoLGYZ8GIgpzOCD1/IRPprAVrLLchVqGYTaiIP+GAqD5yCvCPTLR5S78JSuBtnQ0pzLuGWrIEngoXKryjv8Dny3XjmB4sKao/r2l7SRSVO9fCOVIJMcQtk65XaZ8RzeeuemMTpvUuOrjqiBiBrMQoJqk2M5N6/5SPZy6Q38I3qsaym+1cheeAcRa4O9VNIgU7IfDDlzg7jOhKocNCReAifvRLTQMw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=whwiyzpb; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=whwiyzpb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gdyqp4Skpz2xtC
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 15:10:28 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781500223; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qrZoHhpZ8qiUfDzxaLwT9t9rEuEsMXrsfA9Z/wGiJ8U=;
	b=whwiyzpb87nXCdoZA40Ga6TRll6YOxTDmFRaOuR7Ny5K1+yK8tMAObvCBCsw8fKiEx4MfNAbe3oHGTLvfouxSbhH3mJwFKF8D+RltX7aK5T20iaWYfP53vPbi7IIqe9kS5ilaIiAXaVJdunjL/9AadhA6Sfk8kYcYajklapKuew=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X4pAs62_1781500217;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4pAs62_1781500217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 13:10:21 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs: introduce erofs_map_chunks()
Date: Mon, 15 Jun 2026 13:10:16 +0800
Message-ID: <20260615051016.27430-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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

Try to map more chunks in the same metadata on-disk block for
more efficient IO performance.

Also unset `map->m_plen` since it's unneeded for plain data.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/data.c | 126 +++++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 60 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 44da21c9d777..f75c391b098a 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -98,17 +98,69 @@ void *erofs_read_metabuf(struct erofs_buf *buf, struct super_block *sb,
 	return erofs_bread(buf, offset, true);
 }
 
-int erofs_map_blocks(struct inode *inode, struct erofs_map_blocks *map)
+static int erofs_map_chunks(struct inode *inode, struct erofs_map_blocks *map)
 {
 	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
 	struct super_block *sb = inode->i_sb;
-	unsigned int unit, blksz = sb->s_blocksize;
 	struct erofs_inode *vi = EROFS_I(inode);
 	struct erofs_inode_chunk_index *idx;
-	erofs_blk_t startblk, addrmask;
-	bool tailpacking;
+	unsigned int unit = vi->chunkformat & EROFS_CHUNK_FORMAT_INDEXES ?
+		sizeof(*idx) : EROFS_BLOCK_MAP_ENTRY_SIZE;
+	erofs_blk_t addrmask = (vi->chunkformat & EROFS_CHUNK_FORMAT_48BIT) ?
+		BIT_ULL(48) - 1 : BIT_ULL(32) - 1;
+	u64 nr = map->m_la >> vi->chunkbits;
+	erofs_off_t pos = ALIGN(erofs_iloc(inode) + vi->inode_isize +
+				vi->xattr_isize, unit) + unit * nr;
+	erofs_off_t endpos = round_up(pos, sb->s_blocksize);
+	u64 last, addr;
+
+	idx = erofs_read_metabuf(&buf, sb, pos, erofs_inode_in_metabox(inode));
+	if (IS_ERR(idx))
+		return PTR_ERR(idx);
+
+	map->m_la = nr << vi->chunkbits;
+	map->m_llen = 0;
+	nr = 0;
+	do {
+		if (unit == EROFS_BLOCK_MAP_ENTRY_SIZE) {
+			addr = le32_to_cpu(((__le32 *)idx)[nr]);
+			if (addr == (u32)EROFS_NULL_ADDR)
+				addr = EROFS_NULL_ADDR;
+		} else {
+			addr = (((u64)le16_to_cpu(idx[nr].startblk_hi) << 32) |
+				le32_to_cpu(idx[nr].startblk_lo)) & addrmask;
+			if (addr ^ (EROFS_NULL_ADDR & addrmask))
+				addr |= (u64)(le16_to_cpu(idx[nr].device_id) &
+					EROFS_SB(sb)->device_id_mask) << 48;
+			else
+				addr = EROFS_NULL_ADDR;
+		}
+		if (!nr) {
+			last = addr;
+		} else {
+			if (last != EROFS_NULL_ADDR)
+				last += erofs_blknr(sb, 1UL << vi->chunkbits);
+			map->m_llen += 1UL << vi->chunkbits;
+		}
+	} while (addr == last && pos + (++nr) * unit < endpos);
+
+	if (last != EROFS_NULL_ADDR) {
+		map->m_pa = erofs_pos(sb, last & addrmask) - map->m_llen;
+		map->m_deviceid = last >> 48;
+		map->m_flags = EROFS_MAP_MAPPED;
+	}
+	map->m_llen = min_t(erofs_off_t, map->m_llen + (1UL << vi->chunkbits),
+			round_up(inode->i_size - map->m_la, sb->s_blocksize));
+	erofs_put_metabuf(&buf);
+	return 0;
+}
+
+int erofs_map_blocks(struct inode *inode, struct erofs_map_blocks *map)
+{
+	struct super_block *sb = inode->i_sb;
+	struct erofs_inode *vi = EROFS_I(inode);
+	bool tailinline = (vi->datalayout == EROFS_INODE_FLAT_INLINE);
 	erofs_off_t pos;
-	u64 chunknr;
 	int err = 0;
 
 	trace_erofs_map_blocks_enter(inode, map, 0);
@@ -116,13 +168,10 @@ int erofs_map_blocks(struct inode *inode, struct erofs_map_blocks *map)
 	map->m_flags = 0;
 	if (map->m_la >= inode->i_size)
 		goto out;
-
-	if (vi->datalayout != EROFS_INODE_CHUNK_BASED) {
-		tailpacking = (vi->datalayout == EROFS_INODE_FLAT_INLINE);
-		if (!tailpacking && vi->startblk == EROFS_NULL_ADDR)
-			goto out;
-		pos = erofs_pos(sb, erofs_iblks(inode) - tailpacking);
-
+	if (vi->datalayout == EROFS_INODE_CHUNK_BASED) {
+		err = erofs_map_chunks(inode, map);
+	} else if (tailinline || vi->startblk != EROFS_NULL_ADDR) {
+		pos = erofs_pos(sb, erofs_iblks(inode) - tailinline);
 		map->m_flags = EROFS_MAP_MAPPED;
 		if (map->m_la < pos) {
 			map->m_pa = erofs_pos(sb, vi->startblk) + map->m_la;
@@ -132,57 +181,14 @@ int erofs_map_blocks(struct inode *inode, struct erofs_map_blocks *map)
 				vi->xattr_isize + erofs_blkoff(sb, map->m_la);
 			map->m_llen = inode->i_size - map->m_la;
 			map->m_flags |= EROFS_MAP_META;
-		}
-		goto out;
-	}
-
-	if (vi->chunkformat & EROFS_CHUNK_FORMAT_INDEXES)
-		unit = sizeof(*idx);			/* chunk index */
-	else
-		unit = EROFS_BLOCK_MAP_ENTRY_SIZE;	/* block map */
-
-	chunknr = map->m_la >> vi->chunkbits;
-	pos = ALIGN(erofs_iloc(inode) + vi->inode_isize +
-		    vi->xattr_isize, unit) + unit * chunknr;
-
-	idx = erofs_read_metabuf(&buf, sb, pos, erofs_inode_in_metabox(inode));
-	if (IS_ERR(idx)) {
-		err = PTR_ERR(idx);
-		goto out;
-	}
-	map->m_la = chunknr << vi->chunkbits;
-	map->m_llen = min_t(erofs_off_t, 1UL << vi->chunkbits,
-			    round_up(inode->i_size - map->m_la, blksz));
-	if (vi->chunkformat & EROFS_CHUNK_FORMAT_INDEXES) {
-		addrmask = (vi->chunkformat & EROFS_CHUNK_FORMAT_48BIT) ?
-			BIT_ULL(48) - 1 : BIT_ULL(32) - 1;
-		startblk = (((u64)le16_to_cpu(idx->startblk_hi) << 32) |
-			    le32_to_cpu(idx->startblk_lo)) & addrmask;
-		if ((startblk ^ EROFS_NULL_ADDR) & addrmask) {
-			map->m_deviceid = le16_to_cpu(idx->device_id) &
-				EROFS_SB(sb)->device_id_mask;
-			map->m_pa = erofs_pos(sb, startblk);
-			map->m_flags = EROFS_MAP_MAPPED;
-		}
-	} else {
-		startblk = le32_to_cpu(*(__le32 *)idx);
-		if (startblk != (u32)EROFS_NULL_ADDR) {
-			map->m_pa = erofs_pos(sb, startblk);
-			map->m_flags = EROFS_MAP_MAPPED;
+			if (erofs_blkoff(sb, map->m_pa) + map->m_llen >
+			    sb->s_blocksize) {
+				erofs_err(sb, "inline data across blocks @ nid %llu", vi->nid);
+				return -EFSCORRUPTED;
+			}
 		}
 	}
-	erofs_put_metabuf(&buf);
 out:
-	if (!err) {
-		map->m_plen = map->m_llen;
-		/* inline data should be located in the same meta block */
-		if ((map->m_flags & EROFS_MAP_META) &&
-		    erofs_blkoff(sb, map->m_pa) + map->m_plen > blksz) {
-			erofs_err(sb, "inline data across blocks @ nid %llu", vi->nid);
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
-	}
 	trace_erofs_map_blocks_exit(inode, map, 0, err);
 	return err;
 }
-- 
2.43.5


