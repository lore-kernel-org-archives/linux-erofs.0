Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A6860A2607
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YqWXCoB9
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jNwQ73337z2yD8;
	Tue, 10 Nov 2026 16:37:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794289023;
	cv=none; b=aZjg99VfTT4JeEhEKCNQODVP81KGmM5ttMjYUm9fpGh3771cDXRZoXBkxhDFLD9me4WuU6uPQPlzY0jcgCLaBTg41YTlkZKnsIi6uTClQL6dB3An/WVEq+GdCHAAxRRd6UYJKySLStpZhs5fDhhF7C8ualoUfmHMDDQC5p3ORwsngKzLPNopaaO1xJ8+sw6FAFcm4av8PMCNhM169N2j359IzybV8TFVrz1QPozhAYkvTrHwEYz20p08mUfjmbPJdTjZRhQTkJNfnW8UxiUZg+ZyJunykqIs6ihkBG7FMihQDrEfi/0NIvmLREE7Dta6LqkIYga0VhiHjmyFdrGqwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794289023; c=relaxed/relaxed;
	bh=upBQHvhIXS9jA4rn/T2U6OyiZNi8Uwc76Ij6dQGz7TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2nWAgIVzTx7Xx274EFksznsctrYW7+YnTefM9vX1UU0638qGfSe3KM5rDkh8hec8dmvVh4cAsz9PfAfl+sDiGZUYExzB6pdmhBUBlTOeIjaLtXeZNnJZ7gHAS80gFd9PAQ8CqDu2AVoSuhaCRMdLl7AvQDk6MpPO/MZAHQW2W4xCuxzs02G4+0Al6ZVznaZsIPO6swL2lIxSZ+O3WP8bqm4lMUVUVvkjHtZ8qk2jBZ2VdEHjLzKZt6lhvcWHXvUvZatjUCoaB8ANzx/Z60VNJEhyEngCcJn6BEC6jzycg7JDcmxX8JmJRjeASv+UMl0nRqorgcdcp6+LXtSPeByHg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YqWXCoB9; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42c; helo=mail-pf1-x42c.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YqWXCoB9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:20::42c; helo=mail-pf1-x42c.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jNwQ56zrjz2yD3
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 16:37:01 +1100 (AEDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-8a06e79e152so842065b3a.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 09 Nov 2026 21:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289019; x=1794893819; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=upBQHvhIXS9jA4rn/T2U6OyiZNi8Uwc76Ij6dQGz7TA=;
        b=YqWXCoB95xZsQGD2hlb+IAefGC6sLiua7TY6c2kgS9+IHd6RGibGAaLXMR2rHivC9T
         sYh8grEvwtt8SY8u17Ssh8KefwqsBMZU67YwoH5M3jkuUvFsU8lc8uqqZPNW0QimhPRD
         PbiN9aDCRovOzZ46sOI2E2MolHrBxKNLdnf1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289019; x=1794893819;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=upBQHvhIXS9jA4rn/T2U6OyiZNi8Uwc76Ij6dQGz7TA=;
        b=PhzVMTp/2PpkV7zYT+Td3syLDQ3NPqQ3+aASb7Ro20MzLFUdWmHUbU1tDOfhA6Seyj
         iAWR5WITnEmdQ2KljSg5r5/g0ploJOt5WEyq/WxCzl1jRGoCyFri289Jn/O9DwqYnXUE
         X7VDYyz4xTKAyPWG8/2z9ddJZpuhF95zcrxWH1k6WPRuL+Dco86xh/vCfHIiv6vbRqj5
         kB5D3jfUhOIZqSA7jgeZ+izLruYr9u1rQorJgb6tURKnJneKQnadFK7n9XR4V4DIXDAD
         DhqFd9HufzEue7W8KrxSVz7Z92KLoQpOYnzjKJH/1Aw6xUkbVwE+gT9/OokreqZkUTOg
         Q6LQ==
X-Forwarded-Encrypted: i=1; AL+hErFtAm2BBuuvK9zjIdjdtS3I0+MRbJw9a6i9JYuhTsWIrTJnYV03b2KHeBQLJWj2nMbGuglxQGqfx8JmhA==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8rhfuC7/faneznOofJJcbFAf1vX14Ws6U40IVkqPA47RPsDOxF
	xdsG+zINuAt5XffSqEklVxIGIneK6zuSiPk+L4+CpWzrNdw/7yL7FIc6pMR+pKXTXg==
X-Gm-Gg: AYBFou1cJnh74rMMazi4AhYhc9BnFcg/OMlxA6G3S12hbhvCmiistDBnDyDy6nNDDJk
	nqZHlBNwIWBftVIrLviL1UViEWtJUNrgHdJvo2IMDixGx4pxgJ1HAh5QQZb7vIbEW0dD1WJt+Ak
	IKBnTMlV+L7FQtad/LkzQwbwJfW5U11rfJVFD3YcnEHHJKE1yoxYHusHxxF+yrvOc6KYWolFKZZ
	1EuToREnjWRYxA1C+rA6ORXjODZQvJmbvVeLTfpGxfmu6vv7CVckknmux9Bge/rKT+n1eO5exJx
	hhrhJFWKEQuCh+Q1OYSuuWuYI1lUFLeOSRczBMtlLxXBSzVtZAkg/vlDF3ya2KfVlJ0+jAojmDR
	kYgbBaJf/IIaDzMM6ZFi5SsgIZ+7HoH7fKcB5SDWB6yNDCZvnObKyQKG3GsLaHeMEvBwbTqXsEb
	mGOGzESIwt6pIG44xkn4AM+pk1WqbmKswbUlMISvSRQftVV1+TdKwVhH50K5qOAHL5l7iOt5Ijp
	bYUFy9OiZTab7vypTnXqcRe+mYQRafSIFXkk5/5TgEY8s8i8q6DuXqFnLnvcLpWTk7yakOlGuMR
	YfaDt/i7OtOPL4rvsZzztg/mwpod6HV8jRVDKPp5pe5Co18HY8i676lxbWFeErUOoPPDxQ==
X-Received: by 2002:a05:6a00:1492:b0:89f:5c84:46ec with SMTP id d2e1a72fcca58-8ba89661da0mr1558178b3a.40.1794289019108;
        Mon, 09 Nov 2026 21:36:59 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dccc7sm405355b3a.52.2026.11.09.21.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:36:58 -0800 (PST)
Date: Tue, 10 Nov 2026 14:36:48 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, 
	Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Laight <david.laight.linux@gmail.com>, 
	Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 10/15] lib/lz4: switch the compressor to the vendored
 sources
Message-ID: <avKs4_S7r6EiUVgC@google.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144305eucas1p17b3b27d403dc7d13b85cdd9a4bea83b9@eucas1p1.samsung.com>
 <20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc@samsung.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc@samsung.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/06 15:42), Michal Wilczynski wrote:
[..]
> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
> index 1e4ad31d39a63f45b3bddd3d8a467d8d7d095beb..50265e3ce256490994cb6dae32a45da376e408e0 100644
> --- a/drivers/block/zram/backend_lz4.c
> +++ b/drivers/block/zram/backend_lz4.c
> @@ -42,7 +42,7 @@ static int lz4_setup_params(struct zcomp_params *params)
>  	if (!params->dict || !params->dict_sz)
>  		return 0;
>  
> -	dict_stream = kzalloc_obj(*dict_stream);
> +	dict_stream = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
>  	if (!dict_stream)
>  		return -ENOMEM;
>  
> @@ -88,7 +88,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>  		if (!zctx->dstrm)
>  			goto error;
>  
> -		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
> +		zctx->cstrm = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
>  		if (!zctx->cstrm)
>  			goto error;
>  	}
> @@ -112,7 +112,7 @@ static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
>  					zctx->mem);
>  	} else {
>  		/* Cstrm needs to be reset */
> -		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
> +		memcpy(zctx->cstrm, params->drv_data, LZ4_MEM_COMPRESS);
>  		ret = LZ4_compress_fast_continue(zctx->cstrm, req->src,
>  						 req->dst, req->src_len,
>  						 req->dst_len, params->level);

The zram code here is outdated, it has been reworked quite a bit
(patches are in linux-next and Andrew's trees).

