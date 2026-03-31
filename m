Return-Path: <linux-erofs+bounces-3134-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468551061B2B
	for <linux-erofs@archiver.kernel.org>; Tue, 31 Mar 2026 03:34:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4flDJN51z7z2ybQ;
	Tue, 31 Mar 2026 14:34:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774928084;
	cv=none; b=CpKcPhig9p/kMCZg5bFKWtgo84px7A2mPVo67ga/X92KbO7UqtCvOOqXdOq9NTgtHpmFE46XO7a4Q2JNWNWwsA/1A4dqRPkjKCyPM0uDQ7ZyvL0Ws8x2WgyKCxU7SC8qh25U5b8WPs7tNIiRivCm2on/3gSB2fKTuoZXbEdWXW+bN79NlfpKQM3BbZrRJGrrV07+jw8gvMeEwFSbPj1GlT7aRztcZ4UwP14l6OmaZxQs9ivxFJIs83iB2TRwj2al2BwLatIUX0tDbTJdT84bKA0zUnsqkE14jROq+KUnnSz2wfr++JTBK4iB+axDHxUVGjFOLaU6qvLPlWCytxk9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774928084; c=relaxed/relaxed;
	bh=EkYfcMcWLT5ma6rohOqOzF/JvyvVAIU76YTUb9Jn2Qo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DDfwLeq9NoW/r07/5iWrB7k98loZY7rg93l5B+d1bIZKYG9HrO9LqSXSE7eOKija3fNDtuvI2Y7IOvYFyQyvuSeldep69RcbH/LQ8hxQ7QM1LCbkiM5gOb4TuS/R08F8oSSqyHoEEqkSQ0QkUHOBC3f67YoM72yINwbgLTPjcga4yhlcehhQNp2iePG8fIA3j40aFpwMyCOWKP3Xmf66YRzHlHCle4emFZ1ZtUJDL7/mPWfX0vZZ0kFolANBx+XObR09FXKtGr23Er2T0urX4fAJ6CA9nSQ9fmymrEwdWE3vZRz+RRzFTN+8KLFmrnjzaM6JnfotN/40mwpWK/Ix3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pmEndSVI; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pmEndSVI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4flDJL3tRGz2xlK
	for <linux-erofs@lists.ozlabs.org>; Tue, 31 Mar 2026 14:34:41 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774928078; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EkYfcMcWLT5ma6rohOqOzF/JvyvVAIU76YTUb9Jn2Qo=;
	b=pmEndSVIbuf0TAaKe5eCr7FgG/Q8a4kWZ54Hsq7Rmjm7SYRz0bvqtbnE1UgwT4FZuCGrG+vSffogCJg4C5e5S83pWiYFgyayBYGgyv5EkKa792DGX/ZUV739DxySViJ6escNzBsYjd3MbJ+O1cPvzFuh9WA5yKTvPznO974T5HU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X02y099_1774928076;
Received: from 30.221.131.145(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X02y099_1774928076 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 11:34:37 +0800
Message-ID: <c9224478-e7ad-49fa-ad60-0531f810bfa7@linux.alibaba.com>
Date: Tue, 31 Mar 2026 11:34:35 +0800
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
Subject: Re: [PATCH] erofs-utils: tar: guard slash-only header names
To: Vansh Choudhary <ch@vnsh.in>, linux-erofs@lists.ozlabs.org
References: <20260330173447.486569-1-ch@vnsh.in>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260330173447.486569-1-ch@vnsh.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/31 01:34, Vansh Choudhary wrote:
> Check that the assembled header path is non-empty before trimming
> trailing slashes from it.
> 
> A malformed tar header name made up only of '/' characters could
> otherwise drive the trim loop to read before the start of the buffer.
> 
> Signed-off-by: Vansh Choudhary <ch@vnsh.in>

I don't think it's a valid one.

> ---
>   lib/tar.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/tar.c b/lib/tar.c
> index 4e97522..39e2321 100644
> --- a/lib/tar.c
> +++ b/lib/tar.c
> @@ -866,7 +866,7 @@ out_eot:
>   			path[1] = '\0';
>   		} else {
>   			*_path = '\0';
> -			while (path[j - 1] == '/')
> +			while (j && path[j - 1] == '/')
>   				path[--j] = '\0';
>   		}
>   	}


