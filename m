Return-Path: <linux-erofs+bounces-881-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DFDCA0EED
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Aug 2025 09:56:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4c7bDh5wzVz3cZH;
	Fri, 22 Aug 2025 19:56:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1755856580;
	cv=none; b=SzzGytvVSqyei8VlQI2ZWfJNrHZfmoZn1WsPst/14oVb+MZzpOmmh3nEokMdVALexcBuUWufoD1DcCUjsEKxXRIuI/EdFyYeliOkDMPHSdVptC8PKV9RugVdL8zUM5W616wNzvhFUJI1hBMb52Xj/mqJUpnIknd9nLizigQ7mJ8DCz0hlRvC7/GSc/Z8I5x9PENjVm5OcoZqFHT9qebvKrWXMZGKb9nv+xY2xCBroT65p7kBRGmWhfvc5hj0SoMcSOYytdfOG745X9G8RyiJEL/KPe/oXr8BLjT/9SuvSZJm2zv6dHbU5r7+G9mKEwhXaZNEhoM2tTgOTsSey4WAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1755856580; c=relaxed/relaxed;
	bh=cSxV8kZlJHmQ+78dA0dPBMpbh2dXg+r8vzs5lX3ssaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYirA88G/iE3rbRlMPrSOuNw8FqoackDOHsSEg9uQtB3TQI2qIy6cAS1mB036aJ1Xm/MtzHcVkoiOO8+89jw0Ti70rW1JxVlfZ5f0aisnbcp5Arra2Q3tzLOnI0ttC5AQAIXcfMyHrVVvr+ToEBwV2ebNxgQ5kiblFZRxD4BL+4N/FemZ9+GDgAkb7NLQET0gyP7/uZPK2fEzPTwiEyNKO/reSQZwaSFKXGWtoxNx3j7mzT9DmJyZ/wOz/nYWR2XvxJv/J9ok3SplGNfzktfSTba33UKYQng3yVbewrsAr8sPXYxKL/BUxQyihy7i/QcizWvihOXV6ZVADxmjoE/hw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eG/yQu4p; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eG/yQu4p;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4c7bDg1P50z3cZ8
	for <linux-erofs@lists.ozlabs.org>; Fri, 22 Aug 2025 19:56:18 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755856574; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cSxV8kZlJHmQ+78dA0dPBMpbh2dXg+r8vzs5lX3ssaY=;
	b=eG/yQu4pp3ylmkfPAR+ENoMBiUqYRDLoqDzjd/5drHQHRKsJCG9RkT2XB9tS7E52xau+AIO2lCFdTHCxu6F/oHG7Fe5GQ3ETl4xQ7cuzk8uySSdTkS9aBKARdfvB9kus0XP6lj5rHe01f2uverGH697TkoPS9DyISHCrCrb5z2s=
Received: from 30.221.131.67(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WmJJmUD_1755856572 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 22 Aug 2025 17:56:13 +0800
Message-ID: <a22386fd-d5b2-426f-a6d7-83abce5cf593@linux.alibaba.com>
Date: Fri, 22 Aug 2025 17:56:12 +0800
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
Subject: Re: [PATCH v2] erofs-utils: mkfs: Implement 'dsunit' alignment on
 blobdev
To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
 "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Cc: "Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>,
 "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>
References: <20250822084241.170054-1-friendy.su@sony.com>
 <ab8c4834-a2f4-4b04-a797-5fb3ab3f9e40@linux.alibaba.com>
 <TY0PR04MB6191308433B54530F009868EFD3DA@TY0PR04MB6191.apcprd04.prod.outlook.com>
 <TY0PR04MB6191A41E6265D02BCF22E8FBFD3DA@TY0PR04MB6191.apcprd04.prod.outlook.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <TY0PR04MB6191A41E6265D02BCF22E8FBFD3DA@TY0PR04MB6191.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/8/22 17:52, Friendy.Su@sony.com wrote:
> +       if (cfg.c_chunkbits && dsunit && 1u << (cfg.c_chunkbits - g_sbi.blkszbits) < dsunit) {
> +               erofs_warn("chunksize %u bytes is smaller than dsunit %u blocks, ignore dsunit !",
> +                               1u << cfg.c_chunkbits, dsunit);
> +               dsunit = 0;
> +       }
> 
> 'ignore dsunit' means set it to default, default dsunit is 0. Is this correct?
> > Then sbi->bmgr->dsunit will be set to 'dsunit'.

I think it just ignores `dsunit` since the current behavior also
ignores `dsunit` for blobchunks.

Let's not introduce extra behavior otherwise it could have three
different behaviors among different mkfs.erofs versions.

So you could just drop `dsunit = 0` line.

Thanks,
Gao Xiang

