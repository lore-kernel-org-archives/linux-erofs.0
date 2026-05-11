Return-Path: <linux-erofs+bounces-3398-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47216CD37BE
	for <linux-erofs@archiver.kernel.org>; Mon, 11 May 2026 13:51:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gDh2t5wFlz2xlh;
	Mon, 11 May 2026 23:51:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778507478;
	cv=none; b=kzINRAQFaapD0WlpR53xHrTyc36XtHIFrXSozuZSZfZTycZS0V9XZ+CxKEQsv6Db04uLsRt1zyidKLwxGw8llmQNuqHx0alu9G7s/enrJxQVQcEhrbwRMIxLazuEqrqA0vJMZ+8UH1DyOPGwjk4nzWzz6D2O/rvAwog4TTaqnI3DVXEy60JRHDaok0Plevsgdep0qidDFIwJnLLa6Di3GYWy9xRQ1CtQ4fSg2mDirQ+zpF/+R2BBXMrgk0DLZlFE+K592xJgo8OOupwIe7rB2qMTa+HO9ZvRPaFpX6i1wN+ZSZnh4hrPQSRJJECDc9z5yFMd2+3sOzylMleUzxGS8w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778507478; c=relaxed/relaxed;
	bh=Y8M6mMdVolVnKka42g9G16ZiGw6ujrioeSJ3VBGCXG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nnW1eIUANVA7GcYMn3X3PvofDAZGAyWb8Wj5AEubdERfl5aJVcM1qpuH7mhA2Ft9tIng0iFCQ9/HXcUWa8afaW6FQ8UOB6DvgWW39EdwRn+bKIaChiunSpTb8WEuxkFwukBoTJkmUwbfhuymJVad8q/fBb45hlqUdfZlVtsERNvuGUYbxpj8NwIbRWDY8pIc/0J6viVZTYtfNxRfb+hQkK1/T5Y60cb0hlrZFBVgMnAYbbJc+X7F3PY7ClzHqTvhX283ixAdnTY9fwMOETRLzfB83HqDxIfggEorr2dj53Oj0pPLLcp5WgDPHDMsMw20A5nC4tDktrcdZWthfUxBtw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=g9IkDCot; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=g9IkDCot;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gDh2s6msqz2xf8
	for <linux-erofs@lists.ozlabs.org>; Mon, 11 May 2026 23:51:17 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C5FD6001A;
	Mon, 11 May 2026 13:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45902C2BCB0;
	Mon, 11 May 2026 13:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778507474;
	bh=oQvTmeGEc99r8erfM15bC0WUhgOmacUXjVtiE3IA898=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g9IkDCotg6WWhykj7LZiwk6kawsNmowRdw8GQsSasp9kxb6mE29gfCIOpj13P4psp
	 AXKsxJ8oPv917nMkmHvI1jSpeROEBWJUVk3ZzvVp0gINqx86NbVyMlQQtdCeUQGPn6
	 29HMz/DKbOfD4F1f7CPP9RUfA9Afm/KGSJOeYshNR7aYHn2EK3WLFcGsDd00AwAIqK
	 qwPUDOXXJsw6P/clU8G3N3zknUoe2lT+hoSLagHDySfIww88HdNb6DN0u8pcGE7vJU
	 /pf2M8wzmVCuiqbLPIe7kd9mSqDc38xi/hBos/LiW+JtYSk3bPp67HCU4fUQU/1ivY
	 WtkcS/ukw2kog==
Date: Mon, 11 May 2026 15:51:07 +0200
From: Christian Brauner <brauner@kernel.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-erofs@lists.ozlabs.org, 
	Chao Yu <chao@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	oliver.yang@linux.alibaba.com, Carlos Llamas <cmllamas@google.com>, 
	Sandeep Dhavale <dhavale@google.com>, linux-fsdevel@vger.kernel.org, 
	Tatsuyuki Ishi <ishitatsuyuki@google.com>
Subject: Re: [PATCH] erofs: use the opener's credential when verifing
 metadata accesses
Message-ID: <20260511-ozonbelastung-verzweifeln-a03cd0309ad9@brauner>
References: <20260505155615.2719500-1-hsiangkao@linux.alibaba.com>
 <af2c4X1YCB7NEb8p@infradead.org>
 <CABqzrSOaCMPD_QrSq_y_6bXLC3ecm3FZsE_ACrdNbTHG8baMCw@mail.gmail.com>
 <188c33e2-331f-4362-8475-b8cea7a8fe7d@linux.alibaba.com>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <188c33e2-331f-4362-8475-b8cea7a8fe7d@linux.alibaba.com>

On Fri, May 08, 2026 at 04:39:15PM +0800, Gao Xiang wrote:
> Hi Christiph,
> 
> On 2026/5/8 16:24, Tatsuyuki Ishi wrote:
> > On Fri, May 8, 2026 at 5:20 PM Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > On Tue, May 05, 2026 at 11:56:15PM +0800, Gao Xiang wrote:
> > > > Similar to commit 905eeb2b7c33 ("erofs: impersonate the opener's
> > > > credentials when accessing backing file"), rw_verify_area() needs
> > > > the same too.
> > > 
> > > Two things here:
> 
> Let me use Tatsuyuki's reply to address your two comments.
> 
> > > 
> > >   - rw_verify_area is a helper for use inside the VFS and file system
> > >     read/write method implementation.  Erofs as a user of the VFS should
> > >     not use it at all.
> 
> Currently EROFS file-backed mount metadata is directly using underlay
> fs page cache, which is mainly used for composefs, etc. to avoid
> different EROFS instances have their own EROFS page cache for the
> same underlay backing file and avoid unnecessary copies into them.
> --- That is also what composefs once did in their codebase.
> 
> Since EROFS just read the underlayfs page cache and does _not_
> touch anything inside the underlay page cache itself, so I guess
> it's fine?
> 
> On the other hand, we talked a bit commit f2fed441c69b ("loop:
> stop using vfs_iter_{read,write} for buffered I/O") in another
> private thread related to fanotify, which lacks proper
> rw_verify_area() as well, since it called into raw read/write
> iter methods instead of using the previous vfs_iter_{read,write}.
> 
> > >   - using the opener credentials when accessing the backing file seems
> > >     wrong.  The entity accessing it is the file system, so it should
> > >     have system or mounter credentials, not that of someone causing
> > >     metadata / fs data access.  And this applies to all access by
> > >     a file system backed by a backing file.
> > > 
> > 
> > I think there's probably some confusion of terminology here. buf->file is
> > opened with the mounter's credentials, so we are impersonating the mounter
> > here. Perhaps the commit message could describe that more clearly. Same for
> > the previous patches mentioned.
> 
> Here "opener" means the mounter as Tatsuyuki mentioned, I just
> follows Tatsuyuki's term, but it just means mounter credentials
> indeed.

We're slowly reinventing overlayfs I see. ;) I think it's probably fine
but it's also rather sketchy to mess around with permissions like that.
Mainly because I don't think we have any actual page cache permission
model. It's inherently shared beetween everyone and this kinda tries to
bolt permissions on top to not make it so. Probably fine here but also a
bit wonky.

