Return-Path: <linux-erofs+bounces-4201-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05440C5B56A
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 23:37:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKShJ6bB7z2yjs;
	Wed, 12 Aug 2026 09:37:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786491424;
	cv=none; b=QRBwIPzFZtWCHO4c8EOqq9fWLHotx339e5Dt2dg8q/KjTCgrw1ygD3AbJosNtzyk/YyEoICixYvDQZudvWvYIQyaia+MWeo0HR0pzV5l9H3soxPtBelrxI3tmAOHqh2zG1pw5IygJpyo4QX2dJmVRwIG871QWPdv9sMPcioTkGMoXwJfIRs4v0lqcn6rZTcpyEjNbwWWhXNfdTW1ajyYzEBQh+JUgCMwzThviZtaE5zWIVQmC+Skt2h7Vk+G4j4rmmSwohfEssz15tBYu839wcI3RbTGDN+bIKixihkG7imQm3w42ae4bkoA/h09Hx7+rknny1GLUNlniQnOHwfw2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786491424; c=relaxed/relaxed;
	bh=GFX016VZdFBU7HNnvD6yh2FXR6VJUV1as4xnHM0gksc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfi8CHzPYdH/3kuJ05O/1AYCC/PwkpDQsKsepsA6QxnkukzVDVvLpQEteJbWpXgxR7NF2Q4CtDFFks/KpcSFUEfibMbd+gxT8/3NX487kkXh+CvYjHrfIPzUC+l3ELLHy7pfXji5eR5jE38iCZGaNMKf7/9oINEvuYaO/sCIjGRVVW/WIuO67ApzOsuIEcFKC0LMSPWCFfsgt5LHNPxl8Kur4qCw3twrknPk/gOzLKeED/NGbT3JOLYb4+V5SVyAxL8skKpsGp+QQy3F/xxAiJV/fuUwdOrN2vTsPaGI/Cr8iZQHrz4QezETqWQlgGVU2eFau00vdUyeOecSvyVkQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CK0/SYbY; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CK0/SYbY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKShH3fPxz2yRF
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 09:37:03 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 747C741820;
	Tue, 11 Aug 2026 23:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5260E1F000E9;
	Tue, 11 Aug 2026 23:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786491419;
	bh=GFX016VZdFBU7HNnvD6yh2FXR6VJUV1as4xnHM0gksc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CK0/SYbYW7X65D1Qel0r4HLPbZGiJ2w8Y41Pdxgelv/tpdDtbI4L3hN9IA8T6brH7
	 vuUlLCFWPz6e9wJ9hiFi9UMmyBHoJ6LKyYqk35oBxxYs4jb7EZyV4cYzioOUbmGgfF
	 IcjpGmOqiQhiDUGPsA8xeKFCm7UQTNNK+pK8bOnydmtZQGJRoXQeLWR3iDY6SyOr5w
	 v/0l2amSn4DEVLYc9DO2tCY14Gu4xLPyAODEEocj5RVXt0cSBjnUoW3qlf2wm7Bdkv
	 k4v5KB95uTnqtFa4Y0iYjFMREA0/HDhn2Msh8cCIKuoWpzFbQ3ZqB/H5wZ9JVoJuyG
	 Shm8kcaRbPXEQ==
Date: Wed, 12 Aug 2026 07:36:52 +0800
From: Gao Xiang <xiang@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	SJ Park <sj@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
Message-ID: <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
Mail-Followup-To: Michael Bommarito <michael.bommarito@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	SJ Park <sj@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	David Hildenbrand <david@redhat.com>
References: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local>
 <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros>
 <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
 <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>

Hi,

On Tue, Aug 11, 2026 at 03:37:38PM -0400, Michael Bommarito wrote:
> On Tue, Aug 11, 2026 at 3:35 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > Any progress with fixing this for v7.2?
> 
> I would like to fix this since I started the problem with the original
> patch, but I feel a bit stuck.  My v1 and v2 patches would not have
> triggered the build failure, but Gao made valid points about the
> trade-offs that led us to this v3.  Maybe it would be worth your
> opinion on the config approach in those earlier patches?
> 

Sorry about the late reply.

As I said, I really dislike hardcoded range, but it is an issue that no
NR_CPUS definition on CONFIG_SMP:

I wonder if the following diff resolves the m68k issue (I'm not an
Kconfig expert but it seems to work on x86_64 !CONFIG_SMP):

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 8ca1767dafb6..2dfc313588d2 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
 config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	int "EROFS LZMA default maximum decompression streams"
 	depends on EROFS_FS_ZIP_LZMA
-	range 1 NR_CPUS
+	range 1 NR_CPUS if SMP
+	range 1 1 if !SMP
 	default 16
 	help
 	  By default EROFS allocates one LZMA decompression stream per CPU.

Thanks,
Gao Xiang

