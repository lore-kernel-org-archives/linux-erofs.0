Return-Path: <linux-erofs+bounces-2555-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763E6EB1043
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 10:24:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVVNs6fYbz3bjb;
	Tue, 10 Mar 2026 21:24:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773138269;
	cv=none; b=gijWa/d7pt1hQSfe96HHw546SteLYjkC9HKgIBktaFnDBudEHuI3RDozrhI2UGef+9yEwuUHIX7NGMteDNzKt7qOTesxEEbnggkbPgHdFMuLpMaQ1nJ2LAuFYn72i0hBgHr/o4ywRKeDhHyD6NlgqbfiPv7p2TyXyc66pxGQyprH8HzcfWNIJDoSo5aWbATQfeUbm8oB/a5xRln6akMla1VoPXoFwZhbtJ8yAtATJpkGhfBaxs5jNuOYBPkC7jDMTLiPEWvZq6CzztKwvhhc/tsUF2XKv+hemKkF2bZPYmBcLkRctJ4qcO6fH355Z0fU2K58hMFdzVHy7+wEHWKttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773138269; c=relaxed/relaxed;
	bh=oNyg5rr0iDtSfw+Y/ml7isN2LbI/fcU2bAhuGvK67ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQjblogpnse52AQRIBVtdxdRxioE0x4ApPaJr3FUtDF4HNBEvwKBS3JO5R6veBWW/yYTL0jkAha7UfyetYgDWFlDyHqn2JqylhfLx15BLtL67HncJAAPvA36N32T54yASc7dY057AwIy8CxKah/VdrOIgc1pCWj8K+nAzi4a89rvVGCeuPnFV7RZ5agHY+q+tWtwaedh2RUdghkxbsSd7qyrKPSMPu7lR08XKCHzGlfWou5Oh+ka3N1dXsUAaELbDkIFvCDPaKsus05fsCgc9jaVJeBqCtM8MvRiwtW2dnh1HBaKsXbDlo9y4LzqQmnax3X21ykrFfnMMIDHOUtu9w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=OFRvIdC6; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=OFRvIdC6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVVNs2Fgnz2yFY
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 21:24:29 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E733360097;
	Tue, 10 Mar 2026 10:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A870C2BC87;
	Tue, 10 Mar 2026 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773138265;
	bh=nxZ9lJKi7W+un67iR2+nCzWIZ7sjXd9DTdiqKGp20R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OFRvIdC6Aw+pes4prsTnisaAeP8tbDy5j+jWqO3MELwmzw3FLFifp09vM5pycTP5s
	 aDZfD11hgk+o9+wQ1k4fV90J45gTQDvEr2g/8EdoFwrn39XcUqjmcZsOG7h2d23NH8
	 wXOk+UeUdh3tepvYPsVMC315WqYsZ4hg+/Rdc1paIKMjoXO9ecBP1quu0XXGYstEWc
	 0ibMnncS4pj0QnRuacDPgUEzDOK6OwSZs241A8Up0I7pGw4sAtbyuv5Qv2VbqXoWPv
	 jIYcSsbAnKconGDsNjvGMiSYLY5CsFdXxcfVjIuQhsbPBwHaZ+gdWd/cokLJZ0HRqE
	 e3RKN7KPxVZVA==
Date: Tue, 10 Mar 2026 18:24:16 +0800
From: Gao Xiang <xiang@kernel.org>
To: Lucas Karpinski <lkarpinski@nvidia.com>
Cc: linux-erofs@lists.ozlabs.org, jcalmels@nvidia.com
Subject: Re: [PATCH v2 4/5] erofs-utils: mfks: add rebuild FULLDATA for
 combined EROFS images
Message-ID: <aa_xUG1Z60A10AMY@debian>
Mail-Followup-To: Lucas Karpinski <lkarpinski@nvidia.com>,
	linux-erofs@lists.ozlabs.org, jcalmels@nvidia.com
References: <20260309-merge-fs-v2-0-2dd0ef53db4d@nvidia.com>
 <20260309-merge-fs-v2-4-2dd0ef53db4d@nvidia.com>
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
In-Reply-To: <20260309-merge-fs-v2-4-2dd0ef53db4d@nvidia.com>

Hi Lucas,

On Mon, Mar 09, 2026 at 12:38:20PM -0400, Lucas Karpinski wrote:
> This patch introduces experimental support for merging multiple source
> images in mkfs. Each source image becomes a directory directly under root
> and keeps its UUID stored as a device table tag. The raw block data from
> each source is copied using erofs_copy_file_range. We preserve the file
> metadata and layout (FLAT_PLAIN and FLAT_INLINE). Symlink paths are handled
> by reading and copy link targets.
> 
> This does not yet support chunk-based files at this time or compressed
> images.
> 
> Signed-off-by: Lucas Karpinski <lkarpinski@nvidia.com>

Thanks for your effort, I finally get the time to look into this
new feature.

So you'd like to cleanly rebuild a new filesystem with given sub
filesystems?

I think first, yes, that is what `--clean=data` is used instead.

But I think uniaddr shouldn't be used like this (uniaddr is used to
give a flat mapping for multiple blobs, in addition to the device id +
offset ones, which is mainly used for compressed data multi blob
support), instead, I think we need to find a way to wrap up the data
source into a valid vfile (so that erofs_pread can be called to get the
source data) , and make erofs_mkfs_job_write_file() to write
(un)compressed data from its source instead.

Thanks,
Gao Xiang

