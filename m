Return-Path: <linux-erofs+bounces-3731-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E225DCDB46B
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jun 2026 03:20:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkr112rsbz2y71;
	Tue, 23 Jun 2026 13:20:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782184821;
	cv=none; b=MVz7r0WlQwweDNZ7Yf6ACjFFR/sdGOwyOEduKIqYrLUyoFM0X49gMr2gDektr+vw3Z1k6yn+W43ArbowYZk3rvT0P3447imIdaots70laIKK3kCopC2v131IYtXmRyMdiBEmz338bk2LBoTO2CFHUF4mt8cNMJH+MczO/tNhrTO4zz3MzkaiB1y2ENaegl1WAsc8be+VqmW1mzytdoYHOUeKYh22KBHgW2AP4CPKpdE27jAgL8DXkwsZkz23gEi+ywUp7bF/gUvCfuygGKG932y6xNX5Gs/llQn3uIZdRXEhqjIFR458ByGLd6m6/UDgDpSjuC0L7TT11jDxBfEg1w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782184821; c=relaxed/relaxed;
	bh=qjT+JLAFydGrra+0UYmoq3fNee3FFZfdgkBa3A3KMAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VrEslWGeuroQ7mxjaXmDsfitfXFNQ8llBh6+t0TbERuBBH5W/fG4kZVRS34yQnHKgIB9fV815RRwNkzCxLyqgxDS2xHRy6hWHis/XjaFbCDMbIKmqeBpHnGmm86v2xNbsl7ktjdFsM4dORNO+MR0pWvBk4k8JpO2lxpvhrXbYc+4glMv5GGloSaPOTX4paglMx8MJMMi3uoXd5aEUj9WToEeasKemrYmQ7zaA4emEqfSh9Th9Es5tHxsLvrl9foIDIVzGYK88viU8L83S4sASS/PnXCbY1yF+TX8G2DgKw9m9qDsg2Mcf9CxMCyVqY66Uh4G4KFX8d0wbPWGV0IFYw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=maLnDibO; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=maLnDibO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkr0y5WdMz2xwP
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 13:20:17 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782184813; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qjT+JLAFydGrra+0UYmoq3fNee3FFZfdgkBa3A3KMAU=;
	b=maLnDibO16j5SMjBv1GUbrTbbQ1NtOuEyILRExF1g6GqmLePo85YwyRWa3tFjxU/om5dJSe1Tk8bTfH2VZ1EXWpTSyArKZ+wieAAp1Cl8gEf1brkkNbIvFCYLbS02LRnV5CZTnu/S3ItwaAtk8efV+shqof3dkD5sIRfwZE/x4E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X5SQorA_1782184811;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5SQorA_1782184811 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 11:20:11 +0800
Message-ID: <9d5e66e2-189b-484b-8ad7-1fd890c4668b@linux.alibaba.com>
Date: Tue, 23 Jun 2026 11:20:11 +0800
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
Subject: Re: [PATCH v2 1/2] erofs-utils: lib: don't abort on compression
 fallback
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: zhukeqian1@huawei.com
References: <20260623025334.1049210-1-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260623025334.1049210-1-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/23 10:53, Yifan Zhao wrote:
> File-level compression fallback is control flow, not a real error.
> Return an erofs-specific status code for it instead of overloading
> -ENOSPC, which can also report real space failures.
> 
> Keep the global compression context reusable for that fallback while
> preserving the fatal state for real errors.
> 
> Fixes: a729584ef975 ("erofs-utils: mkfs: avoid hanging if fragment is on and tmpdir is full")
> Reported-by: Bastian Schmitz <bastian.schmitz@vorwerk.de>
> Closes: https://github.com/erofs/erofs-utils/issues/50
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---
>   include/erofs/err.h |  1 +
>   lib/compress.c      | 10 +++++++---
>   lib/inode.c         |  6 +++---
>   3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/include/erofs/err.h b/include/erofs/err.h
> index 7dacc91..ef882c9 100644
> --- a/include/erofs/err.h
> +++ b/include/erofs/err.h
> @@ -29,6 +29,7 @@ static inline const char *erofs_strerror(int err)
>   }
>   
>   #define MAX_ERRNO (4095)
> +#define EROFS_ERRNO_COMPR_FALLBACK	(MAX_ERRNO + 1)

hmmm, the naming is not quite good, I will think out a
new name and manually change it.


