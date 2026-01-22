Return-Path: <linux-erofs+bounces-2186-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D320D3EE89
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 16:32:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxmnF0d6rz2yFm;
	Fri, 23 Jan 2026 03:32:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769099553;
	cv=none; b=DTtb1mKaviQXQqrJ2A9aj6+VVGtzlqjuG2bspi/dhRuq0CQfXSV1QHGorTJUHBdxC0LAR5REyO/bZsH8/epenPJD4jvdNL9soKDxer49UVT6kbahb8iKTsK+A3sLvqQUfAb5MmdGybJn/3ygWGklr7EX++6EHOvvn5+WGEauh622MppnUQ9ff2rCUKvZvh0+FuxAaNIrjn1Lu1XlCw4Cnzm2+m4rHTV9nM1OVojuay1d3YbROQbAyqCeEbKqoiQKyGZ8CQD2YoESwNJf1MdL055NWYnZ4fbEZSHsdzgig477PglZE35f874NPuhykTYjGUu98+K5WN0WKEu1xrq3GA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769099553; c=relaxed/relaxed;
	bh=WgGjCmtUlQAzHkuWKEX+aFWP3mMdaRSo1WEnDLfhUl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STBiTw+b/OTGZdJ9YAp3xV7dHhcZ/2iA8XWto4SepJaFooalFt16mcO5bx7vijm7wnbeTO0TawUuCabtG5T+j5N5YJ4qyVVAg0to2O0oreSg/n2scmQYB4EPr3JtkSrqOExCQp+xop9GKrdhIffQZ7OdvkgM+VkM9+2ZIRiYAq7rUne3sawiwsn/YpZloUn5k7IXmkR97Vym8c3zbxLysV5O5GPe2Z1Oy+HGHYd5si8AeXdyVvGsd1kzRgTJIv3IReedt3u+/zUOZQZ9SCy8KNx2L3ebO3HCcInwXYs7XURHpa3Deot8qOhgifBtyynByqBjOe42oQIvDhhHnTNPRQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=EabnteSq; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=EabnteSq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxmnC5NbMz2xl0
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 03:32:31 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769099546; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WgGjCmtUlQAzHkuWKEX+aFWP3mMdaRSo1WEnDLfhUl4=;
	b=EabnteSqjRMArOkJEy7qSQ8wS6ruoqavKYy8+H/RBvQcKYD6BGyrwbUFu5A7+vuaGP7QlnIFhW4RJmFTxCXpnIvpHvstO9/0vCCvbkwZSQj94vyKnY/BVmjRWxcb4Lnqqw17Pn4MJqZPWyaB0OoUiP0nBb/Mjlq4nU36LqMXLNI=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WxctV1L_1769099542 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 00:32:23 +0800
Message-ID: <ce900b69-edac-4d1a-8ba2-5d5dbad9ec02@linux.alibaba.com>
Date: Fri, 23 Jan 2026 00:32:22 +0800
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
Subject: Re: [PATCH v17 05/10] erofs: using domain_id in the safer way
To: Hongbo Li <lihongbo22@huawei.com>
Cc: hch@lst.de, djwong@kernel.org, amir73il@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, brauner@kernel.org
References: <20260122153406.660073-1-lihongbo22@huawei.com>
 <20260122153406.660073-6-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260122153406.660073-6-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/22 23:34, Hongbo Li wrote:
> Either the existing fscache usecase or the upcoming page
> cache sharing case, the `domain_id` should be protected as
> sensitive information, so we use the safer helpers to allocate,
> free and display domain_id.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   Documentation/filesystems/erofs.rst | 5 +++--
>   fs/erofs/fscache.c                  | 6 +++---
>   fs/erofs/super.c                    | 8 ++++----
>   3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> index 08194f194b94..40dbf3b6a35f 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -126,8 +126,9 @@ dax={always,never}     Use direct access (no page cache).  See
>   dax                    A legacy option which is an alias for ``dax=always``.
>   device=%s              Specify a path to an extra device to be used together.
>   fsid=%s                Specify a filesystem image ID for Fscache back-end.
> -domain_id=%s           Specify a domain ID in fscache mode so that different images
> -                       with the same blobs under a given domain ID can share storage.
> +domain_id=%s           Specify a trusted domain ID for fscache mode so that
> +                       different images with the same blobs, identified by blob IDs,
> +                       can share storage within the same trusted domain.
>   fsoffset=%llu          Specify block-aligned filesystem offset for the primary device.
>   ===================    =========================================================
>   
> diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
> index f4937b025038..cd7847fd2670 100644
> --- a/fs/erofs/fscache.c
> +++ b/fs/erofs/fscache.c
> @@ -379,7 +379,7 @@ static void erofs_fscache_domain_put(struct erofs_domain *domain)
>   		}
>   		fscache_relinquish_volume(domain->volume, NULL, false);
>   		mutex_unlock(&erofs_domain_list_lock);
> -		kfree(domain->domain_id);
> +		kfree_sensitive(domain->domain_id);
>   		kfree(domain);
>   		return;
>   	}
> @@ -407,7 +407,7 @@ static int erofs_fscache_register_volume(struct super_block *sb)
>   	}
>   
>   	sbi->volume = volume;
> -	kfree(name);
> +	domain_id ? kfree_sensitive(name) : kfree(name);

I really don't want to touch fscache anymore, and this line
should just use if else instead, but I can live with that.

>   	return ret;
>   }
>   
> @@ -446,7 +446,7 @@ static int erofs_fscache_init_domain(struct super_block *sb)
>   	sbi->domain = domain;
>   	return 0;
>   out:
> -	kfree(domain->domain_id);
> +	kfree_sensitive(domain->domain_id);
>   	kfree(domain);
>   	return err;
>   }
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index dca1445f6c92..6fbe9220303a 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -525,8 +525,8 @@ static int erofs_fc_parse_param(struct fs_context *fc,
>   			return -ENOMEM;
>   		break;
>   	case Opt_domain_id:
> -		kfree(sbi->domain_id);
> -		sbi->domain_id = kstrdup(param->string, GFP_KERNEL);
> +		kfree_sensitive(sbi->domain_id);
> +		sbi->domain_id = no_free_ptr(param->string);
>   		if (!sbi->domain_id)
>   			return -ENOMEM;

I don't think
```
		if (!sbi->domain_id)
			return -ENOMEM;
```
is needed anymore if no_free_ptr is used.

Otherwise it looks good to me:
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

