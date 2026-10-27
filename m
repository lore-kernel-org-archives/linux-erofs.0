Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B63606A31A
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Oct 2026 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIGSwWYp
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jDcxK3tvWz2yDc;
	Wed, 28 Oct 2026 04:31:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793122309;
	cv=none; b=nzyAXUdCU7MLPYUwrg/E2/V2ayheWoAZbYVgbhBMulD5QWOCB/O/wZpzeg9un07EzAYgiE8pIYR6tQ7Psw2Qv2gw918pO6wLyjvolxCW2I5P7oy1U6/FLaMyLoxvBe5wFzGXcue0WhhllRJfmd+5X/qHgXdwskSOnWZQw6vwm2+bisy/t42NPB55pdJHMmzPid1qIW11PMg5RK8ZJFxyn64oMGrSsokF+ysN4V+JgjIEkCQOTtoOJNfoq0uWTFfT7Zv7SwqKWZMhQTrVh84wnC94Pn3ydI6d1Drq7YdQxMSjOmV4R+D0KmpBzstJ19Mcm7h4l2RRwoIInAycriRgEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793122309; c=relaxed/relaxed;
	bh=ykD9hJIyGKZWLrte2Awyt7qawqEff/YzTjeoIDIVEp8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=keTXe40Mx936DntHQoVLIFuZY22KVA6E+2iRpoVrKw9be02oE9SBkX8+hEpcg9LVMR1556YhbIH7RapwkRyd9CQsuCO2MG1+dxV1KS3+5IeTIotzUrH91QmW1g5bQuaUV/Jt/WrEKzAU8dSA906p0ujcrUOoYnxhHxqi6Fi4tvzo3CyYwFB/Um1ZOVgcdt3G9PA5Xms0VFXL8zRtC9WRQAv5kbQYwYtAsBWw569/q1UfQ/z1INGlMJRPA6OCB81qYpbVno2cfNBmJsa7R/itFcdVHJbv2c9pDEUolYc3GYMjYBtK0TetEAcS8kkhVy5egki9aY2b0u7wV7FdeqwBmQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIGSwWYp; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIGSwWYp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jDcxJ0y4Fz2xLm
	for <linux-erofs@lists.ozlabs.org>; Wed, 28 Oct 2026 04:31:48 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9857B60142;
	Tue, 27 Oct 2026 17:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A201F01825;
	Tue, 27 Oct 2026 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793122305;
	bh=ykD9hJIyGKZWLrte2Awyt7qawqEff/YzTjeoIDIVEp8=;
	h=Date:From:To:Cc:Subject;
	b=QIGSwWYpH8GFRyZWPPgYNY5A2TXJHdV1J9KaEDmbILKaR9CaTNrOg4fLLYhe0gHjm
	 PxrpzG4m+TJzji9ZB5QlT/tAepCdhMTbfKCirYHWGQTCRDXbBxFjPtCOqN0M7XYWGU
	 Y+YREykYzcMGZG/Cs0vA8LJ1U0uId0Ymzu9qZW+pDKMoCYax07tkhbhDEngJ8BKfgp
	 tmUFucYulNxpUq97UG2FWPrSgajBtr5HXsO9/Wus53NckgzvNJIsAUlspMJgm4esmw
	 rz2dMIx2TQr0o7NA5N1zI6W4nT5U7LwHg490UqKG2SbD3orFn91uKXrG0Z0US8aIpf
	 Ipl5OquGKStWQ==
Date: Tue, 27 Oct 2026 18:31:39 +0100
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Hengyu Liang <hengyul@cs.unc.edu>, Chao Yu <chao@kernel.org>
Subject: [GIT PULL] erofs fixes for 7.4-rc1
Message-ID: <auDf-xw7n159FvUS@MacBookPro>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Hengyu Liang <hengyul@cs.unc.edu>, Chao Yu <chao@kernel.org>
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

Could you consider these extra fixes for 7.4-rc1?

These patches address several new reported issues related to page
cache sharing, the new superblock_share feature, and recent metadata
path changes for file-backed mounts.

All commits have been in linux-next, and no potential merge conflicts
have been observed.

Thanks,
Gao Xiang

The following changes since commit 1137aa577a35e2684e8046c3e53f920e79c7cc60:

  erofs: enable iomap for file-backed mounts on unencoded inodes (2026-10-17 17:29:36 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc1-2

for you to fetch changes up to 209108a5456171ab430e25b54b2dfe083455bfb6:

  erofs: drop unnecessary .read_folio() checks for file-backed mounts (2026-10-27 09:15:19 +0100)

----------------------------------------------------------------
Changes since last update:

 - Hold real inodes to fix mmap usage with page cache sharing

 - Fix metadata reads at the end of file-backed images with sub-page
   block sizes

 - Ensure disallowing superblock_share when device= is specified

 - Drop unnecessary .read_folio() checks for file-backed mounts to
   allow tmpfs as a backing fs

----------------------------------------------------------------
Gao Xiang (2):
      erofs: hold real inodes for shared files
      erofs: drop unnecessary .read_folio() checks for file-backed mounts

Hengyu Liang (1):
      erofs: fix metadata reads at the end of file-backed images

Zhan Xusheng (1):
      erofs: fix disallowing superblock_share if device= is set

 fs/erofs/fileio.c | 18 +++++++++++++++---
 fs/erofs/ishare.c | 43 ++++++++++++++++++++++++++++++-------------
 fs/erofs/super.c  |  9 ++++-----
 3 files changed, 49 insertions(+), 21 deletions(-)


