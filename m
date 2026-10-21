Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C470606A319
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Oct 2026 03:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hXL/CNPu
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8Yy20Xgbz2xcB;
	Wed, 21 Oct 2026 14:03:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792551801;
	cv=none; b=Pz1sTvpYjT4kykZfuHxiIhJjkWMyIZcD9hZarvuFuYHH5IkcSACOA8hHwlfeKLdtbqVQa0rsiPclLK4p2U2c+ifBUPJEKzPk0afb2jXlVeo0cgjgKGXP0amBztbD2WR0qr7+W+Z4Fs5XYs8NQYgXnIf4vsCeXd6L8pH5nXoJ4KrfNKg3Aq925tdq8zScsD57MVsfBg0EdQr+SS1RW2h9NgXO8pjdIV1Bhp7PG6Js1Lc0Tf7GTa3HnHVKyrmNI/5s9ZdudcQguEI0CwI/5twHWb6atSFYcZcTEKCO/okJBUv8lG0INV3OyOagJl/TMVG7bqIZDSvFSz6kRPitq9QWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792551801; c=relaxed/relaxed;
	bh=oCfcfQS9oZIfhbFtahLoTFfPgh4X/RsLplRbPeoMUK4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fE0/MAkV1Gbd+OgN10OwitYWbOeus+c6rsr01Mq8DO3mdN55WHxlykwIJ9wEoE3BamJUkR3wZasQyKJqGHh9EKsWReCLnUw/S7hKyXPguAcxNNok9M0I67S5p1H8WhXYDcwvEMyZCU3F5usyIJbkGJ3WU6fzF3WXKgN2eghOt82Nc6wIH1dF9K/h1HYs0w6lsp2/Zcu2zaNp2CV+4VjHOWEXYEYpFGebjxZH3lFL5A74igB7yUJnxBxcME7dGOgeTcd1SI/KAOiyHpFB/1cplACaoxRhjKGaI+sFXsBIB6pO+6q+xTEcxw/V57P+cFkWh70LOMktXG8yKHxE8/io4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hXL/CNPu; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hXL/CNPu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8Yy071xvz2xbN
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 14:03:20 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70A0360416;
	Wed, 21 Oct 2026 03:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FE71F000CE;
	Wed, 21 Oct 2026 03:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792551797;
	bh=oCfcfQS9oZIfhbFtahLoTFfPgh4X/RsLplRbPeoMUK4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=hXL/CNPulwjHI9ioXmUjO8CRWa6pipSpQ5U/uOIa6yjFcH2ERNxdK+ZTS5hiRYKXT
	 8EIRWy+vl6BozhT3obLOplIQ8HKcI3JYJOQwSU6yvw2cCpN0P3GqCOVB7ZjFq+Ddee
	 bbqz5I6aAobmohMNPXW58vaKb3KRn9dKdohqk0EdyZTtaezE4waMjmCorbZ/+lGhVZ
	 xcN/v/olsSmYKRIplGzzWBWS69O9biQ3Vz43T2qIV1NFkyo6SCMhAS0NXxKyTowpOG
	 dw4W3hYTRXctFBgbVR1OmsnLFjcrcaAmvfk52wxy5NNEM1Q5ycNvzZ1bWQhv5FHwRW
	 cmG27NJpQ19dw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A35F3809A18;
	Wed, 21 Oct 2026 03:03:17 +0000 (UTC)
Subject: Re: [GIT PULL] erofs updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <atZ5QThkCK8UnB28@XiangdeMacBook-Pro.local>
References: <atZ5QThkCK8UnB28@XiangdeMacBook-Pro.local>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <atZ5QThkCK8UnB28@XiangdeMacBook-Pro.local>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc1
X-PR-Tracked-Commit-Id: 1137aa577a35e2684e8046c3e53f920e79c7cc60
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7b9498b77066bd2a55f607e82a05b0888dde990a
Message-Id: <179255179568.353442.13679607997949913266.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 03:03:15 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Binglei Wang <l3b2w1@gmail.com>, Giuseppe Scrivano <giuseppe@scrivano.org>, Chao Yu <chao@kernel.org>, Jingbo Xu <jefflexu@163.com>, Gyokhan Kochmarla <gyokhan@amazon.de>, Christian Brauner <brauner@kernel.org>
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Mon, 19 Oct 2026 22:10:41 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7b9498b77066bd2a55f607e82a05b0888dde990a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

