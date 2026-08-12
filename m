Return-Path: <linux-erofs+bounces-4205-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF13EC5CFDB
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 11:37:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKmg72fTlz303K;
	Wed, 12 Aug 2026 21:37:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.160.51
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786534627;
	cv=none; b=lf9IUp5YisFP+hQumVtnBvjSG/zu/gK1nU0+huTvepU5LRkGkD/b7RLCi25Xp52qs6RuihP6HPeHFuSPcIr531/FFRJBnJurzLx8EMKWGDL3ARu0Q30+W3RqbG3/IkAk2MAHCfgN+iGFjcpYnCk7ERJTTBd37zdFwsy8vZYbkWW64oq5OTrCRHZxsTEaNOhBA1FQ/gH7AHFbJnXtV6O1Eipt22EGHnN/1SGrxCI8xBSpq/NFLotHeZU/DOEyW+foQ6EldWwMmc6P8LbIILuF2/CaHdgMl7dZjTxo/256xm013SySzjG1wsXELCyaPFoPHuzlWbShPzfNW+Fuc5o2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786534627; c=relaxed/relaxed;
	bh=6rSvx/0jGZMH3RxNpi80otjZ2OhjJJMdYcHXZd9f4cQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Pxo7HpzkLLn11ApLwy7LIs4kUWwv8bYnDek8AYM4buotZs0U1F3RQtx+eihuVtFh0wcUYE/bD5ACPlo2O8LFvIhjriQ/I3g6FZvolQjmikSpD7GdB1Srk6YUiH7zjtW6MInRHGmtItZpEO3Ulj1s1NsNXlDedGMCQwQZnWf/IpZih7h1XNUMAGYjocbIvYv6ZESEmjp0R5w2oseJvZ7oUhrkWIOAgQ41RJ5ShntECspnRPFNpf91d/qZpwhj556gRKta5Y7VtcQDaWaWof3SJIXUeSqt0o34IgtlKdJ9NOZei8O+urGHjjDqgE9FyVw3i7hseYjOgZY8qAs40aqFUw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.160.51; helo=mail-oa1-f51.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.160.51; helo=mail-oa1-f51.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKmg56qBQz2yvB
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 21:37:05 +1000 (AEST)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-455ca262ccbso497253fac.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 04:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786534622; x=1787139422;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6rSvx/0jGZMH3RxNpi80otjZ2OhjJJMdYcHXZd9f4cQ=;
        b=DnHrVmmigMUAyPgdG90eY0G2QXrck0ztPMJyDIbt1+YmE/w2q32fYkaxRh/f8CSQcg
         SKNu5awBPJf2MYIaMSQDTBT4FvznfwL5v6DRKiUCBzxUJNDaZZXuyiShAAIeHIpyMxnb
         eNH2RVYQRgVO8h8McHiuFDZKnNEgXp/+/4BOiL4USa46XlGdEqHBiEJsxLeGNdFsnoLv
         j9xpAZMK5sV7OjoDdJqSIX5deCLoV55B3qgM1W1zEmWIGqUA65lnCu+z+ente/tdc7oC
         6ADlahYdU7ibeYcGXWeqCITCyXTodWnQ+Nkvpi3WhOewKd0wp8xmx8e+hczwY1mtdn+c
         YGKw==
X-Forwarded-Encrypted: i=1; AHgh+RrR3UHbnYmmgsu8zLB2HmDR1MvVYwjx8Ij9G8lfB4jl/ENgieouZyKR4A0Og7pYTrNJgEkzf3L/zfSBpg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxqGa2ElTZtduihEQe2H/EIm1Kq50oDjQG0+e4nlP/3vQi9bGOo
	W6zdKhWqczKNHQxEOHBKWn5Opt53cuGRnxtLVjEKMQlzsGgYBfwshEtARvUqlL74
X-Gm-Gg: AR+sD110LGh1F984niqMHyrPOUQ6wUwGYkyX1mKv1lIfgVkvM865cUUhZc6lJB88/bY
	SoVr6T/+6RRYUkSLxweiqcYZsXlBCIK5yQ/tSdAPZfSkmOKcqmBOeWc67QIqsw1xKoQ90/MhHRP
	Vz1Wht+dj7E84K0IkilwFKkGdSfdVyIkVOHEm711ieIywP7QgnJhVUWKy1Ec//yt8XB01t4IaLC
	Rof7wLkvcKrMyF6Y/i+1j73ikK29jOlxnVwnticZVzcPE4kv72Vy+k1axK0Ro1A9JY/gg7Zz3di
	yqVasG9xHpc1NQ/bmjrxjgSCPHdenQIKW+Zd085XnuP7q1/ldsYbmKTHb7Vh/cS/zXA0PFx9kwq
	QvfUt11vVge1z1e6Y8NkBqPTAc9zyCRlyL0J5F61iU/FD9atqJr4sir6MJOjTfjwKDKle3tGSYc
	oLO7yZpZte1RSm8WmcAB/jEYEmwG1xCeO/U0jJYIQBJQF/FuIAE2mMDpF6CrCQvPn+kMhVGp8yT
	UhkX7B7M/rL1YmPSspUAQgF5A==
X-Received: by 2002:a05:6871:b13:b0:447:7f2a:baa7 with SMTP id 586e51a60fabf-45e3ebe5673mr3320014fac.16.1786534621640;
        Wed, 12 Aug 2026 04:37:01 -0700 (PDT)
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com. [209.85.160.42])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45e3564c247sm1676652fac.16.2026.08.12.04.37.00
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 04:37:01 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-455ca262ccbso497238fac.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 04:37:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqH7vklXYntHysyp9gPP4xq5f9+JD6w5jbFaBWH3bf6VcJJtahXmUpLQqEf0Vq3arwNBK66uS21hasIpQ==@lists.ozlabs.org
X-Received: by 2002:a05:6102:5696:b0:631:28c1:154c with SMTP id
 ada2fe7eead31-76c89774158mr780549137.9.1786534139804; Wed, 12 Aug 2026
 04:28:59 -0700 (PDT)
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
References: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local> <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros> <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net> <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local> <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
 <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
In-Reply-To: <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 12 Aug 2026 13:28:48 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
X-Gm-Features: AUfX_my5HHpFn4yhw-8fesR7FW3YNOyOr1ipPx-sXs7eTkazDvmu8WeCPMYJpY4
Message-ID: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: Geert Uytterhoeven <geert@linux-m68k.org>, Gao Xiang <xiang@kernel.org>, 
	Guenter Roeck <linux@roeck-us.net>, Michael Bommarito <michael.bommarito@gmail.com>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	SJ Park <sj@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, 
	David Hildenbrand <david@redhat.com>, linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao,

On Wed, 12 Aug 2026 at 12:55, Gao Xiang <xiang@kernel.org> wrote:
>
> Hi Geert,
>
> On Wed, Aug 12, 2026 at 11:30:14AM +0200, Geert Uytterhoeven wrote:
> > Hi Gao,
> >
> > On Wed, 12 Aug 2026 at 01:37, Gao Xiang <xiang@kernel.org> wrote:
> > > On Tue, Aug 11, 2026 at 03:37:38PM -0400, Michael Bommarito wrote:
> > > > On Tue, Aug 11, 2026 at 3:35=E2=80=AFPM Guenter Roeck <linux@roeck-=
us.net> wrote:
> > > > > > Any progress with fixing this for v7.2?
> > > >
> > > > I would like to fix this since I started the problem with the origi=
nal
> > > > patch, but I feel a bit stuck.  My v1 and v2 patches would not have
> > > > triggered the build failure, but Gao made valid points about the
> > > > trade-offs that led us to this v3.  Maybe it would be worth your
> > > > opinion on the config approach in those earlier patches?
> > >
> > > Sorry about the late reply.
> > >
> > > As I said, I really dislike hardcoded range, but it is an issue that =
no
> > > NR_CPUS definition on CONFIG_SMP:
> > >
> > > I wonder if the following diff resolves the m68k issue (I'm not an
> > > Kconfig expert but it seems to work on x86_64 !CONFIG_SMP):
> > >
> > > diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> > > index 8ca1767dafb6..2dfc313588d2 100644
> > > --- a/fs/erofs/Kconfig
> > > +++ b/fs/erofs/Kconfig
> > > @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
> > >  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > >         int "EROFS LZMA default maximum decompression streams"
> > >         depends on EROFS_FS_ZIP_LZMA
> > > -       range 1 NR_CPUS
> > > +       range 1 NR_CPUS if SMP
> > > +       range 1 1 if !SMP
> > >         default 16
> > >         help
> > >           By default EROFS allocates one LZMA decompression stream pe=
r CPU.
> >
> > Thank you, that seems to work (despite still seeing the warning on m68k=
,
> > as NR_CPUS does not exist).
> >
>
> ...
>
> >
> >       $ make ARCH=3Dm68k allmodconfig
> >      fs/erofs/Kconfig:137:warning: range is invalid
> >
> >  Warning...
> >
>
> Yes, other arches shouldn't have the warning because I think other
> arches (including microblaze) defines NR_CPUS in Kconfig, except m68k.
>
> The following diff can eliminate the m68k warning above, I think m68k
> folks could consider this way if you really don't want to define an
> explicit NR_CPUS.  Anyway, I think it should go with another patch:
>
> ```
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index 11835eb59d94..90499f126c73 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -44,6 +44,9 @@ config M68K
>         select UACCESS_MEMCPY if !MMU
>         select ZONE_DMA
>
> +config NR_CPUS
> +       int
> +

Let's bite the issue on m68k for good, I'll take Uwe's patch for v7.2
https://lore.kernel.org/all/20260731094950.1988084-2-ukleinek@kernel.org

>  config CPU_BIG_ENDIAN
>         def_bool y
> ```
>
> I will try to form a formal patch (with the diff in the previous reply)
> directly to Linus (since I don't have other urgent patches for
> Linux 7.2.)

Thanks!

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

