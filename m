Return-Path: <linux-erofs+bounces-2790-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC75F3382F
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 09:53:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZnMw6J5sz2yj1;
	Tue, 17 Mar 2026 20:53:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773741212;
	cv=none; b=foGU9ckS36vzKC2SK/Pr2u4ExjmGFeviKxPRTPKCBJ64+By8tYM8b4LpRqA5KX5T3lxz9DyvREtSDvyVFxp3SrKcC4EsgOWBI5xzK7WzUObW0zXIthZdSCShgd8RfLj7FXHqhz36IrxCf8nCmhDWAlo22jLcqGLcCD8eYOF1QDMTkqLN1EtAduvW61J1WiVO39UIWhy1cIdcPxoWxO2Mh5C4Z1yP5ip2S1PWEmcVwxm9Ggd4vVys1DhDl65D2jI/BpLZpM+7clelWcEiqJDauQAgLQ3uV4U/dHdT3vi/w9IB+6m1mMkzRhCZkB1fbHNrqSLlWh/yrQurkdNUeMCJow==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773741212; c=relaxed/relaxed;
	bh=e+tmqyzkN7pKNV1N1eAugyyzJhD2oPmoBMpel1ln5x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQcGTbMvtEX3cM8i64px2nmbj/fJTaHGGxKYmKsZkv4YDY0oADx+TrDnvZcrlHk7cMnSs8AFJvLQDmimfALzN7u2TyJsrDd0QelOFeDLC+xuNPDVp6OIG/zpA7X64DvV2zhz9/Y7M4aTCeV1JttM04IS0/WNGUn/BEIThOP17z8db899uZLxMqKeb58QzEZgJEhB+nvUfezuzwTzOI9MNNAaIosqzJR14fzH9YlJ+Axdwjpe+oWecl81lYjZg0mWX4j0yxrsvz7xNKUQmFAkMqYJ1FHvq489sgKHj3TegmecRlH116iFnA3MXkyYJod7M8jgBt1eq0WjsP7/PyZjLw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=I9m6GhE2; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=I9m6GhE2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZnMt6xFrz2yfP
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 20:53:29 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773741204; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e+tmqyzkN7pKNV1N1eAugyyzJhD2oPmoBMpel1ln5x4=;
	b=I9m6GhE2jQbclK8nyjbmH87ipqmr4BSdcLFx/AZ3GKDqZ8KAdqMqSoOX+seIGagKl2g5kYK4FmjlyHH5DiR8WzK0OOrfiDQdQucN0RvnME8Sk6meAtKYto20eHWWfZMnhoU+HnOp930/Ilxa3tWdDUKQ4J+0aPukhd+AOXlDU0o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.AcnW8_1773741203;
Received: from 30.221.133.143(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.AcnW8_1773741203 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 17:53:23 +0800
Message-ID: <a65ab6cb-3e98-433c-921c-fd0b7cc8c188@linux.alibaba.com>
Date: Tue, 17 Mar 2026 17:53:21 +0800
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
Subject: Re: [PATCH v2 1/2] erofs-utils: lib: validate ZSTD frame content size
 in decompression
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: yifan.yfzhao@foxmail.com
References: <20260317045537.9591-1-singhutkal015@gmail.com>
 <20260317045537.9591-2-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260317045537.9591-2-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/17 12:55, Utkal Singh wrote:
> ZSTD_getFrameContentSize() reads the content size from the ZSTD
> frame header in the compressed data. This is untrusted on-disk
> metadata, independent from the extent map that provides
> rq->decodedlength via z_erofs_map_blocks_iter().
> 
> A crafted EROFS image can set the extent map to claim a decoded
> length larger than the actual ZSTD frame content size. When this
> happens, a buffer of the (smaller) frame content size is allocated
> and decompressed into, but the subsequent memcpy copies
> rq->decodedlength bytes from it -- a potential out-of-bounds read.
> 
> Additionally, the ZSTD_getDecompressedSize() legacy fallback
> returns 0 for frames without a content size field. This leads to
> malloc(0) followed by out-of-bounds access on the returned pointer.
> 
> Reject frames where the reported content size is zero or smaller
> than the expected decoded length.
> 
> Reproducer:
>    mkdir testdir
>    python3 -c "open('testdir/f','wb').write(b'A'*131072)"
>    mkfs.erofs -zzstd test.erofs testdir/
>    python3 -c "d=bytearray(open('test.erofs','rb').read());\
>      p=d.find(b'\x28\xb5\x2f\xfd');d[p+4]=0x20;d[p+5]=0x01;\
>      open('test.erofs','wb').write(d)"
>    fsck.erofs --extract=out test.erofs
>    # Expected: ZSTD frame content size 1 < decoded length 131072
> 
> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
> ---
>   lib/decompress.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/lib/decompress.c b/lib/decompress.c
> index 3e7a173..fb81039 100644
> --- a/lib/decompress.c
> +++ b/lib/decompress.c
> @@ -48,7 +48,14 @@ static int z_erofs_decompress_zstd(struct z_erofs_decompress_req *rq)
>   #else
>   	total = ZSTD_getDecompressedSize(src + inputmargin,
>   					 rq->inputsize - inputmargin);
> +	if (!total)
> +		return -EFSCORRUPTED;

hmm, that is the difference between the kernel and erofs-utils
implementation.

the kernel uses zstd streaming APIs, so it won't malloc()
a new buffer in advance, actually I think erofs-utils should
switch to streaming APIs too, in order to avoid

ZSTD_getFrameContentSize() and ZSTD_getDecompressedSize()

dependencies as you said in the commit message.

Thanks,
Gao Xiang


