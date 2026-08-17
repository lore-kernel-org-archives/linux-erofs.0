Return-Path: <linux-erofs+bounces-4241-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0740C5B572
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 08:10:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNlqv2W1Cz2yGT;
	Mon, 17 Aug 2026 18:10:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786954203;
	cv=none; b=oRBCOja6UZsMxxvRmdzx0R7tX/3Bn0x/ft4PfUSgSJTwfa8Um4745RszeYSBrM9ivZV4Q5HcsVKmRxfpn+9gSMvVKrs5EoBDi2vnJEiXqdjUpZSsBXvR0WmHmMao7sO3WfLjXhZZrh3Qbu0LdfG3pQgLR2XEwy/YU/z8hu0+Q8lyM3mPibKjGbVdoFH3QlUD21a6uDD2Qlr8wnze3ImAUG+iLV9mJRLI2RgP0lvS9MAs96yW1Jj2OY2xHy+n0nLW94oUhe0puEK6Xnu1vNJxzngXOcxxGxd8+V9bRg3jnM9MfscG3HwgXkpfvUAe3EBah5BM5R9Uqft++Gucssitog==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786954203; c=relaxed/relaxed;
	bh=PLA3WJ9fmd7lCZh4vW3Goc7AroiX//cyy+tOp+iiQRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEBL5ons75CXHYvoNZ4t0R6L1Gn2rDEH1jseSo/m65spqW3evveok+0glmnkl/0pyTOMl5TiC1mNg6gMSBsX75V9KRGdU5pjfNqzgaShn7o0UZAWRKFOYlprYbWb/uLuYZCvkdCdO5tgdRKqGs1cWgBwx5gExPSfDojxYB9LdvmxizhaRIH23F9rPjD0qytL5xAdn0TRUzTLEf2pcXqdnJxOD4kwHc1Yk6pMbovTx/rp8kuactedW6JS4od8saB8xisUBxUKSEKdZtWwSJ/u5ZyZ9KCL8fK7HsPEPttzuUSD73TXFdeipS0w9Gjly2sbc7GfaNX8+iaDNFgAwTrGEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDZ/9xpJ; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDZ/9xpJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNlqt3RS1z2xl5
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 18:10:02 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D457600AE;
	Mon, 17 Aug 2026 08:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361611F000E9;
	Mon, 17 Aug 2026 08:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786954200;
	bh=PLA3WJ9fmd7lCZh4vW3Goc7AroiX//cyy+tOp+iiQRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RDZ/9xpJ6PAG5T2NCClL54ukpiS7d1AWEF5IYgFbT85BcjV6+kAVBJB0nwx5yEDUp
	 eEErymmQR1Hb8NugVbMjC0Vop5CKP/AMGg1cz4NfdvY0fI28InR4zg1q/58saLF8hK
	 aeWjta1A38HheyTJDE9O0u9oCPMqvtGIzmljt9blYBhOJcT8xA5VqjgUY222GDZtQD
	 tsXD8DRCuWFA/AeTu++fih8n/klHp4FN5Vjdp8jGczWumY6gVN7FvWzA25f2w0ctyS
	 QXDrAIEvxkq5Jb64SNhZM20zEfJz1JuzL6em727WZC8VHaE6Z66uFKcNdaQF6S1ZnZ
	 ugPn+nPeRpPXw==
Date: Mon, 17 Aug 2026 16:09:54 +0800
From: Gao Xiang <xiang@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
Message-ID: <aoLB0mk6rE4htbZm@XiangdeMacBook-Pro.local>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
References: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
 <20260812131144.30802-1-xiang@kernel.org>
 <CAMuHMdWQO2Lkv4O8=nv6WVtsL1FEk-04RAv=VSZGkro7n0th2g@mail.gmail.com>
 <aoK84br1-61FLLXB@XiangdeMacBook-Pro.local>
 <CAMuHMdWeHTsAMtgwVT9hfvmZj_Z8G8JG7pV2rVEnEOSiqsCDOg@mail.gmail.com>
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
In-Reply-To: <CAMuHMdWeHTsAMtgwVT9hfvmZj_Z8G8JG7pV2rVEnEOSiqsCDOg@mail.gmail.com>

On Mon, Aug 17, 2026 at 10:05:09AM +0200, Geert Uytterhoeven wrote:
> Hi Gao,
> 
> On Mon, 17 Aug 2026 at 09:49, Gao Xiang <xiang@kernel.org> wrote:
> > On Mon, Aug 17, 2026 at 09:32:51AM +0200, Geert Uytterhoeven wrote:
> > > Thanks for your patch, which is now commit a64d500b0078e16e ("erofs: fix
> > > EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms") in v7.2.
> > >
> > > > --- a/fs/erofs/Kconfig
> > > > +++ b/fs/erofs/Kconfig
> > > > @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
> > > >  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > > >         int "EROFS LZMA default maximum decompression streams"
> > > >         depends on EROFS_FS_ZIP_LZMA
> > > > -       range 1 NR_CPUS
> > > > +       range 1 NR_CPUS if SMP
> > > > +       range 1 1 if !SMP
> > > >         default 16
> > >
> > > I have just discovered another oddity: when you have less than 16
> > > CPUS (including SMP=n), this default value is invalid, and "make
> > > savedefconfig" will always write a line like
> > >
> > >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> > >
> > > to the defconfig file, even if that is the default suggested value.
> > >
> > > Needlessly polluting the defconfig files could be fixed using:
> > >
> > >     -       default 16
> > >     +       default 16 if SMP && NR_CPUS >= 16
> > >     +       default NR_CPUS if SMP
> >
> > I guess `default NR_CPUS if SMP && NR_CPUS < 16` would be better,
> > I'm not sure since I'm not handy in Kconfig stuffs.
> 
> Kconfig always picks the first matching default value, so you don't
> have to exclude the "SMP && NR_CPUS >= 16" case here.
> 
> > >     +       default 1 if !SMP
> 
> If all architectures would always define NR_CPUS, one could replace
> the last two lines by
> 
>     default NR_CPUS
> 
> > >
> > > Thoughts?
> >
> > In principle, that would be better, but may I ask if there is some
> > severe consequences out of one extra line of
> > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1?
> >
> > Since it has been fixed for many times, I hope if it could be improved
> > later if no severe impacts, sigh..
> 
> It causes more churn (defconfig updates), and makes the defconfig
> files larger than needed.

Could you submit a formal patch directly (since you found it and
suggested a version)?

so I could submit it along with the pull request if you're fine with it.

Thanks,
Gao Xiang

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

