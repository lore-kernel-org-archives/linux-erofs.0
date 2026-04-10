Return-Path: <linux-erofs+bounces-3272-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A27E99071
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 10:10:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsXcX5sqkz2yZ6;
	Fri, 10 Apr 2026 20:10:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=95.181.183.35
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775815836;
	cv=none; b=Dpobmu44vy/ELwy0feR6XOFGFmJnjUZ6A+aJwvfcZQZ+02OpGr8A6kLJPZKrk+GrIvvhhJUpflmDb69B7n5ofky4UNtIcES565R83nPYHxw9u0s9LLUbgkni/HkyyvkxxGOvBOBhaPrksuhN54hO6wRKfYFi9c4QhUeVR9NmAP4uzkNEqBWokIAiyb5vk9CkA1lZTkdpz4oulz6ZgO3skQrL0IDmjpAUC6C+cOskJqLhRJV7G9qt1CyuXr0PVfl+LSy+bqw4CDwuyMC4mYXFSaRrLRruMUdLUlLqfFLGLWZhEYLwrWq/2w741G2zBjtTUYiaZJT/y6Y7Kl90Z0Qfmg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775815836; c=relaxed/relaxed;
	bh=9GWw5nmUvOSDZHe7Ub8q+Hdw4ItMDqXTolohKIf2nHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bg49Q6dGOjwCKWkw5BncFCwvMq12GNPX6eYK7mfAWS0Ftirqn+OnvfvtFpeoKPo6dIAjsN/oSVJwRHIcPeFQbtMPARah5+dTHUNoqq1x2HhLzdP5nxn0qTUxpRgC6oas1ix+kqouXBM27NjmBAQY2jIx837nhL+KyXHhdpbYmHF7lIrnNQVPgJ7WyvD+/9k9QxnAtWJhqGTmRcJ5aajc1Jobt3BVgpHpQXsges/bXfMogsluv/XjwSY5DLf2brVyH4LtL5Js2EZcOWiHN+DXZCQPGQAfzcg/FF+kNZOaEJtWQbKwMJjtk72/xswmU2GechquN6tTeta4dmqrSskK0Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; dkim=pass (2048-bit key; unprotected) header.d=salutedevices.com header.i=@salutedevices.com header.a=rsa-sha256 header.s=post header.b=mpZa3NJK; dkim-atps=neutral; spf=pass (client-ip=95.181.183.35; helo=mx5.sberdevices.ru; envelope-from=avkrasnov@salutedevices.com; receiver=lists.ozlabs.org) smtp.mailfrom=salutedevices.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=salutedevices.com header.i=@salutedevices.com header.a=rsa-sha256 header.s=post header.b=mpZa3NJK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=salutedevices.com (client-ip=95.181.183.35; helo=mx5.sberdevices.ru; envelope-from=avkrasnov@salutedevices.com; receiver=lists.ozlabs.org)
Received: from mx5.sberdevices.ru (mx5.sberdevices.ru [95.181.183.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsXcW5XzRz2yYy
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 20:10:35 +1000 (AEST)
Received: from p-antispam-ksmg-gc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx5.sberdevices.ru (Postfix) with ESMTP id B7938240011;
	Fri, 10 Apr 2026 13:10:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx5.sberdevices.ru B7938240011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=post; t=1775815832;
	bh=9GWw5nmUvOSDZHe7Ub8q+Hdw4ItMDqXTolohKIf2nHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=mpZa3NJKKG92o5YPIlciwdshm5DXGVPI7IuvociR+Z+NqhBgiLPJBJXVToSVVs0Yk
	 wc/NuOj6y6NDjfkkZPIIxi3+4q+C2A0QrDV4tQMxnPtfAKRfhmp9kdjJmqnLZT0V1V
	 UY0ZUoeizmBphjwhzJjnE/rR8mqZwMiyK+wkcrFP3L2rfM0vDPViuW5Spt384MOgJj
	 RyAAwMhTzHUUkugoEaRlGOC6v2LrrQAIKIliw+w1CPg27ZibdYlTwROOqnd2TJ2KAP
	 6/BB6hsE0IEsDM/yASSzpo7furqNIdtFzBnqJI0Mv4CyzEZUKNRyBvkyjZvRceXAyU
	 WBiKznQcIsYaA==
Received: from smtp.sberdevices.ru (p-exch-cas-a-m1.sberdevices.ru [172.24.201.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "sberdevices.ru", Issuer "R12" (not verified))
	by mx5.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 10 Apr 2026 13:10:31 +0300 (MSK)
Message-ID: <5301be8f-4b2e-4f1d-a90b-91da00f98994@salutedevices.com>
Date: Fri, 10 Apr 2026 13:10:30 +0300
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
Content-Language: ru
To: Gao Xiang <hsiangkao@linux.alibaba.com>
CC: <oxffffaa@gmail.com>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <kernel@salutedevices.com>, Gao Xiang
	<xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>, Sheng Yong <shengyong1@xiaomi.com>
References: <4a2f3801-fac1-42fe-ae75-da315822e088@salutedevices.com>
 <f1ed0cff-57ff-4fb3-b102-0a0a6d79f1a9@linux.alibaba.com>
 <9d8a073a-982e-4c7b-9445-623941a16b05@salutedevices.com>
 <16ea58e8-43b7-439b-91db-9f87d2fb2b84@linux.alibaba.com>
 <a28be132-1f08-4ce1-90f9-7732301c9aa3@salutedevices.com>
 <e8bc1c98-e76b-4f02-a834-c0d2ad88ed46@linux.alibaba.com>
 <f68962d5-cce1-4993-a7d2-54c3fb752064@salutedevices.com>
 <cad241fc-c2c6-4872-ab56-be3b7b44fbea@linux.alibaba.com>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <cad241fc-c2c6-4872-ab56-be3b7b44fbea@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.28.3.98]
X-ClientProxiedBy: p-exch-cas-a-m2.sberdevices.ru (172.24.201.210) To
 p-exch-cas-a-m1.sberdevices.ru (172.24.201.216)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Info: LuaCore: 98 0.3.98 ca9d2f3beca9ca2a85e178af9d8e97d5fa2c38a3, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;smtp.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 202167 [Apr 10 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/04/09 21:06:00 #28382314
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5



10.04.2026 13:06, Gao Xiang пишет:
> 
> 
> On 2026/4/10 18:03, Arseniy Krasnov wrote:
>>
>>
>> 10.04.2026 13:01, Gao Xiang пишет:
>>>
>>>
>>> On 2026/4/10 17:59, Arseniy Krasnov wrote:
>>>>
>>>>
>>>> 10.04.2026 12:20, Gao Xiang wrote:
>>>>>
>>>>>
>>>>> On 2026/4/10 16:55, Arseniy Krasnov wrote:
>>>>>>
>>>>>>
>>>>>
>>>>> ...
>>>>>
>>>>>>>>
>>>>>>>> BR2_TARGET_ROOTFS_EROFS=y
>>>>>>>> BR2_TARGET_ROOTFS_EROFS_CUSTOM_COMPRESSION=y
>>>>>>>> BR2_TARGET_ROOTFS_EROFS_COMPRESSION_ALGORITHMS="zstd,22 --max-extent-bytes 65536 -E48bit"
>>>>>
>>>>> btw, may I ask what's the erofs-utils version?
>>>>> erofs-utils 1.9?
>>>>
>>>> We have 1.8.5 erofs-utils
>>>
>>> 1.8.5 shouldn't have `-E48bit` support, that is my question.
>>
>> You mean to try to reproduce with 1.9 utils ?
> 
> Nope, I meant
> 
> BR2_TARGET_ROOTFS_EROFS_COMPRESSION_ALGORITHMS="zstd,22 --max-extent-bytes 65536 -E48bit"
> 
> is invalid in erofs-utils 1.8.5.
> 
> If you were using erofs-utils 1.9+, that may be due to
> the new `-E48bit`;
> 
> but you said you are using erofs-utils 1.8.5, that makes
> me feel confused.
> 

Ah, ok, so need to debug it at kernel side as we talked before.

Thanks

> Thanks,
> Gao Xiang


