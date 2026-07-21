Return-Path: <linux-erofs+bounces-3947-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C12C4451C
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Jul 2026 07:51:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h48hk40Gdz2xlb;
	Tue, 21 Jul 2026 17:51:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784620278;
	cv=none; b=KWtZxihI8dab21HX1ZAuUFIYh12vFoWeAyVkZ5/3ugKQbgyxy9S/oymmYjIXhI6JAMjVSYQY6CMnPCol4g6oNFyDcyM5qNewrWq5eRu1GvF3mR/dWxJq8T8H7LjoUezsQA7oO4wH0W44NQU9sRGGhlD5yXF0RsTpGGatO7icQFIgIy9EzGIOfssvqKG7TtS1O0miKfvPX+EOODZG7UVwA7VfZfvkqvvIcHrvxCa61ZSAdWGhEEE/1976wjgc9E0ehQf5PoAaAcIFi8o5BLemP2tpDN9Nz+nRSnJtNC3N2/6Z075oNlYWLIxmOtlQnUKqPTwHFDBYwjn9V+Xcg/Y1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784620278; c=relaxed/relaxed;
	bh=GEHV5tD5kWUaXR36g2ln35YI6PVcHV6TeqNgz+F898Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e4yyDnezfdmgy7LbynmlGeeyiOxpj5KlKeYBNC5EzdeocRb8SBtKgpNtev3gG0HPRQiMOJjTsQKYG8f/9Lwxhz8k8y/Tvu0Njnc8YBhaOHmedx8JXvHc3hqK6pxSD4PkldwBjLsmvkvkqEBXR3lxPWV8ymJdsbPxlrf/AQS1frmc3/HE1cqNLruxyMkHgyBHGaLSmgus2Rdj1FD5kNXoLJmbidEP00AQQBTFEdIpNVpfa7/KkuM4HVk6+rsgKkgsH76mKQNR+llMauJZLqRIEWmbBf56aAtofH1hCK1CbRxrtfIXzcfduFaL4kXctDut2Wlx8Q8VrNfEo7vaO9zKbg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=lvn0WDkA; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=lvn0WDkA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h48hh6DwBz2xjd
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Jul 2026 17:51:14 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784620270; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GEHV5tD5kWUaXR36g2ln35YI6PVcHV6TeqNgz+F898Y=;
	b=lvn0WDkA7UxCVAkz5L+99LPwsG7Yavz2uxW28smoOhmEODdNoK6ImaNqzqIqMGntd4OhIFWm/mAxT9PNhanxtQgPEsm3XzmKeiR9Ipi02DvcZGKTIOO8eoB/MncnIUJVuPXucfmdJ/Wa5geRzew59O1z2LANKRD2Jze2chEgxFE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X7Z980Q_1784620269;
Received: from 30.221.132.10(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7Z980Q_1784620269 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 15:51:09 +0800
Message-ID: <0bf409e5-d9dd-44a5-af67-b06bbcffcc7d@linux.alibaba.com>
Date: Tue, 21 Jul 2026 15:51:08 +0800
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
Subject: Re: [PATCH] MAINTAINERS: update Hongbo Li's email address
To: Hongbo Li <lihb2113@gmail.com>, chao@kernel.org
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 hongbohbli@tencent.com
References: <20260721070518.2016441-1-lihb2113@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260721070518.2016441-1-lihb2113@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/21 15:05, Hongbo Li wrote:
> From: Hongbo Li <hongbohbli@tencent.com>
> 
> Since the original email account is no longer in
> use, I have updated it to my current email address.
> 
> Signed-off-by: Hongbo Li <hongbohbli@tencent.com>

Acked-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

