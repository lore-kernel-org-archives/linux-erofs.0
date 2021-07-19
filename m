Return-Path: <SRS0=RNpQ=ML=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03C6C636C9
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 15:23:11 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6ADFC61375
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 15:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ADFC61375
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GT5Fp168gz30GN
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Jul 2021 01:23:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=lst.de
 (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de;
 receiver=<UNKNOWN>)
X-Greylist: delayed 583 seconds by postgrey-1.36 at boromir;
 Tue, 20 Jul 2021 01:23:04 AEST
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GT5Fh0Jr1z2xKP
 for <linux-erofs@lists.ozlabs.org>; Tue, 20 Jul 2021 01:23:03 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
 id 1206568BFE; Mon, 19 Jul 2021 17:13:12 +0200 (CEST)
Date: Mon, 19 Jul 2021 17:13:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3] iomap: support tail packing inline read
Message-ID: <20210719151310.GA22355@lst.de>
References: <20210719144747.189634-1-hsiangkao@linux.alibaba.com>
 <YPWUBhxhoaEp8Frn@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPWUBhxhoaEp8Frn@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: "Darrick J . Wong" <djwong@kernel.org>,
 Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Jul 19, 2021 at 04:02:30PM +0100, Matthew Wilcox wrote:
> > +	if (iomap->type == IOMAP_INLINE) {
> > +		iomap_read_inline_data(inode, page, iomap, pos);
> > +		plen = PAGE_SIZE - poff;
> > +		goto done;
> > +	}
> 
> This is going to break Andreas' case that he just patched to work.
> GFS2 needs for there to _not_ be an iop for inline data.  That's
> why I said we need to sort out when to create an iop before moving
> the IOMAP_INLINE case below the creation of the iop.
> 
> If we're not going to do that first, then I recommend leaving the
> IOMAP_INLINE case where it is and changing it to ...
> 
> 	if (iomap->type == IOMAP_INLINE)
> 		return iomap_read_inline_data(inode, page, iomap, pos);
> 
> ... and have iomap_read_inline_data() return the number of bytes that
> it copied + zeroed (ie PAGE_SIZE - poff).

Returning the bytes is much cleaner anyway.  But we still need to deal
with the sub-page uptodate status in one form or another.
