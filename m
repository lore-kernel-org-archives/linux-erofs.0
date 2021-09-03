Return-Path: <SRS0=hJpO=NZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88A2C433EF
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Sep 2021 03:06:39 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 16D0E60F92
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Sep 2021 03:06:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 16D0E60F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4H12kj4YBdz2yJj
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Sep 2021 13:06:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.43;
 helo=out30-43.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4H12kc0NSbz2xXS
 for <linux-erofs@lists.ozlabs.org>; Fri,  3 Sep 2021 13:06:26 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R981e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=7; SR=0; TI=SMTPD_---0Un3cJFF_1630638367; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Un3cJFF_1630638367) by smtp.aliyun-inc.com(127.0.0.1);
 Fri, 03 Sep 2021 11:06:08 +0800
Date: Fri, 3 Sep 2021 11:06:06 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Yue Hu <zbestahu@gmail.com>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH] erofs: remove the pagepool parameter from
 z_erofs_shifted_transform()
Message-ID: <YTGRHuRsVeiGM8Nq@B-P7TQMD6M-0146.local>
References: <20210831103204.881-1-zbestahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210831103204.881-1-zbestahu@gmail.com>
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
Cc: xiang@kernel.org, huyue2@yulong.com, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, zbestahu@163.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Yue,

On Tue, Aug 31, 2021 at 06:32:04PM +0800, Yue Hu wrote:
> From: Yue Hu <huyue2@yulong.com>
> 
> We don't use the pagepool for plain format, remove it.

In my LZMA patchset, I'll rearrange such interface to make LZMA
integration easier:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/?h=erofs/lzma&id=3fab9044a4fe9358e95e16780831640caf3de10b

This cleanup patch does no harm to that one, yet I think it has little
real impact (especially applying the patch above)... So I'd like to
hear Chao's suggestion about this as well. I'm fine in either ways.

(p.s. we are in 5.15 merge window, I will set up a new dev branch after
 -rc1 is out.)

Thanks,
Gao Xiang

> 
> Signed-off-by: Yue Hu <huyue2@yulong.com>
> ---
>  fs/erofs/decompressor.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
> index a5bc4b1..8f50a36 100644
> --- a/fs/erofs/decompressor.c
> +++ b/fs/erofs/decompressor.c
> @@ -360,8 +360,7 @@ static int z_erofs_decompress_generic(struct z_erofs_decompress_req *rq,
>  	return ret;
>  }
>  
> -static int z_erofs_shifted_transform(const struct z_erofs_decompress_req *rq,
> -				     struct list_head *pagepool)
> +static int z_erofs_shifted_transform(const struct z_erofs_decompress_req *rq)
>  {
>  	const unsigned int nrpages_out =
>  		PAGE_ALIGN(rq->pageofs_out + rq->outputsize) >> PAGE_SHIFT;
> @@ -403,6 +402,6 @@ int z_erofs_decompress(struct z_erofs_decompress_req *rq,
>  		       struct list_head *pagepool)
>  {
>  	if (rq->alg == Z_EROFS_COMPRESSION_SHIFTED)
> -		return z_erofs_shifted_transform(rq, pagepool);
> +		return z_erofs_shifted_transform(rq);
>  	return z_erofs_decompress_generic(rq, pagepool);
>  }
> -- 
> 1.9.1
