Return-Path: <linux-erofs+bounces-3466-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED23CD4F3D
	for <linux-erofs@archiver.kernel.org>; Wed, 20 May 2026 04:25:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gKz433d8Fz2xy3;
	Wed, 20 May 2026 14:25:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779251139;
	cv=none; b=cNkYffmL0OAdJDwPENVMR6H+V5A5aAKoRmWYPIE1G/MfKH2KHXxWRjTpRDEJmMg34YjpEj9IYO0Zij/5YTNkV8Tik8XxPKQ53ezeqdxI1//Z/+g+6bb/Ycicm2TM3QftEWwH2NN1HMCCYZExuzPiURHs6rnKirWb4ZnlknN14BStpHLnzr6DLW6VMJX6yj7WnxgC20Ia/7yeJaY2k2fude+QHovcaq2lUikF6D8npOIDUAyf1NAYrqym6FyCubH9NNJhgHKRDpQuxpZwj/8Tw6XTnLY40WaHEQSeHB7dYm70c1H7cczl3oUzKICiCCxkQI2k3GhM8mZcnWNCmjbu/w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779251139; c=relaxed/relaxed;
	bh=vBprvAeKPUGahtI2gP0STxTFpen0ySDLXfvesc2LssI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikyB3LkfaeQBnBo94tDzuVVxK8cDGlA4VMJfRmTZI75SPUMJQoruC40Fqh2HJ6qZ2LQAJ8uwul7WI56rgCHvIsmzjuc4DbQQE+IbzwgEai7AIDSb/h6JYzh5Mz+ybcBHmSDDo2b6aF2uT1xAGH7/2jPg7sao8HgOsO7YrAm67lRZGf8Egy4Xo9p8trql6kxo44ZwxzljmAhEZivmJE5G+3WG2TDkZ0K9wzzHxFCuDGalrPYdUjKNFuNwOSXFdRFu+756WCYr22d9GG6KPRuSBgFzdP6OEwVtxc2BJfGKA3bnQJ/14DTb+FxmkryyqLiTgFQ6o1iPdmjngRTOM+lw/Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XjM9fgOS; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XjM9fgOS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gKz4174Q2z2xrC
	for <linux-erofs@lists.ozlabs.org>; Wed, 20 May 2026 14:25:36 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779251132; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vBprvAeKPUGahtI2gP0STxTFpen0ySDLXfvesc2LssI=;
	b=XjM9fgOSOLD+UBXdwt0LJ4IOR6fgEJ320pYoUsNXo4P91OISyZyn/APoKmcGoQ92Jcl4Q3KE0zVO1p5cUEpYKkHB2QBtIrs9Dl4lwtkCWB4asUV0Js96Vp16Dube7+InElXnX3NwfngKAIyZrV0dhaSQTHElv8JxKz825yKsd5c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X3HHeIg_1779251129;
Received: from 30.221.132.121(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X3HHeIg_1779251129 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 May 2026 12:25:30 +0800
Message-ID: <d6707821-fe25-4331-94bf-c0c3936c8d1f@linux.alibaba.com>
Date: Wed, 20 May 2026 12:25:28 +0800
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
Subject: Re: [PATCH] erofs: fix metabuf leak in shared xattr initialization
To: Jia Zhu <zhujia.zj@bytedance.com>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Amir Goldstein <amir73il@gmail.com>
References: <20260520034252.40163-1-zhujia.zj@bytedance.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260520034252.40163-1-zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jia,

On 2026/5/20 11:42, Jia Zhu wrote:
> erofs_init_inode_xattrs() uses a local metabuf while reading the inline
> xattr header and the shared xattr id array.
> 
> It currently drops that metabuf from some error paths and from the success
> path, but the erofs_bread() failure while reading the shared xattr id array
> goes straight to out_unlock.
> 
> This became observable when file-backed metadata reads started calling
> rw_verify_area() before reusing or dropping the current metabuf.  Before
> that, the read_mapping_folio() failure path already dropped the old metabuf
> before returning an error.
> 
> Consolidate the local metabuf cleanup at out_unlock. erofs_put_metabuf()
> is a no-op if no page has been acquired, and this keeps all paths after
> taking EROFS_I_BL_XATTR_BIT covered by one cleanup site.
> 
> Fixes: 307210c262a2 ("erofs: verify metadata accesses for file-backed mounts")


Hmm, I don't think it's a correct "Fixes:", and
the commit message should be fixed too.

I think it's an issue due to missing erofs_put_metabuf()
in the erofs_init_inode_xattrs() error path instead.

I think
Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")

is a more proper "Fixes:".

Thanks,
Gao Xiang

> Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
> ---
>   fs/erofs/xattr.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
> index 41e311019a251..df7ea019526d7 100644
> --- a/fs/erofs/xattr.c
> +++ b/fs/erofs/xattr.c
> @@ -89,13 +89,11 @@ static int erofs_init_inode_xattrs(struct inode *inode)
>   	    vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) {
>   		erofs_err(sb, "invalid h_shared_count %u @ nid %llu",
>   			  vi->xattr_shared_count, vi->nid);
> -		erofs_put_metabuf(&buf);
>   		ret = -EFSCORRUPTED;
>   		goto out_unlock;
>   	}
>   	vi->xattr_shared_xattrs = kmalloc_objs(uint, vi->xattr_shared_count);
>   	if (!vi->xattr_shared_xattrs) {
> -		erofs_put_metabuf(&buf);
>   		ret = -ENOMEM;
>   		goto out_unlock;
>   	}
> @@ -112,12 +110,12 @@ static int erofs_init_inode_xattrs(struct inode *inode)
>   		}
>   		vi->xattr_shared_xattrs[i] = le32_to_cpu(*xattr_id);
>   	}
> -	erofs_put_metabuf(&buf);
>   
>   	/* paired with smp_mb() at the beginning of the function. */
>   	smp_mb();
>   	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
>   out_unlock:
> +	erofs_put_metabuf(&buf);
>   	clear_and_wake_up_bit(EROFS_I_BL_XATTR_BIT, &vi->flags);
>   	return ret;
>   }


