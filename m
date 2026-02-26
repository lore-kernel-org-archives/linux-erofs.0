Return-Path: <linux-erofs+bounces-2426-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04750FD45F9
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Feb 2026 03:28:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLxkV3cQ1z2yvy;
	Thu, 26 Feb 2026 14:28:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772076514;
	cv=none; b=Ad6eWZdTBmNCBWn9VIHtLKQrz/P5o/hRQQLK1bvWXgc507W5DUzuhQgUZE6xSoYICw6lfFE1tNWUDZptUB/Q9iXuh8MxaZa7wzBDkx80lMIg3w2tKvrQqqMG5x1zfGZvcIkj22xLxnJfds0YTxvjuwAq03pvH8RFK2qtqa3reFK0e0NQTVzBBpm0Y0VMRVCnNn7myt2q3jhkrlqC+GGF8VlUZRHwPzo6bDngw4+uKbj/XLnuJREP+aVgMRcYoovT0ENqTgEjPNg+GZbw08g2m7tZE9aH6O9dUkBD902rKUBoHL8/BMrqofy+Wa5AJPPXMdMzpyJVBfJefAAF8QCShQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772076514; c=relaxed/relaxed;
	bh=Z7sy/zlYsN6jqksPO7TiPo9b86oj47gpKWXqUmA04aw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dibRgDs/2l7cjT3NQpsWBXTjlegRw0jobpXAmFyJtZ5tsxClG81SBDFrL4Ar+kzvxwSmf+NR6oN5K9nybJ/GJPiQBH3RdlzrOf+1ZYInwo0UtsWwSZB15hVUGNxscahW/LUt/Vd+Wt5Ombs0PvmEC9P/zQIlKcAR7G+ikF+LY5ooGrRZMT59u+njrIFYSXe8Wt8FZnh77TPtUYXETzuB9Dj8oCX7+lXCLVwKxFX+9B1XvnbhZUr7w6JnIRTQyWwovOtjHxaPiCWwLjc8tN0G6ZQAMGajyIy5EAwsypbsM1ui80sAf4FcJBV3k9e1GT9lhRTYWY5WU13J0f7VA0f3uA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ObiEUnAG; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ObiEUnAG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fLxkT5Sxrz2xMt
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 14:28:33 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A70E243FA6;
	Thu, 26 Feb 2026 03:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C3FC116D0;
	Thu, 26 Feb 2026 03:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772076511;
	bh=ADUu+2urQKD30IozxBF+Sx8bKXJkft26FA/57//jBq4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ObiEUnAGFsH0IlIFi3R5866QZpqu0OmzAAzFkutR+/juUfFkR5tBQLU4o6/cLeYtX
	 6IKV36Zc5WsIaWO6eoqSSgzqs6bk0LsT0CuMsgQkNyuQiyVYzb4nZ7x3GOaiPU+cLS
	 ZfgNWKXNDOOKWn/LpkdwUXL6MEGft7Ug2iri03nV9TR4IwPoitPU0zzLv7n2sPGwz+
	 jW4mJxfA/qT5AKSuON8Ymaa8JKSSO7Z8SmB2J8zDL4y2EXZFlt+PPaYhSq/+6gzJIq
	 k66HJQeNrktFG1j8XRjRP2bw0vb+NxOXKCcrcgefMqjZnZ/aPwrZLENI5DSVwwpIom
	 +ORPuTMDlc+IA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D08A380A94B;
	Thu, 26 Feb 2026 03:28:37 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.0-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <aZ9Q0_cPEZQQM_75@debian>
References: <aZ9Q0_cPEZQQM_75@debian>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aZ9Q0_cPEZQQM_75@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.0-rc2-fixes
X-PR-Tracked-Commit-Id: 4a2d046e4b13202a6301a993961f5b30ae4d7119
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f4d0ec0aa20d49f09dc01d82894ce80d72de0560
Message-Id: <177207651614.1021445.5896339454370160796.pr-tracker-bot@kernel.org>
Date: Thu, 26 Feb 2026 03:28:36 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Hongbo Li <lihongbo22@huawei.com>, Ferry Meng <mengferry@linux.alibaba.com>
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

The pull request you sent on Thu, 26 Feb 2026 03:43:15 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.0-rc2-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f4d0ec0aa20d49f09dc01d82894ce80d72de0560

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

