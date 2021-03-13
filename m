Return-Path: <SRS0=UhNX=IL=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D5CC433DB
	for <linux-erofs@archiver.kernel.org>; Sat, 13 Mar 2021 20:45:47 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 55FA964E45
	for <linux-erofs@archiver.kernel.org>; Sat, 13 Mar 2021 20:45:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55FA964E45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DyZT50PN7z3cHX
	for <linux-erofs@archiver.kernel.org>; Sun, 14 Mar 2021 07:45:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Xp7rKFZb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=Xp7rKFZb; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DyZT24cwbz3bcs
 for <linux-erofs@lists.ozlabs.org>; Sun, 14 Mar 2021 07:45:42 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPS id 0411B64ED6;
 Sat, 13 Mar 2021 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615668340;
 bh=OxclE0IRvk0O9yDw59ilEel2JELIYvpEdhMsDCBRMOM=;
 h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
 b=Xp7rKFZb8/nlyfPuqwEVzUDHau92kOpSA3RFljxt28Wih/XFxrpBsSOwXEktZs25O
 i8hHYkjWCr4ZtY4/OlGq+dHHoEKPGLxzerU+AssNeeTuV7oBeXb2k03v226X5dDC5+
 szuzNtp0dyr3NSrxpKmTRO/jejJxzdfIDzXR0GChFTJx0zbw3GEFSGOYNhJv2twCke
 uT+cdsX8UqIHUmj/rAFN68irHrSyqpL5qJzrQniCIeo0bTk4VoIcdTZ7mnVKoxSB9S
 X+IeAMtXLmysjG4CH+hHtwvwodTb9ZBTqrPxD3b/IoRQV6JJhMjdzKdDadry3IauAe
 a92bJqst3v4cw==
Subject: Re: [GIT PULL] erofs fix for 5.12-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20210313124044.GA488856@xiangao.remote.csb>
References: <20210313124044.GA488856@xiangao.remote.csb>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210313124044.GA488856@xiangao.remote.csb>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
 tags/erofs-for-5.12-rc3
X-PR-Tracked-Commit-Id: 9f377622a484de0818c49ee01e0ab4eedf6acd81
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 420623430a7015ae9adab8a087de82c186bc9989
Message-Id: <161566833999.19597.9631392118505520065.pr-tracker-bot@kernel.org>
Date: Sat, 13 Mar 2021 20:45:39 +0000
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
Cc: linux-erofs@lists.ozlabs.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 LKML <linux-kernel@vger.kernel.org>, Martin DEVERA <devik@eaxlabs.cz>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The pull request you sent on Sat, 13 Mar 2021 20:40:44 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.12-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/420623430a7015ae9adab8a087de82c186bc9989

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
