Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A4BC4345F
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Apr 2024 08:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1713948311;
	bh=VYO5JujBqFYVef45KN1r1Z6DoRGEiTAQ2ROrnpy89Ns=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=DsWTmfmYg+rY/hFG3Bd2A/KJ1YxktRMR7oAFe9UI2MaUzh9DK+GdxSdv/xjvMYNEM
	 QaR3EWdf+H7mhdScY5bu5W7qLtBDIcc7dy3wKZHSvCAZj4cOl9t4eclEbLZE1ryEm3
	 j4UYXHPig7awyTKmTe18H1sBc71d6UEhDLAc8xUpZaYdKphI+Em/TNzNLemiQsoTg8
	 XsR/UQEf3sIP9pDuNr75yQxLAm7bTTT3kc1gu8WxoDDuwagMYwO8zyY8MGGMyU9kyt
	 Piw61o+QOCMni0S2dCmmqYdgWyduwEJJ/csSAZ7F7xA8t9kvZcszqd03jsoPaPoJJV
	 J4nLUrNkNiYiQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VPXcR5cVqz3cSS
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Apr 2024 18:45:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 139 seconds by postgrey-1.37 at boromir; Wed, 24 Apr 2024 18:45:02 AEST
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VPXcG3Dq8z3cDk
	for <linux-erofs@lists.ozlabs.org>; Wed, 24 Apr 2024 18:45:02 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VPXWx2KVVzwSZg;
	Wed, 24 Apr 2024 16:41:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 041921800C2;
	Wed, 24 Apr 2024 16:44:28 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 16:44:27 +0800
Message-ID: <7ae4a071-56b3-410b-9c95-d6677dc46f25@huawei.com>
Date: Wed, 24 Apr 2024 16:44:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] erofs: modify the error message when
 prepare_ondemand_read failed
Content-Language: en-US
To: Gao Xiang <hsiangkao@linux.alibaba.com>, <xiang@kernel.org>,
	<chao@kernel.org>
References: <20240424023945.420828-1-lihongbo22@huawei.com>
 <871467f7-1218-4c13-ae47-13e89bbbe0cc@linux.alibaba.com>
In-Reply-To: <871467f7-1218-4c13-ae47-13e89bbbe0cc@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Hongbo Li via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Hongbo Li <lihongbo22@huawei.com>
Cc: huyue2@coolpad.com, linux-erofs mailing list <linux-erofs@lists.ozlabs.org>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

ok, thanks!

On 2024/4/24 11:29, Gao Xiang wrote:
> 
> (+cc linux-erofs & LKML)
> 
> On 2024/4/24 10:39, Hongbo Li wrote:
>> When prepare_ondemand_read failed, wrong error message is printed.
>> The prepare_read is also implemented in cachefiles, so we amend it.
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> 
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> 
> Could you resend the patch with proper mailing list cced with my
> "reviewed-by:" tag?  So I could apply with "b4" tool.
> 
> Thanks,
> Gao Xiang
> 
>> ---
>>   fs/erofs/fscache.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
>> index 8aff1a724805..62da538d91cb 100644
>> --- a/fs/erofs/fscache.c
>> +++ b/fs/erofs/fscache.c
>> @@ -151,7 +151,7 @@ static int erofs_fscache_read_io_async(struct 
>> fscache_cookie *cookie,
>>           if (WARN_ON(len == 0))
>>               source = NETFS_INVALID_READ;
>>           if (source != NETFS_READ_FROM_CACHE) {
>> -            erofs_err(NULL, "prepare_read failed (source %d)", source);
>> +            erofs_err(NULL, "prepare_ondemand_read failed (source 
>> %d)", source);
>>               return -EIO;
>>           }
