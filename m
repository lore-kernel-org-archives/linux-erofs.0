Return-Path: <linux-erofs+bounces-4563-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39FBFC88E53
	for <linux-erofs@archiver.kernel.org>; Tue, 15 Sep 2026 06:22:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hkX4r5N7Wz2yhP;
	Tue, 15 Sep 2026 16:22:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789453372;
	cv=none; b=kKjZ0jlpz1DSAoYUGwO+O8a0RHL23FsEZo4e3aUnMtMVOVD5jVHuaK0PqYE58OTYlC/dAg5QETtEXq9vfBNkf5DqF6AwV9ZLn2Wn4WyfgcQ5KfsiRQpNhTlx5IWMYwmVcZEjgSNu+N2FWa/WclFAF5RG7T47eyydlSCmGNlBtTYnXN1ewSAnXY7mOfuf5I8aBUWnF8AbHWv/dtsapJ50PUiFwF+m7zhj47DbfxeoW+T9U0oolBKnMTrv4gqnekjROFKzPF3MmC0GCpo+r2dA+R/eMvYhVzfaqJloM0yeHB8w1dzWRwLnFkYgDonJMGMs/+hO/I3uU1Fyd/2/8upzMw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789453372; c=relaxed/relaxed;
	bh=D8/iAJMiujfimShlqI9jIY87fo2qMJqr4SkN0+SUm+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDenexMcpgjrgVqM0iMKfvPK5cbsArXpPCOmpIv6UgC/Ef0akrTH1LxPEssrycY4i5ndJxDShvadQrj2LA6jjRywGIZ2DBpm2dDASRlchIZo4YUZJOcCiVtZbBjpL9ZXPjCo4XzyF596uAgb15Iqz9AQFWYbeTsDflv+iEvzVVduQlrYQJKGFH9+zzoNmIFrqZuvHdN8BjhifRlYh3M5BnBpP0qvhMvse+MU/ieOAp5tzIwMZWOTvPJoELxE4b9Ju0TzPaeRTWV8emu0BGLBzsdQR3nsyWb5fsmi7vD1J3Xk98K9CUE0Zx4/NHdL+CM2vWVvJb3ueq5tBPlOVivbjA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=msVk/6r6; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=msVk/6r6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hkX4q50Bnz2yFW
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Sep 2026 16:22:51 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DAB3405A4
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Sep 2026 06:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC93F1F000FF;
	Tue, 15 Sep 2026 06:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789453370;
	bh=D8/iAJMiujfimShlqI9jIY87fo2qMJqr4SkN0+SUm+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msVk/6r6m6Dby/8oe5Q/ikRGYVpnGWTq8z4L1Kwb28niNCV6pGP9DcnHymqM24HLx
	 /tvNGIrYlglqppFDJJ37pIC1UmVwoKI8gY7rVOUx/i3mi0xuECFp52BiKI3rkVOTXc
	 HkPtpmnuUFajXFxOscoUxRyeAzb32ZcZOQ2jasknoLwLrm4+PgtTANVxFPg4BEjYXX
	 S35digaz0XD2Ogo6/wWd7SDgHnYxmHrkuVuHYcUlRWxF0WBTcL6WkffIFurZEQdMpb
	 Z2Cl11gGCw5CidQL/9QgFEZ4cqU0szfWh8slYWmTu4KQig86zTlzgDNWYSmTC4kK8g
	 VkB15WT0tyFHw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2 3/4] erofs-utils: lib: switch to use per-inode big pcluster flag
Date: Tue, 15 Sep 2026 14:21:38 +0800
Message-ID: <20260915062139.54810-3-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915062139.54810-1-xiang@kernel.org>
References: <20260915062139.54810-1-xiang@kernel.org>
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

Some inodes can be non-big-pclusters but the filesystem can have big
pcluster inodes.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/compress.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index ef79eaa..cda138f 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -168,6 +168,7 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 {
 	struct erofs_inode *inode = ctx->inode;
 	struct erofs_sb_info *sbi = inode->sbi;
+	bool big_pcluster = inode->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
 	unsigned int clusterofs = ctx->clusterofs;
 	unsigned int count = e->length;
 	unsigned int bbits = sbi->blkszbits;
@@ -213,8 +214,7 @@ static void z_erofs_write_full_indexes(struct z_erofs_index_writer *ctx,
 
 	do {
 		advise = 0;
-		/* XXX: big pcluster feature should be per-inode */
-		if (d0 == 1 && erofs_sb_has_big_pcluster(sbi)) {
+		if (d0 == 1 && big_pcluster) {
 			type = Z_EROFS_LCLUSTER_TYPE_NONHEAD;
 			di.di_u.delta[0] = cpu_to_le16((e->plen >> bbits) |
 						       Z_EROFS_LI_D0_CBLKCNT);
@@ -931,7 +931,7 @@ int z_erofs_convert_to_compact_format(struct erofs_inode *inode,
 	unsigned int compacted_4b_initial, compacted_4b_end;
 	unsigned int compacted_2b;
 	bool dummy_head;
-	bool big_pcluster = erofs_sb_has_big_pcluster(sbi);
+	bool big_pcluster = inode->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
 	erofs_blk_t blkaddr;
 
 	if (logical_clusterbits < sbi->blkszbits)
-- 
2.47.3


