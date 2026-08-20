Return-Path: <linux-erofs+bounces-4260-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47512C5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 10:04:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQfDZ3Gnsz2xWR;
	Thu, 20 Aug 2026 20:04:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.221.170
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787220270;
	cv=none; b=jJXSYoymD5SVK/yTgsljnNVbq4PnAfL8tKl9O0daNVZdvG4hMdA9tqh6ICfPbsmTwwJ2hmUjVAMMJLkTZs0555LJ2XPONj2O6wWXOeyxgFtpMlk77x0VkA6vxdOaCBYBwf2mwV9ZUuHvcpbruQnETNstuXszyl6eswOSDNRa8Ywg6m1mCDUT5D2bX4NSLRQhpMBkyTElG3KxnCji53tEe9yPxADzYqJqWreWsgrfijqNx2lMMu62iTcyj/1mOSM1z8XX1LhKRjdoK01Ahs00BaCBLbfbyp5tcgDeyFGWNLhsrftH4NL5L4bWYLcn1a4ayObtvpKzMntcn3CwQ+D6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787220270; c=relaxed/relaxed;
	bh=0w7idTUB3W5HdUm3doaF10D3uskIVTFBDNakMHKQhfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=guDmEP7O+Hy3JqlXa3gerQmTJwEshAGdjgKJFki5+xIVn8O4imk05fnLFbmj7iwZ7ewVpEpvAwhZDLavyAsOA+lzE5pO9CuQpXkLGiOYqH7y/F60mbyE5OU8jjvTynBqYlbd3pN0Xic2hDQxZjtkqawynf+xyvoBGhqISAkDGbeBnmWUue2aN+OXXB24vEghGHickob8ei9PeRwgZTqLECKwFnWooz0pmZz2h6/n/SuoTA6Y9ZtJ91Tb8ire+0K+jQAdrJI27oE+50QSZodRcuVEk1bgiGGOfynJza+LyAc6jcsdZEnDn9RVIbLO5ThR2v6T48RoNnRIyw7/9CDJsg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.221.170; helo=mail-vk1-f170.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.221.170; helo=mail-vk1-f170.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQfDX5ZQXz2xW5
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 20:04:28 +1000 (AEST)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5c276bd3692so1845489e0c.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 03:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787220265; x=1787825065;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0w7idTUB3W5HdUm3doaF10D3uskIVTFBDNakMHKQhfc=;
        b=P9naJtpHWUe8V5oTkY9IThLzW8qvcySi4Zj6YOS6V7WEcG3awwsRY/wAsKsCyyHi0m
         InRKwnN7a6MBcKEfV5gwSpbYMF4jCH2QKUYWat1PsomKP29GH8svvgUe/uJmJ/oYlv74
         U1Zh+k46BE6jw25yAikMBnMfRTtBcZGuaa5QQa/3eF4xGdmJ+Mn0NtiR0DBrogDvAyxw
         wQsaqZlrelI/2WUBSqlhGqN9QuIiXq+Q56aNlikb5y0IoxclUV7PWhTJyGGf/aDxW8HK
         +9SwtTJzXMz4m8fUbB33jnoEFWFwXDQzNj9zhU3hid5s+HRQbYFp79kFsRLjP05G176u
         VJCg==
X-Forwarded-Encrypted: i=1; AHgh+Rqx75a4YLJ0Ob2ec4bT7hc+6wkhoBa/z2o4SPIjZi9NGw9VucTrbRRCj5MW9PwTbZkB24LJJGtB4z0vZg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyBRM3SpkbPVxAFZtofEFXGrPDRX+SV/Lc/hqG2KpK9/4IVWT48
	aZ+sc+tsCBAceZSDE5dzL0gr8NoSV6eFyTyjzSKumvK2srPI+8qTJqckJYZDvMu6
X-Gm-Gg: AR+sD12OyMQltimGHmzpVXf8iUV3tZszyUpQpvGk0UYt4ZlHrbcMLIEwkfm90RY9GEE
	EaWqjMinTYKcNxqpOVQrBwiXJukAhUtPxPUw1EVANFEphEA1N/ACcdnhynhjqJNhz1zhdh9STH6
	jeoPlhlygSuOQcEBPFvyCu+u7UE23QTvhUv5WBkkZ+XLyvcausVCqk3RlT1omf9mrX8n9oxk67f
	viIOhwM9CTTkBB/bM/ld6Lkf/gTnTK9qzokJpzUNVwCzjQV4yW9nOpSuVjZ3RoS1Odeh8HrQOTL
	W9y7pd9vKG/li7MKP7NIBxZ6OtWDq2FCf5B7CfLebNGE/YQVsgOTv+k+oJpWj8gvnw/M66vJMaj
	9DMy9HaSTulCGj/CzsZ4jn7b69IPHPhWRyeJIK506/cV0411JvpGfsrXp2nJvDdelgyutkcw84C
	q/RQCnh6CqhpbL0K+GQWS/KoS/90VJ12XP9bYAMK9GDNk8auhLrdaxP1gdJku47AsZJv7mDNJIF
	oQ3gbh4J98yiKmqWKnmUSI0kQ==
X-Received: by 2002:a05:6122:298a:b0:5bf:d3cd:3d64 with SMTP id 71dfb90a1353d-5c5e2ec4dabmr5012482e0c.0.1787220265410;
        Thu, 20 Aug 2026 03:04:25 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c5e276e712sm5173692e0c.9.2026.08.20.03.04.24
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 03:04:24 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-779d18ef706so96977137.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 03:04:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqtTNKxsycEuqfNemr9iGskIpyXYxToqrgs9ZTYgkYir+UR8XmV+1vDjho76fkT36l8I33JfTLzlgT8Ig==@lists.ozlabs.org
X-Received: by 2002:a05:6102:2c08:b0:729:affa:70fd with SMTP id
 ada2fe7eead31-777f9a9093fmr4409954137.8.1787220263904; Thu, 20 Aug 2026
 03:04:23 -0700 (PDT)
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
 <aoLOuVyQyzflCqWD@XiangdeMacBook-Pro.local> <CAMuHMdVJQoRxD4F5gZzAgvzZOad+gy-ROtNVmeNFiZ22=uoApg@mail.gmail.com>
 <aoLYrMCx96xw04K0@XiangdeMacBook-Pro.local>
In-Reply-To: <aoLYrMCx96xw04K0@XiangdeMacBook-Pro.local>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 20 Aug 2026 12:04:11 +0200
X-Gmail-Original-Message-ID: <CAMuHMdViOgm=1Mp+XVoaQPL8LLVTnvmPhvzsFVEfdT=yVpFGaw@mail.gmail.com>
X-Gm-Features: AcwNN1Vmflb4W1Pd5paO6vjA1rI7Mw3rZx_qHM9gmNjZ0edjmQEUDHAllA6b8rQ
Message-ID: <CAMuHMdViOgm=1Mp+XVoaQPL8LLVTnvmPhvzsFVEfdT=yVpFGaw@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, 
	LKML <linux-kernel@vger.kernel.org>, SJ Park <sj@kernel.org>, 
	Guenter Roeck <groeck7@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

On Mon, 17 Aug 2026 at 11:47, Gao Xiang <xiang@kernel.org> wrote:
> On Mon, Aug 17, 2026 at 11:21:33AM +0200, Geert Uytterhoeven wrote:
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

Because all systems are SMP? That is not true.

> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS impacts the default
> LZMA maximum memory usage, I hope it shows the same for both SMP or
> !SMP (even it cannot be configured on !SMP, since it clearly shows
> to users the number and indicates how the default LZMA stream
> derives in general.)

I disagree: Kconfig is not meant to document underlying mechanisms
that are not relevant for the current configuration.

Anyway, I have now submitted "[PATCH] erofs: Fix
EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic"
https://lore.kernel.org/c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be/

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

