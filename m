Return-Path: <linux-erofs+bounces-3701-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40ABCD98E4
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 03:51:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkDly29cnz2yVP;
	Mon, 22 Jun 2026 13:51:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782100318;
	cv=none; b=cfXKqojaGdln9tRTmOWBxtyF5/0LmsvxhZERe6Otr3yV+KFJGHvp6IHtLVt4xl7fdJEOUojAX0ittsbi+XyzeVSO6YXJAHq1DzrS3reGebFkEBTkb+nlVjazXsLer9H7T3iQfqmvdjJApsw730+e+eploWFP12tzjtGTMYan6dDQx3z74pzcMM+b7ILsALLuB8Coba7+2VVS2IDOC+ensgYDWRGwcI7ztAvD3gelXsfYsKip2Qsf3SaO9cOgefaH6dLu89Rk4AHSN6MOC4UZWqagVh7hYZhNJu8lw0A9g9wdUy3F7T3B+niWc95YKM9c7/rkvjL7HIKpVxK/5J7gug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782100318; c=relaxed/relaxed;
	bh=H/abZO8hGE9v2Z4Jo3zI2twB0zGTlsV7SHkmjkd71Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VqlhRTqXbDBp9PJlaI94j6y9bfXI1lGK+cEyMxvQla8GjFjPWNd0aIh6GBesBZBEAq5H480/SAEKtcdMq8CwePH0kXwUv3x2EtyB1RQt4/4FcDryQgYphxESkvMZCr0m+FjFijs3nfBaG29wYxmHcrd3JCQPwfmBxNAEH4kHso6rJCLu8pJkadbCsFcE9UYgbhn6pOI9BkuunsyM5z0sDT7HTDkMAozRrno+29hggFgqLhb6UKYXkwqgOYyeq6ME8tnyUIj7TfE/qw+wspZXFP+m2W4rKWfnMpGxh1RjpM4nU6fFqGakSSt86N7NAERb5ke4CgDreGPa/gKHTSSd4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Bfvx23Xa; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Bfvx23Xa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkDlw2sRzz2xwH
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 13:51:54 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782100310; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H/abZO8hGE9v2Z4Jo3zI2twB0zGTlsV7SHkmjkd71Zg=;
	b=Bfvx23XaetfoXuBR4CqY+OwSFFS6L0t9f/edBUBa7QuThnOs7lkq0hYydSmNaobRdTU2VI7SxLIvDbrYT7YkWOBlJt54+f9hhHKHC4iqp18M4D9dU2yqfciutGFtdk1Zx7btKZf5va7IGn+K3sY9SDYqpFjoK3Zap5zIVq9XzZ8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X5H0YFL_1782100308;
Received: from 30.221.130.114(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5H0YFL_1782100308 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 11:51:48 +0800
Message-ID: <4433eb42-4ca9-46ae-98e5-7bd388cad0a0@linux.alibaba.com>
Date: Mon, 22 Jun 2026 11:51:47 +0800
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
Subject: Re: [RESEND PATCH 1/2] erofs-utils: lib: don't abort on compression
 fallback
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: zhukeqian1@huawei.com
References: <20260622034248.1047783-1-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260622034248.1047783-1-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yifan,

On 2026/6/22 11:42, Yifan Zhao wrote:
> -ENOSPC can be a normal compression fallback when fragments are off.
> Keep the global compression context reusable for that case while
> preserving the fatal state for real errors.
> 
> Fixes: a729584ef975 ("erofs-utils: mkfs: avoid hanging if fragment is on and tmpdir is full")
> Reported-by: Bastian Schmitz <8330902+bshm@users.noreply.github.com>
> Closes: https://github.com/erofs/erofs-utils/issues/50
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---
>   lib/compress.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/compress.c b/lib/compress.c
> index ea07409..2a43b81 100644
> --- a/lib/compress.c
> +++ b/lib/compress.c
> @@ -2031,7 +2031,11 @@ err_free_idata:
>   out:
>   #ifdef EROFS_MT_ENABLED
>   	pthread_mutex_lock(&ictx->mutex);
> -	ictx->seg_num = ret < 0 ? INT_MAX : 0;
> +	if (ret < 0 && (ret != -ENOSPC || inode->fragment_size))

Thanks for the fix! but why `inode->fragment_size`
is used here?

I guess if (ret < 0 && ret != -ENOSPC) is enough?

Thanks,
Gao Xiang

