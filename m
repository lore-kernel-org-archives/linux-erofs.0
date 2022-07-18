Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E13C43334
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Jul 2022 11:36:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Lmg0L3R2cz3bbQ
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Jul 2022 21:36:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=47.90.199.11; helo=out199-11.us.a.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out199-11.us.a.mail.aliyun.com (out199-11.us.a.mail.aliyun.com [47.90.199.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Lmg0F3l6Gz3050
	for <linux-erofs@lists.ozlabs.org>; Mon, 18 Jul 2022 21:36:26 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VJjf4Le_1658144174;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VJjf4Le_1658144174)
          by smtp.aliyun-inc.com;
          Mon, 18 Jul 2022 19:36:16 +0800
Date: Mon, 18 Jul 2022 19:36:14 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] erofs: clean up a loop
Message-ID: <YtVFrpFdaR2Iwf2x@B-P7TQMD6M-0146.local>
References: <YtVB6GBWHVSc6fbU@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtVB6GBWHVSc6fbU@kili>
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
Cc: kernel-janitors@vger.kernel.org, Yue Hu <huyue2@coolpad.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Dan,

On Mon, Jul 18, 2022 at 02:20:08PM +0300, Dan Carpenter wrote:
> It's easier to see what this loop is doing when the decrement is in
> the normal place.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/erofs/zdata.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 601cfcb07c50..2691100eb231 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -419,8 +419,8 @@ static bool z_erofs_try_inplace_io(struct z_erofs_decompress_frontend *fe,
>  {
>  	struct z_erofs_pcluster *const pcl = fe->pcl;
>  
> -	while (fe->icur > 0) {
> -		if (!cmpxchg(&pcl->compressed_bvecs[--fe->icur].page,
> +	while (fe->icur--) {

Thanks for your patch!
Yet at a quick glance, on my side, that doesn't equal
to be honest...

.. What we're trying to do here is to find a free slot
for inplace i/o, but also need to leave fe->icur as 0
when going out the loop since z_erofs_try_inplace_io()
can be called again the next time when attaching
another page but it will overflow then...

Thanks,
Gao Xiang

> +		if (!cmpxchg(&pcl->compressed_bvecs[fe->icur].page,
>  			     NULL, bvec->page)) {
>  			pcl->compressed_bvecs[fe->icur] = *bvec;
>  			return true;
> -- 
> 2.35.1
