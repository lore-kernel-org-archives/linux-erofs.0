Return-Path: <linux-erofs+bounces-4237-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92635C5CFC1
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 07:33:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNl1K1Z8sz2y1Y;
	Mon, 17 Aug 2026 17:33:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.217.51
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786951989;
	cv=none; b=Ko2kevZP0Y7crc5mTCKr94JyyeGYz++9JBt9KwpLxnS3h5zEXl+xUdDb0OIu31W9sqfyrEZtT6F3IX2rM5CWyr5j3eZif+adTiKd2NTcTs1FMqt/Sl6/3j0+ZFgdwBY9Wk14m99QbPVyNIRH4QFCeW7fvOLLS3ry9x3D969muUnT4hBewM838B9Y9BA76c2hlG1RHUWRkzYrOt/DDkeW1fkUgdfu1F9PDi+oxI2t4HrcQZAtL8hG1Z+Lwct1Pq4XjsZjf8NAc4D3qcFf52gv80JVcMMIQmyu6RhWKWdi691ajNMK7VDBeWl6eYLM3NWiZ2k+VJHpc5dShYnhjhNVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786951989; c=relaxed/relaxed;
	bh=rGPGcAD5cDNWRFdInMMGFvPYcVoEknpx1I7XI1khVZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jk6LdrqJcpMQFujYYIDxUXxoItHsmNewoWGxXU0kfrkMlm4h/z3+iaAFjsGP9uaZDE5rjW5wTMxhFSjPIOD9tYXiVs/oi8msrD3uHYEIGBgM8DZtws4lX8uqefWqtZ/f9YaXbDVHqneBI6KmG0+gK7np9vHCOXzae52MUesR24AdsMUrL710hb8rwapUvHn7ARbCEV2frI4pd15aOsEaf/PgXvPWucvuwpkL+/GEKbAc2q52Fe3IGcoojjHHJ+O66s9ARtgN6SEpUVHqSSduNAriUjhUmmNqSNIJTnPMFgb7ymQVzSyTbOZbKkudjKNpc3sS55RYUiPD6sXy/OlnwA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.217.51; helo=mail-vs1-f51.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.217.51; helo=mail-vs1-f51.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNl1H3pWzz2xy6
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 17:33:06 +1000 (AEST)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-74a9ac9cda6so1610459137.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 00:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786951984; x=1787556784;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rGPGcAD5cDNWRFdInMMGFvPYcVoEknpx1I7XI1khVZU=;
        b=HDbG94KOPF0DLI1PIbzK9NQ2Ls4mNDNwHLEDyvQkckbupGBkZI0iCG1DFxCQyfuZS/
         GONTZG6wLGU8SiUEsxigBI5MwdWkSb+V0dmMwHOH2Hst4ZRflLLUU6XMOt/KIq3liL+w
         +3P3PPylHIX3bJWpCPLOpsNBiSz7k6iVN/yy6FRAWmp91IpYjQsV9fqg/C4vdM7mwZJ1
         EnubqXqbOACjc4Ro3XeCdaNR3/ItshIQffWk1SaaviQeb8dk+3rHh8yN/Iqy5UMiPQzJ
         m8Lw6brgrCbBzVzXkt7x4msPyL4FWz+aAJ4km5EOcg9ajvkOGSkuQKHbGh8Bbh8u+THJ
         wl8A==
X-Forwarded-Encrypted: i=1; AHgh+RqiBycZiuRrkpEMyPxO90l6d75nx+14Sxn18ixOGyke9Z4v+be3nCuK5x9ULrmmPucYKTs71577mzBPnw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzYZFQ6LXAEOUmBwmY6rK9xhOWN6PruxFiMA+VD6PbtERYkhOf2
	SQnkm7A/XQZNcvlxRNVapp7e5TvBGxFxkTLepkdVaJM6aicI4ik74d7QBHFuizUy
X-Gm-Gg: AR+sD1092+jKdtykdaq4zcLqFxx1+gLbcIZ8pVhrE8UuUcXKNR/b3pZwfq81g4mn386
	IzjNqLtylWS1NdOucqQDWXOE4WHM0QZBW/9jPqB95g8pnNtOOUs3E9DsxvA5dzY1iaWKOGDkriK
	i4oz5W9rtoV7uShiuNs5WNLWa/MrG0ZOslN5lsXRNY/jHtQjXz+yOzmaNlIsmLeRUmTSstQqqqw
	YtILajqpMJd9029ia2246AKXzW6I+dmcom1OgR5s7OA65T5cyH5CWatvYQTYpkt+nhTheuauyyK
	y4Hf9WVablspYJJi7EDieBg5jLRPKruH+v8kROTQY8lqgd28JTKpzvDuoSxuWOwo0owbw0DizEP
	bicvSNhBSePITpeclIsn9dIMDLYTWM4ll4CoebJCU93g9wtzSYqMo++Z9p0bd6AOELt+Xw/3pTK
	SzONMo8Awqh22vXATzdwHizWu44OMvPLsgiuXMrNoQXHoElQdJggHoFDHUGCC0GFMGQcgDSn1LM
	UqpMBX0Z/5Y50bN6KlDzxYHSQ==
X-Received: by 2002:a05:6102:194e:b0:772:5acc:b849 with SMTP id ada2fe7eead31-7725accbb4emr1149393137.5.1786951983313;
        Mon, 17 Aug 2026 00:33:03 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-773c508c0c9sm349180137.9.2026.08.17.00.33.02
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 00:33:03 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-977fca41f52so1378112241.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 00:33:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RotgDQV1g4iTHuCAqVt1WRiMntFeGQg2UQTTngwFv88qcNYpX927F/Xau1Q1CMBxbvp4ItzoKyboraYdQ==@lists.ozlabs.org
X-Received: by 2002:a05:6102:3f8c:b0:738:3525:43ff with SMTP id
 ada2fe7eead31-76f2cd658e8mr4679016137.13.1786951982523; Mon, 17 Aug 2026
 00:33:02 -0700 (PDT)
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
 <20260812131144.30802-1-xiang@kernel.org>
In-Reply-To: <20260812131144.30802-1-xiang@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 17 Aug 2026 09:32:51 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWQO2Lkv4O8=nv6WVtsL1FEk-04RAv=VSZGkro7n0th2g@mail.gmail.com>
X-Gm-Features: AcwNN1VGKeE4u7XXdwDZijtpmIzes2PkzoxQDMSXyTSjU28nfocs7gpDT4KvUTk
Message-ID: <CAMuHMdWQO2Lkv4O8=nv6WVtsL1FEk-04RAv=VSZGkro7n0th2g@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, 
	LKML <linux-kernel@vger.kernel.org>, SJ Park <sj@kernel.org>, 
	Guenter Roeck <groeck7@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

On Wed, 12 Aug 2026 at 15:12, Gao Xiang <xiang@kernel.org> wrote:
> CONFIG_NR_CPUS doesn't define on some UP platforms (e.g. arm), so this
> can cause make oldconfig to loop indefinitely when CONFIG_SMP=n:
>
>  $ make ARCH=arm allmodconfig
>  $ sed -i "/CONFIG_SMP=y/d" .config
>  $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config
>
> EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
> EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
> ...
>
> Let's guard NR_CPUS with SMP instead of using a hardcoded arbitrary CPU
> uplimit here, similar to commit a3344078101c ("mm: make SPLIT_PTE_PTLOCKS
> depend on SMP").
>
> The initial report from SJ Park was for m68k [1] (m68k is the only arch
> without NR_CPUS in Kconfig), and it will be changed in another patch [2].
>
> [1] https://lore.kernel.org/all/anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local/T/#u
> [2] https://lore.kernel.org/r/20260731094950.1988084-2-ukleinek@kernel.org
>
> Reported-by: SJ Park <sj@kernel.org>
> Closes: https://lore.kernel.org/r/20260728065447.91511-1-sj@kernel.org
> Reported-by: Guenter Roeck <groeck7@gmail.com>
> Closes: https://lore.kernel.org/r/87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net
> Fixes: c9b47e6b2311 ("erofs: cap LZMA stream pool size")
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Gao Xiang <xiang@kernel.org>

Thanks for your patch, which is now commit a64d500b0078e16e ("erofs: fix
EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms") in v7.2.

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

I have just discovered another oddity: when you have less than 16
CPUS (including SMP=n), this default value is invalid, and "make
savedefconfig" will always write a line like

    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1

to the defconfig file, even if that is the default suggested value.

Needlessly polluting the defconfig files could be fixed using:

    -       default 16
    +       default 16 if SMP && NR_CPUS >= 16
    +       default NR_CPUS if SMP
    +       default 1 if !SMP

Thoughts?

>         help
>           By default EROFS allocates one LZMA decompression stream per CPU.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

