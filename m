Return-Path: <linux-erofs+bounces-4265-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BF1C5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:10:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQkMM2Nn5z2xT6;
	Thu, 20 Aug 2026 23:10:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787231439;
	cv=none; b=mOC/IHTpQHFkhs4P4MSwQqwEldPp8L8Qt6jKN1RJvxfbJGXJU6p2CR2nh37b3wH8xd0KNIIXf5LyVTOuResS7r706NjEnNNpCgSJisEZA1uShcGmhbRjRel5fns9Z0CUsBAESbpuzwjCFoDbdTD2vKUzYtTgAh8DSR0wTeXu/qW0ei35AJPokTxXq67AHIyXbrGQ8zGzh8PJLC4+F8sbTllF67oHuCL3XLt6nCKBKSNRsH99Z6nIntufxRyiHMokpgWI9RsKTj1F6GJV5X/O5+mGErXE7Aiu4D+BSw0EedqScCtN8W/CgFY/cysTwEAAYUOoScF74qbKYl2Mwou6Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787231439; c=relaxed/relaxed;
	bh=3fRmigEw7qmFQY4eu/xZ0xLHtznc2W4nB8FZd9DSCys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmiGTUUHgaxfJuL2i7H+KTMJc2WoM5hBKACxj4T53HWgXlY5XdRQXrWCQZOyPk6cBgw9SvxzkqqFkWgndH9nmvig//juZHHRHcj7afwwPNBSlh7CFpax1ANKiYwHUeJ0lmvcxgfaa7KxL4ojdAnoC6VeTSCJ3prV9SNhMWyUfUrs0/PiP0t1zDs5FKSdYfEQA2rAuGK53swvfcjJ8irUs9sVwjckD0RX3Un5O09pS9lPSYO3PvJfhEaAA+mrgcNDyImyGz8K7BxY7lqSlRVNKcX4Lw6IXsBAUjgaotJQ7tHrRZXjw/NgbqbbCHt+LJkH5TUF+ifou/5w+AMe1K5yGA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oShboYWx; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oShboYWx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQkMK3XQYz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:10:37 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4EA660A63;
	Thu, 20 Aug 2026 13:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3EC1F00A3A;
	Thu, 20 Aug 2026 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787231434;
	bh=3fRmigEw7qmFQY4eu/xZ0xLHtznc2W4nB8FZd9DSCys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oShboYWxprDqsqk3dvye3hwz6sMF8/sOWXUoYuRIKZFI0D4bjFMIys93mnlmnleRq
	 tcETnFQVfXaEnFwy0Kgzgx3/BMXnWRthzmPJCkQCNAgrD2YQXfdXYxf9oGbSTN8Aeh
	 R5SYmeQnxlxsl3kW27j7t6LpATsosHotRsUdsKacyNYvf8VBcndbmYND9OCSflelNZ
	 7y+e3WFYfWezFlIXDeaLhA1hxCfoTIhlqQPPrzBQdcfi6ik69aUp0KzQ2wQRF7ayRc
	 lPNyCKlZCrCeFRl2oNdbxA9i5hUVPmJdqqXHg37nbpDhW83rRz8fRl7MW0tAP+d7gZ
	 nWXhrjQK/me3w==
Date: Thu, 20 Aug 2026 21:10:25 +0800
From: Gao Xiang <xiang@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
Message-ID: <aob8wTTSCuq5054v@XiangdeMacBook-Pro.local>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
 <3d845134-9b75-40bd-b221-2bd35f98d425@roeck-us.net>
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
In-Reply-To: <3d845134-9b75-40bd-b221-2bd35f98d425@roeck-us.net>

On Thu, Aug 20, 2026 at 05:51:08AM -0700, Guenter Roeck wrote:
> On Thu, Aug 20, 2026 at 12:00:23PM +0200, Geert Uytterhoeven wrote:
> > When NR_CPUS is less than 16, or when SMP is disabled, the default value
> > of 16 is invalid.
> > 
> > While actual configuration picks up a sensible and valid default
> > (NR_CPUS or 1), "make savedefconfig" will still write a line like
> > 
> >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> > 
> > to the defconfig file, even if that matches the sensible default.
> > 
> > Avoid needlessly enlarging the defconfig files, and reduce churn for
> > updating them, by specifying valid defaults depending on SMP and
> > NR_CPUS.
> > 
> > While at it, make the prompt depend on SMP, as there is no point in
> > asking the user about the maximum number of decompression streams if
> > there is only one valid answer.
> > 
> 
> Absolutely agree.

As I replied to Geert, unless there is a mandatory requirement
documented that "there is no point to make a Kconfig visible if there
is only one valid number".

I tend to avoid making EROFS Kconfig visibility depend on arbitrary
architecture Kconfig options such as SMP or !SMP; SMP here is due to
some arches make NR_CPUS = 0 if !SMP, but it doesn't need to bother
users why a EROFS kconfig visibility has some relationship with an arch
kconfig.

Thanks,
Gao Xiang

