Return-Path: <linux-erofs+bounces-4468-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A2CDC61DD3
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 14:29:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbMS44LxZz2yDr;
	Fri, 04 Sep 2026 00:29:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788445780;
	cv=none; b=n1JoAQnQjYpaw2cWHIgxIaQWRbKlna1ioO3cbKW4E3/NBqlxZ1RqdyRGVqBaEXTInaheA9lssw/bKJjnzxshkpLVL55jmnug/ujPlwtdphAOx7Y1fAuO3JUneyTqVhLC9poAnWwkSIflYnsx5/boxVHNzqoXZ4zS916x7pZohl0pSjUswQrmRGmICxyswgMlQxZfPq/f8jqsgW7Dg5aO1VwN9Ao5KSW7uDTvLAH1tZcLv6hiEZx+m/aBoKNtvdlReWyuGuZSXY4lxa7pNs6g3F6UMka2Pixn7CK6vsFYvZ3qQSxPANrMQwqGZi4NgDam0OVixDZQniTw5xMljhYiyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788445780; c=relaxed/relaxed;
	bh=vhUZTqNa/p6fi0f//Ohc7Sk8mdZj6Nh5HCM0lRwe13Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NUx98f90kKlQ25D/YvdKGGL8bVE0iOAFGZ+AhEF/o4WGXm51jbK50nY/8I+C2nt+A0DPCu9TmjqYcbqFPZ28+meWLfTy9eFnlaUQDg8qRsmatVa4fK9ZoRUZc9mE9sYq24pY8g0kBDKU0FP+9+VruHTrNBtPrP6Voe9yyGjIT2I90iQ14nomy3DZYMf5+6dohzuAnSgg0ooMOH/eFGJFpG01hVs1MAG02iHsTAbZ326XzclIcoTHu5Jmp8fxS4YKCUSxQY3A9GiExgmkDGFLtOKanrJbxKPMskI2rr4FG3eyONI1pOAE/zs3+HtAs7gt1bj0QpGQJoKfvDYilykeeg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnCAQvU2; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnCAQvU2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbMS24v5xz2y71
	for <linux-erofs@lists.ozlabs.org>; Fri, 04 Sep 2026 00:29:38 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C07E60546;
	Thu,  3 Sep 2026 14:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4FC1F00ACF;
	Thu,  3 Sep 2026 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788445775;
	bh=vhUZTqNa/p6fi0f//Ohc7Sk8mdZj6Nh5HCM0lRwe13Q=;
	h=From:To:Cc:Subject:Date;
	b=bnCAQvU2rfO6eEEJ+2Gj+D/LyEEJSf78NjgVCbt84ifDTjaZQgdTUxvanalBwynvh
	 AUCR8IrjuZELezIplFoidL5NKAsEkr/P94OV1/FAivlDQKkUs7SQd8ZG+MOo2FbuCz
	 Bb62pAoTU7n06XDYK2/ke40cou8jnMftTbZq0aGQ2u2iFGynA5aZ7Btkx3pZcWjxfQ
	 e+GCfMYitqFY4/FKMqwwSBhtPkorC2I62N5nBN2gTrpZga1BGi9rsBSIak98dVjGdp
	 4SXPyjAgDs4u5LSVPJRPvMSRxKLdeC7a1sWfw2e44kF9aCKt4ZI/6yZPEeZBSDsEQh
	 aZXuTcNWhWYjA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	"Walther, Jens-Uwe" <waltju@amazon.de>,
	Yann Collet <yann.collet.73@gmail.com>
Subject: [PATCH] erofs: disable LZ4 rolling decompression for now
Date: Thu,  3 Sep 2026 22:28:41 +0800
Message-ID: <20260903142841.4465-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

LZ4 rolling decompression [1] was introduced to reduce the memory
footprint of temporary pages:

 For many cases, it is needed for users to read small data within
 a compressed extent (pcluster), either due to random small read, or
 since uptodate folios (typically order-0) cannot be reused for
 decompression again since decompression algorithm refills
 already-uptodate folios.

Rolling decompression works because LZ4 is LZ77-based and only refers
to the most recent 64 KiB of decompressed data, so in theory only a
bounded rolling window of temporary pages is needed when decompressing.

It can save a lot of temporary memory, e.g.
 601,960-byte data can be compressed into a 256k LZ4 compressed extent,
 which means it needs 146 extra pages per request in the worst case if
 rolling decompression is disabled.

However, the upstream LZ4 implementation is not under EROFS' control:
For example, the literal copy memmove() may still **copy long literals
backward** on x86 based on the address comparison even when the source
and destination ranges do not overlap (IOWs, inline decompression
doesn't need to be considered here). That breaks the rolling assumption
and makes the optimization broken.

Disable it for now to make sure the data correctness first since EROFS
is used everywhere now: The rolling window approach can be revived once
we either ensure that the official LZ4 code always copies forward for
non-overlapping ranges or maintain our own LZ4 implementation in EROFS.

The main impact is a higher runtime memory footprint; However, recent
commit 0f6273ab4637 ("erofs: add a reserved buffer pool for lz4
decompression") helps mitigate this when enabled but it's still not
perfect.

[1] https://www.usenix.org/conference/atc19/presentation/gao
    § 3.3 Decompression

Reported-by: "Walther, Jens-Uwe" <waltju@amazon.de>
Closes: https://lore.kernel.org/r/BEZP281MB2102E57CD31862B8D958B33DD2AC2@BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM
Fixes: 8e6c8fa9f2e9 ("erofs: enable big pcluster feature")
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 fs/erofs/decompressor.c | 55 +++++++++--------------------------------
 fs/erofs/internal.h     |  6 +----
 fs/erofs/zdata.c        | 18 +++-----------
 3 files changed, 16 insertions(+), 63 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 27caf4bebddc..d387b27c4ee2 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -7,8 +7,6 @@
 #include "compress.h"
 #include <linux/lz4.h>
 
-#define LZ4_MAX_DISTANCE_PAGES	(DIV_ROUND_UP(LZ4_DISTANCE_MAX, PAGE_SIZE) + 1)
-
 static int z_erofs_load_lz4_config(struct super_block *sb,
 			    struct erofs_super_block *dsb, void *data, int size)
 {
@@ -21,8 +19,6 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 			erofs_err(sb, "invalid lz4 cfgs, size=%u", size);
 			return -EINVAL;
 		}
-		distance = le16_to_cpu(lz4->max_distance);
-
 		sbi->lz4.max_pclusterblks = le16_to_cpu(lz4->max_pclusterblks);
 		if (!sbi->lz4.max_pclusterblks) {
 			sbi->lz4.max_pclusterblks = 1;	/* reserved case */
@@ -39,45 +35,25 @@ static int z_erofs_load_lz4_config(struct super_block *sb,
 		sbi->lz4.max_pclusterblks = 1;
 		sbi->available_compr_algs = 1 << Z_EROFS_COMPRESSION_LZ4;
 	}
-
-	sbi->lz4.max_distance_pages = distance ?
-					DIV_ROUND_UP(distance, PAGE_SIZE) + 1 :
-					LZ4_MAX_DISTANCE_PAGES;
 	return z_erofs_gbuf_growsize(sbi->lz4.max_pclusterblks);
 }
 
 /*
- * Fill all gaps with bounce pages if it's a sparse page list. Also check if
- * all physical pages are consecutive, which can be seen for moderate CR.
+ * Fill all gaps with bounce pages if it's a sparse page list (for example some
+ * folios are already uptodate and thus can be mapped into userspace). Also
+ * check if pages are physically consecutive, which can be seen for moderate CR.
  */
-static int z_erofs_lz4_prepare_dstpages(struct z_erofs_decompress_req *rq,
-					struct page **pagepool)
+static int z_erofs_oneshot_prepare_dstpages(struct z_erofs_decompress_req *rq,
+					    struct page **pagepool)
 {
-	struct page *availables[LZ4_MAX_DISTANCE_PAGES] = { NULL };
-	unsigned long bounced[DIV_ROUND_UP(LZ4_MAX_DISTANCE_PAGES,
-					   BITS_PER_LONG)] = { 0 };
-	unsigned int lz4_max_distance_pages =
-				EROFS_SB(rq->sb)->lz4.max_distance_pages;
 	void *kaddr = NULL;
-	unsigned int i, j, top;
+	unsigned int i;
 
-	top = 0;
-	for (i = j = 0; i < rq->outpages; ++i, ++j) {
-		struct page *const page = rq->out[i];
-		struct page *victim;
-
-		if (j >= lz4_max_distance_pages)
-			j = 0;
-
-		/* 'valid' bounced can only be tested after a complete round */
-		if (!rq->fillgaps && test_bit(j, bounced)) {
-			DBG_BUGON(i < lz4_max_distance_pages);
-			DBG_BUGON(top >= lz4_max_distance_pages);
-			availables[top++] = rq->out[i - lz4_max_distance_pages];
-		}
+	for (i = 0; i < rq->outpages; ++i) {
+		struct page *page, *victim;
 
+		page = rq->out[i];
 		if (page) {
-			__clear_bit(j, bounced);
 			if (!PageHighMem(page)) {
 				if (!i) {
 					kaddr = page_address(page);
@@ -89,21 +65,14 @@ static int z_erofs_lz4_prepare_dstpages(struct z_erofs_decompress_req *rq,
 					continue;
 				}
 			}
-			kaddr = NULL;
-			continue;
-		}
-		kaddr = NULL;
-		__set_bit(j, bounced);
-
-		if (top) {
-			victim = availables[--top];
 		} else {
 			victim = __erofs_allocpage(pagepool, rq->gfp, true);
 			if (!victim)
 				return -ENOMEM;
 			set_page_private(victim, Z_EROFS_SHORTLIVED_PAGE);
+			rq->out[i] = victim;
 		}
-		rq->out[i] = victim;
+		kaddr = NULL;
 	}
 	return kaddr ? 1 : 0;
 }
@@ -266,7 +235,7 @@ static const char *z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq,
 		dst_maptype = 0;
 	} else {
 		/* general decoding path which can be used for all cases */
-		ret = z_erofs_lz4_prepare_dstpages(rq, pagepool);
+		ret = z_erofs_oneshot_prepare_dstpages(rq, pagepool);
 		if (ret < 0)
 			return ERR_PTR(ret);
 		if (ret > 0) {
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 65974e57aebf..12e3a5b80a5a 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -71,12 +71,8 @@ struct erofs_dev_context {
 	bool flatdev;
 };
 
-/* all filesystem-wide lz4 configurations */
 struct erofs_sb_lz4_info {
-	/* # of pages needed for EROFS lz4 rolling decompression */
-	u16 max_distance_pages;
-	/* maximum possible blocks for pclusters in the filesystem */
-	u16 max_pclusterblks;
+	u16 max_pclusterblks;	/* maximum physical blocks for LZ4 pclusters */
 };
 
 struct erofs_xattr_prefix_item {
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e1e25ca0d190..6b07e73ee2aa 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1259,7 +1259,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 	const struct z_erofs_decompressor *alg =
 				z_erofs_decomp[pcl->algorithmformat];
 	bool try_free = true;
-	int i, j, jtop, err2, err = eio ? -EIO : 0;
+	int i, err2, err = eio ? -EIO : 0;
 	struct page *page;
 	bool overlapped;
 	const char *reason;
@@ -1348,7 +1348,6 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 	    be->compressed_pages >= be->onstack_pages + Z_EROFS_ONSTACK_PAGES)
 		kvfree(be->compressed_pages);
 
-	jtop = 0;
 	z_erofs_fill_other_copies(be, err);
 	for (i = 0; i < be->nr_pages; ++i) {
 		page = be->decompressed_pages[i];
@@ -1356,22 +1355,11 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 			continue;
 
 		DBG_BUGON(z_erofs_page_is_invalidated(page));
-		if (!z_erofs_is_shortlived_page(page)) {
+		if (!z_erofs_is_shortlived_page(page))
 			erofs_onlinefolio_end(page_folio(page), err, true);
-			continue;
-		}
-		if (pcl->algorithmformat != Z_EROFS_COMPRESSION_LZ4) {
+		else
 			erofs_pagepool_add(be->pagepool, page);
-			continue;
-		}
-		for (j = 0; j < jtop && be->decompressed_pages[j] != page; ++j)
-			;
-		if (j >= jtop)	/* this bounce page is newly detected */
-			be->decompressed_pages[jtop++] = page;
 	}
-	while (jtop)
-		erofs_pagepool_add(be->pagepool,
-				   be->decompressed_pages[--jtop]);
 	if (be->decompressed_pages != be->onstack_pages)
 		kvfree(be->decompressed_pages);
 
-- 
2.47.3


