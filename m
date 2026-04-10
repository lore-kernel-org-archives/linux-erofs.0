Return-Path: <linux-erofs+bounces-3267-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7451E9905E
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 09:21:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsWWJ21c4z2yZ6;
	Fri, 10 Apr 2026 19:21:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775812860;
	cv=none; b=egr9iNchqvkxDIcZAp4xME8YSDPu+DS89oQABEfssfLlRD65tttVaqTHlAgAN/VBBkX82VLtnd9qfoFE668L+TRXQNiGF96vknd/58YpG8OrWOAOe7mAsPVNRVfx1I0Z3jx3NxPj60nVh1tluoJivUrMIFzkq6+beB1wvSFCTWJsQrTzH0o7+iwfZZTpctvoDz8E4TFDo+3hqQPe2GSSEkpbJlv1HIPobOsQiFwVZpA3zvrOxg8WeD9FqEY4+aX1/kgi8Fol2ni+Jwqee6LXsnEYm74tvfpRG9w5GMv8kFJGPrEkaM86Ss86Iam6ln+lXmiCRn4oA3Q3O5Q6oLoKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775812860; c=relaxed/relaxed;
	bh=wnWcYguAqwjF8FcXrJmbksHV5AKeP1VA/I33KJYK2h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7tqKR6nL5LSm+8Tl06SCVwJigDLtpkx4TS1ZMmbUEiauAsLIEuR36PsXr3jAvSaOU6/YUgt0nHYlYyhuD7cQ1zSG5E5mTyRA44ljFvqpr4bnKaFZJdGd+vxE5V009G+oWpCCxFOw6xPKvYXjhjXH1+7DAKGbSqI9YrHUcNL4Z7SsSAnk9PY4t4zogo9I2Wwt4wY7sOjGft9bHyusXhsxI1vchREY88INfQgNZ5VyF41tCjUUx8xKgkmrFDu3vQQKk7TA+dmdyDnJWCofAw1Bn+gR4o7a2CV1xvOq7zVvRhsFE6mkEscUgFuHav4PLCuGP8ZdhRZPvsb+nL7Fd/POQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OoHbOBmb; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OoHbOBmb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsWWF5DRFz2xT6
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 19:20:56 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775812852; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wnWcYguAqwjF8FcXrJmbksHV5AKeP1VA/I33KJYK2h8=;
	b=OoHbOBmbGFqGbfL2Fxlw4LTy8zL2m7Cxr8m3sU35Ia11N1T3Lr41j9ZSGUcHGVtR03ttviZQWobY04lSiqYmcC3O+/4nQpvqgK+qGeV8ZkDreSiXBa1Bd7e9sSpCDkafErBh9xHoT973Z7PTV0mIf3mCY1WEbUHIIgaGTP2Qlzs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0ksjaY_1775812850;
Received: from 30.221.132.105(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0ksjaY_1775812850 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 17:20:51 +0800
Message-ID: <16ea58e8-43b7-439b-91db-9f87d2fb2b84@linux.alibaba.com>
Date: Fri, 10 Apr 2026 17:20:50 +0800
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <9d8a073a-982e-4c7b-9445-623941a16b05@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/10 16:55, Arseniy Krasnov wrote:
> 
> 

...

>>>
>>> BR2_TARGET_ROOTFS_EROFS=y
>>> BR2_TARGET_ROOTFS_EROFS_CUSTOM_COMPRESSION=y
>>> BR2_TARGET_ROOTFS_EROFS_COMPRESSION_ALGORITHMS="zstd,22 --max-extent-bytes 65536 -E48bit"

btw, may I ask what's the erofs-utils version?
erofs-utils 1.9?

I guess it's related to a relatively new experimental
feature (-E48bit + encoded extents + zstd) introduced in v6.15.

If you don't use this new feature, the issue may not be
reproduced anymore.

Thanks,
Gao Xiang


>>> BR2_TARGET_ROOTFS_EROFS_FRAGMENTS=y
>>> BR2_TARGET_ROOTFS_EROFS_PCLUSTERSIZE=65536
>>>
>>>
>>>
>>> May be You know how to fix it or some ideas? Because we are new at erofs and need to discover and
>>> learn its source code.
>>>
>>> Thanks
>>


