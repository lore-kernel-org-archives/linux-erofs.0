Return-Path: <linux-erofs+bounces-3264-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6869E99056
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 08:59:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsW2n30bNz2yZ6;
	Fri, 10 Apr 2026 18:59:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775811585;
	cv=none; b=O2+uYtF3sphVlBSBCdDx8TkvSvY9fWFCRpLAbFZZY9qhbVVvkPtQXDWLuw6F+ukVPZUNtQvgXRPxj/PXEhAMmAJBgDUmUn+oz5aBKNcsLh8ypC/gBXSnePpgPytU31AeNjwnvbbOdM/euU5r/yLr6+mHYVHv1D7t4iy55L19RtKcpdrwnAr7CTsH46aDXDjDDH5ubPjpMNaO05G/VP0XJCIvgb2b5euGELqxMXxbDgHxO8XA50n1HM4HU6+jRB9Vp1h2duA8/HAF2eX0R15siUXBtGeDBHtPYPUC2KCMLUOW4BSVGTFvgfmL79mBzhRPCHhXi3IoND3F2zPUpB0oqw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775811585; c=relaxed/relaxed;
	bh=sLBoAw220Ntlzz3l6qGwv8yMQ3uBi7OQZXVrEWMuzGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gZr5OJV1r1ZAIhga04GTQDnxAYHHV6XyvfOMRSHgsW1CtYhxed/rGgEnl+pkVRia3fw/TaisNA6i6lHtM8LHwIJlufOSMUOKuMgPJeDTZp0A9/o/kvLJRSXTkG4eRT1NCvJsAh8GnCng/IsW+jcVqN6/BsZgP2jUUT3OsiMHmtHuzZhUbD97zoOi7Z7YxQHr8JrSM9JPQhhdwhh1Gmj2MZ4IXpKH0v/23/pbLtVa/vE9YkeWd3mZ/+q6mauCgWKmXlHVyTzLE18jhMZoif6N1ig1/JvmfG0Syzfuc7wQtPkNzV5nk3do1jn/95iuB7IT/l99tVFV/wl+Y6+xIs6qCw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=b7oPm8iQ; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=b7oPm8iQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsW2k5C25z2xTh
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 18:59:41 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775811577; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sLBoAw220Ntlzz3l6qGwv8yMQ3uBi7OQZXVrEWMuzGw=;
	b=b7oPm8iQavDhXHdeMD+DyNwN0iFKOmLmWWOuNKQOf4fRFmvOTfP/huQ9nasRgngm5G+BkDDCFwlO2PX9oZOUpwapa6T0pfDmrvPHOrxJPdgC+6My1S1METTwJrHMVyRLSwvhXe/N10gwS9z2RTNjAnQUlgBiRg4xb88ltWPTTb8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0kq3Lr_1775811575;
Received: from 30.221.132.105(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0kq3Lr_1775811575 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 16:59:36 +0800
Message-ID: <181cfc04-1147-483f-b56f-b6b0119803cf@linux.alibaba.com>
Date: Fri, 10 Apr 2026 16:59:34 +0800
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
Subject: Re: erofs pointer corruption and kernel crash
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: oxffffaa@gmail.com, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, kernel@salutedevices.com,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Sheng Yong <shengyong1@xiaomi.com>
References: <4a2f3801-fac1-42fe-ae75-da315822e088@salutedevices.com>
 <f1ed0cff-57ff-4fb3-b102-0a0a6d79f1a9@linux.alibaba.com>
 <b2cb6d41-adf0-4c62-8689-70294b9b2fc7@linux.alibaba.com>
 <31735f62-2008-4898-b548-0d546efb9120@salutedevices.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <31735f62-2008-4898-b548-0d546efb9120@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/4/10 16:51, Arseniy Krasnov wrote:
> 
> 
> 10.04.2026 11:42, Gao Xiang wrote:
>>
>>
>> On 2026/4/10 16:31, Gao Xiang wrote:
>>> Hi,
>>>
>>> On 2026/4/10 16:13, Arseniy Krasnov wrote:
>>>> Hi,
>>>>
>>>> We found unexpected behaviour of erofs:
>>>>
>>>> There is function in erofs - 'erofs_onlinefolio_end()'. It has pointer to
>>>> 'struct folio' as first argument, and there is loop inside this function,
>>>> which updates 'private' field of provided folio:
>>>>
>>>>     do {
>>>>             orig = atomic_read((atomic_t *)&folio->private);
>>>>             DBG_BUGON(orig <= 0);
>>>>             v = dirty << EROFS_ONLINEFOLIO_DIRTY;
>>>>             v |= (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
>>>>     } while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) != orig);
>>>>
>>>> Now, we see that in some rare case, this function processes folio, where
>>>> 'private' is pointer, and thus this loop will update some bits in this
>>>> pointer. Then later kernel dereferences such pointer and crashes.
>>>>
>>>> To catch this, the following small debug patch was used (e.g. we check that 'private' field is pointer):
>>>>
>>>> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
>>>> index 33cb0a7330d2..b1d8deffec4d 100644
>>>> --- a/fs/erofs/data.c
>>>> +++ b/fs/erofs/data.c
>>>> @@ -238,6 +238,11 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
>>>>    {
>>>>        int orig, v;
>>>> +    if (((uintptr_t)folio->private) & 0xffff000000000000) {
>>>
>>> No, if erofs_onlinefolio_end() is called, `folio->private`
>>> shouldn't be a pointer, it's just a counter inside, and
>>> storing a pointer is unexpected.
>>>
>>> And since the folio is locked, it shouldn't call into
>>> try_to_free_buffers().
>>>
>>> Is it easy to reproduce? if yes, can you print other
>>> values like `folio->mapping` and `folio->index` as
>>> well?
>>>
>>> I need more informations to find some clues.
>>
>> btw, is that an unmodified upstream kernel "6.15.11-sdkernel"?
>> Currently I never heard Android phone vendors using 6.12 LTS
>> for example hit this. If it can easily reproduced, is it
>> possible to reproduce with the upstream kernel?
> 
> Yes, this is just upstream kernel, no vendor modifications. It is not android, just
> buildroot.

I know, I mean for buildroot workloads, it should be
less pressure since it's just for embeded use.

> 
>>
>> And is the "0xffff000002b32468" pointer a valid pointer? what
>> does it point to? If it looks erofs pointer, the only one I
>> can think out is "struct z_erofs_pcluster", if it's not the
>> case, I think there should be other thing wrong if the kernel
>> is modified.
> 
> Yes, this is valid pointer, need to check about that pointer. I'll feedback here.

Anyway, if z_erofs_decompress_queue->erofs_onlinefolio_end()
is called:
   - the folio should be locked, and folio->private should not
     be a pointer;

   - it seems `PG_Private` is set on the problematic folio
     (otherwise try_to_free_buffers() won't be called), which
     is unexpected too.

So what I need for some further analysis are:

   - the folio structure (folio flags, mapping, index, count, etc.);

   - what does folio->private point to?

Also is it possible I could get the memory dump if possible?
Not quite sure if it's possible in buildroot environment.

Thanks,
Gao Xiang

> 
> Thanks
> 
>>
>>>
>>> Thanks,
>>> Gao Xiang

