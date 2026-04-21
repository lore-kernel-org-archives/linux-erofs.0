Return-Path: <linux-erofs+bounces-3353-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4A3F94CA5
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Apr 2026 18:51:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g0WfG4B6wz30Wd;
	Wed, 22 Apr 2026 04:51:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776797478;
	cv=none; b=kGKgr+vLvNgIyGCz6GAMYyLraWKfi81CKrSR5MtzcRuGknoBNSVyWUKGs87P4SDa79NzY7HIAgNBO5aER8XDKEoMUjjzJacdaA1fEmPy3GYoQ7EBqhKgTQS8CNaXSitdXIOVJkZZG0RPVr1BXMuhjoevnenGCvnKDS50fyhrStOUPyTv4V4uLvuKLfU3iimB4KNKah/MfP2c5AuozYGLrHvgPjsDMxiP905tKslpkLjEiHm8oKrhai5bvccBCi8G4ZnKj3UJOmgVHZ8OfLCoNk8bUd17IpXKeXo42UtO/HrypGn2IaLehCKQOF+Vv1H5O0ku5MEwyre1njAqq6ZQww==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776797478; c=relaxed/relaxed;
	bh=KQWQWBx+QxznavWUHrZJv5e3rYON/xJLeO9MwqUBjbg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eRpu64WKi0YjfMCzxyGK1yjtgEY+U3I+a9+iXSEYLmOodRjvOZuazXd985EOP+n8WL4VU7YdA12JGf+6iXayQRb2aka974o8/ttolnC1zS3WkLTaaUexSNA+P5zcHuhmj9qakR9SFGWGIXL9EfCxvZQy/FeooHaOG3Psen+lR2P9YSNs4yxUxo1gCkITYA+9k9KtMLvhK2bVrfTBNjsS9Agk6UEpIyRzIVer+zF64g4NUB+3rzIiSGDL9xzVF4eUSgD4fnWaRC0pmoXVDyI/B5lp/jZRtMWmqVJ52sbrWc4YwaYiH96cD93XRd6m/F21uW+gEy3uwn4U0K9XXvvIkQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=OufeAX9d; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=OufeAX9d;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g0WfF6MRmz30Ff
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Apr 2026 04:51:17 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF4B560126;
	Tue, 21 Apr 2026 18:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635A1C2BCB0;
	Tue, 21 Apr 2026 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776797475;
	bh=4RCEjv2/azz6WrMuVO79qRQR6r2JzxrV0RMGTZi3h58=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OufeAX9dtgXtnQFkP8R0hVqV8Agsgsgw9Zm0YBZYpIjF3fmB/+fXFj2NiEQ+kR+bf
	 432g6JdhXouifSFtJFWSLye7ZrmTVJVmRHztk9MlHv0WEfRi6rWMGzXbMiUU1htnEH
	 RGQqT5DvLyFyjOHtdmPO5jiPBqj7EetOZgUM/Vneg5lv7kLdQhZNMJZWXUkjWwPEGV
	 ZvdSQZIJZKRHMKA/q/P+vNKjiKj/QKKre0/QYi5Qp265aeBpwm84JJD1RGgAOaoCK8
	 fw61MclMvgYIpRfCTvYermRO0SBesQikUP6hlWtKsBo0bIDoe93CBgyXyXhoS9oRsk
	 1/0NtccMfBnNQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F493930203;
	Tue, 21 Apr 2026 18:50:40 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aee91ucT5PLdydIC@debian>
References: <aee91ucT5PLdydIC@debian>
X-PR-Tracked-List-Id: <linux-erofs.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <aee91ucT5PLdydIC@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc1-fixes
X-PR-Tracked-Commit-Id: 2d8c7edcb661812249469f4a5b62e9339118846f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6fdca3c5ab55d6a74277efcae2db9828f567a06a
Message-Id: <177679743852.2956451.9937340118178994423.pr-tracker-bot@kernel.org>
Date: Tue, 21 Apr 2026 18:50:38 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>
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

The pull request you sent on Wed, 22 Apr 2026 02:11:34 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc1-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6fdca3c5ab55d6a74277efcae2db9828f567a06a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

