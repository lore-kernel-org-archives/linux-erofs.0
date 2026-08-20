Return-Path: <linux-erofs+bounces-4261-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0583C5DF82
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 10:15:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQfTg0rMQz2xT6;
	Thu, 20 Aug 2026 20:15:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.222.52
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787220951;
	cv=none; b=fpI3R672wLge8mmZdcJMKsTTAHoChoxP2VD8XJe6LV7M2oGHtUJbJPXwMjycVDHlhj3HQ7+YSwOLHt15Dnp206JnTYsJL0LNfZEDIPeLKF0C3B/XsgpWvA6NxpSCIoiZA/yxgfQIAGhjeKXqom1Rm7OM+6TzxR1kSee7IqnltoqZFhlYyMVqsYe7cxMwM9VQD8Bx6pTLM75NNdBHXOV08N8+buUcHOKABhlm/YgqoBMsWZf9opZRLqsmqXLj3ScWyaFtPjZvn06hP8X0K1Un/dUuIC8hcrkIJa6A9y0QyJI1Pv1gWuXKHe5kqfSnQ7UPCKzBiwl2/4rFLP08wUv0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787220951; c=relaxed/relaxed;
	bh=y+o9iLBsNyZevlXTHABv43DjobImxTsPK2gLQOnstcQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2GcsqY0rTc3ht1eHvqcer+UsL9RSyO++WIo6AGzg/+QWGZ6kjVWUJDKF6GO8j4L0mqeAPXdn5mmmxjqjH+G5yT84ljF9Vok1fs8r7b0L1X9c5C/m+uBQOMKLDHE5BbFeHrKVegRuQbK63mwapPVRqv6efJmZ2fJE9XGo0DjUA0yZ4VrW9A0RLI1HNanuLIlNwbCd8fWalqSEB0bB18xqvMWddgti4CF2LmVng2OpshtNVYYOsC+ulWG7yOqG0SDMZoo3VaRQKMtzMfn0cdvGqToEdWVVUPycjTcto9mlcphWq7KIdu/nFG6y0PtGikh9vawTeQ+dv+v/ewwH4VE8g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.222.52; helo=mail-ua1-f52.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.222.52; helo=mail-ua1-f52.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQfTd6Wdrz2xRx
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 20:15:48 +1000 (AEST)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-97c637bf788so217834241.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 03:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787220945; x=1787825745;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=y+o9iLBsNyZevlXTHABv43DjobImxTsPK2gLQOnstcQ=;
        b=anvgnfB4QBYS0Y67WIJkGQ3gWP2OVG9Lur2vPMGS5T8iFgxQug+v4WQepcl60j1ELa
         ldDkiCZzw0A+ZOupWjoIAm5/+JowTVlLpDctJnLJFavDNQikm3SNbxHBFC7oFenv3zOl
         hNA01iaddjpjP/jc1uHkLC0z6TUwflEjCkkUMdOrD+7HiIiaH5F3gFjaHAYcw7CdGH7+
         0a5boCjKO9Q0QmePK8p9Y9XKKlA2Ps968W04qFQuTOBv+p/ie4m4U2IHM4oJn4eYVQ0q
         uOVUUQJRvY0zOwfATQ6qS3vSkH4TmnxWEIlD8efF9JMW+vLul6BthNTdWTxQBS4Y1IjE
         eTvw==
X-Forwarded-Encrypted: i=1; AHgh+Rq77IA03yf/UcvWcVRCkOCYA/NoQbBDxtjt8UM84DkYm4MWqHFISHbIoQNdk2wExxaGBVM0b4xVhIfJwA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxFSNuEqWArApHk/1qA3PeLsLNHUoMRCDvmxSVdfRRw2gaM+zoC
	wHaPIGix+GB0sCCXbBcMr6F5uUMWXRe8oWuoV+ZDeD2CYX227un/HWJEQJpa2WOG
X-Gm-Gg: AR+sD122E7uf/jWZG9L8RykSKmMjwIFx2KMUWbZgTih1skHP69hEZkMagD4zDfxTE9i
	h0ki92NF/259qVVfso78aEgIQd08cZTprsfbtVbiL1zh+jI70XAH/4kk3PJczXtuSQThzFqX3gB
	jqKC+T4xftynDJASKheWYYAq9VDmpmJ3xk3Xu1WJhbEQNVVFpvCPK82qgHY2iUHNj+RiDT44Gsf
	0zLvyMYNUhy7aWmGS9/nMDCtQjW6i75jFcgouJSEPJkRgCPmrLk5cql6k5GKeJ9rUfeV929tns8
	6ARQ0IDB/7bDsCqCyJZlfzhPmXukUor24L2szZ2CmTMb28wCB9Tr+w0j4XIqcgA4wQyoO2E3ZlU
	ryp0grE6nQhCvNJCfWBe87q6sEvMBjKpoB9hr4nR9nskZ8i8p2AJVsuZSHgaW+a7jWhlFqc66FH
	EP3RE/0xKEtvbmaVsCVvfB/rf6DQRS/ajDPB5pYENMZE0KxTDkG/SbTiug0R5f73baD7XL7d1lN
	4l0OjHa4Ndxbf01qKEwwzw7JQ==
X-Received: by 2002:a05:6102:4424:b0:74c:7fd8:73f5 with SMTP id ada2fe7eead31-777f927738bmr4089271137.6.1787220945523;
        Thu, 20 Aug 2026 03:15:45 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97c4e75fd76sm5239099241.2.2026.08.20.03.15.44
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 03:15:44 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-74a9ac9cda6so1187823137.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 03:15:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrycORnjbC+1nAWlQuMpEkUn6ov2F3qNXZh6Ppe5hKcvtjNnm1Th1lLgAu/Y92yP6/UJlLbtFkl1vfqNg==@lists.ozlabs.org
X-Received: by 2002:a05:6102:2b9c:b0:779:2dc9:1f40 with SMTP id
 ada2fe7eead31-7792dc9231dmr1821162137.3.1787220944749; Thu, 20 Aug 2026
 03:15:44 -0700 (PDT)
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
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
In-Reply-To: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 20 Aug 2026 12:15:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com>
X-Gm-Features: AcwNN1UWhRa382Q8SMeXb2Oyrd1gOh-npcOHUcLlPC7nVo2RmYwaP-iNW8vv0Bw
Message-ID: <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com>
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
To: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Michael Bommarito <michael.bommarito@gmail.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

CC kbuild

On Thu, 20 Aug 2026 at 12:01, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> When NR_CPUS is less than 16, or when SMP is disabled, the default value
> of 16 is invalid.
>
> While actual configuration picks up a sensible and valid default
> (NR_CPUS or 1), "make savedefconfig" will still write a line like
>
>     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
>
> to the defconfig file, even if that matches the sensible default.

Is this a bug in kconfig?

> Avoid needlessly enlarging the defconfig files, and reduce churn for
> updating them, by specifying valid defaults depending on SMP and
> NR_CPUS.
>
> While at it, make the prompt depend on SMP, as there is no point in
> asking the user about the maximum number of decompression streams if
> there is only one valid answer.
>
> Fixes: c9b47e6b23114e93 ("erofs: cap LZMA stream pool size")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  fs/erofs/Kconfig | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> index 2dfc313588d283a0..37495e95a78d9bf6 100644
> --- a/fs/erofs/Kconfig
> +++ b/fs/erofs/Kconfig
> @@ -132,11 +132,13 @@ config EROFS_FS_ZIP_LZMA
>           Say N if you want to disable LZMA compression support.
>
>  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> -       int "EROFS LZMA default maximum decompression streams"
> +       int "EROFS LZMA default maximum decompression streams" if SMP
>         depends on EROFS_FS_ZIP_LZMA
>         range 1 NR_CPUS if SMP
>         range 1 1 if !SMP
> -       default 16
> +       default 16 if SMP && NR_CPUS >= 16
> +       default NR_CPUS if SMP
> +       default 1
>         help
>           By default EROFS allocates one LZMA decompression stream per CPU.
>           Each stream can hold a dictionary of up to 8 MiB taken from the
> @@ -144,7 +146,7 @@ config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
>           of memory.  This caps the default; the lzma_streams module parameter
>           still overrides it.
>
> -         If unsure, keep the default of 16.
> +         If unsure, keep the suggested default (16 or lower).
>
>  config EROFS_FS_ZIP_DEFLATE
>         bool "EROFS DEFLATE compressed data support"

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

