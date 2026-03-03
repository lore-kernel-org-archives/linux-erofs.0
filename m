Return-Path: <linux-erofs+bounces-2475-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4014CEB3648
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Mar 2026 02:11:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fPzng3QSRz2xpk;
	Tue, 03 Mar 2026 13:11:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772503911;
	cv=none; b=YeELV8uF9Ta3hJJ3XPOzPilZhcvwYeG8pRqqOaaCzDsVcmcxAFXUEOl5ao/qqqk50PviMrJAWcrjO+e69V2TYANbQjZg6vvuYyYffM7YmlM3/voiO0ZWHlWm6Y9QLmFYU13sFgeNoS9W4tnvrXK4JOFfZuBpPZhk2vTeX+ZYWNlRb76Whn+B8EAuINDjM0V7QILYty8nbGHa5siOJRGR1VtCCbVYV4jFVkES8JGmcWFzYNThvrjuUJRngVKpexIKlL4/z6irA2HtfLLkolpVzXYvoEUmCvRva3FPkmmoekcb3TwUaUFZA3JWZNufaKJgLQaCjjbF2sjGh3+dh+KLow==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772503911; c=relaxed/relaxed;
	bh=nFbFx2/BFofkXvHdvXlriaDv4ASYA0leI76fEaVkqac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eTLif9h7TITpS//8L0aHRbexLEfxivA3h+tWJTmUwvmIBGC84gMXuuMCbM4IZoWjKVMlr3wTFN0Y+CwmTKQ5cffQQegvUIGRCdm5e5rCc0U3aR9M7tHX/ltxSwIBQnIVfcEaxUU6MldLxO+4qh0y6YZ9RPR575Wt+BP+XRq0x14fgExDIHsHevwZwROAPbbMPrYvhSS2csaWBGe+YEvfWs5WSc5QFQ0bU8JqhQahIL45pD2rW+BatK3RwLxcVNLF5RB1ROxq+HDddWvnW9PHRE09K3JXn6hScDL5+PKuN8yetn14o2A6UUuMTHXZCXvDKzLPYM5vRD4wAgTMmisiKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=R8cPBzEN; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=R8cPBzEN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fPznc54d5z2xRq
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 13:11:46 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772503902; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nFbFx2/BFofkXvHdvXlriaDv4ASYA0leI76fEaVkqac=;
	b=R8cPBzENSu/Itoq2r9p20BnISMaF2Mnuj7nPhn1CM/Q/MLx1ZJ5ChRag7MMEYjRbWMJepUVQxoH6Xwj0aZcO8//UKd9UDyMyzBw5itIn20Ve7veyAy6EyWRmqoHJgOZH7PpE6zayClnCKdfgRhYWGgrz/qiztQgTwrfdj1UTyJY=
Received: from 30.221.132.55(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-86zLx_1772503900 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 10:11:40 +0800
Message-ID: <6e5aa87c-f3bb-4ae9-8700-27f7f1a9d7b2@linux.alibaba.com>
Date: Tue, 3 Mar 2026 10:11:38 +0800
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
Subject: Re: [PATCH] block: avoild hang when bio_list is non-NULL in
 submit_bio_wait()
To: Jiucheng Xu <jiucheng.xu@amlogic.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, jianxin.pan@amlogic.com,
 tuan.zhang@amlogic.com, Gao Xiang <xiang@kernel.org>,
 linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@infradead.org>
References: <20260302-for-next-v1-1-eb9339e8dc99@amlogic.com>
 <aaWVwH_Xna22DTAq@infradead.org>
 <dddf1754-d575-4f4b-a11c-09847d0d0475@linux.alibaba.com>
 <b2ad3f3f-105e-4171-b735-84051906cfb5@amlogic.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <b2ad3f3f-105e-4171-b735-84051906cfb5@amlogic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/3 10:03, Jiucheng Xu wrote:
> 
> 

...

>>
>>> that need to use GFP_NOIO.
>>
>> Yes, it should make vm_map_ram() in the end_io path use
>> GFP_NOIO instead.
>>
>> Jiucheng, could you add memalloc_noio_{save,restore}() to
>> wrap up this path?
> 
> Thanks for Christoph's and Xiang's comments, I will try it. Thanks!

Just one more note: just wrap up z_erofs_decompressqueue_work() in
z_erofs_decompress_kickoff() with memalloc_noio_{save,restore}() is
enough.

  ...
  memalloc_noio_save()
  z_erofs_decompressqueue_work()
  memalloc_noio_restore()

> 
> Best Regards,
> Jiucheng


