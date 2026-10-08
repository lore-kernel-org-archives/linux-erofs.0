Return-Path: <linux-erofs+bounces-4682-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC69CA600D
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Oct 2026 19:08:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0zzq72x2z2yqs;
	Fri, 09 Oct 2026 06:08:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::132b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791486519;
	cv=none; b=hL5tptZdhranF6KKuR3zln588dNJU54owh3JmNVpItUzCQ8RiD43AMM2e98F6+TkR3KmIsafBjpP5XejIYQ5hWtH5ace4VCKf9VASKZ0cj9f03hwm2CBRQkFyEWCRg0GK17D0zkRgjZfFgwuQ35cJ/7bZSaLVpDobWaH+d2m2sEKY9RJqJrL3wdOcdB+vjYQcmhLgJulmC3+XirQZ0mpZcY87Uwyj7kj2lhdCBBlRvzin79dJM1+4QfDdeXrFK87mzUU9sAzPaKuLB0ko5zzNUjGVJVPyyrdIHsO00r3lqN50sw6qpTg0sezFpCkR/wxAk5YzXGXi7657lGua9Ihsw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791486519; c=relaxed/relaxed;
	bh=89nlx+M34LzIrZosb2dO9gI0RPZyt6hlktU5w00KTX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgGE8/aKJ/KE4MHNpWNT5RrKiMWTmqpvmloEugI5f5iDJFr2Mqq2yNli5lX7fdrGTa1PsCIAbCZXnju8w62Na9cYnJxUJUg0A2v8yK3zLhGjD6dYhvYsX1Qq7eUkbo0YXgC5GXmKfyXYxn2H8Bs8fLojPqztaxR6sUjY+YocZsWeDzIK/Igh/hXniWXDUuyUH5PsjZTNp5Gw2Az5OzUA4zN/IS/C/TnfSnDPKrkA1cwd88Bdcqn/K4ZR+cKwl4QZGOMo5D8Nk/JHhSMD45uY2UbrgeCBW29BdvfdquBTHi+WH07n4tEtzWXot4OE0C9mDp1LRnyVilJjfxJkJcdWmQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=DckWARvs; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::132b; helo=mail-dy1-x132b.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org) smtp.mailfrom=trailofbits.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=DckWARvs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=trailofbits.com (client-ip=2607:f8b0:4864:20::132b; helo=mail-dy1-x132b.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x132b.google.com (mail-dy1-x132b.google.com [IPv6:2607:f8b0:4864:20::132b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0zzp6xWWz30Vb
	for <linux-erofs@lists.ozlabs.org>; Fri, 09 Oct 2026 06:08:38 +1100 (AEDT)
Received: by mail-dy1-x132b.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso3130575eec.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 12:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791486517; x=1792091317; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=89nlx+M34LzIrZosb2dO9gI0RPZyt6hlktU5w00KTX8=;
        b=DckWARvsc08NfR/jPaVpCG+CSYkfSQWTZKkpRbUeXCVxxNElClo/r8DytU3pINc7TH
         87aEKDYXvpVRTaL6C4WrMSSSSG59zHER10oW9zoudn1R9cV+oNgh8v4vvnHqDHAJP3UY
         rV27bz5KpgUm8tikww+Xrs0Vs2Q38ALPc1+caN9EltS2zDBs06HhVRAvYug7X9/hmJih
         SWsBNMywkCDmLz5RBwaL6qJpns198Bqfzm0sPmbuG7qIIUpjlD2dWm/8PC0Yh3uED7EL
         81I77AmyKCI1dYre/XwG7HIUJKkhdz2QCIN907dvDu1nwcntOyIb/uy2Wn+4IXRhnp/7
         yLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791486517; x=1792091317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=89nlx+M34LzIrZosb2dO9gI0RPZyt6hlktU5w00KTX8=;
        b=DCaRIc5oZpuC3UYhM9fD3/mGYhC7PwZO/Mk2L58GsDUT6RjbC9kWLynWFShUdkaLwy
         F51sUfgrdPWX4/eM16tm98pa+X9aBeq3VdwWHpLmWt1VcBL6d+6q6J+25PuMFOSEoGCL
         5qg5rA4QRfCiODsoHy+FH0O4NWO+zpTQ0WnxMb1P8vwl/tG6/XIsPxAxLHJJA1eCAQ0R
         s4kOm3O3XLfxZuk0/XF9PpttkqZVo8GTc8cjw78NbwJgy6B78R+GApinDlKD6+Y48D5e
         Mw/tnzqLUnbshc/1WEOOGt0+FivWSPi36aGdJZvYaj9Busrmu9UDHHBZgInJsODSf3tT
         THnQ==
X-Forwarded-Encrypted: i=1; AKwUvBwOXc3OQm/H+IpORxQYJMrgTHOB4uW1e4U5Wm7lGi2tXfwot2DufjkLWpLJT+c278LGLwt/TFXWNIJFPg==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKiv46SJzPSLy1uItoCuj9EiuWsNphMnQAOfGqc9oeVC+DzZuih
	0c3Fmj7jBvAwaRVhKlBqI46zLZoCeecfB6e3bchhfC42P8tVKrYG6SOtlpIElC/c/fU=
X-Gm-Gg: AYBFou2Rv5R2NBvowZYximKYK4CLeDLj/HHo5yUhWtvPb+ZGnuHJh7cZLZxV91+TQvg
	hOgNh17Ic4wwXB6feKNeu+mjndSS3jbiTiWsP2PQh/ZxE29aoGYHtHpKjPK0lssmfrUKR8C5tp6
	7HUORJOxEI77GFP/Za+D5iL/Sh39XCTOK1F4zjKloTQhRPI2dYoXEEWBjmBD7f16Kzb+v4i2zoG
	4GZgvu4m/MT5ZXloGr6VWGJLWrT+AlKo4PHZdlJxv45xZKwOB5oqd9iGzp6P0iqgDxOzOqlj696
	T9ncaHgTXnkzC+wBYJ3qCKTRMKN+NU8dxM8W+j+sngd08RQm/10c++e5utQcCON6W2wcb/WR+4X
	oFGdSkoVBTMATteX11u1F8w1qXSa0eRLjectinDLIBqbDslDyPY5UYx1NAMO3doPn7D8wMxk6M4
	BEKuGnSMmar1mdqcq6+3lrxa+AKwyp11utZQr0ZW+dENc/A37bKW9l5Frjq6nSBpsrbwEkrW+YW
	vesai592gWejWttX2kZg/6tvMsSseMYLkkyRM7k7tv1AhIh9FQixiwH8gYrUnOtbbmRa50=
X-Received: by 2002:a05:693c:88d1:10b0:351:f762:a10c with SMTP id 5a478bee46e88-351f762a25bmr2478155eec.0.1791486516485;
        Thu, 08 Oct 2026 12:08:36 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bc88:5ec1:4f8a:5b23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537c841648sm80561eec.3.2026.10.08.12.08.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 12:08:36 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Yue Hu <zbestahu@gmail.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: [PATCH 6.6.y 2/2] erofs: unify lcn as u64 for 32-bit platforms
Date: Thu,  8 Oct 2026 15:08:28 -0400
Message-ID: <20261008190830.97970-3-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261008190830.97970-1-artem@trailofbits.com>
References: <20261008190830.97970-1-artem@trailofbits.com>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 2d8c7edcb661812249469f4a5b62e9339118846f ]

As sashiko reported [1], `lcn` was typed as `unsigned long` (or
`unsigned int` sometimes), which is only 32 bits wide on 32-bit
platforms, which causes `(lcn << lclusterbits)` to be truncated
at 4 GiB.

In order to consolidate the logic, just use `u64` consistently
around the codebase.

[1] https://sashiko.dev/r/20260420034612.1899973-1-hsiangkao%40linux.alibaba.com

[ Backport to 6.6.y: rebase after the CVE-2025-68251 compact-index
  validation change. Widen its new lcn diagnostic along with the
  recorder, full and compact loader data flow, lookback and compressed-
  length locals to u64. ]

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
This is patch 2 of 2 in the ordered 6.6.y backport series.
This change addresses CVE-2026-53015. The EROFS zmap implementation and the
preceding compact-index validation fix otherwise retain 32-bit lcn values
in shifts on 32-bit systems; widening the complete data flow and the
validation diagnostic to u64 prevents 4-GiB truncation without weakening
the new loop check.
This needed a target-specific adjustment; I called it out in the bracketed
backport note above.

The fix is absent from the pinned 6.6.y branch and queue and must follow
CVE-2025-68251 in this series.

 fs/erofs/zmap.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e53d5239f04d..990322b228cb 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -12,7 +12,7 @@ struct z_erofs_maprecorder {
 	struct erofs_map_blocks *map;
 	void *kaddr;
 
-	unsigned long lcn;
+	u64 lcn;
 	/* compression extent information gathered */
 	u8  type, headtype;
 	u16 clusterofs;
@@ -22,8 +22,7 @@ struct z_erofs_maprecorder {
 	bool partialref;
 };
 
-static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
-				      unsigned long lcn)
+static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m, u64 lcn)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -219,7 +218,7 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 }
 
 static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
-					 unsigned long lcn, bool lookahead)
+					 u64 lcn, bool lookahead)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -270,7 +269,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 }
 
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
-					   unsigned int lcn, bool lookahead)
+					   u64 lcn, bool lookahead)
 {
 	struct erofs_inode *vi = EROFS_I(m->inode);
 	int err;
@@ -289,7 +288,7 @@ static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 		return err;
 
 	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
-		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
+		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %llu of nid %llu",
 			  m->type, lcn, vi->nid);
 		DBG_BUGON(1);
 		return -EOPNOTSUPP;
@@ -310,7 +309,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
 
 	while (m->lcn >= lookback_distance) {
-		unsigned long lcn = m->lcn - lookback_distance;
+		u64 lcn = m->lcn - lookback_distance;
 		int err;
 
 		err = z_erofs_load_lcluster_from_disk(m, lcn, false);
@@ -330,14 +329,14 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 			m->map->m_la = (lcn << lclusterbits) | m->clusterofs;
 			return 0;
 		default:
-			erofs_err(sb, "unknown type %u @ lcn %lu of nid %llu",
+			erofs_err(sb, "unknown type %u @ lcn %llu of nid %llu",
 				  m->type, lcn, vi->nid);
 			DBG_BUGON(1);
 			return -EOPNOTSUPP;
 		}
 	}
 err_bogus:
-	erofs_err(sb, "bogus lookback distance %u @ lcn %lu of nid %llu",
+	erofs_err(sb, "bogus lookback distance %u @ lcn %llu of nid %llu",
 		  lookback_distance, m->lcn, vi->nid);
 	DBG_BUGON(1);
 	return -EFSCORRUPTED;
@@ -350,7 +349,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	struct erofs_inode *const vi = EROFS_I(m->inode);
 	struct erofs_map_blocks *const map = m->map;
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
-	unsigned long lcn;
+	u64 lcn;
 	int err;
 
 	DBG_BUGON(m->type != Z_EROFS_LCLUSTER_TYPE_PLAIN &&
@@ -402,7 +401,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 			break;
 		fallthrough;
 	default:
-		erofs_err(sb, "cannot found CBLKCNT @ lcn %lu of nid %llu", lcn,
+		erofs_err(sb, "cannot found CBLKCNT @ lcn %llu of nid %llu", lcn,
 			  vi->nid);
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
@@ -411,7 +410,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	map->m_plen = erofs_pos(sb, m->compressedblks);
 	return 0;
 err_bonus_cblkcnt:
-	erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
+	erofs_err(sb, "bogus CBLKCNT @ lcn %llu of nid %llu", lcn, vi->nid);
 	DBG_BUGON(1);
 	return -EFSCORRUPTED;
 }
-- 
2.39.5


