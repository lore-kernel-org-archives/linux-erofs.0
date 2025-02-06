Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A98FC02194
	for <linux-erofs@archiver.kernel.org>; Thu,  6 Feb 2025 12:51:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YpcR74v3Hz3dBl
	for <linux-erofs@archiver.kernel.org>; Thu,  6 Feb 2025 23:50:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1738846256;
	cv=none; b=SCu6kPeRiNHBKsgtYsUBO4nUGKzvrpMNU0HarSalxWq5WUvUhd3RheBhYKdvp67x4GsfTWeFFDymYDVFy30rwmPNeq6Xx5Ya10JC9FeI1IWvYV+bpm9xFwYfQRlaDaJ5dp7NF7gqDZccvWjaD0JpzAlXwGNVW9zOKvqFJMVOBVYS9zKqqHmqzmtVIXk8R0csO5jYWLMRF23h+BiSJnwD8kX5d10M1EvJ7QAoyl/Cltf9yCXdhlZc2GWwUC4Ogwj6RG/x5dqsiIiHTKKdEOBZdP2W0LrQf4RFE6a7eI07bymbE4L/hzmLoNpuhqUyIwCCZHyEPN/DKwF+7bnTBUd30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1738846256; c=relaxed/relaxed;
	bh=5uZiqRm5vQ4OFRhAJR0Fo+wj2s4XUx6quBRBJMrtmh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsp+PE5noJaXNw/GERBiILUSmZxPFx6n3SKqqC4oFK2ECFpa4A2BRndjVRf9GWWpL+NNZImMsobTGV5nhmJczzTlkhVhtdXTGv1p3kyNGLsR8IaWXOB4hPMp4jx06YnpXDFZvOO6oieef7t83zU39vHirNFlidI3P679nYVEva38kB99Zun1goa2+6m9JxTNr/59gBJOunBQ45EEgdoqb+FQD8c1c0BVH6dyMyQbz2kMxZgfxiw5Z+gbFcBOHPH4SLuuCcWUhpO2Hfs6yVOQyF3MTM/id/U0q1zGLMMDpAbOBooLFy+bJJf6WjyaXwjGrwfpNWgiTTHjqGm8fXknRA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=h3iBDXB8; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=h3iBDXB8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YpcR30VWTz30HB
	for <linux-erofs@lists.ozlabs.org>; Thu,  6 Feb 2025 23:50:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1738846251; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=5uZiqRm5vQ4OFRhAJR0Fo+wj2s4XUx6quBRBJMrtmh8=;
	b=h3iBDXB8jz42t9ZzvJjsA+BpoLirnbrC9cMFxBdnSlSgXAfeMtmxtJW8cN3TFjJ3e0H4QjWthH+fC6VINlKY4j0h9m6pAbh/wrkkUExaloQWjtSyZHMx/3TpnL8cqcGIGrN1yl9O3dmrhKSLucUiAqOsgoiSnS3N9okLCbcabm8=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WOwMl7m_1738846250 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Feb 2025 20:50:50 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 9/9] erofs-utils: lib: clean up z_erofs_extent_lookback
Date: Thu,  6 Feb 2025 20:50:34 +0800
Message-ID: <20250206125034.1462966-9-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250206125034.1462966-1-hsiangkao@linux.alibaba.com>
References: <20250206125034.1462966-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Source kernel commit: ab474fccd04509db89fde8d3b28c39aa9a47db64
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/zmap.c | 60 ++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/lib/zmap.c b/lib/zmap.c
index 24bdff7..2287bed 100644
--- a/lib/zmap.c
+++ b/lib/zmap.c
@@ -273,46 +273,40 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 				   unsigned int lookback_distance)
 {
 	struct erofs_inode *const vi = m->inode;
-	struct erofs_map_blocks *const map = m->map;
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
-	unsigned long lcn = m->lcn;
-	int err;
 
-	if (lcn < lookback_distance) {
-		erofs_err("bogus lookback distance @ nid %llu",
-			  (unsigned long long)vi->nid);
-		DBG_BUGON(1);
-		return -EFSCORRUPTED;
-	}
+	while (m->lcn >= lookback_distance) {
+		unsigned long lcn = m->lcn - lookback_distance;
+		int err;
 
-	/* load extent head logical cluster if needed */
-	lcn -= lookback_distance;
-	err = z_erofs_load_lcluster_from_disk(m, lcn, false);
-	if (err)
-		return err;
+		err = z_erofs_load_lcluster_from_disk(m, lcn, false);
+		if (err)
+			return err;
 
-	switch (m->type) {
-	case Z_EROFS_LCLUSTER_TYPE_NONHEAD:
-		if (!m->delta[0]) {
-			erofs_err("invalid lookback distance 0 @ nid %llu",
-				  (unsigned long long)vi->nid);
+		switch (m->type) {
+		case Z_EROFS_LCLUSTER_TYPE_NONHEAD:
+			lookback_distance = m->delta[0];
+			if (!lookback_distance)
+				goto err_bogus;
+			continue;
+		case Z_EROFS_LCLUSTER_TYPE_PLAIN:
+		case Z_EROFS_LCLUSTER_TYPE_HEAD1:
+		case Z_EROFS_LCLUSTER_TYPE_HEAD2:
+			m->headtype = m->type;
+			m->map->m_la = (lcn << lclusterbits) | m->clusterofs;
+			return 0;
+		default:
+			erofs_err("unknown type %u @ lcn %lu of nid %llu",
+				  m->type, lcn, vi->nid | 0ULL);
 			DBG_BUGON(1);
-			return -EFSCORRUPTED;
+			return -EOPNOTSUPP;
 		}
-		return z_erofs_extent_lookback(m, m->delta[0]);
-	case Z_EROFS_LCLUSTER_TYPE_PLAIN:
-	case Z_EROFS_LCLUSTER_TYPE_HEAD1:
-	case Z_EROFS_LCLUSTER_TYPE_HEAD2:
-		m->headtype = m->type;
-		map->m_la = (lcn << lclusterbits) | m->clusterofs;
-		break;
-	default:
-		erofs_err("unknown type %u @ lcn %lu of nid %llu",
-			  m->type, lcn, (unsigned long long)vi->nid);
-		DBG_BUGON(1);
-		return -EOPNOTSUPP;
 	}
-	return 0;
+err_bogus:
+	erofs_err("bogus lookback distance %u @ lcn %lu of nid %llu",
+		  lookback_distance, m->lcn | 0ULL, vi->nid);
+	DBG_BUGON(1);
+	return -EFSCORRUPTED;
 }
 
 static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
-- 
2.43.5

