Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CE5606A321
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 23:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATehF30l
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQbwq5dc3z2xnv;
	Fri, 13 Nov 2026 10:20:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794525659;
	cv=none; b=MP/BXJ3Cw2B0J8TTbYgTrCNE6v07hYALYFMr8KgO97skUyrQhYftS2dSFwj/PGy37RCTq78OMnGFTeze23iNC2tzHZfdzKx0LxNAPiWEhuLcyzGh9RBxbyagsAGtkYEixB+hoo0fPKVin88bOEnBgR2IZtH63FJi3Y2XmwkafP6QiUi5u0YNlQ5VqTwLG7l6kw6+zm77xlzsLwU1r+8tGtxu4zY+9i6zjNblqE8Enjljgw/RrCUdnPuum6iHq2QPuvoC8/1fxUWRHkf8pWSdRPRwS/fBAoNIRTqYHRkGnAYBFF0Owmtk1DHiBZBv/MMqfHjpjEmQT2y1ZpikD50/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794525659; c=relaxed/relaxed;
	bh=a/3mvFXM/PFJUPTQ5V4YaL3jd5pr71ShEwl5nxgYvlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y22hAaePDdPnq3cOMCTCmRnbeodnB17LYEiOhXZA7QDGGwS5Go/2H/kpmXlayO3Of0T6gfZBssdUq/h6olmevUMi9Tk1grgStEWfu82Tn3CAy1O88iX6UVq+pQueddAkhuQmn5cTV/wwoY7vTyRgaG7kPp9gxSIT+h1E0gPKV+Aw01EbhJEoq8c8Rp+sxVEna68G5WWA+yKzFcfKyavFdbeCEFBDXvDX0oV/h1ThM6wAbrw+X04tPkNsEL1xleTDHZNIKvqaQnQ0IvhKYGJfRu4v/bhpzEKZ8Q5JVdQvKmr6kFgRgM4byIQv1inRxJ+SM1PLzwtf6t7coFFuZHXvzQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATehF30l; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATehF30l;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQbwp6N00z2xnn
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 10:20:58 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FCC941A82;
	Thu, 12 Nov 2026 23:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A791D1F000C4;
	Thu, 12 Nov 2026 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794525656;
	bh=a/3mvFXM/PFJUPTQ5V4YaL3jd5pr71ShEwl5nxgYvlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ATehF30lmfgEvhEiAtaolI6kG4N+wcpSdqzgFWwLQSdaLh61acxgUr02CuPtg05f+
	 bhxecpQsdiYUoznuk3c4MHAiZTv3irdoa2aK+tdz/jZDEo9ahvwT+Nq3nNVJ5wK0FZ
	 q9wykaGEFZIEvizD4XaRNq3yeMZ8GHjXVFYthDCYCI+I8C2DBfK0FYpZ68YOxS7O3a
	 NHpZ2bmJCWZq0iakoY3CTOlyo7HcJgIX2Sp8fIXC45ba7OJDquJRulHYaHFyiO4iT9
	 oJTITxZpTR23thi+p7Xd4S0SbwYWxlQb8JUNWkRXDox81cR1gY0+aoMIiZ/3Mp+dzm
	 tN423HzJAP5mw==
Date: Fri, 13 Nov 2026 00:20:51 +0100
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <stopire@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH 4/8] erofs-utils: lib: fix buffer leaks in error paths
Message-ID: <avZJ00X9YuOPSkHw@MacBookPro.fritz.box>
Mail-Followup-To: Yifan Zhao <stopire@gmail.com>,
	linux-erofs@lists.ozlabs.org
References: <20261112124725.2774244-1-stopire@gmail.com>
 <20261112124725.2774244-5-stopire@gmail.com>
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
In-Reply-To: <20261112124725.2774244-5-stopire@gmail.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Yifan,

On Thu, Nov 12, 2026 at 08:47:21PM +0800, Yifan Zhao wrote:
> Fragment data is already written before its buffer is shrunk.
> A failed realloc() should leave the original buffer valid, so the
> fragment commit can continue without shrinking it.
> 
> Also fix an inline data buffer leak when loading compressed metadata
> fails during rebuild.
> 
> Fixes: 84bae6acdbee ("erofs-utils: lib: keep full data until the fragment is committed")
> Fixes: 1c230a485f25 ("erofs-utils: mkfs: support rebuild mode for compressed inodes")
> Assisted-by: Codex:gpt-6-astra
> Assisted-by: Claude Code:deepseek-v4.1-flash-1017
> Signed-off-by: Yifan Zhao <stopire@gmail.com>
> ---
>  lib/compress.c  | 2 ++
>  lib/fragments.c | 8 ++------
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/compress.c b/lib/compress.c
> index e1cfc05..b5f75ca 100644
> --- a/lib/compress.c
> +++ b/lib/compress.c
> @@ -2607,6 +2607,8 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
>  err_free_ei:
>  	free(ei);
>  err_out:
> +	free(inode->idata);
> +	inode->idata = NULL;
>  	list_for_each_entry_safe(ei, n, &extents, list) {
>  		list_del(&ei->list);
>  		free(ei);

Can we use a separate patch to fix that?

> diff --git a/lib/fragments.c b/lib/fragments.c
> index d4e79b2..3398888 100644
> --- a/lib/fragments.c
> +++ b/lib/fragments.c
> @@ -366,12 +366,8 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
>  		memmove(fi->data, fi->data + fi->length - sz, sz);
>  
>  		nb = realloc(fi->data, sz);
> -		if (!nb) {
> -			erofs_up_write(&bk->lock);
> -			fi->data = NULL;
> -			return -ENOMEM;
> -		}
> -		fi->data = nb;
> +		if (nb)
> +			fi->data = nb;

Does this one impact the reproducibility?

I mean that if realloc fails, we should just error out instead of
falling back, otherwise the generated image can be different.


Thanks,
Gao Xiang
>  		fi->pos = (erofs_off_t)offset;
>  		erofs_up_write(&bk->lock);
>  		inode->fragmentoff = fi->pos - len;
> -- 
> 2.56.0
> 
> 

