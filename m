Return-Path: <linux-erofs+bounces-2818-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2982E10854D0
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Mar 2026 03:10:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fbDNV3rb6z2yZ5;
	Wed, 18 Mar 2026 14:10:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773803434;
	cv=none; b=KnovOgiKLBXEvFPBgQOsPbdYK0vYAg1F9gCFK9wW4ievkmoFQvAib4HOzWXOyB+xECVvA8I3lfsAKHiug53F6hIGbpdKxrNnuxR4u+d9ZvIU8MEcvmrI32wkZVoqV7SKVdkoN/pGdaMnqryJ5xYHjDID6tQ7SOaMFWEbl+iV2mFoS0ESJxX33KjkIw34UEMOJI9atbOymjsWORYAA0KSvGanpRladY31+Fd7QyYUS6L11guhr+xs1zVkRZdVmaMe7fgV0facc130LYIjEEP5rrEKbf8MU7nfMc/pXhZ+iA+BsSvCMsT9GZssaCE+sZolEW8ywFTtWNqECb5u5CKv2A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773803434; c=relaxed/relaxed;
	bh=gYknurx8oAYuO7mE+c3zbOmmInQV/xq8kKMbY0fLvj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQT9eYuIdCEsrSPSEeQd9G8AqaVVTbj0IkeTDVPpAJbe0wTvVHHrv4p0h7xVfR299Vl/yP9XOUp3awzVkKofxTOHel4sIPM8xOO7UVGmEewX+E9Bff5HXqatRPNxRywDs13CT3lwH9g3yV9Yn5V3Ry07Nr5lGgYwKCS2vPNo9QwrK5LsxohXQeMW/bPo8hx1OJicuKtnrLb/W+KZbPqYpQ17UBd+J/w6TBfZJCbOTHap8yZ0EmMR8H3Fqim2F4CkiyDFfmiHuKspKW4frx47sZRLmFq+XTuTjIMSf3aSQ9uv2myB2WbLdB7WBbLC8BHTmBElczaUr2KB2gJfeXt0sA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KNryVU8S; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KNryVU8S;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fbDNS1cwjz2xQr
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 14:10:30 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773803421; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gYknurx8oAYuO7mE+c3zbOmmInQV/xq8kKMbY0fLvj0=;
	b=KNryVU8SJrPVUCnv8Xqw31z5RLdX8p7EBJIqRlSfvf7y6BaKD4eI+VW8eN4lg3hsAweSP2KcLGQPLXr/VdOS95b5QjJBdU9KVD4PNP4aHjkPcFxWm7KOzOoP7/0/veSzlo3Ydeugz7o0hMwbikHlcqKf2CPh3CKKibhMU0Eap80=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X.CrUxO_1773803419;
Received: from 30.221.133.123(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.CrUxO_1773803419 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Mar 2026 11:10:20 +0800
Message-ID: <6e0f2de8-5f02-437a-8eb1-330e57ee9e6f@linux.alibaba.com>
Date: Wed, 18 Mar 2026 11:10:19 +0800
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
Subject: Re: [PATCH] erofs-utils: fix thread join loop in
 erofs_destroy_workqueue
To: =?UTF-8?B?6LW16YC45Yeh?= <stopire@gmail.com>,
 Nithurshen <nithurshen.dev@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, zhaoyifan28@huawei.com
References: <20260317043307.27575-1-nithurshen.dev@gmail.com>
 <CABra5+1T-FH54LSYF=Nz1UDrKVX47N32BS432TPo3HEAFJQ10w@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CABra5+1T-FH54LSYF=Nz1UDrKVX47N32BS432TPo3HEAFJQ10w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/18 10:15, 赵逸凡 wrote:
> On 3/17/2026 12:33 PM, Nithurshen wrote:
>> Currently, erofs_destroy_workqueue returns immediately if a single
>> pthread_join fails. This halts the teardown process, potentially
>> leaving orphaned threads and leaking the workqueue's mutexes and
>> worker array.
>>
>> Refactor the joining logic to unconditionally join all worker
>> threads. Capture the first error encountered, continue joining the
>> remaining threads, and ensure all workqueue resources are properly
>> freed before returning the captured error.
>>
>> Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
> 
> Hi Nithurshe,
> 
> 
> I'm afraid I cannot agree with this change. If pthread_join() fails, it
> implies that the worker thread is still alive.
> 
> Cleaning up the synchronization primitives and the workers array at this
> point would lead to a Use-After-Free issue, which is far more severe
> than the current resource leak.
> 
> I believe pthread_join() seldom fails, otherwise it indicates bugs in
> our codebase.

Yes, I wonder the real error number here, it seems there
is another bug somewhere.

> 
> How about just leaving an error log print for this scenario? cc @hsiangkao

Agreed, we should print the error message for each failure
instead.

Thanks,
Gao Xiang

> 
> 
> 
> Thanks,
> 
> Yifan
> 
> 
> 
>> ---
>>    lib/workqueue.c | 10 +++++++---
>>    1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/workqueue.c b/lib/workqueue.c
>> index 18ee0f9..23eb460 100644
>> --- a/lib/workqueue.c
>> +++ b/lib/workqueue.c
>> @@ -42,6 +42,8 @@ static void *worker_thread(void *arg)
>>
>>    int erofs_destroy_workqueue(struct erofs_workqueue *wq)
>>    {
>> +     int err = 0;
>> +
>>        if (!wq)
>>                return -EINVAL;
>>
>> @@ -53,15 +55,17 @@ int erofs_destroy_workqueue(struct erofs_workqueue *wq)
>>        while (wq->nworker) {
>>                int ret = -pthread_join(wq->workers[wq->nworker - 1], NULL);
>>
>> -             if (ret)
>> -                     return ret;
>> +             if (ret && !err)
>> +                     err = ret;
>> +
>>                --wq->nworker;
>>        }
>>        free(wq->workers);
>>        pthread_mutex_destroy(&wq->lock);
>>        pthread_cond_destroy(&wq->cond_empty);
>>        pthread_cond_destroy(&wq->cond_full);
>> -     return 0;
>> +
>> +     return err;
>>    }
>>
>>    int erofs_alloc_workqueue(struct erofs_workqueue *wq, unsigned int nworker,


