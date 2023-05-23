Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C2EC7EE23
	for <linux-erofs@archiver.kernel.org>; Tue, 23 May 2023 18:03:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QQhxv5pDlz3f79
	for <linux-erofs@archiver.kernel.org>; Wed, 24 May 2023 04:03:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=b99bd4Xj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:4641:c500::1; helo=dfw.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=b99bd4Xj;
	dkim-atps=neutral
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QQhxm3Npbz3cgq
	for <linux-erofs@lists.ozlabs.org>; Wed, 24 May 2023 04:03:08 +1000 (AEST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id E4FDC6358B;
	Tue, 23 May 2023 18:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F932C433D2;
	Tue, 23 May 2023 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684864984;
	bh=/P/Osjoc4z4Yu1N3CgNlw0iuscbguTL7v6pbGCgQbH4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=b99bd4Xjdm1odCryN2qdU5WbBTcWoU0sFMQvQwhAHVzlDLAoyYhXLH3LI1CmpxtAo
	 XVc4H2Jn8h4YdYHfozN82i8iyvZroRwmkVIyb5cNkbNyP87mas94y0n/Z30OuPLGSQ
	 xJqpiS49RGxh+WM2FAiV6yApwsuPYXESmY1i72RclZpB6/KTtKAndKZ1PTaMvS40MM
	 zpRzPVCPJe3SUj7ExGcZvKVur9O2pSr9X0EmLfwzXD5HQNbizL5v9e1sleZwslA52z
	 5/D+hA8BvhqJ0/1uadLTC4BjFfXCKv6vTQ3cdS+9uj+ChglV9eICLcxk+QZ79ry3+F
	 osUtEQ35VsPIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3114FE22AEC;
	Tue, 23 May 2023 18:03:04 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 6.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZGz1wpqyI+lfCaUA@debian>
References: <ZGz1wpqyI+lfCaUA@debian>
X-PR-Tracked-List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <ZGz1wpqyI+lfCaUA@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-6.4-rc4-fixes
X-PR-Tracked-Commit-Id: cf7f2732b4b83026842832e7e4e04bf862108ac2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5fe326b4467689ef3690491ee2ad25ff4d81fe59
Message-Id: <168486498418.10175.448428344867124366.pr-tracker-bot@kernel.org>
Date: Tue, 23 May 2023 18:03:04 +0000
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
Cc: linux-erofs@lists.ozlabs.org, Yue Hu <huyue2@coolpad.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Sandeep Dhavale <dhavale@google.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The pull request you sent on Wed, 24 May 2023 01:20:02 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-6.4-rc4-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5fe326b4467689ef3690491ee2ad25ff4d81fe59

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
