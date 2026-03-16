Return-Path: <linux-erofs+bounces-2716-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB9AD58B21
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 04:35:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ2M540RLz2xln;
	Mon, 16 Mar 2026 15:35:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773635713;
	cv=none; b=RvXDci0cOfnE7Q636RUQvmRSvCVaiyv9VC1+geXgUS9f4DsaN2DDav8SdoaPNS06wAWl5uNWr7IQpuTeRHoB6wW+TY8DcWQg1iTGjF5geziMtrP7N0gZHNsppkmFW0LrUZhcFPpMfj37ny3APpg1w+1mdi9XTiCk9R4m77IwiPZtL/WfBgIegis33NISC3o9NaVYVdodh1K/7Cyfya4lZbHv0SNHWnHIm2biDOwE5sX7xVfMBkGvOYHIA0FoILwBb2QdtxR/Nr4a4/4NTa5OqVqaRc/yWepRcX2pTjmLI+l/3yzEQ+OgnCBAyUL3yKvLqS6PZoWvEg7HraKvrnjzZA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773635713; c=relaxed/relaxed;
	bh=X/Ex+L90uGBTy9QCe1FBRoWX1zvmrETLBvk4ndfxp2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jjy0bUEgH4TU3TqrED/S+jUimSZ+91RvKfPRjMovOlGXaU06TXV7Uo7kEfAyeShUDPondMMHEVVrTuXnfWFqQMevifBvJRoVH1oEdocmVD8H3x6tpEv5+2syzhB8W/5vJhCcETPzYK5zP8LtiIUrhnB2nk48ChX71SUlOFpvNXVKrqfobkOHBjRNDQurDO8mjOEtix0aW7k5iCOex5STEMoH8xcJC3NzPGRgidqCksbpICM7xnY5hX1jpNjJ8s/D4ubuqPL39K+Exw+6fIUQr3T5rTyoXxGma7sJZQs03OsAQ9FaSB+LXenmUcNpgBhltO7g5oQ6Fq+q9uN9aPgFQw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rSvgMpRX; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rSvgMpRX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ2M26xPtz2xlP
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 15:35:08 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773635704; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=X/Ex+L90uGBTy9QCe1FBRoWX1zvmrETLBvk4ndfxp2Q=;
	b=rSvgMpRXs44ewyLD1MXgBNBOi+7tV8LE4JjfDflOmw22ZnYNmHI+8ohNp1+VD8TRgNNRYzpBHo8QWdqTg7KHRJXSZN4kq1kDGqfeNuvU1rXjd4WQYpUfRnpltStLiv/L74lpj3rp/qHUIztjk+EKmDYwv1mBafFLgKe11CRE3CQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.-ggdd_1773635703;
Received: from 30.221.132.167(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.-ggdd_1773635703 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 12:35:03 +0800
Message-ID: <2d26643a-6830-4667-81fe-2f03ea031f6d@linux.alibaba.com>
Date: Mon, 16 Mar 2026 12:35:02 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: fix potential NULL pointer dereference
 in docker_config.c
To: Sri Lasya <lasyaprathipati@gmail.com>, linux-erofs@lists.ozlabs.org,
 ChengyuZhu6 <hudson@cyzhu.com>
Cc: gaoxiang25@huawei.com
References: <20260315191422.1392-1-lasyaprathipati@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260315191422.1392-1-lasyaprathipati@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/16 03:14, Sri Lasya wrote:
> Signed-off-by: Sri Lasya <lasyaprathipati@gmail.com>
> ---
>   lib/remotes/docker_config.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/remotes/docker_config.c b/lib/remotes/docker_config.c
> index 00db1bb..b346ee8 100644
> --- a/lib/remotes/docker_config.c
> +++ b/lib/remotes/docker_config.c
> @@ -38,7 +38,6 @@ static char *docker_config_path(void)
>   {
>   	const char *dir;
>   	char *path = NULL;
> -
>   	dir = getenv("DOCKER_CONFIG");
>   	if (dir) {
>   		if (!*dir)
> @@ -203,6 +202,8 @@ int erofs_docker_config_lookup(const char *registry,
>   		}
>   
>   		entry = json_object_iter_peek_value(&it);
> +                if (!entry)
> +			continue;

The patch format is broken, also Chengyu could you review it?

Thanks,
Gao Xiang

>   		if (json_object_object_get_ex(entry, "auth", &auth_field)) {
>   			b64 = json_object_get_string(auth_field);
>   			if (b64 && *b64) {


