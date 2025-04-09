Return-Path: <linux-erofs+bounces-168-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E6DC36002
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Apr 2025 16:33:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ZXpQy3gVPz30Vf;
	Thu, 10 Apr 2025 02:33:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1744216394;
	cv=none; b=BuLjzNvUVN9bKz68/3azOTSzw5HYBKA8bPFNTHZO/FQaHV44jn+KiEltKE573M+hEtyVV0ZU0gbzySLH1j7RV8rMU6WF97rRGdCh75HB78DGie5YplGMjhZCMUR4ymX5QheA6gv9Y9C/6vejSVIcaJsHmxvJggZ7D+SOQPyj4Rhp5qmSxIw4mvaYo/WwTvr+D3tzjNLqxtPpCLj8iU3M1q047u+y2bjysjNlhorLG6l42lGzkeXLfRHD465KCKI+AZ93mKARiP1AHZQkc0FgXH+M6s7LRaGyY4YPf08kB5xjzvBLc21qqjCybPFQkkKQaYcEgLK2CuwtkzGxMwsymw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1744216394; c=relaxed/relaxed;
	bh=7P4HEhL2b/Gb01pJStzo82xt2vdW/GmBur1578sdfpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEuYPABgIXtPON7ptDRPH7ggpO1qwM/kqPdW8ZfMtyhKBYPvYBjtjmh8lq5M8OIZXbrlK5Y6LZgDXLragYHIO9lD5nHOhgZksyv14Nh/nONCI994SwSf64+gN6SNT6Ij0lS+5kU3XBaBjC6N5pTEAJEJutXcqGRygVgNWSxT+ZR9O+Gh0jCrqIdcF7wKPKedtAOpcJuSbUGMQ0zucymAb/3nxc4Jc85mkCDt4kwBCfoHoYjnrC3up3t9BmHcJGRHM/AZunvH8RkVQyvR3KeMujLrSZJSwR03t0sa7+nOihvJHgq+SXwx9yZ5dgEsqonzkmBDHDCoJtSmsxlmS7cAbA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Met43eqn; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Met43eqn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ZXpQw63Qbz30VR
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Apr 2025 02:33:12 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744216388; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=7P4HEhL2b/Gb01pJStzo82xt2vdW/GmBur1578sdfpA=;
	b=Met43eqnm3s1Z/u/DFHFnoig1/n9WsBL0aUSI/WkyQPVHuHI4iiNQoiZDoFT6kmbzCR5o2O+UTK/jvKH0UjPODGpH1EkaD3CCqZJixg3mnizcASBWyw4+IVhxtP4SM9ZsEQVT5URaXBUDl6xHg7YIeEIfTrBd83ISzx7ipwpk9w=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WWKsZT7_1744216386 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Apr 2025 00:33:07 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v2 03/10] erofs-utils: lib: clean up header parsing for ztailpacking and fragments
Date: Thu, 10 Apr 2025 00:32:52 +0800
Message-ID: <20250409163259.2077865-3-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250409163259.2077865-1-hsiangkao@linux.alibaba.com>
References: <20250409163259.2077865-1-hsiangkao@linux.alibaba.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Source kernel commit: 540787d38b10dbc16a7d2bc2845752ab1605403a

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/zmap.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/lib/zmap.c b/lib/zmap.c
index d47ed6b..07c6a83 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -493,6 +493,11 @@ static int z_erofs_do_map_blocks(struct erofs_inode *vi,
 		map->m_flags |= EROFS_MAP_META;
 		map->m_pa = vi->z_fragmentoff;
 		map->m_plen = vi->z_idata_size;
+		if (erofs_blkoff(sbi, map->m_pa) + map->m_plen > erofs_blksiz(sbi)) {
+			erofs_err("invalid tail-packing pclustersize %llu",
+				  map->m_plen | 0ULL);
+			goto out;
+		}
 	} else if (fragment && m.lcn == vi->z_tailextent_headlcn) {
 		map->m_flags |= EROFS_MAP_FRAGMENT;
 	} else {
@@ -589,21 +594,8 @@ static int z_erofs_fill_inode_lazy(struct erofs_inode *vi)
 		return -EFSCORRUPTED;
 	}
 
-	if (vi->z_idata_size) {
-		struct erofs_map_blocks map = { .index = UINT_MAX };
-
-		err = z_erofs_do_map_blocks(vi, &map,
-					    EROFS_GET_BLOCKS_FINDTAIL);
-		if (erofs_blkoff(sbi, map.m_pa) + map.m_plen > erofs_blksiz(sbi)) {
-			erofs_err("invalid tail-packing pclustersize %llu",
-				  map.m_plen | 0ULL);
-			return -EFSCORRUPTED;
-		}
-		if (err < 0)
-			return err;
-	}
-	if (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER &&
-	    !(h->h_clusterbits >> Z_EROFS_FRAGMENT_INODE_BIT)) {
+	if (vi->z_idata_size ||
+	    (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER)) {
 		struct erofs_map_blocks map = { .index = UINT_MAX };
 
 		err = z_erofs_do_map_blocks(vi, &map,
-- 
2.43.5


