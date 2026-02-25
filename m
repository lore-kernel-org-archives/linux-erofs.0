Return-Path: <linux-erofs+bounces-2410-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DD6EFD20C
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Feb 2026 08:50:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLSwC5xlTz3dWY;
	Wed, 25 Feb 2026 19:50:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772009419;
	cv=none; b=OPRX2eUwrCjBYgGDLtBYyfjwW0VsWI9wkAFfxfpE9Mwt/a9BiJZNKoGhBNhaTVs4u6gJA4UZAH8bB4M7Wo1hfDDCCZcIdqPi9A0RmeGVTJQX7gB2WGorhwcXmcaJ3l6sKi3y8+CEWkIwe/JZalN713i3ADXEwm+WOn6Kr0esZzWdVo/OuHrOOP6dsHXKru20Jg5Sm5R98jBIK9nDpMragzQirfVR7sGuf7Eeiv9v1YIZjnXV/pX13qbAtmCHF6Tb5j5ASuym5dz0nca7Xp0TCauai1Ku0mnJK7THfT2LiOaG+Zr0nZH85kUDPDJYeT7YD3lOcTrebv1Ayztc4yzULA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772009419; c=relaxed/relaxed;
	bh=Egzg4FpZQX6U62tZxRord2ozCfj7bRK4GNMiwFL3EnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CuvChh5JUIb2uyOsT7dEHAhdY/klPHipkAjg3BwP5YC0x5xL0PC2B1/NmNVBx79QwhuUUKiClQGFLsbX8/RFpidWqGzVSvKW/YSHBSqLPduqYbLfOkJyuoD970UIhIp5zkDlDpUCdYUL5LtOO8z6mK9sUDE9Q9zdtF7UfuRkYhEYV3L8XdMQawH8/O5WB6Q6i+I/yhFU540aZ6qha5xWUkqQJ3BV8m0FRt0ODa8TUYSUIkdxBGxc5iHX+HWaNY+n/fTweqt2Sgi57HVZd+SXHA1UpzMv+fnBHIhk+EBiyPy70Fgbi8ucQTIofiv7ip4RQkBhUR8MxYRciXJGZRJVNQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=k2GN1JfI; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=k2GN1JfI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fLSw86MXjz3dWS
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Feb 2026 19:50:15 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772009409; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Egzg4FpZQX6U62tZxRord2ozCfj7bRK4GNMiwFL3EnA=;
	b=k2GN1JfIvirTI4n45YtEJr+/F0Kubev9eWYEW8756Qs/E6oXBsY8renJW6SdRC8ix3v8uQkyCjprR1hPy/c77pwFtHOxAQ8LkC/oMBJvZU4zefz8My9HWZ16n0xtMXe7dvVXGFsIB7PwtFAu8JJonBilpnBTa5PqwR2mo5K9FCM=
Received: from 30.221.131.204(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wzlx6Gc_1772009407 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Feb 2026 16:50:07 +0800
Message-ID: <9acfc376-f200-40a0-ab21-87b6221b3b31@linux.alibaba.com>
Date: Wed, 25 Feb 2026 16:50:05 +0800
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
Subject: Re: [PATCH] erofs-utils: dump: add missing compat features and
 separate feature display
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: jingrui@huawei.com, wayne.ma@huawei.com, zhukeqian1@huawei.com
References: <20260225084602.553324-1-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260225084602.553324-1-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/2/25 16:46, Yifan Zhao wrote:
> Add three missing EROFS_FEATURE_COMPAT_* entries to feature_lists:
> - EROFS_FEATURE_COMPAT_SHARED_EA_IN_METABOX
> - EROFS_FEATURE_COMPAT_PLAIN_XATTR_PFX
> - EROFS_FEATURE_COMPAT_ISHARE_XATTRS
> 
> Also separate the feature output into two lines:
> 'Filesystem features(compat)' and 'Filesystem features(incompat)'

`Filesystem features (compatible)` and
`Filesystem features (incompatible)` ?


> for better readability.
> 
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---
>   dump/main.c | 22 +++++++++++++++++-----
>   1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/dump/main.c b/dump/main.c
> index 8422bb9..1c4e8b2 100644
> --- a/dump/main.c
> +++ b/dump/main.c
> @@ -96,6 +96,9 @@ static struct erofsdump_feature feature_lists[] = {
>   	{  true,    0, EROFS_FEATURE_COMPAT_SB_CHKSUM, "sb_csum" },
>   	{  true,    0, EROFS_FEATURE_COMPAT_MTIME, "mtime" },
>   	{  true,    0, EROFS_FEATURE_COMPAT_XATTR_FILTER, "xattr_filter" },
> +	{  true,    0, EROFS_FEATURE_COMPAT_SHARED_EA_IN_METABOX, "shared_ea_in_metabox" },
> +	{  true,    0, EROFS_FEATURE_COMPAT_PLAIN_XATTR_PFX, "plain_xattr_pfx" },
> +	{  true,    0, EROFS_FEATURE_COMPAT_ISHARE_XATTRS, "ishare_xattrs" },
>   	{ false, 504U, EROFS_FEATURE_INCOMPAT_LZ4_0PADDING, "lz4_0padding" },
>   	{ false, 513U, EROFS_FEATURE_INCOMPAT_COMPR_CFGS, "compr_cfgs" },
>   	{ false, 513U, EROFS_FEATURE_INCOMPAT_BIG_PCLUSTER, "big_pcluster" },
> @@ -675,12 +678,21 @@ static void erofsdump_show_superblock(void)
>   			g_sbi.inos | 0ULL);
>   	fprintf(stdout, "Filesystem created:                           %s",
>   			ctime(&time));
> -	fprintf(stdout, "Filesystem features:                          ");
> +	fprintf(stdout, "Filesystem features(compat):                  ");

Same here.

>   	for (i = 0; i < ARRAY_SIZE(feature_lists); i++) {
> -		u32 feat = le32_to_cpu(feature_lists[i].compat ?
> -				       g_sbi.feature_compat :
> -				       g_sbi.feature_incompat);
> -		if (feat & feature_lists[i].flag) {
> +		if (!feature_lists[i].compat)
> +			continue;
> +		if (le32_to_cpu(g_sbi.feature_compat) & feature_lists[i].flag) {
> +			fprintf(stdout, "%s ", feature_lists[i].name);
> +			if (feature_lists[i].lkver > minkver)
> +				minkver = feature_lists[i].lkver;
> +		}
> +	}
> +	fprintf(stdout, "\nFilesystem features(incompat):                ");

Same here.

Thanks,
Gao Xiang

