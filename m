Return-Path: <linux-erofs+bounces-4245-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0EDC5DF66
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 09:05:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNn3R20xNz2xy6;
	Mon, 17 Aug 2026 19:05:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786957507;
	cv=none; b=ZTV8dFQgSfAUYevYyJz+t5YL7I0mMpLrCsSmnzH6YkewSzGsbJDerm0HAT5R/mnhNNcTgHZEvlwoAiyVJ/yunGFoC3VnJhWhUTL1m8iBec0+Qqx/H1zt2NRkNC2hss3z57t+4ML8PDKxzI+v/Z+QkOdToTorMIkwrURVdaLSllbcwSqQORrUxDKYS97ryDB/yj1DnDlMcRomO56B31JSHza/QohfqIOK0UvKOmqLsL+7T9zbWgYlEx5wIYjlyd8PD2itEWBw1CgC04cMj7myy2pO+R3b6gz1st9oYySj4sici+qMr1jMoYdfZjbawDIJV5HfNZL9RTbBqphpyhUDPw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786957507; c=relaxed/relaxed;
	bh=u/+sIdY9ilSmKd/iYE4w990qSp87aPY8l1VSbNWC6NU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEViJ9lT3vJ5+O4ZcCMqmbAeJ34GE7jdMWSHLdBBoC9ic4rNNB1+y9eWcLMbwy4A0w2oWqgXKIadHaSEBw7g6uo5+LJ+eP/4ReXmtRAh14Cr9Vi26zEiY2XEgdr/mt/bxGzd4JZYnmUTg08TWSaDIg7b8k/Ekg7KAEiez6G3ooIoISSwyGpXANBhClhEtsyUaLkPX1n8cRYHXBX0Yd/awy+uD4AVko/v72/j0fI5Qh9MtCN/hHbt0MRvpiYfrl3Hyg5RwC5XIKG11GCB0KlIwFVMKg8RSjysXogKaYulqEP9tAdxxvj09mhV2wmqBvRjcfLloJiYiam2wpWsYXyMyA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rg4Yf7sM; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rg4Yf7sM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNn3Q3sbzz2xWV
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 19:05:06 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1713601E0;
	Mon, 17 Aug 2026 09:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6678B1F000E9;
	Mon, 17 Aug 2026 09:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786957503;
	bh=u/+sIdY9ilSmKd/iYE4w990qSp87aPY8l1VSbNWC6NU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rg4Yf7sMuNL6VNg4vQb3axaJp8iR10wd7nt9Gvda6JCkuqmNMjOsOfMha6RnAw1tm
	 MEpMka/oOQ27ePkZTNNVPl0YZTJv9aL8XDBDd+TEmXbNl4IL991v1qJ8XMkRbHg91V
	 JJYkUTXgnVRPj6AbpCjky9ybeRNJ2wA8QDwkOoEvgv2GjEFQV/tALF9eI5EOql/IFz
	 kmy+cMR6MEJuN9OGfF0Cl/ZXkdIbHSNSaypNYigT5fBhi81tHRle/FdR/JkaRAHCep
	 ChY9PCrE2H75iJ7yxKnL4JZvHDG14JGVDF2y4JFKKcIOsUls2/CPcjJX7RmF6NID9n
	 knz+zvki99cBA==
Date: Mon, 17 Aug 2026 17:04:57 +0800
From: Gao Xiang <xiang@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
Message-ID: <aoLOuVyQyzflCqWD@XiangdeMacBook-Pro.local>
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
In-Reply-To: <CAMuHMdWmcj5SQ-AbyhWL3jiPJKdmNq64m-BOAe3T7HPjJqaDBw@mail.gmail.com>

Hi Geert,

On Mon, Aug 17, 2026 at 10:43:34AM +0200, Geert Uytterhoeven wrote:
> Hi Gao,
> 

...

> > > >
> > > > In principle, that would be better, but may I ask if there is some
> > > > severe consequences out of one extra line of
> > > > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1?
> > > >
> > > > Since it has been fixed for many times, I hope if it could be improved
> > > > later if no severe impacts, sigh..
> > >
> > > It causes more churn (defconfig updates), and makes the defconfig
> > > files larger than needed.
> >
> > Could you submit a formal patch directly (since you found it and
> > suggested a version)?
> >
> > so I could submit it along with the pull request if you're fine with it.
> 
> Will do, I want to do a bit more testing first...

Ok, anyway, I will try to submit a PR hours later.
if there is a patch, the worst case is that it's included in
the follow-up pull request.

> In addition, usability can be improved by hiding the prompt on UP
> systems:
> 
> -       int "EROFS LZMA default maximum decompression streams"
> +       int "EROFS LZMA default maximum decompression streams" if SMP
> 

I hope CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS is a user-visible
configuration (and the Kconfig text helps too) no matter the platform
is UP or not (but it can be omitted in .config) even there is the only
one choice in menuconfig for example on UP platforms.

Thanks,
Gao Xiang 

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

