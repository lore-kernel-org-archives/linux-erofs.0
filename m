Return-Path: <linux-erofs+bounces-4222-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89845C5CFC1
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Aug 2026 18:26:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hM9fk4ndpz2yRZ;
	Sat, 15 Aug 2026 04:26:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786731998;
	cv=none; b=PLtpe7gVWwPDPfjlJRosvr/1ZhAKcOaHjqE0b9TadQSGr4TP5tg0HY2WgbWFWvfQMw+ybIO1P7TQvoryMns4RjtivQ3a2CkC96VEV8557uUjzaamOp28xv8qtg32G/5nrXJWujknwyvAM7f3RnJkqWgR58Ma1CGI5+97yqlNRneun2CC/dVO3Hig3yNZlRIt9+8iiIeE0/IUqz7/bg0VFo/qgFzU0J7/AQFlg628D5zCM2v9cklCLvDgtkpi/H46FKtqqHy/CYLDQA84xk2Cd97lCCL3ghcXcNxDJb2ZuAVbLf7ZHeCSejpFH8v5U1J6jGwF/8o87vNUWFRGUTp6eA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786731998; c=relaxed/relaxed;
	bh=CgfrDtYSv7XSiQrsZBc5JqmKYf95u/1czGarXlJCkhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DC+MNxvVrWk0QkEkMri9r4MEIIJPvwrJO0ZRftp6JbuA6m2Oj3h+CEi8rvIWQcpYOOy1izrUv4Z/+iofs7ksM/P+nvcQPA7Z5NcQVlQjHUxRVCWYWzKcRsgkvaGhj+/6v0HTMJUgqhpXXv61wWu5zZgGav0YgWsaBeZXSbPcCTJTWpa8EBvylVINzD+EolxLuTfDQKp9HoszDa5g8sbE1MK8eJUyT8yqYFcVPS6NJB8dmeuZmBH9VS16ZQF/J9WtISzV+UzdCaYqw0nY26V9tHBcCiwguhADdUENaeyvpkg76ubUzKvYilmkKUI4UI8oNFB8VBRi0UN/PGdxMtfegQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEq5KU6M; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEq5KU6M;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hM9fj381sz2yRP
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 04:26:37 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C6F8436EB;
	Fri, 14 Aug 2026 18:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BBA1F000E9;
	Fri, 14 Aug 2026 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786731994;
	bh=CgfrDtYSv7XSiQrsZBc5JqmKYf95u/1czGarXlJCkhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JEq5KU6MMJBQlMCl5YG3XPNvkI397ajcdFHnneLMtZoi6TFgDkvbm6lN2rJNUDBdF
	 /RVB0B990cDS7UqjAt/RmPrYDYc18+PIV1TzRnPghaQoRZxQ3+XOmnlO0ddsx5k5uh
	 lZgsV5PNoakXZNf2u+e+foMImznsvWLkdq/gFEC+72yuohnaWjg6kknGdjt1z2DhMt
	 cHPugJtnfp4VjX28rqBnrbp/LGgUtNxY40lVD2JHZlkmjHcjHmKj5V4wAo8RCb9+RO
	 zL2ahAR6vF8yMnl9vPyWUASy1HqBNY/ML2wj/1Nl5u3m1Uztk5FsDTWAC88g0eTGSd
	 C0dd10UcZHl2g==
Date: Sat, 15 Aug 2026 02:26:27 +0800
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
Message-ID: <an9d0zxE5J8txxf6@XiangdeMacBook-Pro.local>
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
References: <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros>
 <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
 <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
 <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
 <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
 <5825b5c2-06b3-4358-91b0-d7bf437528a3@roeck-us.net>
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
In-Reply-To: <5825b5c2-06b3-4358-91b0-d7bf437528a3@roeck-us.net>

Hi Guenter,

On Wed, Aug 12, 2026 at 07:25:50AM -0700, Guenter Roeck wrote:

...

> > > 
> > > Thank you, that seems to work (despite still seeing the warning on m68k,
> > > as NR_CPUS does not exist).
> > > 
> > 
> > ...
> > 
> > > 
> > >        $ make ARCH=m68k allmodconfig
> > >       fs/erofs/Kconfig:137:warning: range is invalid
> > > 
> > >   Warning...
> > > 
> > 
> > Yes, other arches shouldn't have the warning because I think other
> > arches (including microblaze) defines NR_CPUS in Kconfig, except m68k.
> > 
> 
> That is not entirely true. openrisc only has it if SMP=y. But it still
> does not generate the warning for some reason.
> 

I looked into the documentation a bit
(https://docs.kernel.org/kbuild/kconfig-language.html), especially the
following parts:

 - type definition: “bool”/”tristate”/”string”/”hex”/”int” ...
 - input prompt: “prompt” <prompt> [“if” <expr>] ...
     and "If a prompt is not present, the config option is
          a non-visible symbol, ..."

 - dependencies: “depends on” <expr> [“if” <expr>] ...
 - Menu dependencies ..

and I think that is true, taking openrisc for example:

config NR_CPUS
        int "Maximum number of CPUs (2-32)"
        range 2 32
        depends on SMP
        default "2"

which can be transformed into

config NR_CPUS
        int
	prompt "Maximum number of CPUs (2-32)"
	range 2 32
	depends on SMP
        default "2"

which can be then transformed into

config NR_CPUS
        int
	prompt "Maximum number of CPUs (2-32)" if SMP
	range 2 32 if SMP
        default "2" if SMP

so if `SMP=n`, it's equivalent to

config NR_CPUS
        int

so NR_CPUS symbol is still there I think (and its value is 0.)

Thanks,
Gao Xiang

