Return-Path: <linux-erofs+bounces-4019-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175A5C53209
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 21:50:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8C2d5dYSz2ygh;
	Tue, 28 Jul 2026 07:50:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785189049;
	cv=none; b=O1NEH7rx7fdFyS69vW+W89LHvxUTna7YxmCKEpFtQnf2/mwYHSQRhMhCDW+/l0RQZYCvnWzuOJQySeCpipa5AM2I3mBGWHRdHE7XZ6/mejEmG8ST2aEOizYHTsFlIjVPn2FeeEtPy/q8WHtlGk2at5ovD9l4ct1x15Vn2MWJFTyaZxdQ9jw5Pd1goFylVHSBPMCdXQBlJqSYdxs8csZFJWm1mqnRGjGwnegrzBfVV3x/KHGKtaez7647RA5/qwJjXnASDFxt4g+IgSFOx4tnml+0zmmrUtuWUa34nsOa8tg1gEvvqPk/UKUKpeU3NRiXrbo6bUe+oG7OWtOf2ET9vw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785189049; c=relaxed/relaxed;
	bh=384O+BN2fI2UgbEqZaMCx4DNdrjiOiIN/h1IPB0hqrM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Id2bwet9RpUQcunUoiSA6YT3HqFACp71BjOGDAPvEaA1wTve6F3Q7hh/0Jleqi6gjKbU5dWaVjbw2WW2V0+tYlSkg3yzpDPcK0Swp4RbLknhtehmsgs2bpXxf4+oPafqIoratAz042C85DX6QcHlWgs0cQVPJWhFoJCeZAVqvX7lFoJldix3Ata/GXDqgnMDEeUtiVzwbCtscRBT1NZOUPs/dPGU1TjYC6iPZIbFx/PEZVccZFlmHM9okGnG1eNVRAOD61LwB+HwwgjnfGTHGSvwFsDuJA+XJSV6EZ1UKc4k49L19sW2BppMS0opU8PdYJcjDVTeCjnsW6F9VZqjSg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRUpQ7Qs; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRUpQ7Qs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8C2c56sWz2yS4
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 07:50:48 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD58C60A64;
	Mon, 27 Jul 2026 21:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9291A1F00A3D;
	Mon, 27 Jul 2026 21:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785189040;
	bh=384O+BN2fI2UgbEqZaMCx4DNdrjiOiIN/h1IPB0hqrM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=XRUpQ7QsP0X3XEmB4/VxWs++VhXFq3XOCYYm9JFOFrjmeohnBm+NVGg9f7zIWNvr1
	 gGLHwse0a+fZedC2PX4tMb0RlYhdX1QjZN/Lru+SAr+eGMrPHtrD+HtQm/ccJV/LMe
	 96yKa8vSPjYMvgHvwnNh5l3oY96hWyQIwQXVjrj2MQSFGt4dnrNKUHI2f+nwla16di
	 WJpjs654zsWH+1w9htORk2e8IoZJ/n5f5pfnHua7UMExLTKzdKzXYse/lKBxbsOjKr
	 scTwQOwNNYO2kR5yVq8LJl2w6v3MNaVfyiLtEsV1lehaeNqPtDGu1tHz5vVfVVe9SO
	 33LO85GZ7f1rA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198A7380CECD;
	Mon, 27 Jul 2026 21:50:07 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.2-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <amd6OALSzdFYQOb2@debian>
References: <amd6OALSzdFYQOb2@debian>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <amd6OALSzdFYQOb2@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.2-rc6-fixes
X-PR-Tracked-Commit-Id: c9b47e6b23114e939b17f818471c7a46e59006e7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e895a6fc204ff662bafe6b857f571424f1d17888
Message-Id: <178518900575.1430666.7345217205437961315.pr-tracker-bot@kernel.org>
Date: Mon, 27 Jul 2026 21:50:05 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>, Hongbo Li <hongbohbli@tencent.com>
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

The pull request you sent on Mon, 27 Jul 2026 23:33:12 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.2-rc6-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e895a6fc204ff662bafe6b857f571424f1d17888

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

