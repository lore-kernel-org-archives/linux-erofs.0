Return-Path: <linux-erofs+bounces-4253-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3988AC5DF6D
	for <linux-erofs@archiver.kernel.org>; Wed, 19 Aug 2026 05:56:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hPwmL1X8Nz2yQJ;
	Wed, 19 Aug 2026 15:56:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787118962;
	cv=none; b=GF1qbw0sDlH9aOSSUyYitx3OW702yBh5+1U7+nBDOt2uQEyL3D8g9k3R4RAzTr81pnHS/g++Pldyh+oqX9nDsvt3rDIHvnE1xV146Cn7E7kOqLBwfxkuOK8SVZ2Wg7Yw4VlvLRH/udf1Q8eILqHc2uTIktmKbeUG/Ucg47/kDTsoEdaSP9cRROaJFqYxd6eDdWuhSyO1oqZVDwBlDK0m0Jfk3XrmWjyo666l67ccmO091PDXvd1wGCU6puwNHVEaZ+mN6eLBdx8oojJe0MwDcj/TLgDbKf+Hs0rm7nPgx5Svk7E39TqQD0ELZH7fLJA4M/37rNhdcK7d9551rWdqHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787118962; c=relaxed/relaxed;
	bh=K8bMPBkYtARjcSd9hBM7FNI9dAbkKzf/OcgllMQXUiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OaokGlQnR+C2EgWSRl2TIQL83zLsKBs13nF0+IkqaU3QzS25nWTBJEPK2Bal8VKSKDwLCyN0yDGzv5uQCKj9lVyais9LCQo0xON9s290TAOTEmff8lmx7SYY2yYmi58OhOfLKf1ojZRtWoe5iIgZUpEr+bYBq3IFaeAZFzktPixStUff87nbrOUQksFc6gOi6U51NmG6/z4Wld2fgrWM8dy79nucRfxsedKsnCjdzjL7hB0+Rw6UZ9JgSuXGiWCShzHjlOYGvqnXBS2T5qMmZD4JqqY5k9zjoaoY4FbclWwpzdtxvdCPwoB5EwEcLy75Qoa8qiQCd4nSZxjywk894w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=g3iyVUQA; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=g3iyVUQA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hPwm909GVz2yFP
	for <linux-erofs@lists.ozlabs.org>; Wed, 19 Aug 2026 15:55:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K8bMPBkYtARjcSd9hBM7FNI9dAbkKzf/OcgllMQXUiM=; b=g3iyVUQAh5P0JjYZQyt4nlYQSz
	XmJyVUPiDyuFOLTFqe9LRT9CGDHVSUlihiTrp3Kp+cUDl6BMi11M84CtLbSe/VP2CxT2U9aRb+zz0
	2b/Sejwiqs3R+H1tAHv3VYmWsHfEjRgrf54uDcBF9k72BSmTQ+Tuk/NYCmVcfD+u+3tZIy9Z/8+AA
	DYjKjf62n3fnE6rWVQIekomE35AwqyB6mHOUuPtsf2HwlwrY7fp4E1JR8MxtVDEmF6TU+vRdBiX5g
	NpqNj8lUwS6Xr3f3kegWtHTPcqC7mAcPqoPKYmIKY9FoUPrYR9dpujVk2comx29TNdFJn8Ab7vHZ4
	0SNAIDnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZH9-000000093BD-1A0r;
	Wed, 19 Aug 2026 05:55:47 +0000
Date: Tue, 18 Aug 2026 22:55:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2] erofs: use dedicated meta inodes for file-backed
 mounts
Message-ID: <aoVFY0jyMGpcu1NX@infradead.org>
References: <20260811080852.29418-1-xiang@kernel.org>
 <20260811090717.29787-1-xiang@kernel.org>
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
In-Reply-To: <20260811090717.29787-1-xiang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 11, 2026 at 05:07:17PM +0800, Gao Xiang wrote:
> access on file-backed mounts (although I still don't think it is
> necessary due to the EROFS immutable model). As the result, metadata
> cache won't use the page cache of backing inodes anymore.
> 
> The "managed cache" was originally used to cache physical compressed
> data according to the current cache strategy and I/O patterns; since
> file-backed mounts also need to access physical data for metadata
> access, it's natural to reuse the managed cache for this too, providing
> a unique inode for all physical data access.

This look sane.  Any reason to not use the meta inode unconditionally
to simplify the code?


