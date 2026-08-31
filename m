Return-Path: <linux-erofs+bounces-4390-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D93C3C61DD3
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Aug 2026 12:40:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYT9R5Zc0z2xpn;
	Mon, 31 Aug 2026 22:40:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.221.180
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788180027;
	cv=none; b=Ki+fS1oyhqVGcbTN9NuxdSzHSM8nfLzHUCj1BkRo/D5uWJhPZCx3wmu8CFwo54EI7jhqXG6Rh+ckGbv5nS8/EfMvkEmLTGH0WrMVQOL7PyVdhkWDeOWfLX50W5T13ifBpSHW1OxDTrXDA+TAH/6jhjeFEPPkV5umhsJHRmiIaKlCJaVf+dLO45FVVtCEa2skhArhpdpMmJmeNCCodef//PCy5G6deF4lwMLDgdUJaVPeaeQio8gzmlh1N6H/Q2tQnvHPVmzKLhe3Epbc1XTfYk2A7wZU/aF4Zh0ii3uIq1Tw6yRTsRB/sOdMabupK7+Ji9mC/4ACPOO3p2QTha9f9w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788180027; c=relaxed/relaxed;
	bh=yDjQEmaO8nMillvg6lw6y5CLfKSX+705cRaL+2tb0Tk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WOtYzHivjhbFB1l2VX6nwHIP+910a3IGm1riOc5quY9x0ZL1NVtP1KbRWCZhjR49XNd1gFMjGas2vgnJ1r5T3VViJTtzEEL+d3bCmBh4td+4TQ6/S20/yfzkxWg6ypSvyNq//i+W8xpb0LxAyg1qR1bUKfCwq1BwujSW5M2RJNn9T6QzzjLi/qpCNIjlk3dl5NZLGhS5OtniyRao692ahDFkCYLdV0cSpSrA4yYohPnM5/G65kC1q84zokhLwCLYrA4j7mgI1XBbGFCP7W40oNTRrzPLxBIYBeYUeCPQRQfG4jdQhqFTxGubq2vYn1ExKsdcTloCaO/3C5A6KgbHmw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.221.180; helo=mail-vk1-f180.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.221.180; helo=mail-vk1-f180.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYT9Q0rgHz2xLf
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 22:40:25 +1000 (AEST)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c675e64ffcso3424493e0c.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 05:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788180022; x=1788784822;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yDjQEmaO8nMillvg6lw6y5CLfKSX+705cRaL+2tb0Tk=;
        b=ElplisRWfZ7l1PIstWVAkcoYl0aOU7vc6iE9FPzS8dzRU3yfIgORtLMXJttQcPUEdd
         0aoAM8sQurbpsFxeA5w1/1UHm+rX7GsWGUSn2YOWDdfBpYV4ZgAMb7CpeX830rrpVkAF
         Q6HF1U2kCu58zwypOL9TcaEJmQ6ybJL3dEd8YR6G1z+bRxScwlhKQW84ayj6ujMwyPP+
         937NvUMfd26V1sIaBZ9qspVW3D1Dz+Fu6t8KtggzRbQhhljDmYue0ZhL0LS5U60mZ9zu
         +JRmzQ5BvkfG06Iw55MsKdg2THupu1EI2dhb6whFTyZskRV6mhyQviW7lOJJi667EHMT
         iVUQ==
X-Forwarded-Encrypted: i=1; AHgh+RqaMhhhQF8ErKzCw10bc8RViJuVDaIwkledrsmwJK8Pn5kSbz20qLiXY8sznzujDSFz/+p5LW9SA5XSOQ==@lists.ozlabs.org
X-Gm-Message-State: AFuF++m3hCwkkVamHkLrNLMmCGSoZIq3Fy4UptkyPaQ4YHEPjBWjSuKy
	NAzoRQ7wXqS3pG22AZcStiQgUQQW+O+EsvmkSjYmHhrV5Sgk7luY56hQ9gn8CQGj
X-Gm-Gg: AR+sD12UF4XWx16pKUgya8lJNOnQ5Nk0aB8ow3N7VWXblnZYVbEIY28UkipwynO5KxO
	D9G3L+t13xAuycojaRA5k22QxETuU26ka4bqbxz47FsXIyx/k/3tjjreS/JW7MkLAnjimKM0ayi
	oj/NGjbaBLFDQQ5XgPU0fXVto4NbcvC22Pzm9nUNV2L7sGvrx/oDFPmV4RmB6txjkBQ8WEaDknY
	rjH4fKVOB/jU24HoSASRq5u9L4BMFcUBNiSopoedTWc7UfvPj7d7FxguH18wlIf6jBL002Pv1DY
	QOPL3/nSg7z2eyXdam4Hws7wI8rjctJzBa1r8eozEj5Q4pwAd6uQBp9ERLimkFnxfOsXSFd5RWG
	SpSaI6/SvkWpj0/np0EGUEb2DMWsXdJqUfRSzTZNTgseOmSpUklCP8Gv8pp9wdKiT0S+tC4gOos
	gwhzvxB9voHqiY5cFtwNI9N5XxUxkpM4xBFMkTdCu7fGArWIkHqpGAWiyWzHR6648BNd6RH0QjZ
	FUPx5Hgl6Zxaijrc7Jv/QJkKpTYhw==
X-Received: by 2002:a05:6102:9c5:b0:782:913b:c2ca with SMTP id ada2fe7eead31-789dc948eebmr1463933137.22.1788180022463;
        Mon, 31 Aug 2026 05:40:22 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97e84a55284sm7778488241.4.2026.08.31.05.40.20
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 05:40:21 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5c675e64ffcso3424470e0c.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 05:40:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrmwTUu8V6ELKIRoNGcOalS29UR4Ys2/3OaJGV7znn0ee7szJtVVrpizV+YeM4Qs6hnU9tFNd9R3xZRKw==@lists.ozlabs.org
X-Received: by 2002:a05:6102:2c85:b0:744:d517:b0b0 with SMTP id
 ada2fe7eead31-789dc7e86f7mr1577779137.10.1788180020647; Mon, 31 Aug 2026
 05:40:20 -0700 (PDT)
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
 <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com>
 <apGqg5a5I9g1CoF_@levanger> <CAMuHMdXwmCrzLZiPnQejJ+dTvVNf2zTzgKwTWEFEkfKRkZQpPQ@mail.gmail.com>
 <apHfhILRL0-lFOEh@levanger> <9de2f5e7-079b-472f-9d98-91d878dcefd3@gmail.com>
In-Reply-To: <9de2f5e7-079b-472f-9d98-91d878dcefd3@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 31 Aug 2026 14:40:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVbdO_aY+_CZ6KV23Y-XGfhb1+F8yLQVBY6Tw31PTKzvw@mail.gmail.com>
X-Gm-Features: AcwNN1VSJrr9aEDo0FVQh3lxnRuPny3ZCLnXQftv09uT0Kmgcq1-H6pLZpi5V5U
Message-ID: <CAMuHMdVbdO_aY+_CZ6KV23Y-XGfhb1+F8yLQVBY6Tw31PTKzvw@mail.gmail.com>
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
To: Julian Braha <julianbraha@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Michael Bommarito <michael.bommarito@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Julian,

On Sat, 29 Aug 2026 at 01:19, Julian Braha <julianbraha@gmail.com> wrote:
> On 8/28/26 20:20, Nicolas Schier wrote:
> > Cc: Julian
>
> Thanks for looping me in.
>
> So it's not great usage of the Kconfig language to have the 'range 1 1'
> and the 'default 16' here contradicting each other. But, it's currently
> legal.
>
> I would prefer to disallow this, but a proper check would actually
> require SAT solving (or similar) in the general case, so it's unlikely
> to become an error in the near future.
>
> Anyway, as long as we're continuing to allow it, savedefconfig should be
> considered bugged for not handling it accordingly.
>
> Let me see if I can send something out this weekend.

Thank you, my patch can be reverted again once your "PATCH] kconfig:
fix extra output from savedefconfig on out-of-range defaults"[1]
has been accepted upstream.

[1] https://lore.kernel.org/20260830221129.2668354-1-julianbraha@gmail.com

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

