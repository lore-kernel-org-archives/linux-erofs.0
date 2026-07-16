Return-Path: <linux-erofs+bounces-3928-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6289C44512
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jul 2026 17:26:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1Khq1R5Rz3br2;
	Fri, 17 Jul 2026 03:26:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784222795;
	cv=none; b=TERXbn+exyPfGKDySscCnP7fXMtBIuAl6oRk5RMjfCA58jRHg7uxUxlYUjy/MNf1BhSRMxNWKPAF8If7BX1C/hWsl9FMVc8BjkZN1e/1sQIEEiBMlxzsiANW/UI19WUOuy0Q/UUPNahP7vQtLKSHobZHXgbA/rtUhHBpHVsrlqeevowaivzW8SLboST5kqVFDTa0sD8EiYx5NwwiRcW2QhulJnd5+TBIAgP5nfJuLsHVvPcRJAIat2Dqc+YMfZ80euT+lV+jf/Rf8W+9Leq8ZS5eseNa42TLDLspWqfF+2Ih8p2jJ3U/H+4eXJaBwNxEEOvC/jw9EQs1KnlFSS1H/w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784222795; c=relaxed/relaxed;
	bh=hF5oMM/DGEvoc4fPGoiWJVWQ95c2+RryZefbzwo16Q8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=W3de47MSrgIYI4esmJS6D6g7fh85OPsMVw7yedgZV69mi+CFiDguNtTLxmz0oGe1Yb/sqmOB/kdAHbo/fgMGsuzqb0xpsd5QwNJ2xsh35U5vpdsTLov8z2cr0vC7aU5yfTWi4H7q/xhDt+lC2C4Usmuf/kkZehIALoNLuZfx9zP0uoKqJ7snvV0YssY/fZEG2O2BOrdAXFs0yU7SH3wUSv0ddEd9zcjHEeJuu3YOcalTooTgRflIprk6q+9FKyTIaL67iYW/hzZYqjKvruahvbBm/bZ19FJoSFFxnCNSfSjHavhY8KxfP8/Hx8tgq7t74+cjh1uhQLrFRJPsUe1j8w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kufePSp1; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kufePSp1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1Khp1NG0z30FB
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 03:26:34 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6585260A5E;
	Thu, 16 Jul 2026 17:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130661F000E9;
	Thu, 16 Jul 2026 17:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784222791;
	bh=hF5oMM/DGEvoc4fPGoiWJVWQ95c2+RryZefbzwo16Q8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=kufePSp18iRnaRzaXEBVvSdH7byzZ5bq0OpvGmFktAjVwMGHo3rBEY559A1+baUKD
	 Y3ase3qkIKuyvwTWLFAONzQJLV5+8SP/UnXshUmtWVz1jUik6jBoHL7+iNlIOcqrWD
	 degGdbPSN46+N0GH9gdXHFOAglNJ/Odwrwg61pUrJ1TWiYZf/bTPI92Y2RjU22MWZz
	 RH0pvAYbd8V0hzUxIgYVTOjsmd/15UzPHqeYwyL/+ethb6e+iyqcPCMS5TsHM+U69n
	 8PTNJEBxL7GR7X8cvbv9nPsDK+8IkQZmFkthP+YA766xS3bZk4jsnehtJQ3/6IPuo8
	 Bc6iO9reW5LZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56EC43809A8C;
	Thu, 16 Jul 2026 17:26:05 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.2-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <aljmGezzdz_pJy_C@debian>
References: <aljmGezzdz_pJy_C@debian>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aljmGezzdz_pJy_C@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.2-rc4-fixes
X-PR-Tracked-Commit-Id: 1572282de6d3377ca8605d48c50df3a8c08468e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 133fc7aaccf61b0d29f61b37202d5812da5dc03f
Message-Id: <178422276397.1357537.1097268869644410758.pr-tracker-bot@kernel.org>
Date: Thu, 16 Jul 2026 17:26:03 +0000
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

The pull request you sent on Thu, 16 Jul 2026 22:09:29 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.2-rc4-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/133fc7aaccf61b0d29f61b37202d5812da5dc03f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

