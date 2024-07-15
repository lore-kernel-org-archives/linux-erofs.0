Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69FBC2BD09
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jul 2024 06:22:46 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=cX5HT+C6;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WMsZF0snnz3cfQ
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jul 2024 16:22:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=cX5HT+C6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WMsZ75zTGz30Wn
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jul 2024 16:22:39 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 39AA560C94;
	Mon, 15 Jul 2024 06:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59614C4AF0A;
	Mon, 15 Jul 2024 06:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721024556;
	bh=Co1Akgsep+V5e0x3SqKrYkPdSIfOqSklD63YDt8g5Ns=;
	h=Date:From:To:Cc:Subject:From;
	b=cX5HT+C6feoGfAic3pfRtIP+Ps13HfXKzbul1Heg5+MDHnUMYqVQi8CX6b1xF9Tjd
	 bBnxsFlV9vM3lRe6iC7hIjAdX8MGm4aFhzjorAnCFVQqlpMuymoqX/WS8SMJm66glk
	 ONZ2LFoiNtace049iRGggYA67l74Crb4EeXBAhsRohG9TgnkPShlRf5xYYrxj0fNrn
	 g1sBJ9uqq19dLqP2ghdoTz9tObkR12i6Ght+zFBqLJQp2LTa8G+xIg22rZupWOFlpA
	 HkXLnp7n3aCWh3HQ0z631IEa0SYolhgYdJE6RabHOg8hxaSmVkOmAkh/OcvbTeyRO7
	 mYQk1DX3zXshw==
Date: Mon, 15 Jul 2024 14:22:27 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] erofs updates for 6.11-rc1
Message-ID: <ZpTAI1mLZ1pfTnz8@debian>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Hongzhen Luo <hongzhen@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>
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
Cc: Hongzhen Luo <hongzhen@linux.alibaba.com>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Linus,

Could you consider this pull request for 6.11-rc1?

No outstanding new features have landed for this cycle so far.

There are patches addressing folio conversions for compressed inodes:
While large folio support for compressed data could work now, it remains
disabled since the stress test could hang due to page migration in a few
hours after enabling it.  I need more time to investigate further before
enabling this feature.

Additionally, there are also some patches to clean up stream
decompressors and tracepoints for simplicity.

All commits have been tested and no potential merge conflict is
observed.

Thanks,
Gao Xiang

The following changes since commit 256abd8e550ce977b728be79a74e1729438b4948:

  Linux 6.10-rc7 (2024-07-07 14:23:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-6.11-rc1

for you to fetch changes up to a3c10bed330b7ab401254a0c91098a03b04f1448:

  erofs: silence uninitialized variable warning in z_erofs_scan_folio() (2024-07-13 12:47:34 +0800)

----------------------------------------------------------------
Changes since last update:

 - More folio conversions for compressed inodes;

 - Stream decompressor (LZMA/DEFLATE/ZSTD) cleanups;

 - Minor tracepoint cleanup.

----------------------------------------------------------------
Dan Carpenter (1):
      erofs: silence uninitialized variable warning in z_erofs_scan_folio()

Gao Xiang (8):
      erofs: convert z_erofs_pcluster_readmore() to folios
      erofs: convert z_erofs_read_fragment() to folios
      erofs: teach z_erofs_scan_folios() to handle multi-page folios
      erofs: tidy up `struct z_erofs_bvec`
      erofs: move each decompressor to its own source file
      erofs: refine z_erofs_{init,exit}_subsystem()
      erofs: tidy up stream decompressors
      erofs: avoid refcounting short-lived pages

Hongzhen Luo (1):
      erofs: get rid of z_erofs_map_blocks_iter_* tracepoints

 fs/erofs/compress.h             |  61 ++++---
 fs/erofs/decompressor.c         | 148 ++++++++++++++---
 fs/erofs/decompressor_deflate.c | 149 +++++------------
 fs/erofs/decompressor_lzma.c    | 166 +++++++------------
 fs/erofs/decompressor_zstd.c    | 154 ++++++------------
 fs/erofs/internal.h             |  48 ++----
 fs/erofs/super.c                |  34 +---
 fs/erofs/zdata.c                | 346 ++++++++++++++++++++--------------------
 fs/erofs/zmap.c                 |   4 +-
 include/trace/events/erofs.h    |  32 +---
 10 files changed, 496 insertions(+), 646 deletions(-)
