Return-Path: <linux-erofs+bounces-4238-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D516FC5CFC1
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 07:49:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNlMf0bpDz2y1Y;
	Mon, 17 Aug 2026 17:49:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786952941;
	cv=none; b=TwGDilKAx4dopgDLwazs2jIezEMBAIB1ECoVcGkxdUatAeWLgqWu23t0A6+Qqj0YqkNr/cLeIvfqo6KFDNLWVrTPsI+OstmeK9TN0fqYZhuI+fqGo9A2KGg4H6GmlXWM6s7CUiNNE+yYE0LKZ3rpefu6hkWQ15MHcH4ZucetL8GiSoqT3AepQme8d6a6iFNjoiuz5G+ZHroX9x7Nn1QNnUsTco+wCzNQkvv74UFSkIdbKKnHS2Z8UbNLfSLdDH5zS5+AcdfZqa+BusiLO7+HjNQaaClS6SYdiyDNScW2QnAj6YTEI/n+OoJrt+SFxSQ04yOd7LmH2g6H0Qc5FV3IGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786952941; c=relaxed/relaxed;
	bh=viBoymsg9xDAdiX1A6XjLrBvzNgBn+v6VRW83WfvxCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1CK1e16FXnaMQ5TEawqm/ZnbJJq23pWN8vrF/QsaZ1ctq2axB6zPR4UgKARcd7MKBUaBDK81ijkqqWBA4CbUzb/OPsRLkLgPo/JmZzwQfHNos5BH+WqUXb0K9Mi63Xf0R2bMO+A0ltQiD64hC4hPFkD/5JXNWpIiweUz3MyLKhsWyHzlquAXIeztUJEaPUkX7gOeZyW1QWK1rCRJH8xRz2Ls+VIHvxjiiZr3FmuY32T2eSPDQQH8QA60fZSIhCDsg07DwFyW4yx1LCczpVqS3z+FQcIh4YU3oaxc5YTxo6Zpt3Fqlkwkv1Mk/rn4W7b4M29IrQxXvFq1V/MHmRyPg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBdTldUC; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBdTldUC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNlMc5klsz2xy6
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 17:49:00 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C14C5403ED;
	Mon, 17 Aug 2026 07:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136B41F000E9;
	Mon, 17 Aug 2026 07:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786952936;
	bh=viBoymsg9xDAdiX1A6XjLrBvzNgBn+v6VRW83WfvxCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HBdTldUCWwl0PpHhUc3ZpuiclKN1kld8sUrBNobMnvvAzb0zx4Y9GZ7AQnLPTdQZM
	 kBfuMQFioU8l2sCHC8LkwqccFvraiNiYsL0scmvLpDXa7Zz/yw7dhzUrJYt4keENQI
	 EdqW38lAKQRXm+iLuJfa46eMcWVFy8ggY4Nld3Pm/G30LshrQBrr3/eszmP+wKRTgT
	 mUpb67U2OCnZs+9WErG3r6ysLAAuvpxNloEO/0Nt1JXYKPHv1rn9erVOyStPd7cW76
	 uQZq/b3nhiLxp/tQwldT1NbiyA44IeRY/F7oDiwBbwAEMVg+R8lqDgVW5Um7Bp6aqC
	 k+AlNRL4W5zAg==
Date: Mon, 17 Aug 2026 15:48:49 +0800
From: Gao Xiang <xiang@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some
 UP platforms
Message-ID: <aoK84br1-61FLLXB@XiangdeMacBook-Pro.local>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Gao Xiang <xiang@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	SJ Park <sj@kernel.org>, Guenter Roeck <groeck7@gmail.com>
References: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
 <20260812131144.30802-1-xiang@kernel.org>
 <CAMuHMdWQO2Lkv4O8=nv6WVtsL1FEk-04RAv=VSZGkro7n0th2g@mail.gmail.com>
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
In-Reply-To: <CAMuHMdWQO2Lkv4O8=nv6WVtsL1FEk-04RAv=VSZGkro7n0th2g@mail.gmail.com>

Hi Geert,

On Mon, Aug 17, 2026 at 09:32:51AM +0200, Geert Uytterhoeven wrote:
> Hi Gao,
> 

..

> 
> Thanks for your patch, which is now commit a64d500b0078e16e ("erofs: fix
> EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms") in v7.2.
> 
> > --- a/fs/erofs/Kconfig
> > +++ b/fs/erofs/Kconfig
> > @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
> >  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> >         int "EROFS LZMA default maximum decompression streams"
> >         depends on EROFS_FS_ZIP_LZMA
> > -       range 1 NR_CPUS
> > +       range 1 NR_CPUS if SMP
> > +       range 1 1 if !SMP
> >         default 16
> 
> I have just discovered another oddity: when you have less than 16
> CPUS (including SMP=n), this default value is invalid, and "make
> savedefconfig" will always write a line like
> 
>     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> 
> to the defconfig file, even if that is the default suggested value.
> 
> Needlessly polluting the defconfig files could be fixed using:
> 
>     -       default 16
>     +       default 16 if SMP && NR_CPUS >= 16
>     +       default NR_CPUS if SMP

I guess `default NR_CPUS if SMP && NR_CPUS < 16` would be better,
I'm not sure since I'm not handy in Kconfig stuffs.

>     +       default 1 if !SMP
> 
> Thoughts?

In principle, that would be better, but may I ask if there is some
severe consequences out of one extra line of
CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1?

Since it has been fixed for many times, I hope if it could be improved
later if no severe impacts, sigh..

Thanks,
Gao Xiang

> 
> >         help
> >           By default EROFS allocates one LZMA decompression stream per CPU.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

