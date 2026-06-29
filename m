Return-Path: <linux-erofs+bounces-3781-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BBBDC43327
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Jun 2026 12:18:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gplfy0JS5z2yZc;
	Mon, 29 Jun 2026 22:18:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782735498;
	cv=none; b=FqZqHXQvLOAcjBDs643LekyELuztfBDAyqOdehMR8fgQJJ9QbeTVz+mTEK91FyIPnV4Lxk5W65JoPbkY9VeTr5mDG4ASsUJy2jnzkIpi1Pr8v+3guI3mC5+frxJe2+58v7qyBG9lFkbVooYonUJ6e5kOXemy0joOCn6oJo5Dy6JCLznAHi4JvNP96RzpuOX3AVmaKUV4yAC1GLfGBzyJYb3flA75aXr0nmJfDPeIja7Jza+AK8q+cb5XJOE1p0HCkS0e3d09ONX8ONdg1S/ZoUrv+37gLljJw66c7o0yTMsjN3OqxfX3CCot937WWAK+YODrQoK4p3udmQGkCatJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782735498; c=relaxed/relaxed;
	bh=3uv6XzvXDFaI2s9endu4pr1fplTSlVypCXcNeZT65c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3uDeeuLsNk/CH6EwwoJ6ddSWYf6pKjuv+HSJ+gqzUP2SqEiLabGN2SiRtQ8Jw0G2gklZMzjna9av6aXCBX/JsvVjjjbQg79dTX4xK1PxdYRCyWOCuPyD/YFVXfwwtT2LPg1LcDqb3+F7ufLM+JY6rCLN/mPiycAf7PBovwE110kXwdgLX84YA2lZEzIrmXvV8yY3wGYgpLensYamJUw1g20fY+kRit5HRRdlLZJqPb9LXTCmFmkrNNhc02ptn+nKAJg1dhMt/etdCjvyplazFudC8vrJF3S4oUIiA1Lb3pi8mDV1BjlAJ0hgSWaUf2HL4U7gDjABLUki2t60QEzsQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=eedIQ8Qq; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+90a5730460baaf6f6760+8345+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=eedIQ8Qq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+90a5730460baaf6f6760+8345+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gplfx0w4Rz2xYh
	for <linux-erofs@lists.ozlabs.org>; Mon, 29 Jun 2026 22:18:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3uv6XzvXDFaI2s9endu4pr1fplTSlVypCXcNeZT65c4=; b=eedIQ8QqTRxd6h5AkRYsGDJ6YS
	4kv4Qn5bntDkBKjrWSpSeh+NCKdcvYQaj1/Wor3mrcNNW5A/NBxkRLYpc5DBNLH5ln9pOoH4OMSB0
	QopCbNCZMcCi83A1nojoVmbbu6WX93YKMstLM1HAN2ru8wY+ZgphspFaXxG8KgGo6U1+VSuvunJcg
	sPWjFbaM7XuoBn9QHr2yMJwqLoq/DoRHlWi8yZAM7hSWlhu5M/xWi/I/sRUtdozgFglmr4934qw7w
	FbtaIiwSvaJmB5gWy8x7SWEk05EA+j9Y6DN9u2Z63wyuls6oyPysgk047jGC4L+/s4nZCSKoXXCi+
	jLdF1unA==;
Received: from clnet-b08-202.ikbnet.co.at ([83.175.123.202] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weAwG-0000000EX0p-3WTv;
	Mon, 29 Jun 2026 12:18:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] iomap: submit read bio after each extent
Date: Mon, 29 Jun 2026 14:17:40 +0200
Message-ID: <20260629121750.3392300-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629121750.3392300-1-hch@lst.de>
References: <20260629121750.3392300-1-hch@lst.de>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the iomap buffered read path tries to build up read context
(i.e. bios for the typical block based case) over multiple iomaps as
long as the sector matches.  This does not take into account files
that can map to multiple different devices.  While this could be fixed
by a bdev check in iomap_bio_read_folio_range, the building up of I/O
over iomaps actually was a problem for the not yet merged ext2 iomap
port, as that does want to send out I/O at the end of an indirect
block mapped range.

So instead of adding more checks move over to a model where a bio only
spans a single iomap.  Change ->submit_read to be called after each
iteration so that the bio based users submit the bio after each iomap.
Fuse is unchanged because the previous commit stopped using ->submit_read
for it.

Fixes: dfeab2e95a75 ("erofs: add multiple device support")
Reported-by: Kelu Ye <yekelu1@huawei.com>
Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 fs/iomap/bio.c         |  2 ++
 fs/iomap/buffered-io.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 0f31e35567b4..dc8ac7e370a5 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -87,6 +87,8 @@ void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
 	if (iter->iomap.flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(bio);
 	submit_bio(bio);
+
+	ctx->read_ctx = NULL;
 }
 EXPORT_SYMBOL_GPL(iomap_bio_submit_read_endio);
 
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8d4806dc46d4..276720bc18dc 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -642,12 +642,12 @@ void iomap_read_folio(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, folio->index,
 				   folio_nr_pages(folio));
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		if (ctx->read_ctx && ctx->ops->submit_read)
+			ctx->ops->submit_read(&iter, ctx);
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, bytes_submitted);
@@ -718,12 +718,12 @@ void iomap_readahead(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, readahead_index(rac),
 				readahead_count(rac));
 
-	while (iomap_iter(&iter, ops) > 0)
+	while (iomap_iter(&iter, ops) > 0) {
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		if (ctx->read_ctx && ctx->ops->submit_read)
+			ctx->ops->submit_read(&iter, ctx);
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);
-- 
2.53.0


