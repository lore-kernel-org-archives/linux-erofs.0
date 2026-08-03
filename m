Return-Path: <linux-erofs+bounces-4082-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D3AC55184
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 08:09:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hD8Tf3BQNz2yhP;
	Mon, 03 Aug 2026 18:09:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.221.178
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785744566;
	cv=none; b=OG47dRhB8OxJcs7qQiV7lRJ60yi4wP7kdoJY2vrVDnHibLeixKeIbXu8eQ6OBf4wl1GvPaxcZKCXN+xwPxsA7tX3rKFxib7QJbNbzB5jCYpCGIkl2BFzLNY6/UtAgH/8E5NV2d27trTbD7aQVqKnn3LRoUfAz4QDzGDX4drBsIhvJPjFrgGjqEZjs067Dxt9lh8F/nbmeGrVQzqS58gm3ld4SuPZHM14F5v6M2KkWbubxqYZ4+f+BLMYDWz/OOe5rXOA9qLIsqoqTh5njPwOb57cyg6LShYnMr6SKHmDuUm3jLT7z13pLHL1VsC36v4M1sOi/7xxKIcR4fGgcledRw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785744566; c=relaxed/relaxed;
	bh=gt9Uv9rnheC+lhk+WKX3mjSr+Y1yldd4f4F/prMteYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=krre7lqYeS7CNPSW7eyNdvJqRgSrLsT58AY1jmZ+1BN4KTfcP+3N2WE6BwShRztGfCYz57rfMCk1MJBZyz8y9ZG3E5VDMnlHCPPgLi6RQZEN4KxYuhR05PcyK6oxpyhbOMEnk955hCdiEVoPhwLmKKFCRbD5KzGztf/eWQvx54tIWITPJQBpKV1r1se12FOOBywfjOXCnWbGF5n4dfrK4b0a1QwoCbwcqWNyBiOUMrmgHTiA0NcLa3Lwsx61RY3moNF5OsBuYaZNBV/XcqqWRjH43hW42oqe9zFRlB+6lDWblhd8FasjmvmtXTThcmW5RfMg1L6sRSrwpFrzOMwsrQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.221.178; helo=mail-vk1-f178.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.221.178; helo=mail-vk1-f178.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hD8Tc5Hk4z2yfH
	for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 18:09:24 +1000 (AEST)
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5c2dbaf828eso1116017e0c.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 01:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785744561; x=1786349361;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gt9Uv9rnheC+lhk+WKX3mjSr+Y1yldd4f4F/prMteYw=;
        b=as4DewuJZSutOzMqNurQjW99mPcRVzb+CNwhH4zcty+xtjpWb0l6xBfhGB48nfquBZ
         sqUtsZM1yOzSN564UYRD4WGOaPtH6bvDKChy77j8C0Dm8J+jOoVv6fqZxuKUTyEpdbuP
         ahb6fxxrMxYSSJpuHxEpjHgwqxCDyJm0Dmeyul91HOr976Z0+YZu+q7pE9pHUGHpQCXN
         xIgB+qEaUNtc/rbguT/hg5swJt4GPaTMiTW0j5qFh5ooZnO1M7iz4yoCPOSwYVXgJ5ZO
         AWTa2pRHD5+i767SM91Q4PtT0q6tERgDsluZWJfPKf/8Td5jgVMp3s4cdDzzfhZWNNOa
         AlyQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPbOwnhDU5RjWCqtCTJy/2FzYbA1N2/ehE5dxYuzk21txROG698WFLLZMdMKEvxDKuqBCs70EawCd69w==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yxi0qpkIRGYjnq8suX00csIYMd6oGwyiWGDnep4EjFoCjmt525m
	dGnRKaKJeVNnHBq66rObU3dWjd7JeGmPNcns7Fk8BT8tsU2+D2IUNLNScnuHiwD0
X-Gm-Gg: AR+sD13mcgRpTcJyhpmgXGbrFambfwI2/CCafcCFXsOYSP9dKgwEDiRjlUDyOrr6sHk
	tQ0QfzKt6v0AsmAZEkukNXHbXG9vbA483jQqmMPRxlDJ8GPb81L4IGWZu5LeCJc75zyq1mX5Gad
	6LQIA9MJPc+TPphvsuKybdzBvx+kjxGUViynK5zzUxhwZLfczb1hlR0B4q8zRDsyNJGSqDznd2X
	gLOqrRHsF3OZGVu1/0YT+Gk62V6Z/WzeUigfahmmlQxMF0kd3bOUoD03EBjHP5n1RZmDwa96J4c
	EdMee71YmebcgA8fQlTbrAlNUjRPhJGu1mJ3HALmvt8s/zifcQYKd3K8FfHw2H1NZEnHY1nshys
	/E7qYx5XxZax5giXPQRn2APfMnrlDvKEIsAihhch0T0DW/19Lqj3OARUGJWp35eU/aVc4zZ1Tub
	Oh/aiiE4d7iFsYjm3IdEE6LJ+5cDbhZov1HFwKQtDzlTaXldtdnAwF4ZV8zHvsbp6tU3jSEErX8
	D58VeXEy4eXCykzYXoFeAWnPg==
X-Received: by 2002:a05:6122:c8b:b0:5be:2177:70b3 with SMTP id 71dfb90a1353d-5c3877e0185mr2317416e0c.10.1785744560821;
        Mon, 03 Aug 2026 01:09:20 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c37eb6befasm8173000e0c.8.2026.08.03.01.09.19
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 01:09:19 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-745497ac8fcso1037524137.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 01:09:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpRI6isgyW0cHp8t6nHg8YVO1x2xW9mcD+sftj8gQoHfW7yP9Zr8+r9f5GZQ09Lw/5dFoKaE4dk2NNHTw==@lists.ozlabs.org
X-Received: by 2002:a05:6102:2908:b0:631:4cd8:b6aa with SMTP id
 ada2fe7eead31-75b2448670emr6347076137.13.1785744559459; Mon, 03 Aug 2026
 01:09:19 -0700 (PDT)
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
In-Reply-To: <20260728065447.91511-1-sj@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 3 Aug 2026 10:09:06 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
X-Gm-Features: AUfX_mz8E88NlF3yJaoWsAs-_X60XcGyI0leJ6VCoCD_dQDxMNf3uAZ6BaUJpTw
Message-ID: <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: SJ Park <sj@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, 
	Guenter Roeck <linux@roeck-us.net>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jul 2026 at 08:55, SJ Park <sj@kernel.org> wrote:
>
> On Tue, 28 Jul 2026 14:31:14 +0800 Gao Xiang <xiang@kernel.org> wrote:
>
> > Hi SJ,
> >
> > On Mon, Jul 27, 2026 at 08:46:32PM -0700, SJ Park wrote:
> > > Hello,
> > >
> > > On Tue, 21 Jul 2026 11:44:04 +0800 Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> > >
> > > > Hi Machael,
> > > >
> > > > On 2026/7/17 11:43, Gao Xiang wrote:
> > > > >
> > > > >
> > > > > On 2026/7/14 19:47, Michael Bommarito wrote:
> >
> > ...
> >
> > > > >
> > > > I submitted the following version to -next:
> > > >
> > > >  From 4ec57610a769cd93027d12134c75160390b23b08 Mon Sep 17 00:00:00 2001
> > > > From: Michael Bommarito <michael.bommarito@gmail.com>
> > > > Date: Tue, 14 Jul 2026 07:47:29 -0400
> > > > Subject: erofs: cap LZMA stream pool size
> > > >
> > > > fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
> > > > pool from num_possible_cpus() when the lzma_streams module parameter is
> > > > unset, then z_erofs_load_lzma_config() preallocates one image-supplied
> > > > dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
> > > > systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
> > > > decoder state until the erofs module is unloaded.
> > > >
> > > > Impact: An EROFS image mounted by the system can pin up to 8 MiB of
> > > > vmalloc memory per LZMA stream, either as intended or unexpectedly.
> > > >
> > > > Bound the default stream count by a new
> > > > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
> > > > worst-case default preallocation is 128 MiB if the number of CPUs is no
> > > > less than 16 while preserving the existing per-image dictionary limit.
> > > > An explicit lzma_streams module parameter is still honoured as-is, so
> > > > administrators who deliberately size the pool are not affected.
> > > >
> > > > Fixes: 622ceaddb764 ("erofs: lzma compression support")
> > > > Cc: stable@vger.kernel.org
> > > > Assisted-by: Claude:claude-opus-4-8
> > > > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > > > Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > > ---
> > > >   fs/erofs/Kconfig             | 14 ++++++++++++++
> > > >   fs/erofs/decompressor_lzma.c |  3 ++-
> > > >   2 files changed, 16 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> > > > index 4789b1077d8ce..36f027c1c5ac5 100644
> > > > --- a/fs/erofs/Kconfig
> > > > +++ b/fs/erofs/Kconfig
> > > > @@ -131,6 +131,20 @@ config EROFS_FS_ZIP_LZMA
> > > >
> > > >             Say N if you want to disable LZMA compression support.
> > > >
> > > > +config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > > > + int "EROFS LZMA default maximum decompression streams"
> > > > + depends on EROFS_FS_ZIP_LZMA
> > > > + range 1 NR_CPUS
> > >
> > > Hello, I just found this breaks CONFIG_NR_CPUS undefined builds.  For example,
> > > my m68k build test [1] shows problems like below:
> > >
> > >     $ build_m68k_w1.sh
> > >     [...]
> > >     fs/erofs/Kconfig:137:warning: range is invalid
> > >     .config:13480:warning: symbol value 'NR_CPUS' invalid for EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > >
> > > I confirmed using 1024 as the upperlimit of the range, like the original patch,
> > > fixes the problem.  I'm not sure if that's the right and preferred fix, though.
> > > I'm just reporting my finding.
> > >
> > > [1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_m68k_w1.sh
> >
> > Thanks for the report, but may I ask if it was a warning instead of
> > a configuration failure?
>
> Indeed it didn't directly fails.  Instead, it was trying to do config again,
> like below.
>
> [...]
> fs/erofs/Kconfig:137:warning: range is invalid
> .config:13479:warning: symbol value 'NR_CPUS' invalid for EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> *
> * Restart config...
> *
> *
> * Miscellaneous filesystems
> *
> Miscellaneous filesystems (MISC_FILESYSTEMS) [Y/n/?] y
>   ORANGEFS (Powered by PVFS) support (ORANGEFS_FS) [Y/n/m/?] y
>   ADFS file system support (ADFS_FS) [Y/n/m/?] y
>     ADFS write support (DANGEROUS) (ADFS_FS_RW) [Y/n/?] y
> [...]
>   UFS file system support (read only) (UFS_FS) [Y/n/m/?] y
>     UFS file system write support (DANGEROUS) (UFS_FS_WRITE) [Y/n/?] y
>     UFS debugging (UFS_DEBUG) [Y/n/?] y
>   EROFS filesystem support (EROFS_FS) [Y/n/m/?] y
>     EROFS debugging feature (EROFS_FS_DEBUG) [Y/n/?] y
>     EROFS extended attributes (EROFS_FS_XATTR) [Y/n/?] y
>       EROFS Access Control Lists (EROFS_FS_POSIX_ACL) [Y/n/?] y
>       EROFS Security Labels (EROFS_FS_SECURITY) [Y/n/?] y
>     File-backed EROFS filesystem support (EROFS_FS_BACKED_BY_FILE) [Y/n/?] y
>     EROFS Data Compression Support (EROFS_FS_ZIP) [Y/n/?] y
>       EROFS LZMA compressed data support (EROFS_FS_ZIP_LZMA) [Y/n/?] y
>         EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [NR_CPUS] (NEW)
>
> And, I find no way to go out of the prompt other than Ctrl-C.
>
> > (because I didn't see a report on -next also
> > I don't have a m68k testfarm).
>
> I don't have a m68k testfarm, either.  I'm doing crossbuild [1].  Hopefully you
> could also reproduce it.

I think you can reproduce some of the issues on most architectures
with a non-SMP kernel, cfr. my reply[1] to Uwe's proposed fix.
Unfortunately the Kconfig warning only shows up on architectures that
don't define NR_CPUS (because they do not support SMP) at all,
while ending up with zero streams is probably a runtime failure.

[1] https://lore.kernel.org/CAMuHMdVGKX=3cfOrLWp1uSHX76xf1-=C0+GVCXkA8JTqNPg-ew@mail.gmail.com

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

