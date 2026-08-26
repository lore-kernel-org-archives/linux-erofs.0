Return-Path: <linux-erofs+bounces-4344-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE017C5DF97
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 04:44:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVBrN2qLTz2y2R;
	Wed, 26 Aug 2026 14:44:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787719460;
	cv=none; b=Gtcq3AbJMZngNIHgqA0kpIaZegOCBTFi9zd4VkmF9SsHiLRegjSa/LSJZm67Ds2tbpShyNCeR3Dwb6g6bkQ9Os4IOB9jn6q7RXCtUxoNcL+LXQp+Oe9KCNaJugQqMETndcyP6POP7Zd/VQvvQCWAjZltfJudZOo5DsWQbAxNf2QNbQE/S/P2NZeesP1iWEvEmen8h2MYx4OcDnHsw7O8GIls+PKGkI++WyJcKQTrELtYt3mgFLxyFpEOUl7CtMr0ZXOubn3KtUlUh7ymi9DpiEM2Rhxztq1tpdUVtWPdSegXRT1u0g9JNwaLdYhrEsGIA8SgU8PByH91snSbdHrTlg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787719460; c=relaxed/relaxed;
	bh=VwNk+20oX5Nq5ler9R2U89bGOjpSa70RVJPDevUc9r8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epgWmRyi7gK9nABBGcHmdEVurTlphEuOUTNXVhKrcMnmXD9246hKLxY8RoIL4yESYocNAYwi8CPBwIwLDX+h/87lkZvoOa+9pqcWn+YX5obAGho0dOjXRDXaQoaQoHfPeRIJXc377qSk3PJYHroFnEbIjlRoYqiDEB0+1HXvDlvq1KRfaHghaX2NSkKU8euxyTpwRthpJAY4XeBfaovry46rbCl6dgf2GFcmUYKX8BpVkFiiqqTRRdg3F42oWMYaojLiVh6ODR1K/c169nyphzWJEiPZFfSa40huaq8jMDJD93VPH+aKEErnLBifLv71S9lfnJ+/bB5PvX8LsjOyVw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lSBwEenE; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lSBwEenE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVBrG30yJz2xWV
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 14:44:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VwNk+20oX5Nq5ler9R2U89bGOjpSa70RVJPDevUc9r8=; b=lSBwEenE0P0nCLIF87dRSbJ7QS
	t3FOpFltQvZ8uuWoQGFV61ogv9vco+4yFk26YviwVB77d7lQoff0LWoriw+0f8FnKERTUJQrFaNfP
	UzMkRwPXsa+0uVFRtxVsfkLiuj+1tz0B7mZRgSksXckP8+VtyqTZgI19nJw1k58RpFXT8v46tlMRq
	uCaTf8JronxnTeEld9T/RT28ozmhvWaWa8lINvAmMUMnLSPsDZJNSZoGpo0xQGxvsTMDN3u2BJSnS
	wFWM2v/ICbwxUvhMK3EoV33DcOXPTNzoZ7QPK3CU+Fapn6qJlfz5ybl+zXyXFi9SVaPQcnO+5LWiB
	W9YptFkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wz5Ua-00000001tWL-06Ej;
	Wed, 26 Aug 2026 04:44:04 +0000
Date: Tue, 25 Aug 2026 21:44:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2] erofs: use dedicated meta inodes for file-backed
 mounts
Message-ID: <ao5vE3v-n570dvXL@infradead.org>
References: <20260811080852.29418-1-xiang@kernel.org>
 <20260811090717.29787-1-xiang@kernel.org>
 <aoVFY0jyMGpcu1NX@infradead.org>
 <aocD3jkUnsPlrllM@XiangdeMacBook-Pro.local>
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
In-Reply-To: <aocD3jkUnsPlrllM@XiangdeMacBook-Pro.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 20, 2026 at 09:40:46PM +0800, Gao Xiang wrote:
> Hi Christoph,
> 
> On Tue, Aug 18, 2026 at 10:55:47PM -0700, Christoph Hellwig wrote:
> > On Tue, Aug 11, 2026 at 05:07:17PM +0800, Gao Xiang wrote:
> > > access on file-backed mounts (although I still don't think it is
> > > necessary due to the EROFS immutable model). As the result, metadata
> > > cache won't use the page cache of backing inodes anymore.
> > > 
> > > The "managed cache" was originally used to cache physical compressed
> > > data according to the current cache strategy and I/O patterns; since
> > > file-backed mounts also need to access physical data for metadata
> > > access, it's natural to reuse the managed cache for this too, providing
> > > a unique inode for all physical data access.
> > 
> > This look sane.  Any reason to not use the meta inode unconditionally
> > to simplify the code?
> 
> I guess you meant avoid using bd_inode page cache?


Yes.

> I'm not sure if it simplifies a lot, also like fadvise(WILLNEED) to blkdev
> can perform to bd_inode too so I think it can still have some benefits.

This is actually an artefact of why using the bdev page cache is a bad
idea, because it opens your metadata cache up to external modification
and side channel attacks.

> I think bd_inode page cache can be used for filesystems so maybe leave it
> as-is for now, or maybe a follow-up work if it's really needed.

That's how it has historically been done.  We generally try to avoid
it for newer designs.


