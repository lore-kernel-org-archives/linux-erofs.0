Return-Path: <linux-erofs+bounces-1510-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A56D68BD1
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Dec 2025 03:26:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dWwzp6LKZz2xpg;
	Thu, 18 Dec 2025 14:25:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1766028358;
	cv=none; b=PTaiL4s4kTuaKSnrQUDIRMzpxyVMAcStTVYwMQmcJIOEWkhyKTJwI23mIW6oY0/7hRlN5xzlKNS1sVrxjwpLMufmPjpxxzewei8bK3R44GxiNIq2T40cWrWUUBwl5jWFCp8su2BXHtjdLhmGXlohjx3toLxFcKjR8KTYemxlCw3PGlUhXCjJoYSiXq4nOnkK1KriOvlzpBzldEQfNWk1coATTAiAtbds14KMZWlPVNFL4iamiENtloh/Er0VtulMAPV77pC6QTofnpnmc0HPwVxOGRfXSyPEij0j95yFMXDbmjmpjgESchjTZ39kJjLUK271jrxgW+XuJIFB7VpxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1766028358; c=relaxed/relaxed;
	bh=O2r5K3ClHRUcn8V5Kxk4ANKDK0yNYHHVTlS6HFPGZOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UFeMXp8untWjvrhyiogrUE0Vz7tAOVOFG2TmjTP9lBXpXGKXjNa09FlzpW1+SGOR8D0RRc7OgXd8CnC6P5tsYHZskwbk6CpvrmUxP80r0XWXKH5GNqmj1BDPOY2mcPPPH5Vp9EipvkQU8Y0BJlPrVCXJZdaLnNsiiBt8ZjiSdnNEZ0yW9wVN+rTvPhlSn3hheGYnWYrjM6vVC0xM0ezM/g4gdRfjjDBnsWB3F9vyPuTh3Dhv272X4yrmyTdbprWD0lpB9kwu36zRhT5cvirV7zidLzMOhMj8G6dOswpG9Ou6ovv77yjWIzGIC9410x6MGVhrmyXQnxweT91eDbWTeA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UiJamXC0; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UiJamXC0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dWwzm1TQlz2xDD
	for <linux-erofs@lists.ozlabs.org>; Thu, 18 Dec 2025 14:25:54 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766028347; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O2r5K3ClHRUcn8V5Kxk4ANKDK0yNYHHVTlS6HFPGZOM=;
	b=UiJamXC00dCoy8BAAVn824/UqEHn8661spi+mF7pJpm7npKkbqLrkw3po+1p2pannqFwlp0ib2nGgesOBHoH8dANtE25dI+6ZV51Tf8Ot0/EUxmhlRxC2PBuVkFInV3GSep/9eRSs3gjtIjw+hKjv7dR6sE3YIKICXfxjtXl400=
Received: from 30.221.132.6(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wv6mXj5_1766028346 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 11:25:46 +0800
Message-ID: <ac302644-023e-46e1-ad8f-075410db0d6a@linux.alibaba.com>
Date: Thu, 18 Dec 2025 11:25:45 +0800
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
Subject: Re: [PATCH] erofs: print the names of unsupported compression
 algorithms
To: Yuwen Chen <ywen.chen@foxmail.com>, xiang@kernel.org
Cc: chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <tencent_D4F8982BC9797B5EE01759574F512CF7E506@qq.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <tencent_D4F8982BC9797B5EE01759574F512CF7E506@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/12/18 11:18, Yuwen Chen wrote:
> After simplifying the implementation of z_erofs_parse_cfgs, the
> names of unsupported algorithms can now be directly output.
> Moreover, some unnecessary additional judgments can be removed.
> 
> Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>

It seems that you're working on outdated codebase.

There is no erofs_decompressors at all.

Thanks,
Gao Xiang

> ---
>   fs/erofs/decompressor.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
> index be1e19b620523..866bd9158615b 100644
> --- a/fs/erofs/decompressor.c
> +++ b/fs/erofs/decompressor.c
> @@ -385,21 +385,22 @@ const struct z_erofs_decompressor erofs_decompressors[] = {
>   		.decompress = z_erofs_lz4_decompress,
>   		.name = "lz4"
>   	},
> -#ifdef CONFIG_EROFS_FS_ZIP_LZMA
>   	[Z_EROFS_COMPRESSION_LZMA] = {
> +#ifdef CONFIG_EROFS_FS_ZIP_LZMA
>   		.config = z_erofs_load_lzma_config,
>   		.decompress = z_erofs_lzma_decompress,
> +#endif
>   		.name = "lzma"
>   	},
> -#endif
> -#ifdef CONFIG_EROFS_FS_ZIP_DEFLATE
>   	[Z_EROFS_COMPRESSION_DEFLATE] = {
> +#ifdef CONFIG_EROFS_FS_ZIP_DEFLATE
>   		.config = z_erofs_load_deflate_config,
>   		.decompress = z_erofs_deflate_decompress,
> +#endif
>   		.name = "deflate"
>   	},
> -#endif
>   };
> +static_assert(Z_EROFS_COMPRESSION_RUNTIME_MAX == ARRAY_SIZE(erofs_decompressors));
>   
>   int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb)
>   {
> @@ -433,10 +434,9 @@ int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb)
>   			break;
>   		}
>   
> -		if (alg >= ARRAY_SIZE(erofs_decompressors) ||
> -		    !erofs_decompressors[alg].config) {
> -			erofs_err(sb, "algorithm %ld isn't enabled on this kernel",
> -				  alg);
> +		if (!erofs_decompressors[alg].config) {
> +			erofs_err(sb, "algorithm %s isn't enabled on this kernel",
> +				  erofs_decompressors[alg].name);
>   			ret = -EOPNOTSUPP;



>   		} else {
>   			ret = erofs_decompressors[alg].config(sb,


