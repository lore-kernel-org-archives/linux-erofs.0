Return-Path: <linux-erofs+bounces-43-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD731C28B2E
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Mar 2025 09:56:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ZBC3532f7z305P;
	Mon, 10 Mar 2025 20:56:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1741600593;
	cv=none; b=MKS9I1cqqQko8BEJwuAWqwNX4/raTjFhsEYWsreX4iWSavRifHEUF+5hQ6+IKn6CFZXvE+Wtk+v0oL/f+E4DoWD2aeBjj35+PMA3EyMBe+zySBPcastDUWrHLGfShv2Znmxo6ocdauvaOIhLcXglhQgY/KVRt22mwLMBm98v09uByC1+YJjHLIgnCZVSzuc991GZWawmyiPKt795JpwNx0ikOBvLMPmR4yCp2RWGwFm6P5FSmYZuxg2BQrb6FhOv3cewhW/OyC1ZSpzei1pSx8766+l/6Fm2BvPpj23a+Fa8PQWohi6W7TdB8sEN7gSgLkdyg5qMPxAS4C37wXqNYA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1741600593; c=relaxed/relaxed;
	bh=n44x2GIBHkV592zsiETUNG9/RVsDGqeAc5pa7H6OG30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLWii5bWSAsArqgmerAeNKbgXosWV+X0fgViN3mF4ErrvPpAsYUo7JwnFRlx0YitTE+rRKgYJGGvlf6LNX2F79OQQnUGcyS5zOSFAmHwjKqfmUKMKgLMUTSbX2x5oCrEdPoGW1Jngzl6bKVHIB22ZBRP1wzrCe38FXat4+9JjlrK2yv9XFyud0CalY8TF551dWpW5E6aBfC0CEBc+ssig/PrRdHvc0AnFvr8wD8j4wGxe+K9IBHN5rD+UtTr6ee6/GKFf7hintXwsqtO4d7qVIijjyfeE6F8+X+wsrq+FP7ZOR5oFlAhVJ6LNPV2pXgYRZ5RfGrzUaPtsY9s8vnN6Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jMjkmFFl; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=jMjkmFFl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ZBC341Zz3z2ykX
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Mar 2025 20:56:31 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1741600588; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=n44x2GIBHkV592zsiETUNG9/RVsDGqeAc5pa7H6OG30=;
	b=jMjkmFFlJMlOOIXZOQerOmrqPvozI0C/77Mr93ATza7N6S3AFtxsLIpYv3NLOsvji7gKe2L7w262dWZOS9qsDY+8JcjYGK7qKdISZ5b0MZt7lhDiLvx0EwdfR2fXbImgBFRuIUG1sjJNzv86pdn31B70EmzMOvL/yfXiG3GeVlM=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WR0rjXe_1741600587 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Mar 2025 17:56:27 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 10/10] erofs: enable 48-bit layout support
Date: Mon, 10 Mar 2025 17:56:25 +0800
Message-ID: <20250310095625.2623817-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250310095459.2620647-1-hsiangkao@linux.alibaba.com>
References: <20250310095459.2620647-1-hsiangkao@linux.alibaba.com>
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

Both 48-bit block addressing and encoded extents are implemented,
let's enable them formally.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/Kconfig    | 14 +++++++-------
 fs/erofs/erofs_fs.h |  2 +-
 fs/erofs/super.c    |  2 ++
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 6ea60661fa55..331e49cd1b8d 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -13,12 +13,12 @@ config EROFS_FS
 	  smartphones with Android OS, LiveCDs and high-density hosts with
 	  numerous containers;
 
-	  It also provides fixed-sized output compression support in order to
-	  improve storage density as well as keep relatively higher compression
-	  ratios and implements in-place decompression to reuse the file page
-	  for compressed data temporarily with proper strategies, which is
-	  quite useful to ensure guaranteed end-to-end runtime decompression
-	  performance under extremely memory pressure without extra cost.
+	  It also provides transparent compression and deduplication support to
+	  improve storage density and maintain relatively high compression
+	  ratios, and it implements in-place decompression to temporarily reuse
+	  page cache for compressed data using proper strategies, which is
+	  quite useful for ensuring guaranteed end-to-end runtime decompression
+	  performance under extreme memory pressure without extra cost.
 
 	  See the documentation at <file:Documentation/filesystems/erofs.rst>
 	  and the web pages at <https://erofs.docs.kernel.org> for more details.
@@ -97,7 +97,7 @@ config EROFS_FS_ZIP
 	select LZ4_DECOMPRESS
 	default y
 	help
-	  Enable fixed-sized output compression for EROFS.
+	  Enable transparent compression support for EROFS file systems.
 
 	  If you don't want to enable compression feature, say N.
 
diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index 6d461be790bd..9581e9bf8192 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -32,7 +32,7 @@
 #define EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES	0x00000040
 #define EROFS_FEATURE_INCOMPAT_48BIT		0x00000080
 #define EROFS_ALL_FEATURE_INCOMPAT		\
-	((EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES << 1) - 1)
+	((EROFS_FEATURE_INCOMPAT_48BIT << 1) - 1)
 
 #define EROFS_SB_EXTSLOT_SIZE	16
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 0156ee7217c9..a8fc75fd1c74 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -330,6 +330,8 @@ static int erofs_read_superblock(struct super_block *sb)
 	/* handle multiple devices */
 	ret = erofs_scan_devices(sb, dsb);
 
+	if (erofs_sb_has_48bit(sbi))
+		erofs_info(sb, "EXPERIMENTAL 48-bit layout support in use. Use at your own risk!");
 	if (erofs_is_fscache_mode(sb))
 		erofs_info(sb, "[deprecated] fscache-based on-demand read feature in use. Use at your own risk!");
 out:
-- 
2.43.5


