Return-Path: <linux-erofs+bounces-4543-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD01C88E50
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 12:10:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hhCzW4nWqz2yd7;
	Fri, 11 Sep 2026 22:10:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789128615;
	cv=none; b=TWW5GWEgD5CDUZqvsVgo10uwO1zmrkQ1Rd5GhL0g5oL2qdcw+FlLXbfbHPkgsw6E+3NwZzgbdvZeVUDavm/nhsdDPhnL8spSRbOzxgH0Liujd2Hc0v+tlCE+HaOZzm4ziUer6JBZ81ve2DkFlfl8n+Kbb9/IBO/2l9ZhEGT6HM4UL+akQPJYqTz3mSURtJwvEhmevhPIAXtEFQN0amVsUq9IeDVK8XFp4414eZ76Y2L6ofIpnnTueHMKs5fFpanr9WYqA/fDwuDuZcakqpcelIp0LFdZb51HRZi6S58PM1gASPZ/1kimEX9FUFSblb7gWA9ak1RGRVAR14MAfa/dnw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789128615; c=relaxed/relaxed;
	bh=8TsdnoJq8gaBYJX7nUSCYNIoiVbyNkevIK7AIv3WaiA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mIvFtVYfJSyx2KdJqIUqd8j+4lIc7o8GSUOd4eZT5bKG4UZ8hRPMJZCqQKxoe2QCg6m3KS6jDseewdt3d4Pe1RL7d9A4C/sToLdf51oV+GWe3Y41ANlNvJs/0PG+J9UItO5m+4GOPqxQb1VVwk1itV1go0YozGWtkKZE/oxnHF4zUBOTK3QdCVQp5lsRbe7G/Kd7UplewB7l1WU6coKJwJ/ZtKZAs28SLfPnXRty3QhfZPRCtGY2oHOy/WbbD23COAI3xOXqCwCKJAcakXZ5p8uDQ9uClhQ/WwOWpYg+L/mMcwRksxXcUmKnkhT7LEAYjKFqNN6N3oQh1Ba2EwdaKQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PdHnfI/v; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PdHnfI/v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hhCzV4dnmz2xBK
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 22:10:14 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C6C841256;
	Fri, 11 Sep 2026 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053901F000FF;
	Fri, 11 Sep 2026 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789128612;
	bh=8TsdnoJq8gaBYJX7nUSCYNIoiVbyNkevIK7AIv3WaiA=;
	h=From:To:Cc:Subject:Date;
	b=PdHnfI/vWefl+41S1tkUwxEW6gUTaK++LZvnU5vhhM9Ab2S1WulXmlfxaVDJ7iLNK
	 EdxpSKAruEsLANVn6AFWilzFOSMnrGFWrkg4Su5ji/GTCVTINOWJJvWwzZIaqhDp05
	 rAzFxQpE5oWrQzA0kzxxFwxRxJnHJEZb3ZozwCvkgQy668ozvpg93GOgQ/Ce+6cej5
	 1nrzB58fNhd2WuVTJsMDHnQHbXVqAaE4EzA2suFZC7CTygoh0kpwIROq9onJI2wd0k
	 3DWRrD/XqyvG+Vuysu9t9ka1CROP5r4DTUTgJsfQgl3l2aGRo4mcko8Ff8NoxmkriK
	 c1BEsCmafJdFw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Jonathan Calmels <jcalmels@nvidia.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [RFC PATCH 1/2] erofs-utils: record algorithm id in in-memory compression extents
Date: Fri, 11 Sep 2026 20:09:13 +0800
Message-ID: <20260911120914.185958-1-xiang@kernel.org>
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

In order to enable the rebuild mode for compressed inodes.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/dedupe.h |  1 +
 lib/compress.c         | 13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/erofs/dedupe.h b/include/erofs/dedupe.h
index 14dd7dc..dbcb37c 100644
--- a/include/erofs/dedupe.h
+++ b/include/erofs/dedupe.h
@@ -18,6 +18,7 @@ struct z_erofs_inmem_extent {
 	unsigned int length;
 	unsigned short device_id;
 	bool raw, partial, inlined;
+	char algofmt;
 };
 
 struct z_erofs_dedupe_ctx {
diff --git a/lib/compress.c b/lib/compress.c
index ae09e86..3e8f9b6 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -189,7 +189,9 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 		DBG_BUGON(!e->raw && !inode->idata_size && !inode->fragment_size);
 		DBG_BUGON(e->partial);
 		type = e->raw ? Z_EROFS_LCLUSTER_TYPE_PLAIN :
-			Z_EROFS_LCLUSTER_TYPE_HEAD1;
+			(e->algofmt == inode->z_algorithmtype[0] ?
+				Z_EROFS_LCLUSTER_TYPE_HEAD1 :
+				Z_EROFS_LCLUSTER_TYPE_HEAD2);
 		di.di_advise = cpu_to_le16(type);
 
 		if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL && !e->plen) {
@@ -238,7 +240,9 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 			di.di_u.delta[1] = cpu_to_le16(d1);
 		} else {
 			type = e->raw ? Z_EROFS_LCLUSTER_TYPE_PLAIN :
-				Z_EROFS_LCLUSTER_TYPE_HEAD1;
+				(e->algofmt == inode->z_algorithmtype[0] ?
+					Z_EROFS_LCLUSTER_TYPE_HEAD1 :
+					Z_EROFS_LCLUSTER_TYPE_HEAD2);
 
 			if (inode->datalayout == EROFS_INODE_COMPRESSED_FULL &&
 			    !e->plen) {
@@ -700,6 +704,7 @@ frag_packing:
 		e->inlined = true;
 		e->plen = blksz;
 		e->raw = false;
+		e->algofmt = inode->z_algorithmtype[0];
 	} else {
 		unsigned int padding;
 
@@ -755,6 +760,7 @@ frag_packing:
 		}
 		ctx->poff += e->plen;
 		e->raw = false;
+		e->algofmt = inode->z_algorithmtype[0];
 		may_inline = false;
 		may_packing = false;
 	}
@@ -1233,7 +1239,7 @@ static void z_erofs_write_extents(struct erofs_inode *inode,
 			plen = inode->fragmentoff;
 			pstart = inode->fragmentoff >> 32;
 		} else {
-			fmt = ei->e.raw ? 0 : inode->z_algorithmtype[0] + 1;
+			fmt = ei->e.raw ? 0 : ei->e.algofmt + 1;
 			plen |= fmt << Z_EROFS_EXTENT_PLEN_FMT_BIT;
 			if (ei->e.partial)
 				plen |= Z_EROFS_EXTENT_PLEN_PARTIAL;
@@ -1350,6 +1356,7 @@ int z_erofs_compress_segment(struct z_erofs_compress_sctx *ctx,
 			.raw = false,
 			.partial = false,
 			.pstart = ctx->pstart,
+			.algofmt = inode->z_algorithmtype[0],
 		};
 		init_list_head(&ei->list);
 		z_erofs_commit_extent(ctx, ei);
-- 
2.47.3


