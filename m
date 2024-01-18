Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFA7C4707B
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Jan 2024 15:32:42 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=MKIroSt6;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TG6FP3QRsz3c3w
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jan 2024 02:32:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=MKIroSt6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=145.40.73.55; helo=sin.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TG6FH0qR2z2xTl
	for <linux-erofs@lists.ozlabs.org>; Fri, 19 Jan 2024 02:32:35 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 817ACCE1B3F;
	Thu, 18 Jan 2024 15:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7EAC433F1;
	Thu, 18 Jan 2024 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705591952;
	bh=NH/52USESWX/025MLcTJ6cVm9KuDjzjd5hFj4uGgKqA=;
	h=Date:From:To:Cc:Subject:From;
	b=MKIroSt6lXEKXaW8LCFPoSsCdjkVBNMdDh4OwkAUPMa+c4EeXxQZce1qojt4K+jRr
	 zRPxQP/bhxY8ALNlY6DLgb1CfD9zdGxGXJLOKfJOJJkA8DA7ImEr5tGrVu2aMyLysj
	 t0tuu2Eh/TOX4GmhS2m5JaWFUjVMLUbZKlxHNNBOPOd6LkTFG1zfMeC2C1o7Y5jIpT
	 zynEbInLm74oT4C73gymPTjFaVj29z+ffyW18ObgO7XN91QrTC+ePQg/qvOQpyWOtw
	 UhknVtn5vBVJAB5Z/WHPsKJsDvSV6krDZdqc9PEEUsuPwnkLuje+ZSXb7SGYichrxo
	 4W4dCQJSw/5rw==
Date: Thu, 18 Jan 2024 23:32:24 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [GIT PULL] erofs fixes for 6.8-rc1
Message-ID: <ZalEiKJWhdH2D9JV@debian>
Mail-Followup-To: Linus Torvalds <torvalds@linuxfoundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Yue Hu <huyue2@coolpad.com>, David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Chao Yu <chao@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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
Cc: Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, David Howells <dhowells@redhat.com>, Yue Hu <huyue2@coolpad.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Linus,

Could you consider this pull request for v6.8?

It simply contains a fixed commit of the previous problematic one
mentioned in [1] and a folio helper cleanup.

All commits have been in -next and no potential merge conflict is
observed.

[1] https://lore.kernel.org/r/ZZ6M8CCkunjfbt+%2F@debian

Thanks,
Gao Xiang

The following changes since commit 0dd3ee31125508cd67f7e7172247f05b7fd1753a:

  Linux 6.7 (2024-01-07 12:18:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-6.8-rc1-fixes

for you to fetch changes up to 2b872b0f466d2acb4491da845c66b49246d5cdf9:

  erofs: Don't use certain unnecessary folio_*() functions (2024-01-15 23:52:52 +0800)

----------------------------------------------------------------
Changes since last update:

 - Fix a "BUG: kernel NULL pointer dereference" issue due to
   inconsistent on-disk indices of compressed inodes against
   per-sb `available_compr_algs` generated by Syzkaller;

 - Don't use certain unnecessary folio_*() helpers if the folio
   type (page cache) is known.

----------------------------------------------------------------
David Howells (1):
      erofs: Don't use certain unnecessary folio_*() functions

Gao Xiang (1):
      erofs: fix inconsistent per-file compression format

 fs/erofs/decompressor.c |  2 +-
 fs/erofs/fscache.c      |  6 +++---
 fs/erofs/zmap.c         | 23 +++++++++++++----------
 3 files changed, 17 insertions(+), 14 deletions(-)
