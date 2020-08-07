Return-Path: <SRS0=1gMj=BR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A33C433E0
	for <linux-erofs@archiver.kernel.org>; Fri,  7 Aug 2020 02:39:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44B8422CBB
	for <linux-erofs@archiver.kernel.org>; Fri,  7 Aug 2020 02:39:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1sUWz7jF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44B8422CBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4BN8hS0S2HzDqvd
	for <linux-erofs@archiver.kernel.org>; Fri,  7 Aug 2020 12:39:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=default header.b=1sUWz7jF; dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4BN8hL5q86zDqNR
 for <linux-erofs@lists.ozlabs.org>; Fri,  7 Aug 2020 12:39:30 +1000 (AEST)
Subject: Re: [GIT PULL] erofs fixes for 5.9-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596767968;
 bh=klkVfP88rtLpfevFfFMGfw20TED7XGDbc1+skecj4Ck=;
 h=From:In-Reply-To:References:Date:To:Cc:From;
 b=1sUWz7jFwLfI2MK7tPWs87D5q5W9gCbMXwuZHjK1BRXMk+9VEfUYr8FNGlhRHer4e
 I+7EZvBYop6pKuqDiwr71XNQVwzizO43v873a6qmwMFy2Vqpk70Ig0zqkeUS+KdHSj
 1U9P0xNquHaOitF1CyqFp14tbN/hP4/xaP7rWQkY=
From: pr-tracker-bot@kernel.org
In-Reply-To: <20200806032017.GA4442@xiangao.remote.csb>
References: <20200806032017.GA4442@xiangao.remote.csb>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200806032017.GA4442@xiangao.remote.csb>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
 tags/erofs-for-5.9-rc1
X-PR-Tracked-Commit-Id: 0e62ea33ac12ebde876b67eca113630805191a66
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 019c407c1dfb81c37036323597e18cce73c84122
Message-Id: <159676796820.23087.18283400571453619730.pr-tracker-bot@kernel.org>
Date: Fri, 07 Aug 2020 02:39:28 +0000
To: Gao Xiang <hsiangkao@redhat.com>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linus Torvalds <torvalds@linux-foundation.org>, Miao Xie <miaoxie@huawei.com>,
 LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The pull request you sent on Thu, 6 Aug 2020 11:20:17 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.9-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/019c407c1dfb81c37036323597e18cce73c84122

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
