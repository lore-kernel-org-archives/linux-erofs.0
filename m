Return-Path: <linux-erofs+bounces-3582-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC209CD98DC
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Jun 2026 08:04:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gcBqz0tC6z2ykX;
	Fri, 12 Jun 2026 18:04:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781251471;
	cv=none; b=FxFZ4A5+hSHEVwK6SiTF3jrbuF8/aR9I49T3GioucWzjfXuvVX63/1D9j3TtwAL44GcOCobkNJQh1AuLay9H54+idsFZmBBqhXoFEgUaqPpEtgQcjc+VBxh/5ijqoyxXfW29fUctYt/yamX7UNk3UoywyPEzD3BQE7D+LfvKbijcfz3zD0hF6vkmcUtb7U+AX5mYnbcNjExLlhf3o8sCF/XabYgOUW4KwHT0WFTocr1EzjNKFFW+oHfolweMf3RkCcCxFo3RNj7LrBoZZYCZgxggmZTtPi0oaWMQSb5AIXhTnIxOgIsAT9VHSG9uLFrwwEIthMFyJVyOWZMdK92oLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781251471; c=relaxed/relaxed;
	bh=0ihkg1BpPN6WDh+Xj+gutcck2344hxpx3EQTJxaNIzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLmaoXOrnF0sxcXqjKoD5jF9Ln4+yAxuYq4js2S0zG+xwLCBykJNMUamGY78xich8Gfc8V9y2v2PO5GFLsvhvRcDNtObY10xj6S6f4pLxBONVNOGW2HOP++tJI9ppJ71qOtuQp/n8L15rWPzkNqEybBxEN1ppXRGYFl7bl1n8faK61z+2Zt1JpqpDDXio1sNa/G8fhEOgVf1lgsIC0UuXaf2pTj1a7Fiqhx5t4G4pgQqYQV6FCZtV+qrOhZfJRc3nhS7UHDyx4/O4bmPEZTkP8BKufXnFvOFGc7s+QGGLx8Vi6Uzwr71rebNPWNhwI18kRfWf1oL7hIAjIe/N1aQJw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wc5Cag2Z; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wc5Cag2Z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gcBqx0l9pz2ySC
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Jun 2026 18:04:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0ihkg1BpPN6WDh+Xj+gutcck2344hxpx3EQTJxaNIzM=; b=wc5Cag2Zc4drAvR4ORaMcn9cZS
	mnahB9H3My+1sQ6zybnO5AG9bad2yEZveqEdNU7DYahkvGihQqLxraVFiDpD1U8j3GDPJ9wewnkTj
	Iwoa1F+MfjOQJwWSmhxkQfjE/sg5xmWO354Ka4uc3Siptoz3fQYlhaovas52qkEnrPJZY9+cR/cXA
	HA/jQEo7z+966L2nK6GHdVXTONE1ip31wzYgOM+k3fjfsWIG0H9VK6h5J6bEFciAcCzYhqSU1saYV
	u3X/KNzq3KkNQj7q8p5+MUxls3XKjmh/P626GdTKZHuskhLQwjrmqLS+GYt0lKwVXGM0fIC3SPyMO
	yfbrodNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXwsM-0000000AXjf-1g9e;
	Fri, 12 Jun 2026 08:04:26 +0000
Date: Fri, 12 Jun 2026 01:04:26 -0700
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
Message-ID: <aiu9imWL_c1eyerw@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
 <aiuw0QvFIhEWUPG-@infradead.org>
 <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
 <befed994-02bc-42f8-945c-2aea3e3b10b2@linux.alibaba.com>
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
In-Reply-To: <befed994-02bc-42f8-945c-2aea3e3b10b2@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 03:35:38PM +0800, Gao Xiang wrote:
> btw, there may be be some edge cases like:
> written | hole | written | hole | written ...
> 
> and if bios cannot across multiple iomaps, bios could be
> amplified according to the shuffle pattern even all written
> data is consecutive on disk (the block allocator may
> allocate written blocks consecutively.)
> 
> Anyway, I never tried to argue with this cases (yet both
> previous buffer-head and mpage codebase will merge this
> except for some specific exceptions), maybe it's just a
> pure artificial pattern and I'm worried too much.

We actually just had something like this come for XFS even
with the current merging:

https://lore.kernel.org/linux-xfs/6csdtjn33va4ivyycr4uh2ogac22xput4kgzxzt3mczdkvwjaf@37audfdijskv/T/#t


although this involves REQ_NOWAIT and thus is a bit more complicated.
But the merging scheme discussed there should also help with your
above case in general.

