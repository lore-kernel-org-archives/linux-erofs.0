Return-Path: <linux-erofs+bounces-4374-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2E9C61DD9
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5q2Kwgz2yhD;
	Sun, 30 Aug 2026 14:19:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063567;
	cv=none; b=BV1T79XE5AiFNN5I2vqr5COPOG6wS+m6XCvruw+L6MLmlpoM44jW5XtLOHClX9jcpIY+BnH5ABYLt4Z39epfUeWVcrgCzD13M3ea8C2D1xTD5KhPVm8w/paeeOfaYB0PGcziuXQI33m5HdxHEJ+4+bFWT+fpKWXrJaTc9Qub7NcbPJCRSIdIgbDXGekatOS0k4U5mCtHn6/1nqZe5FXh2+BHtZ4NXWrVzrF6lZ8Dy13UsihsEMv4dtWAICLBeGn0gD2UyVIpNe4TPJUshZMkWawPBrlbkfRYztHFADmYEcYnGrJG5ajO849FUx75QE6c1ayuwJe/qDFEUN7rDsURUA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063567; c=relaxed/relaxed;
	bh=17KDooFJoYeOcgqtwlU5ofiBDQP57dVuWi84LFJRoDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNXpNTW9UfuyNnfSCMo9Ln8+B7WhBgxu5E/zpmTFuijDnFisBxVXf4xyj3KEylgo1h9trY0yelmtlcC+SbLYmUxYMhxRq/56D89b5eRQHRukePmKSCCZxmHVwu4ezCj+qvEMQleGJ7UVURTbxWjXLPJco+EQuveWnm2CVzI6edsBFTAZUuBof5+kvfZswopFDxJZkU4dVwUEu0JX2nWgC0PeJ1Wqn/Zh/8SpyFkN0ZP9OVxcNFL6WmvNZHd1JXlbCm+gZOxtPhy0MJBTjE3BNzczD4wek3qRmX63G5+MRYZ2+DddLGyYhHTViWQid00CzeNyYbfIsi79vfrllb4RKA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=TisMTFuh; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=TisMTFuh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5g0qDNz2y7Y
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=17KDooFJoYeOcgqtwlU5ofiBDQP57dVuWi84LFJRoDU=; b=TisMTFuhPCehbA7/9nutMd5vZd
	dGAVseYx9yVTpk//u4fNFf54zujpuIxBHFGc46tKpAUpq1GZxXRPYSn7FYTAklF/bfAtpWBCIi0oC
	1J3BDbE+FEpcCaXt3JF9blBGINHRtNtYhss61eG4phR8MkG4W5HyPetKV9dWjA59icSHtWvcNRJGN
	GiKLqnHuePZ0aPQJE7gGK8fblo+0p7PB2bv+IKL2GOeSR7hWHlnEOEqpTCSnX98Tgprf0NJ7dTnYt
	1ZXY+Z4uZeCw3nVDigJ0ICzRwqLlMVt5EZEKarX+tOuSAxr98ZRt2QwuDcnBtoKP22oJ8qCVci5uH
	unmVDQ0g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hO-0BzY;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:49 +0100
Message-ID: <20260830041901.2668-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
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

Both of these locations are called while a transaction is in progress.
Starting a transaction uses memalloc_nofs_save(), so we are already
prevented from recursing into the filesystem and using GFP_NOFS was
unnecessary.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ext4/inline.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..1884abb09614 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -601,9 +601,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 		goto out;
 	}
 
-	/* We cannot recurse into the filesystem as the transaction is already
-	 * started */
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
+	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		ret = PTR_ERR(folio);
@@ -734,7 +732,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 		goto out_release_bh;
 	}
 
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
+	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
 					mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		ret = PTR_ERR(folio);
-- 
2.47.3


