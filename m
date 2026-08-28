Return-Path: <linux-erofs+bounces-4364-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE868C61DBD
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Aug 2026 17:21:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hWlY05KC5z2y2T;
	Sat, 29 Aug 2026 03:21:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.221.169
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787937684;
	cv=none; b=EV2sO+78lHTBNobA6TxZFam1m4IU3RIhxyqfbO/5pbmMtchkGIBWrjFSWKXpzOtgQIyGsb9GiWv3ARYwZaaQvAyX2Nj8YhB87sss/fN/WBlbwaEUQnHvML8FCNYpJ6gBfNdkrDfYGTrc5cLaRWLHbzUx1pR0VTj69RtMb0iLI4aF2nEw4RdeClKBrI4vuZVWnK148SPGCdSJoI6sVegcEgu09zfi2po0fYDc5NNppLGQmqgVtRrGKP1srJvtbb9/AoglYqfoJjuUAmbcRLrzKZmpNumqm3K6DCvBV5EEWpU1SMMKwd0WTq93LyJcA1HzClM9vOJaqmWpuXPD3TCKig==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787937684; c=relaxed/relaxed;
	bh=evpTKVZReIwvDgHYHGAoajVc7f3qpbEUisvP+F0+k+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nt99o7/vnFbB+lWn/2Ty5yyfw3OPwqBJoj96WS8C7wqFdr0X4tURzwgQ/NEXszRsKgQeTyZyWG9Mn6lQ7/dl5IwXlbP/2GDnH8M9EAOlnnAbIgbHvmY3hxl10gwZ+1zkY5eKNvvXKHsQECv1JmpZD2cJ2wGR1AaztzHEPXep3+ss+DMZoQoaF3dqUgYD4aNBZV2ujS+XvbMb+wF2B+L9Mfn9wCGnG5evVM7yl3L18v/LgxmJwPF9d9zL6BvdDm7aXOwTlFLPMUqgDqHRKLIm6okRjU/yXkjZ8gV/M9EtlDWSA5PrY9w4mr8VVOcAjpEL17YNpInBlxPYSt+knQMJKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.221.169; helo=mail-vk1-f169.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.221.169; helo=mail-vk1-f169.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hWlXz0T5kz2xlw
	for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 03:21:22 +1000 (AEST)
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c652293bcdso1205198e0c.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 10:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787937679; x=1788542479;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=evpTKVZReIwvDgHYHGAoajVc7f3qpbEUisvP+F0+k+M=;
        b=Htxoh4mTeSF7Fbh0frfytANfl6DxwjsalYDtNS16AV8eKp4iqniy1aphxfupQ2iUfH
         pHIfBSHwRFEr+Xys6SkVrE2qlJ9oLfnZsYBmz/v4ZTEQ+kN7Zhd4S3QDXopxztCznbxb
         GDI5aPh/IJ4rs34DgA6e1/H8pQBVQM16V+nwUz+zHrN/w21QkiMnGOp/fZaP7Mm36KIp
         MCxzd1p463nNy82zItIcF0rQsPzal8WWMGvC9vdSCzIjQI16Tvt5euVwk8LrwwKauvDu
         hv4xgLiR+jEWpcEPVNhvuRm+F7WpVPoWL2C3dlMW4M1Y4eMHuZbgNqgDj4D1yWyfmRJI
         YYjA==
X-Forwarded-Encrypted: i=1; AHgh+Rrn79Pz6LI+w/pZ+w91CBW07+JsaiL2XbVaIHQZgW0xchmWjcY2I8aQtjVlmxcdFOCyMP797y3GqcmDQg==@lists.ozlabs.org
X-Gm-Message-State: AFuF++mmk4c+qi1LXZ0NSkSOmovDPEVj8RjNU5F9ld1Ro1A8Ebx6z1xe
	myBb07wLDV+6hM7oXx6MVTWM8rIvHyypcDbx2tk+W4v/OIPEY8H7GRpaP76D7IJa
X-Gm-Gg: AR+sD12yOryhxogoZAR/Z0tbFzkeQaGCenNS7wsX/vmWAJ8PtzL8Fgkk+mhcxrsUtZU
	taaKnZIBOkhg5TDMVc3rrLcoQ5bb0P9IQdQyYldNhyJ7M8+PaEBE53U2NnVTaNAJvJCcMLKBDrz
	B61kMeAVMZBQuKLkn0RSBFfpDdaq7jjrHiuINQCUxKuMkVLTFpbhxGnPNhFs1km3Ged3lMRa5eT
	SLvv6pWPetRhJQKWpcktrPFwsRD6gKv7Dpx+8r770/RF4QaL697G4XSlqngj8BOLOq1z+Lvzegd
	mXxSlV2HaMchxDNzs0H0xZwQI3nYrebCX2SiKa5XzgFPcehNHrfVIowIslaq3TQCQk+88QrtQMS
	2ul6wa9tQqYrifMTS6wi6PKDuRb3uvOeoBbytSfC/9ntYbA6yextVQ3xfzfZvJd++eVgrY++lqv
	Ds14rgPQ1q9TZcN/rQyAlEVS4ktDt/dbAiSWChikzZIVBbUPLS0ywwDoNRndyPXFypfUzyuL9E/
	9aogL/nwG+XhMs+UyewSL0iMA==
X-Received: by 2002:a05:6122:4b19:b0:5c6:58e0:b2e0 with SMTP id 71dfb90a1353d-5c6814ba009mr4425541e0c.7.1787937678986;
        Fri, 28 Aug 2026 10:21:18 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c7241da340sm1822019e0c.9.2026.08.28.10.21.18
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 10:21:18 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7542a2ee156so881587137.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 10:21:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp79UoJF9QHvDDSU7FInMbCtTymUr2P67Klhred9g8pJV3zePW4G6jqA+SS5QnVlVGEu/EweFmZinJmIw==@lists.ozlabs.org
X-Received: by 2002:a05:6102:54ab:b0:778:5bbb:b2d2 with SMTP id
 ada2fe7eead31-78599269b6amr3135505137.11.1787937678652; Fri, 28 Aug 2026
 10:21:18 -0700 (PDT)
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
 <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com> <apGqg5a5I9g1CoF_@levanger>
In-Reply-To: <apGqg5a5I9g1CoF_@levanger>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 28 Aug 2026 19:21:07 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXwmCrzLZiPnQejJ+dTvVNf2zTzgKwTWEFEkfKRkZQpPQ@mail.gmail.com>
X-Gm-Features: AcwNN1XXn2qAoRTtHkxt_2I4cw2b47n5hgFTcYzlKhY5Mo5gPaW3qE-98baSbzY
Message-ID: <CAMuHMdXwmCrzLZiPnQejJ+dTvVNf2zTzgKwTWEFEkfKRkZQpPQ@mail.gmail.com>
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
To: Nicolas Schier <nsc@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Michael Bommarito <michael.bommarito@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Nicolas,

On Fri, 28 Aug 2026 at 17:47, Nicolas Schier <nsc@kernel.org> wrote:
> On Thu, Aug 20, 2026 at 12:15:33PM +0200, Geert Uytterhoeven wrote:
> > On Thu, 20 Aug 2026 at 12:01, Geert Uytterhoeven
> > <geert+renesas@glider.be> wrote:
> > > When NR_CPUS is less than 16, or when SMP is disabled, the default value
> > > of 16 is invalid.
> > >
> > > While actual configuration picks up a sensible and valid default
> > > (NR_CPUS or 1), "make savedefconfig" will still write a line like
> > >
> > >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> > >
> > > to the defconfig file, even if that matches the sensible default.
> >
> > Is this a bug in kconfig?
>
> I am not able to reproduce that; this is what I see with ARCH=arm64
> (arm64 always has SMP=y):

[...]

> Thus, to me it looks as expected.  Do you still see the behaviour you
> described above?

Perhaps you cannot reproduce this because this fix is already
upstream as commit ab74edaeb1ae7c71 ("erofs: Fix
EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic")?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

