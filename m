Return-Path: <linux-erofs+bounces-4399-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EB8C61DE4
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Sep 2026 05:59:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYwDJ1BYPz2y2S;
	Tue, 01 Sep 2026 15:59:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788242368;
	cv=none; b=Ti1Da6xlmfnTpxF7I60Jc288CtaL79VtINazWNuzIvlWK1DLIPFvShGNVlXAiRuC8rrCSLXC+q5V0XHa1CdkBLqBYk1YafqWb6vInLaIyDxKKiJov5ZKxdoj1fZfthogsnJU7wxEnisLqhlPCRaTUAQyy0mxAsAkfjHWrywKEihCqSxVDFzpDJpEZp9S0FT1XKISYhu60gFTXV3Rw4HGnxda9itWAq4JpV8KT6ByXO6UB1KhOUQGiqe1R4bb7cRRdAxswcXvczl2BnPv7A/vwxWKiDIUySCVeP5wbBas9BX6hwTjpdAVvUDKudDgKcM9Y2FJuA7wFShq8wOO7emUjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788242368; c=relaxed/relaxed;
	bh=SzImJZLLnR7KzJ1vSv1N9X+Zs6R4uonAJmI6sq3tQuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEGV1PdxcmuOBgdK3TjHPuAsoFDcI3hE22BkZfdenu8mHWwcjhKPmD0D/SL9RYkewIYw5DfK7MDy8aWMvhV6SEb8er/NTUD5LUhAtD8C4nuQcwCuzvKYoZW0nIvvd5gjEi3hUiFhbzAbNXczfHlp7/JSmcWsqXPfCKhYs7OzwuDjq2ZEmqRO+ES6JFGk8F6+nSYQFa8f2faYij8nNjKxKiv4f5LHJtiL685BkDIacAMQnCFUooluQ0D/pVyqoNYm/PkS9A1z6Xh8RsQm8w8DVY1tcv+tdJHKDWagowS5Al1fCcjr+CLOJnYtUpgYFy7N4TP8n8TccDkFpnkmY3hl0g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jAok0+s8; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jAok0+s8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYwDH1kC4z2y2B
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 15:59:27 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95D2D40998;
	Tue,  1 Sep 2026 05:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07E51F000E9;
	Tue,  1 Sep 2026 05:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788242365;
	bh=SzImJZLLnR7KzJ1vSv1N9X+Zs6R4uonAJmI6sq3tQuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jAok0+s8gqUkYTlkSy9agEI/tLZevpFcyz7fQAUuLVrTlhdqkA8+bEdFm0OkKNGV2
	 YhJ/xWCmWC9WVhhaPvUldfix3UbPdQsRI/aCRULLyRyEM+pSclvqH2L0T51dJh1VIa
	 kKNj9qUc/tssdl8VJnv/VBz3vwDzqoxvmG0IVi+XuTX+Vvsmh5iTIQiPpaXz59vLZr
	 L8aov2+sZ3/ui7mh9C9s98suT+FAsYu32mvOLBBDRu+wfYlg2wh3scirv/szWkPPa6
	 VMhNRRR4utA7v9r3tb1Bc+6BfFywsYJDR7giWB+l+MrNssvgfF2M7BWPxU0F7F253Z
	 8iZQSz1c6DB3w==
Date: Tue, 1 Sep 2026 13:58:59 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: add sysfs feature entry for xattr prefixes
Message-ID: <apZpo_arKm1aGCEi@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20260901024622.108319-1-jefflexu@linux.alibaba.com>
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
In-Reply-To: <20260901024622.108319-1-jefflexu@linux.alibaba.com>

Hi Jingbo,

On Tue, Sep 01, 2026 at 10:46:22AM +0800, Jingbo Xu wrote:
> Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
> supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.
> 
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>

It'd be better to add a "Fixes:" tag since it should be backported by
the stable kernels which have this feature.

Also it'd also be better to mention the first impacted kernel version
in the commit message too. 

Thanks,
Gao Xiang

