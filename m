Return-Path: <linux-erofs+bounces-1094-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1E9CAC5AE
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Sep 2025 02:44:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4cXJ2t41Twz2ytg;
	Thu, 25 Sep 2025 12:44:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1758768278;
	cv=none; b=gI43D2gqB5UPwFBM70OBBgeO2kD2z72uMfbLARE5lcL4YTMIkw0vhm0RYQgeeUCVqWXtkT0cOXUXsXp4tBA1IdlWlt6PvpeP06efGkwcFnpgsmRO88Lo7eMELxyrVwQgFc6nuEKiuen/8C7KZrVS6Yg5QuunCg2Z5ESdi5kprV7UbVSAdaXJ7ll33n8d4+3ECVqwmU+96OsqJXwiDLYrTvGNhMddrABWZW7BQdp6diHg6ozZYjuxktiWdiw2n1fD/d3YxLiwjhUE8kHTo3xlYATPp15va4WwMtSGJFDBnhicGdU673yVcRAJSGe/fh0Q1ARu9SKZfFYzSkfp9Ikoug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1758768278; c=relaxed/relaxed;
	bh=6pFN3Ps3uuO28jOfe2fN0GP7NN54es1U7tblyQRKSGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lsUcmgsnl84StZnui779JN8isx4gPXfuBK6DNabJlTN7NMF8lDwUET62vSoCpqy3qFQWQud0fpoqBWG9KltfkowAMfC1EKKLqfADrS7nuS+mWpegpMHkIc2rjgU4lc7mIbZe7Sdsu55OaLLwFwz4ETWE+n0GEgUbtOhpaPqQfnx2003XPm7sR12dqTbYQkLKl/MbaAJGCG9OPe8G88WEHNiAA7bzvnNWf203ZlRYz2Lv7z+P/dwzeqhXNGAQDJhd80EfAgEFuUNPW/UNGUmmXh5+VWClf9v25giFvAma8lKsCSHzbQa261z5Smm+L8bfSfexIlQyFOQIy8xpkUgYrA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=woGAmfVI; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=woGAmfVI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4cXJ2r0jwxz2yrm
	for <linux-erofs@lists.ozlabs.org>; Thu, 25 Sep 2025 12:44:34 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758768270; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6pFN3Ps3uuO28jOfe2fN0GP7NN54es1U7tblyQRKSGE=;
	b=woGAmfVIYkU7UhZ+cX7KhA/0HTzFlp0lqzYj9M3WCvxraVVqfHwtFnzyHaS8fNu5/xqwiti2zYI1QqhymmIFiG5PrSKjRjfW6CA26onWwIuSpnTxS8T/QL//yqMe4NhMSkE8f0hd6gy1XT8he4BqB+pRVaYzSJp7b+zkQTRiuro=
Received: from 30.221.129.251(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wolpgv9_1758768267 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Sep 2025 10:44:27 +0800
Message-ID: <3b3ca672-af9e-4eed-bea5-40ad082cdd20@linux.alibaba.com>
Date: Thu, 25 Sep 2025 10:44:26 +0800
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
Subject: Re: [PATCH v5] erofs: Add support for FS_IOC_GETFSLABEL
To: Hongbo Li <lihongbo22@huawei.com>, linux-erofs@lists.ozlabs.org
References: <20250923070112.16644-1-liubo03@inspur.com>
 <b17e1d63-3d9e-4336-9b4e-a9bd2abff72a@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <b17e1d63-3d9e-4336-9b4e-a9bd2abff72a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/9/25 09:02, Hongbo Li wrote:
> 
> 
> On 2025/9/23 15:01, Bo Liu wrote:
>> From: Bo Liu (OpenAnolis) <liubo03@inspur.com>
>>
>> Add support for reading to the erofs volume label from the
>> FS_IOC_GETFSLABEL ioctls.
>>
>> Signed-off-by: Bo Liu (OpenAnolis) <liubo03@inspur.com>
>> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> 
> Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

Applied now.

Thanks,
Gao Xiang

> 
> Thanks,
> Hongbo

