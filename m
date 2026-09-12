Return-Path: <linux-erofs+bounces-4549-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B85BC79FB6
	for <linux-erofs@archiver.kernel.org>; Sat, 12 Sep 2026 12:50:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hhrqm1wGkz2xy3;
	Sat, 12 Sep 2026 22:50:44 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789217444;
	cv=none; b=fi8c9W8e4eWnCnCJroUk10ADxkGUw6d4lW+RILXa12G9AGGZMRx4sW25rHp9hONuHF3gOtg/RzJ4aLRYcNhWrPvIT3hrWflEKgwFY9pYq/CVj1/u9B8LmskQLNI/gc/H17mAMU0bj7RAJqcrJ8e+GbK1kQ0TJA9KqYqSkpX5osw+rMcKIFbxAJtPkhGrPdde09dEHyKgu8OYj+ZJhbNrGjP/UVdm0q5nRIY4/LX7/E+2XHjjZTaD3WjnFZ4z220FsBpPVPR0j0H+QWH7gUgSqfdZqmnHqk9yG9L2BcDN0fKoa7GCYOBoAhZTlaJK+zuPp0ReJ3B8DUoZuVI9rezusQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789217444; c=relaxed/relaxed;
	bh=eNq1op5ezbt97IUUfSwak+X0tpZtHNmTMqQGd5E3XXg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=h151IbUE0TGCsDaltsovRP+ipjjsRJldUnfcVjOGLRc4+Emh8SAFJZ4AkVFu/TgNQXO1zy6jOKgig6NOaPMX9c9pLsF+vghrucIefGDUt22GOy+uhUtcfRmMtxMiKg9S2sZdReSzFefD356CQJN2r0+h8ymDNEshNdvBGxVFBqHQKOdWaegE4Ibs/1Z31Oxj/WEEhdm41THlKU1Zv+F9uZJR+Ein8tmBsUPp38LglRKuihRBxJRuPTRfjinK93BYnRw9MoozGsGIGBMuKRBu7+fjQUlN0+xO9IeV+otVOJwtBVxhsQ7sYDHM4mObVKM1mpexn5XksBHZd26h0772Ug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ix5uvgYA; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ix5uvgYA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hhrql3FHvz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Sat, 12 Sep 2026 22:50:43 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC1DE43B14;
	Sat, 12 Sep 2026 12:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A16F1F00893;
	Sat, 12 Sep 2026 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789217440;
	bh=eNq1op5ezbt97IUUfSwak+X0tpZtHNmTMqQGd5E3XXg=;
	h=Date:From:To:Cc:Subject;
	b=ix5uvgYAHl0eXNMygcQoGz1gHxvqrDHoLPrPEgmcirTwmMuSrixPLlH2JVPr9rNbz
	 2aYar/z3fqLSDmDpI18WvNr3Ps974LN72D0UeuSf2OBZI7Kz05xlmZi2Remc6yFQt+
	 JZw6VuFtCTyI+1o5znmPqPn9o3gsvGrh4Yqus9oEZzuAc1BmjfhIX/WxSNqhcsIM6b
	 50s6/P5dp+3yo19SLaCus8HygHRg0pBjNLQgdPQI0CZRAmJb7mesJ948CyOrDUmDea
	 tqsD3/uQh8gCAP+B2la2Us/SaMHXfx0bSSfqiyCjtP/MUwQe0H1yZ/UOuncWtYs6Ju
	 tOmACcpcCMPFQ==
Date: Sat, 12 Sep 2026 20:50:26 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Chengyu Zhu <hudsonzhu@tencent.com>,
	Binglei Wang <l3b2w1@gmail.com>, Chao Yu <chao@kernel.org>
Subject: [GIT PULL] erofs fixes for 7.3-rc3
Message-ID: <aqVKkkgDZCBO-0Df@XiangdeMacBook-Pro.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Chengyu Zhu <hudsonzhu@tencent.com>,
	Binglei Wang <l3b2w1@gmail.com>, Chao Yu <chao@kernel.org>
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

Could you consider these fixes for 7.3-rc3?

The most impacted one is to disable LZ4 rolling decompression for now:
AWS folks recently found their systems could get corrupted data with
some rare, specific LZ4 datasets, and after a deeper analysis, I found
the root cause is that there could be uncontrolled backward memory
copies in the current LZ4 implementation and it breaks the assumption
of the rolling decompression optimization, since the kernel LZ4 codebase
is out of our control and it needs more time to plan how to do next, so
disable LZ4 rolling decompression for now to ensure data correctness for
real production on these rare cases first.  The technical details also
see the corresponding commit.

Other changes are random minor fixes.  All commits have been in -next
and no potential merge conflict is observed.

Thanks,
Gao Xiang

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc3-fixes

for you to fetch changes up to 135d84c66f85426299db01a09d93a79a87af18ba:

  erofs: add missing buf->off in erofs_bread() (2026-09-11 12:16:20 +0800)

----------------------------------------------------------------
Changes since last update:

 - Fix the missing sysfs feature entry for xattr prefixes

 - Fix invalid LZMA decoders on resize failure

 - Disable LZ4 rolling decompression for now due to the uncontrolled
   LZ4 implementation

 - Rearrange the inode_share cache key to avoid potential collisions

 - Fix erofs_bread() when fsoffset is used on sub-page-block EROFS
   filesystems

----------------------------------------------------------------
Binglei Wang (1):
      erofs: add missing buf->off in erofs_bread()

Chengyu Zhu (1):
      erofs: delimit inode_share cache key components

Gao Xiang (1):
      erofs: disable LZ4 rolling decompression for now

Jingbo Xu (1):
      erofs: add sysfs feature entry for xattr prefixes

Nikhil Gurudasani (1):
      erofs: preserve LZMA decoders on resize failure

 Documentation/ABI/testing/sysfs-fs-erofs |  2 +-
 fs/erofs/data.c                          |  2 +-
 fs/erofs/decompressor.c                  | 55 +++++++-------------------------
 fs/erofs/decompressor_lzma.c             | 18 ++++++++---
 fs/erofs/internal.h                      |  6 +---
 fs/erofs/sysfs.c                         |  2 ++
 fs/erofs/xattr.c                         |  9 +++---
 fs/erofs/zdata.c                         | 18 ++---------
 8 files changed, 39 insertions(+), 73 deletions(-)


