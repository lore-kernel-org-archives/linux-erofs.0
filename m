Return-Path: <linux-erofs+bounces-3271-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DFA3E99074
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 10:06:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsXWT5Dgjz2yZ6;
	Fri, 10 Apr 2026 20:06:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775815573;
	cv=none; b=Iskwmlzq5SbEdI9L4ch1cD2/fqfJmHw9EUZlyPDqEodUzKrmK/owShQwiIASrZW48LyRf6ijc/rTsegSi91fE69JMvAe2Mp5HHv+fsF50RcA+yu74pXtKCdR2zWCX0NclKvZSaTglHFwvY7VdfA0DYiS2Y7lxVnfeVWBoPhHehmwQoHL4utNOKSzCqgcjZAJ2aQksJHTtlAhQ4a12MxJg86cnl3/q8Ju9H9dhVFiDxYg0s9EOt7JuqJ2C1/wMspsOqzCU1v+/ilR1qC5D3O2YRMD4jfkCQhCT3IK6WYKOOzJI7MtALi4tQB72NwD++4hmURLbwALGUBlvce8v2ccfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775815573; c=relaxed/relaxed;
	bh=AeAHf9/ou6cD3bpJp5OYIP7QdLqeK8HJO0Wre2/s2bE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EIhihYbqJvaP8zykESEouCvS9S8ybSysUS91WE/uuJ4nvxZypc3SBot4GfrzCKP8+tfDjP+Fjd4KYJMAW/UoepMmdoaP8VLAKro+yQyDO7mMUNMGo7BSA89KTuyvj4+07zSITfr5z0nDGZaj/Igl5l/8F/d/bmxkk0w2fr2CBlNbEy6Q/qH2SgBYLdlHwyPMgzsYMRgLJzYc36RDWK/KbnAgjYb2wpMm/QnypRlmjjP4+6MiGuZoFrBODIwZ3nPWOlcax2tqrOgf4aOg9v4G06JqM91mDFZL84Od/F5nJdV4oVIe5Hmsxf/qsjdPC7cy6TpzjNJSQY9f8rBTuEl+6g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=U89RjBb1; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=U89RjBb1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsXWS60cZz2yYy
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 20:06:11 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775815568; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AeAHf9/ou6cD3bpJp5OYIP7QdLqeK8HJO0Wre2/s2bE=;
	b=U89RjBb1ahIkrBOLlXHmEuQb3hFWktxyaN0CcR641bdxDByTjdHK56r5o776BTjgjXR2HMa6QrmLfUnpCErhaf53Pb5sMOcXpBMBsgdPEUDlcflw7aRMbKenL5EhvsaZCazXx8mabZtDmo5PI378wGjugxtv4LixcjY6x94zqZw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0kw22-_1775815565;
Received: from 30.221.132.105(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0kw22-_1775815565 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 18:06:06 +0800
Message-ID: <cad241fc-c2c6-4872-ab56-be3b7b44fbea@linux.alibaba.com>
Date: Fri, 10 Apr 2026 18:06:05 +0800
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
 <9d8a073a-982e-4c7b-9445-623941a16b05@salutedevices.com>
 <16ea58e8-43b7-439b-91db-9f87d2fb2b84@linux.alibaba.com>
 <a28be132-1f08-4ce1-90f9-7732301c9aa3@salutedevices.com>
 <e8bc1c98-e76b-4f02-a834-c0d2ad88ed46@linux.alibaba.com>
 <f68962d5-cce1-4993-a7d2-54c3fb752064@salutedevices.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <f68962d5-cce1-4993-a7d2-54c3fb752064@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/4/10 18:03, Arseniy Krasnov wrote:
> 
> 
> 10.04.2026 13:01, Gao Xiang пишет:
>>
>>
>> On 2026/4/10 17:59, Arseniy Krasnov wrote:
>>>
>>>
>>> 10.04.2026 12:20, Gao Xiang wrote:
>>>>
>>>>
>>>> On 2026/4/10 16:55, Arseniy Krasnov wrote:
>>>>>
>>>>>
>>>>
>>>> ...
>>>>
>>>>>>>
>>>>>>> BR2_TARGET_ROOTFS_EROFS=y
>>>>>>> BR2_TARGET_ROOTFS_EROFS_CUSTOM_COMPRESSION=y
>>>>>>> BR2_TARGET_ROOTFS_EROFS_COMPRESSION_ALGORITHMS="zstd,22 --max-extent-bytes 65536 -E48bit"
>>>>
>>>> btw, may I ask what's the erofs-utils version?
>>>> erofs-utils 1.9?
>>>
>>> We have 1.8.5 erofs-utils
>>
>> 1.8.5 shouldn't have `-E48bit` support, that is my question.
> 
> You mean to try to reproduce with 1.9 utils ?

Nope, I meant

BR2_TARGET_ROOTFS_EROFS_COMPRESSION_ALGORITHMS="zstd,22 --max-extent-bytes 65536 -E48bit"

is invalid in erofs-utils 1.8.5.

If you were using erofs-utils 1.9+, that may be due to
the new `-E48bit`;

but you said you are using erofs-utils 1.8.5, that makes
me feel confused.

Thanks,
Gao Xiang

