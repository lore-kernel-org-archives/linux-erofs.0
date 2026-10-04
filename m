Return-Path: <linux-erofs+bounces-4659-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCFFCA5FEC
	for <linux-erofs@archiver.kernel.org>; Sun,  4 Oct 2026 08:34:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hyG5b5H9kz2y1Y;
	Sun, 04 Oct 2026 19:34:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:30::e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791102851;
	cv=none; b=JQcCixhcfm7J/a0ylVIFoXy9UxA+6my2lHazDlH8ZrwQzO59fh4eU2iyZe46lAnpRLbD/SRZ43xJuYtLgEHxIch3Ky5/HL1AtH22BVnzoqSPcsusIDPZ6YdjW4Geuq/8TNvlFtdO89ubAVyKfoTh2U+McOtdJlgPHtmJULhfpbsah0mo3piNXRwryNtHkJQgZUqRc5fpWCPWxOEkIVHWeJpvuEEe7irNy97jcoH/quqNXrhctCYQn2xvOcWMV4BchQGutzL3QAWAgURYxOdOQWwYw9YXWhNKHSHZSP668mw+djR8Dt9EV+MzkhVcgv6UPcTmt6jqV+unP8BEdeIqFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791102851; c=relaxed/relaxed;
	bh=0HFDC0D77tUqEmXehAlYyAx2E0DK1wOzX1zKg1ym3bo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZliA3/TqSIo1IBs0gx594YDvyYlAEsEaCPv5y87TssZEVwnIIBOzZefjPKZA0KxBosrDPER2VI/OvglTL+0UfthFW3fEyD+RcLeJg7EnO7D/DMO8Wlg5eMnJG0donzu4rSK/LLGhvnR0sPMmHcY8/usnf/7lt2uRc71DxsjjA7koRPLZHLOo6vACu/JW8mgvoveJoHh3M0aUivjeVTeFhKTX90a/BenmOzZ4Icol+j1W6SlkziUZuGBFrtybNdJyfuYn+mcxbIf95J0Q/B/cy7CrO4ErnQ5C+MmW81VRcW0YUx9mjpx2Swic6g5bo2OyMnxyX8gLKLQ0uvrsxO6HIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qwRS3zwT; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:30::e; helo=mail-wr2-x0e.google.com; envelope-from=david.laight.linux@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qwRS3zwT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:30::e; helo=mail-wr2-x0e.google.com; envelope-from=david.laight.linux@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr2-x0e.google.com (mail-wr2-x0e.google.com [IPv6:2a00:1450:4864:30::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hyG5Y6Nbzz2xM9
	for <linux-erofs@lists.ozlabs.org>; Sun, 04 Oct 2026 19:34:08 +1100 (AEDT)
Received: by mail-wr2-x0e.google.com with SMTP id ffacd0b85a97d-48aff58e6abso374507f8f.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 04 Oct 2026 01:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791102840; x=1791707640; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0HFDC0D77tUqEmXehAlYyAx2E0DK1wOzX1zKg1ym3bo=;
        b=qwRS3zwT70HvtUmaXBWq1gXVs8Lzhy/y1kg2PhkvNh5SWmDNk+OSL2B9Tx4lncyQRl
         7dWq3rOubFDTco+jn5qycA4SJLKI9poCsyrV8OzgWEIb5P3BBP2q7hXQ+TxhYutEsDW9
         M4zngofdWkWKV8TjP/EuVOAY6yUyjwvsDtNgO+McV+suDGlpxCGndggUib20xntN7zEs
         YJyBFXtepUfqm/VfhzfAZRG8Vy+1JhTdqUh4/dXqWHcJ52uZ1m9lDPfkyEpKu4PiKBq4
         irPerP/VLn6+2GE5m+ktvdfo9lDwSi5dX97OZaaEhfuyh1dF4sdCYf2gqceCLmMFn6lu
         BJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791102840; x=1791707640;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0HFDC0D77tUqEmXehAlYyAx2E0DK1wOzX1zKg1ym3bo=;
        b=IvFm3kl1WSkOGgAsFOxsf0VY+AQacJErM9mZf0Xk9vM6otGxPf+3/NdeSZvWZfQBA5
         OJonfav6wZZaGjc9fzn1ckbmj29Ms2J3KQMGyT4tyfSH/agZqa/S23TC3VqfRyPx0tqK
         Q5sp3fAJ+nKWAn2h68zODKtz7ihVt16XhjBlpefVZwOPXpoPa1CdjklvY/mapX30B6Db
         ZQlgKSaJXvmDAc2Wr5mgTw6ysijKUry65D+KjM7iBDCOjRKQMgYJ1PNyiuhBRlMu49VH
         aMB3GWmjwxvT4qpJMveuPnnAHt2L9Ms9nvVbAKaCnWCkj+jUttoAF8Nj83qhr2EsBxPv
         FuTQ==
X-Forwarded-Encrypted: i=1; AKwUvBy4DF15s+XWPCP1eDI21tj/KraIDkUoVDYg1N7STANcmWpABrDH5fMxez6d6CEKgvRCMKaP9Chy1HBUxw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYI3Li7Cz1ooXHT9XjqVYZICK73jtXpL2v+WGwf8DChwgEZ0Gnjd
	1Vlb3PpVOXzT/OtU4PClJKGf+bPoMs+QpajgOKvYx6KEvlhv0SUnwIpE
X-Gm-Gg: AYBFou0qvGzvhA/TnPdPKl7jG5tpzHugsx96l0/WupjnzmMdQzxbXH96lY3XNWdMxEo
	1ba1jWPIibxjMWXcKmJP1U5NplTlKUeCFfrT5qwYRgVG60S0pRIlkVBfDT9UypQe6mowxNuCh8w
	GMHF8IgAWZimzlerB3NIBtl6Za/PT/ZKkp1OHS/G54nvk220cGnviF/yJnyk6Cpuz99TrSvmKCE
	1mktVg9UKeM741Qro1KwiN43EnCzVdRIbdT8Eb7ArNzsNseDEZvSEXlCpZTSqzlRCe/TcDTlKSu
	5MxV3IoRHJS24WhSkBclb9i+8PRj/X4cuIW4Zhp6c6/n5tDxA/JjfBSKHXBeJ4RTHSspnD95xSs
	ZviH//8HDKxFkzJfgbVEqIfW5hg/XLoQtnbYIKTF6MTJNDPR1EPMaze+eyfWwspPnyl1IWeu0V9
	g+gPyRi7ZhfE4dYob6pgstw/tk3XSJcqlZkUFCaZ8t62Ssk2NEfwFt0Lvw26QuSlR9zv6p8xuqs
	QTCIEDoFBkz4JDG5iGea4H8QEgXVPq2Ao9rC688ShAtzw==
X-Received: by 2002:a5d:5d0f:0:b0:488:83f7:633a with SMTP id ffacd0b85a97d-48b12736b49mr11750202f8f.28.1791102839800;
        Sun, 04 Oct 2026 01:33:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f04f8sm17350793f8f.9.2026.10.04.01.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 01:33:59 -0700 (PDT)
Date: Sun, 4 Oct 2026 09:33:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Nathan Chancellor
 <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Bill
 Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Russell
 King <linux@armlinux.org.uk>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>, Jens
 Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, Nick
 Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, Phillip Lougher <phillip@squashfs.org.uk>,
 Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 1/9] lib/lz4: import upstream LZ4 sources verbatim
Message-ID: <20261004093357.33a124b4@pumpkin>
In-Reply-To: <fac0f401-bbd3-444b-a755-53cc393673de@samsung.com>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a@eucas1p1.samsung.com>
	<20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>
	<arn3TC7BgjTXWmdG@google.com>
	<fac0f401-bbd3-444b-a755-53cc393673de@samsung.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 4 Oct 2026 01:50:39 +0200
Michal Wilczynski <m.wilczynski@samsung.com> wrote:

> On 9/28/26 07:19, Sergey Senozhatsky wrote:
> > On (26/09/25 13:27), Michal Wilczynski wrote:
> > [..]  
> >> +int LZ4_compress_fast_extState(void* state, const char* source, char* dest, int inputSize, int maxOutputSize, int acceleration)
> >> +{
> >> +    LZ4_stream_t_internal* const ctx = & LZ4_initStream(state, sizeof(LZ4_stream_t)) -> internal_donotuse;
> >> +    assert(ctx != NULL);  
> > 
> > Probably in some other places as well:
> > 
> > LZ4_initStream() can return NULL, but the code immediately derefs
> > the pointer.  The assert() check seems to be misplaced, unless I'm
> > missing something.
> > 
> > I suppose those need to be decoupled.  First LZ4_initStream() call and
> > NULL check, then stream->internal_donotuse.  
> 
> Good catch, this assert() is a noop in the kernel (as any build without
> LZ4_DEBUG), so a NULL, undersized or misaligned wrkmem oopses in
> LZ4_compress_fast(), and LZ4_compress_destSize() and LZ4_resetStreamHC()
> carry on with an uninitialised state.

The assert() is also just a waste of code.
Debugging the NULL pointer dereference is just as easy.

David 
 
> 
> No in-tree caller hits it (all use kmalloc/vmalloc), and I listed the
> alignment requirement as a behaviour change in the cover letter. Still,
> the vendored files need to stay verbatim.
> 
> So in v2 our own entry points can check alignment with a WARN_ON_ONCE()
> and bail out early. It might be something that we can fix upstream as
> well.
> 
> 
> >   
> 
> Best regards,


