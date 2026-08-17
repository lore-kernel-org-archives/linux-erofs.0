Return-Path: <linux-erofs+bounces-4239-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF2EC5CFC1
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 08:05:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNlkZ0CgRz2xy6;
	Mon, 17 Aug 2026 18:05:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.221.173
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786953925;
	cv=none; b=W2vBwKee/SZHrd446eduMki9T3p78o/yGytiUvAy6lDURwLCao5BK5E+Yvb1zhH1z4trsp17FqbEsOoDGFnuP5GtGkJVjuwAu1oK3ppJ6u9reUgu1lmlpJ0alRf9ymMjHg5Fo0bfXfBIYkietzVDf/fueqaxdP5hueytTDzcs3b0dOVxogOkjXU+uNPNo8u2JJX9aHC4HbWOe2v2Uwa1kM/UdARAtXPhW3UM2d5mjbixlZmBID/rdky541elE2LPn8McMDYBRh3kU68qZxx3sy6SfrAMoEkTOnL21o2NoRevB75vguwvDyEonWEqc7r2v39ZcVacdB/mFPQgH9Ys9w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786953925; c=relaxed/relaxed;
	bh=cfb6+conlmTSAk788D8dXigOPUOrnG+6BswdAqf7bj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TtuyVTUHqzoiSeeWUpJRmHfFeG72Vmr7n7Lr6HACy8gCrBhb3BcVbGrq0Ee0AuKQjiiJv+uWA7wcz/2ZTk7LYImH55019rUB3UzbmLyFCPJH3dGSN2IMaTNsY82kDV5TLuTvxUn/tGIHDoNNhgHseTKtHR2ZUpMIF3PMoQZEKdpphIJAJWYeoJNSKu4/UEdpGUFD9gZNcfXWjHM6YvTcPO813gOi1llT6R2jdVt6zsYpAuD31BRlvb/PPYl4r5Usw7RrmIpHV6qs4POvTGetyIq/GdOOQBPY9OgT+Km1R99q9cnOATwVIN/JryFgcgRa2PYiCVyM+ZfhUSicpvvMEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.221.173; helo=mail-vk1-f173.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.221.173; helo=mail-vk1-f173.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNlkX5fcnz2xl5
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 18:05:24 +1000 (AEST)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5c30d9adfa7so1017232e0c.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 01:05:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786953921; x=1787558721;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cfb6+conlmTSAk788D8dXigOPUOrnG+6BswdAqf7bj0=;
        b=qOkX3LFOqajxryKuyBoo4IXncYEb7vgaa8fBtXf7mpH543GRLiKxBddL4iq2j9nrLP
         h9i71fYHLriJzslX1o5ERzo0T7CVIsKa/dml3o+DwsZVDAhgzZ9iqc3lZxjenoTW6KS/
         MIV8GBKBVxSDk1cb2riSILRozsRAkCw/a7BZOj6njKYZRpHesIK0OlEsIvktM+5kEpRf
         GbjSwJU/zMsKzaQtOGEVQqPl/KnaQfZ+0PKb9oQeW9hBejOcobe/spkhAHaQKSnR3MYC
         jn55AjQwfsZ5ijRcrQTrgtJId0+b3faudyxiuqDqO6hT+8ccvefleHPJxvlmSwjkC6KY
         9Z9g==
X-Forwarded-Encrypted: i=1; AHgh+Rq5if5tztou8YMTm3dGwtpIiqriUhwfE5tmMJ1pRWpVQSN5u4qjpurG4Qol6GAgrQNujPrjUdGGLOwW9g==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyT1EK5uxppoiQolU5NZgaVdst4jHW/jQccuxq4qJUUb7c7WNVL
	KDTEms+02rFmYi3UyOQaxycpZF0y8mkW4e/dfUGRxsf8wd1PSYbl9YqxDq59wg2E
X-Gm-Gg: AR+sD11DhSrVGcxEy+dnD44ZcLHyUbv3L+QkZLyIzzHOGyuuEDS8Q0cl+MDuNUeDUnq
	lwf9rqZRX49r9d6o2r0RJdGrv+Ysbt5uFKntzj3/h1nFQgmxpT9poj/lMo858ukNQwLfMYWrW9D
	DL7a2cMvaqARog2cFEUUsWLpsVkGC1JA/WosaIjbKpQ8kUyAzopCm8c+b88Xqhe48+BJcPVLIXn
	zQJyHac/IG8tuhx0ls9GEdhEUMyEFWoyeAYGHWMqFo71kuAtbeL/esqYfCDV3pm5RXihHPaV9yy
	1jNa/LUX+QOVNdHo+JxBZ3eFRhwBG/mM6VVO43aQ334PQb/iC6rNEYICofyZH2xpYwn20RRDHMM
	8oWnF6OCp6zHsP7E+wgvtwXRfzQAHu11inui85Lh+wLHMP+lW1aMbCsQN7Kb4Upcso+8UTWJzvL
	SiyygRpa7sXt8AGMrdFJr67/vpxqjKm0GxIUyjEofhED6/cx3C2GpToSBq6jcVRlxsm8gImcGOV
	xc4SAh34jT/YFlEsXOkKyOvteVALA==
X-Received: by 2002:a05:6122:6091:b0:5bf:b879:15c0 with SMTP id 71dfb90a1353d-5c591cc744emr4039330e0c.5.1786953921301;
        Mon, 17 Aug 2026 01:05:21 -0700 (PDT)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c5c764e7f0sm444839e0c.6.2026.08.17.01.05.21
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 01:05:21 -0700 (PDT)
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5bf83925ddaso1067542e0c.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 01:05:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrZ+SMWba+bIVE/oXeb3XCN1KCH0nA0X0Z8GnTQdNoERHnxUgeLzEgbRY2BJmDQSNObtTSM/ib72zSgUg==@lists.ozlabs.org
X-Received: by 2002:a05:6122:3401:b0:5bf:4522:fca7 with SMTP id
 71dfb90a1353d-5c591c966b6mr4776103e0c.4.1786953920834; Mon, 17 Aug 2026
 01:05:20 -0700 (PDT)
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
 <aoK84br1-61FLLXB@XiangdeMacBook-Pro.local>
In-Reply-To: <aoK84br1-61FLLXB@XiangdeMacBook-Pro.local>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 17 Aug 2026 10:05:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWeHTsAMtgwVT9hfvmZj_Z8G8JG7pV2rVEnEOSiqsCDOg@mail.gmail.com>
X-Gm-Features: AcwNN1V6UK-V_sOiwm7iJStyXWPQcRpgb9Tb2YvHjOkj9xjMVA508SR69lribCU
Message-ID: <CAMuHMdWeHTsAMtgwVT9hfvmZj_Z8G8JG7pV2rVEnEOSiqsCDOg@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, 
	LKML <linux-kernel@vger.kernel.org>, SJ Park <sj@kernel.org>, 
	Guenter Roeck <groeck7@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

On Mon, 17 Aug 2026 at 09:49, Gao Xiang <xiang@kernel.org> wrote:
> On Mon, Aug 17, 2026 at 09:32:51AM +0200, Geert Uytterhoeven wrote:
> > Thanks for your patch, which is now commit a64d500b0078e16e ("erofs: fix
> > EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms") in v7.2.
> >
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
> >
> > I have just discovered another oddity: when you have less than 16
> > CPUS (including SMP=n), this default value is invalid, and "make
> > savedefconfig" will always write a line like
> >
> >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> >
> > to the defconfig file, even if that is the default suggested value.
> >
> > Needlessly polluting the defconfig files could be fixed using:
> >
> >     -       default 16
> >     +       default 16 if SMP && NR_CPUS >= 16
> >     +       default NR_CPUS if SMP
>
> I guess `default NR_CPUS if SMP && NR_CPUS < 16` would be better,
> I'm not sure since I'm not handy in Kconfig stuffs.

Kconfig always picks the first matching default value, so you don't
have to exclude the "SMP && NR_CPUS >= 16" case here.

> >     +       default 1 if !SMP

If all architectures would always define NR_CPUS, one could replace
the last two lines by

    default NR_CPUS

> >
> > Thoughts?
>
> In principle, that would be better, but may I ask if there is some
> severe consequences out of one extra line of
> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1?
>
> Since it has been fixed for many times, I hope if it could be improved
> later if no severe impacts, sigh..

It causes more churn (defconfig updates), and makes the defconfig
files larger than needed.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

