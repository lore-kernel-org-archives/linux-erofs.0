Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A05C54E67
	for <linux-erofs@archiver.kernel.org>; Wed, 27 Mar 2024 09:24:41 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GqB+AyGc;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4V4Lpv68Jbz3dhY
	for <linux-erofs@archiver.kernel.org>; Wed, 27 Mar 2024 20:24:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GqB+AyGc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4V4Lpn5fN6z2xQK
	for <linux-erofs@lists.ozlabs.org>; Wed, 27 Mar 2024 20:24:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711531468; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uxwWbrArm1xNuk6UDwn5k8T5iSf4Ft84Q/m+C+xGahQ=;
	b=GqB+AyGcfRaBYge4LAlH7Y9u1lFBqv0FLVt89Fla8ITTKZJuzDnc1TXzhfn49dcrwtkPV32xWc+nXxEwz2tbFqUmOtQonw+znk+eN3jF1b4PQxv/OeUa+FbkdYDWQmpAHcakv1KAbJUxK2GCU5pmoUCROv3tYiAEd8XDXhiwyWM=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W3OEqPS_1711531466;
Received: from 30.97.48.170(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W3OEqPS_1711531466)
          by smtp.aliyun-inc.com;
          Wed, 27 Mar 2024 17:24:26 +0800
Message-ID: <b0f40ec0-13e0-440f-aceb-267bb086e3e0@linux.alibaba.com>
Date: Wed, 27 Mar 2024 17:24:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] doc: magic: Fix the 'clear' example
To: Luke Shumaker <lukeshu@lukeshu.com>, linux-erofs@lists.ozlabs.org
References: <20240327091239.4141736-1-lukeshu@lukeshu.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20240327091239.4141736-1-lukeshu@lukeshu.com>
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



On 2024/3/27 17:12, Luke Shumaker wrote:
> From: "Luke T. Shumaker" <lukeshu@lukeshu.com>
> 
> ---
>   doc/magic.man | 4 ++--

Does this send to a wrong mailing list?

Thanks,
Gao Xiang

>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/doc/magic.man b/doc/magic.man
> index b9845f5c..2ee28774 100644
> --- a/doc/magic.man
> +++ b/doc/magic.man
> @@ -1,5 +1,5 @@
>   .\" $File: magic.man,v 1.107 2024/03/01 02:57:32 christos Exp $
> -.Dd February 29, 2024
> +.Dd March 27, 2024
>   .Dt MAGIC __FSECTION__
>   .Os
>   .\" install as magic.4 on USG, magic.5 on V7, Berkeley and Linux systems.
> @@ -764,7 +764,7 @@ If you have a list of known values at a particular continuation level,
>   and you want to provide a switch-like default case:
>   .Bd -literal -offset indent
>   # clear that continuation level match
> -\*[Gt]18	clear
> +\*[Gt]18	clear	x
>   \*[Gt]18	lelong	1	one
>   \*[Gt]18	lelong	2	two
>   \*[Gt]18	default	x
