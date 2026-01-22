Return-Path: <linux-erofs+bounces-2134-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D87C44500
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 08:41:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxZKL2FL3z2yFm;
	Thu, 22 Jan 2026 19:41:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769071270;
	cv=none; b=ZMrVZIr2kUOidavTr1uVrzImjwqTAhgBI35TfSCL8c1tWtQe1raWJTbg1ryStD5mcQzV8rmuOz+IIzTIwJX1KhHLeMjMKVq9WB71lLjZEOXYKtSadIuaR94VCxKFt4zRvLS2GN56IRaw16zeHWgv6PdZOk8siy4MyMJm07tfSLXn3tXPGP+J0xP1WGXaEUz8s1q7dRbCOC64VZq98GgMN6lz+6kHl9rOysGq5sCb7FOMTmYu3Gb6fScZzl8msS5Y57keJ4h4z2CojknQkXwoGIhBRFFLHb7Jc58B7G/dVm2Oht6b3IstnaNI7+kdPzGREWl2zPifSkZyTUAX484c6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769071270; c=relaxed/relaxed;
	bh=gJSzOWSqPre+2yZ8/cQcaEgo/1k5YiDdjzLGF45ntF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsJeWzxiTajUBODjuRiqEO4zHbgj22/OI1+tUCLXgNHdy35vlVG19kWOtOHty7/o5lb0Ik8NmAE/5dMw4Ng7xIhk11QwDcRAc9bYWVqwWZQvdh9s1O9ZpcDGfJ8QRm9WqLSaw90d7FTPMRlnr0OSL1q1537C/MBMXmyYYz1IjgVOBX8djOycNa8+jE28cS6YnYOQ6GKnX5VFxK38or6MrzHjUmkyAJEaXuYXGO6+lrISrKycqbxrH+eupdxrI9YRZL/YQI2aRBSY/jmyhyjWX4qKzOVnIxbznOUkFthC4YLGIzGZcZmknfbfogr014xluZtz4k8I5RHvKE07V3lA/g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SVtt8ulf; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SVtt8ulf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxZKJ2c3Mz2xS5
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 19:41:07 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769071262; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gJSzOWSqPre+2yZ8/cQcaEgo/1k5YiDdjzLGF45ntF8=;
	b=SVtt8ulfGWdIs1E6Jg6ak12Cn2aqqBbOK1M4a5QjFnvkyf++oVLKjzAuzy9Yzn7YgClRAIet+1m1upVkPU5imZUfpQlG3gYjLcj2GWzlJO4rFnLFBYA25JnmKDo5So1V6deQ7f+LRhaKIpVMU+TPxwVD4IZM8J08z3feTxBjg1Y=
Received: from 30.221.131.199(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WxbgvIV_1769071257 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Jan 2026 16:40:58 +0800
Message-ID: <abb1f8f4-c5cd-416b-b346-046d3fa8408c@linux.alibaba.com>
Date: Thu, 22 Jan 2026 16:40:56 +0800
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
Subject: Re: [PATCH v15 5/9] erofs: introduce the page cache share feature
To: Christoph Hellwig <hch@lst.de>
Cc: Hongbo Li <lihongbo22@huawei.com>, chao@kernel.org, djwong@kernel.org,
 amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, oliver.yang@linux.alibaba.com
References: <af1f3ff6-a163-4515-92bf-44c9cf6c92f3@linux.alibaba.com>
 <20260119072932.GB2562@lst.de>
 <8e30bc4b-c97f-4ab2-a7ce-27f399ae7462@linux.alibaba.com>
 <20260119083251.GA5257@lst.de>
 <b29b112e-5fe1-414b-9912-06dcd7d7d204@linux.alibaba.com>
 <20260119092220.GA9140@lst.de>
 <73f2c243-e029-4f95-aa8e-285c7affacac@linux.alibaba.com>
 <50db56b8-4cf9-4d62-b242-c982a260a330@linux.alibaba.com>
 <20260120065242.GA3436@lst.de>
 <5892c7bb-f06e-45d7-ad84-99837788e5ab@linux.alibaba.com>
 <20260122083310.GA27928@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260122083310.GA27928@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/22 16:33, Christoph Hellwig wrote:
> On Tue, Jan 20, 2026 at 03:19:21PM +0800, Gao Xiang wrote:
>>> It will be very hard to change unless we move to physical indexing of
>>> the page cache, which has all kinds of downside.s
>>
>> I'm not sure if it's really needed: I think the final
>> folio adaption plan is that folio can be dynamic
>> allocated? then why not keep multiple folios for a
>> physical memory, since folios are not order-0 anymore.
> 
> Having multiple folios for the same piece of memory can't work,
> at we'd have unsynchronized state.

Why not just left unsynchronized state in a unique way,
but just left mapping + indexing seperated.

Anyway, that is just a wild thought, I will not dig
into that.

> 
>> Using physical indexing sounds really inflexible on my
>> side, and it can be even regarded as a regression for me.
> 
> I'm absolutely not arguing for that..
> 
>>>> So that let's face the reality: this feature introduces
>>>> on-disk xattrs called "fingerprints." --- Since they're
>>>> just xattrs, the EROFS on-disk format remains unchanged.
>>>
>>> I think the concept of using a backing file of some sort for the shared
>>> pagecache (which I have no problem with at all), vs the imprecise
>>
>> In that way (actually Jingbo worked that approach in 2023),
>> we have to keep the shared data physically contiguous and
>> even uncompressed, which cannot work for most cases.
> 
> Why does that matter?

Sorry then, I think I don't get the point, but we really
need this for the complete page cache sharing on the
single physical machine.

> 
>> On the other side, I do think `fingerprint` from design
>> is much like persistent NFS file handles in some aspect
>> (but I don't want to equal to that concept, but very
>> similar) for a single trusted domain, we should have to
>> deal with multiple filesystem sources and mark in a
>> unique way in a domain.
> 
> I don't really thing they are similar in any way.

Why they are not similiar, you still need persistent IDs
in inodes for multiple fses, if there are a
content-addressable immutable filesystems working in
inodes, they could just use inode hashs as file handles
instead of inode numbers + generations.

Thanks,
Gao Xiang


