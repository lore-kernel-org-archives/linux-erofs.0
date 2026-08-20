Return-Path: <linux-erofs+bounces-4278-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49452C5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 19:57:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQvPB6Thgz2xWV;
	Fri, 21 Aug 2026 05:57:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787255870;
	cv=none; b=eVO3oMIRf8xjTmskdjnkfSJ576movaP5DxnNLiKNPjO9E5Wy+AIZgpaQBR9wfA5yceW3uJXo+sj2tZHaal3LKeIRb1Rf+OBQmQNmgJ/F7VktWhGGH2VUp4X8QT1wdA5AamEobCt5fLyZJWJ6h+aaAaOAQ1sAXZlbdiveyvcFV3zYjg5Oms+GBm8Y2x57KE+fhyo/CBmkO4hPRl2eAlH3xZEttEmYbWf9NXQW1yUp5AprXD2nevS2q5pwoDi5JbVV7DuuLoPEmaLIUN3q1JWe4+UfEZ7fkTKhom7IlD0VHe1Ri62AFqL15A805CNoP1rQO0WSaUmKOgZTT9HOvobxtg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787255870; c=relaxed/relaxed;
	bh=oz1kcuJf+6c/WeFMyr4aa6wy/N08GN1ILirUuAAX280=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=R7FVA2Zoj6Ju9xCEPyM9Rc3aWiaStJ69lrcWm2Zeby3nlo+PcUzJWhBmVOg2U/i0ayux+tWxfwn2W45ItKOPAtni4cOxaOTAXgHBaUBpnbh1mQb0gdp3ynDRQWus0fx0vVB28UCPV8iR0rxg0AoXzKjgAmWLYCNvjkhAAutHnCQDNrVM5kynhRwNH9bnGEdVtwynxXW/NzZkpDFgIetF7D1hkE0lK0wNPAq9XPUy4xuIm8GlikFtrcgi1vQnFWlu2FhugzUx4s3CWFvDb+Zn5uthJLiVOAyVDEXUjxKl2hWbKNyv81S/Gl6MHgRcGXu5577DklA4CqMIdN2rprhurA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZP/n3bU; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZP/n3bU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQvP95SnSz2xRw
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 05:57:49 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70AFC60A58;
	Thu, 20 Aug 2026 19:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290B11F00A3A;
	Thu, 20 Aug 2026 19:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787255866;
	bh=oz1kcuJf+6c/WeFMyr4aa6wy/N08GN1ILirUuAAX280=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=WZP/n3bU+UpZzWz1nWW5TqF0ZwFDt1uUC6QEdY/BkRoLle4HRRXfNsJ70RP9r+jQP
	 PDf8OGc+//YAvXlEblUFvXGc30p5Rabo+YejZwZ/ngb3IRg2yBmXUGYcyhRmabvnt5
	 wxp8seGAvBkYBEq3Xomw5LD6pMX3Jyf9lIgYTZCB8HNDYobMWGQ9JySs9VS7NiteQs
	 1K3jLfBIDfMxcngaHNtN2yqL+1qvs0tG8wKVZChm8VQvDG890uXSm345dMLmTh1KBH
	 Dlu+VpvfxiuxRAez7SlUQl278oQR5Ssw1l2UVnJQGHtWPKkAdYtX72z5t/jTn/2xd+
	 7QzlhZ5Vjv+JQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939A8392445B;
	Thu, 20 Aug 2026 19:56:57 +0000 (UTC)
Subject: Re: [GIT PULL] erofs updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aoPTUl2rn-iIaXPy@XiangdeMacBook-Pro.local>
References: <aoPTUl2rn-iIaXPy@XiangdeMacBook-Pro.local>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aoPTUl2rn-iIaXPy@XiangdeMacBook-Pro.local>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc1
X-PR-Tracked-Commit-Id: 988c3c186c730590a71df8adc1424c5578ef8bae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8f421dfec2347c67f5f8c261fbfdee407ac5e20f
Message-Id: <178725581632.459220.9668752703745289931.pr-tracker-bot@kernel.org>
Date: Thu, 20 Aug 2026 19:56:56 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Giuseppe Scrivano <gscrivan@redhat.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Chao Yu <chao@kernel.org>
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

The pull request you sent on Tue, 18 Aug 2026 11:36:50 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8f421dfec2347c67f5f8c261fbfdee407ac5e20f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

