Return-Path: <linux-erofs+bounces-4023-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97E2C53219
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 06:40:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8Qny72Bgz2yRl;
	Tue, 28 Jul 2026 16:40:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785220838;
	cv=none; b=IOgM+x72q6i1HKcPlOTR7CaE3B/sneqc3bql0emKYHoPLWi8Q6ULZxVL+1hPya3bAi7K8iO2tohJKtjAkTbCPv5HJ4IpdZ5UUKAAN/9tnKjP2nPLw9/x1AK+FYZW/rSD9nH4gUHLkuuEq+Ved/I0iHzqlL6AZ3h4tWWJIGfTmc2z4/vfEuKheN5hXgRpFGdcz0b/8/Ag4jisB7/v5etqD5Gq9TAzQ8ldfOP661/fzxaiYJtzBtd/bpVi7c9M4d2djDj5gwKNR03N5b0kdQlecX2IR9dRvfKeil7rdNJNk5k3nWRhx2sKRdcSwC4C66JXSZLttna/QtRqGwnImHgg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785220838; c=relaxed/relaxed;
	bh=ACxJe4D3rHkXg7y6V5XBMY94uTUMOyCLNCijYgiSQv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mSR6Mz0lccqQse1KN4ezqsqIMbwaZi4Ts87rCzZipcRrpNJmp3/gB7vzAFDe7CXOZ9HmrM4gFKRXkqCmDaB6WFKU2GwFWeFDdE98t3MguS5spP6EOFspy3MZBbSX1B1cdFGxGDW0PAk89+0kwUTe2v70v1OSe1c/QJHDxlYU+1YrU05ERD0YF0A6KNNvyQg6szhQvyYaYGJB4IktxQnSRpFHQgR4SNGzxAMF3PtjurQlQxLJufnBs08kDcV/+Je2FJcxp6F5f6JRrfpDdo4euxlAqBZ2zY8zfGBVft25WMfGHs7OepSLl/cuK9wgIAZtn+vJEk1oock3OwhFN2falA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jtAo+eAQ; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jtAo+eAQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8Qny0MFZz2xLq
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 16:40:37 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 731E7600FC;
	Tue, 28 Jul 2026 06:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0F61F000E9;
	Tue, 28 Jul 2026 06:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785220834;
	bh=ACxJe4D3rHkXg7y6V5XBMY94uTUMOyCLNCijYgiSQv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jtAo+eAQkSMkmijUYpDMRcJ6cCKJfby3aNMi0KRQ8RjVVcA/QkLw7chMpKoDxC0AX
	 4Z1+9lz8EuhlPN4zQR1bbKYjcUP5fUF02DEXSeqBEfqjOjVjInQp2jfYkhstSj5oFI
	 0q30FbUjtJi2YPWjnRnUGg3JjpfnANcjlylBKm7Ue6m7ycLFV9fz2Dj0eTZtMK4+Kr
	 Usl5Ziaax4NbglTNiE9JSXdo9L8O0m3hsf1Gy1kue1WXUZQhvBicqn5yX0yog4c2bo
	 Zf2BV5I5tLgA1++9KRzE73dQDi+BiwCRr4ONGYerSK7cGU9Wr0pLW/tq+tcdLBO6Hn
	 b6/oxICrsBp+g==
Date: Tue, 28 Jul 2026 14:40:26 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: Re: [PATCH] erofs: cap Zstandard stream pool size
Message-ID: <amhO2uzAdAZYb0VW@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>
References: <20260728021831.1532541-1-zhanxusheng1024@gmail.com>
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
In-Reply-To: <20260728021831.1532541-1-zhanxusheng1024@gmail.com>

Hi Xusheng,

On Tue, Jul 28, 2026 at 10:18:31AM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> fs/erofs/decompressor_zstd.c sizes the module-global Zstandard stream
> pool from num_possible_cpus() when the zstd_streams module parameter is
> unset, and z_erofs_load_zstd_config() then preallocates one workspace per
> stream, grown to the largest dictionary of any mounted image (up to
> Z_EROFS_ZSTD_MAX_DICT_SIZE, i.e. Z_EROFS_PCLUSTER_MAX_SIZE).  On high-CPU
> systems this can pin a large amount of vmalloc-backed decoder state until
> the erofs module is unloaded, mirroring the LZMA case fixed in commit
> c9b47e6b2311 ("erofs: cap LZMA stream pool size").
> 
> Bound the default stream count by a new
> CONFIG_EROFS_FS_ZIP_ZSTD_DEFAULT_MAX_STREAMS option, default 16, while
> preserving the per-image workspace sizing.  An explicit zstd_streams
> module parameter is still honoured as-is.
> 
> Fixes: 7c35de4df105 ("erofs: Zstandard compression support")
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Thanks for the patch.

Unlike LZMA, each Zstandard only takes 1MiB at most (although erofs-utils
only generates 4MiB LZ77 dictionary at most for LZMA, but on-disk format
allows 8MiB so just in case.)

So I think for Zstandard, 1MiB each stream should fulfill to most
platforms (and for embedded systems for example, the vendors should
control the dictionary size when generating the image; but for servers,
I think 1MiB at most for each server CPU is OK).

Unless there is a particular need, I don't expect every decompressor need
a strict customized Kconfig for this (of course, DEFLATE and LZ4 takes
32k/64k so it doesn't matter.)

Thanks,
Gao Xiang


