Return-Path: <linux-erofs+bounces-2092-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7DAD2ECF7
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Jan 2026 14:11:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwTlR6DXVz3c1T;
	Wed, 21 Jan 2026 01:11:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768918291;
	cv=none; b=lB7fyRz7XJd8+QjGw/kE9FIkzLYQudwILR7IrwOx4pxO204q0cm14O8AAxJF1dWaCliXnmPElyNU1s6rO+Dmdwu8EvzLut7XT4QaicPf6RJffpjQc4XlV55Aq5aettZLkwEgqGRtvyzeK76hDQRO7lVq/+G/cCPCrtfccWnUvQ5gqLEa2i9/3mEyAVFCoJH6R0f5i/O+JgG1ZS8ht6KRCVxAMiHnRD5OfXLwqQTQRbWqd4+DMGKfYEUQXTgUPToPrsjnirevpNbQ1S9IpLdoKLxN6di36Ukxmxkor5beFbWSE3EgOoPe7HZq9y86SXXpvFz0Fc9YFrRQ/yr5CUfuCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768918291; c=relaxed/relaxed;
	bh=23an09Q0biO5z22AKKKB/TBPcY7M6X9cJ2eW+LaU65A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LjW+5S4E2YKrF/lBI0RCAt/z7HcAb0PbJzsWNauR6XJ29KnOcs3EkcDeo7+ts7N+PReYSX8Zs8jQ+6x6vZWxl/JVgH68McOXq4h+u1dSAHWrgS1tgcXfKFe1/pqSxDHwNti9Ir5Kl70uJ3x5S2T6mSeTX7cGJGz/XKwXhGiNqLZWP6fQnjrGfZSwKq/ku/1uRTw5v6etaVYRX2+CXCbw3fSwrLt67cMt+OmEhciq8pVTHUUKk3coNmYkMpfOE+sCRN1En+nEsyrjI4QbRk1KFUrQyzBaimT0wwtp2JWHs0/hV/zhajoiCApyFqlNpmh/HaEWKK283PX1jb2USoGn5g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fJ96ZRXq; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fJ96ZRXq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwTlM5QZSz3btw
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 01:11:25 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768918277; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=23an09Q0biO5z22AKKKB/TBPcY7M6X9cJ2eW+LaU65A=;
	b=fJ96ZRXqk2F0vpHQRjzctslXbWL+tTdisrY8Y6dm+QisbsCqywutI6zoRu+UkGCzD2NpTZDV5p+Tszd809DBmsdX/UEcB2YvQ9snRUttVceszJtMsl+pBSkGGSN6NIXdFTHue2E+eWzSFR+33R0tI1pepQVKxOJhk4YC75PuGtU=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WxUigVY_1768918271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 22:11:12 +0800
Message-ID: <1e9134c2-d984-41a3-b294-166b7e3e6bcf@linux.alibaba.com>
Date: Tue, 20 Jan 2026 22:11:11 +0800
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
To: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Hongbo Li <lihongbo22@huawei.com>, chao@kernel.org, djwong@kernel.org,
 amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, oliver.yang@linux.alibaba.com
References: <20260116154623.GC21174@lst.de>
 <af1f3ff6-a163-4515-92bf-44c9cf6c92f3@linux.alibaba.com>
 <20260119072932.GB2562@lst.de>
 <8e30bc4b-c97f-4ab2-a7ce-27f399ae7462@linux.alibaba.com>
 <20260119083251.GA5257@lst.de>
 <b29b112e-5fe1-414b-9912-06dcd7d7d204@linux.alibaba.com>
 <20260119092220.GA9140@lst.de>
 <73f2c243-e029-4f95-aa8e-285c7affacac@linux.alibaba.com>
 <50db56b8-4cf9-4d62-b242-c982a260a330@linux.alibaba.com>
 <20260120065242.GA3436@lst.de>
 <20260120-neuland-rastplatz-31cc7d61a196@brauner>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260120-neuland-rastplatz-31cc7d61a196@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christian,

On 2026/1/20 21:40, Christian Brauner wrote:
> On Tue, Jan 20, 2026 at 07:52:42AM +0100, Christoph Hellwig wrote:
>> On Tue, Jan 20, 2026 at 11:07:48AM +0800, Gao Xiang wrote:
>>>
>>> Hi Christoph,
>>>
>>> Sorry I didn't phrase things clearly earlier, but I'd still
>>> like to explain the whole idea, as this feature is clearly
>>> useful for containerization. I hope we can reach agreement
>>> on the page cache sharing feature: Christian agreed on this
>>> feature (and I hope still):
>>>
>>> https://lore.kernel.org/linux-fsdevel/20260112-begreifbar-hasten-da396ac2759b@brauner
>>
>> He has to ultimatively decide.  I do have an uneasy feeling about this.
>> It's not super informed as I can keep up, and I'm not the one in charge,
>> but I hope it is helpful to share my perspective.
> 
> It always is helpful, Christoph! I appreciate your input.

Thanks, I will raise some extra comments for Hongbo
to change to make this feature more safer.

> 
> I'm fine with this feature. But as I've said in person: I still oppose
> making any block-based filesystem mountable in unprivileged containers
> without any sort of trust mechanism.

Nevertheless, since Christoph put this topic on the
community list, I had to repeat my own latest
thoughts of this on the list for reference.

Anyway, some people would just be nitpicky to the words
above as a policy: they will re-invent new
non-block-based trick filesystems (but with much odd
kernel-parsed metadata design) for the kernel community.

Honestly, my own idea is that we should find real
threats instead of arbitary assumptions against different
types of filesystems.  The original question is still
that what provents _kernel filesystems with kernel-parsed
metadata_ from mountable in unprivileged containers.

On my own perspective (in public, without any policy
involved), I think it would be better to get some fair
technical points & concerns, so that either we either fully
get in agreement as the real dead end or really overcome
some barriers since this feature is indeed useful.

I will not repeat my thoughts again to annoy folks even
further for this topic, but document here for reference.

> 
> I am however open in the future for block devices protected by dm-verity
> with the root hash signed by a sufficiently trusted key to be mountable
> in unprivileged containers.

Signed images will be a good start, I fully agree.

No one really argues that, and I believe I've told the
signed image ideas in person to Christoph and Darrick too.

Thanks,
Gao Xiang

