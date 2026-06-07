Return-Path: <linux-erofs+bounces-3520-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D27CD8C85
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Jun 2026 01:53:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gXyqj47p3z2ySl;
	Sun, 07 Jun 2026 11:53:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780797185;
	cv=none; b=R+rFgdnsi5IR2nWpVdXn43g3epCS8rqZpRUTXLGo0mIpdifSp4sp8ns6Kthk3vLoizTpwNyupZJ6hjGmpaEzQ1pBYvSWwAxa+FkFCkrwQW4XC26nPHGgkbRASZ/99/AEEKlAH515RMMDsBx9Gy/CTr9DzhFC1dAe4lYRwyy+dF1XonqbYvaYuxolFVTxENfXfMSdw9dFKXx/83rJqy/4rWbMLyq5uwV3c9YiEWprSB5aQcSOWwb6GfQKICRT5cgqf/TDHYGNINLZqwXu1zy7+OeVGZNWluxfSoewJfDB70OS+z7sBxDns63WA33pdlQKtAJ6OU8POOmHi3x6NKY5Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780797185; c=relaxed/relaxed;
	bh=vGGp3+pXhDxRoGqqwftx5RkugYriz+0LtX7KTV/7bSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUZ93G2eult8aGVv+THCRKAI9eCcHdUxhbQgtP0N4hZseEOTlgR0Fhh7okYd8alvMrL6MjNdGTYGKtoQYG4gQdiTDHZGKIEsyHzNGzR6phM5de+tzqJNu257FWvmCT/+POhzmlntVoS0i52sZBdTMNQ3NZamHuhUwszpLHAetcWamZBuaapaU/5uTebJRZxy+i8CSD88Hkmm/60XAgMYzsl2WFM8Fuu5DEmgXJkAy0CLS56N3U2FEvAVVKeeFyKWFYdTIsccJJBZnkBEuan9Dm7mxqgtVeDWxL1EGBuH2tJV/6AagYk/pPPYrNSV1jLC987CNfpH6KjS4g1EH4xVCQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HcRCasVd; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HcRCasVd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gXyqh4hFKz2xLk
	for <linux-erofs@lists.ozlabs.org>; Sun, 07 Jun 2026 11:53:04 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1632360008;
	Sun,  7 Jun 2026 01:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BBE1F00893;
	Sun,  7 Jun 2026 01:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780797181;
	bh=vGGp3+pXhDxRoGqqwftx5RkugYriz+0LtX7KTV/7bSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HcRCasVdsojCnjfO0eCFRwdyCHyQHQkMU4nSxUnn/i0dd/EAwXzrjCSCaV9MlD4F8
	 6Sagy537ttZgMlVdX7rMkMjXf9wAOtuek2Kd2s8tCJ/NyZiGFCCp08FQE46I5CmGtU
	 7xuCLg+vQXiTAKdoDVgnNr4/bz7NwTs2+ysQ+7jf88eUs/YZ8IDfXPDsKSFCsATcog
	 Pr/W3yAo+Bygp+guJlLQzweF7tb3qfLTs5VUZ2lnV9HE6Emn8op/ePXRiHW6xmgHKk
	 RKSvj2e3JXmZgogV3HtESsUWDt5uJ3Y+ZZUkll+39a2TsDmo+NrY03abM52akgLd6y
	 TWSKT8GFtsxxw==
Date: Sun, 7 Jun 2026 09:52:30 +0800
From: Gao Xiang <xiang@kernel.org>
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	xiang@kernel.org
Subject: Re: [PATCH 2/2] fsck.erofs: implement dynamic pcluster batching
 based on algorithm complexity
Message-ID: <aiTO3rkYVC8j65NQ@debian>
Mail-Followup-To: Nithurshen <nithurshen.dev@gmail.com>,
	linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	xiang@kernel.org
References: <20260523003757.13078-1-nithurshen.dev@gmail.com>
 <20260523003757.13078-3-nithurshen.dev@gmail.com>
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
In-Reply-To: <20260523003757.13078-3-nithurshen.dev@gmail.com>

On Sat, May 23, 2026 at 06:07:57AM +0530, Nithurshen wrote:
> While static batching successfully overlaps I/O and compute, different
> compression algorithms exhibit vastly different scheduling thresholds.
> Extremely fast algorithms like LZ4 require large batches (e.g., 32
> pclusters) to effectively hide the synchronization overhead of the
> thread pool.
> 
> Conversely, applying this large batch size to compute-heavy algorithms
> like LZMA or ZSTD causes memory bloat and thread starvation, as the
> main thread spends too much time reading and accumulating memory before
> waking up the background workers.
> 
> This patch modifies the workqueue submission logic in z_erofs_read_one_data
> to dynamically scale the batch size based on the algorithm format. LZ4
> is permitted to utilize the Z_EROFS_PCLUSTER_MAX_BATCH_SIZE, while
> other heavier algorithms trigger workqueue submission at a much lower
> threshold (8 pclusters) to ensure a steady pipeline of work and a
> bounded memory footprint.
> 
> Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
> ---
>  include/erofs/internal.h |  2 +-
>  lib/data.c               | 15 +++++++++------
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/include/erofs/internal.h b/include/erofs/internal.h
> index 38020ee..c8f056f 100644
> --- a/include/erofs/internal.h
> +++ b/include/erofs/internal.h
> @@ -62,7 +62,7 @@ struct erofs_buf {
>  #define erofs_pos(sbi, nr)      ((erofs_off_t)(nr) << (sbi)->blkszbits)
>  #define BLK_ROUND_UP(sbi, addr)	\
>  	(roundup(addr, erofs_blksiz(sbi)) >> (sbi)->blkszbits)
> -#define Z_EROFS_PCLUSTER_BATCH_SIZE 32
> +#define Z_EROFS_PCLUSTER_MAX_BATCH_SIZE 32
>  
>  struct erofs_buffer_head;
>  struct erofs_bufmgr;
> diff --git a/lib/data.c b/lib/data.c
> index fa36899..a06f4c2 100644
> --- a/lib/data.c
> +++ b/lib/data.c
> @@ -17,11 +17,11 @@ struct erofs_workqueue erofs_wq;
>  struct z_erofs_decompress_task {
>  	struct erofs_work work;
>  	struct z_erofs_read_ctx *ctx;
> -	struct z_erofs_decompress_req reqs[Z_EROFS_PCLUSTER_BATCH_SIZE];
> -	char *raw_bufs[Z_EROFS_PCLUSTER_BATCH_SIZE];
> -	char *out_bufs[Z_EROFS_PCLUSTER_BATCH_SIZE];
> -	erofs_off_t out_offsets[Z_EROFS_PCLUSTER_BATCH_SIZE];
> -	unsigned int out_lengths[Z_EROFS_PCLUSTER_BATCH_SIZE];
> +	struct z_erofs_decompress_req reqs[Z_EROFS_PCLUSTER_MAX_BATCH_SIZE];
> +	char *raw_bufs[Z_EROFS_PCLUSTER_MAX_BATCH_SIZE];
> +	char *out_bufs[Z_EROFS_PCLUSTER_MAX_BATCH_SIZE];
> +	erofs_off_t out_offsets[Z_EROFS_PCLUSTER_MAX_BATCH_SIZE];
> +	unsigned int out_lengths[Z_EROFS_PCLUSTER_MAX_BATCH_SIZE];
>  	unsigned int nr_reqs;
>  };
>  
> @@ -397,7 +397,10 @@ int z_erofs_read_one_data(struct erofs_inode *inode,
>  	task->out_offsets[idx] = out_offset;
>  	task->out_lengths[idx] = length;
>  
> -	if (task->nr_reqs == Z_EROFS_PCLUSTER_BATCH_SIZE) {
> +	int batch_limit = (map->m_algorithmformat == Z_EROFS_COMPRESSION_LZ4) ? 
> +						Z_EROFS_PCLUSTER_MAX_BATCH_SIZE : 8;

Why it's called dynamic decompression batching?

> +
> +	if (task->nr_reqs >= batch_limit) {
>  		z_erofs_read_ctx_enqueue(ctx);
>  	}
>  	return 0;
> -- 
> 2.52.0
> 

