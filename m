Return-Path: <linux-erofs+bounces-3269-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4C0E99069
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 10:01:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsXQS3VR6z2yZ6;
	Fri, 10 Apr 2026 20:01:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775815312;
	cv=none; b=JG0x/r7yAidlrT6nISQ9UFhNM/gvQ6aRSCGzuHfKcXxoTj9ZWqCzpq204fONM6rLtLwPGNQ9AUDscUVhdAC64BodIpjyEU+FYHurm3Hl7qY/ZkOimNywKYjIUgGbfToPJnZtHLMs0FEIkIfo0WHYeGtPmMf+LpU5Bfz054wOS2noDcLz50B5n/WaR3Wndc+yhDwg+5nuQbWEr2Vv4rQzmKC5+B40itwOVyc2md7hVbSBT7vnQZZV7WM7HSpRZ1GRJXIGmsFY1Y7bee/rDE+HGGGTIbrZ1Ekec96wXhoyxz0SQjFlbZfeyUJypthMqwiNUloacWbnrkl7TZh964J0fw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775815312; c=relaxed/relaxed;
	bh=v6PwKHJlF21wBeLGxKNRLt3rT4RxrxBYzsmqRJOlFhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kjosgFMFhWA2qlPVwBKH/9+z6mRczPj71XlBg4uoaBKi+SusKPiTnWr4ilBg0lXu3zvE+gJuiYJD8bS+A2hZFCYb5yPuCmcbxHr7VYWZK7SC0DIHN8k+WiTkEt5k/aKgg0inz00sKbbaULhiHdxiXZeLTEo/1T5RE9emRFlBCHCkPXsFuQ5uDdytxtnNyMJju9votlcIoEHOP8YcbGDmk91r0mrncG98DgG7LP4zNHaRcl+0+sF7WixL1Ltbpc2pwLgY0OGaza1SwEWJzziUuJ6PEAR25VirT830dLhcoS/hzZrgnx+I2FLik1YWNjReye/rDInYwVfwrles8jwFtQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=U6T1WLOr; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=U6T1WLOr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsXQQ2WBbz2yYy
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 20:01:49 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775815305; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v6PwKHJlF21wBeLGxKNRLt3rT4RxrxBYzsmqRJOlFhk=;
	b=U6T1WLOr3H3nldQ/bQooge2f5eZVHUoyhOBzJulvom5cZR9NKZmi36+QkrYVLk9EsNiVeuA5V6W/6p5c5BtszKcQPh82nsoEf1gF+4i3IO0ocO1bk1I6QpSB7HNFf186mxYyuIzb2rj8tANfC11GYODZvXVJB+6i+OwHOIrF2h4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0kt-tP_1775815303;
Received: from 30.221.132.105(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0kt-tP_1775815303 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 18:01:43 +0800
Message-ID: <e8bc1c98-e76b-4f02-a834-c0d2ad88ed46@linux.alibaba.com>
Date: Fri, 10 Apr 2026 18:01:41 +0800
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <a28be132-1f08-4ce1-90f9-7732301c9aa3@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/10 17:59, Arseniy Krasnov wrote:
> 
> 
> 10.04.2026 12:20, Gao Xiang wrote:
>>
>>
>> On 2026/4/10 16:55, Arseniy Krasnov wrote:
>>>
>>>
>>
>> ...
>>
>>>>>
>>>>> BR2_TARGET_ROOTFS_EROFS=y
>>>>> BR2_TARGET_ROOTFS_EROFS_CUSTOM_COMPRESSION=y
>>>>> BR2_TARGET_ROOTFS_EROFS_COMPRESSION_ALGORITHMS="zstd,22 --max-extent-bytes 65536 -E48bit"
>>
>> btw, may I ask what's the erofs-utils version?
>> erofs-utils 1.9?
> 
> We have 1.8.5 erofs-utils

1.8.5 shouldn't have `-E48bit` support, that is my question.

Thanks,
Gao Xiang

