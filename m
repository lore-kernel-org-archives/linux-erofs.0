Return-Path: <linux-erofs+bounces-3209-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9189FB5189
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Apr 2026 03:22:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fqWjJ2Nt0z2ydq;
	Tue, 07 Apr 2026 13:22:44 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775532164;
	cv=none; b=hx8yqwWd/LMWKayetB0/OPy+CwPbxiTD8kDulvtgoJtzUF7qFlUnC+cwhQzpanKcjvGEo2Kq/Sfn6vk/lYnXjJqZerz5IQmykVCC/Q/GOsJ2xS7PkJ203nWlSkdk3+fx1/PxU28I9oYOJluKKVUhkhyJKxd+zlx8TlCi1SIZgEG7pbKBOj2QAAeO9RqoYRKcnMoWnkyet4wutswy16bYG5GIwh6hYGjEESOS5DIQgsVCHkufVgFqTxvdT84MRlsJUDPwQPmGDs3gQKbjWH6X+f5yrKtjnmsgUTlCoaljDPZLtzQ76YABRqw7rxbCZvW6Xam6cU2o47dJT0LCbFpYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775532164; c=relaxed/relaxed;
	bh=yhCqghI0Du32l+1wAANoBjHt+8rq/oA4YAk/bnlJREI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BB7f/SrzTE/+tusY/v++mRScRbQPgNuNMQSz4MeY9CMCoCdHv0l5+r99dibayFwlaosjBfpXEDiRIg9IWjaawkuNe9Ya7BAy5bpxM7DcATtC40oJ48M8eC2gttm09UpJyM89Sn7azasp8tbjkoEE9gtn3++DrlBC8eu6XSKxr6pusvq0r+c5y1k9mtWFeLUL3uwOc8Od04FghsiuODsN6qbl0jxxM70KpetnEJFVI1ajGSqxL5v+gPlzFGpZ6B+nrexMti9Di9g8wwgQb4DurenG3gvAFL1Ye6ATKDl0dXBfekchsp//bP9uC8DE4mpcN6UEIArVQYV4qFrYGEtGSg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=k6AOK993; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=k6AOK993;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fqWjF5Pjfz2xQs
	for <linux-erofs@lists.ozlabs.org>; Tue, 07 Apr 2026 13:22:39 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775532155; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yhCqghI0Du32l+1wAANoBjHt+8rq/oA4YAk/bnlJREI=;
	b=k6AOK993/lCSHo+JHqPbgF8q5BMGM/vw5GSbTyxAFXDVKXHUzQ0T+xq2MbPGQXgwWcf3dxJFGabYhNRbSIvkFd6Sy+NI9kDTAVX7k9JjT+StvPMMO/g+J2XTYluYTJUgSAYSdJWVPq4lY6UXoPP/MzgViO7iyYvF7T7c9jOyFWM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X0aH6Ti_1775532154;
Received: from 30.221.130.92(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0aH6Ti_1775532154 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 11:22:34 +0800
Message-ID: <9e0696c4-95ff-4365-aced-2f67c7f08c85@linux.alibaba.com>
Date: Tue, 7 Apr 2026 11:22:34 +0800
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
Subject: Re: [PATCH erofs-utils v2 2/2] erofs-utils: handle 48-bit
 blocks/uniaddr for extra devices
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, Zhan Xusheng <zhanxusheng@xiaomi.com>
References: <12b129db-0206-44f3-a53c-9eec6fe3fda3@linux.alibaba.com>
 <20260403130546.76579-1-zhanxusheng@xiaomi.com>
 <20260403130546.76579-3-zhanxusheng@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260403130546.76579-3-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/3 21:05, Zhan Xusheng wrote:
> erofs_write_device_table() only writes blocks_lo and uniaddr_lo to
> the on-disk device slot, but does not write blocks_hi or uniaddr_hi.
> Similarly, erofs_init_devices() only reads the _lo fields for extra
> devices.
> 
> For extra devices whose blocks or uniaddr exceed 32 bits in a 48-bit
> EROFS image, the upper bits are silently lost in both read and write
> paths.  This is inconsistent with the primary device handling, which
> correctly writes blocks_hi (super.c:231) and reads it (super.c:125).
> 
> Also sync the erofs_deviceslot on-disk definition with the kernel:
> blocks_hi should be __le16 (not __le32), matching the 48-bit design
> where all block address high parts are 16-bit.
> 
> A corresponding kernel fix has been applied:
>    ("erofs: handle 48-bit blocks/uniaddr for extra devices")
> 
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
>   include/erofs_fs.h |  4 ++--
>   lib/super.c        | 10 ++++++++--
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/erofs_fs.h b/include/erofs_fs.h
> index ff8ac78..5d12049 100644
> --- a/include/erofs_fs.h
> +++ b/include/erofs_fs.h
> @@ -45,9 +45,9 @@ struct erofs_deviceslot {
>   	u8 tag[64];		/* digest(sha256), etc. */
>   	__le32 blocks_lo;	/* total blocks count of this device */
>   	__le32 uniaddr_lo;	/* unified starting block of this device */
> -	__le32 blocks_hi;	/* total blocks count MSB */
> +	__le16 blocks_hi;	/* total blocks count MSB */
>   	__le16 uniaddr_hi;	/* unified starting block MSB */
> -	u8 reserved[50];
> +	u8 reserved[52];
>   };
>   #define EROFS_DEVT_SLOT_SIZE	sizeof(struct erofs_deviceslot)
>   
> diff --git a/lib/super.c b/lib/super.c
> index 86d50a1..fd7972c 100644
> --- a/lib/super.c
> +++ b/lib/super.c
> @@ -54,6 +54,8 @@ static int erofs_init_devices(struct erofs_sb_info *sbi,
>   	if (!sbi->devs)
>   		return -ENOMEM;
>   	pos = le16_to_cpu(dsb->devt_slotoff) * EROFS_DEVT_SLOT_SIZE;
> +	bool _48bit = erofs_sb_has_48bit(sbi);

It should be refined with the variable definitions.

I will manually fix it up instead.

Thanks,
Gao Xiang

