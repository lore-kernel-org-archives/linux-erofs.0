Return-Path: <linux-erofs+bounces-4263-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4974AC5DF87
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 12:51:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQjx01tRkz2xT6;
	Thu, 20 Aug 2026 22:51:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::636"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787230276;
	cv=none; b=lIc5xBbAPChHLTsda4OjTQiscLCU9JpcLAQAvAgOUXiYHdle/krfzQDb1H0OQMLQ60pIkmq7OEVh2B+9NErohkEZGw1TMuhUt9DaeoT6tnUX6JtsxbriP9jfmRD/GlRge8k4ukfQucSwjf+XppfAi+ytTIQ12a7KgOQ2pL3xNhK+Z389Bmn8UnkPxH2epDTDLn4zWdyiay0cVac/AdO5mybapBbU/QlDhGcSb4bxsafvAYTrIvPkAMK05OhpSrQGp3RAdtdIPxMDr2BtIn1dSNIsUD/fs2nODLAgEWN4KKLA4JHS0trMu/HiJnpEsgUY2kmlr29FCDNs5DmQncNMug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787230276; c=relaxed/relaxed;
	bh=Si7LMqQovUXrzcuAyjz5fRRdJxM8IdMb9TYKZNUROeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ss3D7GB9SfVOIFkp9AFueOGdVPgfOX8/bc79TEKY1xtiRWmNgKohpXIlGbLgfRIxv07tb0PHqj+oVPOdFHrHt3n3pgUUCFYUIjcIaW2Z0No0jiOYxBBzxc8lzkPL4DVNJ1EvtO0z8YRoSnS0ckPDg4cf8qZrExw3vp3drLyDjef3fs0VCoCay9yDu3Dj2LfVLKpa7akRfqsZnTjSn/sSGrMQFb63VIil4wzdexWQpSN3g9gaLR5O7qDizAcC9Esi4oqBv07VehI2xx7MurEiJ6AEs5pMM1xmhSYf7yznfYdwMr9cXw3gG4ojDfi0nzihL3f71rwugCGc10w5NtrYIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P5dmDSpv; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P5dmDSpv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQjwy0Hbdz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 22:51:13 +1000 (AEST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-2cace91f112so21212875ad.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787230271; x=1787835071; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Si7LMqQovUXrzcuAyjz5fRRdJxM8IdMb9TYKZNUROeI=;
        b=P5dmDSpvJaYK/gxecz0qgo9IQeInP0cL6YHeI6dVtj1EdeocSBpGtBNQuCHIDqC1I3
         866jruUJwg1bONpkVbXDipo0fHim5rUqzfXh5AVvop+0JZNj6OKDxNrPbpO3q3J45zAi
         WKPH92c9RVcElJj3t7ww2b66hITZ3Xm9Qyund8taiF/lDKoVLGj+rulohje4+vxpb5z0
         58Bl6QMpgxb7JcXsO7T6TB10h3EOcp8RtuOHOb0PclXCoGLJBb8l2K1tG2WaMIohjJpP
         wtg6qLR5Lycb5pvBqlsbdRHGBr5Vnp7WrH60Kj8p+iPXd9hjFXJIjur+67rjuw5pfeQk
         cKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787230271; x=1787835071;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Si7LMqQovUXrzcuAyjz5fRRdJxM8IdMb9TYKZNUROeI=;
        b=IErUB6DaI1h7R3xf2ohERb1tOVZF4gkhA8fVkc5PRE639CduuVgTnFEahhHg2QGs+N
         nodvgKwr1Mic/QV6ohYMALLfpa9mVhiK7kZuW9iXEvNpdaKc/5VIYX9w6GucOqu+fH20
         ruDh3CwvcTJ7g05AzUa+mP6QK+73IO/BZtGxjLr38leSN5wwTakCL4n/ei1uXI81mifz
         kJndLufViHTBLHeEyzTuYptM9tSL5hlzDfHZudmi90CYem6LyNRABYAGImmF8pFla+dQ
         HYxiWZXEScVH9u4XOKmn/RfIG/KpI7HdxGvwTFf1QjuUrrl8x/59oPd/i+DLe0Zz844p
         JMxA==
X-Forwarded-Encrypted: i=1; AHgh+RqqXOgoUWd4LdYQ2U93pJFW23yz+3GwV5/NL73BNtC1YEy/r0bl38QW1yAiZmIeqXunXKg+X0YF2wZEvw==@lists.ozlabs.org
X-Gm-Message-State: AFuF++nB5cgN+a5LV9YOIJvRYjSlhH4dwIK9KBQm+lggSLwWNDarPlQQ
	UZRTCSHhO9T6M4ePSKCB8hs6OEYqbzqvWJqrSjyUT2fZrAbWLQXRQV+C
X-Gm-Gg: AR+sD11CqoZKPTNYAVMOEP/ls0Xmo5ZfNjNXqSZeVLdegDWCYId+b93mbnnOEztcW9O
	CrS370NTd9ODqXxdd8Wp8pcCLvuiPVP4BAD8+KeytxnaLMezJZvv0jxkVaq4v2mANUfW7bJQlDX
	xqxoAzvKIx4QnSZXjXp7R9BOkZntfr5X/PYvv5VQdx+PZTP9xIhBmHhW8z/GEvyZ+ohcpCLNV2j
	aMM5ZzlwS7YowApHHPRy5OAxs1mLiwySBpKpg7VgztfJTLmghisnpPXphYFecscgo4R6Zq5ySNm
	4H73rxH+f/dHTklM/4oyASBirBArufi0aDVh/PK/zFLdndVZ6WJ8QxpIQU9i8XdTs/xeNvzFbiz
	gRKWZOzLZ6YwWfIN4MiF3aylQV9N+sckl+JRxkGQYmsxKWVDuVCq+IXlCalrPqBsnrPJ1woC3HQ
	hHP00oWKP0Yu4nbw9JfhCpJpgbHyI3KmWiE7B/OjhHx40/1kInHjmlOH6rBxHIQ3dkZfifoU/VM
	A==
X-Received: by 2002:a17:902:c94f:b0:2ca:e62c:9e96 with SMTP id d9443c01a7336-2d5fd6acbecmr225918805ad.5.1787230270659;
        Thu, 20 Aug 2026 05:51:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef3993dsm15590612eec.5.2026.08.20.05.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 05:51:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 20 Aug 2026 05:51:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <3d845134-9b75-40bd-b221-2bd35f98d425@roeck-us.net>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>

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

Absolutely agree.

> Fixes: c9b47e6b23114e93 ("erofs: cap LZMA stream pool size")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

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

