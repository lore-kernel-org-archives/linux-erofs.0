Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561FCC77B61
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Apr 2023 04:27:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Pxml359tKz3fCk
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Apr 2023 14:27:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Pxmkz5pWbz3c71
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Apr 2023 14:27:22 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VfzAfT2_1681360036;
Received: from 30.221.133.131(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VfzAfT2_1681360036)
          by smtp.aliyun-inc.com;
          Thu, 13 Apr 2023 12:27:17 +0800
Message-ID: <c12b5de6-9591-56ba-85e6-e6292aece7bd@linux.alibaba.com>
Date: Thu, 13 Apr 2023 12:27:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] erofs: explicit cast blkaddr to u64 before shift
 operation
Content-Language: en-US
To: Jia Zhu <zhujia.zj@bytedance.com>, linux-erofs@lists.ozlabs.org
References: <20230413035734.15457-1-zhujia.zj@bytedance.com>
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <20230413035734.15457-1-zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8
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
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 4/13/23 11:57 AM, Jia Zhu wrote:
> We should explicitly cast @blkaddr from u32 to u64 before the shift
> operation to return the larger type.
> 
> Fixes: b1c2d99b18ff ("erofs: avoid hardcoded blocksize for subpage block support")
> Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
> ---
>  fs/erofs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index aa7f9e4f86fb..6fe9a779fa91 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -35,7 +35,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_blk_t blkaddr,
>  		  enum erofs_kmap_type type)
>  {
>  	struct inode *inode = buf->inode;
> -	erofs_off_t offset = blkaddr << inode->i_blkbits;
> +	erofs_off_t offset = (erofs_off_t)blkaddr << inode->i_blkbits;
>  	pgoff_t index = offset >> PAGE_SHIFT;
>  	struct page *page = buf->page;
>  	struct folio *folio;

LGTM. Thanks for catching this.

Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>

-- 
Thanks,
Jingbo
