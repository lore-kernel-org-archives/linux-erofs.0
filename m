Return-Path: <linux-erofs+bounces-4569-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A737C88E77
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Sep 2026 07:42:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hl9nj2pDyz2yGT;
	Wed, 16 Sep 2026 17:42:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789544521;
	cv=none; b=F/4pKj+YNlGWM7ICTnca8zU3y4eorxGntdm0Yo3RywjzHJASUfrrCg6n/jsF++CmYmPlFvclYO9M5ScIdfYm+5/N3CdAwTrJmwBC8pZXYIOiT2YPlVxUWAAIotaGa06sOHtYROM//BoqV15nS0aNm3FEQ+FcjwtG57RTpZg35cbNIn5QSDrt+q9Wb+qiqtN8BDmX5fAD+GsiD1RnKkizCspeMVVTAEXyITLNvKkPIdg5HYptJ8mFW2OknIyjZjCW9EqHSKvAL0/J8wkX8WctFsSQtVGrTFskJs6czin1Z4yZjE+EvZxo+VE/cFp7+hdbTH7ePyHzj0fGDpqwkBDtZw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789544521; c=relaxed/relaxed;
	bh=D8/iAJMiujfimShlqI9jIY87fo2qMJqr4SkN0+SUm+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUm5RFksj5P66rja7KcQDn2dnrtfR9k4ALXLgGLbl5LaGql7XDZeSFZGXFGuE3tFdF9nxoj1Yt3zhx1eInFNJSdKaKG13PRL5KERekY6/PPXF3UKjdqF4wrnj98IpScRRmP8zauy7x74c4/OBicO5DODzRq/oRSrhMjPwBMW0S23MDC4N0QtubKoxlWSbdLVKGHBqUefdsedS6AWGZYfUwBrP0hB8tMR8nHQuRKVoCuzGD8tOq/86KYgT2CwodA+c8tH/xwgUaI4Zx78nj/LJI2zGeS7uEjzsGX1O1zQBJlJm2Sc6tMXxyfNkYhwInYGR4Nqp7kaxAcxtwpR/3uipQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opykPmD/; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=opykPmD/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hl9nh5F9Vz2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 17:42:00 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B85DE43D3C
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 07:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD2E1F00893;
	Wed, 16 Sep 2026 07:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789544518;
	bh=D8/iAJMiujfimShlqI9jIY87fo2qMJqr4SkN0+SUm+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opykPmD/qJcvUV1VAWPSx25G0Lqrg7zjPnUE0Es9tgoub4hmCeEfPL5UAWnWzfc/2
	 XSGMmuAiihh5n+7qaNXkfRUzGcH8fTBzG6jKd9Ws5XcTGfBJOCWp06vMQqoC9z1oAC
	 a0oSqBgt2pLoAZcRQIz8lIuAGJIaCBatjvPQ8Q98KdosjSvlPMNNmnX+ITy2Bwop89
	 UJK/0JUxtEstxSTUVX3HDkjPo1iMsuaKmHrmhVt0fKIym9o/tDfQ9cdAAny/TYlcBK
	 N9Z+ed27mNSvpmELmSXOkix7co8+5x8RC4E4DYyYaE74hD0Ss44ZnUzeKqbvGJSXkC
	 SZZI4Ag1IXbow==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH v3 3/4] erofs-utils: lib: switch to use per-inode big pcluster flag
Date: Wed, 16 Sep 2026 15:41:00 +0800
Message-ID: <20260916074101.66357-3-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916074101.66357-1-xiang@kernel.org>
References: <20260916074101.66357-1-xiang@kernel.org>
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


