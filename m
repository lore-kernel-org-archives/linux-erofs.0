Return-Path: <linux-erofs+bounces-2697-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B804ED58B0F
	for <linux-erofs@archiver.kernel.org>; Sun, 15 Mar 2026 07:28:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYVF91t9Zz2yYy;
	Sun, 15 Mar 2026 18:28:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::635"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773559693;
	cv=none; b=cbnxqSHA0dmZSzm8wwtXP0eHKWNCbSZwPMXnYgzc7t3fKEXZrAifbPKgO+Co/3WG4BQ0mvmNxGguRmeU9GIzUffvi8IvnTuutrD35xway6uXotn8Q8DpNsysvVUOWlWujzGYdYQF1kFCkO7XXTtlCdvRg13BD7GK1W4cjpB1A1nFPSL2JnCKrvC5Avr5jjx6k+JSWMIXHEtEB2aGrJ/bG4Rj4CWFwIc41ds0neG70WslSXh5iDvJpp/PvnhzbfnYfPwIovzV+vmMpmc8hPBpoxl4CZwagyg+M9vkpGyuWImZFKU4dfl423WyMkaIAOMyooukL65YfxE14RENcTblWw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773559693; c=relaxed/relaxed;
	bh=y8W3tue+BUXzjzsC0JnskebSQQUL9HGt1yDKVVOjktk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KvHYXz3dU80YPUvsvnGUSe8SWy0w0zCC1H/Voi+GknooMpeQScG0d5v2InLeNnJgBkxPnW0zb3Ii7kFIsW0QOn0Vz5X6pgaeAq1HLdxKmVe9spKZLB/B+8m3+Em0l50Udv5K/4lCiwnRnUqSNTCJjM3DgmVJD9yBNk1sypD91/B7RdOmeFcHN+gLARdPSHOXrRVRcNUZHXF/Jab4Khl0hCxMRgZc6WOedXfzSawDcGmb4s1ZLHb0UyZXZMrI9u4v551Ci0z1KZPWb7zvJZuyHLGbw9qo8SYSyRuO1aSMxj672aRX1UNNpTZb/uLus8GJNzEMnp+q1RdIVok4EZbukg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=YrHMWUXt; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=YrHMWUXt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYVF84j3Xz2xVT
	for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 18:28:12 +1100 (AEDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-2aea8c13d94so6347115ad.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 00:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773559690; x=1774164490; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y8W3tue+BUXzjzsC0JnskebSQQUL9HGt1yDKVVOjktk=;
        b=YrHMWUXtySuAkYxPBwHYKgh5NRntoZE401GYkKFj8xnNfAs4q9jXstMXd+74utoLkg
         nXfV0FTJZ2mKJ51YXkizJQ9KrwKEclPMXxJBzkpHJdjXGj0qW+Ncs0VpcAJQx0xmKv1J
         7iRcxjdEpILfeQdemKKVtDrYSI2mXGImJAa904MfPQbJivCp+pjw4iLKVJW8pbvLWKSN
         v1+x5VLcsvNml54hiKuNYlExAXQ06BVeOwFwwp0nE6ey29OHljRUzF/UQar1BL49wE9X
         gXvvjryuzpyTfgIpAP1wmkTGCkAGkFfIeyxvvcwSeEv2Dd3VMx1ntDVa87UsyueluDCE
         7Yiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773559690; x=1774164490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y8W3tue+BUXzjzsC0JnskebSQQUL9HGt1yDKVVOjktk=;
        b=sUuTjlJxsI0aW2HSu7GHvYsZtGYf9p8IVc2bEEBdIrq3yTNO9JU7tb1sUyfLzPV8+x
         i0Vk9xZYKXqsvnhpCNxpJEJOrwu8ZRQjXkTSJXLGmNFSnc3ggN9dag+CbDFMIZbxY1wK
         SJSdV/NolLW2NmuW9iwrz2mZSr7r+pP3eYuLwA8UjsF/0+oz471uslxMOwwCcyWQ09Zj
         4pWrzrcafpGD4/AC/MlYMo0GvmMSOPZq5JHOFzBcbD/4fMcc7VqVWJvT7868uWV27XaC
         GFNZDkUrGFq/5zKe40uM8sOcMwsp2lz8PVx9MKXWhOtJV6RXanctZfm7HmlCJhVhMb5y
         HvDw==
X-Gm-Message-State: AOJu0YyF1HJeLLhjIquEdpCWrxaI1cqgldlJdI/NeXTq+4pECVMoDh7D
	45OqMmkOlTgnq6tCPWNTq3Xi6WiUYqpypEObPeSLNE+Z2Q7KbKZ9ia5O
X-Gm-Gg: ATEYQzyrUmKP2J5V8cT8V+NEIhmaZD2NHFLUNPZ5Tqjn0lrhTlP/1gobC9VnYjaa9JV
	kTP63PNQQO0iPkYM/oshFyRQ28tx5hFI9ZJFquoigwxmf3bGWO0+7Wkwq1VZpo44/6EsMXUCX6w
	T0HQ81xSZhjWB2gByk9a6X9Ca6aclUgGTfLKzLiR1CgpAQGGmxV0up3XOUNdFefSgNoR7nUAzPQ
	66D0HXc7tgy6UC3flp1E16Kw+TvvUdAM/BF4K0/5cSPvk9PxdtnJWBFYIs80idH3ZQbuD1xhqpw
	80WPkwbFP2UdGqUHBMpK3ZE43/Wl3o4Tm6XklbtPXvqqc+AJkaG53gS4UJoJbpeDEhn97pBMYil
	xP126vfE8P2RinZY5Us2L6Gn/fphQkuO9BzoZQacPSY/9Jy+Tkn/38fwsyzK78Tb+l68/7OjtkP
	RnHRavI6KYRg6hXDz2XGpAWELamFx167uxgXkob0HcaHX2I1gYeVb32/m3KVSlaP4rq5zQwF2xO
	ok8o3FAKLbs7zpYSPPW7ZI2vQV6x177s1Zj
X-Received: by 2002:a17:903:37c6:b0:2ae:4ebc:71e4 with SMTP id d9443c01a7336-2aecab1f373mr61838075ad.7.1773559690505;
        Sun, 15 Mar 2026 00:28:10 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([112.196.126.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b048d2b690sm34778655ad.29.2026.03.15.00.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 00:28:10 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: hsiangkao@linux.alibaba.com
Cc: linux-erofs@lists.ozlabs.org,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib: validate algorithm format before use in z_erofs_map_blocks_ext
Date: Sun, 15 Mar 2026 07:28:06 +0000
Message-ID: <20260315072806.17504-1-singhutkal015@gmail.com>
X-Mailer: git-send-email 2.43.0
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

The fmt field read from the on-disk extent is used directly as an index
without bounds checking.  A crafted image could set fmt to a value
exceeding Z_EROFS_COMPRESSION_MAX, causing out-of-bounds access.

Add a bounds check before using fmt-1 as algorithm format index,
returning -EOPNOTSUPP for unknown algorithm formats.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/zmap.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/lib/zmap.c b/lib/zmap.c
index 0e7af4e..ac5daca 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -630,8 +630,14 @@ static int z_erofs_map_blocks_ext(struct erofs_inode *vi,
 			if (map->m_plen & Z_EROFS_EXTENT_PLEN_PARTIAL)
 				map->m_flags |= EROFS_MAP_PARTIAL_REF;
 			map->m_plen &= Z_EROFS_EXTENT_PLEN_MASK;
-			if (fmt)
+			if (fmt) {
+				if (fmt - 1 >= Z_EROFS_COMPRESSION_MAX) {
+					erofs_err("unknown algorithm format %u for encoded extent, nid %llu",
+						  fmt - 1, vi->nid | 0ULL);
+					return -EOPNOTSUPP;
+				}
 				map->m_algorithmformat = fmt - 1;
+			}
 			else if (interlaced && !((map->m_pa | map->m_plen) & bmask))
 				map->m_algorithmformat =
 					Z_EROFS_COMPRESSION_INTERLACED;
@@ -738,10 +744,18 @@ int z_erofs_map_blocks_iter(struct erofs_inode *vi,
 			else
 				err = z_erofs_map_blocks_fo(vi, map, flags);
 		}
-		if (!err && (map->m_flags & EROFS_MAP_ENCODED) &&
-		    __erofs_unlikely(map->m_plen > Z_EROFS_PCLUSTER_MAX_SIZE ||
-				     map->m_llen > Z_EROFS_PCLUSTER_MAX_DSIZE))
-			err = -EOPNOTSUPP;
+		if (!err && (map->m_flags & EROFS_MAP_ENCODED)) {
+			if (__erofs_unlikely(map->m_plen >
+						    Z_EROFS_PCLUSTER_MAX_SIZE ||
+						    map->m_llen > Z_EROFS_PCLUSTER_MAX_DSIZE)) {
+				err = -EOPNOTSUPP;
+			} else if (map->m_pa && map->m_plen &&
+					   map->m_pa + map->m_plen < map->m_pa) {
+				erofs_err("bogus physical extent: pa %" PRIu64 " plen %" PRIu64,
+					  map->m_pa, map->m_plen);
+				err = -EFSCORRUPTED;
+			}
+		}
 		if (err)
 			map->m_llen = 0;
 	}
-- 
2.43.0


