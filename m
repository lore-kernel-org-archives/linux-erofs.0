Return-Path: <linux-erofs+bounces-4264-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52618C5DF87
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 12:56:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQk3T0ycpz2xT6;
	Thu, 20 Aug 2026 22:56:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787230613;
	cv=none; b=bCk5TQx6rrw3Bz5HgaGoMNSKobrMhzJAPf91IgdEjB8pUm52qYzMlGVM/t1zfdj5hKfZpVHPiYbRzzSl1JrElik19c6/bZrICaCH9biezeVlf4K8x92F3q8id8Tx7qddOUkoi9tMNm8XE7/sA3cAJbFV8SCnBBdrMLGhQWvzMrBZGvAnyIc/G89Y+l8kE+52dPmdadt87541fYr6MForQ/jqjiZ0aX3wXSCPrs8Rsfe6yDZFjr6R4rprv2r9RxY/01Q/Gw19HaZ7YHrcml5Y0azw6Rm/UVNQQOyqvjfnRp9f47DEj86HjUh34Bw++zHNQP6WPOdm8CMNY7nQ3bHsSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787230613; c=relaxed/relaxed;
	bh=v3b8LkCPd/3U6i839fzpldCSolvfMg/BARz6B6crxS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTWWXvAMwnGgi1GGfyPLXdU+/7FbYCWrHGy18Hlu4UB2OEEsdm6Xy+h4F3vn/ZmndfwKEQ9y8L2dey9SfG9vCT3jrSz9j/PnYBwWcbWWn1LwQzPuz5qG6zaBumpuDj5VG3PocojnunVUc4qKtSDv/mzJo0eWoIa4TgjznCe8V+g+GJM7EMhXpwzz5E1sVd9LvcnEqq5xchD0S7pzwpC0FF2TdWr5fAYU6fjT0z+nhrQ+grxps3k+kVEnQ10+j2pBY9sMJkBqFC/f67tN/4TSEa5EuRXGmKhKfLWEz9TonwX4bh3Eo9lNkS9/rk4YlfgQcaN+qdXq2BhV4SVmYCQYPg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRofYnmE; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRofYnmE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQk3R72C9z2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 22:56:51 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 204DB60008;
	Thu, 20 Aug 2026 12:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29041F000E9;
	Thu, 20 Aug 2026 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787230608;
	bh=v3b8LkCPd/3U6i839fzpldCSolvfMg/BARz6B6crxS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SRofYnmEr7nB8DoX1HQy/tolAkTh4t1oE5YM/kzUC/AG/I3Q+8VqvlN+O/7JlxCJi
	 iqxOkFyGJMZTgr7QgATijZjNEf+PvqtjBO7ziOooQbv4uyU5YszB/KV+OlJnuDoqre
	 xvy7rRsED7S/L70hmX0QQw8i537z519DFGWOt2i3QW/ClDuxNEp55CRO84D1J42Sqx
	 jzW7woyNn0CrSu9ytm0rOTDyHxR4UOAQZBVzC8+gWgJ1Q9PK7Wz8WVidEqvIUUm1UY
	 HdKjcTZdI9k4nf3EPHWgwkpAZ8UGNZBKm7h3col0GyDEvQmgw0V1dg+4FZ8i2OhvwF
	 42stvjwqWXV+Q==
Date: Thu, 20 Aug 2026 20:56:39 +0800
From: Gao Xiang <xiang@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
Message-ID: <aob5h3hi8W0CKxXr@XiangdeMacBook-Pro.local>
Mail-Followup-To: Geert Uytterhoeven <geert+renesas@glider.be>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
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
In-Reply-To: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>

Hi Geert,

On Thu, Aug 20, 2026 at 12:00:23PM +0200, Geert Uytterhoeven wrote:
> When NR_CPUS is less than 16, or when SMP is disabled, the default value
> of 16 is invalid.
> 
> While actual configuration picks up a sensible and valid default
> (NR_CPUS or 1), "make savedefconfig" will still write a line like
> 
>     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> 
> to the defconfig file, even if that matches the sensible default.
> 
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
>  	  Say N if you want to disable LZMA compression support.
>  
>  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> -	int "EROFS LZMA default maximum decompression streams"
> +	int "EROFS LZMA default maximum decompression streams" if SMP

As I said, if NR_CPUS is meaningful for both SMP or !SMP, there should
not be SMP involved in this Kconfig.

In other words, if SMP below is just a workaround since some arches
leave NR_CPUS = 0 if !SMP.  If NR_CPUS is valid unconditionally, I don't
think SMP is at all useful here.

Could you just drop if SMP and leave this configuration unconditionally
shown for users? It's easy for all users to get how this Kconfig works.

Thanks,
Gao Xiang

>  	depends on EROFS_FS_ZIP_LZMA
>  	range 1 NR_CPUS if SMP
>  	range 1 1 if !SMP
> -	default 16
> +	default 16 if SMP && NR_CPUS >= 16
> +	default NR_CPUS if SMP
> +	default 1
>  	help
>  	  By default EROFS allocates one LZMA decompression stream per CPU.
>  	  Each stream can hold a dictionary of up to 8 MiB taken from the
> @@ -144,7 +146,7 @@ config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
>  	  of memory.  This caps the default; the lzma_streams module parameter
>  	  still overrides it.
>  
> -	  If unsure, keep the default of 16.
> +	  If unsure, keep the suggested default (16 or lower).
>  
>  config EROFS_FS_ZIP_DEFLATE
>  	bool "EROFS DEFLATE compressed data support"
> -- 
> 2.43.0
> 
> 

