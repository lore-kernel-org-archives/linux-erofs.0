Return-Path: <linux-erofs+bounces-4258-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA40C5DF82
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 09:53:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQdzv4pYxz2xRx;
	Thu, 20 Aug 2026 19:53:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787219611;
	cv=none; b=D8cuKWOj1kyx6sQWOQzbHAfsqzhG0OKqKaJC2DeNuYFOEsQwuWDBw6S5kgx3wSw2w38se50X0LcRM1N4HyoYHWixe2j/emhmMTgFu8aPOB64wjms+xB8LFg5pcRUmXIdB8h53qxkJMumBYI/nkW+sSgj4GTozo4R2LDSlV7bdtF3NAEgPmvKzX3Yxi27jznymLsbmGEZsuMZgY0jmJzu4bvvoysQ1CJNsqjD3v0d02oLB2wqUmzspsaA/XQtOtUaeLV8ZS+LkCUTxDgeXiNsmCxFX3jQRO0GH/P0QGyqSCJtn8ixTP7+MeCavhWcrU+DDXpixHw36bM7kR44P3Rmww==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787219611; c=relaxed/relaxed;
	bh=krhkCUV/huoczaV3l16hDfp/ZVJBovEFX5MspQM9s5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AVS5ZwSLuw8orxJH3YfgGB04r8VOozFXm2PVGI6vlgFz5ioregZae3dWTdcfSbgN2ZwCWiATc1usmy1iUnnstp0o/8byyuE5pErWCC96g/8A/N77GV/7y5aQHiHj9YQ3Hqo6DzpSoYUU4EXHiO7rcsGStp0uCyXLJw0cn5FHPue4nDBJeAVnDP8JtVhcdDXUZqktqbg7Gb2EUZWZ1L2rGItjq0by0FmMZzW21179Jwq2k9Idkv8vPknaBMVRP0vBeyMqczyRf2gS6x0QDSjv1d9FDGyVCzGb08B3sn67uJ1r2ncUVu+a9z4MKvO/VYkjhWxBpfy9dDmhLVufbBGtwA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=W2MvZ6FY; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=W2MvZ6FY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQdzs2v7sz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 19:53:27 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787219602; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=krhkCUV/huoczaV3l16hDfp/ZVJBovEFX5MspQM9s5o=;
	b=W2MvZ6FYTMGy6ifLusOVlvv8z3HTQmF/NBQbMTc/WvdbenJBRdDZE8lq2zzB6Kuadn3bVZnf+GsxamoD6aG/Jaw392BpTNNtIbudxsv6LA5+SXZoqmqTp922m3308FZZQsQsFHyo2fo7KV8y0HW30JnCVyeCf/xL/GBJLVgk+v8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9J7cYn_1787219600;
Received: from 30.221.151.40(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9J7cYn_1787219600 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 17:53:21 +0800
Message-ID: <3d735f18-2d26-4b4c-be68-b000742e9826@linux.alibaba.com>
Date: Thu, 20 Aug 2026 17:53:20 +0800
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
Subject: Re: [PATCH] erofs: use the shared page cache for splice in
 inode_share mode
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>
Cc: zhanxusheng@xiaomi.com, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260820064441.1083470-1-zhanxusheng@xiaomi.com>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <20260820064441.1083470-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/26 2:44 PM, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng1024@gmail.com>
> 
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> erofs_ishare_fops routes everything that touches the page cache to the
> backing file in ->private_data: read_iter clones the iocb onto it, mmap
> does vma_set_file(), fadvise calls vfs_fadvise() on it.  splice_read was
> left as filemap_splice_read(), which works on the user file's own mapping.
> 
> filemap_splice_read() does init_sync_kiocb(&iocb, in), and
> filemap_get_pages() then takes iocb->ki_filp->f_mapping, so splice() and
> sendfile() populate the per-file page cache from disk instead of using the
> shared one.  The data is correct, since erofs_fill_inode() sets that
> mapping's a_ops either way, but the same content ends up cached twice,
> which is what inode_share is there to avoid.
> 
> Pass the backing file, as read_iter already does.
> 
> Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
> Link: https://lore.kernel.org/all/b7dc7192-d586-45a2-bc4a-b41dc681c9bb@linux.alibaba.com/
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
>  fs/erofs/ishare.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
> index fa7d4112dec5..01dc53e9e3ad 100644
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -148,6 +148,13 @@ static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *vma)
>  	return generic_file_readonly_mmap(file, vma);
>  }
>  
> +static ssize_t erofs_ishare_splice_read(struct file *in, loff_t *ppos,
> +					struct pipe_inode_info *pipe,
> +					size_t len, unsigned int flags)
> +{
> +	return filemap_splice_read(in->private_data, ppos, pipe, len, flags);

Please refer to backing_file_splice_read() called from
ovl_splice_read(), file_accessed() needs to be called on the original
file (just as what .read_iter() i.e. filemap_read() does), and the input
@ppos needs to be updated accordingly.


-- 
Thanks,
Jingbo


