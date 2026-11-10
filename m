Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39E4606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 05:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=hqLvt75E
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jNwTV2DTtz2yD3;
	Tue, 10 Nov 2026 16:39:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794289198;
	cv=none; b=aErXKFzVZoD8kUF2UM4oto429JaFdohoTShjC3h9e8ZsIxM+KeTReNXGwd9GRiwZhf46z7Fe2RpLX/X1WcfflHShi5bk+VFLyApvqRlCnZwEcOBvUJ/Qvz+5IL8wbZOkrAaz13MabInGNAL+EY6umGmnPFBMDmz4ISMMboVt7TLM+JTS/c/0/39Jkbs1Mf2iXgQBgrHI7QOWEmlPjv/pB/WOudrknGnRn7bOo2crxJzz9AVSN4vmnyGINHVRzJQE787pKmDEJQ/hzos7S14A0lkEdWONPuFRJV05ObrS4iKYUpag9Yj35xuxFiJ2hWITR2X/c7jvgCTS6GAjBbiw/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794289198; c=relaxed/relaxed;
	bh=Y4IpnFVFMm5fXSXAtzV8xsgRv9+hQP6OGl0+r2a9VT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFHulPua7IejOBQwm2IUk5zRU3YxKdwuDlabPtgwyv6aEumtO0KNn40cihHVWwUPl99Yy2ZAhSzfpFz0kgelgwuQRgblR85xJpkSbSl1bPBOIEdl7/B7DlzdyFtIPBrF8oskw7X2q0Z2lFo6Jq05GIPvY8xDKAETTxlriBfYQn77BwVKoFebjYCJpOazU1RQSwc8NI6VRM1+YdHpS0ILsmlxbx3+ESxV9ppXPW5hFihifahK1IJUpUwdJViqoIBgfMeowMuBo6ii8Aa5AirzBNdICIRVYaKvprFt8w3b9tv0m3kpebYnnKv0Krhqz3WjbrIZz6eKZiftWMQEMSA4ew==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=hqLvt75E; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=hqLvt75E;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jNwTT393hz2xf8
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 16:39:56 +1100 (AEDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so742680a12.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 09 Nov 2026 21:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289194; x=1794893994; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y4IpnFVFMm5fXSXAtzV8xsgRv9+hQP6OGl0+r2a9VT0=;
        b=hqLvt75EBjeR0DX2pP+tbcfo3oH8wNnm+zU6ri4UVEWwVkp633DTiauKpOsBSJL5Ey
         qQ9Lx9kfHRosXRrlj9dLRs8BiEzN5CzD+3L3sjLRJqxyj2ZaDADvJkqoy1mFyXUtXxXG
         3m3AUF5mJxsIXyzq+nKNHb5myCp1Dmle0n4T0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289194; x=1794893994;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y4IpnFVFMm5fXSXAtzV8xsgRv9+hQP6OGl0+r2a9VT0=;
        b=hL9NtTmxLnkTPDTCbhG5lkf+ycNUX4uqRasNAbNrOsJCo57UejiMB2azuAkQKbHOTE
         KzNOv/woCBvnig1/06gnEEqBO36t9yg3aOk/PjGDqNPnrQNsSgxmGOmoFFv5vUvURhED
         32yUodaL2NTv8674aPtGWIzy+De3IJB9EAux7O2Yf1wRqxKhWP8azk2ztfjI3PKfx0Nd
         ePNt8d6F7EbYiwTx3XN9cwTkkMOh7GoyiYvuvJuKTCM5dz9wVoQ/IzMrgCuH8S8HjKcj
         KrJO1CijCMAy0nqERrMNbvwMrM6MQCkjxGj/Xi15FUn/cy/xggjNqWdf6mXcjcHArxJC
         uvmA==
X-Forwarded-Encrypted: i=1; AL+hErELXbLhPvz4mU8Tk/3MPls4P7OR8Fwkfe4/M1ermDsivc4qY45NpKyyo7K+tvRQCkN22nrIBLI8uigG2A==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+GYJnKxsZgAxx1SlpQnEaVsGvc0H+fzfAJuH3CMvrBu9H+1Me2
	LZEyoaSM+3uQFFlITH9vMBOGQJGtH4VR4Cm40wKkwziTbKGA4kVa+xFF8Q0B1zrw2w==
X-Gm-Gg: AYBFou0XOASwPkKLODwL/UqjiWk7O/pon27Yvsed4Uys/3hwsq4i++R2vaSyZ1TVx82
	ripqQ5Iq9voFUFWsDyUvXPdQFgQM1GKGWzTZUNudb0a0jzqqm9yIhdim1C62TRbeo521AUeyXhQ
	tlYfZPtk2VKDxrjvPI4nSO7CHN20usFivmhyJi3iPmqa6c1pWskx1Fta5KZOmYSpkxj0M0BfBMG
	ANm5mirdizSDJGfmHq6ZNHhyJ+IMn5KQgymr16V8KEvHeRDdUa33gbbplrY04M7Q5mqc/fsZ3mO
	r5hCFn9OoWlq91qnFQrs4VdtL+fUQtN7uZb43pfCbOycTAmpCrbYcV0SN3TPdb43RAenG6+z0iZ
	3sUlYVXjIHWM1HIQwwSVVwiloKkMovrEewMnIl+Sx+4iNIztP8XyDC6TgFSD8FHKh4UHbGu0nhO
	inQ8Uu+QE14rRZHAmSLeTBjhioUjKyx4cVwiQASlWkRWyMRlD8f8hzO6ZNyNdMo4sl0K3ahInz7
	zcHJgXGU7+xOjcPV7Xabbsbg/av2tCs/DFcPgE4SEibuKbozHPstyJk+cW5VXUW1mfceCw0fzSo
	71oF3SjBzGJKxSzCcPBu5Kpg4wQGK8VwFLBvmym1Pu48mN/LkfByxMpy9TsNG+eFTpZfDaS2GJJ
	7lW1EC354y9SOEKE=
X-Received: by 2002:a17:90b:380f:b0:3ac:9599:a689 with SMTP id 98e67ed59e1d1-3b166d02addmr1882552a91.34.1794289194303;
        Mon, 09 Nov 2026 21:39:54 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b168ff86e7sm1041404a91.2.2026.11.09.21.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:39:53 -0800 (PST)
Date: Tue, 10 Nov 2026 14:39:43 +0900
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
Subject: Re: [PATCH v2 13/15] lib/lz4: switch the decompressor to the
 vendored sources
Message-ID: <avKtyCOOmK3AH0xy@google.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94@eucas1p1.samsung.com>
 <20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
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
In-Reply-To: <20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/06 15:42), Michal Wilczynski wrote:
[..]
> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
> index 50265e3ce256490994cb6dae32a45da376e408e0..b9b8a5f678c155442fa3fd2c1984e45182e6fc38 100644
> --- a/drivers/block/zram/backend_lz4.c
> +++ b/drivers/block/zram/backend_lz4.c
> @@ -84,7 +84,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>  		if (!zctx->mem)
>  			goto error;
>  	} else {
> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>  		if (!zctx->dstrm)
>  			goto error;
>  
> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
> index e7ee3740219852f079d1e0866da6b213a3f3a583..1e09c93016264259c149e2913b2819571b56fab6 100644
> --- a/drivers/block/zram/backend_lz4hc.c
> +++ b/drivers/block/zram/backend_lz4hc.c
> @@ -65,7 +65,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>  		if (!zctx->mem)
>  			goto error;
>  	} else {
> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>  		if (!zctx->dstrm)
>  			goto error;

Ditto, outdated zram code.

My ask would be to not squash zram changes with lz4 changes, when (iff)
possible.

