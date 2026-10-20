Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E117606A331
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Oct 2026 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QstRVWs1
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8DDF0lp0z2y2T;
	Wed, 21 Oct 2026 00:44:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792503869;
	cv=none; b=OjYhiPZ5fovp8puaq2a8K7Gzgq7brPvbVGO1C294zk5KG/AMRWlajvfTDsArUKntgO1YWiNlBkUEIWp/l56AcJ+oA/GoAFI2TJiJucpkGWedgoX2QB9vVU4yYO2K289V0Bk3ihzwryo75T+6eJvCrRxGjmp0wdiu8PAZ57pOfztgfbLO1pmk6II/+2TyMnkvsrfw9zquCVxlAsnoZwR72tet2BR56Qat2k4P0s6FH6ZV6E8zM/w4NlTQelPGkbPA69EJzsQ5UA5oxe9Jw/0d6Btq5OzMe2/4MOASwUGlKAGmPBnnfsaD5WG152nuAWjnmPoMUzf7uGgtEu7mm9pyHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792503869; c=relaxed/relaxed;
	bh=4v/R2L1ktn+ABRMMUm8NRyO1GZ0BAB15EvJH232HrNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RccrMOVVa88tcOoBUl/SvJiyNBogQWedX2TP92ITJq7fE00I/7pojCIASjgE4zaZZPb6UdVV5zwvR+C19iK9Y1HM0efd8PJPPVko8/UPsB/Nc8x0GtcaFDLUiQExtcgn3yaiS/U+wrPsfWzl2o/yt6j109WxlozyPLFrq0ESjtuFNgGZwDT4/9hs2ve/jgVgqDPeN9JkziP2txI1CNLQZlswz/Iid1rlAfIVADw4Sm+djSqyTbO0xDO1jDI8dgrQgFWbNF9K75OV4hKVkuSVH67BPCve5mwPqdoSoP1HbUa/c1wqnhTagRih9HCgEBJV3hWMFA2wXS0d3WYm2JcbaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QstRVWs1; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QstRVWs1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8DDD3Pc6z2y2B
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 00:44:28 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE9D8438F1;
	Tue, 20 Oct 2026 13:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FAA1F000C5;
	Tue, 20 Oct 2026 13:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792503865;
	bh=4v/R2L1ktn+ABRMMUm8NRyO1GZ0BAB15EvJH232HrNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QstRVWs1+u34PY/I+2fP79FdisWauxScOShtXkz/JTgTY2U0pYOtxQF07dLQyd0Po
	 CNuuI/SYHninLf/KEYzMRqP0c6qA2wcIVRtF4ZBdv5rEpvGqPR9UFL6lZ7hiINnhXU
	 h9En9JJzKt5RHKM9KgQJgE/nL5pKtfNmUn4mNrAuey8qWznfx+2wayj0ncXY7pPkn8
	 IE3f+6doY2Obi+u56+m/dbgukYnyGK5X3u/rlC9A4hvUqLhYTkauopi0L5kOD/hZgn
	 ZDNzFA6w8nOPHvtRK1R3hSdFRQ1sB9ou89aEaZ6Zr52Iwh5RnALr4G3SE70yBSUwOT
	 7CZLaBOnz5hDQ==
Date: Tue, 20 Oct 2026 15:44:20 +0200
From: Gao Xiang <xiang@kernel.org>
To: bingying lan <lanbingying.lby@linux.alibaba.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org
Subject: Re: [PATCH] erofs-utils: lib: fix xattr prefix offset truncation
Message-ID: <atdwNLVXkwSgARDK@MacBookPro>
Mail-Followup-To: bingying lan <lanbingying.lby@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org
References: <20261020055218.2953541-1-lanbingying.lby@linux.alibaba.com>
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
In-Reply-To: <20261020055218.2953541-1-lanbingying.lby@linux.alibaba.com>
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Bingying,

On Tue, Oct 20, 2026 at 01:52:18PM +0800, bingying lan wrote:
> xattr_prefix_start stores the long xattr prefix table offset in 4-byte
> units.  Casting the byte offset to u32 before shifting discards its
> upper bits, even though the overflow check accepts offsets whose
> shifted value fits in u32.  The table is written at the full offset,
> but the superblock points to the truncated location.
> 
> Shift the offset before narrowing it to u32.  This prevents corrupted
> images when incremental builds place the prefix table at or beyond
> 4 GiB.
> 
> Fixes: b6b741d8daaf ("erofs-utils: lib: get rid of tmpfile()")
> Signed-off-by: bingying lan <lanbingying.lby@linux.alibaba.com>
> ---
>  lib/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/xattr.c b/lib/xattr.c
> index d86d94a..e742bfc 100644
> --- a/lib/xattr.c
> +++ b/lib/xattr.c
> @@ -921,7 +921,7 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
>  		return -EOVERFLOW;
>  	start = offset;
>  
> -	sbi->xattr_prefix_start = (u32)offset >> 2;
> +	sbi->xattr_prefix_start = (u32)(offset >> 2);

Good catch:
Reviewed-by: Gao Xiang <xiang@kernel.org>

will move to -fixes after -rc1 is out.

Thanks,
Gao Xiang

