Return-Path: <linux-erofs+bounces-4021-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA9AC531F9
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 03:46:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8LxN31J6z2yRl;
	Tue, 28 Jul 2026 13:46:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785210408;
	cv=none; b=CJi+aM1llvqfdcaHmD9nctylSuOFc9eFQoK69wWc41RrHhrYU94FZV+b+OyJkZn9d2bRA2Kh2BxGgOhlxvg7OEuEb95/7oNiqEMKI5YspTMQ9iRj+KlNfaWW00i3R0LUy30XfCY4zHTAV9fxweLGgCf0SaEfI5+6NUFvb4ZLV09FtytHKKgaaezvLVgt4TleWCzgRIl3kGgJbl5YxVcbRUgEzN2XlXBzSs7YeKIUNB6pqHWutHQ4cNtpFVH3+vh+Aq9I8W+UgKV33KFBTpgSHkuEcgxe4OZee9TyjN+C7pI/Pqwg+JZ3g0p3ktoOJmFPvv0NVcV/V8yafpFe6g9Lvw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785210408; c=relaxed/relaxed;
	bh=7U3zlkmh8Pc/euVyLT92bNgOkXi7m38doJdTHNiz8Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1zDXv4h6VsY4RsbD41RjQlwHYoZlSo1urrk/GCd4ri06a32xcZ1wrjsxOLF4EQcafA6bGSXRMmr96J9yzi/L6OGufa3UbsUf6FLJ3VNqgKAkLS1icIjvg3kiAhGR8tctflJo6Bmf4aH++9Q5Xl3QveNX9emknU1l5V4rgSp6CZ9Hsnvg7TUzkKIkr4cP9koBOMUVFagSPfOFpDvrxfJLMg8LzMelJ1Okwo3xkox57sVtHSdZHs9SonQvemkrxVDMV9zDf4Gxs8BSXZrGwM3/BprEu2hL5QqMrKxGPfKQRVgN9ObKSCVTS2aHPurrMhANiOhF3LAN0P+ie7b5ASs/Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4+JufGQ; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=sj@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4+JufGQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=sj@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8LxL3vV0z2yN8
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 13:46:46 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8A1143CFF;
	Tue, 28 Jul 2026 03:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3220D1F000E9;
	Tue, 28 Jul 2026 03:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785210402;
	bh=7U3zlkmh8Pc/euVyLT92bNgOkXi7m38doJdTHNiz8Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4+JufGQAJvdqXwgt7253Ur/g1EsExQHm2yDYFqVoC3Un9WRKzJhvmOcFJSVp8K1A
	 cBEAMEXeWI77ixGCoV8x4IzFmUewDP/rKE0fIUi0G98hIwitAzMGI92czR4If6jxvn
	 oi2VEMAHjiJdV872qMrUh4SrqBLn0qOyxZ4cm2orqlPWFrYZdShX/yazWjRgEilLMd
	 O/6gZP9h1ttWRsvfR7wQkyNu9WHEN3CU563iusfA8cXIzK+fmcGLz9aB99F5fYD9qe
	 7v7OGJwGS288sbL2U/HhFBhRIGrPlQsEwWV/Uk6i1ccYPb2NvCLolUcz72ONfQ4yEx
	 KoqJwdeqTn7Ug==
From: SJ Park <sj@kernel.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: SJ Park <sj@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
Date: Mon, 27 Jul 2026 20:46:32 -0700
Message-ID: <20260728034633.104580-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6179ba55-d53d-4c46-8220-d7340f18e8b5@linux.alibaba.com>
References: 
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 21 Jul 2026 11:44:04 +0800 Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

> Hi Machael,
> 
> On 2026/7/17 11:43, Gao Xiang wrote:
> > 
> > 
> > On 2026/7/14 19:47, Michael Bommarito wrote:
> >> fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
> >> pool from num_possible_cpus() when the lzma_streams module parameter is
> >> unset, then z_erofs_load_lzma_config() preallocates one image-supplied
> >> dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
> >> systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
> >> decoder state until the erofs module is unloaded.
> >>
> >> Impact: an attacker-supplied EROFS image mounted by the system can pin up
> >> to 8 MiB times the LZMA stream count of kernel vmalloc memory.
> >>
> >> Bound the default stream count by a new
> >> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
> >> worst-case default preallocation is 128 MiB while preserving the existing
> >> per-image dictionary limit.  An explicit lzma_streams module parameter is
> >> still honoured as-is, so administrators who deliberately size the pool are
> >> not affected.
> >>
> >> Fixes: 622ceaddb764 ("erofs: lzma compression support")
> >> Cc: stable@vger.kernel.org
> >> Assisted-by: Claude:claude-opus-4-8
> >> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > 
> I submitted the following version to -next:
> 
>  From 4ec57610a769cd93027d12134c75160390b23b08 Mon Sep 17 00:00:00 2001
> From: Michael Bommarito <michael.bommarito@gmail.com>
> Date: Tue, 14 Jul 2026 07:47:29 -0400
> Subject: erofs: cap LZMA stream pool size
> 
> fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
> pool from num_possible_cpus() when the lzma_streams module parameter is
> unset, then z_erofs_load_lzma_config() preallocates one image-supplied
> dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
> systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
> decoder state until the erofs module is unloaded.
> 
> Impact: An EROFS image mounted by the system can pin up to 8 MiB of
> vmalloc memory per LZMA stream, either as intended or unexpectedly.
> 
> Bound the default stream count by a new
> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
> worst-case default preallocation is 128 MiB if the number of CPUs is no
> less than 16 while preserving the existing per-image dictionary limit.
> An explicit lzma_streams module parameter is still honoured as-is, so
> administrators who deliberately size the pool are not affected.
> 
> Fixes: 622ceaddb764 ("erofs: lzma compression support")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>   fs/erofs/Kconfig             | 14 ++++++++++++++
>   fs/erofs/decompressor_lzma.c |  3 ++-
>   2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> index 4789b1077d8ce..36f027c1c5ac5 100644
> --- a/fs/erofs/Kconfig
> +++ b/fs/erofs/Kconfig
> @@ -131,6 +131,20 @@ config EROFS_FS_ZIP_LZMA
>   
>   	  Say N if you want to disable LZMA compression support.
>   
> +config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> +	int "EROFS LZMA default maximum decompression streams"
> +	depends on EROFS_FS_ZIP_LZMA
> +	range 1 NR_CPUS

Hello, I just found this breaks CONFIG_NR_CPUS undefined builds.  For example,
my m68k build test [1] shows problems like below:

    $ build_m68k_w1.sh
    [...]
    fs/erofs/Kconfig:137:warning: range is invalid
    .config:13480:warning: symbol value 'NR_CPUS' invalid for EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS

I confirmed using 1024 as the upperlimit of the range, like the original patch,
fixes the problem.  I'm not sure if that's the right and preferred fix, though.
I'm just reporting my finding.

[1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_m68k_w1.sh


Thanks,
SJ

[...]

