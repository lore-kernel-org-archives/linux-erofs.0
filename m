Return-Path: <linux-erofs+bounces-4228-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A814BC5CFC1
	for <linux-erofs@archiver.kernel.org>; Sat, 15 Aug 2026 11:42:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hMcdk13VPz2xnS;
	Sat, 15 Aug 2026 21:42:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.217.41
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786794138;
	cv=none; b=bvLln4S0Bw9wu16O9uAHwu7Q326QliskOxSDQUDIj+OoJeOf/FxvH+huaASA5TGdb3RNWyrryPNtni7s7aCUE0CMM79YCDVvXvhaQS7RbwSJfUlTJLszZyhWR7T5h9MCzg8EDVy14amGniYqRQRoPytSi63zjiqp/blsM7BHYH7cTX2d32zeXihCcrWlUD0vHpRDuhrp42MKeMw+lbLcYt4ysN9GhYkW22rChpl0kmh9di1sbuPmKfrOWqOfmhT/9L/7EsNZLmPs6BL9ttFfhdIfnkATx/ZJWbohLVr1KYl7kCy3JSJxoLdyhfCaG7jPduNV3iGSUJWU+AAEITjsIA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786794138; c=relaxed/relaxed;
	bh=0rUTv5K3p3pcfp6FAure4QlzpyDmPoMH+895UYcj4JI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jaNHy0l1OAjfTRcCF8aXvLrGVz5Ck5pHOZ07YEpnPP5eJXXcd5kE2olZStBvVvz7SRYRBI0iWNDmBREAwsx9rR9IrATv/Nc8b8ZfUb2JTk3dfvDcDtHCkm8yE6Md51NuvutLkf/J6yfBir/bp/ERSu2vlBtUF0f6pf5+wCG5UX4eT6QAuxZl509uVTe3RZAWPqwrzs0OTlJzw5SXwv/NgsHSdiPqNWzmJCJKZycORiJTxabB/DaDVDCqPTD5Jd4gAfB7YcUQcv0GaW6iHelf++x8xTGWiVohLMhhKQjqJv/1DYpScJKEdgyhGhwk9OYT+YLoebCBUE0fSwqJP7TwCA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.217.41; helo=mail-vs1-f41.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.217.41; helo=mail-vs1-f41.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hMcdh1PhKz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 21:42:15 +1000 (AEST)
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7466771f1caso545505137.0
        for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 04:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786794133; x=1787398933;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0rUTv5K3p3pcfp6FAure4QlzpyDmPoMH+895UYcj4JI=;
        b=h/6Mg39ze7YPsHKjtgiOLkV3brHOZPdHGHJ4V50uaKqh1Lmsscc8PJs9ouV//HURNU
         E/HJJ1Im5BGFDdluuRcwqPuP5rU3xBMtccV0uMYWnuc3jA2s0MUxK/nFu0j12xjNGJpC
         tcnJWNrDE/azDoS89m1/YgqUqv/9uj/iyUYxWZWaKV3SsiBLAObk6+sdce1eyGf1gt91
         3BKf3IFCJ5J92kmdfZQGDloKsk4/FSdjkcemteCwvGrpyGp8jjX5nWzG0do8yfNEN2+R
         VFMFb58V8Vr0QkA9tfbpIxEDOS11iRsHOGGknbtM5O2nf5QqtkAsUQxRw+mWd6xFANLm
         zQ1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqI0OtgEQCrVusXATAqlD/5HCCjhE0AJjSWr6FiF7BY0cMtZgeCtZqlo5d19RcIbLA3SK07gf+F15J8lQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yy152UG9Jyf/tXO7ORi9sJ+tLpISz6RZPrrpanYlvpkAA4v1iwM
	OLzCxfk1WXSc4Q3ob7W64Fra4Eidqj155JQum/ryQsgeK2M4pzPNocseumAzjMknPq8=
X-Gm-Gg: AR+sD10T8S5qKePkJfDh7zq8c8RTwHshqtSGPLziWRP8m8MU7w5x12UZNIvU4va8Tyk
	UMIllo3mGVeJSZvs2jRCZgmMp0zLrQvUdNXoRwavbbPRaSL/iq03cnpDCkQIlM/wJRDprANgR5e
	hJQwRm3M2Uywl+eslyjfKBGosbXhD/jhtDuQYTXTcuU1ZY4nuQUbE5f5XPRG3mJcG0/GAILUPZH
	chib142dHhqMdRkZFrewLa6HYiXfSHAHNJ+AKozwD5WoHyIFtPsKdEloqIrr1MrWbMeczSfNslB
	iz7a9UlWZVa0tcWmx1GLrsK0m84OjZWultFAIzOvIPbvkyjhwVZ2FG9BVt/TZObBozUABwt2Lmu
	ijmHqJYWradcdZ2DnSYhGz4mEcqnEJ8xB8IDspsd5tcLfQF+OMMr4A+uaSXafnQ76chsQeogf/N
	Oq1GMCqnQalfy5Hu91eLHD6UGVyjlYLqnz337ECrCjxS5mihOXKtd/O/OZGHvuMUuwEjepAybRG
	EHuy/+zKrvEZFc1SodRgteIkQ==
X-Received: by 2002:a05:6102:6b0a:b0:744:cb59:d6e0 with SMTP id ada2fe7eead31-76f2767f322mr1967059137.0.1786794132632;
        Sat, 15 Aug 2026 04:42:12 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-76efa511f43sm2365263137.9.2026.08.15.04.42.10
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 04:42:10 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-963f63fe025so404595241.0
        for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 04:42:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoUdlLjYTYMvLIBfSRMwyg5D6C4iEYNkA3phB/S07BNWqZ7Ob8J7SzbcXjyVpYQNGDvjtMU/CHML3HZmw==@lists.ozlabs.org
X-Received: by 2002:a05:6102:850e:10b0:770:63a1:b26f with SMTP id
 ada2fe7eead31-77063a1b71dmr649108137.10.1786794130006; Sat, 15 Aug 2026
 04:42:10 -0700 (PDT)
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
References: <20260728065447.91511-1-sj@kernel.org> <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros> <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net> <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local> <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
 <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local> <5825b5c2-06b3-4358-91b0-d7bf437528a3@roeck-us.net>
 <an9d0zxE5J8txxf6@XiangdeMacBook-Pro.local> <1638f2a8-d9cd-423d-83f6-2b436e3c9de0@roeck-us.net>
In-Reply-To: <1638f2a8-d9cd-423d-83f6-2b436e3c9de0@roeck-us.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 15 Aug 2026 13:41:57 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXpJY3gqx98z92=P8NxV2_-_N+5OVqNvMLDMKq9bhuY+Q@mail.gmail.com>
X-Gm-Features: AcwNN1WYoN-n_CAfH-GW_Zs3A4lf_FFUASxx_a7f-R_6u7A4lR5RgAtY2rsqH94
Message-ID: <CAMuHMdXpJY3gqx98z92=P8NxV2_-_N+5OVqNvMLDMKq9bhuY+Q@mail.gmail.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: Guenter Roeck <linux@roeck-us.net>
Cc: Gao Xiang <xiang@kernel.org>, Michael Bommarito <michael.bommarito@gmail.com>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	SJ Park <sj@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, 
	David Hildenbrand <david@redhat.com>, linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi G=C3=BCnter,

On Fri, 14 Aug 2026 at 20:44, Guenter Roeck <linux@roeck-us.net> wrote:
> On 8/14/26 11:26, Gao Xiang wrote:
> > On Wed, Aug 12, 2026 at 07:25:50AM -0700, Guenter Roeck wrote:
> >>>> Thank you, that seems to work (despite still seeing the warning on m=
68k,
> >>>> as NR_CPUS does not exist).
> >>>>
> >>>>         $ make ARCH=3Dm68k allmodconfig
> >>>>        fs/erofs/Kconfig:137:warning: range is invalid
> >>>>
> >>>>    Warning...
> >>>
> >>> Yes, other arches shouldn't have the warning because I think other
> >>> arches (including microblaze) defines NR_CPUS in Kconfig, except m68k=
.
> >>
> >> That is not entirely true. openrisc only has it if SMP=3Dy. But it sti=
ll
> >> does not generate the warning for some reason.
> >
> > I looked into the documentation a bit
> > (https://docs.kernel.org/kbuild/kconfig-language.html), especially the
> > following parts:
> >
> >   - type definition: =E2=80=9Cbool=E2=80=9D/=E2=80=9Dtristate=E2=80=9D/=
=E2=80=9Dstring=E2=80=9D/=E2=80=9Dhex=E2=80=9D/=E2=80=9Dint=E2=80=9D ...
> >   - input prompt: =E2=80=9Cprompt=E2=80=9D <prompt> [=E2=80=9Cif=E2=80=
=9D <expr>] ...
> >       and "If a prompt is not present, the config option is
> >            a non-visible symbol, ..."
> >
> >   - dependencies: =E2=80=9Cdepends on=E2=80=9D <expr> [=E2=80=9Cif=E2=
=80=9D <expr>] ...
> >   - Menu dependencies ..
> >
> > and I think that is true, taking openrisc for example:
> >
> > config NR_CPUS
> >          int "Maximum number of CPUs (2-32)"
> >          range 2 32
> >          depends on SMP
> >          default "2"
> >
> > which can be transformed into
> >
> > config NR_CPUS
> >          int
> >       prompt "Maximum number of CPUs (2-32)"
> >       range 2 32
> >       depends on SMP
> >          default "2"
> >
> > which can be then transformed into
> >
> > config NR_CPUS
> >          int
> >       prompt "Maximum number of CPUs (2-32)" if SMP
> >       range 2 32 if SMP
> >          default "2" if SMP
> >
> > so if `SMP=3Dn`, it's equivalent to
> >
> > config NR_CPUS
> >          int
> >
> > so NR_CPUS symbol is still there I think (and its value is 0.)
> >
> $ grep NR_CPUS .config
> CONFIG_FORCE_NR_CPUS=3Dy
> $ grep EROFS .config
> CONFIG_EROFS_FS=3Dy
> # CONFIG_EROFS_FS_DEBUG is not set
> CONFIG_EROFS_FS_XATTR=3Dy
> CONFIG_EROFS_FS_POSIX_ACL=3Dy
> CONFIG_EROFS_FS_SECURITY=3Dy
> CONFIG_EROFS_FS_BACKED_BY_FILE=3Dy
> CONFIG_EROFS_FS_ZIP=3Dy
> CONFIG_EROFS_FS_ZIP_LZMA=3Dy
> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D0
> # CONFIG_EROFS_FS_ZIP_DEFLATE is not set
> # CONFIG_EROFS_FS_ZIP_ZSTD is not set
> # CONFIG_EROFS_FS_ZIP_ACCEL is not set
> # CONFIG_EROFS_FS_PCPU_KTHREAD is not set
> # CONFIG_EROFS_FS_PAGE_CACHE_SHARE is not set
>
> The symbol may be there internally, but it does not show up in .config.

    config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
    ...
    range 1 NR_CPUS

Apparently the default value picked by "automatic" configs like
allmodconfig and defconfig is the last item from the range.
If NR_CPUS exists internally (e.g. openrisc and arm), you end up with
the "undefined value", aka zero:

    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D0

As NR_CPUS did not exist on m68k at all, you ended up with the NR_CPUS
literal:

    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3DNR_CPUS

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

