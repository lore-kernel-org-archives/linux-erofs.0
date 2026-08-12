Return-Path: <linux-erofs+bounces-4210-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45163C5B56A
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 14:21:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKrK04H5Fz302l;
	Thu, 13 Aug 2026 00:21:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786544500;
	cv=none; b=FhvdzR3DCiwOnkXw9LMioCMqb9CWGzF/vtfNC5d4q3cxfCW8IHLP5e0yc/fBujhf5fTYPSrPZy8rCEIrEZ1M8331s1URZ2+1Y2WaDggWLFkTgzP5Ozy0HDhl+PqlwT+cb5K6kmVOOqSRnelBwL4aqIYzu4bCfV8DnqhjnMug87R0nCs9VFKAsesvnRxtqT6Imblk6Ybb9n5ew1tSA5GtDilgrKfxQ0RRwaMYKmPosp1zkZ9rhUWxhrCQdTUEjdJbQ0RgpU8kbxCqe3nZrNPiWjObJZ849p4PSUoI+4W1XiNOowufzqXNmN3VdtmSA9PSXG2NIfTkHVwdSG4p7N7etA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786544500; c=relaxed/relaxed;
	bh=a7uHO+cls4zicW3uCaFv9/XNqct5VHTMhLbXkR3nur0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPI72/SN8LuHfLIisQpS47cpIsknMaaCE1y05d/FI7+O4xx1imc4E1QEaAyP65AmVtVl0NwxUy4/c26YmbQzMvv2YjVG7jNwuxn5d+NSsEH5c74LzVAAkbQ9RYuUH4R27mVfI3uQvDYWh62sHtj1rxsStdsDseJTqW6unGv+EXS6V2LkhDfz91m7ehZQog8EmKn9bnSW/7/JmE7IeTdrwAP0dKaCZ0O3Fo2K+/xJ0Z36oIjxhCZe5hrQVXBsaE+TEL9RISF7cscYHw4cFveuZZ24BHKtbjrhOqUPTH7oImVcxCDsaAK931yzTMOpFNhZ1zsgbMV54hLmSlyEvCzruQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Efhanhoc; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=sj@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Efhanhoc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=sj@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKrJz6Kvpz2ytv
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 00:21:39 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F242D60AA9;
	Wed, 12 Aug 2026 14:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F991F000E9;
	Wed, 12 Aug 2026 14:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786544497;
	bh=a7uHO+cls4zicW3uCaFv9/XNqct5VHTMhLbXkR3nur0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Efhanhocax+0BjDxsAvm5/zpWalMWJn9FmC/Vd1Q2qp3EztLaT+JXFwig25RvLV27
	 YlaM8vxIlV407KATsZg7kEq4pW6E5uLGh8z9M1TMOo6g9WmP4mSJ/kioxxvB+3nuOi
	 YIUunDYhs1LU+V7sLJ7JMRUtyJMN5zwjpQ+sRrzdzYAoh2OHmto1WdMzN06nd+Yv0g
	 DHgStv0atUzA3Eu9vQzHM2B1WWFyVRtMCxhmhhlO55ZC7/4QA06dV+k729Ro6g+HdM
	 zxdf4MDkusWMZJFGGpTPrIglqqIYK+dP1sk9ceDBIuNGOu4XMDl/6rpreuc5PPPnvH
	 IeEMSGcRDQ08A==
From: SJ Park <sj@kernel.org>
To: Gao Xiang <xiang@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>,
	Guenter Roeck <groeck7@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms
Date: Wed, 12 Aug 2026 07:21:29 -0700
Message-ID: <20260812142130.124832-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812131144.30802-1-xiang@kernel.org>
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

On Wed, 12 Aug 2026 21:11:43 +0800 Gao Xiang <xiang@kernel.org> wrote:

> CONFIG_NR_CPUS doesn't define on some UP platforms (e.g. arm), so this
> can cause make oldconfig to loop indefinitely when CONFIG_SMP=n:
> 
>  $ make ARCH=arm allmodconfig
>  $ sed -i "/CONFIG_SMP=y/d" .config
>  $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config
> 
> EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
> EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
> ...
> 
> Let's guard NR_CPUS with SMP instead of using a hardcoded arbitrary CPU
> uplimit here, similar to commit a3344078101c ("mm: make SPLIT_PTE_PTLOCKS
> depend on SMP").
> 
> The initial report from SJ Park was for m68k [1] (m68k is the only arch
> without NR_CPUS in Kconfig), and it will be changed in another patch [2].

Thank you for this patch.  I confirmed this fixes the issue on my setup.

> 
> [1] https://lore.kernel.org/all/anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local/T/#u
> [2] https://lore.kernel.org/r/20260731094950.1988084-2-ukleinek@kernel.org
> 
> Reported-by: SJ Park <sj@kernel.org>
> Closes: https://lore.kernel.org/r/20260728065447.91511-1-sj@kernel.org
> Reported-by: Guenter Roeck <groeck7@gmail.com>
> Closes: https://lore.kernel.org/r/87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net
> Fixes: c9b47e6b2311 ("erofs: cap LZMA stream pool size")
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Gao Xiang <xiang@kernel.org>

Tested-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

