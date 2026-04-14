Return-Path: <linux-erofs+bounces-3288-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FC63F531DE
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Apr 2026 00:30:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fvlYQ5Z97z2yty;
	Tue, 14 Apr 2026 10:30:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776126634;
	cv=none; b=d4d7o0hGsqpiG0P8FrJCAybA3Cw5dEgBKGlFx4pOPrwDetJpDVVMobWmwB8GpBsywpXlB/FKxyLwYvxJJ5QCZ3xMFWKU2GtHs+JkOxuFT7dK8JG9h33bp/DgWZo03arPOq0hq7eCDf7tMmnvDiDmDEMTp/q9KiKgGA7lgHgN9WoICa3e2EjLksfmtpff46Z6hEYbW4Fke/xkxqaRCQfzAEPOz/Pe/rtlg7079IjKvUzAp49QNkOfoU7tHazyqnAXm5SogZRR/jzQDMwHbJa9maxP+nIUsNKZhGDSP9LkFLhgY2ZHpL5FZVtoV512Xo2RKXl5gpgruO2elY5J36PMSA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776126634; c=relaxed/relaxed;
	bh=JFPmNa7/W8pO4UYpoWAfJntL2dPbeG8MZ+z4zePEgR4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=glAZfz7qix38WOQID41OynuKV/Q37QxFxBnCevcwOppYFMCKJ27z0NH2yBWkVWCKfCHYlRg4tLADlyt1mfpywZW8rffczGs1frwJoBLmpy+A0jsTuf1hXrnXqTGr2JDFLg3WBcr8izBCnlwHZ5qY960j3NNn7IsCpppqdreHonlrbRibGXiRjgTFP+7L446bfihaJO+VfdY5H4HfeFLGfVyACZJJYnjuKApX05xM2khPuvCQd5u9aIGpsa8n2ATtGKTAwtkmXEdnRQNjh4SKN0tElRNh7hH4carC0QAAKbzTrPlz9AEJAacetwNSEdiuSMQiAxt0tSVw28wTKr/isg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=G6vn7MWx; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=G6vn7MWx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fvlYP2ZdKz2yrD
	for <linux-erofs@lists.ozlabs.org>; Tue, 14 Apr 2026 10:30:33 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C81DA443E5;
	Tue, 14 Apr 2026 00:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A990DC2BCB4;
	Tue, 14 Apr 2026 00:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126630;
	bh=uBjFxpeVeWNLhwcAizDWHwxtoX9sAITSs8yykiRci+E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=G6vn7MWxFEt5Li46/EemKBBnZLseRujRd6O9cvvfr4qBJNl6VmVKse3/+0WKI3O3O
	 FXwL2oxWqJbKadMNe6YWnZZsX38Jnvm8l5S+YzTEJTotvK4MVUGVZUBRj7PAfm0VNd
	 RRUfmYR8MHgAaLoO2jKF/UjX4KUjc7Y+A+oJ3tl6BKL7UZitR8GECFZO4d6WdZp0Eq
	 ll/AW+aptatOOemN7Cha1mG7A4nTcYMSCiPC89qn6h6ArykWJ2QbBjWz6YuGBDe3lT
	 TFMM7tI1xmH1kUIV1ctmP1wIf4qZ0VwxmcCOwmlMxmPzfwwVQLcpgitObAjeu+Ihzz
	 kO/EvFa4GDmAg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02C763809A0B;
	Tue, 14 Apr 2026 00:30:03 +0000 (UTC)
Subject: Re: [GIT PULL] erofs updates for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <adx1dXEp8xyWwgZ2@debian>
References: <adx1dXEp8xyWwgZ2@debian>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <adx1dXEp8xyWwgZ2@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc1
X-PR-Tracked-Commit-Id: a5242d37c83abe86df95c6941e2ace9f9055ffcb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 230fb3a33efd52613910a3970495b20295557731
Message-Id: <177612660162.618768.16469525564658132170.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:30:01 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
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

The pull request you sent on Mon, 13 Apr 2026 12:47:49 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/230fb3a33efd52613910a3970495b20295557731

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

