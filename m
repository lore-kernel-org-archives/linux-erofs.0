Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA10606A323
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2026 04:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFIOB8St
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbKfW668rz2xqh;
	Fri, 27 Nov 2026 15:08:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795752531;
	cv=none; b=k+1huUYLxlHum3QC6ghzwaXHIe9bKlFNW13oOrWVYSbveBr1atI571s0VcfLO1RYF2L/al4s5Q/UaUCK71r9qRadJ+a8yxfgyHFmybvRqjJdBfbFwIiFNtO44aiLvDwdtWuQDOdbfUd87vHoFTYmXM+VBVI/UIiJB1u1RQNtlgbzRPSYbOsiPhsbsSRWrB4p90qJrynXCiXH6qQ0XTBDtUiXrX15nELM6lvOmTKxhNfEIYUUpHCb8cdVtUiMT+kS0U1gx7lnNBdG8xryotvDQW2pJVW1lpDxPNqM9ZCCN4Hr9edpSbXmXuNUz9gC19z9pCWWDcdmnTolUbjALnCBEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795752531; c=relaxed/relaxed;
	bh=w+wci2AGQulIxz+YpoGVQN+yjllbjmorWUPR+eBBdFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OIpkECvb5b3oU/3NOlV7/mO0JjDiiUr8OrGBcQj6MjK8tDeH3QxhFQP1g4gZ24Ztuy9lRCoIu+BOL48gNDywxtZngTYLoXkE4AO+BDgeGjtw1f4ZxzKMm5dSUo6Z2F5oJkX2NlnlqWXE1EIaSJyVX78vD5epJJbyaodM34sM4DsHigQ84yFCRYNIWwmAYfRrlkPViaXiHhESIP3SYnTaQW1Lr/xeWYj9VB5eaUc48zCTE5gShuGvED0G6VXHW2c6MLU6i/AkZIceaAwR3KAEiwWxuMlpDX3FKygFP+Zc55CG6JD1viKXoOnIJsvs3lY2cUdwVooqVIPO87wWoAnDKQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFIOB8St; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFIOB8St;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbKfW161Xz2xLg
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 15:08:51 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95A5A451EC;
	Fri, 27 Nov 2026 04:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6D51F000C1;
	Fri, 27 Nov 2026 04:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795752528;
	bh=w+wci2AGQulIxz+YpoGVQN+yjllbjmorWUPR+eBBdFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NFIOB8StySlRU+btMPLOygoxR/VDftr9jHLmB3DoMDfXwC0OUPEEmCvmSMd0Xbioy
	 JDkpzO0Cew1QSvK7ZXH17Pj+6V6g2wLzLL1obpvNni91TuNJrBF3HWIJSH7I2hiiSX
	 koR0HUSs/q+QRNvPRmz2ABcz1xnCqXa5Yqp9KXqiT1tPw85kSDhmRBPoDfOsrd/cBD
	 EN2sMgn9UuAKPCwM8gMpEhnWsA3dTQibAX2r5kw4XOHeAxtP8glXUQD77xrRSSdYXG
	 wejUmQCt1Wk+m0uvFlPULSD1Um2vv5FKEfVKKQPz8+nplFfw/r/vTJHSXBsiNiIKqZ
	 IvLyIa+pT4jJA==
Date: Fri, 27 Nov 2026 05:08:41 +0100
From: Gao Xiang <xiang@kernel.org>
To: Zhiguo Niu <zhiguo.niu@unisoc.com>
Cc: xiang@kernel.org, chao@kernel.org, niuzhiguo84@gmail.com,
	ke.wang@unisoc.com, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs: print error code in erofs_err() of erofs_readdir
Message-ID: <awkCSfgINQ3M3Cj-@MacBookPro.fritz.box>
Mail-Followup-To: Zhiguo Niu <zhiguo.niu@unisoc.com>, xiang@kernel.org,
	chao@kernel.org, niuzhiguo84@gmail.com, ke.wang@unisoc.com,
	zbestahu@gmail.com, jefflexu@163.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org
References: <20261127025636.1333457-1-zhiguo.niu@unisoc.com>
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
In-Reply-To: <20261127025636.1333457-1-zhiguo.niu@unisoc.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Zhiguo,

On Fri, Nov 27, 2026 at 10:56:36AM +0800, Zhiguo Niu wrote:
> Under system stress tests, the following log frequently shows up:
> erofs: (device dm-8): erofs_readdir: failed to readdir of logical
> block 0 of nid 124
> 
> Without the err value, it is hard to tell whether the failure was
> caused by an interrupted read (e.g. -EINTR) or a real I/O problem.
> Print the error code so that we can get more clues to the problem.
> 
> Also fix the similar codes in other erofs_err() call sites where a
> real error code is available but not printed:
> - erofs_read_superblock: "cannot read erofs superblock"
> - z_erofs_init_pcpu_workers: per-cpu workers allocation and CPU
>   hotplug init
> - z_erofs_readahead: "readahead error at folio ... @ nid ..."
> 
> Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
> ---
>  fs/erofs/dir.c   | 4 ++--
>  fs/erofs/super.c | 2 +-
>  fs/erofs/zdata.c | 8 ++++----
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
> index 4aa52a5f204a..69aea8a7c3dc 100644
> --- a/fs/erofs/dir.c
> +++ b/fs/erofs/dir.c
> @@ -83,9 +83,9 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>  
>  		de = erofs_bread(&buf, dbstart, true);
>  		if (IS_ERR(de)) {

I guess the correct way is that we shouldn't error out -EINTR.

> -			erofs_err(sb, "failed to readdir of logical block %llu of nid %llu",
> -				  erofs_blknr(sb, dbstart), EROFS_I(dir)->nid);
>  			err = PTR_ERR(de);
> +			erofs_err(sb, "failed to readdir of logical block %llu of nid %llu: %d",
> +				  erofs_blknr(sb, dbstart), EROFS_I(dir)->nid, err);

you should just use %pe here directly.

>  			break;
>  		}
>  
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index e92a7fa90ae3..39f195e6d10b 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -273,7 +273,7 @@ static int erofs_read_superblock(struct super_block *sb)
>  
>  	data = erofs_read_metabuf(&buf, sb, 0, false);
>  	if (IS_ERR(data)) {
> -		erofs_err(sb, "cannot read erofs superblock");
> +		erofs_err(sb, "cannot read erofs superblock: %ld", PTR_ERR(data));

same here.

Thanks,
Gao Xiang

