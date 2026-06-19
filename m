Return-Path: <linux-erofs+bounces-3682-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545CBCD98F6
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jun 2026 05:01:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ghQRN2mTvz2ySW;
	Fri, 19 Jun 2026 15:01:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781845280;
	cv=none; b=aojnCsgyErFYO2eNVN2ps/mW/GH8onpBOmPGvCjVGhAzIdwe007DMKbj5D1cbVWWaWroyN7QaHoTtm7dWlwj4BEhB6enav/ojOROgeuPoVVLPV+kP/xGbeWCdvOBh7BaaM0fQ8RF7Y2MHVe99MNMWueQc52TeCRNDl++oj45obIyJYTtilgEH5/vQRAimQODGtpjNx5si6WqPWi/eeVUHzptT9Mn3kJSrNdCTQG8xtQk3+ELBrSVZ4WzUXNRVRYK9Y0uyrGYOEGtlY0g9caHtgNIo6YgcBjGPpXTgEQBdaDsS7e1uWY4RNrWEYFr8L4xnPpPwaHzBgpKDMcLGVb3/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781845280; c=relaxed/relaxed;
	bh=OGz8ag5/wPHrsxPlGRkhiL5M14tr2RNW2uLLU3X9sLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3CB+mRkg1WXw0X+w49sodO3fdvhFgv5F0wQxQzvftLwKx+3II1yp1PBH2KIZ9Sd7sggWtfNbBvvYHlwFYF644sj3jPiSfgaHqTIjYk9eC+KhSZOBIQOsAbEeiSMmTPbdXXYEfwOmfRr5mjVpXiUlwo6zwrzWMvBIMYSt36hO4Bf9H5zWmQLpASmwwLa1+P9iWK6N86Hi2JUkHvotANxHKt5qE6jenqO/og7FVevrH2SSzmNEIQfTVJcugQSHELCcsBQQxM8vrZ6JK9FvYPUo8CEGgX7YDuePzmbtA6oWn1YYqC/RUI5BVyZd/rxGcPmpQzS2N/I1QEGz9FkX9JKlA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zVbODfNP; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+9d9d02d532328e2be671+8335+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zVbODfNP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+9d9d02d532328e2be671+8335+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ghQRK6RJxz3bpP
	for <linux-erofs@lists.ozlabs.org>; Fri, 19 Jun 2026 15:01:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OGz8ag5/wPHrsxPlGRkhiL5M14tr2RNW2uLLU3X9sLY=; b=zVbODfNPcB82udYs6SGhVOPonS
	iy3ICX4rlT1nD2AXfEi79J1BgjNpAltwUMHb4KB57n4D+IE9nh0NrnA7YOJqD9eV1HFFchH1bD90i
	AwKbXoXz1vbUoxI2WBcFT5dXe4dfsgVHBzEQvAhTU8W30+Q9HfFAcK0FoVG24syxa9D3yb+kEVXVs
	aRIiubdqe1EyYRjYPhOYgbEVMgq3LmCPNjthNGBfbQ1gZq/vCtUcLcdd3Xp3uInlxr2h2eBHYW194
	fDgZ0ASICIDRoPfwSl9OEDditGYcbLdvA225VIa2rR3OD1G8LMcg6bNHorejSc+M05mq9oPrM/5/A
	0TJfowrQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waRLv-00000001ziK-0OkJ;
	Fri, 19 Jun 2026 05:01:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] iomap: submit read bio after each extent
Date: Fri, 19 Jun 2026 07:00:53 +0200
Message-ID: <20260619050105.439956-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260619050105.439956-1-hch@lst.de>
References: <20260619050105.439956-1-hch@lst.de>
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

So instead of adding more checks move over to a model where a bio
only spans a single iomap.  File systems can still create iomap
that span more than an extent if they want to build larger I/O.

Reported-by: Kelu Ye <yekelu1@huawei.com>
Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8d4806dc46d4..7449cfd995d5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -524,6 +524,14 @@ static void iomap_read_end(struct folio *folio, size_t bytes_submitted)
 	}
 }
 
+static void iomap_read_submit(struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx)
+{
+	if (ctx->read_ctx && ctx->ops->submit_read)
+		ctx->ops->submit_read(iter, ctx);
+	ctx->read_ctx = NULL;
+}
+
 static int iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t *bytes_submitted)
 {
@@ -642,12 +650,11 @@ void iomap_read_folio(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, folio->index,
 				   folio_nr_pages(folio));
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		iomap_read_submit(&iter, ctx);
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, bytes_submitted);
@@ -718,12 +725,11 @@ void iomap_readahead(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, readahead_index(rac),
 				readahead_count(rac));
 
-	while (iomap_iter(&iter, ops) > 0)
+	while (iomap_iter(&iter, ops) > 0) {
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		iomap_read_submit(&iter, ctx);
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);
-- 
2.53.0


