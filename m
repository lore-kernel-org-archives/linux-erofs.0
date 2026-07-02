Return-Path: <linux-erofs+bounces-3810-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0030DC43458
	for <linux-erofs@archiver.kernel.org>; Thu,  2 Jul 2026 18:20:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4grlYp3zyCz2xdb;
	Fri, 03 Jul 2026 04:20:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783016446;
	cv=none; b=lSJ0YFjckOaF5VvAtQ3ezIpb5qvJbzZ/4ug2XBifnJHSzPxrUWofU6GrUyhiUXLcBNqwG2mrTrWUzlGcLMifgWX//f2YfiQ60cBKPC030c+BixlRQRJdcdv5mbpOyNEsUpxPPNC1U/9Q5zxlR3vgKq5uGI6x7+7CwH0AkBZBKfFKpX1HMnwvl6lKxielXFkDZM/hvifOOBhALuJHqckcnLwCpdLZXsB3SCVJoewbARY6gdkQnyKOD5hpK9Xmj2uzVwUXZSeQdBgK38PvCPCyayEu7b/I7g3NGqrxfe79eiquHTjiDmhFzVA65MTLrk+g8JnelLzXm1Y7mMlyk7f9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783016446; c=relaxed/relaxed;
	bh=UtOklQnkXd2hVBY7CgO90PEJph17GBCHJnKg5P8m5ZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MPftpWi76UW9cAadYgZQ57LN07WhdVuz01WrOcoJ3/VOUOHqUHU6gEYehHtg4HxcD82BAq5g58Eime8fj9QkJiw/AXYEJU53OXHLJFrTuaZ8fLtdzn7BF8JzlkIIAFIzwmfRUEiuyaMBxcREZOyhSRz6nK3blkghyiggzyTpiEIeWwdT9xWpLo95gEDVDwULOEM1jJyHyVhZ2n3xxL4KiaQpNzrYhPs8fQOSdk/QfYFHVMa2YkKVSyBhjyIzxq0T+cCjhnEzfVZnB0TniZMK6ZDle5ZcajNvUNEkmhDcoBsvClAkRy2Ddy4LNrNOcvCvehyIit7KgJdM+dUd/GcP8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ysJyI5CZ; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ysJyI5CZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4grlYm1SH3z2xPb
	for <linux-erofs@lists.ozlabs.org>; Fri, 03 Jul 2026 04:20:42 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783016437; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UtOklQnkXd2hVBY7CgO90PEJph17GBCHJnKg5P8m5ZQ=;
	b=ysJyI5CZDWntYo88dYtgSUgUKlm+M3EAM8dxVIj73s6CECUoQFUW9K6At1PaH28SE0oi0koKxfHTM/GnJoNNhTGXe1Why/s76YhGX/GeNfYaQMEIDNiPp7oSjfnHUC8hYRZQjyQXFvNWKCvnmF27bEuNoeVhk1CFG9VRumZHZPg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X6FihR0_1783016435;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X6FihR0_1783016435 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jul 2026 02:20:36 +0800
Message-ID: <debaf257-7222-402a-a5e1-2ac67f62ab50@linux.alibaba.com>
Date: Fri, 3 Jul 2026 02:20:35 +0800
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
Subject: Re: [PATCH] erofs-utils: fsck: add concurrent extraction and
 decompression
To: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, hsiangkao@alibaba.com
References: <20260702081030.10038-1-nithurshen.dev@gmail.com>
 <75a94b5a-011a-4b7f-bd98-5b40d756f842@linux.alibaba.com>
 <CANRYsKjDbs6_FekTRpJeEw124m9D-mQJu-GvvUP2ms8y9uxK=Q@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CANRYsKjDbs6_FekTRpJeEw124m9D-mQJu-GvvUP2ms8y9uxK=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/2 20:59, Nithurshen Karthikeyan wrote:
> On Thu, 2 Jul, 2026, 18:24 Gao Xiang, <hsiangkao@linux.alibaba.com> wrote:
> 
>>
>>
>> On 2026/7/2 16:10, Nithurshen wrote:
>>> This patch introduces a multi-threaded pipeline for fsck.erofs,
>>> combining parallel directory traversal with background pcluster
>>> decompression to significantly reduce extraction time.
>>>
>>> Key architectural changes include:
>>>
>>> - Thread-Safe State: Removes the global dirstack array and
>>>     fsckcfg.extract_path. These are replaced with per-task localized
>>>     paths and thread-local linked lists to eliminate data races.
>>> - Concurrent Traversal: Refactors erofsfsck_dirent_iter to allocate
>>>     task structures and dispatch inode processing to a background
>>>     workqueue (z_erofs_mt_wq).
>>> - Asynchronous Decompression: Introduces z_erofs_mt_read_ctx to
>>>     batch pcluster reads and decouple decompression from main I/O.
>>>     Limits batch size dynamically (32 for LZ4, 8 for compute-heavy
>>>     algorithms) to balance CPU cache hits and memory overhead.
>>> - Memory & Deadlock Safety: Implements inline backpressure during
>>>     directory iteration. If pending inodes exceed workqueue capacity,
>>>     execution falls back to synchronous processing to prevent
>>>     recursive thread-pool starvation and unbounded memory growth.
>>> - Synchronization Primitives: Adds portable condition variable
>>>     wrappers (erofs_cond_t) to ensure the main thread safely waits
>>>     for all pending background inodes before exiting.
>>>
>>> Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
>>
>> What's the relationship with the previous two patches?
>>
> 
> I made then into one atomic patch, since you wanted them merged at once.

Nope, I didn't want that, I suggested you benchmark each patch.
But it doesn't mean the patches should be merged.

The merge meant merging commits to erofs-utils.

Thanks,
Gao Xiang

> 
> Thanks,
> Nithurshen
> 
> Thanks,
>> Gao Xiang
>>
> 


