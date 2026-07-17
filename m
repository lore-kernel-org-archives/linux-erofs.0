Return-Path: <linux-erofs+bounces-3931-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71397C4450F
	for <linux-erofs@archiver.kernel.org>; Fri, 17 Jul 2026 03:43:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1bP14RzJz3brP;
	Fri, 17 Jul 2026 13:43:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784259829;
	cv=none; b=jTpVfH/Z6x9YAS9QRhUJPaR6yPOhQ/MP0tq0Ypeq1AwAkes+8vtxWqCeSOmR5wz77jo1Cx1W88zBr2MlH87VKyJgmIP2DMNTmuPKQWketoE4OvaDI6wW2bPnywHvflqXHlnBo1gqF7Rri3SSRspr6acP405S90huNR89XFyiWueWQsQorDC4rFxZswCFLQVNDzF+Yh89rMkU4L8UnVFKiGoE6M04jhNz7ky/wAFrKSukW8kzm3wpwilQpIXa7ohkXr01AVksy1o51eAARegKacet7Lg8F+mPpRIeAplM52GluPluA/Yl4kINDQLqvKwtmeJ3H2M6gf6bvn0xsnueKA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784259829; c=relaxed/relaxed;
	bh=hbG0T2IH58E2ZuetAf/eBFvgeoRb92lgSfBdcK6cl+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EdZ26ET6r0BX3hjAGMO/AMgPM6ZmFwmqMvUcxS0LBuZLntz6rHpZkQxwgpX5QzbTpdWQ3/MluVldk4IoHWqrBtp2qU0expGZBtjzSppwI0u0SgR3iM+us/TpH77eF4f3P4QvaS2y6SgJHRRCzws/vVo9s0GyTHg7NdkRYNuFL5RG2FAdynNTY3FULyvr/T+tfCRw0rQh8hVo4IsBYo+J+LKvYbNfWJhYMja+xWrHFBp6nsfHDjTC2onWL62ImgVRvGpJ1OZRtYGIlKYrjYvmGPzFqZScFexNrLEEt+Z99wCuPQ4XR1LYHDb5w83KJN7McozVqhOK43KoyeXIyjoYAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WkxHc9wr; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WkxHc9wr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1bP03gkBz2yRF
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 13:43:48 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784259824; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hbG0T2IH58E2ZuetAf/eBFvgeoRb92lgSfBdcK6cl+Q=;
	b=WkxHc9wrIz3ryVqQbmXJQ2SE62O6x5t0+toeaaY5GNhQSezVww8IZnl+yql6wrsVNMW0gm63IDq7pLb3MMoSW6lG4dda54PrzZIg/EQc06qJK0oKPtbWc1d52sgQiBhvffMfRLxAPRny58RyqmZDjLAU2pwIOuHioOThHTaYL1A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X7G2U7i_1784259822;
Received: from 30.221.133.5(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7G2U7i_1784259822 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Jul 2026 11:43:43 +0800
Message-ID: <d0d5816c-8aef-4155-806f-37094c79d847@linux.alibaba.com>
Date: Fri, 17 Jul 2026 11:43:42 +0800
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
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: Michael Bommarito <michael.bommarito@gmail.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260714114729.3760594-1-michael.bommarito@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260714114729.3760594-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/14 19:47, Michael Bommarito wrote:
> fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
> pool from num_possible_cpus() when the lzma_streams module parameter is
> unset, then z_erofs_load_lzma_config() preallocates one image-supplied
> dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
> systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
> decoder state until the erofs module is unloaded.
> 
> Impact: an attacker-supplied EROFS image mounted by the system can pin up
> to 8 MiB times the LZMA stream count of kernel vmalloc memory.
> 
> Bound the default stream count by a new
> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
> worst-case default preallocation is 128 MiB while preserving the existing
> per-image dictionary limit.  An explicit lzma_streams module parameter is
> still honoured as-is, so administrators who deliberately size the pool are
> not affected.
> 
> Fixes: 622ceaddb764 ("erofs: lzma compression support")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

