Return-Path: <linux-erofs+bounces-3703-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B1CCCD98E4
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 03:59:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkDws5pVJz2yVP;
	Mon, 22 Jun 2026 13:59:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782100781;
	cv=none; b=KpcpNIMzqfRf1n6SK7u4IXpW/qNlFegpXAyU++OYAT+FZE8YF4v2cXUr1GIyQkjGC8BqYBOlp7GQ1FYqV4kOHpBF9TcF1Zn3ebNQsOJROEuGLfEaeMieq8EgqwR3QoZTE3PCwLVeMbCwdGQBUdqU2w9AXrSCBtgMt+XRXzqwZJizERmcbtl5ZFjnt2WI0BfMO1t6jQwh+kaNRM8MKXp8CNJAWvjB/TxwxUA5hCkcEjsbe3FOos1YTlKMM4u1qt70SQgCGiLZFy2UxreY9wprH9zxS/XKMNNPQCSe5OQOnnLjOOhjF4ngunrCCcT7y/j0ybkeeH0hZ7aL+qZFdd31nA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782100781; c=relaxed/relaxed;
	bh=plYcJNOgnQxeoujvx1OKqGco3BKdNofh2ZGsVdvRSWc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=CNrnVMCDL/9rnsvtprBnTlXKFe28+kb4H3fPXMdXys1xNbvrrDjnCbytmkpLi3KMBFbqYQxyByCklbkE2NnyXzFkpyUgSbJzhb/7dai58ynRwXbQ7ntdBj8JwoZgrCTqoHWoSaHsfd7H9dtsZzk+Jxr+axNhUTjsCHxqIvewJWsOZgzu9r31Vu16nWdjsqrTjINyRRnw1Jk5D2ps4Yz3cUP9tM/uMIhQ0atUMcCwVEip9esHTzAL4LnwMMQGdI+/Vo0z7RhG1eRuxA5LXidz2a912RsUB7Re4rYiTiZD4xEBIGrqgSzIoo3b7Ne2q6cRdgvq2MlXYaxboWi3/u9X2g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vIFFYipa; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vIFFYipa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkDwr6S2Xz2xwH
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 13:59:40 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782100776; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=plYcJNOgnQxeoujvx1OKqGco3BKdNofh2ZGsVdvRSWc=;
	b=vIFFYipaYPV3Tpn34pQTKZa+25F0qUegNth4jlLsFP8aXPsbFyKKEb44ouLdHQ8TOzv6HaV0WfPtNE3D9JGZBSvr4D8uzlEm73e6q5rlLoNADrmJXzoJ5cYMN3fmJM7h+2NedZKTrk2n2jby46buOrkEI13tgUut6qAvsCLBR0k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X5H7-In_1782100774;
Received: from 30.221.130.114(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5H7-In_1782100774 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 11:59:35 +0800
Message-ID: <7f503bac-d77e-4038-a8e9-8e213bc992a7@linux.alibaba.com>
Date: Mon, 22 Jun 2026 11:59:34 +0800
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
Subject: Re: [RESEND PATCH 1/2] erofs-utils: lib: don't abort on compression
 fallback
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: zhukeqian1@huawei.com, Bastian Schmitz <bastian.schmitz@vorwerk.de>
References: <20260622034248.1047783-1-zhaoyifan28@huawei.com>
 <4433eb42-4ca9-46ae-98e5-7bd388cad0a0@linux.alibaba.com>
In-Reply-To: <4433eb42-4ca9-46ae-98e5-7bd388cad0a0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/22 11:51, Gao Xiang wrote:
> Hi Yifan,
> 
> On 2026/6/22 11:42, Yifan Zhao wrote:
>> -ENOSPC can be a normal compression fallback when fragments are off.
>> Keep the global compression context reusable for that case while
>> preserving the fatal state for real errors.
>>
>> Fixes: a729584ef975 ("erofs-utils: mkfs: avoid hanging if fragment is on and tmpdir is full")
>> Reported-by: Bastian Schmitz <8330902+bshm@users.noreply.github.com>

btw, it seems the reporter email should be

Reported-by: Bastian Schmitz <bastian.schmitz@vorwerk.de>

>> Closes: https://github.com/erofs/erofs-utils/issues/50
>> Assisted-by: Codex:GPT-5.5
>> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
>> ---
>>   lib/compress.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/compress.c b/lib/compress.c
>> index ea07409..2a43b81 100644
>> --- a/lib/compress.c
>> +++ b/lib/compress.c
>> @@ -2031,7 +2031,11 @@ err_free_idata:
>>   out:
>>   #ifdef EROFS_MT_ENABLED
>>       pthread_mutex_lock(&ictx->mutex);
>> -    ictx->seg_num = ret < 0 ? INT_MAX : 0;
>> +    if (ret < 0 && (ret != -ENOSPC || inode->fragment_size))
> 
> Thanks for the fix! but why `inode->fragment_size`
> is used here?
> 
> I guess if (ret < 0 && ret != -ENOSPC) is enough?
> 
> Thanks,
> Gao Xiang


