Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB037606A32D
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H2HTk8rO
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPyFV138Hz2yKn;
	Thu, 12 Nov 2026 09:03:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794434590;
	cv=none; b=eNVUdHx0nNhOZVGTCs4wvJoev5pVyEGFcYmLIXEU+3d3hSNJmimzh9oi8r8jKBCssFs2DYCU3CYqn5HDO6rYnJtDnH0ksAvdjhZnxHcp1D1l+dZAXrQy9Vf8/ZRozCNKoUOrCrk63BE63qzl20bQ6u+9qP5/cb9CkGdoGDTJOw1iqvGqAqYNWGJtYynhEuPaVtx0yhE2z0FVqM8THmfBloqGXMwfaWGf04X4YFL0bC55WXZ+CnAGbwDSDkwXgBK9G2biKE0JhPw3qzqaHbg61tLYtT58C5rxI6evv2l9/10GffflMnk+xmLW1I8T2wPckhu/ALPZVeSiDGh1tHXtfA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794434590; c=relaxed/relaxed;
	bh=/29Fh1u2FOm5/5k1pmwlztbcmx561O6eu158ApMSsyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gr3ttmjdM0ljGO2KQ7EjqmcVNGok95IZnVN50ZkvRCX6uvLpPpVT4Vc+qqZDhOPYGapqFLdDIvZMiILPIArgDCpJytVi84XhrLnfW66f5jnVDuWcQzCQTsbG4Qfe5P/Pj5WRpLuWtzQwGx/wJynlcmiA9zzoKgUdB0ZVoGzjNdrDwaPb/CugL9w13M9qEbvkYk2t4B0e1BvnUu9AYSnOmB4WVeCi62AYgeN4sKFLjic/hHa1ZnfGrPlkb1eL5m1bJk/9pZhqkPFAd6B8uozeaK+CDw4TxVjKIUXIlr/q4QqPmZhVC+pvJxShy1yyzDxbxo/oYuEdzV3vyfr/XQaWNg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H2HTk8rO; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H2HTk8rO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPyFT1ww1z2xsW
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 09:03:09 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2040261D2C;
	Wed, 11 Nov 2026 22:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E751F00A05;
	Wed, 11 Nov 2026 22:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434586;
	bh=/29Fh1u2FOm5/5k1pmwlztbcmx561O6eu158ApMSsyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H2HTk8rOLZgWw9Lm2uB8it44XJGQ1VP252zKM3Vsl27YeQT3fQC/oPf+9dR1GGuPe
	 fTrdVHJg83sazuCLRwsK7FMBmZ65BjYmx/5l1Fr9V4zrWbVX2E4c/EGrAZHOJ23iP5
	 K6oVJy3Ue6XdepxFi87RWoq3TdzVK9qDLL8BM8XMCz9n7H3pjJ8s2COHz+NjnFIDwg
	 2eGJ+4dbOKk2dBpxqBDuRpXAU1slNtJxbA2Dkar3W/730CiqV+uxXwdTMmafxIRXoH
	 hanK6KHxVmWrohkzaChiP47GtgTq+nQUar+jL+4xWJclsB1e8afff/e4uoWiQs4JB9
	 jrQrJYXOzTbWA==
Date: Wed, 11 Nov 2026 23:02:51 +0100
From: Gao Xiang <xiang@kernel.org>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Laight <david.laight.linux@gmail.com>,
	Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 12/15] lib/lz4: widen LZ4_DECOMPRESS_INPLACE_MARGIN
 for the fast decode loop
Message-ID: <avTmC_1I59FKA1FN@MacBookPro.fritz.box>
Mail-Followup-To: Michal Wilczynski <m.wilczynski@samsung.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Laight <david.laight.linux@gmail.com>,
	Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-crypto@vger.kernel.org
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7@eucas1p2.samsung.com>
 <20261106-lz4-vendor-upstream-v2-12-ee04c3f0d7dc@samsung.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261106-lz4-vendor-upstream-v2-12-ee04c3f0d7dc@samsung.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Michal,

On Fri, Nov 06, 2026 at 03:42:52PM +0100, Michal Wilczynski wrote:
> erofs decompresses a pcluster in place when the slack after the output
> is at least LZ4_DECOMPRESS_INPLACE_MARGIN(compressed size), upstream's
> (compressedSize >> 8) + 32.
> 
> That holds for the fork, which overshoots its output by at most 8
> bytes. Upstream's LZ4_FAST_DEC_LOOP, which the next patch brings in for
> x86 and arm64, copies in 32-byte steps and can overwrite input it has
> not read yet: of 172410 valid streams laid out as erofs does at exactly
> that margin, 3660 fail to decode, none with the fork. The worst needs
> (compressedSize >> 8) + 33. Images mkfs.erofs built did not hit this,
> but nothing in the format rules it out.
> 
> Use (compressedSize >> 8) + (compressedSize >> 15) + 36, which takes a
> 4K pcluster's margin from 48 to 52 bytes. Upstream's lz4.h defines the
> macro too, so undefine it first.
> 
> Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>

First, I really think kernel LZ4 should be updated for many years, so
thanks for this!

But my personal thought is that could you just fold this patch into
the next one ("lib/lz4: switch the decompressor to the vendored sources")?
Because this one should be part of the fast loop update.

Although the current patch order is also fine, but my potential concern
is that people don't know the details maybe pick the random ones for
backporting, which is what I'd like to avoid so I hope this patch could
be just part of it, otherwise the inplace decompression could be broken.

Thanks,
Gao Xiang

