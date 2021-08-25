Return-Path: <SRS0=qATq=NQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB30C4338F
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Aug 2021 07:26:18 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F3DC8611C9
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Aug 2021 07:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F3DC8611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GvcwS58bkz2yM0
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Aug 2021 17:26:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130;
 helo=out30-130.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-130.freemail.mail.aliyun.com
 (out30-130.freemail.mail.aliyun.com [115.124.30.130])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GvcwG2FYYz2yHq
 for <linux-erofs@lists.ozlabs.org>; Wed, 25 Aug 2021 17:26:03 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R471e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=alimailimapcm10staff010182156082;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0Ull5o8F_1629876352; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Ull5o8F_1629876352) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 25 Aug 2021 15:25:54 +0800
Date: Wed, 25 Aug 2021 15:25:52 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Huang Jianan <huangjianan@oppo.com>
Subject: Re: [PATCH] AOSP: erofs-utils: increase val for WITH_ANDROID option
Message-ID: <YSXwgCND2Zf0sfl2@B-P7TQMD6M-0146.local>
References: <20210825033416.19868-1-huangjianan@oppo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210825033416.19868-1-huangjianan@oppo.com>
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
Cc: yh@oppo.com, kevin.liw@oppo.com, guoweichao@oppo.com,
 linux-erofs@lists.ozlabs.org, guanyuwei@oppo.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Jianan,

On Wed, Aug 25, 2021 at 11:34:16AM +0800, Huang Jianan via Linux-erofs wrote:

Subject: AOSP: erofs-utils: increase val for AOSP-specific long options

> Signed-off-by: Huang Jianan <huangjianan@oppo.com>
> ---
>  mkfs/main.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 10fe14d..9369b72 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -45,10 +45,10 @@ static struct option long_options[] = {
>  #endif
>  	{"max-extent-bytes", required_argument, NULL, 9},
>  #ifdef WITH_ANDROID
> -	{"mount-point", required_argument, NULL, 10},
> -	{"product-out", required_argument, NULL, 11},
> -	{"fs-config-file", required_argument, NULL, 12},
> -	{"block-list-file", required_argument, NULL, 13},
> +	{"mount-point", required_argument, NULL, 256},
> +	{"product-out", required_argument, NULL, 257},
> +	{"fs-config-file", required_argument, NULL, 258},
> +	{"block-list-file", required_argument, NULL, 259},
>  #endif
>  	{0, 0, 0, 0},
>  };
> @@ -289,20 +289,20 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
>  			}
>  			break;
>  #ifdef WITH_ANDROID
> -		case 10:
> +		case 256:

How about using larger numbers such as 512 for AOSP-specific options?
I'm afraid in the future we might bump up generic options to >= 256
like this as well.

Otherwise looks good to me.

Thanks,
Gao Xiang
