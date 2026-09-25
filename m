Return-Path: <linux-erofs+bounces-4618-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB103C9832A
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Sep 2026 21:39:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hs3xx0c9Wz2yNH;
	Sat, 26 Sep 2026 07:39:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790372372;
	cv=none; b=a4wFCOVLfak+PyXOpGAKkodnqQQGghDdOl4/Q+Jn9Tjj5kiatGK2jXd9dLEnv794gp3UbsFOPAN0nBXQrR549Bnkl//LNiXqnXX7YEF8Pp6viMUykLaajkKWTyWQ0ZQrHQhq3IzW7QCtilV1lU+1DUNPCZV8gPOhLQf0PT/W7nwYWvw9dQ/nERAlb/Wu9209OG/Wo4MDT9vIV3hKSoMOSAG/2IZLhXg3ZR4cAFOwf5qG1T/JJH6eqLd2pI/5c0oUHL+cEOgzDj1jYdRevOuGmrmyo3hsF/HX/xriituOiXsUbxabNhJIsstw1q/scOLyw/UVnD/FEH9+EYorOkEQRw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790372372; c=relaxed/relaxed;
	bh=qGAVtFU1ZWDmCtLaT+G7B5o5ljsTh3nqCzq4ca6rlME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsk/1rgyqVmfvWGrlWATiCqvh9qp5+cu2EfnmQXaphTDfCcijBf0RfNBrsOzcHC56bWvh/Hne5lZT26llkFcO3KbDxXII/ARV03RfBQv4E3RytK5StGPlb+vbCAEMXKohZA3gUPAyIJVklioHhmvrPJqOCGtm1BNGKvybiGahybDCqIqATHzYO1VnVVPT5QWbZ1yyEPmvCqnGPHIjB51hu79Ewrcm2mXuG6cmVwXp+rxn08fJ7zNDA5Y1rapaONxTcQvjJbeG0T+AvML1+KtS5mwaDZPqU3ibq39NX92+trD5jg4Wyox+UAYcKApTtLwjlvCRSqd17+Dr29J1eF1cA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uq3jK6lz; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ebiggers@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uq3jK6lz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=ebiggers@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hs3xw0DVbz2yMm
	for <linux-erofs@lists.ozlabs.org>; Sat, 26 Sep 2026 07:39:31 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE20960136;
	Fri, 25 Sep 2026 21:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CA41F000FF;
	Fri, 25 Sep 2026 21:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790372368;
	bh=qGAVtFU1ZWDmCtLaT+G7B5o5ljsTh3nqCzq4ca6rlME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uq3jK6lzFPBk2mUB+21kzIEJ3e7xo6lES0MeUECU8KDNeBmretRa77Q3OlwhtoQmE
	 JG8Dx0lTEjtjm2k8juBgSTzHaF2rroNVk1zww7OONmnk0v+x0FA56wC0MjZCrNSV/e
	 H2pVr0Zo24UJv/vG9L8beZRRHMlmE7YAN/RF7/BIf3sCxDQZGCKJr+E+v3UjzyyNbI
	 MirHao5U2KikMGzvv4h38MAzkcRcWP7PU8EZ2aiQo71N4cAbsRUfMEcbTXCJ/xYXPz
	 HyiCZr2awcrNsxXI7Kdq8YVAeSXWzjieQzGLgVnG89GGjnkOohpJbH4QMHQxQzDjRf
	 Ccal7IQ4ASL7g==
Date: Fri, 25 Sep 2026 14:39:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,
	Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 9/9] MAINTAINERS: add an entry for the LZ4
 compression library
Message-ID: <20260925213926.GA1903@quark>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
 <CGME20260925113507eucas1p2ddb94f2077b679426aa86dd1d492eaf3@eucas1p2.samsung.com>
 <20260925-lz4-vendor-upstream-v1-9-1c7ffbe21c4b@samsung.com>
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
In-Reply-To: <20260925-lz4-vendor-upstream-v1-9-1c7ffbe21c4b@samsung.com>

On Fri, Sep 25, 2026 at 01:27:39PM +0200, Michal Wilczynski wrote:
> lib/lz4/ has never had one: get_maintainer.pl returns only the LKML
> fallback for every file in it, including include/linux/lz4.h, which eight
> subsystems build against.
> 
> This matters more now than it did. With the previous patches lib/lz4 is
> vendored upstream sources, and someone has to bump them to new upstream
> releases and decide what the kernel-side glue may do. I am willing to do
> that, so add myself as its maintainer.
> 
> Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc3cae2e378b34aeb705cef654c720ca9f2ba223..989e1b5fab21432dd7042d1e60c4bbad85beb925 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15606,6 +15606,12 @@ S:	Supported
>  F:	drivers/net/pcs/pcs-lynx.c
>  F:	include/linux/pcs-lynx.h
>  
> +LZ4 COMPRESSION LIBRARY
> +M:	Michal Wilczynski <m.wilczynski@samsung.com>
> +S:	Maintained
> +F:	include/linux/lz4.h
> +F:	lib/lz4/
> +

Should this entry cover lib/decompress_unlz4.c and
include/linux/decompress/unlz4.h as well?

- Eric

