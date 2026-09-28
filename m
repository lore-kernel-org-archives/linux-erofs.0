Return-Path: <linux-erofs+bounces-4623-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322F8C9833E
	for <linux-erofs@archiver.kernel.org>; Mon, 28 Sep 2026 05:19:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4htV3S5SMGz2ygW;
	Mon, 28 Sep 2026 15:19:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790572756;
	cv=none; b=mV4gX5ldN+SpZtnmMMq+08ws9jyCz9CdpKCK6NRRpkgpOZjhCVlM7qtmqnFEJfXyckRAgijZTUjg6OxOPFCSRTR9nNmiG+Dfd8++OqID2fjLnyPFU4itfAj5QdbXDoRHVCurQVb2KEES51jQ1RGkE+MpXeVujw6idO2+woo2Ew3VwA2D0RcUty1AwUV5q+CMYQCLMlm0MvnVXeO3Q5xOzvCWZVkyNh9XXsoBNmYLtdprbdKUUFrrzunmB4OB6acCkyT3CwfKDIEuMrrRX/1llHpAnIKrgrp1HO4GF8R6Z6N5DJFOF4CGu79XIVt1J29aJXpMGDAcq1juVNw8btifpA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790572756; c=relaxed/relaxed;
	bh=aE4CNeMPjoyGqhac0qEjC0MrhT1ea2sjSdxYtuXCv0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxAuKEGbQLHKPD1bY9334eMl1j3I0Jjm1VrPkSoB8dAcn+tc2PTIq14ttJC9hSwt6RNlZ80CJUqjEDBSbq1a4g64UdIpG8wS0lAFLqLg7WR4b+RpSOdXOhfmr7gLCJiFdVvUh5pfXYBZrxJ0u27GoEbaOudHrROuk3vyUNNECYCZAfUocYYNoSLMe7Sd/8IdHh9q7l8RmDNvlTH7qLwBl2Hn9tWtjfRwTfbxJohfrDbb1Yu2fweI0EyIj2efCBnnafQ4gozHQpEiYEN0maAiikDzYgpXEhZrHRURvvhMZE2+uncVsBeuzFU9EL3YqJ0dDNnGStri/QLR3ycgfLYsnQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=FjM3L+/s; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::f; helo=mail-pj2-x0f.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=FjM3L+/s;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:39::f; helo=mail-pj2-x0f.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0f.google.com (mail-pj2-x0f.google.com [IPv6:2607:f8b0:4864:39::f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4htV3R38rFz2yb9
	for <linux-erofs@lists.ozlabs.org>; Mon, 28 Sep 2026 15:19:14 +1000 (AEST)
Received: by mail-pj2-x0f.google.com with SMTP id 98e67ed59e1d1-396ccb1a98fso1922072a91.1
        for <linux-erofs@lists.ozlabs.org>; Sun, 27 Sep 2026 22:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790572751; x=1791177551; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aE4CNeMPjoyGqhac0qEjC0MrhT1ea2sjSdxYtuXCv0E=;
        b=FjM3L+/stvYDsmTzi26dGFlh9DYHFgCkuI1wRqkAax+E7HBzw29qBB7GqUHD7CUuo7
         n89vFp24eKIPxuyUZ2PKUDPVfJJ0DnerpUlqlDzvlbSh0vJXuyzVJCT36IxX3XUHAz/k
         3rLf4sRTmiseFG5U1R62FxAB85j7SWzaGUdtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790572751; x=1791177551;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aE4CNeMPjoyGqhac0qEjC0MrhT1ea2sjSdxYtuXCv0E=;
        b=nEzqzLKsQIkyAMfz9L+jfQzEwUKGBY+nHuTXba7wFZClUBRL0wdz85+6BzRQ3ODF8c
         5akTHLIQg1hQWp++EXKNyrf4dxXpDGx4bk80qWAb30sbGI5rtICgRAta9Ji4ogqqa/rZ
         a3frn1CJzpnUjPECGecgba87O0JiQ0kgVgkXc8FYGO/Dn6ujZj+O+3m+o0PrAX27nPEE
         4pZs0nPAd8s48+n3ZxXNtBETC9n3cGIwZjREyc/qDQc9aBgE91KosFXBvUze9XYfu1r5
         jTVD5xqbvDKAxoQajQDz6JOkm7q23W/cThAggyF1mD/owTlUauxrh2HHVL30sXMhfzor
         MCXg==
X-Forwarded-Encrypted: i=1; AKwUvBwLy62EdATt+mrb0/rTzrBcGb6sgeCR7woi8o/LrxweIOW5GkLnxHtBxE69/RkNh4wFRsh1K1zeNDN6uw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKLpgvYI9XXUCQGYaH//aepA5+Sph2tAl7rtUHIAdK6aKRXRMgY
	vVMkiyiUMWVsk5lvar75nKWFXAWa+hbeX2wDI90fCn4kFKalGWQSlHmdLV0D3YlSrA==
X-Gm-Gg: AYBFou3qRvwY5/LAN/crjrOIXh3JC1ezeaGafYnIAGRbiZhUMroa/L4hof+EHu/4WZF
	Z5jQA1cD+YVxpzdugCP/1efsel0yjN0N+RNyuWu3iGahYjglCJLPzBHz/18eUbS+4FKxTjxruXU
	cWpIVECL3k0SzJr2ecetoPIPwXnw4lZ6yUEaGZfvaoa8dMIYEX0Z0j/U5pXPP7vCUbuESLOVupR
	h1VH4xascRNSbpvO8PoA7Eh5O4GVQC9mtoCpWU2uytllgNL/Rn3nJ/unpbnDxzKE1EXpLiInKGL
	OHsXTRQJNCJYp+wlNGrw0UmwAjsQxfWDqmdnfya4q3GLkC/Cm0m6BEhqsE5babj+aaYbTR4PjZB
	3542S99gjSZMp1Z9oKUD05XSLcBnEZK9EJS0DnQFnOcKV4M4ciu/6s5oVVgJiM+IicK3poW3uIG
	nodX9ZiclrEUbSne8pBg1UabqxF9aHTWmrgdN6HC/jp2e3tVrFbvqRdlIHN6HLiPpz5sfnB4+bc
	pkvB+E6o4bvr5yy92GA6aZM9aOf2zfdqxfNSDM=
X-Received: by 2002:a17:90a:597:b0:3a0:a055:1759 with SMTP id 98e67ed59e1d1-3a0bb60e55amr5032133a91.40.1790572751469;
        Sun, 27 Sep 2026 22:19:11 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:fdbe:318b:98fe:bd96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b94936ddsm18408378a91.7.2026.09.27.22.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 22:19:10 -0700 (PDT)
Date: Mon, 28 Sep 2026 14:19:02 +0900
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
	Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Sungguk <sungguk.na@samsung.com>, 
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 1/9] lib/lz4: import upstream LZ4 sources verbatim
Message-ID: <arn3TC7BgjTXWmdG@google.com>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
 <CGME20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a@eucas1p1.samsung.com>
 <20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>
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
In-Reply-To: <20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>

On (26/09/25 13:27), Michal Wilczynski wrote:
[..]
> +int LZ4_compress_fast_extState(void* state, const char* source, char* dest, int inputSize, int maxOutputSize, int acceleration)
> +{
> +    LZ4_stream_t_internal* const ctx = & LZ4_initStream(state, sizeof(LZ4_stream_t)) -> internal_donotuse;
> +    assert(ctx != NULL);

Probably in some other places as well:

LZ4_initStream() can return NULL, but the code immediately derefs
the pointer.  The assert() check seems to be misplaced, unless I'm
missing something.

I suppose those need to be decoupled.  First LZ4_initStream() call and
NULL check, then stream->internal_donotuse.

