Return-Path: <linux-erofs+bounces-2190-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DDED3EE84
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 16:40:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxmyd6d1Tz2yql;
	Fri, 23 Jan 2026 03:40:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769100041;
	cv=none; b=YJQhAaf+lmnw34F5RdNrcfqiBTMd89+TFOWnetJHKQlrHzH0dLlLcSStJZUsqboH1yt1Sv7eC7TZPdSSaYhGmT0pvN+J6rsieEtoJuqseJdUmXIOk0zH9PSFxxaiOiG9I8eUjyhRBJjgnmrY9XiE5bzp/DgjiPiEI8Fu/JzYG9LE+1g+gsd/hdJZ0+apZ6ZsaVQ8IGH10UXFm+ezYTtErRfinpVyFzVVoIiu5TcOyDjVNme72isx3mlT9othFTvt+c7bLpcsOBllW+zK0znQ9I4jf0wQ8nwnlzB77xSJHG36nfT0Xts9fijeM0TKho1E2SwcqFPBVPb4DrcE2iUKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769100041; c=relaxed/relaxed;
	bh=syGS9brh/yDzXJb2T0Cga/xLH20nK1dJL8Pud/2n4Lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aRa9XNJXgFaGmfViPzg+ieFra2S8uwqXBB/U/95Dn3SxJG9w4GSuNLg5+7DvVR1/LAmdOzFF0RtabWGRyFxqEpeLwMFcWpfAZq0Nx0abGOQZder790c4GxgvNw2ABQKpE0KuzzmZfYL9E1xGxJZVOZ29g6K+E/sQhRa5ui4mLRepuTSve1ErgGHSqpyLsrvj+USXoFneBazn/L9B4y5wvJUBOh0oYD9vwDeRSgBlEfuqIoxzWNdoFp53Xjkz0Rb0PkBzyrAhuNh2Alo+DLBjefrSxu5my8bcib3fsmZYPo0k0uoIkaoRae5kNcrDt+Fn1H9xnKzADv2x/ikXI2Gljw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uK/mUbp6; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uK/mUbp6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxmyc1j57z2xl0
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 03:40:39 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769100035; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=syGS9brh/yDzXJb2T0Cga/xLH20nK1dJL8Pud/2n4Lk=;
	b=uK/mUbp6K11YPqwZ8aWXQ1SgpYC/jsY3LvSnNbigrv+Y8qgpDXzc5gWwzTYJkdhzC7J0C1+hnyB9kSbBOz1E6d9XegpYiGM8R9s597Ex7bwb4DT8ekptSNZy95iQtxpN/xqIIO3HymgGMsR5fNj0FDucqg0840EAJ2Mlj1u5AwM=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wxcwsl0_1769100033 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 00:40:33 +0800
Message-ID: <87884a51-f6a7-486a-96f8-26d037f9dd76@linux.alibaba.com>
Date: Fri, 23 Jan 2026 00:40:32 +0800
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
Subject: Re: [PATCH v17 10/10] erofs: implement .fadvise for page cache share
To: Hongbo Li <lihongbo22@huawei.com>
Cc: hch@lst.de, djwong@kernel.org, amir73il@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, Chao Yu <chao@kernel.org>
References: <20260122153406.660073-1-lihongbo22@huawei.com>
 <20260122153406.660073-11-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260122153406.660073-11-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/22 23:34, Hongbo Li wrote:
> From: Hongzhen Luo <hongzhen@linux.alibaba.com>
> 
> This patch implements the .fadvise interface for page cache share.
> Similar to overlayfs, it drops those clean, unused pages through
> vfs_fadvise().
> 
> Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

