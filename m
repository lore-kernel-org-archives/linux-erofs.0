Return-Path: <linux-erofs+bounces-4273-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE24C5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:49:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQlD92944z2xRw;
	Thu, 20 Aug 2026 23:49:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787233769;
	cv=none; b=iLGA6xoFm9VbexHTdXhcXaTZ66ByDY2Ua5NJ+WLpavVdyvoDmkNzUzs8bydFZvyqtcAWGLYZtgQ7u021jgllWrcukDKJzTk71FX45VIs3TDICvUWdQwuYjZr7kmRPZrsXSx9u8zrfcmScJ3eTq5coMCJfGlJZM/d9is09N9LLUIao+lHFJ1efh8xLf5ixGwPrRn+KV+C8LmX33QRY5n1MBLqeiQZfLavslRN/FQTeYs2EirX9p93paRmlMAfan0l0k7hNaB4O1WY3BcArDluPEtNwqjMF1Ob431JQ0G6UeLHbz8jjD0qoUWrT1Y6kzQb3FSaKFryzU91OGOvLeS9rg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787233769; c=relaxed/relaxed;
	bh=Vq46ijBOgQpZhUqPzLzPgL2nw2wm/dg2j5IaVeD0CVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9ZPKurV9afR4O0jpepkBdnvdenaIbtDNjpfbJHI+SDe6Q66e8vlBHNYkWFaBuzJmLVciJux+CEk7v4MmoEV8r82I2ymxgjlELx7uTakTjEukuPPt03o7jg4sGhxWvzV6uIoMO3fGQ7uCtePx/mB6eymmrpD0iJjuN2NhkU/4BtnAVYcovfqKE/CUh8HBH/1maYgMek5k1ylq9YR9FObo7eBsGMFuo8c9gjdj8kHRx11rcHLUf7OIwf30/leJj57MGIISUfZnngeLBbiNOPLUH7DW5/+VxQ8T9PA4ltf5xD6ELvF9tCpXIPzbe3nCZFHbPd9YohzdZ+LNdvmhG/D8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrpNRP/0; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrpNRP/0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQlD84Hzyz2xKh
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:49:28 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B3ED60A58;
	Thu, 20 Aug 2026 13:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A5A1F00A3A;
	Thu, 20 Aug 2026 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787233765;
	bh=Vq46ijBOgQpZhUqPzLzPgL2nw2wm/dg2j5IaVeD0CVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UrpNRP/0NlbaV5ajh9A5r+0iqYxkMqBxDeFzNIqgPUS0DgiAYpsep2cURalt5oEdf
	 rx84rOAxXn/jI++X/PoCSvkLjZVt7myltPm6fPzPdzJ8mNUcWeOzkoJ6wVc96iMpdu
	 AGxnq2sJY5Cqyjm7M5NNohw0vyZ30tee88UFsT3vgSXhghafs36o9J4gChRULIHS53
	 f0DWdb97YqJx/i+eM3nPTKVishPstGO0XRzLCrK4OZCyW+vSfJJLuD9ruLcXm50up+
	 jgAgn0XHQ5LYG5nYbcUQjxVCO8wrxja1S6zqdKmGHz+ZBUpAr6zIwd47R2z3tbaMAg
	 3fQ5UVVlaSCWg==
Date: Thu, 20 Aug 2026 21:49:18 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Zhan Xusheng <zhanxusheng@xiaomi.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: use the shared page cache for splice in
 inode_share mode
Message-ID: <aocF3pQZFiDAIyTE@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jingbo Xu <jefflexu@linux.alibaba.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20260820064441.1083470-1-zhanxusheng@xiaomi.com>
 <3d735f18-2d26-4b4c-be68-b000742e9826@linux.alibaba.com>
 <20260820123705.1748738-1-zhanxusheng@xiaomi.com>
 <76ee52de-1dcb-44da-b2cf-329864adca07@linux.alibaba.com>
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
In-Reply-To: <76ee52de-1dcb-44da-b2cf-329864adca07@linux.alibaba.com>

On Thu, Aug 20, 2026 at 09:34:49PM +0800, Jingbo Xu wrote:
> 
> 
> On 8/20/26 8:37 PM, Zhan Xusheng wrote:
> > On Thu, 20 Aug 2026 17:53:20 +0800, Jingbo Xu wrote:
> >> Please refer to backing_file_splice_read() called from
> >> ovl_splice_read(), file_accessed() needs to be called on the original
> >> file (just as what .read_iter() i.e. filemap_read() does), and the input
> >> @ppos needs to be updated accordingly.
> > 
> > Taking the file_accessed() one, thanks.  filemap_splice_read() calls it at
> > mm/filemap.c:3155 on whatever file it was handed, so on the backing file,
> > whereas backing_file_splice_read() ends in ctx->accessed(iocb->ki_filp),
> > which for ovl_splice_read() is the original.  v2 adds file_accessed(in).
> > 
> > @ppos looks already handled to me.  filemap_splice_read() takes a loff_t *
> > and advances it itself, at mm/filemap.c:3144; its internal kiocb is seeded
> > from *ppos at 3083 and 3098, not the other way round.  ovl_splice_read()
> > has to copy iocb.ki_pos back because backing_file_splice_read() takes a
> > struct kiocb and hands &iocb->ki_pos to vfs_splice_read().  Say if I have
> > that wrong.
> 
> Make sense.
> 
> 
> > 
> > One you may want for read_iter too: it clones the kiocb onto the backing
> > file, so filemap_read() marks that one accessed rather than the user's
> > file, which is the shape splice_read had.  Neither is observable today,
> > since erofs_fc_fill_super() sets SB_RDONLY | SB_NOATIME and the backing
> > file is opened O_NOATIME, so both reach a no-op.  That is why I left
> > read_iter alone here.
> 
> Okay, it seems that file_accessed() shall also be added to
> erofs_ishare_file_read_iter()?

I think file_accessed() is a no-op for erofs?

Thanks,
Gao Xiang

> 
> 
> -- 
> Thanks,
> Jingbo
> 
> 

