Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD53C67861
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Apr 2024 10:35:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VClpq4kgGz3dWc
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Apr 2024 20:35:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sjtu.edu.cn (client-ip=202.120.2.232; helo=smtp232.sjtu.edu.cn; envelope-from=zhaoyifan@sjtu.edu.cn; receiver=lists.ozlabs.org)
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VClpl03rhz3cRB
	for <linux-erofs@lists.ozlabs.org>; Mon,  8 Apr 2024 20:35:08 +1000 (AEST)
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 5977C10091735;
	Mon,  8 Apr 2024 18:35:01 +0800 (CST)
Received: from [192.168.25.134] (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 60D0337C96D;
	Mon,  8 Apr 2024 18:34:56 +0800 (CST)
Message-ID: <c12daa04-c41d-4b6b-acce-26bd885f142c@sjtu.edu.cn>
Date: Mon, 8 Apr 2024 18:34:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: change temporal buffer to non static
To: Noboru Asai <asai@sijam.com>
References: <20240408091627.336554-1-asai@sijam.com>
Content-Language: en-US
From: Yifan Zhao <zhaoyifan@sjtu.edu.cn>
In-Reply-To: <20240408091627.336554-1-asai@sijam.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Noboru,


AFAIK, this `tryrecompress_trailing` is only used when `may_inline` is 
true, indicating that

this segment is the last one in the file. In the current inner-file 
implementation, it means

that only one worker will use the `tmp` buffer at a given time.


In fact, the `static` modifier is removed in the first version of the 
patchset, but the change

is reversed during the review. I think Xiang may share his opinion about 
this.


Thanks,

Yifan Zhao

On 4/8/24 5:16 PM, Noboru Asai wrote:
> In multi-threaded mode, each thread must use a different buffer in tryrecompress_trailing
> function, so change this buffer to non static.
>
> Signed-off-by: Noboru Asai <asai@sijam.com>
> ---
>   lib/compress.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/compress.c b/lib/compress.c
> index 641fde6..7415fda 100644
> --- a/lib/compress.c
> +++ b/lib/compress.c
> @@ -447,7 +447,7 @@ static void tryrecompress_trailing(struct z_erofs_compress_sctx *ctx,
>   				   void *out, unsigned int *compressedsize)
>   {
>   	struct erofs_sb_info *sbi = ctx->ictx->inode->sbi;
> -	static char tmp[Z_EROFS_PCLUSTER_MAX_SIZE];
> +	char tmp[Z_EROFS_PCLUSTER_MAX_SIZE];
>   	unsigned int count;
>   	int ret = *compressedsize;
>   
