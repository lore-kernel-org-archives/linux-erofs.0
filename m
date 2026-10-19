Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4F606A323
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Oct 2026 20:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HhX7jsHF
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j7mrm6mBWz2yYK;
	Tue, 20 Oct 2026 07:11:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792440664;
	cv=none; b=nsOOm510uYPmnTrU8zBr8rZAF/rLvKqLqHROQBdLlb7F0pwiKTk5YdUFNgZLaTJy+HMMPRsasmvrQzejQIMQW9J0Wjl4FlznUsFoca07DBzrxMSFnrUZ5ogKJddJd6qdqPL15BiCrAEy3Zp4uYb2EIIpW5eDJ69uzpzGFKXWgGQszV4KcoXQfdq8+IpvRB8bultyfYRXanTaQCQf3s04rRaEBY4EhMfUNTl82aBaF3Ehx3LaTgyfWolyK9YUrTzQEbjw3XGM/EsN2hHFb5Cr6JHlff4806GgPXVwCSRI6/jtqU0XdSVnhJDnHgGldKSijW8/sCZpR5hdhz2JT8BU6w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792440664; c=relaxed/relaxed;
	bh=qidcyy0hfoTCKGqGDR7rx4LiUit+fnvx+mfaoo40PIs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MiQK3zNbv+JBSmWgva2UfPcmQsXa8t8gVHN1ZTMT/BjPXObr5u94QjOBQsvqY5URgXNhhbZIN/WpoC15MHiwgmxWPxJSuBTG0ZIu98GFES+WUf2KmEioxHVDKsXKUtM2kR/aMmEhQ+fy9ajI/3uvJqoYGEek/nxkjis3aHM6gNjaE1Jp5aTloaU2n/+GJG85NJWi9VDTEspfAKr8fzGxb5HyIu2Dt08Y/4EN6KHpoI/8CP23YAksliRvWkekF4klh5zWSPUcJh723E0uetrs3TrVG1HEz9OVdnbyLEQ/wu3Uf5PpXSWmEaxF/lIIMUwOJlwpXnfiDQ/uWU/Mref8eA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HhX7jsHF; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HhX7jsHF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j7mrk4rhJz2y2J
	for <linux-erofs@lists.ozlabs.org>; Tue, 20 Oct 2026 07:11:02 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F12BE60211;
	Mon, 19 Oct 2026 20:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0181F000C4;
	Mon, 19 Oct 2026 20:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792440654;
	bh=qidcyy0hfoTCKGqGDR7rx4LiUit+fnvx+mfaoo40PIs=;
	h=Date:From:To:Cc:Subject;
	b=HhX7jsHFE6lelJYBSux0lB7vMAvDLPWpxRsOJYXUChc6CpiA8Y/nprIN1uNmNclVs
	 IXCoB532F3waUePdBuO2Zpj9yEAQXGHcKQl/Ta+wX7e2z5+OLFbJzEHAnpkcI4gmst
	 aC5IfMj6MdFY4/Mtg6WHzVVHn6KjJgi92O1eekpuEaqt4AeDOPMr3iwT/n18ODyhMH
	 guVpfw70wmYBzTjwJEpxuLKM3UdGpVxAEv0bRRs1VSbohJ3OzDkd1eX8Di1fmDteSE
	 6tFtlbfxv8OewnojPtbMHtYXRJ8FtUzFurug5T/pwUi3excPFLxaMK9xsuEm0lrAqz
	 KiZHd0ulv1j8A==
Date: Mon, 19 Oct 2026 22:10:41 +0200
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Binglei Wang <l3b2w1@gmail.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Chao Yu <chao@kernel.org>, Jingbo Xu <jefflexu@163.com>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [GIT PULL] erofs updates for 7.4-rc1
Message-ID: <atZ5QThkCK8UnB28@XiangdeMacBook-Pro.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Binglei Wang <l3b2w1@gmail.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Chao Yu <chao@kernel.org>, Jingbo Xu <jefflexu@163.com>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Christian Brauner <brauner@kernel.org>
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
X-Spam-Status: No, score=-21.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

Could consider these commits for 7.4-rc1?

The most notable change is to support superblock sharing for composefs,
thanks to Giuseppe again: it needs a vfs change, which already goes
through vfs tree [1] so I merge the corresponding vfs branch.

Another one switches to iomap for file-backed mounts on unencoded inodes,
which enables efficient sub-folio I/Os. The others are all random ones.

All commits have been in -next and no potential merge conflict is
observed.

Thanks,
Gao Xiang

[1] https://lore.kernel.org/r/20261016-vfs-7.4-rc1.shared.super-9c2de4415e8b@brauner

The following changes since commit a90ee4305c4a5df72c11b31dacfdc76e00fcf78a:

  Linux 7.3-rc6 (2026-10-04 13:45:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc1

for you to fetch changes up to 1137aa577a35e2684e8046c3e53f920e79c7cc60:

  erofs: enable iomap for file-backed mounts on unencoded inodes (2026-10-17 17:29:36 +0200)

----------------------------------------------------------------
Changes since last update:

 - Support superblock sharing for file-backed mounts

 - Use iomap for file-backed mounts on unencoded inodes

 - Minor fixes and cleanups

----------------------------------------------------------------
Binglei Wang (1):
      erofs: fix xattrs handling when metadata compression is used

Chao Yu (1):
      MAINTAINERS: erofs: add dev branch to git tree entry

Christian Brauner (1):
      Merge patch "erofs: share the superblock for file-backed mounts"

Gao Xiang (3):
      Merge branch 'vfs-7.4.shared.super' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
      mailmap: update entry for Gao Xiang
      erofs: enable iomap for file-backed mounts on unencoded inodes

Giuseppe Scrivano (2):
      fs: rename vfs_get_super() to get_tree_super() and export it
      erofs: reuse superblock for file-backed mounts

Gyokhan Kochmarla (1):
      erofs: use on-disk blkszbits for lz4 max pcluster bound

Jingbo Xu (1):
      MAINTAINERS: erofs: update my email address

 .mailmap                            |   1 +
 Documentation/filesystems/erofs.rst |   7 ++
 MAINTAINERS                         |   4 +-
 fs/erofs/data.c                     |  34 ++++----
 fs/erofs/decompressor.c             |   2 +-
 fs/erofs/fileio.c                   | 157 +++++++++++-------------------------
 fs/erofs/internal.h                 |  12 ++-
 fs/erofs/ishare.c                   |   4 +-
 fs/erofs/super.c                    |  56 ++++++++++++-
 fs/super.c                          |  19 ++++-
 include/linux/fs_context.h          |   4 +
 11 files changed, 161 insertions(+), 139 deletions(-)


