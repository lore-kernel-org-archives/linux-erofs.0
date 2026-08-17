Return-Path: <linux-erofs+bounces-4248-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED07AC5DF70
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 10:06:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNpQ61rfsz2y1Y;
	Mon, 17 Aug 2026 20:06:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786961182;
	cv=none; b=B/x0sIAJeQcIAE+e1tFD/TQv7/026d1UmuxBlauz48yIzH4uqjB59tG+suhLn+4HKskgyLRtId1yVOOxpCETaLIZ/6i386K/zz/u/9NzIHhKRppv/tQRZVcx8RFoq+1GaC9Wr4UYCgnVQ933+ourzJWSjZSueutAn8oGXeImAbapa2uzWAOXRFPZSYEKOrK88lGdRlvMfZ8WVBLQZlkisTZd4IxWquDN7ozQyWB3aY13LDCpGlW75+C/Q/B5VJ1eMgJeCn32TRDhL84q7n3m4Iv0BgcTo4XD8gfJafJiLaDL4WBNpJi0o9orRJV9KU/1+1OoNctJRt81vT/Bn0YAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786961182; c=relaxed/relaxed;
	bh=fdSfuECU47r/KTvkehFAte5AcljYqgsIk7gtUuq/RL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLE6nwMy/CxplYRw2HKwDf2u4n9jBwfkPOFcQ1hzQAhgx2/uCBgCNL8ik2cpJwd9saE9LdylTaTtBSQdQIHYr2RC2/yQZkvDIBYknCCHv2LdQ+h8E/ZjuKihUlweGFqCwYFcGkpeTm8ca5cNjkbqW7NkcWypoffGU7GALY1hpSTHNnuy/3E5sNjj+gLjjhwbGEyZBmS1RoKeYyTv/9oGRgrkqxxdDGp0cSCRh2LWyKF8NgMX7vEnYAWHUYfYMeGAewvyCna/E3z/KneW/4JgHTIKm33CwLBczBBRPU4L0uAvY3dHCVQasI+ZxAXnyHbTctq5jPQh4YfGNYRQCtEq3Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fU7lWDww; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fU7lWDww;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNpQ52Fslz2xy6
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 20:06:21 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A654B601E9;
	Mon, 17 Aug 2026 10:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46691F000E9;
	Mon, 17 Aug 2026 10:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786961177;
	bh=fdSfuECU47r/KTvkehFAte5AcljYqgsIk7gtUuq/RL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fU7lWDwwrDAPAJgwJmxSLi3vmDtrwonVS/q7sKRG7Mmt+0z1IEMkfVtsSUsL++6zn
	 V0sxg15HRMrIuWLVkVDnx+jf1MSJbv2orZ0KJ9yLOY/MsbmK5yrFHoT8xUaUtTujZk
	 QZ05qiprsw4eSbSuUtDqbB1oKbOoLiATK559KOOYk6HjoZM/H1UFJVNemK43sOplIV
	 r2hwJjG0685IIMbXGui2q8rsds1X5Ols4n3Xa2SB+YGMEJomZYnbGabnKgLGzDabkj
	 BeTNMW2umSCa175vQzBtAC8qtTvl2UCcLFDjN4OnuBwf6ewApJkNrCIOuziyUeLhrJ
	 mnRkROIR/BACA==
Date: Mon, 17 Aug 2026 18:06:09 +0800
From: Gao Xiang <xiang@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
Message-ID: <aoLdEZaU3ELM1EN9@XiangdeMacBook-Pro.local>
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
 <aoLB0mk6rE4htbZm@XiangdeMacBook-Pro.local>
 <CAMuHMdWmcj5SQ-AbyhWL3jiPJKdmNq64m-BOAe3T7HPjJqaDBw@mail.gmail.com>
 <aoLOuVyQyzflCqWD@XiangdeMacBook-Pro.local>
 <CAMuHMdVJQoRxD4F5gZzAgvzZOad+gy-ROtNVmeNFiZ22=uoApg@mail.gmail.com>
 <aoLYrMCx96xw04K0@XiangdeMacBook-Pro.local>
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
In-Reply-To: <aoLYrMCx96xw04K0@XiangdeMacBook-Pro.local>

On Mon, Aug 17, 2026 at 05:47:24PM +0800, Gao Xiang wrote:
> On Mon, Aug 17, 2026 at 11:21:33AM +0200, Geert Uytterhoeven wrote:
> > Hi Gao,
> > 
> > On Mon, 17 Aug 2026 at 11:05, Gao Xiang <xiang@kernel.org> wrote:
> > > On Mon, Aug 17, 2026 at 10:43:34AM +0200, Geert Uytterhoeven wrote:
> > > > > > > In principle, that would be better, but may I ask if there is some
> > > > > > > severe consequences out of one extra line of
> > > > > > > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1?
> > > > > > >
> > > > > > > Since it has been fixed for many times, I hope if it could be improved
> > > > > > > later if no severe impacts, sigh..
> > > > > >
> > > > > > It causes more churn (defconfig updates), and makes the defconfig
> > > > > > files larger than needed.
> > > > >
> > > > > Could you submit a formal patch directly (since you found it and
> > > > > suggested a version)?
> > > > >
> > > > > so I could submit it along with the pull request if you're fine with it.
> > > >
> > > > Will do, I want to do a bit more testing first...
> > >
> > > Ok, anyway, I will try to submit a PR hours later.
> > > if there is a patch, the worst case is that it's included in
> > > the follow-up pull request.
> > >
> > > > In addition, usability can be improved by hiding the prompt on UP
> > > > systems:
> > > >
> > > > -       int "EROFS LZMA default maximum decompression streams"
> > > > +       int "EROFS LZMA default maximum decompression streams" if SMP
> > > >
> > >
> > > I hope CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS is a user-visible
> > > configuration (and the Kconfig text helps too) no matter the platform
> > > is UP or not (but it can be omitted in .config) even there is the only
> > > one choice in menuconfig for example on UP platforms.
> > 
> > Why do you prefer it to be a user-visible option on UP?
> > In general, we try not to bother the user with questions about
> > configuration options that do not matter for him, or that offer only
> > a single valid answer.
> > 
> > IMHO even "if SMP && EXPERT" would make sense...
> 
> I think users should not be bothered with !SMP in the beginning.
> 
> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS impacts the default
> LZMA maximum memory usage, I hope it shows the same for both SMP or
> !SMP (even it cannot be configured on !SMP, since it clearly shows
> to users the number and indicates how the default LZMA stream
> derives in general.)
> 
> I think it's unlike something that is totally disabled in !SMP (or
> does't have such functionality in SMP), I think that is more sense
                                    ^ !SMP

> to hide it in the configuration but here the DEFAULT_MAX_STREAM is still
> meaningful and is 1.

In other words, if NR_CPUS is defined unconditionally (regardless of
SMP or not like the current status), from the user perspective, I
think SMP inclusion here has no real gain, and it should be just
`range 1 NR_CPUS` simply as a unique per-fs configuration.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
> > 
> > Gr{oetje,eeting}s,
> > 
> >                         Geert
> > 
> > -- 
> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> > 
> > In personal conversations with technical people, I call myself a hacker. But
> > when I'm talking to journalists I just say "programmer" or something like that.
> >                                 -- Linus Torvalds
> > 
> 

