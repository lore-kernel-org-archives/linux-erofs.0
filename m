Return-Path: <linux-erofs+bounces-4224-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D6EC5CFCF
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Aug 2026 18:50:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hMBBH66hcz2xmk;
	Sat, 15 Aug 2026 04:50:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786733431;
	cv=none; b=S8yS3KY8kl1M84548uOv0sO3kDb225q87MhV9Tldvv5IuJGdNtgdrvU8x3EtT1WkYQ6Ap/u3PR9mWF9jgZTpQrw+VpRtay8UlFr0tdg+bE1tYLsZhMrnqE/4ksminNEKYgVj75ZQcqrUj1YDdcg5R2x5H4Q8W6nDJaqJyXrtVhWCeO1HavXMkGkzmX5x7i9O9n0w7/cPfXE86W2weDnav+cVPJwfCsY0gIuLks23wmNKhjOcluVg3ynMtcqycmoQ56DXktOl22qzObPhygQzBA5FrLb9J2iaF6L2z5jJuEKpm2PCimalqGsz6qy7uwUDnjKD1+Le9F0PC+46opgQxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786733431; c=relaxed/relaxed;
	bh=9lCmvz6eJXEEERTfL+imfRIsmzyRwZKtZsiC+HSbrbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wjn1DARc9TZ+Hz1BUPjSzW/oZt898mfwOxATYvISquAXT7AKBPv711B6ffIs3ZMz9kc98cWfRcoB2qr6emQekFukJ1E+TBOOShPiDzraC3+X5ZTEx3u1xpCdvDwL5YzQLbVaAXMFEXcR9yjG2JfcpeoGZ30/vLTMHFE5meI1Kgy9ocAM7RQHfS7JhMPVm5BRIliSUA0QM9RiSk0W7s2aNsmj2ADX4MB5AAuIEE/i2KwCiWCeJM+04Iu2xSIyIq2VOuq0HbvazYnFgQ2jh4Qj/++na8Z/WxRTK5gHGw3fB7FzSe9bpsu/qSQnyxvNjOkzRT60Gh9Mw+/jZnwX3/RhnA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oz1IlyhO; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oz1IlyhO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hMBBG6fkfz2xd2
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 04:50:30 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABD4A60008;
	Fri, 14 Aug 2026 18:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FED91F000E9;
	Fri, 14 Aug 2026 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786733427;
	bh=9lCmvz6eJXEEERTfL+imfRIsmzyRwZKtZsiC+HSbrbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oz1IlyhOm2snclEDHvF0SYNRPqIrosypwB2/OI0vOQ4Q64WFI9EXzRNYJ2H9WX0YP
	 E66lghnB356hVef7ElHyhQwl8OC9Qzef2nLt9A3+ogldevJthPsg+1tafWJZmssFbF
	 UJLpFh/bbznrO4a0ROtvj4htPutE/V1tiCGFUUQCwC+RDtkpyYBrn5uF8UflRxqsxz
	 ozFTiP3CF+VgLlNnXQeJIot56gDUn83CiELVEuFI5e9xdFIjZYRkL/5C8trEaLBwuQ
	 4/wj64z1Hg0vpPJvLUVGdcFG0ifZJTcp7DqE3a6/WB6KE4JHZ3XyaeGAqNCFtUcfY+
	 fEnDEAOZgXMAA==
Date: Sat, 15 Aug 2026 02:50:19 +0800
From: Gao Xiang <xiang@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Gao Xiang <xiang@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	SJ Park <sj@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
Message-ID: <an9ja0x8YR7SFoaZ@XiangdeMacBook-Pro.local>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Gao Xiang <xiang@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	SJ Park <sj@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kbuild <linux-kbuild@vger.kernel.org>
References: <anBYnPELPotUiNjv@monoceros>
 <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
 <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
 <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
 <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
 <5825b5c2-06b3-4358-91b0-d7bf437528a3@roeck-us.net>
 <an9d0zxE5J8txxf6@XiangdeMacBook-Pro.local>
 <1638f2a8-d9cd-423d-83f6-2b436e3c9de0@roeck-us.net>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1638f2a8-d9cd-423d-83f6-2b436e3c9de0@roeck-us.net>

On Fri, Aug 14, 2026 at 11:44:31AM -0700, Guenter Roeck wrote:
> On 8/14/26 11:26, Gao Xiang wrote:
> > Hi Guenter,
> > 
> > On Wed, Aug 12, 2026 at 07:25:50AM -0700, Guenter Roeck wrote:
> > 
> > ...
> > 
> > > > > 
> > > > > Thank you, that seems to work (despite still seeing the warning on m68k,
> > > > > as NR_CPUS does not exist).
> > > > > 
> > > > 
> > > > ...
> > > > 
> > > > > 
> > > > >         $ make ARCH=m68k allmodconfig
> > > > >        fs/erofs/Kconfig:137:warning: range is invalid
> > > > > 
> > > > >    Warning...
> > > > > 
> > > > 
> > > > Yes, other arches shouldn't have the warning because I think other
> > > > arches (including microblaze) defines NR_CPUS in Kconfig, except m68k.
> > > > 
> > > 
> > > That is not entirely true. openrisc only has it if SMP=y. But it still
> > > does not generate the warning for some reason.
> > > 
> > 
> > I looked into the documentation a bit
> > (https://docs.kernel.org/kbuild/kconfig-language.html), especially the
> > following parts:
> > 
> >   - type definition: “bool”/”tristate”/”string”/”hex”/”int” ...
> >   - input prompt: “prompt” <prompt> [“if” <expr>] ...
> >       and "If a prompt is not present, the config option is
> >            a non-visible symbol, ..."
> > 
> >   - dependencies: “depends on” <expr> [“if” <expr>] ...
> >   - Menu dependencies ..
> > 
> > and I think that is true, taking openrisc for example:
> > 
> > config NR_CPUS
> >          int "Maximum number of CPUs (2-32)"
> >          range 2 32
> >          depends on SMP
> >          default "2"
> > 
> > which can be transformed into
> > 
> > config NR_CPUS
> >          int
> > 	prompt "Maximum number of CPUs (2-32)"
> > 	range 2 32
> > 	depends on SMP
> >          default "2"
> > 
> > which can be then transformed into
> > 
> > config NR_CPUS
> >          int
> > 	prompt "Maximum number of CPUs (2-32)" if SMP
> > 	range 2 32 if SMP
> >          default "2" if SMP
> > 
> > so if `SMP=n`, it's equivalent to
> > 
> > config NR_CPUS
> >          int
> > 
> > so NR_CPUS symbol is still there I think (and its value is 0.)
> > 
> $ grep NR_CPUS .config
> CONFIG_FORCE_NR_CPUS=y
> $ grep EROFS .config
> CONFIG_EROFS_FS=y
> # CONFIG_EROFS_FS_DEBUG is not set
> CONFIG_EROFS_FS_XATTR=y
> CONFIG_EROFS_FS_POSIX_ACL=y
> CONFIG_EROFS_FS_SECURITY=y
> CONFIG_EROFS_FS_BACKED_BY_FILE=y
> CONFIG_EROFS_FS_ZIP=y
> CONFIG_EROFS_FS_ZIP_LZMA=y
> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=0
> # CONFIG_EROFS_FS_ZIP_DEFLATE is not set
> # CONFIG_EROFS_FS_ZIP_ZSTD is not set
> # CONFIG_EROFS_FS_ZIP_ACCEL is not set
> # CONFIG_EROFS_FS_PCPU_KTHREAD is not set
> # CONFIG_EROFS_FS_PAGE_CACHE_SHARE is not set
> 
> The symbol may be there internally, but it does not show up in .config.

As I said, the documentation:

If a prompt is not present, the config option is
a non-visible symbol, meaning its value cannot be
directly changed by the user (such as altering the
value in .config) and the option will not appear in
any config menus.

So It think it's expected, and any config X like
this won't be shown in .config:

config X
	int

Thanks,
Gao Xiang

> 
> Guenter
> 
> 

