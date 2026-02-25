Return-Path: <linux-erofs+bounces-2415-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 819F8FD45E4
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Feb 2026 19:43:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLlPl72D9z3fDq;
	Thu, 26 Feb 2026 06:43:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772048603;
	cv=none; b=EkTbk8l91nK0o6fMF6JTMgHGgqNObKoghFZyPK4xpxnQR9ZQaMcP7IZlZBvfiDZ+HsQwBM/Kdy1dqzlEJK/uuc7irPLUaQNpFxnxnafcDcgSP4QHhYfjTGPA0Ov8tTAydizk3MQfC9LdUbWk+xrK3o5x5ZyoHAYW0Xhww4B1d1i1YvYb/YyUBiaA/N7/HpqxrLpI9kJHVyybQ/E2CcK6HBPAZXmFJ8NXnmCt9xuHw8LnSNJ9uEjV2Jt7BjgzXRf/5tUsyzno/SW/Z4H84n+RVo0qzVhqhHS3jHeSsMQKulP8YLn+HkSsiP7ug7QOnV+9Wz1ORcjtYzTqK2b4ThqBtg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772048603; c=relaxed/relaxed;
	bh=ExGp8+gR9pU3Xt4YzGliJv2b+bbSSasVviTkGALb2a4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Y/42wjU6NlN5sYeJlFBSJukvaf03nyVkccKRwC7P74Hj19rOSMbmDpeX4I4hmgAlgTO9NZUxJFy5ocpXbojEBoXZLVNwOfiVlkxQDO91WD12bxULpc4KJlwfLd396RCXiOA7dJPtPP4Hg9ADLY2DHANjm6dTQEWbW0LiA4MnWebbGiGZRy0gH0RFcExGFf0d0NASupIvoFHa1IGvUQphT0g6UmOAYmaJLjDkpLpXJRbUxaLgywNIQaTedO2q9UbKG8G7Rst0ggPX7Sxi8xxphpALBNY8bufPuSQcRRX4cVcvPAN60ygSwXaWye+zf9uVX/5wfoTT4DGVT9G2xKTtng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=roHqaVrB; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=roHqaVrB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fLlPl2my4z3fDd
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 06:43:23 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B89AC60054;
	Wed, 25 Feb 2026 19:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C837C116D0;
	Wed, 25 Feb 2026 19:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772048600;
	bh=2C9b8Zm+1GDv/c/dJvAtw0Jr0AehqfcnI7KHPI8SMFI=;
	h=Date:From:To:Cc:Subject:From;
	b=roHqaVrBPoGAjV2wo1s/BqZrBiOug7kKLaPgCVZuQgHxHDiCO0pKM07iZVpkWStHg
	 c0qca8Wvg+cKWjXU5cXGKNznm0dsBWDlr1P2b2N3a91UyMdV2A0xnZ//OMB8P7Tygl
	 FsxPD/K6I9dqAqxEfWeahn/5LNsq38i+TSc+CblSMFUZ0GSEbSXM37WwJ91AcBttpO
	 4f7cSLmg2bguwFzTHBLVZhcM2tKlz5ovA+CZWDal8wxdMqMB/kEExUSDDbHtiM0TdO
	 4Px3L81gZvEY/vVGtOsFpU37ywUYYbd6kYUXWGaewh8i+zmG860qJQwsNwBDG9jPKd
	 J3wUdCh1wabXA==
Date: Thu, 26 Feb 2026 03:43:15 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [GIT PULL] erofs fixes for 7.0-rc2
Message-ID: <aZ9Q0_cPEZQQM_75@debian>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Linus,

Could you consider these fixes for 7.0-rc2?

Details are shown below and all commits have been in -next.

Thanks,
Gao Xiang

The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.0-rc2-fixes

for you to fetch changes up to 4a2d046e4b13202a6301a993961f5b30ae4d7119:

  erofs: fix interlaced plain identification for encoded extents (2026-02-25 17:40:58 +0800)

----------------------------------------------------------------
Changes since last update:

 - Do not share the page cache if the real @aops differs

 - Fix the incomplete condition for interlaced plain extents

 - Get rid of more unnecessary #ifdefs

----------------------------------------------------------------
Ferry Meng (1):
      erofs: remove more unnecessary #ifdefs

Gao Xiang (1):
      erofs: fix interlaced plain identification for encoded extents

Hongbo Li (1):
      erofs: allow sharing page cache with the same aops only

 fs/erofs/inode.c    |  7 ++++-
 fs/erofs/internal.h | 16 +++++-----
 fs/erofs/ishare.c   | 14 +++++----
 fs/erofs/super.c    | 85 +++++++++++++++++++++++------------------------------
 fs/erofs/zmap.c     |  9 +++---
 5 files changed, 63 insertions(+), 68 deletions(-)

