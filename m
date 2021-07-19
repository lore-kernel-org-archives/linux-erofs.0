Return-Path: <SRS0=RNpQ=ML=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6730C07E95
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 16:32:22 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5190160FDC
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 16:32:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5190160FDC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GT6nd0N66z30J5
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Jul 2021 02:32:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=aukGzst6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=infradead.org
 (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org;
 envelope-from=willy@infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256
 header.s=casper.20170209 header.b=aukGzst6; 
 dkim-atps=neutral
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GT6nV2NQtz2xVt
 for <linux-erofs@lists.ozlabs.org>; Tue, 20 Jul 2021 02:32:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=t0i+7tXFhVAJI+nlAjaCd7T6XGAQwmoipG3wOX3BNN4=; b=aukGzst6WKaOLTfMq0IMTJVP/W
 oW4ss9z0jiy2pgZaSBv/ZXarhM3VSBxdESUqy1kE7h1qXvBgiIdjbm1D5q+RQYj4PbqsL/t0+kqlh
 dy6KPznHqP5JpRsC8Xa6dnhQQapIQxbmuO7likzE6uh9ZP2tXjdzgXqWkCJ4c1q/Fai8CAtY7t6Ac
 t+jsX6iBmhYsMWUt6mBRrwDTTms5h2MroCNEe7CqBtzOy3GiC/Ba8I8TUexNnYJy7PGganCeqDRpn
 nmt7X3oDM8G4sFx6X+DCZ1DvbmiOAMgQs2eLqI2bNgkE2ElmUrjlqjBK82Y04+jrqh5xZE024sN6A
 tfAYcc4A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1m5WAg-0075UR-UE; Mon, 19 Jul 2021 16:31:29 +0000
Date: Mon, 19 Jul 2021 17:31:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
 Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH v3] iomap: support tail packing inline read
Message-ID: <YPWozhzNIljcC83R@casper.infradead.org>
References: <20210719144747.189634-1-hsiangkao@linux.alibaba.com>
 <YPWUBhxhoaEp8Frn@casper.infradead.org>
 <20210719151310.GA22355@lst.de>
 <YPWkRRzy5reIMu8u@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPWkRRzy5reIMu8u@B-P7TQMD6M-0146.local>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Jul 20, 2021 at 12:11:49AM +0800, Gao Xiang wrote:
> On Mon, Jul 19, 2021 at 05:13:10PM +0200, Christoph Hellwig wrote:
> > On Mon, Jul 19, 2021 at 04:02:30PM +0100, Matthew Wilcox wrote:
> > > > +	if (iomap->type == IOMAP_INLINE) {
> > > > +		iomap_read_inline_data(inode, page, iomap, pos);
> > > > +		plen = PAGE_SIZE - poff;
> > > > +		goto done;
> > > > +	}
> > > 
> > > This is going to break Andreas' case that he just patched to work.
> > > GFS2 needs for there to _not_ be an iop for inline data.  That's
> > > why I said we need to sort out when to create an iop before moving
> > > the IOMAP_INLINE case below the creation of the iop.
> > > 
> > > If we're not going to do that first, then I recommend leaving the
> > > IOMAP_INLINE case where it is and changing it to ...
> > > 
> > > 	if (iomap->type == IOMAP_INLINE)
> > > 		return iomap_read_inline_data(inode, page, iomap, pos);
> > > 
> > > ... and have iomap_read_inline_data() return the number of bytes that
> > > it copied + zeroed (ie PAGE_SIZE - poff).
> > 
> > Returning the bytes is much cleaner anyway.  But we still need to deal
> > with the sub-page uptodate status in one form or another.
> 
> There is another iomap_read_inline_data() caller as in:
> +static int iomap_write_begin_inline(struct inode *inode, loff_t pos,
> +		struct page *page, struct iomap *srcmap)
> +{
> +	/* needs more work for the tailpacking case, disable for now */
> +	if (WARN_ON_ONCE(pos != 0))
> +		return -EIO;
> +	if (PageUptodate(page))
> +		return 0;
> +	iomap_read_inline_data(inode, page, srcmap, pos);
> +	return 0;
> +}
> 
> I'd like to avoid it as (void)iomap_read_inline_data(...). That's why it
> left as void return type.

You don't need to cast away the return value in C.

