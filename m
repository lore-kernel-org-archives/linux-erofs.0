Return-Path: <linux-erofs+bounces-4250-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AC4C5DF67
	for <linux-erofs@archiver.kernel.org>; Tue, 18 Aug 2026 03:37:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hPFkN2rbpz2xrL;
	Tue, 18 Aug 2026 13:37:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787024220;
	cv=none; b=Iq3i60j8ruQjZEpjZnqDKPAWOslbEjbxUV6JV3j0ccj/7NqQV3PSgsCvHMlc6RFxPcRf33KY9x/T8YZSvd9nR3DARmk9i4cyHR9ISQDDxhisquiZvpTow6vR/Vsx+iA/1q5T+OSCyrkO+Az6mNdKtJQL9wcrMIGFHFfG9rIOSp1Y7vYq0+0rtZikyIIH9CeIbtXJOw988SUToSvY9FXtb6XP20dLQYSzWbsiKaJLIa/BQpDcLG7wXmNaSTslfHOrRK4s1wRtzOjMFb8yBiA4KI0KZhq0HJWhQ3M1E8iowY7s5vR8PyOGwTi+eUcbiBqmmP7I1zVOLOnqPTeW8ujBMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787024220; c=relaxed/relaxed;
	bh=yi+pbcoZaoSXy68gOZda6jIs+/cJrH+Cn/Lg8qlrRxM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YI3DJxG0KfbghHjfbpb0WuxFYsJqlfL7icbkrpHp6MenN8nMs/biOpgp9glTeo3K26Q6PxnHcTyzfXHKKupwwlSRIY9J36Hh9fNaKv5LaWTuh0JwuAGFGlOCfZR7iiE2G6asci9d9Omp8ImggnMuUR2NS14nybjfiMamUnx/MEHUNT/BIdTEXsjRhRzN10mwG0Fuuej5u7/JksDwo8Fsz5g4EqbMni+9+o6cqbCH3hVIRJFpMuck2KBouQYCoTrM4NJZhwMCXX40yrhR6pZnmEi9nG2ZlX4vRy/ezRrC2bQ/HD4wSW5wESyt1y7k0jHYifR+GF6qN75vZR6BotXnaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=In1e8j0F; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=In1e8j0F;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hPFkM2Wpkz2xpv
	for <linux-erofs@lists.ozlabs.org>; Tue, 18 Aug 2026 13:36:59 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 268BF4383B;
	Tue, 18 Aug 2026 03:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9771B1F000E9;
	Tue, 18 Aug 2026 03:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787024216;
	bh=yi+pbcoZaoSXy68gOZda6jIs+/cJrH+Cn/Lg8qlrRxM=;
	h=Date:From:To:Cc:Subject;
	b=In1e8j0FbTKiLV0rMQakDhR/P6u0eEsbCqh97u+XzulKszZ9i6wxpaRnSdFD33gY8
	 It6+q6oZEPbaWRqjvnT3rZL518NTPH+VsBcu9WI+dOce0BUOMV/Xqs0/nzPDAzdzzi
	 UO8WLF79YpcYFUoWgZIkvsvWD4Q689zYnXVBcMGGmUaM/Vwvi/Ha3Z4MB7VxD8t6zd
	 XOQzGTDyfInwcoy8+MrwB9eYB5j2/X7uEmM8SWoBghwT6rED2KJsb7OAnkspjSUS88
	 Yl4jZd5gTBggAh6VujNGFnD7BFOngJTQ9heh3CtOH91G8izDirr5muH8kPsFjWQfpB
	 veSjVv3wRJ2HQ==
Date: Tue, 18 Aug 2026 11:36:50 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Chao Yu <chao@kernel.org>
Subject: [GIT PULL] erofs updates for 7.3-rc1
Message-ID: <aoPTUl2rn-iIaXPy@XiangdeMacBook-Pro.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Chao Yu <chao@kernel.org>
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

Could consider these commits for 7.3-rc1?

The most notable enhancement is to allow passing source fds via
fsconfig() for composefs. The others are all various fixes.

All commits have been in -next and no potential merge conflict is
observed.

Thanks,
Gao Xiang

The following changes since commit 075b74841bd0065a3bda3440873c747938e69b68:

  Linux 7.2-rc6 (2026-08-02 16:24:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc1

for you to fetch changes up to 988c3c186c730590a71df8adc1424c5578ef8bae:

  erofs: fix unused pcluster_pools for higher page sizes (2026-08-17 17:05:58 +0800)

----------------------------------------------------------------
Changes since last update:

 - Allow source fds via fsconfig(), in addition to source paths

 - Use dedicated metadata inodes for file-backed mounts

 - Disallow invalid interlaced ztailpacking pclusters

 - Validate on-disk compression algorithm IDs against supported ones

 - Fix unused pcluster pools on higher page-size platforms

----------------------------------------------------------------
Gao Xiang (3):
      erofs: use dedicated meta inodes for file-backed mounts
      erofs: fix interlaced ztailpacking pclusters
      erofs: guard on-disk algorithm IDs against Z_EROFS_COMPRESSION_MAX

Giuseppe Scrivano (2):
      erofs: fix typo in error messages
      erofs: accept source file descriptor via fsconfig

Ojaswin Mujoo (1):
      erofs: fix unused pcluster_pools for higher page sizes

 Documentation/filesystems/erofs.rst |  17 ++++++
 fs/erofs/data.c                     |  28 +++------
 fs/erofs/decompressor.c             |   1 +
 fs/erofs/fileio.c                   |  21 +++++++
 fs/erofs/internal.h                 |  14 +++--
 fs/erofs/super.c                    | 112 ++++++++++++++++++++++++++++--------
 fs/erofs/zdata.c                    |  25 ++++----
 fs/erofs/zmap.c                     |  38 +++++++-----
 8 files changed, 182 insertions(+), 74 deletions(-)

