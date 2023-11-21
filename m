Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A644EC61D90
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Nov 2023 20:33:55 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=g9cO+tJ8;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SZbgk1MLcz3cnr
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Nov 2023 07:33:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=g9cO+tJ8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=145.40.73.55; helo=sin.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SZbgc6GbZz3cVS
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Nov 2023 07:33:48 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 48F41CE1DD8;
	Tue, 21 Nov 2023 20:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1744EC433C8;
	Tue, 21 Nov 2023 20:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700598824;
	bh=egAqlVYa/A/HI0HadKIhudt6IzD9eGNLvK0Ri4QfjTw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=g9cO+tJ8dqXbdCCNyztmmWUOTkV7lv0Wfy3GX6yA4DF7VbpAhk5oHQkhbX14Z8MtJ
	 T2VCXyWlIby3Q19wppYlQ6ReCkDVbWYTVlDzQ+jnOUY8NSUrxAkrxBWaGW5GHPRsks
	 RBrGfMAvzEwFR1XgLMpnU1MMxPvlWM+NmelN8mjTNsWJZs4TK27vcTFc3Dp2DBJJZa
	 H/4WdVkA1E5zQzfVO6wEyMbEMSJTRcGdvmoDpzmBTJpRJhMvqeB1X0CH12gAa7aOTx
	 G1z1puENxzdUMbV2YlETs/MaeMoOynDkqcan1Gq1APcg/BSZriLoNUY//nUUZazNFV
	 afV0lf/wx6+5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 045B8EAA95F;
	Tue, 21 Nov 2023 20:33:44 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 6.7-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZVsQBsV2GFTmy+iZ@debian>
References: <ZVsQBsV2GFTmy+iZ@debian>
X-PR-Tracked-List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <ZVsQBsV2GFTmy+iZ@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-6.7-rc3-fixes
X-PR-Tracked-Commit-Id: 62b241efff99fc4d88a86f1c67c7516e31f432a3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6b65522316489ff0b2be65d00fbcecbc781017c9
Message-Id: <170059882400.5512.9141675111276341675.pr-tracker-bot@kernel.org>
Date: Tue, 21 Nov 2023 20:33:44 +0000
To: Gao Xiang <xiang@kernel.org>
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Yue Hu <huyue2@coolpad.com>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The pull request you sent on Mon, 20 Nov 2023 15:51:34 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-6.7-rc3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6b65522316489ff0b2be65d00fbcecbc781017c9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
