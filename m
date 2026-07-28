Return-Path: <linux-erofs+bounces-4024-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D54CC54F4C
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 06:55:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8R6X4dZ8z2yRl;
	Tue, 28 Jul 2026 16:55:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785221700;
	cv=none; b=K4Jqdr5rt2MvEjxX6lauMJzCwcC3r5pmUCSgBfViB1zEjhz66wFSORFMFvw1wGZ8phlvkH0TFuFHwdY3Ph9jxkqOM33q+jTzERHZZdepntV23NGx3SMtpEbbOqdbymKA/VZbXhw/nR0vnkg0//D4cBZ1s1Eqa/eZvOLiFvetEO5oqMvqPLiawnDVxRXUFD5kjqfkgDqRQuRh5CF3YcnqGo8VPdpLlWHNB5z0RmHPT8poRnhhqCUK2wsenjKrWOJ9tfgUQoHJ5Sp6n7II1HZLrZ89WJxo0UFSxgyk/oc2JtbN9FOi7ckTtgZWtp0aotC7FNgNlULm2zgHXYqbPeye+g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785221700; c=relaxed/relaxed;
	bh=iTP14JgwRm3+v6FBToeYU5L4zFOBsRIxMd84Uj++ZRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFIO9F8k+LkZtqHpv0Kw+z7XOie9kB3dCvK1vDnXNDIrBWmvjvI1ROfz0OBWJmuwsSeF11Ws+mmPB2t0YuDEfnHa01icsGjEFQFCndT/IvnohxSFVvV80hpEXG2ipVeT0/o2whC2vA5Um3sLSDlakHoJbxilMzNaG038SRHbmmRTti/A6QXsc8P/tBVUF+zQAtqrVAmYJenHAf1nHkjlo0LAx9cq+lUGw3KdRPRY78gzvTmhMIg1K0vfYI2hljYTFkmsaH50P9MWr1g9S0uC+AhwEwSg4PzcQ9Igb7TwFHf9nrzO5NGVlzYsYr4/zmVN3VGhYHlfKAwEQmfzNbvhQw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RG6ReHWQ; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=sj@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RG6ReHWQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=sj@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8R6W3Lmvz2xLq
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 16:54:59 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41FC560A62;
	Tue, 28 Jul 2026 06:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD4E1F000E9;
	Tue, 28 Jul 2026 06:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785221697;
	bh=iTP14JgwRm3+v6FBToeYU5L4zFOBsRIxMd84Uj++ZRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG6ReHWQ/Ss/hVoHQmrSK3srvu1i3RwcgsDbZCTHnhJ7fPRG6U6yIDiWsPxljXo1g
	 vKUC2JiPTjelP0vb5N56xf/fjwcJNMKUZdrlpczDlFrUq7ZDpk0i8u3L5VHMw1ANhC
	 cf8mAoOVMla2OrPNDvZ91bmQYzZH19pPvph2mlidNQxxLeuw+X6JoLVkfndy4h8r9o
	 OhOOK5ifEubN/poulBx31wPWEcXBQYC+MFdrDy0S+rbRSWkUY0aW/zhXD2qYBVUPK+
	 +olXyoCr6Khjf0FC/EpHh/oGD0IHTYu57+po64FW6mKU84wpzF05yCaSY92KSUpD0X
	 PxFGux57fFnJQ==
From: SJ Park <sj@kernel.org>
To: Gao Xiang <xiang@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Chao Yu <chao@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	David Hildenbrand <david@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
Date: Mon, 27 Jul 2026 23:54:47 -0700
Message-ID: <20260728065447.91511-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local>
References: 
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
Content-Transfer-Encoding: 8bit

On Tue, 28 Jul 2026 14:31:14 +0800 Gao Xiang <xiang@kernel.org> wrote:

> Hi SJ,
> 
> On Mon, Jul 27, 2026 at 08:46:32PM -0700, SJ Park wrote:
> > Hello,
> > 
> > On Tue, 21 Jul 2026 11:44:04 +0800 Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> > 
> > > Hi Machael,
> > > 
> > > On 2026/7/17 11:43, Gao Xiang wrote:
> > > > 
> > > > 
> > > > On 2026/7/14 19:47, Michael Bommarito wrote:
> 
> ...
> 
> > > > 
> > > I submitted the following version to -next:
> > > 
> > >  From 4ec57610a769cd93027d12134c75160390b23b08 Mon Sep 17 00:00:00 2001
> > > From: Michael Bommarito <michael.bommarito@gmail.com>
> > > Date: Tue, 14 Jul 2026 07:47:29 -0400
> > > Subject: erofs: cap LZMA stream pool size
> > > 
> > > fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
> > > pool from num_possible_cpus() when the lzma_streams module parameter is
> > > unset, then z_erofs_load_lzma_config() preallocates one image-supplied
> > > dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
> > > systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
> > > decoder state until the erofs module is unloaded.
> > > 
> > > Impact: An EROFS image mounted by the system can pin up to 8 MiB of
> > > vmalloc memory per LZMA stream, either as intended or unexpectedly.
> > > 
> > > Bound the default stream count by a new
> > > CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
> > > worst-case default preallocation is 128 MiB if the number of CPUs is no
> > > less than 16 while preserving the existing per-image dictionary limit.
> > > An explicit lzma_streams module parameter is still honoured as-is, so
> > > administrators who deliberately size the pool are not affected.
> > > 
> > > Fixes: 622ceaddb764 ("erofs: lzma compression support")
> > > Cc: stable@vger.kernel.org
> > > Assisted-by: Claude:claude-opus-4-8
> > > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > > Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > ---
> > >   fs/erofs/Kconfig             | 14 ++++++++++++++
> > >   fs/erofs/decompressor_lzma.c |  3 ++-
> > >   2 files changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> > > index 4789b1077d8ce..36f027c1c5ac5 100644
> > > --- a/fs/erofs/Kconfig
> > > +++ b/fs/erofs/Kconfig
> > > @@ -131,6 +131,20 @@ config EROFS_FS_ZIP_LZMA
> > >   
> > >   	  Say N if you want to disable LZMA compression support.
> > >   
> > > +config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > > +	int "EROFS LZMA default maximum decompression streams"
> > > +	depends on EROFS_FS_ZIP_LZMA
> > > +	range 1 NR_CPUS
> > 
> > Hello, I just found this breaks CONFIG_NR_CPUS undefined builds.  For example,
> > my m68k build test [1] shows problems like below:
> > 
> >     $ build_m68k_w1.sh
> >     [...]
> >     fs/erofs/Kconfig:137:warning: range is invalid
> >     .config:13480:warning: symbol value 'NR_CPUS' invalid for EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
> > 
> > I confirmed using 1024 as the upperlimit of the range, like the original patch,
> > fixes the problem.  I'm not sure if that's the right and preferred fix, though.
> > I'm just reporting my finding.
> > 
> > [1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_m68k_w1.sh
> 
> Thanks for the report, but may I ask if it was a warning instead of
> a configuration failure?

Indeed it didn't directly fails.  Instead, it was trying to do config again,
like below.

[...]
fs/erofs/Kconfig:137:warning: range is invalid
.config:13479:warning: symbol value 'NR_CPUS' invalid for EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
*
* Restart config...
*
*
* Miscellaneous filesystems
*
Miscellaneous filesystems (MISC_FILESYSTEMS) [Y/n/?] y
  ORANGEFS (Powered by PVFS) support (ORANGEFS_FS) [Y/n/m/?] y
  ADFS file system support (ADFS_FS) [Y/n/m/?] y
    ADFS write support (DANGEROUS) (ADFS_FS_RW) [Y/n/?] y
[...]
  UFS file system support (read only) (UFS_FS) [Y/n/m/?] y
    UFS file system write support (DANGEROUS) (UFS_FS_WRITE) [Y/n/?] y
    UFS debugging (UFS_DEBUG) [Y/n/?] y
  EROFS filesystem support (EROFS_FS) [Y/n/m/?] y
    EROFS debugging feature (EROFS_FS_DEBUG) [Y/n/?] y
    EROFS extended attributes (EROFS_FS_XATTR) [Y/n/?] y
      EROFS Access Control Lists (EROFS_FS_POSIX_ACL) [Y/n/?] y
      EROFS Security Labels (EROFS_FS_SECURITY) [Y/n/?] y
    File-backed EROFS filesystem support (EROFS_FS_BACKED_BY_FILE) [Y/n/?] y
    EROFS Data Compression Support (EROFS_FS_ZIP) [Y/n/?] y
      EROFS LZMA compressed data support (EROFS_FS_ZIP_LZMA) [Y/n/?] y
        EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [NR_CPUS] (NEW)

And, I find no way to go out of the prompt other than Ctrl-C.

> (because I didn't see a report on -next also
> I don't have a m68k testfarm).

I don't have a m68k testfarm, either.  I'm doing crossbuild [1].  Hopefully you
could also reproduce it.

> 
> Personally I think NR_CPU is better than an arbitrary number (like 1024)
> for sysadmins (or vendors) to customize their kernels so I hope I could
> find a way to use NR_CPUS-like approach instead of a hardcoded number.

I agree.  I have no good idea for the right fix at the moment, though.

[1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_m68k_w1.sh


Thanks,
SJ

[...]

