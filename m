Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADF7606F444
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Oct 2026 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqNY3M2L
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8DFN6gF1z2y7M;
	Wed, 21 Oct 2026 00:45:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792503928;
	cv=none; b=PRdxDZs92YkXvLM0DkPr7yFRvjW6tkaC0LkRgIXKwhqk0UWV3QRsL+UVGPGextWaOaOPO1Eq8A8x4Ba9XEBA+vdtmdsnzLxppGLIdeqpd5DDqQ9N9ccRFJU4TdMIVXcJRJMZIUVkelYpWTLsyWI0/fn1bxjJs9eqSaGBfBPeFRg0f+Xp5fYO5fzeleW772D4U0xTfxReuVkC5LsUsKQOoFAqI0J6vJy7hcTlW/uqxTRqm8C+iFcvtAaO7Wc0UxGJRc1Ww5h+z3+Ja/Im4Xpg80HHJX10aeMnxUUlV/nV3dpEH4Wh1N7/gYuYOnoVdWEkD1Nk13yPxK6WhUlabpTb5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792503928; c=relaxed/relaxed;
	bh=BNs6lgZgrjxnbk7MM5mtcg07ZQvr4MMdIv0J+W78mZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJZiN9hZ7qEE4R3N1UW+K+Pwby4OTo20lE+0doNFRqSp9bMli/xsTVRMT5Gnlsy8Q0YYpZCB6e1qA6nQlAtzZIlKbkG6tjHNa5Yq/hoot6z9OnR2Rzta87eCOVqEm4MBWVmxLCyBbDMBdq9wT7Bh8XvFEXtSKkADPuTQd/biCjgauEVcQ3Y2wfS8syiZnW+Lx3HKrkvjiwgfRQzbASuoLgmDF1P7XQqu992c4yGIoaZA1CZ+A2kFzCUWzU0SLIcr84j3SXs6fgfniIkQLOpf18huQ30sfE43ebwL5y4D3lqfbZ/zIrDb/tGoiD8xp0VysFsv6ewPkewC3e9EDXWytg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqNY3M2L; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqNY3M2L;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8DFN1PlPz2y2B
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 00:45:28 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C108040549;
	Tue, 20 Oct 2026 13:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC59E1F000C5;
	Tue, 20 Oct 2026 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792503924;
	bh=BNs6lgZgrjxnbk7MM5mtcg07ZQvr4MMdIv0J+W78mZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IqNY3M2LlBw71npA4nqIcqTrwJoUmYC3KFq67a9loZxFO456wPfYWKoaiPQUOsGZ+
	 t9pbxSK2ZTutKi3HQaXGnXy7IIfOo0xK0fSHjRqeq+n4YH5qIq451/V0aMsxfF6Mxv
	 lacXab7gr52dP20QuZ9qnw5MotCgzkWjGpnLMoZWE3tCSQmm44cLsG1luSNqCZ/YBP
	 g3m4iSu1QTI3GKPsRnVNmlGznQ0FqBYZUlEX6zSPjaW23U8fQI+83F/m4WeYT7OZIg
	 WBfwdPX4BtNHVGH63TnCvIZOgNw6RB0OHwt2ziC0aI3ek6b5aPSC+LlSZJZKnqJ7iY
	 rGf/OOg4kU1Tg==
Date: Tue, 20 Oct 2026 15:45:19 +0200
From: Gao Xiang <xiang@kernel.org>
To: bingying lan <lanbingying.lby@linux.alibaba.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org
Subject: Re: [PATCH] erofs-utils: lib: fix xattr prefix offset truncation
Message-ID: <atdwbyRJoiDjfFN5@MacBookPro>
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

oh, it seems an erofs-utils one, merging now.

Thanks,
Gao Xiang

