Return-Path: <linux-erofs+bounces-4018-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A27C531FC
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 15:33:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h82g76WNvz2yhD;
	Tue, 28 Jul 2026 01:33:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785166403;
	cv=none; b=NNGt/jlBS8oGNDEoj1GsYWQ8QAGK9mlRNBxdyF4Pix/VHcaa+GuzgaTflVb9Xvcyx0JjvgG5+7EpNBvjAWNkJTTGU6W/uaRmG/mL3fMIuBgNDd0z3aDZST29l0oMGOl+xYvJ5ebMomGkVRjWphY5qjgtc3mKcfO9B30vZRUqQ/CgXOm5iz+pWvKhXDorwPU1qFCfxbYl3OtnPfpGAvXLqOAQLJUZimgvTLSpO3TmTzoFBmPHnPhRu9q80hVLHySm3yJ6/o2DX3UvxX54xXqBxChLpg9WvhvJv6BoAIggAVnqjBzHU4896hicMhC0Ta0NSn9taA9zJ/2e4s1+BXoTTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785166403; c=relaxed/relaxed;
	bh=hY9ew9+f/Y9ET/hPIdzhZ5B9xjEYEuGh3khFm7kSZ8U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Sl9JVFrS+yV5t2IZePzIiEmrPFrxxh/MXRKKXIGaUdy+4XplsVPAjV7YYdYkAeKatbabcbxb+vFp3E8coFIoXIFifb9VsOEjSZa6ZDPq0XQQn9aYAwd5iIcPtI+PTe3ChIlqqbApW0wgxAZZT9s+vUq7fFuJp7jSamCADZ+X63jx+RxMe6A7RADhLouNn5M0znoKLFWuTzOTLCDl3Mgotvfn+8x+d50J2n9Q332l5suor4oASE6sdQ3Jp/eajoPSqGNfX7TKCVLpfWjazhZYleTGLsc8ObTNeKwTUH5JnhER9dDMQp3A3KQ5fbxnE8AefkoRtR+Qq0x8UE/XjakM4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BIiSARjE; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BIiSARjE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h82g66bdpz2yRl
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 01:33:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFE566001D;
	Mon, 27 Jul 2026 15:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B3B1F000E9;
	Mon, 27 Jul 2026 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785166399;
	bh=hY9ew9+f/Y9ET/hPIdzhZ5B9xjEYEuGh3khFm7kSZ8U=;
	h=Date:From:To:Cc:Subject;
	b=BIiSARjEQW8vfu8hlhlzKcm0MasS/+CJmxMDBgOARSmM9zrbc+fdVjwWa0U15THK8
	 0CeyGUF40WjlmLsgDo2gILuPC8STpI2wb9SNSmksu/YdqRRDf4sasDDsTas5jiMncU
	 tVKR622lvOqWvaMKg9WxHgPcWrEf8LD7ilRvBb0PGRahJff8yTP8dp8rjzTftyYtBj
	 HYqyjUP4GRy223Gz+9QpkNX3kRsiQwz0rLtyd2LTzqLd3/YCK2UQh3A/7ZxL2mrACY
	 bXC3+rgqNTCPwU1zfvrATImJ3BhYmM2fZ3l4ChM5ydjZ4SGL5y3Dqqu28Mn800xy4H
	 AMwbf4e7PZP7Q==
Date: Mon, 27 Jul 2026 23:33:12 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Chao Yu <chao@kernel.org>, Hongbo Li <hongbohbli@tencent.com>
Subject: [GIT PULL] erofs fixes for 7.2-rc6
Message-ID: <amd6OALSzdFYQOb2@debian>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Chao Yu <chao@kernel.org>, Hongbo Li <hongbohbli@tencent.com>
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

Could you consider these fixes for 7.2-rc6?

One patch fixes a new regression in page cache sharing introduced
in 7.2-rc3, which can cause a NULL pointer dereference; another
patch limits LZMA stream memory usage on systems with many CPUs.

Thanks,
Gao Xiang

The following changes since commit 1590cf0329716306e948a8fc29f1d3ee87d3989f:

  Linux 7.2-rc4 (2026-07-19 13:54:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.2-rc6-fixes

for you to fetch changes up to c9b47e6b23114e939b17f818471c7a46e59006e7:

  erofs: cap LZMA stream pool size (2026-07-27 12:31:11 +0800)

----------------------------------------------------------------
Changes since the last update:

 - Keep a valid f_path for page cache sharing to fix a recent mincore()
   NULL pointer dereference

 - Limit LZMA stream pool size when too many processors are available

 - Sync up with Hongbo Li's latest email address

----------------------------------------------------------------
Gao Xiang (1):
      erofs: ensure valid f_path for page cache sharing

Hongbo Li (1):
      MAINTAINERS: update Hongbo Li's email address

Michael Bommarito (1):
      erofs: cap LZMA stream pool size

 MAINTAINERS                  |  2 +-
 fs/erofs/Kconfig             | 15 ++++++++++++
 fs/erofs/decompressor_lzma.c |  3 ++-
 fs/erofs/internal.h          |  4 +--
 fs/erofs/ishare.c            | 58 +++++++++++++++++++++-----------------------
 5 files changed, 48 insertions(+), 34 deletions(-)

