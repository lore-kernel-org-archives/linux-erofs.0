Return-Path: <linux-erofs+bounces-4185-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E23C5B567
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 19:37:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJlQG2QVMz2yvM;
	Tue, 11 Aug 2026 05:37:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786390646;
	cv=none; b=gHB8VQXcjd826AjIrocVjUd7PeqYlE0IZjascRo8x99fvDFLRME3rsTqmPiS4An6lHEiYX0tnUUa4Pu7OBSZiBUcMoGhou4UCHvPx11pFu7mKW3+IbZfRZ9tZOEcgQqzmXUEP6LOs9TmaSoCIQ/nHCGXxkuu70TqXMzpx9SUsWW6ZTHTuNLXT3sgFSi1Np8KF02tC3J4O8eQs5XtLtuC1da6COxLYiuwQorWHG0yfy9BevzpdR0tkE1/9Cm+7hT4z1YlTJ+SBNcbG3bNe5ISmgDa0JfcLX4s78j/iiT0/2207oPktHhpqRfMVwKfjgqTQdKvR4JNvrRnOLNCD37ETg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786390646; c=relaxed/relaxed;
	bh=w8yXT5X28jD8ZzH4O3pAXcMg6o723h3Ulp37jcRX8zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsUYdFlwdALQTDCC2QkCpAAsaFuY8/l1zR8m4x2g/ar9ybXgQriMyYK2TgTBchNJBLeJ1Zp1cp2hE2gdOKMfmq0vqxIA1Kq5xUtp5GniCMu2bkOF5ctjHowM1B9oqPnhJlvjWa+XVy/cog7ANxViQqeqZgDXb0rqxcXOfS87BBK4argBz4VYyFTjZcCrvvyQsfyqhfu9ztgrKOSwPImcaBvTR/lyz7zjAIZUgd9YgMjiqlivscRrYiz64t8MW6xw1iFc3tYRkbYGHM/7fislh5Dfmyh0hjCIiixNv3UeCe3parXqfDn8zkibZc3+GvCPOi4qwYPUPMnhB98bDN5xsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=WyOU0EKD; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=WyOU0EKD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJlQ54nvWz2yvG
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 05:37:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w8yXT5X28jD8ZzH4O3pAXcMg6o723h3Ulp37jcRX8zM=; b=WyOU0EKDsMOUdYmkMDteNK0iH7
	F7H7rskf1JokJLT1sQ+3xAt1pEzIgkcKhjpvQMcjn+SPkJuP24dAXc+GS5rOQWk3hyGKxtSvEnmBQ
	pdSulUxOSO+5Ikl81Z6EJqFs1Z5Fe5ZdnwawU1wzR32ZA4dea55YLGSTXpEslBD5OWVpqJMwHiwW0
	yAp7+IHx0GoJ+uRa2276XVR5u1tSr7g87aYgAVkRYjCRDfobiAsEyLcLUYHMeLGTRdnqN5Ecdwc2B
	Bk6L64D/tgDrL4L6zUmRIYHoGlnCWfC9pUN73VJQM6UkqdDR48ZANjy8hz4tUKzR4rOLjtpRRUJ2B
	qLnlp2Zg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtVn9-00000000ss5-2mP1;
	Mon, 10 Aug 2026 19:36:11 +0000
Date: Mon, 10 Aug 2026 20:36:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Christoph Hellwig <hch@infradead.org>,
	Paulo Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v9 04/26] Add a function to kmap one page of a multipage
 bio_vec
Message-ID: <anooK9-UCNTmoSAq@casper.infradead.org>
References: <20260810144746.574036-1-dhowells@redhat.com>
 <20260810144746.574036-5-dhowells@redhat.com>
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
In-Reply-To: <20260810144746.574036-5-dhowells@redhat.com>

On Mon, Aug 10, 2026 at 03:47:21PM +0100, David Howells wrote:
> Add a function to kmap one page of a multipage bio_vec by offset (which is
> added to the offset in the bio_vec internally).  The caller is responsible
> for calculating how much of the page is then available.

I think this should be kmap_local_bvec().  Living in bvec.h makes sense,
but keeping it in the kmap_local_ namespace is better than putting it in
the bvec_ namespace.

The bvec should be const-qualified.  We're not very good at
being const-clean, but let's try harder ;-)

I think it's better to steal the same terminology for the kernel-doc
used in highmem.h, just for consistency:

/**
 * kmap_local_bvec - Map a page in this bvec for temporary usage
 * @bvec: The bvec containing the page.
 * @offset: The first byte within the bvec to map.
 *
 * This will not map the entire bvec, only the page containing @offset
 * from the start of @bvec.  Unmap the address with kunmap_local().
 * See kmap_local_page() for nesting rules.
 *
 * Context: Interrupt or process context.
 * Return: A pointer to a temporary mapping.
 */

> +/**
> + * bvec_kmap_partial - Map part of a bvec into the kernel virtual address space
> + * @bvec: bvec to map
> + * @offset: Offset into bvec
> + *
> + * Map the page containing the byte at @offset into the kernel virtual address
> + * space.  The caller is responsible for making sure this doesn't overrun.
> + *
> + * Call kunmap_local on the returned address to unmap.
> + */
> +static inline void *bvec_kmap_partial(struct bio_vec *bvec, size_t offset)
> +{
> +	offset += bvec->bv_offset;
> +
> +	return kmap_local_page(bvec->bv_page + (offset >> PAGE_SHIFT)) +
> +		(offset & ~PAGE_MASK);
> +}
> +
>  #endif /* __LINUX_BVEC_H */
> 
> 

