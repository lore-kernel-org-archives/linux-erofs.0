Return-Path: <linux-erofs+bounces-2205-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B80D6CFD5
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jan 2026 05:58:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dy6g619RRz2xHt;
	Fri, 23 Jan 2026 16:58:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769147906;
	cv=none; b=KSWpkg/curZ3F9QMaWwkn2NS5R0SgpI1ff5ofqezib/fbUWCUySWFqTk+opTOSUAiqt0i7o91blwTsVYBD6LSjkbADklsu0fd4iu3REOu+O91TM4j/XDP/KDZx9BpB5qkHf0v5CG/L1XA+NucAyaMLMmgNzWTm9ewAb70yag9Xfwabk+bkKNvD5GPtOODalk1qZ1DgOYJJ0QURLD3MvlP+E5IjuBYLSkBb1IcvLJUt4jWIdMLym0B31JZSljFh1pDStZ9zxMc6sQ4KQrfM8T0j7c2QKcqZSbjUfPbCw1+cEfG5NaKWZ18LQsOQUikAfM6fjgYy81QqToM6LobBQAfA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769147906; c=relaxed/relaxed;
	bh=qgiEgvnwbNmHMoJ9+JISig9U0fmQoZ1zNWWDsz5ZOb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VSMWcMKM2hC+U4bSFtf3Nfaw4pKrr2T1We8QlEmw5p3l1wh85joS0HKAGWmUUGcCDcT+j9KFx3W6YKWtE2pxUjr7axh9ZTRKWj+LuJaDy3qZmwH2HUOYn4bEGZBTFiqvJtBJzOQDigLgiP47v1UnU8KykIcWHkljag+OfcbRncY3iA1av9WJhXj8xABd2UojJPmm7/fI81qt+Pv/ALj2pJY6Ufm3+m4EqyWfHfz9nfinA4Qm9epB1PiA6aH0pvMqlUttF3103pknW2w//yYmpUYRLX4GH2DEIKVqYBn6B4U2VNTTi9Km9n+hGAvyoSzvP9v3GsU/kXhitANhLKhIUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HLI9Gd2S; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HLI9Gd2S;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dy6g22CBPz2x9M
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 16:58:19 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769147893; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qgiEgvnwbNmHMoJ9+JISig9U0fmQoZ1zNWWDsz5ZOb4=;
	b=HLI9Gd2SVtOOz7EQCQwve9FXfpm+98VEIAv5E7yB7ltfRrRtOu9fNllRFzd9Z8qC5BXjgpQHUSMhGb9WVxR/+qCR2o8bBSs48/1zYk+FkR2GcFZ9YRl5WcphB75TYeoxQlYW6XNxcJFHpbnHguZROYPAp/sG4HbOZbDEw+Bc3AE=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wxehcdl_1769147891 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 13:58:12 +0800
Message-ID: <aa71c034-abf1-4861-8440-e327e535ed7e@linux.alibaba.com>
Date: Fri, 23 Jan 2026 13:58:11 +0800
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
References: <8e30bc4b-c97f-4ab2-a7ce-27f399ae7462@linux.alibaba.com>
 <20260119083251.GA5257@lst.de>
 <b29b112e-5fe1-414b-9912-06dcd7d7d204@linux.alibaba.com>
 <20260119092220.GA9140@lst.de>
 <73f2c243-e029-4f95-aa8e-285c7affacac@linux.alibaba.com>
 <50db56b8-4cf9-4d62-b242-c982a260a330@linux.alibaba.com>
 <20260120065242.GA3436@lst.de>
 <5892c7bb-f06e-45d7-ad84-99837788e5ab@linux.alibaba.com>
 <20260122083310.GA27928@lst.de>
 <abb1f8f4-c5cd-416b-b346-046d3fa8408c@linux.alibaba.com>
 <20260123053936.GA24828@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260123053936.GA24828@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/23 13:39, Christoph Hellwig wrote:
> On Thu, Jan 22, 2026 at 04:40:56PM +0800, Gao Xiang wrote:
>>> Having multiple folios for the same piece of memory can't work,
>>> at we'd have unsynchronized state.
>>
>> Why not just left unsynchronized state in a unique way,
>> but just left mapping + indexing seperated.
> 
> That would not just require allocating the folios dynamically, but most
> importantly splitting it up.  We'd then also need to find a way to chain
> the folio_link structures from the main folio.  I'm not going to see this
> might not happen, but it feels very far out there and might have all
> kinds of issues.

I can see the way, but at least I don't have any resource,
and I'm even not sure it will happen in the foresee future,
so that is why we will not wait for per-folio sharing
anymore (memory is already becoming $$$$$$..).

> 
>>>>> I think the concept of using a backing file of some sort for the shared
>>>>> pagecache (which I have no problem with at all), vs the imprecise
>>>>
>>>> In that way (actually Jingbo worked that approach in 2023),
>>>> we have to keep the shared data physically contiguous and
>>>> even uncompressed, which cannot work for most cases.
>>>
>>> Why does that matter?
>>
>> Sorry then, I think I don't get the point, but we really
>> need this for the complete page cache sharing on the
>> single physical machine.
> 
> Why do you need physically contigous space to share it that way?

Yes, it won't be necessary, but the main goal is to share
various different filesystem images with consensus per-inode
content-addressable IDs, either secure hashs or per-inode UUIDs.

I still think it's very useful considering finer-grain page
cache sharing can only exist in our heads so I will go on use
this way for everyone to save memory (considering AI needs
too much memory and memory becomes more expensive.)

> 
>>>
>>>> On the other side, I do think `fingerprint` from design
>>>> is much like persistent NFS file handles in some aspect
>>>> (but I don't want to equal to that concept, but very
>>>> similar) for a single trusted domain, we should have to
>>>> deal with multiple filesystem sources and mark in a
>>>> unique way in a domain.
>>>
>>> I don't really thing they are similar in any way.
>>
>> Why they are not similiar, you still need persistent IDs
>> in inodes for multiple fses, if there are a
>> content-addressable immutable filesystems working in
>> inodes, they could just use inode hashs as file handles
>> instead of inode numbers + generations.
> 
> Sure, if they are well defined, cryptographically secure hashes.  But

EROFS is a golden image filesystem generated purely in
userspace, vendors will use secure hashs or
per-vendor-generated per-inode UUID.

> that's different from file handles, which don't address content at all,
> but are just a handle to given file that bypasses the path lookup.

I agree, so I once said _somewhat_ similar.  Considering
content-addressable filesystems, of course they could use
simplifed secure hashs as file handles in some form.

Thanks,
Gao Xiang

> 
>>
>> Thanks,
>> Gao Xiang
> ---end quoted text---


