Return-Path: <linux-erofs+bounces-4550-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5540CC88E56
	for <linux-erofs@archiver.kernel.org>; Sat, 12 Sep 2026 16:17:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hhxQW6PBJz2xl6;
	Sun, 13 Sep 2026 02:17:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789229859;
	cv=none; b=jZaEeCLxAyDeQYXVa1zwS1FrBDc+FK+4e7LrZPIhA5t3QGO/jvUAj6P0iu07DY4HL0SxE+Dh6AbKT5fh9qhDROIhkob75bmOfs5BGAc6JXdVX1JT5LTuYMRDzMkTYY8q8QWb2RuLrWCq4rFReh/QM0vXW2KVFVz0qDkzOw4vRhYE5CHXwVRyQms9fgpsBp2mYQm9/DxTMcNzupI28pRGk+HhDlC1ni5BDdrXhoK5nT+aoJ+dC6fHtzE4QOr4s8zRfB3kkhGVPyM2WrNkSsswktohTjC0eXOwJQlw1wkvDwEJudwHppL7i8deTtrTKokyET8TkEPVrhyRea3E2EQsNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789229859; c=relaxed/relaxed;
	bh=uZN626yd30FEpVwVqFda/2a31Z//LOAzQuj35O8XFdw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ozlDYU4QsHpRp9xEN1K/3XMP6Az6UGIJOAaVnEWglPI6igiAG/lnIB8hjkd/LJX3aIo9X1wQbxpxXmsLjImIUgPmVu1WryKkOnZtSZyhWD2XKmrsLswWRQrPNCpABZh7JP3+3B9YSrcSCUGM+bdfrJQQULkAU4AzppDzAnZxoAvgOmjNRBYApL8cYDhTKp8Asp/6cwaHfs40o2gJagQl4bvY2J/G6dVEn61Ye1CRfDMXzWvMZLheSiuX1mqhqvGIDTpglVJaWCxtwYAQX4K1fP0oVxxdL9JhZ8Kn0SvHRB2O0sVT5X45IXbuLWRXvqmeGHjyfIfHk5RIm8ap92Mg4g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F+ca+KOB; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F+ca+KOB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hhxQV72rBz2xfj
	for <linux-erofs@lists.ozlabs.org>; Sun, 13 Sep 2026 02:17:38 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70F8D4391B;
	Sat, 12 Sep 2026 16:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5224F1F000FF;
	Sat, 12 Sep 2026 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789229856;
	bh=uZN626yd30FEpVwVqFda/2a31Z//LOAzQuj35O8XFdw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=F+ca+KOBk54/wnxGzdPP8uvnNGQvYIEbQNPowUIvC+i9d6cNDbxXBl0W1nFiwaoOW
	 eO+WdaGZuysMcHYBJnqZfAerTCF7aa9LXsth8VuEf5ZBuhjlVlPNDkt4ClzEjn+Sv/
	 +rwBOnbXS76ICzWrsM1beq2MZy7xQO7NhgMX8brKorvXNqocV010Hf9MfJBUuTrbWi
	 w7MyZnShkHzwK8kVvWyqDR7NmUjVTykAkBw9xTp4Trnlwimesp8Qie3gpRNfVXNwYP
	 CfFVsiKEA71kRSOIT7xduNlWq+KfFUoXhr8HF6nZc2a6KhknviehSAuFMb2U1EWQV7
	 l3r44S7V9PiPA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0DEE380820D;
	Sat, 12 Sep 2026 16:16:33 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.3-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <aqVKkkgDZCBO-0Df@XiangdeMacBook-Pro.local>
References: <aqVKkkgDZCBO-0Df@XiangdeMacBook-Pro.local>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aqVKkkgDZCBO-0Df@XiangdeMacBook-Pro.local>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc3-fixes
X-PR-Tracked-Commit-Id: 135d84c66f85426299db01a09d93a79a87af18ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d85a45df03118ade0eb34486fb7948bca17acf8
Message-Id: <178922979252.3530607.10384746269709132317.pr-tracker-bot@kernel.org>
Date: Sat, 12 Sep 2026 16:16:32 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Jingbo Xu <jefflexu@linux.alibaba.com>, Nikhil Gurudasani <nikhilgurudasani314@gmail.com>, Chengyu Zhu <hudsonzhu@tencent.com>, Binglei Wang <l3b2w1@gmail.com>, Chao Yu <chao@kernel.org>
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

The pull request you sent on Sat, 12 Sep 2026 20:50:26 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d85a45df03118ade0eb34486fb7948bca17acf8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

