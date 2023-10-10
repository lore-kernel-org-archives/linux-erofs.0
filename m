Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF88CD68E4
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Oct 2023 03:51:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4S4MQH54Ckz3c5F
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Oct 2023 14:51:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4S4MQB1sSmz2yh5
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Oct 2023 14:51:12 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VtrE3AS_1696909862;
Received: from 30.97.48.248(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VtrE3AS_1696909862)
          by smtp.aliyun-inc.com;
          Tue, 10 Oct 2023 11:51:05 +0800
Message-ID: <f7fc636a-76fa-aeb2-c258-7f7d8c79e1e1@linux.alibaba.com>
Date: Tue, 10 Oct 2023 11:51:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v10] erofs-utils: add support for fuse 2/3 lowlevel API
To: Li Yiyan <lyy0627@sjtu.edu.cn>, linux-erofs@lists.ozlabs.org
References: <20230918090306.2524624-1-lyy0627@sjtu.edu.cn>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20230918090306.2524624-1-lyy0627@sjtu.edu.cn>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2023/9/18 17:03, Li Yiyan wrote:
> Support FUSE low-level APIs for erofsfuse. Lowlevel APIs offer improved
> performance compared to the previous high-level APIs, while maintaining
> compatibility with libfuse version 2(>=2.6) and 3 (>=3.0).
> 
> Dataset: linux 5.15
> Compression algorithm: lz4hc,12
> Additional options: -T0 -C16384
> Test options: --warmup 3 -p "echo 3 > /proc/sys/vm/drop_caches; sleep 1"
> 
> Evaluation result (highlevel->lowlevel avg time):
> 	- Sequence metadata: 777.3 ms->180.9 ms
> 	- Sequence data: 3.282 s->818.1 ms
> 	- Random metadata: 1.571 s->928.3 ms
> 	- Random data: 2.461 s->597.8 ms
> 
> Signed-off-by: Li Yiyan <lyy0627@sjtu.edu.cn>

Looks good to me, applied to -experimental now.

...

>   
>   static void usage(void)
>   {
> -	struct fuse_args args = FUSE_ARGS_INIT(0, NULL);
> +#if FUSE_MAJOR_VERSION >= 3
> +	fuse_lowlevel_version();
> +#endif
> +	fprintf(stderr, "erofsfuse version: %s\n\n", cfg.c_version);
>   
>   	fputs("usage: [options] IMAGE MOUNTPOINT\n\n"
>   	      "Options:\n"
> @@ -220,12 +546,15 @@ static void usage(void)
>   	      "    --device=#             specify an extra device to be used together\n"
>   #if FUSE_MAJOR_VERSION < 3
>   	      "    --help                 display this help and exit\n"
> +	      "    --version              display erofsfuse version\n"
>   #endif
>   	      "\n", stderr);
>   
>   #if FUSE_MAJOR_VERSION >= 3
> +	fputs("\nFUSE options:\n", stderr);
>   	fuse_cmdline_help();
>   #else
> +	struct fuse_args args = FUSE_ARGS_INIT(0, NULL);

It's not a good idea to mix definitions and the rest code.
I will fix manually.

Thanks,
Gao Xiang
