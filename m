Return-Path: <linux-erofs+bounces-4207-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F3F0C5B572
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 13:35:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKqHY1PFBz30Wn;
	Wed, 12 Aug 2026 23:35:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.222.46
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786541721;
	cv=none; b=Yzw1HkT/TCynZ+1HFqBZn30hrHoHeIafHvO53GaNUeMTQMleoFkOPgm4Dp3dgpyEgWFOdfqgm58btB3cBKHHUv1San3ApAOYD9E4ADmh0G3FOPpjba8mqKw6oqfCxjPMD36xxWb5VOM9aDYr8wa0sZWDfRe+no1DpYW0+AdzMVE2Zc0h/K2dhoRK2/+iq84sIYZQWppJURYJQkiEDcIE9s53oGL5m41AKlhRW/GYRdjQXN+v3GhyhQpZ0zIq/3OZgwaPAMsaSUJS5vev+rAy+/D74L+0i5C2eE+ViOPrnjsb6ujDC+cyS/M3XIrM6t6S9hZRbfBHb6HO+C0Oq6lMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786541721; c=relaxed/relaxed;
	bh=IyxP0QYVVgqA7g4ge6KVP0vKp6VJ/Uz3SWdAsi+6PrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I0XJSeC/C2mDWTJjB8Ajj3hv5tNA1ozf1FXuWwLXVL75YaF0b4LxOZ06oDkLNjKV8u/sFYGD7FcCGU9dQDqcEjCEzNqrFxS5sq4L2t0W3yayTXibmsmqdEfYdlkcCPYFYmxqhdCEDyGFDp89zLCpUbHcql70VA/ylUD07Mo1CF4ogzPJjBhh4UTHMOyPfLEypZY19co3qCp0hUCoxBaRGcPPqJfsqIIn47eLIs8r3KVhFgGo/8Cw7dAonqHyMM2cN1CZy5g26d0vk2WzCins7j0sXR702BgkzVYu2dyEzOtn8upTpyRIBIRjU6pizpjS2iX4Ut6w/jgBIh6GQd/VAQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.222.46; helo=mail-ua1-f46.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.222.46; helo=mail-ua1-f46.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKqHW34s3z303K
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 23:35:18 +1000 (AEST)
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-97622cc1f40so490289241.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 06:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786541715; x=1787146515;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IyxP0QYVVgqA7g4ge6KVP0vKp6VJ/Uz3SWdAsi+6PrA=;
        b=GGV71MIxJXO3gly9NoCvPwg2G0BQKjfYtSXEd+u3TmovRIDK6xWcdyJZWy+yYOry8l
         2a8eczzemtoPheZveE/04IxkKZbTIsJqMX8qUla8wdklocyru8fZtMwJ+9Y0uL5WuBxe
         0S9JmGHKz5/UqXtDT7MphTMpoF7UTyhXLyfq95Ahp8DcyrcjoaLfSuiXASB2lDfvRzlJ
         pjvoRz3DTtyeYH55DJpvqhaGW9d6R41K4/9FCJ4t6vdXAy8SvlXLfOapS+9JGdJ5hV4W
         7q+GMuiohGADioXQfhWzHwV4nKBSYpPl86R3V6zAzbeWOQaNy2SuwwgYsHImWfo7U4tD
         Vpig==
X-Forwarded-Encrypted: i=1; AHgh+RoQ3gXPu/ktQ4rQqgiCNScDOqrKzSMAiFKe2c3EdvKSBLqclbMI1YqJ2KB33F2rEUR2nZ7ZrWgKg1+zbg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Ywmeo0GPLvYuUi+jHhEY9lHqzW0xGNLYK6kBoJXQusSs6ZMc98C
	rksnOJNeR6lTqxkfbn2BvUCq+HtLQPrtAZ7IaVc0K5hpGTGlK5b35/c6hNr4sxFk
X-Gm-Gg: AR+sD12ERd5CrjuoBvgrFpSxzBvrFIuf9kN6EpTCI69PjyUAmg+Q8TsogqtBjqznpUQ
	7V565Z9JN/hoG8PyRHLIqZB11YlJcu4y4Dlv14+TVWtaqgKLBh7+Ui9O9KZpwLmrMSWVJVHlIMo
	TAPIUFI271/RXUzz8TTjVshAYIDXbhlcgG4867Wkwe30RSVL3554GjBupDpzDh6vM0Krxhinrf4
	fjqqSmxYeafDlzWFZsWvl4LL52AgiK19nzuIwgyYLX5WH6xhsMBfirubYS78Vg5iqxzswjfKNo+
	A5Ki0cgSFBCyC8DkRYSN3Yf6XYOnZlIIlWQlMZiaKJuKfPPOewRShe0ZGWB97XMJ+AJMLxR9knO
	TDLCQSD6INrkauTPfhRYJE+iEa0VSpBL7YD5Z9ytkEWTvn6+vBAe0i91s8vNyEjNYFtgDgJgTzi
	vn6ezyR3xgkEDQAiKgWEC5AjMBqheSdZVEkcFBU021i2ziNyNwzZfNHSCOhRunGiao97HUCLlbo
	IJqnk/IucooW1rTGJ1GY84AGQ==
X-Received: by 2002:a05:6102:2b95:b0:738:bf0f:d0c6 with SMTP id ada2fe7eead31-76c840319b4mr1390285137.0.1786541715075;
        Wed, 12 Aug 2026 06:35:15 -0700 (PDT)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97a3c28e739sm1677909241.9.2026.08.12.06.35.13
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 06:35:13 -0700 (PDT)
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-97622cc1f40so490262241.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 06:35:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpGzvqntV5ug1S4CJkJxqUpJNcIZRn5jdzaHCdG0LgFkEx4we1fsrpO+hr77jQJvHy3Iw530W6cvbVswA==@lists.ozlabs.org
X-Received: by 2002:a05:6102:2c0f:b0:740:2d40:a234 with SMTP id
 ada2fe7eead31-76c89b72bdbmr1250152137.9.1786541712939; Wed, 12 Aug 2026
 06:35:12 -0700 (PDT)
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
Date: Wed, 12 Aug 2026 15:34:58 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVgjeRLGKwiWsFWfmh=1cStyh2PmLdw1xzyO=ighGRbTA@mail.gmail.com>
X-Gm-Features: AUfX_my3V02LuJtnDDDa6U-U4EEpxv38lzvIfsLqGK9gZ2j1h2ZQC8ap8VQl0Vs
Message-ID: <CAMuHMdVgjeRLGKwiWsFWfmh=1cStyh2PmLdw1xzyO=ighGRbTA@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, 
	LKML <linux-kernel@vger.kernel.org>, SJ Park <sj@kernel.org>, 
	Guenter Roeck <groeck7@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Gao,

Thanks for your patch!

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

This also fixes EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS silently becoming
zero (and thus breaking decompression completely?) for "automatic"
configs like "make allmodconfig" or "make olddefconfig" on architectures
where NR_CPUS depends on SMP (which is most of them).

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

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

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
>           By default EROFS allocates one LZMA decompression stream per CPU.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

