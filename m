Return-Path: <linux-erofs+bounces-3260-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFA6E99057
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 08:48:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsVpC5vxRz2yh4;
	Fri, 10 Apr 2026 18:48:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775810931;
	cv=none; b=cjziS0v4e5JiyzP6n7VwW8TWgq2Wv/tTy0LynGtsyqK8onPzYuvptSNl5zUHrC/2xXnayjSLPSCs7iz31P0L3dm5VGGUS93BEXbkF8JYf5OP3sUmmGecaWgFzVhN22+oSZmeqaQsjAEcd/XfcQw/FATV5xgmaZOziVbfIRwBNXXs62aUDTDZ9dsbVDMfPhPr5t9C2s9B5iHNaM1Ci5XYTDhjEsWK6sObpuAluwp2i+yaxP8ssIEDcRIYBkEtLy0Eb9VjEzh73ofDkq1/SBKbiWMFXycvndtrBV5l+0QytFvyiWl4JpGFFB4mLQH2/LveTH8RCylsTIMtMhfBer2wjw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775810931; c=relaxed/relaxed;
	bh=tqNbtPggJ3B4/RDiwTBdMUWCT75AH75+yMvI5oN8pFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToiMg0u1TM6C0mhDnTarvguTVRY+ro2MVqvBBxVFUeWWwUfcszGQQPIZxUSKoVvvgPP2DSeCuNfRwBJAOb79XIkRNIq6zKEWye9l6BTz45wyv4A3cLXtrDp8JP3kfkCOPxjvHpkcvD5a5hN1vcPbrCaM8Wv6PAG0sAkxYranEkejukmGpqCPDg71gxvG1U9fADewkz2cwPm5Dtc30pwpVbbpxmvNnfvflFPbB1VoK79B9GrWFZSyxfLD02CxNXbxJp3+uvwzHuKt5rD9T2WqTG72KH/UKRcPQBJGhKTgAI+V/IPiyDHybMOV3OXmU79mjR0nY3tm9yyB48U6gx7akw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kbaAAncQ; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kbaAAncQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsVpB0N9gz2xTh
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 18:48:49 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775810925; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=tqNbtPggJ3B4/RDiwTBdMUWCT75AH75+yMvI5oN8pFk=;
	b=kbaAAncQfAChCYaZ0YsCDrV/DoeR+1caj7p3kiKWEKqfwWwTURXk5OqgFAjj83cVjoNSfGaCjlWwFDnRxcfSNl0gxdsm/D5vXR+OaFxNle0wIzh4rQLQ90ZqvbP9HdJFNQaOWpCdbfKTzdxdcMK7eXJxYIpT5aFueFK/O6uVRo4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X0kmhbe_1775810924;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0kmhbe_1775810924 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 16:48:44 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 2/2] erofs: error out obviously illegal extents in advance
Date: Fri, 10 Apr 2026 16:48:38 +0800
Message-ID: <20260410084838.512795-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260410084838.512795-1-hsiangkao@linux.alibaba.com>
References: <20260410084838.512795-1-hsiangkao@linux.alibaba.com>
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

Detect some corrupted extent cases during metadata parsing rather
than letting them result in harmless decompression failures later:

 - For full-reference compressed extents, the compressed size must
   not exceed the decompressed size, which is a strict on-disk
   layout constraint;

 - For plain (shifted/interlaced) extents, the decoded size must
   not exceed the encoded size, even accounting for partial decoding.

Both ways work but it should be better to report illegal extents as
metadata layout violations rather than deferring as decompression
failure.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/decompressor.c |  1 -
 fs/erofs/zmap.c         | 24 +++++++++++++++---------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 2b065f8c3f71..3c54e95964c9 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -145,7 +145,6 @@ static void *z_erofs_lz4_handle_overlap(const struct z_erofs_decompress_req *rq,
 	oend = rq->pageofs_out + rq->outputsize;
 	omargin = PAGE_ALIGN(oend) - oend;
 	if (!rq->partial_decoding && may_inplace &&
-	    rq->outpages >= rq->inpages &&
 	    omargin >= LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize)) {
 		for (i = 0; i < rq->inpages; ++i)
 			if (rq->out[rq->outpages - rq->inpages + i] !=
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 67f55b9b57af..72b96e295716 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -473,11 +473,6 @@ static int z_erofs_map_blocks_fo(struct inode *inode,
 	}
 
 	if (m.headtype == Z_EROFS_LCLUSTER_TYPE_PLAIN) {
-		if (map->m_llen > map->m_plen) {
-			DBG_BUGON(1);
-			err = -EFSCORRUPTED;
-			goto unmap_out;
-		}
 		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_INTERLACED;
 		else
@@ -720,10 +715,21 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 			  map->m_algorithmformat, map->m_la, EROFS_I(inode)->nid);
 		return -EOPNOTSUPP;
 	}
-	if (unlikely(map->m_algorithmformat < Z_EROFS_COMPRESSION_MAX &&
-		     !(sbi->available_compr_algs & (1 << map->m_algorithmformat)))) {
-		erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
-			  map->m_algorithmformat, EROFS_I(inode)->nid);
+
+	if (map->m_algorithmformat < Z_EROFS_COMPRESSION_MAX) {
+		if (sbi->available_compr_algs ^ BIT(map->m_algorithmformat)) {
+			erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
+				  map->m_algorithmformat, EROFS_I(inode)->nid);
+			return -EFSCORRUPTED;
+		}
+		if (EROFS_MAP_FULL(map->m_flags) && map->m_llen < map->m_plen) {
+			erofs_err(inode->i_sb, "too much compressed data @ la %llu of nid %llu",
+				  map->m_la, EROFS_I(inode)->nid);
+			return -EFSCORRUPTED;
+		}
+	} else if (map->m_llen > map->m_plen) {
+		erofs_err(inode->i_sb, "not enough plain data on disk @ la %llu of nid %llu",
+			  map->m_la, EROFS_I(inode)->nid);
 		return -EFSCORRUPTED;
 	}
 	if (unlikely(map->m_plen > Z_EROFS_PCLUSTER_MAX_SIZE ||
-- 
2.43.5


