Return-Path: <linux-erofs+bounces-4271-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80088C5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:40:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQl2H5s8Gz2xW5;
	Thu, 20 Aug 2026 23:40:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787233255;
	cv=none; b=H+TL+n6DIBBJ9LhGxHpsJm5klUSA95+RQcAmG0urbxv9NksRoqww3VEVkXFAPL8g1df9aged4ORC03IfYijChPndZUnBjpPbFNwTuEbx/hXMCbwDbzmsm7YqCt95CPICuPIsARjL3KyMnPE/HdEs3KXgSoKQHZRyKu87xD4JEcYxRlPGN0w7YyC3Ppu4n5biCuvqWQuJaw9kbj4eOWZadf8TWAGsltMSgaUQIebZNXCuenBSpvJA2oo3uxa3cg7+5UY3LZiZIxN1Q7ORjvi5TZvslzkaYrnSV8PJVZUXGCSn4WJ0pRHiWM6+Igp77reBjPh1dpTdvskvRIEGMLd2og==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787233255; c=relaxed/relaxed;
	bh=5C1/sfp0hpxAQ+xYTYGAJFVhzdr//CgmnuBX2/NZFns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPj4npsoQKSkOflm4aejvpUCIdME6mDDxshwCddpnDcmZ4G8thHB+8L1QQvYIXhBOa4mYwmPILCtoNvK+VXULMj/GlkcnUA+Saza+ZIpyb43dvmU9ROnxomsT5WBvMp+hhesJDc2EoJLhqOXyHtWRQvDk6GwPrU2tVa24db68CcXSOVfWhI/DgZrRtZ2Q26LZb074/Uvol5q44sK7A5tUwFoE2J8QET/CWcPs5jqUSHwJtKhJJSqcwfZmvy6TOPvs/oQIr2GFb2P/hd0ALoyqO+dtayE7WJpcTw6MKFgeWzekRBV3z/CUYYgei5PGPNC8MUzPP1gOkd5dK4sRKPJCA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTXA8BIS; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTXA8BIS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQl2H1JZwz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:40:55 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3F7060008;
	Thu, 20 Aug 2026 13:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBB51F00A3A;
	Thu, 20 Aug 2026 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787233252;
	bh=5C1/sfp0hpxAQ+xYTYGAJFVhzdr//CgmnuBX2/NZFns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CTXA8BISnRoT6XNjF1dM9rUijiJeNjuqx1e6/yWHSEUn7+tvFqgHxvK7yhTPF9Qfg
	 bsIv5jTl2sA6RDFILsrZr7lCOfCVJLZbe0CZNLQxhtVWb8HxktgSnSl7xMelDWOkRb
	 XVQkXlxAueTZzHf2DeCRd8osHg58j8DZZ3g1jvMcGfJR/WkiYCisKVUbi8yfvWgq/K
	 oTh5JpVgVn1HN9d9TvIp3K/ygL6npAiANLQwx7989sGP2Nppa7ge+D58/msktlZuT5
	 CsSfex4mH8XfUtZ5eDKnVtVbEoxSIcRzLO1EDqy32xEZJH+4IeluI9ewMrD3cWeLtC
	 MNHX8uojwh8gA==
Date: Thu, 20 Aug 2026 21:40:46 +0800
From: Gao Xiang <xiang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2] erofs: use dedicated meta inodes for file-backed
 mounts
Message-ID: <aocD3jkUnsPlrllM@XiangdeMacBook-Pro.local>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>
References: <20260811080852.29418-1-xiang@kernel.org>
 <20260811090717.29787-1-xiang@kernel.org>
 <aoVFY0jyMGpcu1NX@infradead.org>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aoVFY0jyMGpcu1NX@infradead.org>

Hi Christoph,

On Tue, Aug 18, 2026 at 10:55:47PM -0700, Christoph Hellwig wrote:
> On Tue, Aug 11, 2026 at 05:07:17PM +0800, Gao Xiang wrote:
> > access on file-backed mounts (although I still don't think it is
> > necessary due to the EROFS immutable model). As the result, metadata
> > cache won't use the page cache of backing inodes anymore.
> > 
> > The "managed cache" was originally used to cache physical compressed
> > data according to the current cache strategy and I/O patterns; since
> > file-backed mounts also need to access physical data for metadata
> > access, it's natural to reuse the managed cache for this too, providing
> > a unique inode for all physical data access.
> 
> This look sane.  Any reason to not use the meta inode unconditionally
> to simplify the code?

I guess you meant avoid using bd_inode page cache?

I'm not sure if it simplifies a lot, also like fadvise(WILLNEED) to blkdev
can perform to bd_inode too so I think it can still have some benefits.

I think bd_inode page cache can be used for filesystems so maybe leave it
as-is for now, or maybe a follow-up work if it's really needed.

Thanks,
Gao Xiang

> 
> 

