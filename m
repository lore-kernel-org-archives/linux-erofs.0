Return-Path: <linux-erofs+bounces-4272-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A15C5DF85
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:43:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQl596LQmz2xWR;
	Thu, 20 Aug 2026 23:43:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::535"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787233405;
	cv=none; b=Ko2zo0r9+7764gPbQ8pNRYZPoUcHMIbaX5U8SaNJC50CmUBjgYhKAKAz7z77nQ/g9dL7I+Uaka3Q9VJalERUjwT/lLg7KxAJE2dYL/EVKtwMduNyl6UJcqhUAYEm5ZyYy0t65vj6VMzAofAJHxZue5n1RE6fOVo2xnRMRDpJxUpUgaZXOGsnaJsCD/NhbaqKnepAveJH++uUnZWPM06FstO4ZkV6cYYBHjMfeHTHcbdIybwp0Y/BcqxsKxAcewJMsQ/NEoCRL7Ect+R4lwCunymmPtr/NE8EtFaVym3iNzRppWy+DyeFfC6a50zNb87+hHo3XGPLqA1iefAMBUYAfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787233405; c=relaxed/relaxed;
	bh=7hzWmEatSNCCp8M3qWDnR9FsvSVF0djGU28yHB5R7PE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipeQmRS7JPc2Jb5ZByFqw+tUnGefjATGZaswm8sfJdqKsS1PrduuhKV/FCeI3WZmGQu/sTPKpIqjmvl7RHD75km8bZXNY+vyHUj6kS2a1iL9ayr9sQvsV9YqoPTHaKAB/y8KD603QcohsDhqnj23byH44kgV2s43+FZhDU9yKH1sCutMWQ0jxBFx6cdqKQFXUsl5zoEpE0bbbyJuaXQE5Q4q2M04vRf3OcN0krZjyo0fSxRMICnUbT0sfZ2DAgIJEIdp9vUfh0FB1yJqfWLHbDdP5SJuu7/QEPZyE4r0Yh03E/wMn9UQUSS98sjzLOejQ8BOxlMQd5M3Gbww9tG3wg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EUz4FtIZ; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::535; helo=mail-pg1-x535.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EUz4FtIZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::535; helo=mail-pg1-x535.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQl584ndPz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:43:24 +1000 (AEST)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so1229277a12.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 06:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787233402; x=1787838202; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7hzWmEatSNCCp8M3qWDnR9FsvSVF0djGU28yHB5R7PE=;
        b=EUz4FtIZHDi2tSuyQ5H9prt7bRa1HMSuJjp3gSuSfsP2a+zHsCxePZ9F3pAyazaiXO
         J8uMrBX7TGzmLcJ70rtntmLI5shuYweyYHNyBzd/AuEHdQk/OhMlw/hc0lN1QC0QowXA
         mvLZy8EYK+OcGkDA5TQa9Fe5Jao2DDChSITjEcqCry7YArFeN1y3VA6hUj3Hy5XfcNHE
         /+NvOkWOzALfVtN49/r3TX5MSf2wG+kf+BhfmhvwzWtCWCvGTmGHTK9/P/qnsjhBBDED
         /V5s20EP4TcPxhBiObPllQJhJwFuLD/C/S7rSedWHphLE67e6ocIy8L9z+W8VQ5CEbDe
         BYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787233402; x=1787838202;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7hzWmEatSNCCp8M3qWDnR9FsvSVF0djGU28yHB5R7PE=;
        b=YzdzoueWEDmzOh3ycUNXjoglQKkDfseqd3K2GNfUtWVZ6mpfBkm/blFvBaxwtfRM7e
         M8x4NgdL39xkKKzcVCTbrqbBdkd99Hplx052K/0CE64/mMe7WcDTChpz2ErZ/5t9II+p
         jrBrYbXEeYaBBrjwvrureG8HnQBm3R6Ex25nWLt3CRxWv3HvqD6It06UEgXvBcWQs7Mf
         /aZGgRCuKQA4wrhvYQ2OBpei6ckQJVM/KJ2dLXFXP4JtO1SnahCbb93O0gw17JwYzZHa
         R1R3u+SNe09JcXHnBGHP0fRYjB4XUoupWQlPwHYsiSWZEzhWm/Z/8pTekK/PKB8l5UlN
         B9PA==
X-Forwarded-Encrypted: i=1; AHgh+Rqvw0mVA4+vH6ALCThK2NJyFTq+RIANFGb6AqjsEjjWOCebV48DqpqFSrI8/TFFZpWIhmgwtUUh7757dw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxIH7Ck2EkrxOCz2W24CqBJpILKLxl++VQGrvA6PAQ6mI+3rbfi
	eH5Id10FfYwN1rG9101MJPIT7qzOppB5QEbwjLzczmvuKV6Do5t46r1AEttT5A==
X-Gm-Gg: AR+sD12L5WgLbr3QlITNWG8le4JlHCPWvEAhQ0Xw7qFhFajnutN7yF7JFWGzNMIUAjn
	fI0E7AQNi704CkgFd9TYUkZTevsPwMVucjDAdLHm7O0IZn8EZAlcgXl2CwKeNtZ/TcWmoTZt83Y
	37evG5wbBvu2xEe15n/67U4hsVLUwk5iOeRSDbP4apwJQn30ec1Q5IvGPCoBE8w9IvNQGYTqP9C
	uTYDhwCK+f3GUaX/bqLJ4rd2Yq1fYmpAuXdtA+pk9Qd1u6VAiDhVgNBU9Rg1/4muXvkgnEwZYdD
	VG2MRo1P9OVDpU/5ta1r/XCFlfm7c3kGvUFmOMha02zplWEO+568ZCv28FIclRDuUXcbEGjCNw/
	5P/Ckz0KTJ0elc0/Mto+J0VgNCpwKBctRxhDPYestt2btJB0H6WPAiNeLQGcgTF9PEor0CuvO6+
	RSmW/OHF8Vl3fh1g1BLheMPWnwDfAZYRHpr6BNUMuflK2eI2NLkj8r3rx+tIGqZeb1l7p8p+Rao
	g==
X-Received: by 2002:a05:6a21:9991:b0:3cc:3d08:da3e with SMTP id adf61e73a8af0-3cd00e0e43amr20711670637.2.1787233402074;
        Thu, 20 Aug 2026 06:43:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c98ba384sm12480960eec.30.2026.08.20.06.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 06:43:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 20 Aug 2026 06:43:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
Message-ID: <b56c6945-df2c-4532-9c3f-711cad5f6174@roeck-us.net>
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
 <3d845134-9b75-40bd-b221-2bd35f98d425@roeck-us.net>
 <aob8wTTSCuq5054v@XiangdeMacBook-Pro.local>
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
In-Reply-To: <aob8wTTSCuq5054v@XiangdeMacBook-Pro.local>

On Thu, Aug 20, 2026 at 09:10:25PM +0800, Gao Xiang wrote:
> On Thu, Aug 20, 2026 at 05:51:08AM -0700, Guenter Roeck wrote:
> > On Thu, Aug 20, 2026 at 12:00:23PM +0200, Geert Uytterhoeven wrote:
> > > When NR_CPUS is less than 16, or when SMP is disabled, the default value
> > > of 16 is invalid.
> > > 
> > > While actual configuration picks up a sensible and valid default
> > > (NR_CPUS or 1), "make savedefconfig" will still write a line like
> > > 
> > >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> > > 
> > > to the defconfig file, even if that matches the sensible default.
> > > 
> > > Avoid needlessly enlarging the defconfig files, and reduce churn for
> > > updating them, by specifying valid defaults depending on SMP and
> > > NR_CPUS.
> > > 
> > > While at it, make the prompt depend on SMP, as there is no point in
> > > asking the user about the maximum number of decompression streams if
> > > there is only one valid answer.
> > > 
> > 
> > Absolutely agree.
> 
> As I replied to Geert, unless there is a mandatory requirement
> documented that "there is no point to make a Kconfig visible if there
> is only one valid number".
> 
I would call that common sense.

Guenter

> I tend to avoid making EROFS Kconfig visibility depend on arbitrary
> architecture Kconfig options such as SMP or !SMP; SMP here is due to
> some arches make NR_CPUS = 0 if !SMP, but it doesn't need to bother
> users why a EROFS kconfig visibility has some relationship with an arch
> kconfig.
> 
> Thanks,
> Gao Xiang

