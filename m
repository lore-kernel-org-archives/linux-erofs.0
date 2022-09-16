Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C2DECAAD3
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Sep 2022 03:19:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MTK6q3PW9z3blF
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Sep 2022 13:19:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.44; helo=out30-44.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MTK6j63J5z2yQg
	for <linux-erofs@lists.ozlabs.org>; Fri, 16 Sep 2022 13:19:07 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VPvGrTJ_1663298342;
Received: from 30.221.130.67(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VPvGrTJ_1663298342)
          by smtp.aliyun-inc.com;
          Fri, 16 Sep 2022 11:19:03 +0800
Message-ID: <6a716712-4a82-32d7-ddcd-3252f69c6454@linux.alibaba.com>
Date: Fri, 16 Sep 2022 11:19:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH V4 4/6] erofs: introduce a pseudo mnt to manage shared
 cookies
Content-Language: en-US
To: Jia Zhu <zhujia.zj@bytedance.com>, linux-erofs@lists.ozlabs.org
References: <20220915124213.25767-1-zhujia.zj@bytedance.com>
 <20220915124213.25767-5-zhujia.zj@bytedance.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <20220915124213.25767-5-zhujia.zj@bytedance.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 9/15/22 8:42 PM, Jia Zhu wrote:

>  static int erofs_init_fs_context(struct fs_context *fc)
>  {
> -	struct erofs_fs_context *ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	struct erofs_fs_context *ctx;
> +

We'd better add a simple comment here:

+	/* pseudo mount for anon inodes */
> +	if (fc->sb_flags & SB_KERNMOUNT) {
> +		fc->ops = &erofs_anon_context_ops;
> +		return 0;
> +	}

which will be more friendly to those not familiar with the background.

>  
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>  	if (!ctx)
>  		return -ENOMEM;
>  	ctx->devs = kzalloc(sizeof(struct erofs_dev_context), GFP_KERNEL);
> @@ -874,6 +896,11 @@ static void erofs_kill_sb(struct super_block *sb)
>  
>  	WARN_ON(sb->s_magic != EROFS_SUPER_MAGIC);
>  
> +	if (sb->s_flags & SB_KERNMOUNT) {
> +		kill_litter_super(sb);

I think kill_anon_super() is enough. At least in our case, there's only
one root dentry inside the anon super and thus d_genocide() is actually
a noop.


Otherwise LGTM.
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>


-- 
Thanks,
Jingbo
