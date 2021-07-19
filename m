Return-Path: <SRS0=RNpQ=ML=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1393C636C9
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 08:41:27 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F2D5611CC
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 08:41:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F2D5611CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GSwLF4d4Sz30DR
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jul 2021 18:41:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=A9Xm6YNl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record)
 smtp.mailfrom=casper.srs.infradead.org (client-ip=2001:8b0:10b:1236::1;
 helo=casper.infradead.org;
 envelope-from=batv+9026cc9f21ac068c1222+6539+infradead.org+hch@casper.srs.infradead.org;
 receiver=<UNKNOWN>)
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GSwKY1nQ4z2xnc
 for <linux-erofs@lists.ozlabs.org>; Mon, 19 Jul 2021 18:40:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=cc8WxTp9u8HYpKx7zXqvjDzDZErsRxFk/MMnyKkMLQg=; b=A9Xm6YNlWN+nzI/dpgXm0abe3A
 luJ1k4KEHp2gDhChrg4AiKI+M2OZ0q+Ux0kqutpjRVUORh32sJIEUA+Arf7sYFFaUVusZPNRER6MD
 CIUar6CD9U4dE5V1h8tVC37BNxgzxwnM/1BgOaC7jyW6/R0TZUEFnMOI14yYCIXgRb5qxTiR/Ynmz
 m+2Elq52B126zZr+Kcytn4Xq7rRrlOSxTV9yGflhkk80X3rJV9CFp961ly+zL1kf8P0jwmQ0nyT8L
 hyQSQLKZuF5VKo7Ixfq8omp22OV4030nCh9yUdu2buSXncSp7cIZh+LLeDgFHGRAo0wIZPqXZggjM
 xKgjAg0Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat
 Linux)) id 1m5Oo1-006f6U-0s; Mon, 19 Jul 2021 08:39:22 +0000
Date: Mon, 19 Jul 2021 09:39:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] iomap: Add missing flush_dcache_page
Message-ID: <YPU6NVlfIh4PfbPl@infradead.org>
References: <20210716150032.1089982-1-willy@infradead.org>
 <YPGf8o7vo6/9iTE5@infradead.org>
 <YPHBqlLJQKQgRHqH@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPHBqlLJQKQgRHqH@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 "Darrick J . Wong" <djwong@kernel.org>, stable@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Jul 16, 2021 at 06:28:10PM +0100, Matthew Wilcox wrote:
> > >  	memcpy(addr, iomap->inline_data, size);
> > >  	memset(addr + size, 0, PAGE_SIZE - size);
> > >  	kunmap_atomic(addr);
> > > +	flush_dcache_page(page);
> > 
> > .. and all writes into a kmap also need such a flush, so this needs to
> > move a line up.  My plan was to add a memcpy_to_page_and_pad helper
> > ala memcpy_to_page to get various file systems and drivers out of the
> > business of cache flushing as much as we can.
> 
> hm?  It's absolutely allowed to flush the page after calling kunmap.
> Look at zero_user_segments(), for example.

Documentation/core-api/cachetlb.rst states that any user page obtained
using kmap needs a flush_kernel_dcache_page after modification.
flush_dcache_page is a strict superset of flush_kernel_dcache_page.
That beeing said flushing after kmap updates is a complete mess.
arm as probably the poster child for dcache challenged plus highmem
architectures always flushed caches from kunmap and, and arc has
a flush_dcache_page that doesn't work at all on a highmem page that
is not kmapped (where kmap_atomic and kmap_local_page don't count as
kmapped as they don't set page->virtual).
