Return-Path: <linux-erofs+bounces-3581-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED697CD8CA8
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Jun 2026 08:01:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gcBn12pcbz2ykX;
	Fri, 12 Jun 2026 18:01:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781251317;
	cv=none; b=HebPTpd4Tw4F3AuipYf2F0mTsvHmt3GffOTIJwDgTbqgoUfGugcQnXcWd2AIXeeZ78CJdbAWCpmnsIHxWzMnv10+POCv5tORJkVTXjqXOR4CpDO6jZ3qGNO2if+EuL6tkyL3DmWzU6RfVqdqpjdnPIA58MuTx3Gebe3YRjIYCTfCp+Miwc0bJO36D0I9OzMJrfVveHXHlT8qo8UIvLy9if7h/hLAHpK+RCEVPQyhxlo8eghLuicaPLemIXr99fFjsDiz3d0e9MTbK7ubPa+r59wdj6XUeI1AN67qGprxoMrWGwDOOkGohCENjdAO1o18qR6Lau9qj5x+JTDQSNcRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781251317; c=relaxed/relaxed;
	bh=7jD/MDoTJEp59NIG3rOHJIeJwr7qwvbaSlX946skE5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7ddgQF2rBlCRjjmvzyr6muFnkb9gRcHkp66gFT+p21yOQu9Wbrz9IRdfcG7UKsnSbBS8dTrzjzEN+IZ+ccn4dJFiCfDCiA2iU49Q7TewmBrDQjPMF4pQFWq6KOvlETvB+UdpWht0Z6hZUndTY7cU5X+eR2L12vMdqY5bFmQhp73kw6FLP4LKKqNnRGPghx4WNU5ErShbd60qBLnXQr8ykyMr+03mIyUWvDMx2SBMZSJ9/y3QMWfNIveq9FwN4d69Kw0u+14blzEqbzWho8y9/a/9WbIFUaVcmIuzJ7/U9NfclQ24QB6uryQ7CamZ5NTBNtsrVYtZwh4bb2t7NKgPQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=MjstcFXd; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=MjstcFXd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gcBn01Hlcz2ySC
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Jun 2026 18:01:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7jD/MDoTJEp59NIG3rOHJIeJwr7qwvbaSlX946skE5M=; b=MjstcFXdao1aRwyyZFKF/fflDR
	lS8zRrZghT1BIJVSgucqKLuxpgXsG51cbowL7H/i5TPiMX+lS24R8Hhv4bLFZRyH4D5UHo/oqHFnL
	9rHXGaFZ3mNjHKBJN0YUHK5NpAho622YfZCAKT22BxYNNsUjbNuOYOk+n0j2riY6HIJ6QKQREcvDx
	2bLjMEDy80oALtrFdQ5cbb8mSCd7wzNOi4LUgNKb5nLU0UTY3GW9iHH5nt7P+pbfQPN52dc9OKRl1
	pvJmARgZmdMVlnKnNYOnRQzsrNyRb1Ntr+IJ0VoLmjzTm3SORmeEyfibamTf9JZi5CWdNAauoBU3/
	+zbe4eoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXwps-0000000AXKq-0u6x;
	Fri, 12 Jun 2026 08:01:52 +0000
Date: Fri, 12 Jun 2026 01:01:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, yekelu1@huawei.com,
	jingrui@huawei.com, zhukeqian1@huawei.com,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
Message-ID: <aiu88BAe1EqxpeOB@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
 <aiuw0QvFIhEWUPG-@infradead.org>
 <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
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
In-Reply-To: <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 03:19:30PM +0800, Gao Xiang wrote:
> 
> 
> On 2026/6/12 15:10, Christoph Hellwig wrote:
> > On Fri, Jun 12, 2026 at 02:54:47PM +0800, Gao Xiang wrote:
> > > hmm, currently erofs could return block-sized iomap (if the chunk
> > > size is 4k) even it can be merged with the following chunks.
> > > 
> > > Previously it was fairly good since consecutive chunks will be
> > > added to the current bio if possible, but after this patch,
> > > there will be a lot of 4k bios.
> > > 
> > > But if iomap goes into this way, I could make iomap_begin maps
> > > more chunks in one shot, but that needs more changes in erofs,
> > > it's fine anyway.
> > > 
> > > ... I was thinking the following diff (space-damaged):
> > 
> > That should work too for your case.  But we definitively have various
> > cases where merging over iomaps is a bad idea.  You'll also end up with
> > other efficiency gains by merging consecutive entries, especially for
> > direct I/O and when using large folios.
> 
> Yes, optimizing erofs chunk mapping would be more
> efficient, will work out one soon, but Yifan can test
> your patch in parallel.
> 
> Also, if "iomap: submit read bio after each extent" is
> applied, I guess some merging condition in
> iomap_bio_read_folio_range() can be removed since they
> won't be reached in any case. (deadcode)

I guess we can't hit the sector check anymore indeed, assuming
we never get non-contiguos readeahead requests, which I think is
true.


