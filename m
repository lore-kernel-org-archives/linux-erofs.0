Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0621606A323
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NlpcSvnq
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQXwk5c8vz2xnh;
	Fri, 13 Nov 2026 08:05:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794517542;
	cv=none; b=QpENdlF8ZYLh0GeFiNOTiTr8Aufk7b0C5tQR7Xzk8FvwiWFZXV0QftiPdxLTB3ia0BhrbB5uSBqNIT1IUSbe6BSxuhiJyLTJAvY+LYWgWfoO3N92ZUhCRlCP/U6rsmxwsdXqtSKXRVAi2PMG/0B7l4V0SyRUlFHc+oFpuchbXfjJymmgPuLZtgDw4+/AtRfVmMXq9ppXEvRQK0tJ11Bfh56MSgUx9UII03kzPgi0b+jFxPlQt5uaooV5WVfb4+rRI5Vbg13M23rZscmwyFQGgx2G8BH5VHT3/hf9tcjEDobHwcR2PRxwotQzFYJCBcoEBTBTWqOwLAJ60MwYVet9og==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794517542; c=relaxed/relaxed;
	bh=Nnihpci5dvzV4RG5w4j5rrlOdcTEXO4ytfQ14nCnRqw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mNT9rGIznzwpZnvqfwbGz6FRb+XJLKbPEuD8pchHUXIskHdEH+B1qE2lQENKJz6detNDAGz4IX1RONO4DLrpccDF1/ytKlzPO2yhE0/7IDbp3eBCJnkOcBpzuGnTjbziHVL/NIxh0k4Ufh7rlmcemmtsGvqE0zSGf2AB68hzzXroS3Ia8/91A/Xy8ln3A/J1PweqeBDyVztVzYX/C2w/8nLfPvuL//U5ap39fRPfW6zaoLColdf55P+ez4sgl9nyB1mMGprkiZP0jta+UAgNFXb+Yxweu4yeJL4Zht9/42vr6NcsVLTHhkgidSBImx8+waOJVflgkSI5C/XR6xUZSA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NlpcSvnq; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NlpcSvnq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQXwj6qkVz2xjM
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 08:05:41 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59BA5602C2;
	Thu, 12 Nov 2026 21:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7121F000C4;
	Thu, 12 Nov 2026 21:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794517539;
	bh=Nnihpci5dvzV4RG5w4j5rrlOdcTEXO4ytfQ14nCnRqw=;
	h=Date:From:To:Cc:Subject;
	b=NlpcSvnqYM03smxCXoTR3BZduo9UmbLB6uaR9Pg8Y/oJjnI2MVyuLnY1Sa1F8sbct
	 GzcpGdE3ncJSM55SsHjp4nvvSIOGJYb2XjBi/OTr+X0cM0vF3xDMKnvwpDucYPXvC3
	 11KgN7vBTAKoU3bt5IgT8KzEYw+CdFXmP6dKxKlA+E61pEMUiijJBC1k4Y7kvf/Zsj
	 +mX+4YWnfMSVW9KbJRFY/+7V2yDD1X5GTpqwaPi37hBlj7s12ef9piSngcbqw+L+5A
	 dLuPGk26NN3in/Y+zk40V0fXzbP3i32qYJOSj2tZhLJgNVRw6gYhCXaHTqZPiV4INF
	 UdvgyIBXpZ7LQ==
Date: Thu, 12 Nov 2026 22:05:25 +0100
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>, Chao Yu <chao@kernel.org>
Subject: [GIT PULL] erofs fixes for 7.4-rc3
Message-ID: <avYqFWIxinR9JB0O@MacBookPro.fritz.box>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>, Chao Yu <chao@kernel.org>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

Could you consider these fixes for 7.4-rc3?

There are some recent random fixes (shown below) and a Documentation
update on on-disk format high-level overview.

Thanks,
Gao Xiang

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc3-fixes

for you to fetch changes up to 7906eac042a4d6facd3b2dcebfe7179fedfcf1f2:

  docs: erofs: refine the on-disk overview (2026-11-12 10:31:25 +0100)

----------------------------------------------------------------
Changes since last update:

 - Fix stacked fs check for file-backed mounts with extra devices

 - Disallow file-backed mounts on shared backing inodes

 - Reset metadata offsets when fsoffset= is used to fix xattr reads
   inside and outside the metabox in ont shot

 - Refine on-disk format summary

----------------------------------------------------------------
Daejun Park (2):
      erofs: apply the stacked fs check to extra file-backed devices
      erofs: treat files shared by inode_share as stacked

Gao Xiang (1):
      docs: erofs: refine the on-disk overview

Zhan Xusheng (1):
      erofs: reset buf->off in erofs_init_metabuf()

 Documentation/filesystems/erofs.rst | 120 +++++++++++++++++++++++++++---------
 fs/erofs/data.c                     |   1 +
 fs/erofs/super.c                    |  23 ++++++-
 3 files changed, 112 insertions(+), 32 deletions(-)

