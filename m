Return-Path: <linux-erofs+bounces-2945-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E20EC01A0
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 07:55:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffQSx50ypz2yds;
	Mon, 23 Mar 2026 18:55:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774252529;
	cv=none; b=jQh5MTK2ZOn2fJfJvxV5tCvZOhN+9LeyQ5Df38YtckeufQkY1ep9NOOdkEtEqsdESvvNPkFmWlkqOKMJJEOFqoEcLoyBwfVAtTPNgpaNhToXkT6eDYeLEqg7nohiIfidtQlnpO0OSwChITVk7eVbb6PFJBJlkybISa3d00dRv+QhkTNGyHZgoNEzizlisIxW8bcFx3+zvN/oKndCFe/GPTbdR3GrWAlJXxuOqm9le0s/Dr0UquuJtJs3QEs6AWqMBIwGtFLeQ26F4vRDJ/Sq/bVxcG7ywdqkRf4Gwh/I1SOuw887PcEKgKIwDfMBc/KCppsjtQqP8BWvKoa6xICNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774252529; c=relaxed/relaxed;
	bh=Ln27PU6iTQhPj8tFQuQHGkfOiUwIVWgP9XLp448zqaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbpuKP80Nv0CzTTrOdQXiZnUpEBWjR4LeIP6vfWd0xN5dj8YPOvNeQtnTaLDsuqIcsKF0Bws2zjz8ma+qt2VQx6S9egQITvkN+P6pdj+9w7hjXgxL2rcGmoOGLx4YxkfTz7Bcw9z6T8PEDEz8bt5wrZDpeXRuIR2uDgONoUIQnuYBsMslQl+pp7+DOa1Tah0oFALJer8CR8liZaj+73TvwOyQo0G3VvjyO885mnZW9gRgCofU1L+DoV6oBH15iu/i24qltHzd4BztrQcih6LWRfHfUOc/M94ShhpGsURODk7/Te/qKvFwZD6lScH4sgWbf/k35BnF5uZdqLbVCxchA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Z0guAxiK; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Z0guAxiK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffQSw3d4Cz2yYy
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Mar 2026 18:55:27 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774252523; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ln27PU6iTQhPj8tFQuQHGkfOiUwIVWgP9XLp448zqaw=;
	b=Z0guAxiKm/Xml7V/hUzsHtwVqZdIrcRfn5ZWGlriPfRcyX5pwUSeQnWp4JK9IYHMs4oJonShbQ2L60AfePKFv4MJ9UuxjDx69lXZOMK+0s0eeFqAXwaUXOMoYNU5gnJR/9ESy1KWKQH2NE1TcR+qHU6Wt+qTJ0tNplUyMfdoH3g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X.UhD8J_1774252520;
Received: from 30.221.131.200(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.UhD8J_1774252520 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Mar 2026 15:55:21 +0800
Message-ID: <a53e8e57-c54e-4fdd-8738-7e423e6ca37b@linux.alibaba.com>
Date: Mon, 23 Mar 2026 15:55:19 +0800
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
Subject: Re: [PATCH 6.1 0/1] erofs: Fix the slab-out-of-bounds in
 drop_buffers()
To: Denis Arefev <arefev@swemel.ru>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20260323074809.4542-1-arefev@swemel.ru>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260323074809.4542-1-arefev@swemel.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Denis,

On 2026/3/23 15:48, Denis Arefev wrote:
> Syzbot reported that a KASAN slab-out-of-bounds bug was discovered in the drop_buffers()
> function [1].
> 
> The root cause is that erofs_raw_access_aops does not define .release_folio and
> .invalidate_folio. When using iomap-based operations, folio->private may contain
> iomap-specific data rather than buffer_heads. Without special handlers, the kernel
> may fall back to generic functions (e.g., drop_buffers), which incorrectly treat
> folio->private as a list of buffer_head structures, leading to incorrect memory
> interpretation and out-of-bounds access.
> 
> This can be fixed by explicitly setting .release_folio and .invalidate_folio to
> iomap_release_folio and iomap_invalidate_folio, respectively, but there is a
> commit ce529cc25b184e93397b94a8a322128fc0095cbb in upstream  that implicitly
> fixes this bug.

See my previous reply to the patch.

Thanks,
Gao Xiang

> 
> Please commit it to the stable branch v6.1.y .
> 
> [1] https://syzkaller.appspot.com/bug?id=c6aeabd0c4ad2466f63a274faf2a123103f8fbf7
> 
> Jingbo Xu (1):
>    erofs: enable large folios for iomap mode
> 
>   fs/erofs/data.c  | 2 ++
>   fs/erofs/inode.c | 2 ++
>   2 files changed, 4 insertions(+)
> 


