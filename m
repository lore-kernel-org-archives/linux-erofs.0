Return-Path: <linux-erofs+bounces-3705-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE63CDB46F
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 04:11:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkFC06PHCz2yVP;
	Mon, 22 Jun 2026 14:11:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782101516;
	cv=none; b=cBakKl2VmoGFGih/b7CmD0T3eR/4IZC2SEXdinnx5LAYa89elZ9iXOr3syuWZbLT6UyS2ahlWJVQ+hnLg6SeWJfYqhki+D1XFT+JjnzQZCQ0huWJqqnWConQuyvbHh9Mf8Jcl9i4/kW1CjwTTk9TVnM+gmhFV0zMQmGb++3rEgINZ96H08r69Pwr1USoMHKU+EgauNCvZUMbRnBVZrlq3keThtC0romDRN9YJVGkPn3xl1dRSNhoxg3LfuCp7I+wt6zvooBiXdBP0MLmEnF3pZwd52CuXpv8/g6op0Umi+HdlMNPiNiHZa/N87FjRehzGM7aLX3tc2qCWDDaGoTlcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782101516; c=relaxed/relaxed;
	bh=wjyy/0VnwcXowjY8u22tURU3A/I1PaVcNFYZtMPFeXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QaxNyOB6O3x2akIYrd7MLPs8hQ1Fegp15j8Yw2JgyHn2ADZH+ZEA66ZXdFgnmuok+XzAzwz9xHgRdUn9TJ/LN1YHQFFgphJwJVfpAA3xX/6YU9kLMQG22xzv5Xqdh+DLvs0oM96YWzPAm5TK4L9OhL86XonOntuwIxtmJi+kT0wNrD+Hyz+GoyVKS5DkvqrgneR8b8tNmA4znFrY+SUMxEf2FG/vGWhBV3F8gezYIEfcDbuZsEgSmkeMitk68at0JpaH6c760yVoWAffKa42SbI6kg6H/PSseMHWrES0w4lXaR83Y++172TZ9sfIgsJfdbfeY/6fnsLkFCNdJV7bKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JiazSPei; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JiazSPei;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkFBy5JtJz2xwH
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 14:11:53 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782101510; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wjyy/0VnwcXowjY8u22tURU3A/I1PaVcNFYZtMPFeXM=;
	b=JiazSPeiLxi02bEfwh3QwXqDD3Kamiu28awk1tiwsv3oYwqziyV/R1Kt4seENEtnP50XhA6IRBVMvh7/G48c5pdR9z7AMnLOwX1cWstcAVppNs5kl3ugUC3RGVk1o+PFOWBbP6Q9Fc/RWXXbOthpFcMmpGB13TvRkykTv+kICkw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X5H72IP_1782101508;
Received: from 30.221.130.114(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5H72IP_1782101508 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 12:11:48 +0800
Message-ID: <700b7898-36b4-45ef-add6-604e74cc00f3@linux.alibaba.com>
Date: Mon, 22 Jun 2026 12:11:47 +0800
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
To: "zhaoyifan (H)" <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: zhukeqian1@huawei.com
References: <20260622034248.1047783-1-zhaoyifan28@huawei.com>
 <4433eb42-4ca9-46ae-98e5-7bd388cad0a0@linux.alibaba.com>
 <b021c538-3100-4cf2-b69e-cbac93b94056@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <b021c538-3100-4cf2-b69e-cbac93b94056@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/22 12:10, zhaoyifan (H) wrote:
> 
> On 2026/6/22 11:51, Gao Xiang wrote:
>> Hi Yifan,
>>
>> On 2026/6/22 11:42, Yifan Zhao wrote:
>>> -ENOSPC can be a normal compression fallback when fragments are off.
>>> Keep the global compression context reusable for that case while
>>> preserving the fatal state for real errors.
>>>
>>> Fixes: a729584ef975 ("erofs-utils: mkfs: avoid hanging if fragment is on and tmpdir is full")
>>> Reported-by: Bastian Schmitz <8330902+bshm@users.noreply.github.com>
>>> Closes: https://github.com/erofs/erofs-utils/issues/50
>>> Assisted-by: Codex:GPT-5.5
>>> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
>>> ---
>>>   lib/compress.c | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/lib/compress.c b/lib/compress.c
>>> index ea07409..2a43b81 100644
>>> --- a/lib/compress.c
>>> +++ b/lib/compress.c
>>> @@ -2031,7 +2031,11 @@ err_free_idata:
>>>   out:
>>>   #ifdef EROFS_MT_ENABLED
>>>       pthread_mutex_lock(&ictx->mutex);
>>> -    ictx->seg_num = ret < 0 ? INT_MAX : 0;
>>> +    if (ret < 0 && (ret != -ENOSPC || inode->fragment_size))
>>
>> Thanks for the fix! but why `inode->fragment_size`
>> is used here?
>>
> My understanding is that once inode->fragment_size is non-zero, -ENOSPC means real failure rather than compression fallback. (lib/compress.c:1374)

hmmm, I guess we should give another specific error
number for compression fallbacks instead to distiguish
no space and compression fallbacks...

Thanks,
Gao Xiang

