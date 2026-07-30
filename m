Return-Path: <linux-erofs+bounces-4044-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5AAC531D0
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 08:13:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9hmX6LWsz2yjp;
	Thu, 30 Jul 2026 18:13:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785399228;
	cv=none; b=ixbFELlG/OXFGS0f/oVqu5KgG7H8TZUtXmn1QuJTF19/10eMUZTgKN5Ftz5f+XQIxYbI26+oTxCDrmucsnxR6WGPXHfvAZ5t6p8BcV/FP2z3781Tfbx8CKdIuWISlOWNHW3d7V7mhRS2qKgetyhxh6rZ2FoBYi+90ynPFXZAWi2IGXmd19Xc9dH7xJ0map8Cclw6/5oyPLZ7WdbBvrdoN5yernwFC/EgmMOFlM8IXpX1K/O9jDz8fYt/aiB4z+13ZCRrCJrv8PNXbyJy7M7QqUQt7G2NrMUhuU+SVbpRG+Wb+LGngiNdKAEDNtzwgGdL4acKAY+wcmup5mnPLvo0LA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785399228; c=relaxed/relaxed;
	bh=STnZe2MMCF/BzC03VvW9KYRg64vjJ4C3hF7Nl3+7RDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aV/4Js9gvx6pJ7vplNUnAUnPY38jmGsLkLF5wopBNzemNb50hyq0E474Is/8MnzbIzUBOCKPMCQkNRPIGHhwmONl1yFPCVZoOeXIe+yYNHVj/X9Ifpcos+jmLkT34PZd0XuIvCIeLEyF2MmK2RNamX/5UrwGVmLkwwklAud8sjIpxLUWK7MDxkg+RvmKnBrb2DTh2RWDJPEpdzaAFk7gy7/PPYT6k/vBIsfEpXZunF/Kv5v8X5Zb3P84QHFL0ftrVZExjGq9Z1qKaxSfLwVpGZ+GqLSQJ/u4gezwPQbbk6qYPi7iWGJAcfBcUK1Lw5EUm29FPvr7VSRmpGqCOAuvBg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=HXnE18tZ; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=HXnE18tZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9hmX1kfKz2yhb
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 18:13:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=STnZe2MMCF/BzC03VvW9KYRg64vjJ4C3hF7Nl3+7RDA=; b=HXnE18tZYg3z1yOR/vmkbR0e8+
	owNT0191K6/UHsvHlua/zgTPNh+47Mrlet9VRkD9YOmskNQ/80p4l1obKzRYpCGKFK2MtYU7TtyBE
	QK7pHvVOLyKoFlcEqf53voXwTboFbLoHobPt7cmSzgai4XWYpKfuBTiEBa8cJdaoV2k/2DjgijOrz
	47Y58aaxz3ZmSK/0K3lIEgqq5eMANYzbG5Dun1BhAiFZooTUwdLf1QlnI3zuvXNZB5kjfpSVqgnsz
	B1rb3EeP5hQ3vjcheeUz7cCvXG4m0YUzgFz2zFCUn8ORPE8USQ0kcGerQGWURqWi+FHR+hqLmdE8F
	LLVAXE1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLtV-00000009pHc-2Lu2;
	Thu, 30 Jul 2026 08:13:33 +0000
Date: Thu, 30 Jul 2026 01:13:33 -0700
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
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <amsHrVCJnuXzeGG1@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 02:57:53AM -0400, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
> is added. This ensures that bi_end_io runs in task context, where
> folio_end_dropbehind() can safely invalidate folios.
> 
> With the bio layer now handling task-context deferral generically,
> IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
> route DONTCACHE ioends through its completion workqueue. Remove the flag
> and its NOMERGE entry.
> 
> Without the NOMERGE, regular I/Os that get merged with a dropbehind
> folio will also have their completion deferred to task context.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

This seems to be missing the bug fix you identified for the double
deferral?

I although thought a bit how that could be done cleaner, see below:

>  		ioend_flags |= IOMAP_IOEND_SHARED;
> -	if (folio_test_dropbehind(folio))
> -		ioend_flags |= IOMAP_IOEND_DONTCACHE;

I'd keep this flag.

>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>  
> @@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
>  		goto new_ioend;
>  
> +	if (folio_test_dropbehind(folio))
> +		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);

And move setting the flag to iomap_ioend_writeback_submit, and only
for the case where no io_bio.bi_end_io is already assigned.


