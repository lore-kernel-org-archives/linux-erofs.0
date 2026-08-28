Return-Path: <linux-erofs+bounces-4365-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E78FC61DB9
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Aug 2026 19:21:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hWpCS3Rrsz2xnv;
	Sat, 29 Aug 2026 05:21:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787944884;
	cv=none; b=EHIrKKbS2Oj5SS5zMwqafK1Y0J18uwlTFARe9z25Ke257frucBucls8vWuv0x/JOPOhU9fPVpB1622jjy6xM+D7wneEDRGyk4y/IGYbbUiqT6zUlturB6KKxGU1LoDVbqSmn5bRsKpfTBkYkeJ7yrtPQG7vVDEwB0I9xc0/BrMlovjsHyaxkzbLhPydDtEsN1xYDGZruNh/91ynn8nL75unY24dEqvoURSWkK0RKJnSgK9SLU18xXByySGqHeUDMpX+VyR/j1R64eORHo9Y/T2ZRgPZPuwg6xSF7HvHYJLUyCRzbbhX5RnLlgcDUxOggsULrxErinYZxm8ujb1drAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787944884; c=relaxed/relaxed;
	bh=+pC9pfKkgZde38rA1x41lZq10E6fInu+DStbCtLBNtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhB5e7PngEkZX8Dr5lOQQq2Oj+PDJCtcOS4kQgtjHg/Loevh/ZY0RoKsCB2NfzB044mhGq71QNAkIn83nyqydgTYFw6xGx2l12cm1HprD0gfyknWZEGDFd03LIlVH+PNHOhAwJ6AOOlCbAHtrEPh8tBgHkjygrs6F+3XG702sQMfHUP4vPWWDRy+OG6yNQvz1hm1Y6EPPAvoRWfXl+sEvrJuXzdYQUAqwvez0PXghU3gSY0ViG9kNFajycqkQUDOW2WFUmQs0dS20tZy8Qh3mr2cHmjZ5op0XW/PS6ezrIZFufRWxB+YdHvLauA5cRlxMf2zAhUKCihQKAsWMHbmsQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NuPsSYQB; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=nsc@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NuPsSYQB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=nsc@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with UTF8SMTPS id 4hWpCR2Xr9z2xlw
	for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 05:21:23 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 97BB260052;
	Fri, 28 Aug 2026 19:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C6FB11F000E9;
	Fri, 28 Aug 2026 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787944880;
	bh=+pC9pfKkgZde38rA1x41lZq10E6fInu+DStbCtLBNtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NuPsSYQBvf26u0P/q6K3dtc0+Qpl5LEF18SoNBkqHd35yqFpParmpEW5OJaAFfMZg
	 nIMRvP3dpIN0sCi3H6z2usuk1FaUkD00V6+Yh73x8vASAtj+OO8GwkbUv0ilrKEmQg
	 mUJlb/SpY0hrnRc8eI7lDJ/dW6nvqya/YycIFVjV053GtP0eJY7Gp5kVIVyjEI6fSi
	 +c3A2nJ61wn84ZMeWawcL9Am6UB9g0f8rJC4/2iPD1sILuqig3Xa71smYExm56v8kQ
	 duzjI1rwF8kXrNf/GjkOfisAjRBOfumgKGVqHfYVNKTKGWlHTJNCQxe72qhNEa8QR1
	 CWq640sdjuzjg==
Date: Fri, 28 Aug 2026 21:20:36 +0200
From: Nicolas Schier <nsc@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Julian Braha <julianbraha@gmail.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
Message-ID: <apHfhILRL0-lFOEh@levanger>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Nathan Chancellor <nathan@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Julian Braha <julianbraha@gmail.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild <linux-kbuild@vger.kernel.org>
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
 <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com>
 <apGqg5a5I9g1CoF_@levanger>
 <CAMuHMdXwmCrzLZiPnQejJ+dTvVNf2zTzgKwTWEFEkfKRkZQpPQ@mail.gmail.com>
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
In-Reply-To: <CAMuHMdXwmCrzLZiPnQejJ+dTvVNf2zTzgKwTWEFEkfKRkZQpPQ@mail.gmail.com>

Cc: Julian

On Fri, Aug 28, 2026 at 07:21:07PM +0200, Geert Uytterhoeven wrote:
> Hi Nicolas,
> 
> On Fri, 28 Aug 2026 at 17:47, Nicolas Schier <nsc@kernel.org> wrote:
> > On Thu, Aug 20, 2026 at 12:15:33PM +0200, Geert Uytterhoeven wrote:
> > > On Thu, 20 Aug 2026 at 12:01, Geert Uytterhoeven
> > > <geert+renesas@glider.be> wrote:
> > > > When NR_CPUS is less than 16, or when SMP is disabled, the default value
> > > > of 16 is invalid.
> > > >
> > > > While actual configuration picks up a sensible and valid default
> > > > (NR_CPUS or 1), "make savedefconfig" will still write a line like
> > > >
> > > >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> > > >
> > > > to the defconfig file, even if that matches the sensible default.
> > >
> > > Is this a bug in kconfig?
> >
> > I am not able to reproduce that; this is what I see with ARCH=arm64
> > (arm64 always has SMP=y):
> 
> [...]
> 
> > Thus, to me it looks as expected.  Do you still see the behaviour you
> > described above?
> 
> Perhaps you cannot reproduce this because this fix is already
> upstream as commit ab74edaeb1ae7c71 ("erofs: Fix
> EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic")?
> 

oh sure, thanks.  Yes, it really looks like a bug to me: if the range is
defined as 1 to 1, the default 16 should not cause a savedefconfig to
write the config set to 1.

-- 
Nicolas

