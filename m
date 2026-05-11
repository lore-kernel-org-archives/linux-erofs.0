Return-Path: <linux-erofs+bounces-3392-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1747FCD37AC
	for <linux-erofs@archiver.kernel.org>; Mon, 11 May 2026 06:18:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gDV0v23xGz2xSF;
	Mon, 11 May 2026 16:18:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778480335;
	cv=none; b=f39Ui2+xrzW+YiD++cdGkaw+/k1tl5OrCRLUIsTFEKK4uog88ldXfWj0QzcyNmB8DPNVazpAvqkF3ngIyMDfaWzaFUzZnP47cQhYTmaWsJE/z34BWdNbC0oORfXqsiznETZkvYsaUE+Rx0I5Z1bDWAOYH/tndcyaI1vZ0U264IFPXL2SfYKth85qTpTLXxnewtQUzynHiKsD8363Gh5Xo00+c9eiQsObql5ZDIvY/CkfqhXOLazZl4ZX6cDhirCKqwJeoPsHQGBb7EUtow2UrHSxza9F/PykkVciys/P6JPK/pZgoSIftvKd86II3e4mMYjmaup9DchWpfU3PC7nbg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778480335; c=relaxed/relaxed;
	bh=QUzB0vtFO1H2OCGd0aM3xe8F77OrZDRCrHXJ9f+x6G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AK2qJ+kr8Tdq4zUnirMtLNNn9+yE+Y+F+aGrKv794X2JOi2jcw4TLZx9lpEhPGrI+ygW2+f/OeQqV9o07i0EsBybpvqUmCsdcVc1YrNfLJll1UsBASjpQ68KHe394da7mmObpENipxK60/dtdrrElBWQC835ESRzpaRP+VdEAwoQJTGTU9iqyIPsIOs08X4ULR4j+6tw3eXEZkNzOZ+PDQHQk8AENAKad6cnQw4OiAvp671QIhMjEmS4u2CymMY8Xi1tw8W51eWORh+4g5fM/vayUmjTw+KG3BlxUgDpMsnINrQK9f4J9uCMZ2DLiXqjRNLS00XY/FEoneP7ZfJgLA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yJJMCrzY; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+13670275a3c3dad42177+8296+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yJJMCrzY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+13670275a3c3dad42177+8296+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gDV0l5FHCz2x9N
	for <linux-erofs@lists.ozlabs.org>; Mon, 11 May 2026 16:18:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QUzB0vtFO1H2OCGd0aM3xe8F77OrZDRCrHXJ9f+x6G4=; b=yJJMCrzYqeJoVQLb0lSpEthgie
	KJ4ISZY92D9rTQ6iWYUbeYHkrzIVeC8mEmH3+in2LVpBXpXZx7tl6STmTeoz88JhE4ITGPOKu9QrY
	Fknyl29GVPdGPjx9auYyna92ibWxC8OQsaqrdRDfcrP/52ATRkINSYeYm2l0nImlXvmr5rsIPh23P
	80mpZkrUwBZJsowKJyYkhUVWfbeV+JR7GSn2pz22RXEgZLm6sTRb+sGTQbfkchQZPteUO2j19xX1h
	OdpQCzKcAlm8Eny6EfZs+gnJJ/pmlMJemCUKyyCFt2QIqQV/BW2xDwYFJRNaTv7C9SOUdlAhJaHBD
	zs5xukSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMJyS-0000000CT8m-1XF5;
	Mon, 11 May 2026 06:18:40 +0000
Date: Sun, 10 May 2026 23:18:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-erofs@lists.ozlabs.org,
	Chao Yu <chao@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com, Carlos Llamas <cmllamas@google.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Tatsuyuki Ishi <ishitatsuyuki@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] erofs: use the opener's credential when verifing
 metadata accesses
Message-ID: <agF0wJSFRAEcRP8M@infradead.org>
References: <af2kDfHe0B3LnvVm@infradead.org>
 <50668994-b6cf-4288-9ee2-0264bad2b271@linux.alibaba.com>
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
In-Reply-To: <50668994-b6cf-4288-9ee2-0264bad2b271@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 08, 2026 at 05:10:21PM +0800, Gao Xiang wrote:
> On the one side, I hope if there could be some interface for
> such temporary usage rather than just one vfs_iter_read model.

As in a in-kernel mmap?  While not entirely impossible, the locking
model for that sounds horrible.

> > Now for reads it mostly works on the most common disk-based file systems,
> > but it does create lots of problem for slightly more complex ones like
> > network/clustered or synthetic file systems.  It also really breaks
> 
> Just out of curiousity, could you point out one specific path
> so I can look into that.

file system might require their own locking, e.g. cluster locks for
cluster file systems, and at least in the path direct page cache access
also caused problems with NFS data invalidation semantics.  Last but not
least ->read_folio has a file paramater that isn't really a file but a
file system specific cookie.  So calling this with something not managed
by the file system can cause problems as has caused crashes in the past,
although the offender at that time (the old smbfs) is now gone.

> But could we just fix this issue first for previous linux versions?

I just pointed out another issue.  You'll have to fix the credentials
either way.


