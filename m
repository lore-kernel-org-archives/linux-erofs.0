Return-Path: <linux-erofs+bounces-4135-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385E3C55822
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 13:04:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDtzk6L8hz2yMl;
	Tue, 04 Aug 2026 23:04:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785848674;
	cv=none; b=ETLYT5Ou7I2VLbwtsqXsJylmIyfouXBlPqerOOPa1KXeeWupTh0/zaMvThI1YLRGMJCOhFKjkmh3HZ2zNAHT1Pq7z5Q98u0uyt8Avg+7A8i5cHKqMk9CozSoR8/v1t6JecTB/w/J8jCz/yXqux508KFLsMB8ccPakuzumru6Itl5HG8L9pCjwhg055SYn7qWxe4EzdHN5XkdbQFmodYTq+8XgAyoq1wQP3EaJv4fL0fbRBkpkTELWIM5u5rMxbt4a00kX1PWJY/BBidenrBbVV8OZEm0FJzVy6JaTuPIK5HoXQf3lHMecIxiA1djJomp82Gn+56GO95xH7ZEkxRMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785848674; c=relaxed/relaxed;
	bh=LQl1PoD9whXshfiGdiRGN/MouZH83WKAc5uKqtzgf1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lwc5fUizXpXuWI1F1LTvwcgV1W70VcqQMBjwhpYikDir3wM8HwuvYMb4aRgeAz3BA6MWHWj7caC/BNHwxxQ79yJTeQo6435P4fbmAKUalpsXikTsW8U793FI3vdBwejsHEodk2TpIYR88l8HH+FRPSgyEorUeVcEsZ5F+dscxn2lmwmNkw6oYoBULrts+cT1fSWIuRumSCRJquuI1GrC4ACyW4Avy2Zv6f+KS7u5vs5CssNFEtuIy0hg5bo1bJS2qieQzyMoBLfteCOXWLqAY3aTDjTn0sUPF1PXT3IeBSlsSIrX4YxMTAiAkE0qMUp09juJrvGkexAR5bADVBZycw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=K1Rf8ruX; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=K1Rf8ruX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDtzY09wBz2yLY
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 23:04:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LQl1PoD9whXshfiGdiRGN/MouZH83WKAc5uKqtzgf1s=; b=K1Rf8ruXaCO0RHwTW3HGNdLxEN
	UehSuFaYjmEaaycnFZiN1zXEnHPIpv5BQe5q+js0SXAxb3TK4Eyyw3IFJBYhM991O+oZBiGLyF4xG
	D/IIu5cl0XYEmgzOftRVRUHYN0XXfbhDwmMRHoW584lsu4K91Vgou+tdv96EGyc46GJRVKMo6RSYf
	LqEIlAUHCod75QZwf7Q/l+n7ZL+VQdaZw4K8MgdXixh79SEAGwHL3U71hMpCYhR0qnT27wkXgDvr3
	3FvJDKRGqJXN5nNn6rOJV/Dhnq0BaFup841dec2g2gf0W9CppXwCz5+owbsrZyrUQcBApb1qjNLMX
	3gt007yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEoF-00000001sbx-14Kr;
	Tue, 04 Aug 2026 13:03:55 +0000
Date: Tue, 4 Aug 2026 06:03:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
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
Message-ID: <anHjO1vokMmADsZP@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
 <amsHrVCJnuXzeGG1@infradead.org>
 <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
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
In-Reply-To: <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 04:39:03PM -0400, Tal Zussman wrote:
> Sorry, I misunderstood and assumed you'd take care of it in a follow-up.
> I'll adjust it as below and send v8.

My plan was to move from the version you had to something better in a
follow-up.  Anyway, Jens merged it as-is so I'll look into a fixup.
Travelling for two conferences this week might make this a bit slow,
though.

> > And move setting the flag to iomap_ioend_writeback_submit, and only
> > for the case where no io_bio.bi_end_io is already assigned.
> > 
> 
> To confirm, this would only work because XFS provides its own task context
> and is the only consumer of iomap that sets its own io_bio.bi_end_io.
> If another filesystem set it and didn't provide task context, this would
> break, right? I can add a comment about this requirement, but I want to
> confirm the intent, as it feels a little fragile as-is.

Yes.  And I think this might be a good time to actually open code
iomap_ioend_writeback_submit in XFS and remove the "accept an overriden
bi_io_end" thing entirely.  Back in the original code that was required,
but now that the submission happens from a file system methods there is
no good reason for keeping it.


