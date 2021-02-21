Return-Path: <SRS0=TIS/=HX=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85ECC433E0
	for <linux-erofs@archiver.kernel.org>; Sun, 21 Feb 2021 18:39:51 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DADDE64EF2
	for <linux-erofs@archiver.kernel.org>; Sun, 21 Feb 2021 18:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DADDE64EF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DkDd14QLtz30Qb
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Feb 2021 05:39:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=c3Y0+MRS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=c3Y0+MRS; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DkDcz4LWgz30Jb
 for <linux-erofs@lists.ozlabs.org>; Mon, 22 Feb 2021 05:39:47 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPS id E369E64F08;
 Sun, 21 Feb 2021 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1613932783;
 bh=elGYTcXChBWsfDRccHJ3f3SY+OUH/bcWWbYdGxO5JzM=;
 h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
 b=c3Y0+MRSn4StdK32kqjwV3khCDTUmpzDn6Yu69jDntfPDkNCMkNSBFiy0slBbZm5F
 frqcm4zmUigOoQgMU/sPKnSVRDNNjoxvPei78tz1EMh1EuCWdIEpDkBHb/z7mWunJr
 A2RAEkzB+OrvgSWlldC2au0aYC9ixT51n9uTSLiZ2yEPXaYBrZDimFCFUUCLgANYo8
 MY1bbLfnmuBQ6WCdo9/RtoKi1efg1+7hr4HXzaZQDMAhDXeePRMfr6atouy72RkIo0
 lWo6uw4Qsq87QCAlJvulth6EYQSem9aIkxBOAISjMCUokSIfbxsDZvx0CQhP//frsE
 1X6O1VV3/kDOA==
Subject: Re: [GIT PULL] erofs update for 5.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20210219113537.GA492321@xiangao.remote.csb>
References: <20210219113537.GA492321@xiangao.remote.csb>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210219113537.GA492321@xiangao.remote.csb>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
 tags/erofs-for-5.12-rc1
X-PR-Tracked-Commit-Id: ce063129181312f8781a047a50be439c5859747b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 681e2abe2191058b320716896cccda05b161eedc
Message-Id: <161393278390.20435.11331185091951569905.pr-tracker-bot@kernel.org>
Date: Sun, 21 Feb 2021 18:39:43 +0000
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Miao Xie <miaoxie@huawei.com>,
 LKML <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
 Guo Weichao <guoweichao@oppo.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The pull request you sent on Fri, 19 Feb 2021 19:35:37 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.12-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/681e2abe2191058b320716896cccda05b161eedc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
