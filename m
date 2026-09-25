Return-Path: <linux-erofs+bounces-4619-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88CE0C9832A
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Sep 2026 22:07:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hs4ZR6czzz2xsW;
	Sat, 26 Sep 2026 08:07:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790374063;
	cv=none; b=bevB4J2AZeEHkzkfH0swweMcfllkzjGVCgN+K6lqIqqR2P0IWwRLl8P8YF39rLM9cgpoc1JEtpJkdbFTS+qMKFxqRqitL2Kfnj0cLJpChBJRB8SObLWToy0qqsP/NvewKXgIM+x2GsnmpsTrwZLpSCYTk7i3w6o1JkH69H56Nso6tS7hbphRxbPyjrBJDJYXGHy5MIagOmc01jLlP65s4JNp0qG3EvSxVNFKKcLt+iS5Qzohf8q8wug5f2J0QSHDYlxgiu7/GwdQiohnHZrIU5btNYL6ulmMgBZ9p35KcCk6dSRy/VAnBsFCTPRGSk2Qdq00z4dZHfKnz+s3cYU6/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790374063; c=relaxed/relaxed;
	bh=k8g2DRYbUFc/WlQ2pAkletlhQtrwe1F0NZCL2F3+zUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kezyFLA7vRO8Cz2JNrKnUvNWOQ3VzjEO+P9yi8Pyj+rN3sjDdLxqqvHESMKNPHnYCOi59DiS71n314BwqsOEFpp5BzXOnUf3r1X4DhJ6cyNuhJEHCfTeK6v9i6/sL+kxuoBrQGkXqlPGcjezHVDcd5P4MTZUrCSvzbD5tnCOct3b/TCz19CTfLnSK2D9EvL6VBvyPGza3BSGuGCJJk1CCIJoYE7eYrzcTI9UsX2jDrBFqs74LUaYnskXW+ErgcQVJoXasNVl5SAgO9nagnumqgrYwxRvgL8qn2pgD70mIA2NmN8W4Wm6BE7bjl32PqdAl9zh/YsIFhTLlpZqMEXb/A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Blm+98gn; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=ebiggers@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Blm+98gn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=ebiggers@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hs4ZR0Jy4z2xmh
	for <linux-erofs@lists.ozlabs.org>; Sat, 26 Sep 2026 08:07:43 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 871CB60136;
	Fri, 25 Sep 2026 22:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F871F000FF;
	Fri, 25 Sep 2026 22:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790374060;
	bh=k8g2DRYbUFc/WlQ2pAkletlhQtrwe1F0NZCL2F3+zUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Blm+98gnNSmmT+B1FkGka5xELWe0Sas5kxh6t5tiDl8w5RPy2GIR156rg32qYAB8h
	 0WC2HIz9I9oTU8BMJGRhVpVPYDGzzRjyfJveq8tYuLsmMYq8PIg/rRdFm5JUc5XTUv
	 91GhFUgvrNiWWbRRvN59hi3Fpb3qet+Bo+uXdpaPUiXnSpzo4uJ6julwsKMhb0hI0F
	 fCnTm7iQaDrz5G7/S+Ybr+QBIQ138M/AuG4leepfCPOBvTzVcKAe7YoDWwTXpZPdWD
	 sWKIAoZzsyb+GWb/CE2bNAPLaHe7PFEY5aiF2ExoAzy1jo3Uh5k6xUgU2dktwiDBax
	 IMsJ0+SwguBcQ==
Date: Fri, 25 Sep 2026 15:07:37 -0700
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
Subject: Re: [PATCH RFC 0/9] lib/lz4: stop forking upstream LZ4, vendor it
 instead
Message-ID: <20260925220737.GB1903@quark>
References: <CGME20260925113450eucas1p2fcf838f00f35e1bce0ca04a694cd0cd2@eucas1p2.samsung.com>
 <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
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
In-Reply-To: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>

On Fri, Sep 25, 2026 at 01:27:30PM +0200, Michal Wilczynski wrote:
> The in-kernel LZ4 is a fork. The decompressor was last synced with
> upstream v1.8.3 in 2018 and the compressor with v1.7.3 in 2017, both by
> hand. Upstream has made 488 commits against lib/ since, and the gap is
> maintained one cherry-pick at a time.
> 
> That has left real bugs in place for example the forked
> LZ4_decompress_fast() has no bounds checks, so corrupted input runs off
> the output buffer in both directions. 
> 
> This series vendors the upstream sources unmodified and adapts them at
> build time, so a re-sync becomes a directory copy:

At a high level, this looks good to me, and it's similar to what was
done with zstd.  I don't see any obvious issues with the integration.

There are disadvantages to directly integrating external projects like
this, vs. writing a small implementation from scratch for the kernel.
But the existing LZ4 code in the kernel isn't that, but rather a fork
from upstream anyway, and it's clearly not being maintained properly.

The upstream LZ4 codebase also already avoids many of the typical
incompatibilities with Linux kernel code that are often seen in
userspace projects (such as assuming FPU/SIMD/vector instructions can be
used at any time, or that the stack size is infinite, or that the C
standard library is available, or that it's reasonable to have hundreds
of files or 100MB of test data, etc.).

And writing properly optimized compression/decompression code is quite
difficult.  So yes, syncing with the latest LZ4 upstream seems like the
right choice for the kernel.

- Eric

