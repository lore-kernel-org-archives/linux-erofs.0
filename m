Return-Path: <linux-erofs+bounces-3711-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAF4CDB46B
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 08:36:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkM4d2XVzz2yXj;
	Mon, 22 Jun 2026 18:36:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782117409;
	cv=none; b=jht1h20t5T+YiOub/6lp4iHTzd8Dct+hEZS5yBigRCmOZV8eskQEZFjxV1wRITaIGK2tmmcdMpv5wC7leaMkzK562ieT8woUkprN6CwnRT3XhB89+Pn/jmBmA/6eXXF1KR3KkNq3CYurKw9f2VsoT+3/fojXyspfnb7TePmdXzB6/Ov5AHEZBX8ugPbwIvwwXfqB/Nxvueu7HncNXnpIOW5VRuHZLLppqovW95cpX9uKXy7WhvYwce+Ljjbfxsi222B9Zokk8U9APcDRJavpYX9SD+6qDlqkrCT3JKGONScY89V6x914C5kmGL5mUBb6Ls6qQE/qAZJr3h5xl+bsFw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782117409; c=relaxed/relaxed;
	bh=7BH7itEF3mRjlqM+FpQ6A2AOLeIQy2CEWqh5t3jQ15k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iaXyvtqYivWSOSt7295Xb0iFVCfYVfd/EKTyXUCt10JXAU4nSOVY32UJ6fSH7Fedin5GMX9AZ/4yXvfapSQPuciDdFkPVAulHYK8Cx5WFhOHJT/tL1kP1d/u8ZRQqVIyISK3dOBqDOgrbU9smrvY+PKp8ufaC/Wr9NdICCNoFdXyUp+t13hawmBX3SyOKgBISHrkw31nn9gdJED7MtUQijmtF/1SZ8tphbkhVE5rWGhA6k+3frIwrT4c7sF+2453uInRftVUz01fX6ilEGqeeBnjVQp0k4aa0PNezjTlob0PCp4GQEEjpTspNH/M9JPaB1xEA/ARXdeTp0LAHwnRRw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tYuoYRRl; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tYuoYRRl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkM4Z2h8Pz2yVd
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 18:36:45 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782117400; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7BH7itEF3mRjlqM+FpQ6A2AOLeIQy2CEWqh5t3jQ15k=;
	b=tYuoYRRlS+5vIei6/972VRLGRyi51bTnOILEiAHLLnblMJlckqJ+U5WDFwgJxhoml98yhj/RvcrqjhX/hG0FNhSE1FHD4qUY3VNl3hk4SVpJ7nGpJoC529ZSMvzDAFW+wx4VCFiISAyZPQlVMTUao7X0jAh2Sj6d/kmX17X5nlY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X5KMEH2_1782117398;
Received: from 30.221.130.114(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5KMEH2_1782117398 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 16:36:39 +0800
Message-ID: <c3f19333-780f-455a-8714-191d1b694a21@linux.alibaba.com>
Date: Mon, 22 Jun 2026 16:36:38 +0800
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
Subject: Re: [PATCH v2] erofs: handle 48-bit blocks_hi for compressed inodes
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Zhan Xusheng <zhanxusheng@xiaomi.com>
References: <5cccd50c-cb18-4fb3-bce0-77bed389d00f@linux.alibaba.com>
 <20260622081136.2953243-1-zhanxusheng@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260622081136.2953243-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/22 16:11, Zhan Xusheng wrote:
> Combine i_nb.blocks_hi with i_u.blocks_lo when computing
> inode->i_blocks for compressed inodes, mirroring the startblk_hi
> handling for unencoded inodes a few lines above.  Also evaluate
> the shift in u64 to avoid truncation.
> 
> Fixes: efb2aef569b3 ("erofs: add encoded extent on-disk definition")
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
> v2:
>   - Fix the Fixes: tag to efb2aef569b3 ("erofs: add encoded extent
>     on-disk definition"), the commit that introduced blocks_hi for
>     compressed inodes (Gao Xiang)
>   - Reorder to "blocks_lo | (blocks_hi << 32)" with explicit parentheses
>     and shorter lines (Gao Xiang)
> 
>   fs/erofs/inode.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> index a188c570087a..dc0e3d6bb2b1 100644
> --- a/fs/erofs/inode.c
> +++ b/fs/erofs/inode.c
> @@ -191,8 +191,9 @@ static int erofs_read_inode(struct inode *inode)
>   		err = -EFSCORRUPTED;
>   		goto err_out;
>   	} else {
> -		inode->i_blocks = le32_to_cpu(copied.i_u.blocks_lo) <<
> -				(sb->s_blocksize_bits - 9);
> +		inode->i_blocks = (le32_to_cpu(copied.i_u.blocks_lo) |
> +				   ((u64)le16_to_cpu(copied.i_nb.blocks_hi) << 32)) <<

I will change this line to
			((u64)le16_to_cpu(copied.i_nb.blocks_hi) << 32)) <<

to avoid overly long lines (since such alignment is not strictly necessary
but overly long lines should be avoided), otherwise it looks good to me,

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

