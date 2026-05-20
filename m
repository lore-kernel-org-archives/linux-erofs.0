Return-Path: <linux-erofs+bounces-3472-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C442CD5BA4
	for <linux-erofs@archiver.kernel.org>; Wed, 20 May 2026 18:23:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gLKfc6Znsz2xqn;
	Thu, 21 May 2026 04:23:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779301400;
	cv=none; b=E6ILXJew4p5Rq5l0sqCreMCwrPn7RD3I1A2vUAc+1JfW2ZkVtkLGhzSQyEpMwJMwAQEkUp5szjpHpbAu+X/d5CGJHoB3p3GlCFMEdod23+PSrRELLXxHLaZ71sn1OxfO1eOYwbNIAFmKqEEQ5RtLWGa8uLmMF8021BV57U3fqeCvQho2K7yK5RyiIMQpdTkx5KHg/6wFlwEmA1lYnRUKbXN7wZY3bi12LYaHnSEjdcAmQM3hOShlHuH4DXuWG2KHy4RxRrD4HTmE7L00T2Q4nI83+jhP/nJmuVfliMwu93oKAThqgaLMVZ/USfBs/9hUQ4dOprkS12PvIzIws2ROkg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779301400; c=relaxed/relaxed;
	bh=sqXudUafwOULTj51c2tC3LP1win5y4CagsmdoNDxkIw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=caCGmmJ5C27M+Y9QNOhTVLt4JMAm3nOvta74I48+ivjK4+e0JZatZ1QtIm1bJQP4O/yQ6GsmK+o9lQwjANWgla7j5hknnaymekXEOhdQ8MJv5tuJma5SXD9vsu5jCTfScnTw/sez/acviavUp+ckAeAIeUz9urse6ibJX1rOS5Rcx6x2k7+mUTHHqXemAWsAiW5BWvTAJX4s8VBglMPwMsdRkxprFDaBF3j1tskMiNU1Pwy3AIYCfBFxOsOAqI+T494Cv0Qj5hgFOSBaY/xfNk8KNlHiAFWWkr9ypHBUlvt1woKH45SkeCHeGQ6FvejSu8FrlmR1UkUjizE5TqIe8g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEJMtYCK; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEJMtYCK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gLKfc21cGz2xqJ
	for <linux-erofs@lists.ozlabs.org>; Thu, 21 May 2026 04:23:20 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 940FD43E28;
	Wed, 20 May 2026 18:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E141F000E9;
	Wed, 20 May 2026 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779301398;
	bh=sqXudUafwOULTj51c2tC3LP1win5y4CagsmdoNDxkIw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=bEJMtYCKphn3tupAAWDtL2wRydPz3e8Q40b8r68I43AYt3jV6lJieOfzUTFfkfsee
	 OJnLxrL+zPrXdRdPCQaJ4FosVwExhVKXWZdkeklbxLmrS9EBiJZzjQJwYV5PWg1e43
	 JZZTlK1qyFcEgMFz7XaV8OBrKArSHRO6wLnm7sWLVkz2ep0KIyX/lBQp4VKT5NMEgc
	 v9IQkzH47g7PaP1siqeswuw7o/txKU8FurI/3yxgBGriNcH8OFpAd/LsDC5xARo2lM
	 gEghdXaCx3Rv90ZhVrsyLaeky0Zw0gpnlM21qHnaJ52PLP4/cS3am4vfuvleBruKSr
	 sgx450pPsoERw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19ACD3930B88;
	Wed, 20 May 2026 18:23:30 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.1-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <ag36l_9ijbXM_fgx@debian>
References: <ag36l_9ijbXM_fgx@debian>
X-PR-Tracked-List-Id: <linux-erofs.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <ag36l_9ijbXM_fgx@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc5-fixes
X-PR-Tracked-Commit-Id: 79b09c54c6563df9846ca3094bcfd72082c3e1d7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8bc67e4db64aa72732c474b44ea8622062c903f0
Message-Id: <177930140866.3701530.15756755450472077362.pr-tracker-bot@kernel.org>
Date: Wed, 20 May 2026 18:23:28 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Jia Zhu <zhujia.zj@bytedance.com>, Chao Yu <chao@kernel.org>
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

The pull request you sent on Thu, 21 May 2026 02:16:55 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc5-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8bc67e4db64aa72732c474b44ea8622062c903f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

