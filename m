Return-Path: <linux-erofs+bounces-4620-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEDBDC98328
	for <linux-erofs@archiver.kernel.org>; Mon, 28 Sep 2026 04:12:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4htSZY4kn0z2yQH;
	Mon, 28 Sep 2026 14:12:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::2b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790568757;
	cv=none; b=TaXtemJo/NAt7YkBp4ZdQgoyMe/eSlCiIBdhE0ToSY1IKnutDqvw14WdSN3X8l7d9CyfU4gu9JILuMHz9+gBtHzF8oa95MkhUli5FizSWg0j/GbQegv8eRT32iUaMHv2L1Vt3kjEBDLn9RZyeKP2+V9GyGllmu2ginila2nuLs2ZVPiNAD3oClxpjLeJAWtb03EyOglhsMLo1jxsKC2c+lS3baSlpRRog4caFE54OXqIPJEIhV5dYnn5BMqjMTTXxGpiuHA2WBxgkiaz6xkBaVMrcb3OQvc5337TXKgRj+H9rC3OmfAbrCV4tnK+GU9srYNtDv+LGCMVIRnDQ9mxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790568757; c=relaxed/relaxed;
	bh=bXDScwdKbt28kFhjEDV73RhbSo3l7UPBxj8GidcV6Ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joi948Dfq5zI7PvTCyLFw5uMX5JB/w1gQfpjmMNkHQoDCBrxTnmynlAqmrT/0Qc6xuIkoDMU7kH85EMfE/umvyekoiS4f+pnQF0NQ1lZWKx/ftgPpEPPA3EGGBDJzTlk//nuTU4v5vjSuyyZ24b2ilBxKvRaxBgB3l1llWYp/CTFoeIL9Dm7cJzQSWaU4JZvS5fyayBL29uP66GbRTByUp/IOFvhtYX7mvGdJxmpXLKW0hoeS8H+ZGfT1xyMnMgdEhHvK9NVaNvytKXDBSjtYdGKitAGvzFoejVMdwG9Zxgfzzvo0Dsdn74f8FX64VGT/MbhUmCagFUUzHBMgnC5KA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=cP1yWsnt; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::2b; helo=mail-pz2-x2b.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=cP1yWsnt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:3b::2b; helo=mail-pz2-x2b.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pz2-x2b.google.com (mail-pz2-x2b.google.com [IPv6:2607:f8b0:4864:3b::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4htSZX3rn6z2xnn
	for <linux-erofs@lists.ozlabs.org>; Mon, 28 Sep 2026 14:12:35 +1000 (AEST)
Received: by mail-pz2-x2b.google.com with SMTP id 41be03b00d2f7-cc7979d1deaso482476a12.1
        for <linux-erofs@lists.ozlabs.org>; Sun, 27 Sep 2026 21:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790568753; x=1791173553; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bXDScwdKbt28kFhjEDV73RhbSo3l7UPBxj8GidcV6Ck=;
        b=cP1yWsnt5a7aUqWlVbpK3WynculITMgOS8Qhp52YEix6kY3365DYWTBwMbYf/2kmx1
         kTuMlbPlsvUeizIBqVKhBTAL9FUuCK0cD0Inn1Zov78L7aoF103b7XI0W0ljvbLOzD07
         sVIDPRFE1PSnKUlSs/wJeAIracqpgik4GZI5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790568753; x=1791173553;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bXDScwdKbt28kFhjEDV73RhbSo3l7UPBxj8GidcV6Ck=;
        b=AmpMvQz9PVn0W0+UtZLhfQzVBKvBnnC864UPPMY1JEkaiK8DxYpEJ76j7Nd5G9rKvp
         A3UTOTqBvyDXQzsG4d6LCN+rbV5nx+tiP5AWXekW/GbxIu3wNqQSyG4h2XE81iHViQ1T
         TbIniKPVK27gaYApWmwg+/si2Y3dy9fG8RpQdn0urz9Lr3vs6T8LiGAWP0QculD4ygvV
         9tClW+y44UVP+ZmDVlwIZjN5jrVuPC/b39l1lfD8rFnpzLBbf2dD3+WbYvnSDF11EyJ7
         PumFob/fnd4mLCO/WtrOC8/RhGSvN05mN/IIA/JVy8ikzG5LT8VM+MH+GQFSwa96JGb1
         h1cA==
X-Forwarded-Encrypted: i=1; AKwUvBy7J1JN0GAE/wpkuep9WGThTVcV4nld++pCwyCNgNqQrAy180fFmod5W/61KA6SjiCFn9fQCaaSRP1HGg==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLz2VydXi31LAKIo+8VPUNLXhIuHKdI79wi3B8cwE1lqCeeFzDg
	9yNnPzkd+RjQ3ozXON+hm0fBq28A2d4ZYLaVWIiGXazWMec0ZH7Oe0q9yNse2KH0zw==
X-Gm-Gg: AYBFou2e5vVpjbnyt2YyyKyz8RbRGyGD/ksvT/5faF6E8RF7MhRgKkw1R09EyEUicXL
	6Uq13dgkJ3dtdKwlurgLxReCdxfZyrbfEvrZOCU8i1397V+DukR/PD+ZzMMlbWEDnKqBePBi2Ja
	KwvA/plnXzbQ1R6YUZt0cm8ylcDoDmh4yOylNEF4HILYVfmgQqVug85L4Q5ZAa6NziJihSMVVnX
	zqRVOj6RfREcZg6iWpT5+I2d4Zl8kl/QC+gbot0Fc8HSLEeHFaK8ViimeYxGRmYziwfGAm9IKUo
	HYip4XesjfgcXjvDOMr5ZhKivewPkS3qbTgmQb35gfgEAX/gQIwdNQh+/b7oz1nNScxSnUN2OFi
	9lVtr6kaK7yjQz+sVqe/pDWqGqo18eH2QjDfkdHLjGGTCmWjnSSsNGfAmzEa2nvVKMTWZXyN8AH
	4kEi6mNC8cql/JLau4KoqKH4VF9ZkOneOggIfHJZBNZWZAc7akbQT3FKmF+ViyfjzkYXLrWzjdK
	P/wi0TIic+62tZtpXz1dnDXKnyRExJMqAHcJUA=
X-Received: by 2002:a17:90b:1c82:b0:3a0:7d97:37c1 with SMTP id 98e67ed59e1d1-3a098aaba1dmr10891588a91.59.1790568752817;
        Sun, 27 Sep 2026 21:12:32 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:fdbe:318b:98fe:bd96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0bec30aaasm17381254a91.15.2026.09.27.21.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 21:12:32 -0700 (PDT)
Date: Mon, 28 Sep 2026 13:12:24 +0900
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
Message-ID: <arnosKlQYVIdmTR7@google.com>
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
> +#ifndef LZ4_FAST_DEC_LOOP
> +#  if defined __i386__ || defined _M_IX86 || defined __x86_64__ || defined _M_X64
> +#    define LZ4_FAST_DEC_LOOP 1
> +#  elif defined(__aarch64__) && defined(__APPLE__)
> +#    define LZ4_FAST_DEC_LOOP 1
> +#  elif defined(__aarch64__) && !defined(__clang__)
> +     /* On non-Apple aarch64, we disable this optimization for clang because
> +      * on certain mobile chipsets, performance is reduced with clang. For
> +      * more information refer to https://github.com/lz4/lz4/pull/707 */
> +#    define LZ4_FAST_DEC_LOOP 1
> +#  else
> +#    define LZ4_FAST_DEC_LOOP 0
> +#  endif
> +#endif

I just checked https://github.com/lz4/lz4/pull/707 and it seems that
LZ4_FAST_DEC_LOOP is enabled on aarch64 now, but we still disable it.
Am I missing something?

