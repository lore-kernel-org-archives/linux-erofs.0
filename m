Return-Path: <linux-erofs+bounces-4198-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8497C5B56A
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 19:27:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKM8T5Xskz2yrW;
	Wed, 12 Aug 2026 05:27:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.222.50
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786476457;
	cv=none; b=YlPN6U3cyzprXbij9C9nxG85Gwi86LcSdQNq9Rgl0qkkcwICZQSMOXSDr1CJ4AX/9fs4J5zFQs2VnPt5eUZZ5VmZaufAK9hZEiCmxhKeX7Rnk89QRU1xdww4SINhoFS3ZFxrwcyEOmY5CTFsB6s5evxNDtMy7NSzKusporSAU1yosoqd2LpVva3BuwquyyM8UWyCJ5IDAYzhRVcwT9kc0b7TcL0DpMULU8FD34+4tdCKYLxer1kXgLwaYRxCBnD/I9shXSTl5383fbmvGwT1dprSByL5/WiZfyJwj6JBcXEey/gvtMcC9tmArLqL0Ddwli2zeJqgt6j2bEBoFsYwAA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786476457; c=relaxed/relaxed;
	bh=SKsq1sy7Auo3ph3Acu2Sd6USnTM+KG6OSW+xmV886ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LUnCNuho91W7T2X6QWzlhlyRbSv+fwR2QjNmUN0r0OpXRGAEohn9smZaESKqlbtT1WtKe/lfbN49Dykr/TJiFl210MXifGFnosks8swcsptlaNVZx3V/E734umOjfqb9skqsFB7eJsDAit6SkHvBVseVBiXKa5RTX/hcF/LTGId1B/IUpVfid513UeJSmtCeoWLtuXMkkTveTNeh7xtFLz5kvVQ3gVVnz/I0PwNOWVQdsf8DzmEwmJ/NYMk63M8psQ4SMZvxfgPcldYw0mRkhZ/ds7K9l8kJ8Vs6yV9l9gFVdLmg6wKitfjGu+iIxnmpCL+JG4+L0jrLJAEsFPbAGg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.222.50; helo=mail-ua1-f50.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.222.50; helo=mail-ua1-f50.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKM8R62hVz2ynC
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 05:27:34 +1000 (AEST)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-977bbf2eb1dso2415241.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 12:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786476451; x=1787081251;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SKsq1sy7Auo3ph3Acu2Sd6USnTM+KG6OSW+xmV886ig=;
        b=VTp2oO+BY+xcBM+LY0ie3ssNw0Rzh6B6dunhARdRwCgXidKNPP+Fubvf8wEAJqJZbb
         JiKL1jreJa454GKFuw/XGU1LtwJ+uOAyX/8dPlgNOJ3WNrtyv5IG/N2mDKpW1sqzNPWH
         oPHe5YFDSV/FMv3A2FpPpanisce6tA80oyeWRJTUJZ98gdJysofjt/dVNcaRUjwsbGJw
         A3MhW5BtedB2jVVCL6F2V9TF8Ca8hK0k3Oj5ZBwPSqI0sZN8nVk0bt+3QPffGzf4WBKv
         eia3l3BkUQo2hk6VIshP7sekzuLmpEJb9AVrrCt3aBJLA8q/yVDv6GUu285MzBZqBKLA
         xUDw==
X-Forwarded-Encrypted: i=1; AHgh+RpND4fNMpnP2KmVdB1ZOiYQunC+J3ga6ogXV1aqCejH0nmdXAE/r44Q0Gpl4luzW76WGB28vXCHfkXARg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwCwImhIe1PSy0OmYUKn9VDpHqH8V/dBItXCLcGbD69/WakbjBD
	4jXgjh7r/c/hvL9g6EZfwR01xy5+Q46RM761nDpRW1ZYz9N0+Q3NQhrloS6P3IpB
X-Gm-Gg: AR+sD13ahxUhd49cMQmxxJi/inaI7K+4fKIxjCvsJOsYNwEpbGGLM6TbgFWB+OcSu7y
	0LLMSeF0yS6cpGk72uhjyroLofjggEecF0HgA5DDpuMchoKIUB7W2yx/LshTpRDWlgOz3uiPyI4
	9wTzOPIh5VV43+SfEYDbFNTipubf8ioyjnsMWb7cO+XJqRMdQ1aX92eszdMlR2C4u2KFCunm0hU
	a6PdmI4BvPq4h/nZ/knHJrtIqVTEFLpkkmnvoh77LN+ZEQBpH/Qmdv/5scHbU180cBPGUxtfQJm
	Wq1DF0Zg+LzvZLino0Tdvftm0E+qpv3MHcwrOn0gW9gkLooEFZdBLMoJ2pghEwMl/FmAyvRr9lx
	0yepko5LIVDJAE6gu8DkHKOLEoZ67cjTl1iMxJzj2xkBgAC4OJirSeUkT5kVdI7a0iocPEnhd3y
	nQcUmYiubFW1RbI/EpFeCgZ4TMawE3+X3VahkAdNYVud9EzflzxYz/oGp0uoG9xAqUXjbMDRdDn
	zwOW6eQ26u+htMJABdsDHDSaNBpdA==
X-Received: by 2002:a05:6102:1607:b0:76a:fc18:29c8 with SMTP id ada2fe7eead31-76c0aa984efmr739508137.8.1786476450893;
        Tue, 11 Aug 2026 12:27:30 -0700 (PDT)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-76b632912dasm1055417137.5.2026.08.11.12.27.29
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 12:27:30 -0700 (PDT)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5bfb3347dc4so92823e0c.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 12:27:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoY7Kg1HYGUjnO4f48SAu9SCNDR+t0LNJYZTkkW8ji+L2eqa/3mPKkvsZi4nsNp8JE3oBdixdYa0/r6Cg==@lists.ozlabs.org
X-Received: by 2002:a05:6102:b0a:b0:764:ff65:fe5b with SMTP id
 ada2fe7eead31-76c0a381b32mr842771137.5.1786476449640; Tue, 11 Aug 2026
 12:27:29 -0700 (PDT)
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
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com> <anBYnPELPotUiNjv@monoceros>
In-Reply-To: <anBYnPELPotUiNjv@monoceros>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 11 Aug 2026 21:27:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
X-Gm-Features: AUfX_myoVLN35lnbulOGdWCPbF-7LLQtkbV0SUKuUSYrqVvt3k1HQ6WPKQM1qYQ
Message-ID: <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: SJ Park <sj@kernel.org>, Gao Xiang <xiang@kernel.org>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, 
	Guenter Roeck <linux@roeck-us.net>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Aug 2026 at 11:12, Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@baylibre.com> wrote:
> On Mon, Aug 03, 2026 at 10:09:06AM +0200, Geert Uytterhoeven wrote:
> > On Tue, 28 Jul 2026 at 08:55, SJ Park <sj@kernel.org> wrote:
> > > I don't have a m68k testfarm, either.  I'm doing crossbuild [1].  Hop=
efully you
> > > could also reproduce it.
>
> FTR, I don't have m68k hardware either, but as this is a build time
> failure installing the Debian package gcc-m68k-linux-gnu and then doing
> builds using
>
>         make ARCH=3Dm68k CROSS_COMPILE=3Dm68k-linux-gnu-
>
> is good enough to reproduce the failure.
>
> > I think you can reproduce some of the issues on most architectures
> > with a non-SMP kernel, cfr. my reply[1] to Uwe's proposed fix.
> > Unfortunately the Kconfig warning only shows up on architectures that
> > don't define NR_CPUS (because they do not support SMP) at all,
> > while ending up with zero streams is probably a runtime failure.
> >
> > [1] https://lore.kernel.org/CAMuHMdVGKX=3D3cfOrLWp1uSHX76xf1-=3DC0+GVCX=
kA8JTqNPg-ew@mail.gmail.com
>
> I guess EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS should depend on SMP and
> it's use should be conditionalized using something like
>
> diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
> index 6b0cdb446c6a..c00e94f8206f 100644
> --- a/fs/erofs/decompressor_lzma.c
> +++ b/fs/erofs/decompressor_lzma.c
> @@ -50,9 +50,13 @@ static int __init z_erofs_lzma_init(void)
>         unsigned int i;
>
>         /* by default, use # of possible CPUs instead */
> -       if (!z_erofs_lzma_nstrms)
> -               z_erofs_lzma_nstrms =3D min_t(unsigned int, num_possible_=
cpus(),
> -                               CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STRE=
AMS);
> +       if (!z_erofs_lzma_nstrms) {
> +               if (IS_ENABLED(CONFIG_SMP))
> +                       z_erofs_lzma_nstrms =3D min_t(unsigned int, num_p=
ossible_cpus(),
> +                                       CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_=
MAX_STREAMS);
> +               else
> +                       z_erofs_lzma_nstrms =3D 1;
> +       }
>
>         for (i =3D 0; i < z_erofs_lzma_nstrms; ++i) {
>                 struct z_erofs_lzma *strm =3D kzalloc_obj(*strm);

LGTM.

>
> I played a bit with the definition of
> EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS in fs/erofs/Kconfig, but didn't
> find a way to define it that both uses NR_CPUS and doesn't generate a
> warning with ARCH=3Dm68k.

Any progress with fixing this for v7.2?

NR_CPUS depends on SMP on most architectures, so you get e.g.
with ARCH=3Darm allmodconfig + CONFIG_SMP=3Dn:

    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D0

X86 defines NR_CPUS unconditionally, so there it works as expected.
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

