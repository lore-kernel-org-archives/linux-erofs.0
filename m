Return-Path: <linux-erofs+bounces-3295-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A997CF9D0D5
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Apr 2026 14:50:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fw6dK1hCqz2yVL;
	Wed, 15 Apr 2026 00:50:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=47.90.199.17
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776178213;
	cv=none; b=KT4NKzRXI7rTMcXhQscHPEJH0sdIsmV8LLHo6R8smh4/6bLxB54TMQJHCLO5sSQXNv0H7HkAzVn2OpjdhsyKPCcrJf4A9SX3HovDEb+duKIn5n2wFlVespxwQwdBpC4Gu1bQZEIzrLZ4/YhJ/9d27Z6rCzQfoIrVDMRsmGEmspxp3Hn0GETq8ijdH4wKBKDJIy4g8PE3XAYKcA93hrHgreoQcXWvHdZ5N7Igb8awyfBrkcA9Qi+YzdFw3Jccs3irKI5BmxItAb/Rfa5DLOXHFX4ZbVGpQI+0RAa4gRWoX136AcXHw9jkr1RizpMVOxXnfhdHiMlssnuIIGTJQxLteg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776178213; c=relaxed/relaxed;
	bh=CflZtnHAZjK7BExsXQTclcVTUxX9Hh7LzEoNUhDQh/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OKR4wv5Nn9qGWsvcvYX850h/Q2GNpdOYHqEJSKjlBsTeLg+zSWYTIi2fLdidCC+QlHgYWFYyxd+AsGfgIxKAbjZWBBvNPObpFaQoLhk3FDhRfefxFqOnlvNXQMfBQ3NLNrOApXBub4JhJYKLq+H+YdUaXbXavcwWN2JaxvgHKDjkfhl3BytZcb2T5hn10YeuXyC91bBWVOgAHhy6MxRmXlCOiGoeyxs90f6WMTY0kcZNNevTvCAoFnCgctYR2+O97aJkC5jNaplaZZFpjKR/mq+gV9tybFB2blc+Xn5rlbFxJ/z42etMGqLVvrZ4KDAn/mOwvT3HoyQU2uv2687jWg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KzTIT+tm; dkim-atps=neutral; spf=pass (client-ip=47.90.199.17; helo=out199-17.us.a.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KzTIT+tm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=47.90.199.17; helo=out199-17.us.a.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out199-17.us.a.mail.aliyun.com (out199-17.us.a.mail.aliyun.com [47.90.199.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fw6dF2RZcz2xMY
	for <linux-erofs@lists.ozlabs.org>; Wed, 15 Apr 2026 00:50:08 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776178192; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CflZtnHAZjK7BExsXQTclcVTUxX9Hh7LzEoNUhDQh/4=;
	b=KzTIT+tmbG3wwpXVrNIvljKQrvHpv4waUaAPeGDdYtMIZMvNEqb4EkafmmQZ8Lg/RJzCcuOtF/ypkEOyXiOe0Du7HOISbEfRcr6Q1vsp0E51nzrPg0pGdzNmY21o+YPRXXqbc5wPCx7te4UFkx5M/Xe8u4PLlcw51WL/BABBbLk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X11gv2H_1776178189;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X11gv2H_1776178189 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Apr 2026 22:49:50 +0800
Message-ID: <ff3c6662-c86d-474e-8672-c4cd8ce29031@linux.alibaba.com>
Date: Tue, 14 Apr 2026 22:49:49 +0800
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
Subject: Re: [PATCH erofs-utils 0/2] tar: fix parsing issues for pax and GNU
 extensions
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
References: <fb13fd1a-e929-4c7b-a8cd-ca0cc80d0ab0@linux.alibaba.com>
 <20260414144632.46859-1-zhanxusheng@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260414144632.46859-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhan,

On 2026/4/14 22:46, Zhan Xusheng wrote:
> Hi Gao,
> 
> Thanks!
> 
> The issue was identified during manual code review. I occasionally
> use LLMs to help polish commit messages or double-check wording.
> 
> Thanks for adding my Signed-off-by.

For example, this:
https://lore.kernel.org/linux-erofs/20260326125406.61001-1-ch@vnsh.in

I've lost my similiar commits like this,
but I will address them all soon.

Thanks,
Gao Xiang

> 
> Best regards,
> Zhan Xusheng


