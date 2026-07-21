Return-Path: <linux-erofs+bounces-3945-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B07C44529
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Jul 2026 06:57:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h47VL0Yfpz2xlb;
	Tue, 21 Jul 2026 16:57:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784617034;
	cv=none; b=g3Ls40mE224hCwAbusSxeN/I2i+MIil1cLXc8pCnehqNY2/YYjsolg9pmMyFFllBgDdMJFfTHrNvsGxVUuA9I6eu6Q1e0mz0Wyb7Y4jF0NY5KPBAYhJnJruxeNXg/GgZ0fx6LbvpHYVMdSzWTosyqOtD0Qxh5E7L4D/gDxeJxeXjWh2y/7MPbQG7CXHo/rc6ZSc7tZFmlj4OLyGVX4Uaf8b7Sygfbn0XHizrYTse3WKiXrQKX1p7JIzU0+l8PjMOKX161ixYNAeyXNY4+2jVWYgBARs9Po33bTZvw+sWq02qlQWBFhaO2SZJ4wgb51ESXcR7h2Gmks8hEj16XO3TCw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784617034; c=relaxed/relaxed;
	bh=JrgLJ6kyleiy+BWd4V1PcHSkmhi4JuhDjorFs9TGTq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NB8u+Goz6a1jeeoSloHyH7diWtqra9AeU+Xfc8FhXrJBQCuBmFIRU+dpBjEQwltAF0qKrmiZBq5BcY0W79zJsDH9cbuHQHD3Qq5549q1nSX83QRby2Y8mfjLE8D8bL23W4lrQyMTC8HjWYs/4Qh62h20R42OcQbzjQKVimDKdWa9AVu9g9XYIPmfnkL3wjrAyqk8u+CZtY1v3wPXdLDj1D/2BG9WvZcPRXp7lmY9nkDJAzn6hE5Iih5paOOx9ebBZ2p08mVXtr8iw4crARSfKKzksoKrbgy8WQFpQil339eVpI2PMUpWNwf7g8MIjzphMPYmd/oS05IZgJHWv6sOBw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vvo9pFoG; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vvo9pFoG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h47VH490wz2xLh
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Jul 2026 16:57:10 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784617026; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JrgLJ6kyleiy+BWd4V1PcHSkmhi4JuhDjorFs9TGTq8=;
	b=vvo9pFoGmQzGJwvlovKE4AiQr9HtyHhzoKA7vwmn88axycUiZ22bKVbdg9u30ZkYx3VIbrFc+f/K5t6QocJgubRuOAxMivrqBJKQeB37VeiDqEcxzF2I/aHf/GFJLjYoOGHTjaZ7vqELEhA6+LL2hMjNvfbVtLbAzzBRUMofJTw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X7YzLsX_1784617024;
Received: from 30.221.132.10(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X7YzLsX_1784617024 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 14:57:05 +0800
Message-ID: <914d03e1-b792-4e3f-b26e-e1ba2d245aed@linux.alibaba.com>
Date: Tue, 21 Jul 2026 14:57:04 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: fix ztailpacking fallback across
 lclusters
To: "zhaoyifan (H)" <zhaoyifan28@huawei.com>,
 Zhiguo Niu <niuzhiguo84@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, zhukeqian1@huawei.com
References: <20260709123411.1166770-1-zhaoyifan28@huawei.com>
 <CAHJ8P3JK5gKS=RH2b=waY7g1AJ7S6ZHzDV0asg46pkzHsWzMHw@mail.gmail.com>
 <5700f79d-2cfb-4408-80d3-509ac154bef0@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <5700f79d-2cfb-4408-80d3-509ac154bef0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

On 2026/7/21 14:55, zhaoyifan (H) wrote:
> 
> On 2026/7/20 19:42, Zhiguo Niu wrote:
>> Yifan Zhao <zhaoyifan28@huawei.com> 于2026年7月9日周四 20:36写道：
>>> With ztailpacking, the final compressed pcluster is first stored as
>>> inline data.  If the inode metadata area cannot hold it, mkfs falls back
>>> to a normal tail block and drops the inline pcluster marker.
>>>
>>> The current fallback path assumes that the inline tail pcluster belongs
>>> to the EOF lcluster.  That is not always true: the tail pcluster can
>>> start in the previous lcluster and end at EOF, while its raw size still
>>> fits in one block.  In that case, patching the EOF lcluster is
>>> semantically wrong.
>>>
>>> Let's keep raw tail data whenever it fits in one block, and convert the
>>> corresponding lcluster index to PLAIN during fallback.
>>>
>>> Reported-by: Alberto Salvia Novella <es20490446e@gmail.com>
>>> Closes: https://github.com/erofs/erofs-utils/issues/51
>>> Assisted-by: Codex:GPT-5.5
>>> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
>>> ---
>> Hi Yifan,
>> I tested this patch to focus on the issue fixed by commit
>> 277a42502a7a, and it passed.
>> But I have some questions:
>>>   include/erofs/internal.h |   5 +-
>>>   lib/compress.c           | 109 ++++++++++++++++++++++++++++-----------
>>>   2 files changed, 83 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/include/erofs/internal.h b/include/erofs/internal.h
>>> index 2cc9cc8..bdde41f 100644
>>> --- a/include/erofs/internal.h
>>> +++ b/include/erofs/internal.h
>>> @@ -212,8 +212,11 @@ struct erofs_diskbuf;
>>>
>>>   enum erofs_idata_type {
>>>          EROFS_IDATA_TYPE_RAW,
>>> -       EROFS_IDATA_TYPE_COMPRESSED_DEFAULT,
>>> +       EROFS_IDATA_TYPE_COMPRESSED,
>>> +       /* compressed idata follows a final 2B compacted index pack */
>>>          EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B,
>>> +       /* compressed idata follows a final single-entry 4B pack after a 2B pack */
>>> +       EROFS_IDATA_TYPE_COMPRESSED_4B1_PREV2B,
>>>   };
>>>
>>>   #define EROFS_I_BLKADDR_DEV_ID_BIT             48
>>> diff --git a/lib/compress.c b/lib/compress.c
>>> index f7ad5a1..ec90f65 100644
>>> --- a/lib/compress.c
>>> +++ b/lib/compress.c
>>> @@ -483,7 +483,7 @@ static int z_erofs_fill_inline_data(struct erofs_inode *inode, void *data,
>>>   {
>>>          inode->z_advise |= Z_EROFS_ADVISE_INLINE_PCLUSTER;
>>>          inode->idata_size = len;
>>> -       inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED_DEFAULT;
>>> +       inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED;
>>>
>>>          inode->idata = malloc(inode->idata_size);
>>>          if (!inode->idata)
>>> @@ -664,7 +664,7 @@ frag_packing:
>>>                  ictx->fragemitted = true;
>>>          /* tailpcluster should be less than 1 block */
>>>          } else if (may_inline && len == e->length && compressedsize < blksz) {
>>> -               if (ctx->clusterofs + len <= blksz) {
>> Shouldn't this condition restrict the `tail pcluster` so that it
>> corresponds to only  eof`lcluster`?
>> and we drop the inline pcluster just when  eof_tailraw is not null.
>> Thanks!
> 
> Hi Zhiguo,
> 
> 
> A tail pcluster may start in the previous lcluster and end in the EOF lcluster while its whole raw payload still fits in one physical block. In that case `ctx->clusterofs + len > blksz`, but `len <= blksz`, but it should still be converted into a single PLAIN pcluster.
> 
> This patch targets this edge case so I think change the if statement here is necessary?

This case has been resolved on the kernel side, so before we
get a cleaner way, let's keep this as-is since it's not a
new case for many year.

Thanks,
Gao Xiang

> 
> 
> Thanks,
> 
> Yifan
> 

