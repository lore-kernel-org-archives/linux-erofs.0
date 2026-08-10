Return-Path: <linux-erofs+bounces-4154-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E8BC5AE49
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 14:46:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJcyF6pSbz2yxG;
	Tue, 11 Aug 2026 00:46:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786373173;
	cv=none; b=dvcByveul+59U9SOchK79PWpdhzGmuPvDTqIZCrAmzijUZd37iEM6IDlg6A5oasZnS7AIDnguzusOcMUxA4QM4HoxO7p8y6eZnff03DvvD36k8Dr6EBoKAlkO99m9vl9IOjgoHOQmvrqaqScNG5oFMa4LnMzp9fdYaA71V9o88+Fk9+EkAS5TxYxa/il8+ELcNxL40Pf2rswnxH7WKqV2j5HhaLGY3Cq+GlpgvLprcZC8b7sAViyqXs6ifU1Ad9PgpnA+fVdBaGRyRnn30naMxc5C4Wkt1syfA6ztt6Uv+PhexcAbJU5eBe7dAMT7wtlJFeQAx3rpKXsRVg+Kn2Q/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786373173; c=relaxed/relaxed;
	bh=1Lmb88p+cpryq5HXWLXRKXYmtZimwxaBhgeOhNY3PzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHVMIgXrWB6QFLPvnecFJ15LLZCllDho47AHr9+n0zXuKLVf5+P006XqSkU3n9Khab4sNuKAw+AMAmIHS6rxPh17dSMSxHWKEPMc690DmB6clKBSm0o5lHZCa4Qw+bET7g4uagv9461F+XOWgCt8/1+z2Scx22U9y4ma8vk8Aho+oiOeZe9phEFB443eJ2+Fj0oP9nhQPy0Gj7H/vCCqqUtpEMDTY7deWSWUGG+/FtLFznkZSQZ5ciPIr/TcNuYIFUomHbqnzmCCGrxN+LnDBlqUbGxZpmYlJsYHDRzBDD3i8yQEfj9d6D002r9ckKlH5lCMVWK8xXuz2ijCDitzcQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZjlpOaxc; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZjlpOaxc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJcy556jGz2ytv
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 00:46:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=1Lmb88p+cpryq5HXWLXRKXYmtZimwxaBhgeOhNY3PzE=; b=ZjlpOaxcjkG2f9OfkwELBNEzTf
	ggKbF5B/67GpDWQrfUEvvWOm6N35oevLeRO+6030iJHPj2PMWXpaVJNv2DIyP+hoYeHLmSGhctapb
	XIWAc93R4BkxMMeHs/qT7cJ04hcrL1srn8hMzvbpo27fVKLTPh9o17t71xQv1LzenM628CCqDIVCM
	0PPEM3Fzl2tBQIgkvF7VFgp+VT6O6s/c5dYBFz1uP5ISwD07DTcy8DmnF5TwTbrxwV4pvYGuhKH0v
	XX+DTw51mufx9Ucgtu6kXV8a8QyxeZIQAMXvdBM9tD4QHFcET45iUo8jbR02cL5G8JYBbwoWtRyNV
	sLfeSgLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtRFt-0000000C3l2-13Nj;
	Mon, 10 Aug 2026 14:45:35 +0000
Date: Mon, 10 Aug 2026 07:45:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: RWF_DONTCACHE regression fix for xfs
Message-ID: <annkDbhXBEeMoNVT@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Below is Tal's suggested fixup for xfs with the whitespace damage fixeѕ.
It should probably be attributed to Tal instead.  Can you handled it
from here and send it to Jens with your signoff/authorship to avoid
the performance regression in XFS?

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: avoid double deferrals for RWF_DONTCACHE writes

XFS already defers some writes to a workqueue when transactions are
needed to process the I/O completion.  Disable the block layer bio
task completion in this case to avoid a major performance drop.

Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
---
 fs/xfs/xfs_aops.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f73e26d9c9f9..059846a8d65c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -372,10 +372,14 @@ xfs_writeback_submit(
 	}
 
 	/*
-	 * Send ioends that might require a transaction to the completion wq.
+	 * Send ioends that might require a transaction to the completion wq,
+	 * and disable the block layer task completion for them as there is no
+	 * need to defer twice.
 	 */
-	if (xfs_ioend_needs_wq_completion(ioend))
+	if (xfs_ioend_needs_wq_completion(ioend)) {
 		ioend->io_bio.bi_end_io = xfs_end_bio;
+		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+	}
 
 	return iomap_ioend_writeback_submit(wpc, error);
 }
@@ -481,7 +485,14 @@ xfs_zoned_writeback_submit(
 {
 	struct iomap_ioend		*ioend = wpc->wb_ctx;
 
+	/*
+	 * Defer all completions to our workqueue as all zoned writes require a
+	 * transaction to be persisted.  This also means we never need the block
+	 * layer in-task completion for a task context.
+	 */
 	ioend->io_bio.bi_end_io = xfs_end_bio;
+	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	if (error) {
 		ioend->io_bio.bi_status = errno_to_blk_status(error);
 		bio_endio(&ioend->io_bio);
-- 
2.53.0


