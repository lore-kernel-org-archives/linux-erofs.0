Return-Path: <linux-erofs+bounces-2462-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C5EEA4E22
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Mar 2026 15:28:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fPjW53Gcrz3bkL;
	Tue, 03 Mar 2026 02:28:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772465297;
	cv=none; b=GKha5NDrKsIYxWt0TvclTkD+fW/ZFhTQK6zEIkLovFkw/JgQN5esowGXywGHjWJW6aFhv2wCbTHh6pbMYdj+K/CPjkjlNv4e+h8lJbHlr4nRl83+84r5Ow+R2tdJ2FY0G6jk6tMnQ5bz2QhDwY+dcvtLF5OegmmqggmDoHP9wnznbD7BHWchGMMCB5UzbacQGarHKloxoNT0jdwodK/1swBKL7Wr1C/ArV7FHFwbOuPKbBMWe8WYFRcpUBEdaKxYc+h0TNihUHrlP5HM0NMEmbQ+FUe+dDTgQMcFSTx4Q5hP52LMl4zR6dNXfjbcjPbVXM1sFWoDPQTDWTKWNci+lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772465297; c=relaxed/relaxed;
	bh=7s7kxSZqWGizKH/9JQCehT4nLn16OZEHmRU8wOtVczA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KwqmflMKbK63nqUkFWeF6EpQ5eZpeGATkt6Nijqc70rfxXVLv8G+UZwpa2QCDCiy7SNZGG6itKWz3gRyWdYN/xaqQuUtoOH2JEFmXqY/Kr801gCJcTzrk/nWR6ebZpF5zMHdFlbJOmISjBstAnJtoFk1FyCqbHV+7YbhmDD9kRIau8fckYOm0N95BHY7l9a/PYlFn6RaTPEkG1yP0E+R3Ovcg8CJfTcfJw+U17jTakXpnEYbqJal+QfpWU1KxmJQQkCfSaeCxMYkHFKuvuHnKoFGfye9mEceiY/ciLJMlL2aiH1mwezeoWsej6HuO0KsuQkATeku4T7/uRW+3InuYw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZiZPn9dB; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZiZPn9dB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fPjW335Wvz3bW7
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 02:28:14 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772465289; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7s7kxSZqWGizKH/9JQCehT4nLn16OZEHmRU8wOtVczA=;
	b=ZiZPn9dBO/m+wYYS4vtVRbgG2IOs8dCQKnkNiEStf46tQpXSWeO8UXitAZgXVG9pr4gLVytog11396kb6p0Fv7Yx847Ldps080cKkW2ruPif3fTwq46WVoD09KtlwJrY7NKgs93CP+c4ncy8cWWwY45b6VOSqwOyBhma9vfpmaM=
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-65HNa_1772465287 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Mar 2026 23:28:08 +0800
Message-ID: <f1d6133d-e1e2-44a4-9a58-01a917c6e114@linux.alibaba.com>
Date: Mon, 2 Mar 2026 23:28:07 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: fix xattr crash in rebuild path when
 source has xattr
To: Lucas Karpinski <lkarpinski@nvidia.com>, lishixian
 <lishixian8@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: qinbinjuan@huawei.com, caihaomin@huawei.com, caihe@huawei.com,
 wayne.ma@huawei.com, zhukeqian1@huawei.com, jingrui@huawei.com,
 zhaoyifan28@huawei.com
References: <20260302130356.769479-1-lishixian8@huawei.com>
 <f9c910ae-a713-4c85-80bf-e79ca6386f83@nvidia.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <f9c910ae-a713-4c85-80bf-e79ca6386f83@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Lucas,

On 2026/3/2 23:22, Lucas Karpinski wrote:
> On 2026-03-02 8:03 a.m., lishixian wrote:
>> When rebuilding from source EROFS images, erofs_read_xattrs_from_disk()
>> is called for inodes that have xattr. At that point inode->sbi points to
>> the source image's sbi, which is opened read-only and never gets
>> erofs_xattr_init(), so sbi->xamgr is NULL. get_xattritem(sbi) then
>> dereferences xamgr and crashes with SIGSEGV.
>>
>> Fix by using the build target's xamgr when initializing src's sbi.
>>
>> Reported-by: Yixiao Chen <489679970@qq.com>
>> Fixes: https://github.com/erofs/erofs-utils/issues/42
>> Signed-off-by: lishixian <lishixian8@huawei.com>
>> Reviewed-by: Yifan Zhao <zhaoyifan28@huawei.com>
>> ---
>>   lib/rebuild.c | 1 +
>>   mkfs/main.c   | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/lib/rebuild.c b/lib/rebuild.c
>> index f89a17c..f1e79c1 100644
>> --- a/lib/rebuild.c
>> +++ b/lib/rebuild.c
>> @@ -437,6 +437,7 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
>>   		erofs_err("failed to read superblock of %s", fsid);
>>   		return ret;
>>   	}
>> +	sbi->xamgr = g_sbi.xamgr;
>>   
>>   	inode.nid = sbi->root_nid;
>>   	inode.sbi = sbi;
>> diff --git a/mkfs/main.c b/mkfs/main.c
>> index b84d1b4..cb0f0cc 100644
>> --- a/mkfs/main.c
>> +++ b/mkfs/main.c
>> @@ -1011,6 +1011,7 @@ static void erofs_rebuild_cleanup(void)
>>   
>>   	list_for_each_entry_safe(src, n, &rebuild_src_list, list) {
>>   		list_del(&src->list);
>> +		src->xamgr = NULL; /* borrowed from g_sbi, do not free */
>>   		erofs_put_super(src);
>>   		erofs_dev_close(src);
>>   		free(src);
> 
> I was similarly looking at this issue in my patchset so I can confirm it
> fixes the seg fault.
> 
> Tested-by: Lucas Karpinski <lkarpinski@nvidia.com>

Thanks for this, but as I said to lishixian we shouldn't use
global g_sbi in the liberofs anymore.

Could we try to assign sbi->xamgr in the caller instead?

And

> in my patchset

Do you have more urgent fixes? I'm about to release
erofs-utils 1.9.1 since there are some urgent fixes
so fixes would be better to be sent out now.

Also I think we should have a basic testcase to cover
this, I will try to add one this week.

Thanks,
Gao Xiang


