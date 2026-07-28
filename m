Return-Path: <linux-erofs+bounces-4022-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79715C53219
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 06:31:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8QbP2cXkz2yRl;
	Tue, 28 Jul 2026 16:31:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785220289;
	cv=none; b=LEcKnp+KJDtsmG8kKRJVjvG/LXvN9yCnlUA3zMPnbRCjEh0I+xR8iwyaoeXizeghHPrVL8dmr69cfI9lYBSmPCaLHCwGphhOIHR0AQ/tL9qqG8+1MWej23+Am5xjST5+S2bk+CmULwDaourDrMO0B1RQmRQZan43ATJkTdOxC0Xqr/tyahkWuoPcVUVPUM+7kNa3//lJavXhSte5T1ax006WI2EOVyW7115oUxR8xG/hxeuK/RxR/tfy6WaNjt1m0pD4QMpylXI1Ax13ha6aiD0G2zwkslJ4wNItW4VZMepYFgEAWGXSuiBcYjtiMJExDKYJIw/jDrBir+C/PUyBnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785220289; c=relaxed/relaxed;
	bh=j6ELY7ou+trKOYWVhFK1H16b8cZPO3C3TP/IPVrvSVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiuPtTEv+pokF0GUVo9Csif48PbZpTMqbF1gO8bEnzP9Nanr9esRCbAASIhaCljGbPncQK8f23IGBttndgNsVgMW4MDnbmL6tfIgn6Mxo9YOkQh1m9ITqB2u2LwhqVDFs98DeQ2OJnjJCymllAMnY+61WroSBhQD0l1S+XCCTAdRFglaWtSVjBdXdkEAREZLba5mu0ARoTqkj3qmXC0NS6i+oC6dfCMnzMebcQt54FQ8JnPDV3TuZ/TANtkpGXl6wWtGkDLVTZY9TyM2kt83vNHxwro7H1Y/FIYGpZO4N0yfDIvsZkCeeqi4VuSrA8SjijPQXDAV+zMii3ZjMo8QSA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Skb0H6xp; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Skb0H6xp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8QbN2nmmz2xLq
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 16:31:28 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8890143931;
	Tue, 28 Jul 2026 06:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87941F00A3A;
	Tue, 28 Jul 2026 06:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785220285;
	bh=j6ELY7ou+trKOYWVhFK1H16b8cZPO3C3TP/IPVrvSVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Skb0H6xpZEdw3HV4Wz2XPLV1sfOxh6O5WDg6K0e8OAcEwXSlHrVNPhmyRJ9PaUdhn
	 5DlKjkAzUm+0CSwrY2+Dz68yY7Wd98ZOOmW60z2KI/U292J267ZoOlpMcoLS99qw8N
	 iICycvmyK+/oOYa4I1kLYwITVxYcpn91cb4EX+4+aiuETHvtXdRoz6X1mDvci0iJdw
	 vGrPtXoIn8nOshUu0TTT+dOchVHej97kphynsDzCEFdaqA1rj3r2huNtUaqDRCmmXv
	 3JnGfFzwdHtjXppl8I5pvsu/P0PAgVohdLYTSKOMSdp8dbXyfJikouh59ey3CQfGwu
	 Luwmq7r6hCBJQ==
Date: Tue, 28 Jul 2026 14:31:14 +0800
From: Gao Xiang <xiang@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
	David Hildenbrand <david@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
Message-ID: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local>
Mail-Followup-To: SJ Park <sj@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
	David Hildenbrand <david@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <6179ba55-d53d-4c46-8220-d7340f18e8b5@linux.alibaba.com>
 <20260728034633.104580-1-sj@kernel.org>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728034633.104580-1-sj@kernel.org>

Hi SJ,

On Mon, Jul 27, 2026 at 08:46:32PM -0700, SJ Park wrote:
> Hello,
> 
> On Tue, 21 Jul 2026 11:44:04 +0800 Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> 
> > Hi Machael,
> > 
> > On 2026/7/17 11:43, Gao Xiang wrote:
> > > 
> > > 
> > > On 2026/7/14 19:47, Michael Bommarito wrote:

...

> > > 
> > I submitted the following version to -next:
> > 
> >  From 4ec57610a769cd93027d12134c75160390b23b08 Mon Sep 17 00:00:00 2001
> > From: Michael Bommarito <michael.bommarito@gmail.com>
> > Date: Tue, 14 Jul 2026 07:47:29 -0400
> > Subject: erofs: cap LZMA stream pool size
> > 
> > fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
> > pool from num_possible_cpus() when the lzma_streams module parameter is
> > unset, then z_erofs_load_lzma_config() preallocates one image-supplied
> > dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
> > systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
> > decoder state until the erofs module is unloaded.
> > 
> > Impact: An EROFS image mounted by the system can pin up to 8 MiB of
> > vmalloc memory per LZMA stream, either as intended or unexpectedly.
> > 
> > Bound the default stream count by a new
> > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
> > worst-case default preallocation is 128 MiB if the number of CPUs is no
> > less than 16 while preserving the existing per-image dictionary limit.
> > An explicit lzma_streams module parameter is still honoured as-is, so
> > administrators who deliberately size the pool are not affected.
> > 
> > Fixes: 622ceaddb764 ("erofs: lzma compression support")
> > Cc: stable@vger.kernel.org
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > ---
> >   fs/erofs/Kconfig             | 14 ++++++++++++++
> >   fs/erofs/decompressor_lzma.c |  3 ++-
> >   2 files changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> > index 4789b1077d8ce..36f027c1c5ac5 100644
> > --- a/fs/erofs/Kconfig
> > +++ b/fs/erofs/Kconfig
> > @@ -131,6 +131,20 @@ config EROFS_FS_ZIP_LZMA
> >   
> >   	  Say N if you want to disable LZMA compression support.
> >   
> > +config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > +	int "EROFS LZMA default maximum decompression streams"
> > +	depends on EROFS_FS_ZIP_LZMA
> > +	range 1 NR_CPUS
> 
> Hello, I just found this breaks CONFIG_NR_CPUS undefined builds.  For example,
> my m68k build test [1] shows problems like below:
> 
>     $ build_m68k_w1.sh
>     [...]
>     fs/erofs/Kconfig:137:warning: range is invalid
>     .config:13480:warning: symbol value 'NR_CPUS' invalid for EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> 
> I confirmed using 1024 as the upperlimit of the range, like the original patch,
> fixes the problem.  I'm not sure if that's the right and preferred fix, though.
> I'm just reporting my finding.
> 
> [1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_m68k_w1.sh

Thanks for the report, but may I ask if it was a warning instead of
a configuration failure? (because I didn't see a report on -next also
I don't have a m68k testfarm).

Personally I think NR_CPU is better than an arbitrary number (like 1024)
for sysadmins (or vendors) to customize their kernels so I hope I could
find a way to use NR_CPUS-like approach instead of a hardcoded number.

Also I've seen the previous discussion to define CONFIG_NR_CPUS on m68k
but not sure what happened in the end:
https://lore.kernel.org/r/20240923235617.1584056-1-linux@roeck-us.net

Thanks,
Gao Xiang

> 
> 
> Thanks,
> SJ
> 
> [...]

