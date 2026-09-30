Return-Path: <linux-erofs+bounces-4637-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C50C9830E
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 06:08:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvl314TYSz2yTP;
	Wed, 30 Sep 2026 16:08:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790748493;
	cv=none; b=V5Y846Q7bMRc+0jpOFIQlfjvo2Ty1iatiA1fR0KGhiclFqujnTjohgo6gesUaJlCFRtEbrhaPzJ1c/1/lUsTX2Jzltow0t+hCTM33Yk/L2MMjkXvFWnt2qgSbuEE2tvb/WjDjpARlPnnafebNpYdxLIaD45pMTQmbfTat9sqg6pEyoW9CDC6lVxAfldmRU2gVIK4Pz6DNUrON5Hl/xKfpLaYcCmA0Kgrb6M0nVTVb9NF/r4hGRiiUywJg+rPqR+7r58tG1RAFJI6/NPP/b/eK8MT1xDoYFlMh6MKJ/3fcZKqrayi7mBLLbI+DX5V4jtQurcoQ+hCz4SmG3ROkHXt5g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790748493; c=relaxed/relaxed;
	bh=CgFmFj2igJGpmbRflOSd7wans++uMlq7r70gUY54Vy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JP+PuTBvwP4OzKc3K8mvPU7hSqJD5U3lOzKCrMDNqYSIesaWflzDxwNqZyJNBRE+WjsYfHuzWRiShusAxsfZv5Zc7IpA8dVWGPUqEL1vfvMUicFxH/E9Iz+a1bk0Pk0IJVYdx8sy+sKbX96bI5pozXY8IJFjaGXswF5lVnJh/do933Y98GSSUT/0oS2fOgcnHrW4saXxRtmq90KtuJqPF6cpiTEMoBZeZx2UeVE4NuEFnp/nXQLJUf6Rd8ZgMXyWaGxo8Hz0d5Vb2nMMGRwFMkWqu0fwIL/k1V0ONNhW+ms26AZukII5qgm7Exyl91ZZyLBS4tc0U1IhObywBV+Ejg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ObBnEJ/B; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::e; helo=mail-pz2-x0e.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ObBnEJ/B;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:3b::e; helo=mail-pz2-x0e.google.com; envelope-from=senozhatsky@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pz2-x0e.google.com (mail-pz2-x0e.google.com [IPv6:2607:f8b0:4864:3b::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvl2z4VPRz2yMP
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 16:08:10 +1000 (AEST)
Received: by mail-pz2-x0e.google.com with SMTP id 41be03b00d2f7-cc797656e44so1670754a12.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 23:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790748487; x=1791353287; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CgFmFj2igJGpmbRflOSd7wans++uMlq7r70gUY54Vy0=;
        b=ObBnEJ/BWSzEJ+UOtv0IeuzgI4WZoVyu7OGp5VEA4gdPIcTg52uaFEdBP/ukxbMyGe
         ZIULBaRxcnzmfutpcDFSxkGeXN9JDxuPTPjUKgW39zWxgWWBuRBstNvRK1LI0InYvIEW
         IPelNa5ysnqR0XVLABA7SwTpJpmmGOoKJH4OI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790748487; x=1791353287;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CgFmFj2igJGpmbRflOSd7wans++uMlq7r70gUY54Vy0=;
        b=xm8LCRKJPJTu0Ql42le/nW2r7uVUHo4J/EQUvVWGvuwKMlaZVDCqjpS4X+sO0Mh3I7
         dxCGgAU0f/gc/HlWqzoqLAuQHVUsTU5czyxzgLLtCN8D7Tbp4zB2WkCyJboZoHbRqlBC
         QqXxQXE+MNJJdjQCYdRl1qgYXbvqtC/sybdZWZemyBGPsLjipLDTGSSqRPXA59urKAHs
         0TXn1DNwKozWuX6i+w1rzl/cGuc2XxCjhB0AbelB7/P+4coZ5gnTQ0vnl74M5gAiFBVo
         dTcPi3giaCupfpqgAOM6Esq1UtQnsuT5spNxUkaSI5AvQq4DjkH4NFXOTjFlzo5jV0g1
         2qXw==
X-Forwarded-Encrypted: i=1; AKwUvBx1tM/MVK5O2k9o3NVurGy0HTj0CAfv/0FFv8KHm2sT+38V5IM2Vd8nr/66f9Y2EE/XWdi2LRPKoxZF9A==@lists.ozlabs.org
X-Gm-Message-State: AFuF++lUr6vCZWLRkLgQfa7vLwQ4E0uY1GIa5zorDg5GlYGeBstAVpDW
	IaVP/cmGPDlZMw+uZtQW0qHa9B4JD27d6CO8tpobNnZ8Ec6pfzPUnS6R6udTJCne1Q==
X-Gm-Gg: AYBFou29fBEqk4nbvxf7f+4f3B/mgTODlYzdvqQaeuzvFBt7L3OwHYHLNMWyRxSWjcz
	JEkP8CdsxG/RVvt2Qh+pxfTpufZO1DPybn94B2I38WJCF2XKXyTyrqqUtiVrG5BBt9KYateUKnl
	x/Oi6F3Os73LywrZCKwujed4FPbNtwszfPjdZRpRf5peNOnfnfKHnK4FM3BVmswpdsES36oocjn
	urED5/Jzk5H5ih+OcCTMoUFVSSUL2KW++HishVd5xX5fQVcKpzJF534aVbTKMHn4QUzBXLSBM8s
	okRNxeq6I19C/ObQ0f1lFVARvTpSh2CAOsfixWDtt66NQzEjxnX2ptuKWIhO/F4bSoFMKA25mLW
	m/2bjVUYd1GPjyFI3TaiHc7FDnkT4ZM7A3OffTidO1XYgbIOkcnmWKhv8D9Wm6WzIDAoLZpnpHU
	Px+RGclpjjWykM3Lh8ATAKyUm3VR1LNxJna8Vllf8qJgW1+NcVBs9FR9xCsohpARUcFJJ53x1Ew
	keaWkJoBN9XKU4Jm5Po1d46BQuv4Rmv5v5ktT3MsJOfpilJzg==
X-Received: by 2002:a05:6a21:492:b0:3de:3bd5:604c with SMTP id adf61e73a8af0-3de9e87f358mr387844637.41.1790748487167;
        Tue, 29 Sep 2026 23:08:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:31b3:f8c3:893a:d0bb])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88725d68389sm247895b3a.39.2026.09.29.23.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 23:08:06 -0700 (PDT)
Date: Wed, 30 Sep 2026 15:07:56 +0900
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
Message-ID: <aryehUJml8fTy0o-@google.com>
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

> +void LZ4_resetStream_fast(LZ4_stream_t* ctx) {
> +    LZ4_prepareTable(&(ctx->internal_donotuse), 0, byU32);
> +}

[..]

> +void LZ4_attach_dictionary(LZ4_stream_t* workingStream, const LZ4_stream_t* dictionaryStream)
> +{
> +    const LZ4_stream_t_internal* dictCtx = (dictionaryStream == NULL) ? NULL :
> +        &(dictionaryStream->internal_donotuse);
> +
> +    DEBUGLOG(4, "LZ4_attach_dictionary (%p, %p, size %u)",
> +             workingStream, dictionaryStream,
> +             dictCtx != NULL ? dictCtx->dictSize : 0);
> +
> +    if (dictCtx != NULL) {
> +        /* If the current offset is zero, we will never look in the
> +         * external dictionary context, since there is no value a table
> +         * entry can take that indicate a miss. In that case, we need
> +         * to bump the offset to something non-zero.
> +         */
> +        if (workingStream->internal_donotuse.currentOffset == 0) {
> +            workingStream->internal_donotuse.currentOffset = 64 KB;
> +        }
> +
> +        /* Don't actually attach an empty dictionary.
> +         */
> +        if (dictCtx->dictSize == 0) {
> +            dictCtx = NULL;
> +        }
> +    }
> +    workingStream->internal_donotuse.dictCtx = dictCtx;
> +}

Just a side note,
there is a bunch of new helpful API added in this release.  Currently,
we do some memcpy hacks to avoid re-init of lz4 C/D-dict in zram, but
once this series lands I'll be happy to send some trivial EXPORT_SYMBOL
patches so that zram (and other lz4 users) can use standard lz4 dict
API instead of hacks.

