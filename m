Return-Path: <linux-erofs+bounces-3580-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1BACD4F2C
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Jun 2026 07:35:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gcBBr1gVlz2ySC;
	Fri, 12 Jun 2026 17:35:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781249748;
	cv=none; b=ZtVh5RrnROjk+MY057OxRxu5oO0wtXeSoBK/uPvw7UVyvzS1H8/D+lNjdHEo9p9X0dpBynHyuwKjfSTRiNSaRfeAXO8UaLmmds38qtJGeIv9t9InUnEcOUEKbzCAVFRPPQQo8HY694cezgMSYCoBDKCWtswrBBEdaN1AiEncmBCouc2a13TOg/0OnMIuEaVDbtIDkaWV1ZkRI33FWqJFsHU0xUUN8eKlyEqAEj77DKH0DbCsWPFUpVbemoRZEvpZKqq6wVf0ucBKVYrxZr1R8qR01OqwfSFgSJLAQwKT7BPkCjqVuvySJI9OdGVXggRZ7xiSk0owgoDDuCDjt0AMRw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781249748; c=relaxed/relaxed;
	bh=CbovmRFDrsE9EQljGf9/0JLd+m27nru3C9VQHKwKRgc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JoGPoK0CyF0btKGH8SmtYradHs+zb3s9nAK1zmZmV+IWb4WaM7i9P6CfLlwr/2HEdpVVZQMK1PqrCpzCiAtS84c7wqeNFPucKEcyn65FZpXHGY7HhUKHm1r0T5EQM29dpXRu2nNos4ug/NjJpKCOrZxT5Kvw3VI4xHUQNM5/P9oC8eahB9X2xuaCSEkDJU9mz9uGzR6ra3fjQS4kNpLD07umUcDu+vLPN7T1EgBkTRnYl0qKGP4sb2Vj7oMKdmYfnDQ0PyQYtbsJhKD8a57ygWwBUk+gcHXnE7vWjICyy+AiQD7Ke2dSXjWBwacwjn+aaUErxBQd1pPcqunBHU57lg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=COsAQG4j; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=COsAQG4j;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gcBBp20Dzz2yS0
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Jun 2026 17:35:45 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781249741; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=CbovmRFDrsE9EQljGf9/0JLd+m27nru3C9VQHKwKRgc=;
	b=COsAQG4jBpBI3jkb0bBldYr/WtHf8EkxbFe6m9dWQb+j1SZjJPQpdotD5R7HwnX7ctAeYz3KybU+G4Ctl3puJ+uoA/o5Ss/yYAioas8NYn/vsXENHJcR05fctAG1zLIOk6sgefFWRujVViM5qcTp0RPUM3D+Az/NC2xHg4FdWVQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X4hsbzz_1781249739;
Received: from 30.221.132.172(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4hsbzz_1781249739 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 15:35:39 +0800
Message-ID: <befed994-02bc-42f8-945c-2aea3e3b10b2@linux.alibaba.com>
Date: Fri, 12 Jun 2026 15:35:38 +0800
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
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, yekelu1@huawei.com, jingrui@huawei.com,
 zhukeqian1@huawei.com, Ritesh Harjani <ritesh.list@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
 <aiuw0QvFIhEWUPG-@infradead.org>
 <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
In-Reply-To: <04d8ea84-1955-4f1e-b5f2-f142fa1971ba@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/12 15:19, Gao Xiang wrote:
> 
> 
> On 2026/6/12 15:10, Christoph Hellwig wrote:
>> On Fri, Jun 12, 2026 at 02:54:47PM +0800, Gao Xiang wrote:
>>> hmm, currently erofs could return block-sized iomap (if the chunk
>>> size is 4k) even it can be merged with the following chunks.
>>>
>>> Previously it was fairly good since consecutive chunks will be
>>> added to the current bio if possible, but after this patch,
>>> there will be a lot of 4k bios.
>>>
>>> But if iomap goes into this way, I could make iomap_begin maps
>>> more chunks in one shot, but that needs more changes in erofs,
>>> it's fine anyway.
>>>
>>> ... I was thinking the following diff (space-damaged):
>>
>> That should work too for your case.  But we definitively have various
>> cases where merging over iomaps is a bad idea.  You'll also end up with
>> other efficiency gains by merging consecutive entries, especially for
>> direct I/O and when using large folios.
> 
> Yes, optimizing erofs chunk mapping would be more
> efficient, will work out one soon, but Yifan can test
> your patch in parallel.
> 
> Also, if "iomap: submit read bio after each extent" is
> applied, I guess some merging condition in
> iomap_bio_read_folio_range() can be removed since they
> won't be reached in any case. (deadcode)

btw, there may be be some edge cases like:
written | hole | written | hole | written ...

and if bios cannot across multiple iomaps, bios could be
amplified according to the shuffle pattern even all written
data is consecutive on disk (the block allocator may
allocate written blocks consecutively.)

Anyway, I never tried to argue with this cases (yet both
previous buffer-head and mpage codebase will merge this
except for some specific exceptions), maybe it's just a
pure artificial pattern and I'm worried too much.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
> 


