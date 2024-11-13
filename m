Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B92D597DC
	for <linux-erofs@archiver.kernel.org>; Wed, 13 Nov 2024 03:42:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Xp8Ht6938z2yhG
	for <linux-erofs@archiver.kernel.org>; Wed, 13 Nov 2024 14:42:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731469369;
	cv=none; b=GrcEGXjVbXgXUtxONGvN0YuRSnlhA0OZK7wsc63e4jdCY8HSsPM0xdg938OKYvQBilt1rQG9QIJydeeMqa/S7VexeUpncK3eTJUUVVycZOqX0lEBbJu/DpvG2KNiD4bXHzQLMF8tr/rlS3VH6Io6B8vCY/6yJ2OtbneUdNdPVQiZhNyT3Qu+316AaabTSMeBEz3USPWxLfpULgl7c5L53YkaDT8beqKgOhh4IB29b4WwVsfG7uytOQ1UOSsx3JQizajZYE/ADqv+gYl7ppfxLMO2YUYYAv+Qwdod66b1belzI82OWFSRVl7gpKwq10JDm0KJ52du8IImiht3d/fg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731469369; c=relaxed/relaxed;
	bh=DLNQlGqphkgHJqVTPy96g2sXHQpFwdRU64zTO215OIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OsKnnUPNHCpF9s1/rm2Z9jH1Ir3kLa49+WiWRYBnnFSjF+cgO5tpTzkUSWEbOUT7SLRBtG6FCKry5J9xXp5DpZQDh8ddRwrFeyu5oBYoK3qN+lnt245IyCuO4qj4y7uDM6oqxPGXvX3L/188fw/95KPjTJCiIoatvT5MXKDRSXeOoNF3fMw/OxxGHuJeSm60RK0VO2GswXQUOVCwyz8WS41lBxlJsO0lvwEIgxSruswEQbC7RjNrHS54BfUvvJjNG7Rxnofk6L/RxXPjgz6KiV6PjxgH0FJNxhX5yNXVM39cumDGpowQeL1FnyqScgFkHttVsQgnLKe9hea+uTJI/A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oDNZBJ9s; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oDNZBJ9s;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Xp8Hj0GzNz2xks
	for <linux-erofs@lists.ozlabs.org>; Wed, 13 Nov 2024 14:42:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731469349; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DLNQlGqphkgHJqVTPy96g2sXHQpFwdRU64zTO215OIM=;
	b=oDNZBJ9spJySUDtDQdeIamWrz9+QAda2j/wGvLAT8us5uvur96n+UbJNZnBpge3RqSWUecKJDH87WIHwBnPvFGdiLlym9UeeizWDGqZeBZTZwPhghixjf1ycBtkmKp6xUmEKA1MTTWlFtR+wOaJucBTSq6W1x/bvYN2yRfUatuo=
Received: from 30.221.129.12(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WJJVINE_1731469346 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 13 Nov 2024 11:42:27 +0800
Message-ID: <ecfb4f83-e78c-40f6-803c-554edf7928b2@linux.alibaba.com>
Date: Wed, 13 Nov 2024 11:42:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: simplify definition of the log functions
To: Gou Hao <gouhao@uniontech.com>, xiang@kernel.org, chao@kernel.org
References: <20241018033500.13833-1-gouhao@uniontech.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241018033500.13833-1-gouhao@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: gouhaojake@163.com, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Hao,

Sorry for late response due to my long vacation.

On 2024/10/18 11:35, Gou Hao wrote:
> using printk instead of pr_info/err, reduce
> redundant code.

Use printk instead of pr_info/err to reduce
redundant code.

> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> ---
>   fs/erofs/internal.h |  9 ++++-----
>   fs/erofs/super.c    | 28 +++++++---------------------
>   2 files changed, 11 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 4efd578d7c62..ae87e855e815 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -24,14 +24,13 @@
>   #undef pr_fmt
>   #define pr_fmt(fmt) "erofs: " fmt
>   
> -__printf(3, 4) void _erofs_err(struct super_block *sb,
> +__printf(3, 4) void _erofs_printk(struct super_block *sb,
>   			       const char *function, const char *fmt, ...);
>   #define erofs_err(sb, fmt, ...)	\
> -	_erofs_err(sb, __func__, fmt "\n", ##__VA_ARGS__)
> -__printf(3, 4) void _erofs_info(struct super_block *sb,
> -			       const char *function, const char *fmt, ...);
> +	_erofs_printk(sb, __func__, KERN_ERR fmt "\n", ##__VA_ARGS__)
>   #define erofs_info(sb, fmt, ...) \
> -	_erofs_info(sb, __func__, fmt "\n", ##__VA_ARGS__)
> +	_erofs_printk(sb, __func__, KERN_INFO fmt "\n", ##__VA_ARGS__)
> +
>   #ifdef CONFIG_EROFS_FS_DEBUG
>   #define DBG_BUGON               BUG_ON
>   #else
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 666873f745da..64c3258ddf9a 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -18,37 +18,23 @@
>   
>   static struct kmem_cache *erofs_inode_cachep __read_mostly;
>   
> -void _erofs_err(struct super_block *sb, const char *func, const char *fmt, ...)
> +void _erofs_printk(struct super_block *sb, const char *func, const char *fmt, ...)
>   {
>   	struct va_format vaf;
>   	va_list args;
> +	int level;
>   
>   	va_start(args, fmt);
>   
> -	vaf.fmt = fmt;
> +	level = printk_get_level(fmt);
> +	vaf.fmt = printk_skip_level(fmt);
>   	vaf.va = &args;

Let's get rid of `const char *func,` for all cases
since I think it's not very helpful indeed.

Thanks,
Gao Xiang
