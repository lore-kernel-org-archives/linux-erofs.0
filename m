Return-Path: <linux-erofs+bounces-4243-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 248BDC5B572
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 08:43:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNmZv1tBGz2xy6;
	Mon, 17 Aug 2026 18:43:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.222.45
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786956231;
	cv=none; b=IMO2NiCpy+aOdQFRvByHPQnyYp9iTS/Or2e29VxUOY0oNzAf9GYU8N1k3KJ2NCkv3ZII5IKrZN2LyzHbPerLStPeeJ4rujjmOgYNNTNzDGoNRpegbvGE6tUTQb6G7p5FEFRQGoTZYiESPh9l1qpp4nmEEmkMyCof08B3+AfXQlnu4zkhWEFwougTxnpOaqAEA1NmPD82lFs0bExGtC+DBG7TO1QmAXxE1VJvY1HUjs/0ZC4qrvuDsa9rML0EfgQjo4AXe421X7pz/UYDREtsa72wDiOxldoUFxbFbulDckixlVemJGn06IRJzCfobcFXRBIMA/jsHmGjk2PoDfMuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786956231; c=relaxed/relaxed;
	bh=vWWpvBFQVCkmVNab6Wr+qzEQIE1RNW7ncUxmLFhscBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hOJl1aPSGRkdOnqXs1zuDmy9zSEo3FJHMoyTjXgELv2HIeVf0y6VgR3SMKJbvVzGlA7TjanTSLhuXwJkllOuZiznXCVj8Wi4VXfsMRD/ktSHRJBR6siyKjjY05oPdtbUeHJAsVKEuD1GAMBZnccaVO1apdZWK/2+IpfplPUnHVOPIkt39JVj0QK3+MBDGWLaiUVArVcTijlLOMB8P0Q+DiGsuNarggGmP8y+CfAFNvJfKrQwvVJtZuUQ3oe6DIVQu7Aj8R6doByx67FTQZmVOgXYibsf0FG4/A9u5Oj8nhIiFegPvExDZywyNvFyDsPOJw46Yu0K3dSCsmtZb9bosw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.222.45; helo=mail-ua1-f45.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.222.45; helo=mail-ua1-f45.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNmZs5wc9z2xWV
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 18:43:49 +1000 (AEST)
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-973b676e5f5so1984439241.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 01:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786956226; x=1787561026;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vWWpvBFQVCkmVNab6Wr+qzEQIE1RNW7ncUxmLFhscBE=;
        b=rgAlK3EGqrqh/JBlusTo1xo7G3L4Pe+nxqMhv5cFOug/4DvqAVATO/gfwLit1nWkJ5
         bdnuA3tTxweFvMkb7eAu+65qEOAOa8OUxzrRpjXMSSYF2spvbZqn5ssie4KykOP7PllL
         zcPk8sbda5aFdZDOzbNbKbHhY6QIZpXdK8A67oJ5aFb+UPfZr66XBfq94nCcHYZzXnSF
         qr1NjmFdkjdVIw+I083uUAqOQDzm7SJHWSqCzIDEzsHjMZ9CLIwty10CJtvK3YR33NVb
         eWIulqmZjqACbUQoc88dvwFMQAuaf4ZmHS+xOdvCbP7zyxw0Xi8g8s8XJfmzz5a1+9UN
         QKRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrcX7ph/fDuTnxED9XOE2Zc9676TFYcWNStcS+Dj2EnyRRhae90hYrNvoWviYUA6Ry/r7CHYFgrIyvRFQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yz+tXdUP9S6TVdrQrRbaHX/WBnGFcIq9GKoU0rE1XyUI2EIQ6Xv
	MBro057jSxjMCibf40+8fDoKpnbsysT3OqFzXdk+SFpXxfsORnpltiRRB4aR7XIA
X-Gm-Gg: AR+sD11wL0mf+6ZEqGmv3F+41JYRtzE2bG4iZIU8AREEiCqfQyI3BllyaAG/VIkiZJF
	F8kcKnX65Ml5sl+XWh7mAWhTFCLP9lQ2xewD3lZG72Nc0wqGllq0ir6kZed0uAodj0GnCeyTlnq
	Tr5zmZWtQalEzDXLtGz83rFoPjWYEcriRZfC9PjN2Q1kIPegvMR6pEMrl2SjYeMA0nCNTBSVWxD
	4oW46iiGJ+NBg6qTPC/fRJEFL2yShaRqXvC0TXs3Ovl0ZjCLCGSjPgCuGETtQv6wC5DzGb8DYcJ
	XPs+UoZuldAX1+z8V1KZX32L/6DLIw3vVVrg7vk+lZyDfbruD+i6ruESXlHNAAbz6BnBSrAO3nD
	UqAcvZCWacgD4WY7ar8iqVvk/ls6vqNZAbxks2vL7u2IcR/loYllw/RUzCg53Qw+YO7vrESNFTF
	7744z7O8NXsNIAqJIvC1xs4/wq1EblblH+Wwa7QbY8PTkUQ3DF6a0CH8/4ZIsVS54OGLUMEB+7z
	tThiq3QoooRY4TuzTf/TrV0AWwNQA==
X-Received: by 2002:a05:6102:6a85:b0:74a:b492:3a62 with SMTP id ada2fe7eead31-76f2c227b92mr5055265137.4.1786956225864;
        Mon, 17 Aug 2026 01:43:45 -0700 (PDT)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97c2c14799asm667651241.0.2026.08.17.01.43.45
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 01:43:45 -0700 (PDT)
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5bfc5b77c02so2357709e0c.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 01:43:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoZOf0i4xEh5umUZNl/8XmrnoumLJMV6DvNheZDHwD3H+U7GQdLKkdFu90p47zcZ+Ri0Xja+CXOhb3M+w==@lists.ozlabs.org
X-Received: by 2002:a05:6122:4b0b:b0:5bd:fb8c:5db1 with SMTP id
 71dfb90a1353d-5c591f44c22mr5713439e0c.10.1786956225322; Mon, 17 Aug 2026
 01:43:45 -0700 (PDT)
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
 <aoLB0mk6rE4htbZm@XiangdeMacBook-Pro.local>
In-Reply-To: <aoLB0mk6rE4htbZm@XiangdeMacBook-Pro.local>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 17 Aug 2026 10:43:34 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWmcj5SQ-AbyhWL3jiPJKdmNq64m-BOAe3T7HPjJqaDBw@mail.gmail.com>
X-Gm-Features: AcwNN1XvnLnloGHrG1WZR9OQLUUtgeKasWMSiQ93iLcLdedFD_QiZMLQRkcDbuk
Message-ID: <CAMuHMdWmcj5SQ-AbyhWL3jiPJKdmNq64m-BOAe3T7HPjJqaDBw@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, 
	LKML <linux-kernel@vger.kernel.org>, SJ Park <sj@kernel.org>, 
	Guenter Roeck <groeck7@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

On Mon, 17 Aug 2026 at 10:10, Gao Xiang <xiang@kernel.org> wrote:
> On Mon, Aug 17, 2026 at 10:05:09AM +0200, Geert Uytterhoeven wrote:
> > On Mon, 17 Aug 2026 at 09:49, Gao Xiang <xiang@kernel.org> wrote:
> > > On Mon, Aug 17, 2026 at 09:32:51AM +0200, Geert Uytterhoeven wrote:
> > > > Thanks for your patch, which is now commit a64d500b0078e16e ("erofs: fix
> > > > EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms") in v7.2.
> > > >
> > > > > --- a/fs/erofs/Kconfig
> > > > > +++ b/fs/erofs/Kconfig
> > > > > @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
> > > > >  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > > > >         int "EROFS LZMA default maximum decompression streams"
> > > > >         depends on EROFS_FS_ZIP_LZMA
> > > > > -       range 1 NR_CPUS
> > > > > +       range 1 NR_CPUS if SMP
> > > > > +       range 1 1 if !SMP
> > > > >         default 16
> > > >
> > > > I have just discovered another oddity: when you have less than 16
> > > > CPUS (including SMP=n), this default value is invalid, and "make
> > > > savedefconfig" will always write a line like
> > > >
> > > >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> > > >
> > > > to the defconfig file, even if that is the default suggested value.
> > > >
> > > > Needlessly polluting the defconfig files could be fixed using:
> > > >
> > > >     -       default 16
> > > >     +       default 16 if SMP && NR_CPUS >= 16
> > > >     +       default NR_CPUS if SMP
> > >
> > > I guess `default NR_CPUS if SMP && NR_CPUS < 16` would be better,
> > > I'm not sure since I'm not handy in Kconfig stuffs.
> >
> > Kconfig always picks the first matching default value, so you don't
> > have to exclude the "SMP && NR_CPUS >= 16" case here.
> >
> > > >     +       default 1 if !SMP
> >
> > If all architectures would always define NR_CPUS, one could replace
> > the last two lines by
> >
> >     default NR_CPUS
> >
> > > >
> > > > Thoughts?
> > >
> > > In principle, that would be better, but may I ask if there is some
> > > severe consequences out of one extra line of
> > > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1?
> > >
> > > Since it has been fixed for many times, I hope if it could be improved
> > > later if no severe impacts, sigh..
> >
> > It causes more churn (defconfig updates), and makes the defconfig
> > files larger than needed.
>
> Could you submit a formal patch directly (since you found it and
> suggested a version)?
>
> so I could submit it along with the pull request if you're fine with it.

Will do, I want to do a bit more testing first...
In addition, usability can be improved by hiding the prompt on UP
systems:

-       int "EROFS LZMA default maximum decompression streams"
+       int "EROFS LZMA default maximum decompression streams" if SMP

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

