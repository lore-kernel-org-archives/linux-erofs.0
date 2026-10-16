Return-Path: <linux-erofs+bounces-4741-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B81CC6B38
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Oct 2026 07:09:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j5bfD21V1z2yTH;
	Fri, 16 Oct 2026 18:09:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792134564;
	cv=none; b=db5I26+ZBUNQN+tgjXlz/ncAt9ZG6jzRO2MYDztNS7vWkwdGmDOPcR2T2Th4OO8RB/GpJiFUcwV8Y5NVB8VugPzBeGYOq/UwklsJp3SmiziQeqSxVBLWAVgVMaibUb3sqRY3wPR/1raGkLp6OpxGEmYJ3AyV6d1Cy/zEh/XNEGhFYqLhzZuMZmezLljS3VISv8LSGJGckduidhU//hj6bVcgF5rm4vDmfa9goKDsNrn9imDSVb4nZuxkKFPja67HjNUUov6IXFJ4S7yYgV9QWZ15A2OaGTndfaGRb/GcPSdNh/ETG2ZtXg+sCS//qaLoP4fNzQkKsCgteFVZUIsEuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792134564; c=relaxed/relaxed;
	bh=e1AqkV8YwWc9VSlf9Xpn+R39QPSGxhBbbDZwM6dVNZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCnc8EIAeuawS1VwUl+y7BE4VEN2QENeVTbpihhetYFgmYP/LeGAVB56s8zt80l4pn+ymRRX/tZSnKEpZSWsBWHGiNkge72a9zggyAbfJGeQ7LMjl2nuYoZTnmGNZrx50SUWNZnSdlU8k/zaGNE0nCOJA6lpB9seiX0x3VYKjG6Vok029xkxTELrFAs2JYC1Fz9T3ar4aMIyic+12aEZZw14I6PkAJkBtiYOYvY/Kqsw/zyGRF3awSVpq9pHRmUMT01ZGCgv1nsLF/eJH0mZLo7WCTuSyxKrIb6WocNsWWZjI4p/tNCLfvEWJvZZQv2SK4DTkjpvwgGOxR0D1LXWJg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+GL2vJp; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+GL2vJp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j5bfC0wdBz2ySc
	for <linux-erofs@lists.ozlabs.org>; Fri, 16 Oct 2026 18:09:22 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B522743DE7;
	Fri, 16 Oct 2026 07:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AD21F000C4;
	Fri, 16 Oct 2026 07:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792134559;
	bh=e1AqkV8YwWc9VSlf9Xpn+R39QPSGxhBbbDZwM6dVNZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i+GL2vJpDOhdsnwP6Sg12Tcwxe5flkkHR+oQC4ah61eOp1XjpcmsIQxpxNChzuDVh
	 g6jELw18psnkiCU5K5Zohg0j+PJHORQmuFq4A5u3dWp7+MHPHAaphks7xlE6O6yyIT
	 842ObtM0ZYV+LtCoWbBr0w2F9I1WjwvSbMirb6jb0IHo4IDrvUiP3XeU42dpAWKtqL
	 9cSvANMVrHXyGWKkJr/K0fiNGJJB2rNy0sj3bjanhT5r/de47t7y9tFwwtucadJNDt
	 trIA9zjhimBxEqZJrqEkW7amizyEebBwM78s73yleLtXvbh8MHce2mY20rCqVsaPCQ
	 PKsHUptJKmB7Q==
Date: Fri, 16 Oct 2026 09:09:14 +0200
From: Gao Xiang <xiang@kernel.org>
To: Liu Chao <liuc63@xiaopeng.com>
Cc: Chao Yu <chao@kernel.org>, Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <xiang@kernel.org>, Hongbo Li <lihongbo22@huawei.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>, Yue Hu <zbestahu@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: fix unsigned underflow in LZ4 in-place
 decompression
Message-ID: <atHNmmoGa3d3iAea@MacBookPro>
Mail-Followup-To: Liu Chao <liuc63@xiaopeng.com>, Chao Yu <chao@kernel.org>,
	Chunhai Guo <guochunhai@vivo.com>, Gao Xiang <xiang@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>, Yue Hu <zbestahu@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20261016041143.2293155-1-liuc63@xiaopeng.com>
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
In-Reply-To: <20261016041143.2293155-1-liuc63@xiaopeng.com>


Hi,

On Fri, Oct 16, 2026 at 12:11:43PM +0800, Liu Chao wrote:
> z_erofs_lz4_handle_overlap() computes the overlap offset between the
> input and output page arrays as rq->outpages - rq->inpages.  Both
> values are derived from on-disk pcluster metadata (pcl->length and
> pcl->pclustersize) which an attacker can set independently, so
> outpages may legitimately be smaller than inpages.  The unsigned
> subtraction then underflows, causing rq->out[] to be indexed far out
> of bounds and the returned LZ4 source pointer to point past the
> output buffer, resulting in out-of-bounds reads and writes.
> 
> The in-place path is only valid when the output buffer is at least as
> large as the input buffer, so guard the branch with
> rq->outpages >= rq->inpages.  When the condition does not hold, fall
> through to docopy, which copies the compressed data to the per-CPU
> buffer and decompresses safely.
> 
> Reviewed-by: Fang Xieyan <fangxy@xiaopeng.com>
> Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
> ---
>  fs/erofs/decompressor.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
> index 354762c97..50a5f9ddf 100644
> --- a/fs/erofs/decompressor.c
> +++ b/fs/erofs/decompressor.c
> @@ -117,6 +117,7 @@ static void *z_erofs_lz4_handle_overlap(struct z_erofs_decompress_req *rq,
>  		oend = rq->pageofs_out + rq->outputsize;
>  		omargin = PAGE_ALIGN(oend) - oend;
>  		if (rq->partial_decoding || !may_inplace ||
> +		    rq->outpages < rq->inpages ||

This is not against to the latest upstream, and
do you notice the following commits?

 commit 21e161de2dc660b1bb70ef5b156ab8e6e1cca3ab

 commit a5242d37c83abe86df95c6941e2ace9f9055ffcb

also do you have a reproducer?

Thanks,
Gao Xiang

