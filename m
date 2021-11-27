Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8D1C433F5
	for <linux-erofs@archiver.kernel.org>; Sat, 27 Nov 2021 05:01:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4J1KGL19k3z3cCs
	for <linux-erofs@archiver.kernel.org>; Sat, 27 Nov 2021 16:01:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=fVub9bUA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=145.40.68.75; helo=ams.source.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=fVub9bUA; 
 dkim-atps=neutral
X-Greylist: delayed 484 seconds by postgrey-1.36 at boromir;
 Sat, 27 Nov 2021 16:01:39 AEDT
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4J1KGC4H2Zz3c7P
 for <linux-erofs@lists.ozlabs.org>; Sat, 27 Nov 2021 16:01:39 +1100 (AEDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BE0DCB82932;
 Sat, 27 Nov 2021 04:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DD4C53FAD;
 Sat, 27 Nov 2021 04:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1637988810;
 bh=qmrI6qDuYGXxcCK42IFtwac4kllQQxIR9O1mMoTZ0Gw=;
 h=Date:From:To:Cc:Subject:From;
 b=fVub9bUA5rDemlu2pJ65FP8a/VqC0dgIbSd4R1vrMZmi/U75F32XZLWtJb8fXUxti
 7OKjCs+gIPKBWCUm8QlNBHmewUScQDQD9ry8Oh4VbHxcfZgZAAllQ21c5XNC5C1Zr2
 8Gi1Aka55/p5Awyhy/li7QtTKdy1p5vfCGGWfeaHHjVDfVL/0OpqTb8enjbzE9BEo0
 KQZmEpvrfiE0Dn2QLJTMjkmY5c1fK3OCcdcvcPnT9CaMudDPFMGwTtA+ei0siE0+pK
 ym1dd8Di7zu5LL8VgO56/bfXp9YHNeTDIE7KRYmuNv6VngA9q1u3fYFbl7jGls1jZ7
 odQ1FGX43MGfg==
Date: Sat, 27 Nov 2021 12:53:09 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] erofs fixes for 5.16-rc3
Message-ID: <20211127045306.GA17766@hsiangkao-HP-ZHAN-66-Pro-G1>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
 Chao Yu <chao@kernel.org>, Miao Xie <miaoxie@huawei.com>,
 Huang Jianan <huangjianan@oppo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Miao Xie <miaoxie@huawei.com>, linux-erofs@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Linus,

Could you consider this pull request for 5.16-rc3?

This fixes a regression introduced by the XArray convention
which can cause ABBA deadlock in the low memory scenarios.

Jianhua Hao also reported this issue recently. All commits
have been in -next and no merge conflicts.

Many thanks!
Gao Xiang

The following changes since commit 136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-5.16-rc3-fixes

for you to fetch changes up to 57bbeacdbee72a54eb97d56b876cf9c94059fc34:

  erofs: fix deadlock when shrink erofs slab (2021-11-23 14:58:16 +0800)

----------------------------------------------------------------
Changes since last update:

 - Fix an ABBA deadlock introduced by XArray convention.

----------------------------------------------------------------
Huang Jianan (1):
      erofs: fix deadlock when shrink erofs slab

 fs/erofs/utils.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

