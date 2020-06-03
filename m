Return-Path: <SRS0=+euA=7Q=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614D1C433E0
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jun 2020 03:50:25 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F1C220674
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jun 2020 03:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUMOnzZ1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F1C220674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49cFL71p4rzDqWq
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jun 2020 13:50:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=default header.b=bUMOnzZ1; dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49cFKx5HYfzDqWJ
 for <linux-erofs@lists.ozlabs.org>; Wed,  3 Jun 2020 13:50:13 +1000 (AEST)
Subject: Re: [GIT PULL] erofs updates for 5.8-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591156211;
 bh=E33tR9al6qvqyYF6H/XZmuh1Mvt6yfXhaaF9RZ+tvTQ=;
 h=From:In-Reply-To:References:Date:To:Cc:From;
 b=bUMOnzZ1SfuyTvtopxATYXlE7D1L9hx6q/jC8ZykO7qala5HUIbodrYxFME8g0Ukc
 W2O7jAZXFYyeVn2SO2F/qkOTV5l4JnBYboxthC/94URVy108+fC0sXfEnpzErZW9FZ
 yJLm3dAtgaIuC6YkdBPGFn8BR8sL1vLjHNg8Icl8=
From: pr-tracker-bot@kernel.org
In-Reply-To: <20200603012137.GA12304@xiangao.remote.csb>
References: <20200603012137.GA12304@xiangao.remote.csb>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200603012137.GA12304@xiangao.remote.csb>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
 tags/erofs-for-5.8-rc1
X-PR-Tracked-Commit-Id: 34f853b849eb6a509eb8f40f2f5946ebb1f62739
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d6f9469a03d832dcd17041ed67774ffb5f3e73b3
Message-Id: <159115621140.30123.15533234528367920561.pr-tracker-bot@kernel.org>
Date: Wed, 03 Jun 2020 03:50:11 +0000
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
 Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The pull request you sent on Wed, 3 Jun 2020 09:21:37 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.8-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d6f9469a03d832dcd17041ed67774ffb5f3e73b3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
