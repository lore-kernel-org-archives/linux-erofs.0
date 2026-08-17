Return-Path: <linux-erofs+bounces-4246-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56314C5DF66
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 09:21:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNnQk3Zdtz2y1Y;
	Mon, 17 Aug 2026 19:21:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.217.46
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786958510;
	cv=none; b=men7kwLnJIVsDDTHvj/pPWfkJ4BMCygC7EJjtz8X7HGxPlAl3lIXdFZcdSCF+Qq6gJWUX3HUvrqyHu1ruUn9H3Zw2CwTEaygPa+fGQAPb6/GmuAylWOMsmi+B5Ft6eJCI79Gr0u4KqsyINVKFwPL3YPLegO2u3915SXkJw8H5Opm9yQNwr+rSuw5DB/PW8AroOajuqlDVS28ZWNPHcNoBA+Ueq2MfsQhG0WW838RugctpHf2CxIj2rQwHI/8JzEhR4lX49Zmey24YqKgwCm+AqR/F9g3o6UBJaEWovDYXYZqKT1l7505XBJCtodkjUCTLpIl7pW+avlTu28+LOkw2A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786958510; c=relaxed/relaxed;
	bh=gGm0u3+gECL8HqGObaxPwG7bdgm5V3N4sGGNOrIDD1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LfEFyg/wUeg0ggleVsUeYig4o5fKZdZeNB00BBNY2kgA96AR7kizUdCV6PSHJjDmFAJovHWyXQdB/9E9DZDGX71wVvz+3bfhX6XluwlHQE79+hxTFcaICKnRMUbAf1S5mfbhAvpiIWzQLKOKHpr0JadH+wrynDQSk8KJ44R/zyvY/O6MCr0/Yjs33d6NgtfkjiWuXxMQ84H5ucvIyuF48FBZnDTgrtSDasTIfhf/w4xq06GibLS7AuwcPscoi9POeSx4PPjsqmNm0xUZaxbUD3TexLTL9jgPw/xNEHTuDZPiQ3f48NsQ9YpY4gVFACg7nfDU1Ajo0LQm9ASoIp7fWA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.217.46; helo=mail-vs1-f46.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.217.46; helo=mail-vs1-f46.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNnQj48kVz2xy6
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 19:21:48 +1000 (AEST)
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-74dce749cc5so398609137.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 02:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786958506; x=1787563306;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gGm0u3+gECL8HqGObaxPwG7bdgm5V3N4sGGNOrIDD1M=;
        b=UNWeG6UG3foY0izzV8D6CKX5NDeLVjxA4MqD4kSa2tk/Nwv4rt5tknwEHRt/tSNLEv
         vPa2LXTW1dr9G8ymGNNkRyuoJBcfMtlaeGsuM3XDvgAWe9KPQDHsGGH0sVN2JfSqShVw
         vzhILBBuQdJ88oyeS5SkHkpObL28pCAD/p1ic0nSEMLgt/PRoCNeVYwB2QOoQv7cOkap
         3ltBIjSAnxUjt9sJWjNodVXqbC0gh7GR8XSfg9ifSYWmvJnEsb4Y6GiVeAsvhneiFa6O
         RiXSjejMnT1pTr3yv0ORH5KobIq5U5ZUccqVDkTXXIzp8BYEk6QPFril4PxpWOWJ1AYK
         AFsQ==
X-Forwarded-Encrypted: i=1; AHgh+RrXSHKltmqy6ZDvZRTEYf3rVoFvRAOAJwGfkHyvteNErgtT2Rv84FNkpP9W5lIN8509HO+EmB8QX1/baA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yx6CJ2o5lQ/EJTHYWWsD1VRW+7rAQP6t0b4wi4ltO0We1wytyvz
	1s5v1iv5YGaluzaaBhXnhQrm2MCMfKQTA24d/jtYTuQwVAhUy2gitbCy4GF0kNxq
X-Gm-Gg: AR+sD11doBaSkmyq/P1Myldyk0s9OnGvG+vm1vJqLa42NWiXPkrMplPkiwmiXRg/Nhn
	ZXnAZLx2wIE+rdVIZAuB1I4ILiiiuLynFyfM56hmuPljf3YzyCB+UkzpqjCmOsmz085hT0J0tlK
	oZpNi+cJgF7OYCP6us31f7vxcctk2yLvVJCatDUKTwzQkgdS4hrkrNfhCa+07/oCVPRHFdCtokT
	SbmawO6DbCYW0lzRsIaFshpYImuTGjkI3qO005+CmNXbzJL6VD9vpAbTUOEtIFgAgsrWGcowZ0d
	jUiTR9JSb4uhKcRncCyXs5OxHpqwzrhZ51wPJQq+gt21lnZ0thHIlvOpN0dVm8h0jmfPyzPyIVt
	PFEjp+oA81h/gO71ymYxBNKOLOkKOFCiSZ2YIctkstTrg2+9t8yebTz2evgxidtrQVgMoxjni4i
	f5EpdOpqkO0NDGAKkPKzke90kRRhb2egRPy2HAK7nSbZqf7geJzUwbtDpiWecaXa4OUR8Y00jCx
	FXlxibQqF0YaacnecQLp5W5QlL+kA==
X-Received: by 2002:a05:6102:5683:b0:73e:c6a0:331 with SMTP id ada2fe7eead31-76f2c546e7fmr3944188137.10.1786958506139;
        Mon, 17 Aug 2026 02:21:46 -0700 (PDT)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-773c569aec4sm472956137.12.2026.08.17.02.21.45
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 02:21:45 -0700 (PDT)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5bfaa014978so1183901e0c.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 02:21:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro/VyCNqUdvxD6CA+hUnYceP0ju5K+vmNYBTtBhuHMqd2T3Nxbggkq+U0dGPhJIVRJajmogpuMe1LHU3Q==@lists.ozlabs.org
X-Received: by 2002:a05:6122:c93:b0:5c2:c0b2:9889 with SMTP id
 71dfb90a1353d-5c591cb424fmr4463424e0c.4.1786958504656; Mon, 17 Aug 2026
 02:21:44 -0700 (PDT)
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
References: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
 <20260812131144.30802-1-xiang@kernel.org> <CAMuHMdWQO2Lkv4O8=nv6WVtsL1FEk-04RAv=VSZGkro7n0th2g@mail.gmail.com>
 <aoK84br1-61FLLXB@XiangdeMacBook-Pro.local> <CAMuHMdWeHTsAMtgwVT9hfvmZj_Z8G8JG7pV2rVEnEOSiqsCDOg@mail.gmail.com>
 <aoLB0mk6rE4htbZm@XiangdeMacBook-Pro.local> <CAMuHMdWmcj5SQ-AbyhWL3jiPJKdmNq64m-BOAe3T7HPjJqaDBw@mail.gmail.com>
 <aoLOuVyQyzflCqWD@XiangdeMacBook-Pro.local>
In-Reply-To: <aoLOuVyQyzflCqWD@XiangdeMacBook-Pro.local>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 17 Aug 2026 11:21:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVJQoRxD4F5gZzAgvzZOad+gy-ROtNVmeNFiZ22=uoApg@mail.gmail.com>
X-Gm-Features: AcwNN1UYhw1JjJc-K2uk9G5CPEIdPJ0nhWVEugRj_ElPcLSFAi7yO4_wjjw9ieU
Message-ID: <CAMuHMdVJQoRxD4F5gZzAgvzZOad+gy-ROtNVmeNFiZ22=uoApg@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, 
	LKML <linux-kernel@vger.kernel.org>, SJ Park <sj@kernel.org>, 
	Guenter Roeck <groeck7@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

On Mon, 17 Aug 2026 at 11:05, Gao Xiang <xiang@kernel.org> wrote:
> On Mon, Aug 17, 2026 at 10:43:34AM +0200, Geert Uytterhoeven wrote:
> > > > > In principle, that would be better, but may I ask if there is some
> > > > > severe consequences out of one extra line of
> > > > > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1?
> > > > >
> > > > > Since it has been fixed for many times, I hope if it could be improved
> > > > > later if no severe impacts, sigh..
> > > >
> > > > It causes more churn (defconfig updates), and makes the defconfig
> > > > files larger than needed.
> > >
> > > Could you submit a formal patch directly (since you found it and
> > > suggested a version)?
> > >
> > > so I could submit it along with the pull request if you're fine with it.
> >
> > Will do, I want to do a bit more testing first...
>
> Ok, anyway, I will try to submit a PR hours later.
> if there is a patch, the worst case is that it's included in
> the follow-up pull request.
>
> > In addition, usability can be improved by hiding the prompt on UP
> > systems:
> >
> > -       int "EROFS LZMA default maximum decompression streams"
> > +       int "EROFS LZMA default maximum decompression streams" if SMP
> >
>
> I hope CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS is a user-visible
> configuration (and the Kconfig text helps too) no matter the platform
> is UP or not (but it can be omitted in .config) even there is the only
> one choice in menuconfig for example on UP platforms.

Why do you prefer it to be a user-visible option on UP?
In general, we try not to bother the user with questions about
configuration options that do not matter for him, or that offer only
a single valid answer.

IMHO even "if SMP && EXPERT" would make sense...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

