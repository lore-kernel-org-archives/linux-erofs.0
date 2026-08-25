Return-Path: <linux-erofs+bounces-4342-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A01C61DB9
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Aug 2026 16:18:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTtHH3twpz2xVq;
	Wed, 26 Aug 2026 02:18:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787674683;
	cv=none; b=iUd4x4LY2CwFWQL8NgdzHrw5f4bm3s3JzMb4MJj7yswQ7wqh+v12coaXLWMhwhsq6iR0jZDYWIeaLz9saZc5YmBBw3lPVgYIMItS4MUFJ5zF7ZoIvsmwQ3OvbCCyHCJQvbIKby1OhfHD+1LeHF20RltUsU7NCRSdsWVewp961SHquBabZcfcncfgpBcwZLO5EyRijRB0UFGqlHIgUMniDafErSuiyJasxk/22N5UDC5pAJfh64d8e216wzBAxsoHY11hjwfZ/BDT9R8Dli8WDXMMl2rtmaC+Oz29o9dVbIK2NeDPXX/KWQ3+3jvMrZqcf9pz/mMAvemuiLCVUsRDxA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787674683; c=relaxed/relaxed;
	bh=PhxiFq9Zde41Z4GbGC4tAZq3wm4ebaqK1iNmqjZFUdw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nzlax+rkZ7TDhAK9U8dsz6oGWilftWOicUI9FPTdRWgz06XCyW6Ucomviii1BVBvjZ78L+5L8aunQPppbbZmNK77c04P/tao13OF6Y2r1IFneAmubCNA18/DpTQn7r6GcfTdOF6c1oYdaCLUHspijriaQULGwjMsC/9p7jdpT4R+szr16HVA8432BX9ZEtfXkQ/qatjD7gicBE7XIFsYIc5dRcF8qBo4yDoenl3npprXaY1izYwijnMmJy0F4Wpl6OaSlV9x3s8nQ/0bA6ujYuAnOp/IpIutJ5uEYZJHSNn8CPDkWTsYCGlubkrHPD7BhVDCc5VqxwGZaiqywdy8NQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgHbkkw9; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgHbkkw9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTtHG4YcDz2xKh
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 02:18:02 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15AEA601E9;
	Tue, 25 Aug 2026 16:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1F61F000E9;
	Tue, 25 Aug 2026 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674678;
	bh=PhxiFq9Zde41Z4GbGC4tAZq3wm4ebaqK1iNmqjZFUdw=;
	h=Date:From:To:Cc:Subject;
	b=XgHbkkw96LWfBEpPobn/j31D2wlGh4DxuqMQqjFQC+oEcGY49QKp/eh4A3jCK8Owz
	 ygJy+OV3nXs1gALM4t7P+MwYblapQzlx8HIT20NZOveeL6/FVzwoMUOZfaDQw9lwtZ
	 u/AMsVbyfmuQgReeTBVUKtqsfLWJ2WNvvMm4YWqf5e6Lac5o0ZLZ6FhX7FjFACpepv
	 w8c0XZ/SeV/vffjibKSbiCYuu5MOZht3WY4ttFdkL7hpfxS3oLvU6uvjFEqpGAzlVq
	 HkSRm3VqANc/IwlGk21OHKHaA2HdKIZRiv8GU79j11eVPYC4kZ/wg2OrvXoMii2Dmo
	 OpJhJ/p3+1xmw==
Date: Wed, 26 Aug 2026 00:17:49 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Chao Yu <chao@kernel.org>
Subject: [GIT PULL] erofs more updates for 7.3-rc1
Message-ID: <ao3ALZVbrWYuY6nw@192.168.5.19>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
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

Could you consider these extra patches for 7.3-rc1?

All commits are quite small, so I guess there's no need to delay them.

One patch from Geert addresses EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
again, so that "make savedefconfig" won't write the needless default
value to the defconfig file. It avoids unnecessarily enlarging the
defconfig files and reduces churn when updating them.

In addition, there are small changes to enhance the page cache sharing
feature to support SEEK_{HOLE,DATA}, splice(), and large folios.

The remaining one fixes an issue in z_erofs_gbuf_growsize() as below.

All commits have been in -next and no potential merge conflict is
observed.

Thanks,
Gao Xiang

The following changes since commit 8d3ae59288f1e7d58d76558a6ee96d533bc5019f:

  Linux 7.2 (2026-08-16 14:32:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc1-2

for you to fetch changes up to a7d28aa0e9b2c983b915d091f9596f0e3b253355:

  erofs: simplify z_erofs_gbuf_growsize() (2026-08-24 12:21:24 +0800)

----------------------------------------------------------------
Changes since last update:

 - Fix up the EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic so that
   "make savedefconfig" won't write the needless default value to the
   defconfig file

 - Add support for SEEK_{HOLE,DATA}, splice() as well as enable large
   folios in inode_share mode

 - Fix z_erofs_gbuf_growsize() after the previous buffer resizing fails

----------------------------------------------------------------
Gao Xiang (1):
      erofs: simplify z_erofs_gbuf_growsize()

Geert Uytterhoeven (1):
      erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic

Jingbo Xu (2):
      erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
      erofs: support large folios in inode_share mode

Nikhil Gurudasani (1):
      erofs: skip sufficiently large global buffers when resizing

Zhan Xusheng (1):
      erofs: support splice() in inode_share mode

 fs/erofs/Kconfig    |  8 +++++---
 fs/erofs/data.c     |  2 +-
 fs/erofs/internal.h |  1 +
 fs/erofs/ishare.c   | 12 ++++++++++--
 fs/erofs/zutil.c    | 20 +++++++++-----------
 5 files changed, 26 insertions(+), 17 deletions(-)

