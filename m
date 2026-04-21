Return-Path: <linux-erofs+bounces-3352-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90AEF94CA5
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Apr 2026 18:11:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g0VmZ2rykz30WD;
	Wed, 22 Apr 2026 04:11:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776795102;
	cv=none; b=AsHpAO0jvVKlhxW3Q033LZjagO1Os+WDLsc7hpXCKoDPHUC5V2TNhMazNFSla7c2QJ0n7oAs2UAMMp/Iv9VhZULw9jnW+OjT892D+ZTOWkbpsm0p0ynTrqaNolNpqg+omM71QVa1NtAXlY/8nAKZcvsZX6f6C7v6gAoDKu0Dynj+vuZgSKhEI02jxZbxcj0D3UId/AjpidpQkku3enD6tdWgSRJEB6RO5zWFjntseMthoI2JqwYGywyX1lN9ZLUDqlEsdueC9u5WaH5RGIzKVmqkk/gw2FMCTyXRxxKg2IQCm0WVpL7QyoN9VmJfN/CtPDJUJBQUh29bBRStSg02lw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776795102; c=relaxed/relaxed;
	bh=W7aN4CY0qktHM4VvEbLwB0YKb663ePfB+VIdtMaU5g4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=My7uSbFN6Uyqo4CrLpnP03vWhq+jd7FG08/21Aug1/ij7J4ebpQryr1Mogg+Uepo8EBtsvxOLNGI1BSgsKO0PNUrT9F0ycKNHFfLrfwrYzlBkCvrPWYw43O6UIKzzPeT1YTWbOSDEMMrkEcnHWiC2xCUtn5Tstcgqu5yM1nsjCKsGuSwqtLokrXvn8fd1wgPxz1X5XZeYPxYuIbtafx62092LNpJarXiJx0H3t5TCloTmkYctVxFIwWG2nRM0RFhTwgUPZ0T99DWTKeypWXPAIuDG3EZwZ4gIOsmiQxPNAYcKAlIIIaoKYOB+ApI0snsHLdRvp243sfnJo+tfanQsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=RPOZq4WM; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=RPOZq4WM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g0VmY5kNnz30W9
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Apr 2026 04:11:41 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13C4C406AB;
	Tue, 21 Apr 2026 18:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B03DC2BCB0;
	Tue, 21 Apr 2026 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776795099;
	bh=ujT062F7RnHQX9I4MsjE5zC7Gudi2t0iQQFOH6WXu4I=;
	h=Date:From:To:Cc:Subject:From;
	b=RPOZq4WMfCKpr0WLddDqPnlnczcJ91Ia9Pkgm5tgAE8Kb/qvrdc8abMSn/QeqbS59
	 3uHdz6iJ7giuk4PQNJ06ftlf8ZKIC99ZMdRycHwTK3dchohVH9sXtZoLANU4yTiYO7
	 FO2EHubkRurHAfuvejAW+Rjlz5F+ccb3YdhLgl4ZPpjw/NASu2hpatv2Azm0pt/5wd
	 XQBfthHF7e3CqULt9/GM6cvai0hjrs5b4SknO7crrp1QZOVYXrmfI1Fvmm45Lsb3wI
	 i4gZl+jGn2Ttr8OSmgwIQr0tSWAfLiatp3LiZmw2EpYglhdGISwuGGU1Nl9xGZ4N9k
	 IkbUPYqJ6FndA==
Date: Wed, 22 Apr 2026 02:11:34 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: [GIT PULL] erofs fixes for 7.1-rc1
Message-ID: <aee91ucT5PLdydIC@debian>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Chao Yu <chao@kernel.org>
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

Could you consider these three fixes as the following
updates for 7.1-rc1?

They are all small random fixes, but we tend to address them
right now given our priority on crafted images, for example.

Thanks,
Gao Xiang

The following changes since commit a5242d37c83abe86df95c6941e2ace9f9055ffcb:

  erofs: error out obviously illegal extents in advance (2026-04-10 16:53:39 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc1-fixes

for you to fetch changes up to 2d8c7edcb661812249469f4a5b62e9339118846f:

  erofs: unify lcn as u64 for 32-bit platforms (2026-04-21 16:56:08 +0800)

----------------------------------------------------------------
Changes since the last update:

 - Fix dirent nameoff handling to avoid out-of-bound reads
   out of crafted images

 - Fix two type truncation issues on 32-bit platforms

----------------------------------------------------------------
Gao Xiang (3):
      erofs: fix the out-of-bounds nameoff handling for trailing dirents
      erofs: fix offset truncation when shifting pgoff on 32-bit platforms
      erofs: unify lcn as u64 for 32-bit platforms

 fs/erofs/data.c  |  2 +-
 fs/erofs/dir.c   | 28 +++++++++++++++-------------
 fs/erofs/zdata.c |  2 +-
 fs/erofs/zmap.c  | 19 +++++++++----------
 4 files changed, 26 insertions(+), 25 deletions(-)

