Return-Path: <linux-erofs+bounces-3234-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B5CE9DE6F
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Apr 2026 09:09:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4frvJz4dgcz2ygf;
	Thu, 09 Apr 2026 19:09:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775725795;
	cv=none; b=PnWFMmpo4r7/c9U6CHRptF7GKRK0wUeAdQMGBrUQS0rEjleOIhnxhLYgo/jYQf03vVwjJkT2LIBvAhVm92Y5aKSY3b6/NLkBM8ma16J16v4hiv3wnVTEahr3lWe5xOk0VTit+QxBKdNUUrReUj6fyUZ0e8nVeeis8JplrOgP03VQv6w59GZLVQ1SP8xzL+yDw24wqYueaFXMl8Fqsl+w1aC99xxy+itamn2xpuJI7N8b2OE0LuTppphc5Rfa1dsxn8r3fmRLgphtAvJce0I/a4BwH6Q7WdvNbJEDQ87m8IFO7y4+dr0XLGXo2cGmMnRUyGWRDdjF0aEDwPskNMTMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775725795; c=relaxed/relaxed;
	bh=uPp7exEgiBlT8BohYi9kT1T8FzDYyx/IpjdvDIBPv5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b6jP7sdpmJdBEgfhfGR+9g1RIkkjWhQnjskUo7cDuBHRcHxjq6909ZePXTmQr2F2vMSj5gjnC0tNWAGJY7rJaClFt+YICBPBH8e4zuy5nn0Thbhbmvv4hhn0AoSUqJIxzq/tJnBen/TOQLzGqr6qjzVAEOqQRT7YFjHntljEzXLAaSNMOmZ881BApFkHVUVUjH70IB8G+/lM0aCxAxwcoXV5VbSz617eUc9lzzBxt4t+HYS/Ukld7dr3+oaPu9eYMqyfG1rFm4OybEwUJSn7IC9R1ZtMPSY32WPRVEEMa9vfFGIbjGwJqiMnNWbJSLkmIdDqXoHZ8CqSQa7VTfhcug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FaUu3LeG; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FaUu3LeG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4frvJw37sxz2xlr
	for <linux-erofs@lists.ozlabs.org>; Thu, 09 Apr 2026 19:09:51 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775725787; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uPp7exEgiBlT8BohYi9kT1T8FzDYyx/IpjdvDIBPv5M=;
	b=FaUu3LeGRCWavcFYEq59cz2Rj8I8ndXVaMNCU+WS0qA63Bf8qIR3iuv7fBc1Addvp461ucvPijMBtgXrRW79nkcuLGjaBbh+FRNEUspViG8YtbFXOIaEbBY2FfVpCoDZehRlCmJZe/G9Z4bVz2Nfprv3riJwRVR9tAm66eGYy+E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X0ho70R_1775725785;
Received: from 30.221.132.163(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0ho70R_1775725785 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Apr 2026 17:09:46 +0800
Message-ID: <13c30e4c-43de-40f2-b8f4-fc8787f1f642@linux.alibaba.com>
Date: Thu, 9 Apr 2026 17:09:44 +0800
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
Subject: Re: [PATCH] erofs-utils: support --blobdev with block map
To: Nithurshen <nithurshen.dev@gmail.com>, newajay.11r@gmail.com
Cc: linux-erofs@lists.ozlabs.org
References: <20260409084834.147-1-newajay.11r@gmail.com>
 <20260409090713.51262-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260409090713.51262-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/9 17:07, Nithurshen wrote:
> Hi Ajay,
> 
> Thanks for looking into this, but this patch is redundant. I already
> addressed this exact TODO item last month.
> 
> My initial patch was sent on March 7th. After discussing the
> implementation with the maintainers, specifically addressing Yifan
> Zhao's feedback regarding the 32-bit address limits for block map
> entries and the necessary fix to reset m_deviceid in erofs_map_dev(),
> I submitted a finalized v2 on March 9th.
> 
> Additionally, following Gao Xiang's guidance, I have already written
> and submitted the corresponding test case to theexperimental-tests
> branch as of March 19th.
> 
> I strongly suggest checking the recent mailing list archives or the
> pending patch queue before picking up a TODO item to avoid stepping
> on ongoing work and duplicating effort.

I really think you guys don't focus on the random stuff: this
TODO really has low priority.

Thanks,
Gao Xiang

> 
> Regards,
> Nithurshen


