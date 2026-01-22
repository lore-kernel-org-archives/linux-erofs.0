Return-Path: <linux-erofs+bounces-2140-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49F9C44500
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 09:09:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxZxw24Qzz2ySb;
	Thu, 22 Jan 2026 20:09:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769072964;
	cv=none; b=dr2S4NLd8LP1DVVq38alEFT0S00JgAmyK/9Gzn8YYJkNX80cZv9EUXv8lffLshlfZ8cKOVyjtEzSa6azppM2b5QOePI0z2786JHbxx8l94YZbizxZfeJ2SZFMV9hsj1V8ZttpfMjH1xY8oY4S9vxEWK76EBkztkrxQEDEhYRyfAyeA2+bwE1EDff6zVnVENkcTiCVQZ59KKkldygYWDJ1jecONGlPnEmOltRBbfCHO8P57lwEEFpP4hzRQ4/wk/833n2v1SEg+HIquGaOoRSlWJmV6C+TlwfAk8vk3nVByYPcOlwj+dN4eJcJYSsgjAHI+RXB2Hd+ljs99O7QuQ15w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769072964; c=relaxed/relaxed;
	bh=hCTLOra8zdZq+lgmpiQwqt4FVsprbiN5/xv1dEoJkEo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T5JrtYBjKQ2F1iJgign0DHLrrfarGv8pw7G0attfrStSOVbqfy9OYK+U/0qaBswNhZpVLKNZMgXls8UPzTnQc/tGw9DX+jVdzORp0VNfKwopybKn1QkavjNxir0mGdnPEy0z4m7b1yZHKHq6WpCSxJVsG9Q55YIgpnX+8UwBoUBEkVRJExDqc+uYYEaCWz+sRukMEZB19DjMu7BNc6mdhI+67oLRJ3q75JKy3ZdZuC/ow4yVMScb0tAwdCrxEgq52yk6jDzoVAaV3oWSNiWZZyjWSLZF8mw+0NaXvl9OtuNnQzD99I1wlv7gaj5F+L2klYtzVX+O2d9DaLI/5c+ykA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=mJC7O5Ks; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=mJC7O5Ks;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxZxv5H5Yz2xS5
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 20:09:23 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2812B442BD;
	Thu, 22 Jan 2026 09:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCA3C16AAE;
	Thu, 22 Jan 2026 09:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769072962;
	bh=fjyW+4ep+D73HQOgTrM+B+JJzXKK13g1aD6Wwcoeobs=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=mJC7O5KssO09g3kbo/Kl2Z2dT1boXrJPRIp7nApdvt9QR7P65KhVUkr/Msne7D1Ta
	 nHxpcr3cd/qEwqLORCN7MrFRVFRRYpZSXffrHtzPcQT3KoiLgopP2Gb0COokawAM7v
	 eOYMA3FINqfIoruDazfo6XDuNKdCwtyzYPDnRUwcyor7rodXzFdNzTR+3yOvSkjga5
	 yTMhN14KZcroP5fyNGFA+E3f8NGfqCkY7xyEw1EVOtGlH61y34O4ynvLRjKp1V3BDW
	 ihta1euAc31L37CUpvi8pSDKOuQQuxT7s4+BNIDYyfX+PBM3p/gyz4zhuj89IjyX5b
	 XHgQT+gG/bvSw==
Message-ID: <1e0e5367-9f2b-4920-a5be-ce61f9a5387f@kernel.org>
Date: Thu, 22 Jan 2026 17:09:25 +0800
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
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] erofs: remove useless src in erofs_xattr_copy_to_buffer()
To: Ferry Meng <mengferry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20251229100515.111287-1-mengferry@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251229100515.111287-1-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/29/2025 6:05 PM, Ferry Meng wrote:
> Use it->kaddr directly.
> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

