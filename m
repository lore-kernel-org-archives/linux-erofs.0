Return-Path: <linux-erofs+bounces-4203-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B76C5CFEE
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 10:55:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKlkb1zD4z3bpP;
	Wed, 12 Aug 2026 20:55:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786532103;
	cv=none; b=GrGqI5R3fSKBcqL+oV0QdqaQ39vOGenD65pOfKMkcz5CFnCkV5Ika2TTFfPR8ir3E+KMjP17GGBSB8GVybk6v2fFJ2sFg9hRU7HhcSye4hbuutdDVOkv4Yr2Z2EsF9M6i+hTJxBdLXcRxVmZReR9gIPiKOHDF6ePR1ni3u1RNv+mVd1gKZUv7iXDzzzPxaambU7sv7zovbBLLhbzCYXEgq2WNUTS4BI6a0XLOdtyINiNCpz2tofLhcUsSoMvdOF8DPsxt5VuT/Rc3AAMGZmGCxQ03l3YhyXpoR6ZBWzDtpnL7QSnRabeImTsZQkoWeIeiI4YFGz0EpEPam1oxAcFCA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786532103; c=relaxed/relaxed;
	bh=uPRPM0oO7lPsSa7sbZJlY6Xn88MJbrqbLlIHa64uGDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2zjBU6M2yivZAO3pAln7PFEjo934t37xaUX6wVJHfifZzYKq3PdrgvKKOQI0HIDSUNZF9ND2nUxoQqF9+xtT7qiWboj77z/WgYqnHzB+i8gMmoQLOTUu2EYYmpXmSo2QrUB8rL0g7YIgh8F9mbJ0Y9Ui1GKx31ni5IDSQZcq7YT40EHYKXmalJG/cZNRTPMzuGEGBqoFXjAXzvygF+Evg9vw2G66IXm13DEUcRuRh+ilVtUlhaJEvpOMHGyKf371EPHxEBugVEOhm2OsOks7WVBF8MflcZ1HcbK2fnpeIqJ+nECmlKmna8PI1xy4NKtqMHfOPSjE22RZ32Dj6DHmQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lt9u9YE5; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lt9u9YE5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKlkZ0jyyz2yvB
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 20:55:01 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97D54418EF;
	Wed, 12 Aug 2026 10:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6F1F000E9;
	Wed, 12 Aug 2026 10:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532099;
	bh=uPRPM0oO7lPsSa7sbZJlY6Xn88MJbrqbLlIHa64uGDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lt9u9YE5gbZuh1Dl7uF+J880/nASXspS3X6PQ8PaNzAHE+Wf1ZS8PDUqSiRRb4te8
	 QUefXzabe5vzPZsmO188kcoZXU02AsZxTXpmcMfJMmDjhggXqNDDiPPbaH8jvg1gt5
	 5T5tBMrc93ZOJqc6pNiSG2Z7ZZjutBnqFlbUdqa0y1BXWxonKLp/xDm5vfxNjrcIxL
	 QD9l377prWUJTgShmNfjOMZs8LrZS3Tc+Y19X84nLCPfXXpAnHYf0P15DgT1epnpvO
	 xLfVThCFpla7alEKCDMdOVVi2/s1flPJJvMRRpRJEg/NLws/iubuoGv5LGug7NgsWe
	 nYIo2O+0H1HGQ==
Date: Wed, 12 Aug 2026 18:54:48 +0800
From: Gao Xiang <xiang@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gao Xiang <xiang@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
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
Message-ID: <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Gao Xiang <xiang@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	SJ Park <sj@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kbuild <linux-kbuild@vger.kernel.org>
References: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local>
 <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros>
 <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
 <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
 <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
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
In-Reply-To: <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>

Hi Geert,

On Wed, Aug 12, 2026 at 11:30:14AM +0200, Geert Uytterhoeven wrote:
> Hi Gao,
> 
> On Wed, 12 Aug 2026 at 01:37, Gao Xiang <xiang@kernel.org> wrote:
> > On Tue, Aug 11, 2026 at 03:37:38PM -0400, Michael Bommarito wrote:
> > > On Tue, Aug 11, 2026 at 3:35 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > Any progress with fixing this for v7.2?
> > >
> > > I would like to fix this since I started the problem with the original
> > > patch, but I feel a bit stuck.  My v1 and v2 patches would not have
> > > triggered the build failure, but Gao made valid points about the
> > > trade-offs that led us to this v3.  Maybe it would be worth your
> > > opinion on the config approach in those earlier patches?
> >
> > Sorry about the late reply.
> >
> > As I said, I really dislike hardcoded range, but it is an issue that no
> > NR_CPUS definition on CONFIG_SMP:
> >
> > I wonder if the following diff resolves the m68k issue (I'm not an
> > Kconfig expert but it seems to work on x86_64 !CONFIG_SMP):
> >
> > diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> > index 8ca1767dafb6..2dfc313588d2 100644
> > --- a/fs/erofs/Kconfig
> > +++ b/fs/erofs/Kconfig
> > @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
> >  config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> >         int "EROFS LZMA default maximum decompression streams"
> >         depends on EROFS_FS_ZIP_LZMA
> > -       range 1 NR_CPUS
> > +       range 1 NR_CPUS if SMP
> > +       range 1 1 if !SMP
> >         default 16
> >         help
> >           By default EROFS allocates one LZMA decompression stream per CPU.
> 
> Thank you, that seems to work (despite still seeing the warning on m68k,
> as NR_CPUS does not exist).
> 

...

> 
>       $ make ARCH=m68k allmodconfig
>      fs/erofs/Kconfig:137:warning: range is invalid
> 
>  Warning...
>

Yes, other arches shouldn't have the warning because I think other
arches (including microblaze) defines NR_CPUS in Kconfig, except m68k.

The following diff can eliminate the m68k warning above, I think m68k
folks could consider this way if you really don't want to define an
explicit NR_CPUS.  Anyway, I think it should go with another patch:

```
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 11835eb59d94..90499f126c73 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -44,6 +44,9 @@ config M68K
 	select UACCESS_MEMCPY if !MMU
 	select ZONE_DMA
 
+config NR_CPUS
+	int
+
 config CPU_BIG_ENDIAN
 	def_bool y
```

I will try to form a formal patch (with the diff in the previous reply)
directly to Linus (since I don't have other urgent patches for
Linux 7.2.)

Thanks,
Gao Xiang 

