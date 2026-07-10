Return-Path: <linux-erofs+bounces-3872-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6DCC44506
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Jul 2026 02:42:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gxGMb4ZLBz2xSb;
	Fri, 10 Jul 2026 12:42:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783651355;
	cv=none; b=jTjX0A9JExyW1PNhe50dDi1320PmgOhMryTQ367odNZtRQhb9I1QzEIXJ4Kfyk12yPuaEop5+xCDuWlWAb/rxNKwnth6oMM7XXvlAc46ipWqnAdJR69n7PFrNFq34vZuYfFFruLnroofVkEt8jvgCztfMpQt3okkBeyxSBrVxac2XLNKh6ASFIAoGOYONxcib/b1V6i8EEL2CY5LpbVRqUVKBRW+8XjeBowsutQFQI/HY5tA+KRyGRrHUypf8+v+1PXCFnPAgbr683m9hsACoseBVQz2EmsH58gzUj7238U9fSBHlww/a2bo/9lTCpe65JewCrI4g+TqEEgVYzMRmw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783651355; c=relaxed/relaxed;
	bh=0CkT2pbPlw2rWsywXX0DcvXBZbc7R7CKMiUZ7rlutY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhmGk7rCVE03j4NCDZm6GJo5f+aM46N3IUOG++BwzzJ5CUglNVaFllcVyHl4m7IbR4o++PcVqVlOqsNDwfZVMyJeQEfKuPKi2AnzFz+Xp/VaArTa16px5KHJciF7TU4ulQioWAKKNVEcv7vTsMy7YBxFZPwHWYR1GgvY2bojQ0Emm5z7L7No87eAKsddzJPLivpR+7L4HoV0o7xA6D8twvWRBlAtkzW5P+KU2HHbaFiZsc7I22/HQ1jdJB4yOqrOfJ/PvVh55uGeH8xqBSmjk/TQw/LzvinIkA2DNXHDXnctmxbFccVVADcwvHMrQIOPuU9AZ6e6vfz8l0pcnWiynA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RKxCABF+; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RKxCABF+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gxGMZ6064z2xJT
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Jul 2026 12:42:34 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F25243791;
	Fri, 10 Jul 2026 02:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA71B1F00A3D;
	Fri, 10 Jul 2026 02:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783651351;
	bh=0CkT2pbPlw2rWsywXX0DcvXBZbc7R7CKMiUZ7rlutY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RKxCABF+rjTzG3Y3507xPZgMXL614Re7iPyRGeBmo3r6m9CM1WqzXIhj925XeOf+v
	 ONT1ce6IAXM72kaPqAn7nsBPDVvNaOOL4mYnUb9ZJbQKbQa6HDa2s+qGqEfswXFY+C
	 SkI40Iw1i+H9kQAXgPGqI7Jnenf34Fq//XjNKsOKmzI2bBTDpa6GN2TGlmLR6Zd6oo
	 BJs4xsG1TI8SlmQR8aqEjDm4pJtuqCLWSRGKg0Rn3tbTrL2e5uhcG7ZMj54TE6P4MH
	 cx4lIFDIisg23PzzYwLchGKUGG+ctS2We74YF7MxkrvYfFeAC8BfIYwDVIv3UZefa0
	 71Mdx4L+wyB3A==
Date: Fri, 10 Jul 2026 10:42:22 +0800
From: Gao Xiang <xiang@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] erofs: cap LZMA stream pool size
Message-ID: <alBcDlPeV8IPEngL@debian>
Mail-Followup-To: Michael Bommarito <michael.bommarito@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260710023036.3745254-1-michael.bommarito@gmail.com>
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
In-Reply-To: <20260710023036.3745254-1-michael.bommarito@gmail.com>

On Thu, Jul 09, 2026 at 10:30:36PM -0400, Michael Bommarito wrote:
> fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
> pool from num_possible_cpus() or lzma_streams, then
> z_erofs_load_lzma_config() preallocates one image-supplied dictionary per
> stream, accepting dictionaries up to 8 MiB.  On high-CPU systems, a small
> EROFS image can pin hundreds of MiB of vmalloc-backed decoder state until
> the erofs module is unloaded.
> 
> Impact: an attacker-supplied EROFS image mounted by the system can pin up
> to 8 MiB times the LZMA stream count of kernel vmalloc memory.
> 
> Cap the LZMA stream pool at 16 streams.  That keeps the worst-case
> preallocated dictionary pool at 128 MiB while preserving the existing
> per-image dictionary limit.
> 
> Fixes: 622ceaddb764 ("erofs: lzma compression support")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5-5-xhigh
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>

I guess we can make the maximum LZMA configurable
instead by using a Kconfig?

like CONFIG_EROFS_FS_LZMA_MAX_STREAMS, since I assume there is 
the different setting between the embedded systems and servers.

Thanks,
Gao Xiang

