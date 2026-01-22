Return-Path: <linux-erofs+bounces-2154-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4424CD3EE69
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 13:54:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxjGq6wLNz2yFm;
	Fri, 23 Jan 2026 00:54:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769090067;
	cv=none; b=DTP8D7/yt5oV7fRlqShoUdKnRk7jkRQPlT25YwFoMY3PTK9sSjiDyoiTYYVrz6KZbPpxchTBuYx0JeWPsNAy/QpkZ7NynRHGTbknIgGT5YzIKZ4+pXyA8M+qvQAG50vH/oceBJCbr3JJCxT52FSrGiMopKdfy1M8pc+Q5VMmfMATMw83cqRTDYLHhyldYv9YlN4o4O17mDcgvkcQtAWn9VVrTih7zVfmTIuJChTjbqHV1wmK75A4Yu6aZv6bF7BDPWCqsFqfpPsMV6P3Nwxh53jAGwngR8Vum5bKZFQ6YRRRe0QLsYI1cKD22IvOwz8rKPwvTGtJvKKbZR4s50CdJA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769090067; c=relaxed/relaxed;
	bh=iH69wCFur78VdAz+L0r8AsGzLUkhYCtsKfI7hLzfOAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GN2mDf1EiMzQUHXdTNQn6TAIbUChfeg1lmCZeoVMPp541nWK8OTfR0fpkx5YoVRerlBOxCSiDfyPZJxj0jSftseP8/NOlHCPu6XtN7iclyf8WQSB7rGd2DJFZSrOOw4FydYbC0b/hE/wdUBOLbLeb6f7rbwQRrm8U9KYaRAS+AhuC7zw1hgBln1zU26eT7iUGYFq9xMJiskIjUTQwhfDZwri2M9nlg0WLddeteIcxQwhOLDRsIIyIfUuaaBQh4dKjFdBihE1G+SbRi1Pz7m0s24zTnlKeO0cIIcmuSF23otrp8t7L+dTkQHsKfXEl6i9Cb1d8VXAuFskqwJFkTcI4A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Bhrt0bGx; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Bhrt0bGx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxjGm5HM0z2xl0
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 00:54:23 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769090058; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iH69wCFur78VdAz+L0r8AsGzLUkhYCtsKfI7hLzfOAk=;
	b=Bhrt0bGx4CxJgloHg4SMvdg442jtv5A7Qh2twMwmaViwKmPau4hdIJLHyOiz5nmxc2/Evwfqa7HwCgoeIg2tz14ZnN+CDY1KWVYP0E5ehxvXc3TzJQND+shE4kN9VN3eRVERt4MX6FSMVZediMeF0xoh+2NppCZN0Vt/ONLraP4=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WxcZzn2_1769090056 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Jan 2026 21:54:17 +0800
Message-ID: <b20b263d-132b-464e-8314-d3f795e5e582@linux.alibaba.com>
Date: Thu, 22 Jan 2026 21:54:15 +0800
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
Subject: Re: [PATCH v16 04/10] erofs: add erofs_inode_set_aops helper to set
 the aops.
To: Hongbo Li <lihongbo22@huawei.com>, chao@kernel.org, brauner@kernel.org
Cc: hch@lst.de, djwong@kernel.org, amir73il@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260122133718.658056-1-lihongbo22@huawei.com>
 <20260122133718.658056-5-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260122133718.658056-5-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/22 21:37, Hongbo Li wrote:
> Add erofs_inode_set_aops helper to set the inode->i_mapping->a_ops,
> and using IS_ENABLED to make it cleaner.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/erofs/inode.c    | 23 +----------------------
>   fs/erofs/internal.h | 23 +++++++++++++++++++++++
>   2 files changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> index bce98c845a18..389632bb46c4 100644
> --- a/fs/erofs/inode.c
> +++ b/fs/erofs/inode.c
> @@ -235,28 +235,7 @@ static int erofs_fill_inode(struct inode *inode)
>   	}
>   
>   	mapping_set_large_folios(inode->i_mapping);
> -	if (erofs_inode_is_data_compressed(vi->datalayout)) {
> -#ifdef CONFIG_EROFS_FS_ZIP
> -		DO_ONCE_LITE_IF(inode->i_blkbits != PAGE_SHIFT,
> -			  erofs_info, inode->i_sb,
> -			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
> -		inode->i_mapping->a_ops = &z_erofs_aops;
> -#else
> -		err = -EOPNOTSUPP;
> -#endif
> -	} else {
> -		inode->i_mapping->a_ops = &erofs_aops;
> -#ifdef CONFIG_EROFS_FS_ONDEMAND
> -		if (erofs_is_fscache_mode(inode->i_sb))
> -			inode->i_mapping->a_ops = &erofs_fscache_access_aops;
> -#endif
> -#ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
> -		if (erofs_is_fileio_mode(EROFS_SB(inode->i_sb)))
> -			inode->i_mapping->a_ops = &erofs_fileio_aops;
> -#endif
> -	}
> -
> -	return err;
> +	return erofs_inode_set_aops(inode, inode, false);
>   }
>   
>   /*
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index ec79e8b44d3b..8e28c2fa8735 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -455,6 +455,29 @@ static inline void *erofs_vm_map_ram(struct page **pages, unsigned int count)
>   	return NULL;
>   }
>   
> +static inline int erofs_inode_set_aops(struct inode *inode,
> +				       struct inode *realinode, bool no_fscache)
> +{
> +	if (erofs_inode_is_data_compressed(EROFS_I(realinode)->datalayout)) {
> +		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
> +			return -EOPNOTSUPP;
> +		DO_ONCE_LITE_IF(realinode->i_blkbits != PAGE_SHIFT,
> +			  erofs_info, realinode->i_sb,
> +			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
> +		inode->i_mapping->a_ops = &z_erofs_aops;

Is that available if CONFIG_EROFS_FS_ZIP is undefined?

> +		return 0;
> +	}
> +	inode->i_mapping->a_ops = &erofs_aops;
> +	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND)) {
> +		if (!no_fscache && erofs_is_fscache_mode(realinode->i_sb))
> +			inode->i_mapping->a_ops = &erofs_fscache_access_aops;
> +	} else {

I really don't think they are equal, could you just move
the code without any change?

Thanks,
Gao Xiang
> +		if (erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
> +			inode->i_mapping->a_ops = &erofs_fileio_aops;
> +	}
> +	return 0;
> +}
> +
>   int erofs_register_sysfs(struct super_block *sb);
>   void erofs_unregister_sysfs(struct super_block *sb);
>   int __init erofs_init_sysfs(void);


