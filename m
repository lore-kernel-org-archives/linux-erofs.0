Return-Path: <SRS0=qATq=NQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E39C4338F
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Aug 2021 01:23:26 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2547060F25
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Aug 2021 01:23:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2547060F25
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GvSsm5mWkz2yKM
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Aug 2021 11:23:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131;
 helo=out30-131.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-131.freemail.mail.aliyun.com
 (out30-131.freemail.mail.aliyun.com [115.124.30.131])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GvSsj1BqMz2xlC
 for <linux-erofs@lists.ozlabs.org>; Wed, 25 Aug 2021 11:23:20 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R581e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=6; SR=0; TI=SMTPD_---0Ulfa9nB_1629854589; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Ulfa9nB_1629854589) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 25 Aug 2021 09:23:11 +0800
Date: Wed, 25 Aug 2021 09:23:08 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Huang Jianan <jnhuang95@gmail.com>
Subject: Re: [PATCH v2 0/3] fs/erofs: new filesystem
Message-ID: <YSWbfDiAbSNmZw1B@B-P7TQMD6M-0146.local>
References: <20210822154843.10971-1-jnhuang95@gmail.com>
 <20210823123646.9765-1-jnhuang95@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210823123646.9765-1-jnhuang95@gmail.com>
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
Cc: u-boot@lists.denx.de, xiang@kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi U-Boot folks, 

On Mon, Aug 23, 2021 at 08:36:43PM +0800, Huang Jianan wrote:
> From: Huang Jianan <huangjianan@oppo.com>
> 
> Add erofs filesystem support.
> 
> The code is adapted from erofs-utils in order to reduce maintenance
> burden and keep with the latest feature.
> 
> Changes since v1:
>  - fix the inconsistency between From and SoB (Bin Meng);
>  - add missing license header;
> 
> Huang Jianan (3):
>   fs/erofs: add erofs filesystem support
>   fs/erofs: add lz4 1.8.3 decompressor
>   fs/erofs: add lz4 decompression support

Could someone take some time looking into this? I think adding erofs
support to U-Boot is useful for booting with erofs. And keep sync
with erofsfuse code in erofs-utils is a good strategy for latest
feature.

Thanks in advance.

Thanks,
Gao Xiang

> 
>  fs/Kconfig            |   1 +
>  fs/Makefile           |   1 +
>  fs/erofs/Kconfig      |  12 +
>  fs/erofs/Makefile     |  10 +
>  fs/erofs/data.c       | 206 ++++++++++++++++
>  fs/erofs/decompress.c |  74 ++++++
>  fs/erofs/decompress.h |  29 +++
>  fs/erofs/erofs_fs.h   | 384 ++++++++++++++++++++++++++++++
>  fs/erofs/fs.c         | 231 ++++++++++++++++++
>  fs/erofs/internal.h   | 203 ++++++++++++++++
>  fs/erofs/lz4.c        | 534 ++++++++++++++++++++++++++++++++++++++++++
>  fs/erofs/lz4.h        |   5 +
>  fs/erofs/namei.c      | 238 +++++++++++++++++++
>  fs/erofs/super.c      |  65 +++++
>  fs/erofs/zmap.c       | 517 ++++++++++++++++++++++++++++++++++++++++
>  fs/fs.c               |  22 ++
>  include/erofs.h       |  19 ++
>  include/fs.h          |   1 +
>  18 files changed, 2552 insertions(+)
>  create mode 100644 fs/erofs/Kconfig
>  create mode 100644 fs/erofs/Makefile
>  create mode 100644 fs/erofs/data.c
>  create mode 100644 fs/erofs/decompress.c
>  create mode 100644 fs/erofs/decompress.h
>  create mode 100644 fs/erofs/erofs_fs.h
>  create mode 100644 fs/erofs/fs.c
>  create mode 100644 fs/erofs/internal.h
>  create mode 100644 fs/erofs/lz4.c
>  create mode 100644 fs/erofs/lz4.h
>  create mode 100644 fs/erofs/namei.c
>  create mode 100644 fs/erofs/super.c
>  create mode 100644 fs/erofs/zmap.c
>  create mode 100644 include/erofs.h
> 
> -- 
> 2.25.1
