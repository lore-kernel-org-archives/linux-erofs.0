Return-Path: <linux-erofs+bounces-4646-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88573CA5FC4
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Oct 2026 15:43:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hxCjK4QjPz30B9;
	Sat, 03 Oct 2026 01:43:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790955781;
	cv=none; b=nAiHUPy22ta4sVz+ER9ipEcQEQXPelcumb24KB2sBTbZoUWuP+odcJozIRDUPlr0GQO5lNk66yzuL3g+Ae1waALgH3jejippOJCnVKBe/T79074mkTWWbCOA/7WTANWmF5Amk8+Nq2F6J2C77o0tQmKmuTkCp/Yo7iRtcWcypR7HHPJ69V3VSifGx5Uu9efXS7Mq5l97YRoOX2H+DA3y0uWV0VqkQg8ruG4T4kSrdPzHhwakKqiQ5hTy8Ec4tDT4xN1iRTiz2T2ez+14JGUvTliCunpLN/gSLb/Mtc56IpEsmMWssJchLMO/kQom3Ib6h4TaDnHd+emdxw8On+TtwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790955781; c=relaxed/relaxed;
	bh=KqWqAAPlKwxZDka4vPFIdL9fJ2MD7gHMuh0eSJBUyIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VD7oEXlcmXy2SaaLPiHTPOMBV+/ZG5xm5HEFaVL5g6hOenYBQnX+nMQI7xVDF8KmFWOi9qJ0SOcROukEfbVnrD61sJGFI+vwkMnBvmE2J2AZvqtjy9XARLH3zM2RWvplWUm++Ar22SyDzyvq46yY6TxDSfZN0moRi11inH/fEL5/pDr91UaZWF00tlTaySt7hhd9DvXQwsqp6cmgRvbU/laxbq5HD9fV6PG2fD9EpjFpuKNjvHlCEPq0dlJ+kOBavqeWtoeeU18Q4SbwqQ8ZjT2l8pDLr0MgvjQM6auKKeuTrkRI/N39QmlQWmYsAKJQ/9+/6D1gMhU5/DP8gKqmQQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RvdUXkGB; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RvdUXkGB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hxCjJ694dz2ynZ
	for <linux-erofs@lists.ozlabs.org>; Sat, 03 Oct 2026 01:43:00 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FFF860A8C;
	Fri,  2 Oct 2026 15:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA171F00893;
	Fri,  2 Oct 2026 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790955777;
	bh=KqWqAAPlKwxZDka4vPFIdL9fJ2MD7gHMuh0eSJBUyIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RvdUXkGBURvj9+GlFXWYdXsi+/yPP68ys9IVaxCvrJqaioIglvXzaGrUS18aQP9kr
	 4FjVDTWi9fjWEThrUBiWS5AUuCxV5k/v+rN30KdsHnH3oaIRUN4OJ4u74ym8t2HuXV
	 hLR/ICt3OQohgrTXAfyhcrgvPKrkf+n8sJDtXhCAFOqjyLKcG4N1K7JJBjrWyEZCAS
	 OsxQ872xDCml/v3NwB9KyToGUuC8ZQU/Cyd8jOVCWUvKJQ08JcXjSrfZcGaFFKOojA
	 xf6imembAorFL9gQAwFHYYzhMrDXZT3i3rPUWp3Oi5sWT1HjVqk3pLkkjp2gq7ShHY
	 zztNnYIlG5ElA==
Date: Fri, 2 Oct 2026 17:42:51 +0200
From: Gao Xiang <xiang@kernel.org>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, xiang@kernel.org,
	linux-erofs@lists.ozlabs.org, Jingbo Xu <jefflexu@163.com>
Subject: Re: [PATCH] MAINTAINERS: erofs: update my email address
Message-ID: <ar_Q-2yEkQPpnEnv@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jingbo Xu <jefflexu@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, xiang@kernel.org,
	linux-erofs@lists.ozlabs.org, Jingbo Xu <jefflexu@163.com>
References: <20260921030417.87932-1-jefflexu@linux.alibaba.com>
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
In-Reply-To: <20260921030417.87932-1-jefflexu@linux.alibaba.com>

On Mon, Sep 21, 2026 at 11:04:17AM +0800, Jingbo Xu wrote:
> From: Jingbo Xu <jefflexu@163.com>
> 
> This email address will not be available in a few days.
> Update my own email address to jefflexu@163.com.
> 

I will add your original
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
here.

> Signed-off-by: Jingbo Xu <jefflexu@163.com>

Acked-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc3cae2e378b..1008e14254c2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9681,7 +9681,7 @@ EROFS FILE SYSTEM
>  M:	Gao Xiang <xiang@kernel.org>
>  M:	Chao Yu <chao@kernel.org>
>  R:	Yue Hu <zbestahu@gmail.com>
> -R:	Jeffle Xu <jefflexu@linux.alibaba.com>
> +R:	Jingbo Xu <jefflexu@163.com>
>  R:	Sandeep Dhavale <dhavale@google.com>
>  R:	Hongbo Li <hongbohbli@tencent.com>
>  R:	Chunhai Guo <guochunhai@vivo.com>
> -- 
> 2.55.0
> 
> 

