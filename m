Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E52606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 23:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Svkt/RJA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQcNg5Hc1z2xm5;
	Fri, 13 Nov 2026 10:41:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794526899;
	cv=none; b=m2JbGql1KxRVFWotAW6Nmf4gFQn2V+EpKHEGBbpPEge76XSLs0cR4ZJ0xaBIM585LGnFz4zva2jcnCF9j1RzoyiYgZQzd+WGIj9EeLjsp++1q1ZJSWL7NFTwaVUYayUTfxPxA5+TqHm2AS4oNfLwwcLfQIXI/k/lKFGhGbFSSH04/0UXNabCCZeCVN8L4RPZiKNg4qDpjX9ByzgyX0V95ujdmeSMIQDA009Kvpka57FOhQlz9roJG9EaxqXkHZ4ojlwwSbiZ/PUYFS6QsnMOM2TKjIMQYl9150cNAEVuO3lu37KPXYLVryfHq/bbc+S52hEm154w1Wm3g8Y8E9SRVA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794526899; c=relaxed/relaxed;
	bh=xMrD9Vu0ZiZMENHqocu9AXQk1RG7+xft/52AnHX5r7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0XOiL0vd0iTPLsg0bN03btQG6UPHiLfSMGdr+xtPIrVl5LuwE5tHEEMxvF/ZUGHa4lKk4eMZ+GpmPEb8aTXLpe+90qEJ4uIACMniTYpp0vORszI+bpwihwuirOXW3HS22AK4/ivs6+ysc0BwF0apS6wY97s80X/0Qx3gwc6ABz+83UZHCu7zITGokLkVpMGtM37IX5gzLgLG1H0LmYpdepyiNRhyDCOV85UydoPtvPjFSAFyVvMBUrCpLKA6FUwrXvqneywkIi8ixb2lK0Ym5OxdqxajF2ghC6he9rqM3nt0YFyqnfrC/XmZleBPyWroUXus8stDQOMmSHy49li1g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Svkt/RJA; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Svkt/RJA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQcNf4xjLz2xlk
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 10:41:38 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C52E14056B;
	Thu, 12 Nov 2026 23:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A0F1F000C4;
	Thu, 12 Nov 2026 23:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794526896;
	bh=xMrD9Vu0ZiZMENHqocu9AXQk1RG7+xft/52AnHX5r7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Svkt/RJAEXUVtMlmlkxk3YEOiEmZkDDcMaUceN9ONGHBWFFGf1RlbivjKQlHbyNkA
	 DNdZeOANIKMtONuXrJUwQkuPnJ5hBEiPEALD9mjfNy/4bhBupptMavS2xJ6Qr4P81S
	 Kmr5qyBy9Bk6fgAb3RQ8wUkFhbtc31QkPvrR9nJN+oyR7B18FhhYJy1XlJd4jtB01R
	 ZrBuV55arLeq1O2JqufzL5JDvzLemZjpvUlC8EgCPVYVyBL0Z2rZkku+cEizggYmS0
	 evxbm1kHabXWWqRUlbvj+pDxvzyXkyIovroOXemhwWhn4VdNL+AVFOFTaSfLZmcuZF
	 hHk4WcTwUWu8A==
Date: Fri, 13 Nov 2026 00:41:31 +0100
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <stopire@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 8/8] erofs-utils: fix read error and short read handling
Message-ID: <avZOq-NOdK64QAYQ@MacBookPro.fritz.box>
Mail-Followup-To: Yifan Zhao <stopire@gmail.com>,
	linux-erofs@lists.ozlabs.org
References: <20261112124725.2774244-1-stopire@gmail.com>
 <20261112124725.2774244-9-stopire@gmail.com>
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
In-Reply-To: <20261112124725.2774244-9-stopire@gmail.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 08:47:25PM +0800, Yifan Zhao wrote:
> Several erofs_io_read() and erofs_io_pread() callers mishandle negative
> errors or unexpected short reads, potentially reporting success or
> looping at EOF.
> 
> Propagate negative errors, reject unexpected short reads and premature
> EOF, and preserve the result reported by the ublk handler.
> 
> Also cap OCI blob copies at the requested length.
> 
> Assisted-by: Codex:gpt-6-astra
> Assisted-by: Claude Code:deepseek-v4.1-flash-1017
> Signed-off-by: Yifan Zhao <stopire@gmail.com>
> ---
>  lib/backends/fanotify.c |  3 ++-
>  lib/backends/nbd.c      |  2 ++
>  lib/backends/ublk.c     |  2 +-
>  lib/compress.c          |  2 +-
>  lib/fragments.c         |  2 +-
>  lib/inode.c             | 11 +++++------
>  lib/remotes/oci.c       |  1 +
>  lib/super.c             |  2 +-
>  mount/main.c            | 10 +++++-----
>  9 files changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/backends/fanotify.c b/lib/backends/fanotify.c
> index cf8b616..898ea84 100644
> --- a/lib/backends/fanotify.c
> +++ b/lib/backends/fanotify.c
> @@ -169,7 +169,8 @@ static int erofs_fanotify_handle_range(struct erofs_fanotify_ctx *ctx,
>  		  (unsigned long long)(offset + length));
>  
>  	read_len = erofs_io_pread(&ctx->vd, ctx->fetch_buf, length, offset);
> -	if (read_len < 0) {
> +	if (read_len != length) {
> +		read_len = read_len < 0 ? read_len : -EIO;
>  		erofs_err("Failed to fetch range [%llu, %llu): %s",
>  			  (unsigned long long)offset,
>  			  (unsigned long long)(offset + length),
> diff --git a/lib/backends/nbd.c b/lib/backends/nbd.c
> index db0df44..81506b1 100644
> --- a/lib/backends/nbd.c
> +++ b/lib/backends/nbd.c
> @@ -600,6 +600,8 @@ int erofs_nbd_get_request(int skfd, struct erofs_nbd_request *rq)
>  	int err;
>  
>  	err = erofs_io_read(&vf, rq, sizeof(*rq));
> +	if (err < 0)
> +		return err;
>  	if (err < sizeof(*rq))
>  		return -EPIPE;
>  
> diff --git a/lib/backends/ublk.c b/lib/backends/ublk.c
> index d2c5e19..7fa88d9 100644
> --- a/lib/backends/ublk.c
> +++ b/lib/backends/ublk.c
> @@ -630,7 +630,7 @@ static int ublk_handle_io(struct erofs_ublk_queue *q, int tag)
>  		if (ret < 0)
>  			io->result = ret;
>  		else
> -			io->result = req.nr_sectors << 9;
> +			io->result = req.result;

I don't apply this one, because I think there are two many changes
related to different interfaces.

especially this one, I don't know what happens just according to
the code here.

Could you just split this into multiple patch, each patch address one
interface, like erofs_io_pread()... etc.

I applied the remaining ones, so next time just resend these two.

Thanks,
Gao Xiang

