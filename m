Return-Path: <linux-erofs+bounces-4202-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2826EC5CFEB
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 09:30:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKjs76KM3z3bpP;
	Wed, 12 Aug 2026 19:30:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.221.169
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786527035;
	cv=none; b=InnaRKDrIIsogyt7BNhxrI8/PfSr75O673oKgzHIyqyl7BeHNLEUROS5Sw6cRezLB/aEDRXhC39CvqhCvJzHa6ztnD2Bjkej5dpy3DDC5K2qH8mnUGFwsg26BNgysfV7I2pI6YNjUUPPz3Dp+0AuRl0US8XBi+AM3fpGRH9oVQ9lxcZMzhad0VeRHRq0PM+w3sn2Qfnni1tTaxVYjutnkBvcwWPgJJNPJAyixu8PbkTeelcmmaFWVDSnLpzxgtKE7Y1JP8+1yAwR1pc4GfEX6WuqEwbyL37WFnfG3AiO737ZqpD6zVn+tFekZqeoZENOODQgwxmZkT2XctyWGCeubA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786527035; c=relaxed/relaxed;
	bh=HsKpew/NpbmRwJwh6JVQkfOwogDxzHNyZba/zwHTTH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LLZfx0JScDGUAtVyBAGYsmZkqb9CECHa8V67+odXNNijkBCr45YXgVjdz+0qxHPq1RiUAobAMR1AdOnAeDNdMycmGmovEqsMZJguTI4cdGjwx2n4OCXKagUWY4Ir/h9AvRkI66E9KCIFUa4S0X4fSQhpNhGmypfZB0Y/WFI+NJCo5wTuNnveKTeZGHRblyxaKxjXfGpTBH447+XgKZ8+dsPPtRLAKbVw+pWqz8bpfXYSlcYgLq+tncizq8cOH+ruFugCoC4U2s12c79yfOpxu2AxLhbTiQ9wUdToLX5uqKznuqHRspnFP4OndgoJ1sG2kj1ce8WKCf6w4d6evKggDA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.221.169; helo=mail-vk1-f169.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.221.169; helo=mail-vk1-f169.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKjs56jNfz303K
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 19:30:32 +1000 (AEST)
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c38565e774so222245e0c.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 02:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786527029; x=1787131829;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HsKpew/NpbmRwJwh6JVQkfOwogDxzHNyZba/zwHTTH0=;
        b=oUsN/hlR6X8suxVVVv1AwZDwSD1EP1SYHFgVUOjrC5ZBKuOqrVsL7I+ial2hKYVTh1
         K5lTK6v9ts7saieY78avIWUpYia0X7nmSfrlAWJcQxiR4av1I9kIAegh/kTWEhKmYt/g
         zbeHfNFNX5HkPKRlhQF7R81QWKaBlTAmIsmsbAhCmMp8JDc+zVJgev50O6bY9vy0X+wB
         SfjUSVhDGic8K9ohLD/AWMQAaKfTW1aSK61q1ojFJTknnNnaXtMw43c/pJ7WmhXnKxcm
         PDkGoAQppKm/TX7k4sAhPIyQRi2C5hudV2R3gI+w+uJLo4okl5fkwJBehudCmM4PrwaG
         Uh/w==
X-Forwarded-Encrypted: i=1; AHgh+RqBZOikrYHUchlzq9X+esuqdUZ8p+UCfvAZoVFkatwt4S9uaEuxEFFcod+DeZ43HvlX8ltxayIbvxPeTA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yycxo1haHDNeCcDAc051nCepLooW3QntEhIZQ9u8AScCvUZj7ga
	y4vPajXsYKqO9PZ3ifSvtRFHmZs5FOOjJQR9EMzVXg34GEUbEwOKdgSzgnFPWSMP
X-Gm-Gg: AR+sD11U0GDSGVwmmRyoG//xuR4SwnivemDgdqgmgIfb/HsgFX5Qm14kfZoD7v8qLbT
	ryjOK4v5YdctKDi+YTx+abnqEwnI8W5tywz4mIluQIBugC0dkknVDXIDYudz8lMjdrydvbnTjd6
	G7W/izK/hboxE1XMhiCnMPGhD2mscN2aVinfBzStC4b9X+O/oA6aP72zghQmFBrrYqFn2CPpN7B
	Hv1TskaKovnaZSi43OlR2635MyBKHzhUDSm6hfiA+9wPDDOoTc+iKLy55bRGBrt/YvSGLEFUREw
	rTX7G8fApod6cOZNadzaWdXGlAMtWk6eB47La1dZIv7iTNOBzY8XvV9Vi3jgvZdjk7UROLU/dLZ
	zDlfLky/r4e13HYRjHdJE2jGtzgzj7X5iebj+xJEXaifRgeMRpw345DDdn9JRJPnIkOcjiSNd3v
	+TfccAUqHy7DFCnNz18W1qoTb8oJjnLxt6RJznb50YNCXMQtjtMVLbbUqzAI+c6rZ5JsnVD3Esh
	9Hg4Au+Dr6gvrgbKT49vPdCOQ==
X-Received: by 2002:a05:6122:134a:b0:5ab:26f:49e3 with SMTP id 71dfb90a1353d-5c501f4f871mr276688e0c.3.1786527028469;
        Wed, 12 Aug 2026 02:30:28 -0700 (PDT)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c45b460a48sm951093e0c.2.2026.08.12.02.30.26
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 02:30:27 -0700 (PDT)
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-963a722ed59so234267241.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 02:30:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpspmLqaqLGNOGunMlXbbO/gxu9Yeb4Nj14B9Q7lxb9r9yDGqe3DcmhSODFLmABbrNLeBBySEIsy+VFOA==@lists.ozlabs.org
X-Received: by 2002:a05:6102:3c87:b0:737:f0ba:508f with SMTP id
 ada2fe7eead31-76c87872117mr743103137.3.1786527025984; Wed, 12 Aug 2026
 02:30:25 -0700 (PDT)
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
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
In-Reply-To: <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 12 Aug 2026 11:30:14 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
X-Gm-Features: AUfX_mxA9clRzUNdd2GP67STTBu3d3CfSgby0ufuk5IkGAlxaBZE-BZi7BRVSMc
Message-ID: <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: Gao Xiang <xiang@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Michael Bommarito <michael.bommarito@gmail.com>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	SJ Park <sj@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, 
	David Hildenbrand <david@redhat.com>, linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao,

On Wed, 12 Aug 2026 at 01:37, Gao Xiang <xiang@kernel.org> wrote:
> On Tue, Aug 11, 2026 at 03:37:38PM -0400, Michael Bommarito wrote:
> > On Tue, Aug 11, 2026 at 3:35=E2=80=AFPM Guenter Roeck <linux@roeck-us.n=
et> wrote:
> > > > Any progress with fixing this for v7.2?
> >
> > I would like to fix this since I started the problem with the original
> > patch, but I feel a bit stuck.  My v1 and v2 patches would not have
> > triggered the build failure, but Gao made valid points about the
> > trade-offs that led us to this v3.  Maybe it would be worth your
> > opinion on the config approach in those earlier patches?
>
> Sorry about the late reply.
>
> As I said, I really dislike hardcoded range, but it is an issue that no
> NR_CPUS definition on CONFIG_SMP:
>
> I wonder if the following diff resolves the m68k issue (I'm not an
> Kconfig expert but it seems to work on x86_64 !CONFIG_SMP):
>
> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> index 8ca1767dafb6..2dfc313588d2 100644
> --- a/fs/erofs/Kconfig
> +++ b/fs/erofs/Kconfig
> @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
>  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
>         int "EROFS LZMA default maximum decompression streams"
>         depends on EROFS_FS_ZIP_LZMA
> -       range 1 NR_CPUS
> +       range 1 NR_CPUS if SMP
> +       range 1 1 if !SMP
>         default 16
>         help
>           By default EROFS allocates one LZMA decompression stream per CP=
U.

Thank you, that seems to work (despite still seeing the warning on m68k,
as NR_CPUS does not exist).

Test runs on ARM (NR_CPUS depends on SMP, like most architectures), m68k
(no CONFIG_NR_CPUS), and x86 (NR_CPUS is always defined) before/after:

     $ make ARCH=3Darm allmodconfig
     $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D4

 SMP is OK.

     $ sed -i "/CONFIG_SMP=3Dy/d" .config
     $ yes "" | make ARCH=3Darm oldconfig
-
-No warning...
-
     $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
-    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D0
+    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D1

-... but automatic configuration is silently broken on UP.
+UP is OK with automatic configuration.

     $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config
     $ yes "" | make ARCH=3Darm oldconfig
-            EROFS LZMA default maximum decompression streams
(EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
-    [infinite loop]
+    $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
+    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D1

-Manual configuration is broken.
+UP is OK with manual configuration.

 --------------------------------------------------------------------------=
------

      $ make ARCH=3Dm68k allmodconfig
     fs/erofs/Kconfig:137:warning: range is invalid

 Warning...

     $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
-    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3DNR_CPUS
-
-... but this will actually build and work, as <linux/threads.h> has:
-
-    #ifndef CONFIG_NR_CPUS
-    /* FIXME: This should be fixed in the arch's Kconfig */
-    #define CONFIG_NR_CPUS  1
-    #endif
-
-    /* Places which use this should consider cpumask_var_t. */
-    #define NR_CPUS         CONFIG_NR_CPUS
+    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D1
+
+... but UP is OK with automatic configuration.

     $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config
     $ yes "" | make ARCH=3Dm68k oldconfig
-            EROFS LZMA default maximum decompression streams
(EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [NR_CPUS] (NEW)
-    [infinite loop]
+    fs/erofs/Kconfig:137:warning: range is invalid
+
+Warning...
+
+    $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
+    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D1

-Manual configuration is broken.
+... but UP is OK with manual configuration.

 --------------------------------------------------------------------------=
------

     $ make ARCH=3Dx86 allmodconfig
     $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D16

 SMP is OK.

     $ sed -i "/CONFIG_SMP=3Dy/d" .config
     $ yes "" | make ARCH=3Dx86 oldconfig
     $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D1

 UP is OK with automatic configuration.

     $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config
     $ yes "" | make ARCH=3Dx86 oldconfig
     $ grep CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS .config
     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3D1

 UP is OK with manual configuration.

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

