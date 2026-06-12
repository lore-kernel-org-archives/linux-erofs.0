Return-Path: <linux-erofs+bounces-3577-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA01CD98D6
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Jun 2026 06:55:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gc9Hp1vcSz2yd7;
	Fri, 12 Jun 2026 16:55:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781247302;
	cv=none; b=dwV5iQmL4MLOG3nWDskCGR8pcMwA2WfKu8saNKrnGvw9wuZXE6Cu0IcouhXHVBi27gEHhARBwkh3AYQiJvFe33g2yXLmefDoufbGeaqcNyTxXK38+SHBjM3b5b+b/WTo19ItSLNFA7JK8iffk1i/2Mo9qoQqt3dqVJVOHg+khpY3LkIisYYKSbcqEJ5HaN9L7fAq9zLoOqIM1CsZ3noyR3c7B4GRzye8VrNfPcVMJNfZy7wCfrN+Algd/7EV0OOEWJo8SatEiEAlHgYGZ8SPThKv0/3i7qukrkaFm6LnmZRXKKJWVBQyXSmpNfwnG9wmIav4cz+Y2iXKSdiBK6Bg5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781247302; c=relaxed/relaxed;
	bh=ZphKWwyl+WGH86LGIXqyFlQlvne4chYGQBsEKFLt2d0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZOfNHG1hXpfZ6DJNmZczpMrUyJnv21Vqml6caRBnESa+GjIsKkhMfN/SHHGctBD01aoFQBJTQata3LJd6G2E4gg4xufoASUiIGJJzwauuPq30vODbsNt8vnsheSW73kn6Trl9baO73HjPUeMAhA2uJFnH4eGyH/voTyypN2BSJWVOFDf8s3c3qwSTbY5P9Ux8NCY3OT9p8v/OXwqF5NRtezVuqF2ZAOCh8du7DNjAXhlud6YFB+EuDoo1COMgA7WHi/RExFqxtMZfuU6cXkFZ8FhcuAqu1W6aSONF2MmhQzPM3SaC63b19SKTSyaqBhAUm8TeKv9dmlWaCn2zW3FpA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=awYE8laJ; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=awYE8laJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gc9Hk6fhDz2xYg
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Jun 2026 16:54:56 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781247290; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZphKWwyl+WGH86LGIXqyFlQlvne4chYGQBsEKFLt2d0=;
	b=awYE8laJBdJHsDUe2+05LE6v4NQJGcAFtpWASdY2b5jZxz/bgPfVfjzq6dNuowdiy6GmRDDmC80nJIVQnr+urtRZR1uaPcQkM/7u38jNPFULiPGmU7pZmTb1J7Iredxn4VbLzMF/92dXtiEqEmnPnqbXSKzz+crLuj9vdKfrErQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X4hpKI3_1781247288;
Received: from 30.221.132.172(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4hpKI3_1781247288 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 14:54:48 +0800
Message-ID: <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
Date: Fri, 12 Jun 2026 14:54:47 +0800
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
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
To: Christoph Hellwig <hch@infradead.org>
Cc: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, yekelu1@huawei.com, jingrui@huawei.com,
 zhukeqian1@huawei.com, Ritesh Harjani <ritesh.list@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <aiumQL8LEWQX_Nag@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 2026/6/12 14:25, Christoph Hellwig wrote:
> On Fri, Jun 12, 2026 at 11:42:38AM +0800, Gao Xiang wrote:
>>> Reported-by: Kelu Ye <yekelu1@huawei.com>
>>> Assisted-by: Codex:GPT-5.5
>>> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
>>
>> I think it's an iomap bug instead, see:
>>
>> iomap_bio_read_folio_range(), we should fix iomap instead.
> 
> Yes.  iomap should not try to build bios over iomap boundaries.
> caused various issues.  Ritesh ran into that with the ext2 port
> back in the day, and I actually ran into it again with an under
> development xfs feature.
> 
> Can you try this patch?

hmm, currently erofs could return block-sized iomap (if the chunk
size is 4k) even it can be merged with the following chunks.

Previously it was fairly good since consecutive chunks will be
added to the current bio if possible, but after this patch,
there will be a lot of 4k bios.

But if iomap goes into this way, I could make iomap_begin maps
more chunks in one shot, but that needs more changes in erofs,
it's fine anyway.

... I was thinking the following diff (space-damaged):

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 4504f4633f17..241df96a16a6 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -142,6 +142,7 @@ int iomap_bio_read_folio_range(const struct iomap_iter *iter,

         if (!bio ||
             bio_end_sector(bio) != iomap_sector(&iter->iomap, iter->pos) ||
+           bio->bi_bdev != iter->iomap.bdev ||
             bio->bi_iter.bi_size > iomap_max_bio_size(&iter->iomap) - plen ||
             !bio_add_folio(bio, folio, plen, offset_in_folio(folio, iter->pos)))
                 iomap_read_alloc_bio(iter, ctx, plen);


but either way works fine with me since it's an iomap design
stuff.

Thanks,
Gao Xiang

> 
> ---
>  From 297230cc3c08cbfef3670b08c4e35813c18c523e Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Sun, 7 Jun 2026 08:53:20 +0200
> Subject: iomap: submit read bio after each extent
> 
> This keeps bios from crossing RTG boundaries in XFS and probably fixes
> all kinds of other stuff..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/iomap/buffered-io.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d55b936e6986..3642a11c102f 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -597,12 +597,13 @@ void iomap_read_folio(const struct iomap_ops *ops,
>   
>   	trace_iomap_readpage(iter.inode, 1);
>   
> -	while ((ret = iomap_iter(&iter, ops)) > 0)
> +	while ((ret = iomap_iter(&iter, ops)) > 0) {
>   		iter.status = iomap_read_folio_iter(&iter, ctx,
>   				&bytes_submitted);
> -
> -	if (ctx->read_ctx && ctx->ops->submit_read)
> -		ctx->ops->submit_read(&iter, ctx);
> +		if (ctx->read_ctx && ctx->ops->submit_read)
> +			ctx->ops->submit_read(&iter, ctx);
> +		ctx->read_ctx = NULL;
> +	}
>   
>   	if (ctx->cur_folio)
>   		iomap_read_end(ctx->cur_folio, bytes_submitted);
> @@ -664,12 +665,13 @@ void iomap_readahead(const struct iomap_ops *ops,
>   
>   	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
>   
> -	while (iomap_iter(&iter, ops) > 0)
> +	while (iomap_iter(&iter, ops) > 0) {
>   		iter.status = iomap_readahead_iter(&iter, ctx,
>   					&cur_bytes_submitted);
> -
> -	if (ctx->read_ctx && ctx->ops->submit_read)
> -		ctx->ops->submit_read(&iter, ctx);
> +		if (ctx->read_ctx && ctx->ops->submit_read)
> +			ctx->ops->submit_read(&iter, ctx);
> +		ctx->read_ctx = NULL;
> +	}
>   
>   	if (ctx->cur_folio)
>   		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);


