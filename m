Return-Path: <linux-erofs+bounces-4221-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD26C5B572
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Aug 2026 08:15:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hLw5d3HlGz2yS0;
	Fri, 14 Aug 2026 18:15:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786695333;
	cv=none; b=nIuXTb9UT6T4DOzy8hSRZnQHLnNyf/7kLhmCJfC8RjmIPfm/4vklf9fqPvBww4v1mj46R6Yc4kkF1ugED1ft3gJ8j++JdG1AoF07HcQ5cPseYIOxsFl32d5liSR8UauspMlFNhugtqbLWc59/C2AL98qOd1yAqPtTP285gsbMz1t+EqNOpFAuOwvX2+1UxUe6j0dKcWKoItwmq3O8+1Mg77j4q3NHbnQw72B4D5JYuU3dyH/zZcX/FApJHXDh54Rxv8c1naV4KgKKYwxv97Fp23hivsL/zNl/GAO2KnWZj5V9HqZOVmz+KSxOF4ueUp732NBM94bLyGnd4fSkRzLog==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786695333; c=relaxed/relaxed;
	bh=jckIxw0rkLhWWXhIRUjCuN+lX9WBmeMyUIC/hbpvBdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LHD8sNMGIqeEae+QTVVYSKcXxedsHIojZAwGAmAkHRVWT29UfDq3ZiBurEIh8yvgONce3S2dy7chkfQlcUH2JPYZ1YI4mMILYHxAWWgv7/auJ3nuPWzatBCWb/MeQLT1bxQLc8MvLEuZ3ys4qrXXGC/L/H8qojPcB47cKW3X8oLy9JA9jc7lSxCRu/TFC5BRQ9xGF4TvMyUrajqMiaijIv6o8gIZOWtC+kESKQCKD5DycOl7BS2Y6Bc0YZhJGxxQbC1/vNf/RKMgDa39KfvWNh9/Y/A7ueRAXRyfsuEa+GSXWVyBAG4yH7Aod6MoyfEKDYClCThY6rhrxCjF+V8ZPg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K1rmHYbL; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K1rmHYbL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hLw5c38cHz2y8G
	for <linux-erofs@lists.ozlabs.org>; Fri, 14 Aug 2026 18:15:32 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C711600C3
	for <linux-erofs@lists.ozlabs.org>; Fri, 14 Aug 2026 08:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9ED1F000E9;
	Fri, 14 Aug 2026 08:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786695328;
	bh=jckIxw0rkLhWWXhIRUjCuN+lX9WBmeMyUIC/hbpvBdI=;
	h=From:To:Cc:Subject:Date;
	b=K1rmHYbLa6hKygwV4D3FtKsmInhDmW04X+JojGwmzJM0bivmcaxp47TIvgtjD76tM
	 5Jqe9L25bzwmC+DAPTeG9ulYzuc61B1AzBGIV6GC+jHhSZms+2ynkN0LaX/sClOTwY
	 XPt+fdpDayK+/O8cO6ULmuqOZsVm9zBv0eAv7kfphxtvQJDC7GjhWuuJIhxvZ2l97a
	 8dC513Y7W4U7PtBENfgxBAnfRDeNorj/ID0mLbsUuEVeDiJQv68b3tFaAy8Llta0n7
	 La0CJ6nRPvhgH5KL9lo0RACkAOw0/lbd4+JT1AKi4c7XQzV3sF6CR6PtGd6vcqkt8r
	 YidHXggAxVcTw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs: guard on-disk algorithm IDs against Z_EROFS_COMPRESSION_MAX
Date: Fri, 14 Aug 2026 16:14:37 +0800
Message-ID: <20260814081437.86684-1-xiang@kernel.org>
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
Content-Transfer-Encoding: 8bit

All on-disk algorithm IDs should be validated against
supported Z_EROFS_COMPRESSION_MAX.

This includes a partial revert of a previous commit and also adds
validation for encoded extents.

Fixes: 131897c65e2b ("erofs: fix invalid algorithm for encoded extents")
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 fs/erofs/internal.h |  2 +-
 fs/erofs/zmap.c     | 35 +++++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 6de6e5a58e6b..9b7370f0f3df 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -267,7 +267,7 @@ struct erofs_inode {
 #ifdef CONFIG_EROFS_FS_ZIP
 		struct {
 			unsigned short z_advise;
-			unsigned char  z_algorithmtype[2];
+			unsigned char  z_algofmt[2];
 			unsigned char  z_lclusterbits;
 			union {
 				u64    z_tailextent_headlcn;
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index b5411b579fd9..b316a50efe38 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -488,10 +488,9 @@ static int z_erofs_map_blocks_fo(struct inode *inode,
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_INTERLACED;
 		else
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_SHIFTED;
-	} else if (m.headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2) {
-		map->m_algorithmformat = vi->z_algorithmtype[1];
 	} else {
-		map->m_algorithmformat = vi->z_algorithmtype[0];
+		map->m_algorithmformat =
+			vi->z_algofmt[m.headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2];
 	}
 
 	if ((flags & EROFS_GET_BLOCKS_FIEMAP) ||
@@ -605,9 +604,14 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 			if (map->m_plen & Z_EROFS_EXTENT_PLEN_PARTIAL)
 				map->m_flags |= EROFS_MAP_PARTIAL_REF;
 			map->m_plen &= Z_EROFS_EXTENT_PLEN_MASK;
-			if (fmt)
-				map->m_algorithmformat = fmt - 1;
-			else if (interlaced && !((map->m_pa | map->m_plen) & bmask))
+			if (fmt) {
+				map->m_algorithmformat = --fmt;
+				if (fmt >= Z_EROFS_COMPRESSION_MAX) {
+					erofs_err(sb, "unknown algorithm %d @ pos %llu for nid %llu, please upgrade kernel",
+						  fmt, map->m_la, vi->nid);
+					return -EOPNOTSUPP;
+				}
+			} else if (interlaced && !((map->m_pa | map->m_plen) & bmask))
 				map->m_algorithmformat =
 					Z_EROFS_COMPRESSION_INTERLACED;
 			else
@@ -625,7 +629,7 @@ static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 	struct super_block *const sb = inode->i_sb;
 	struct z_erofs_map_header *h;
 	erofs_off_t pos;
-	int err = 0;
+	int err = 0, nr;
 
 	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
 		/*
@@ -668,12 +672,19 @@ static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 		goto done;
 	}
 
-	vi->z_algorithmtype[0] = h->h_algorithmtype & 15;
-	vi->z_algorithmtype[1] = h->h_algorithmtype >> 4;
 	if (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER)
 		vi->z_fragmentoff = le32_to_cpu(h->h_fragmentoff);
 	else if (vi->z_advise & Z_EROFS_ADVISE_INLINE_PCLUSTER)
 		vi->z_idata_size = le16_to_cpu(h->h_idata_size);
+	for (nr = 0; nr < 2; ++nr) {
+		vi->z_algofmt[nr] = (h->h_algorithmtype >> (4 * nr)) & 15;
+		if (vi->z_algofmt[nr] >= Z_EROFS_COMPRESSION_MAX) {
+			erofs_err(sb, "unknown HEAD%u format %u for nid %llu, please upgrade kernel",
+				  nr + 1, vi->z_algofmt[nr], vi->nid);
+			err = -EOPNOTSUPP;
+			goto out_unlock;
+		}
+	}
 
 	if (!erofs_sb_has_big_pcluster(EROFS_SB(sb)) &&
 	    vi->z_advise & (Z_EROFS_ADVISE_BIG_PCLUSTER_1 |
@@ -721,12 +732,8 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 
 	if (!(map->m_flags & EROFS_MAP_MAPPED))
 		return 0;
-	if (unlikely(map->m_algorithmformat >= Z_EROFS_COMPRESSION_RUNTIME_MAX)) {
-		erofs_err(inode->i_sb, "unknown algorithm %d @ pos %llu for nid %llu, please upgrade kernel",
-			  map->m_algorithmformat, map->m_la, EROFS_I(inode)->nid);
-		return -EOPNOTSUPP;
-	}
 
+	DBG_BUGON(map->m_algorithmformat >= Z_EROFS_COMPRESSION_RUNTIME_MAX);
 	if (map->m_algorithmformat < Z_EROFS_COMPRESSION_MAX) {
 		if (!(sbi->available_compr_algs & BIT(map->m_algorithmformat))) {
 			erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
-- 
2.47.3


