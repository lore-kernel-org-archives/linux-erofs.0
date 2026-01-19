Return-Path: <linux-erofs+bounces-1976-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3380BC9830C
	for <linux-erofs@archiver.kernel.org>; Mon, 19 Jan 2026 01:45:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dvYDl64QQz2xS5;
	Mon, 19 Jan 2026 12:45:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768787111;
	cv=none; b=G9MqZvFDrRlqxf/Yu/h1IvkIEyLWloNUpYu38wtuJPsGKQWkkJjrbMo2FERRNXMvN//ElsLYWNPjB5lv+0zwRzREGDZG1cW7oo69vdG/Yv4T1nffcGsSwohLm2D2BPaKNjX3RJktReJDM2jTv1dACOr4bIrBl6NSm/QC3elqhx7ZZYbAbmmODUUPj2oNRXerogpLiZhK6mIiECz/0Er/zeSo9Ql6QAUdbBhONJA4TnvVqQcq0vInEICKwi3Ae9p9fiUiUDRn0PB/OgFBteh2bjj42knbKRPzg4xbiT37anr0yCeVS2ytYJYwMBW3EvUM8F0zku6HQLWb/Apc98TRYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768787111; c=relaxed/relaxed;
	bh=70OK0vfG6EdaS0YAPabCTxwfq6NC1XRXCyBnAyA6LFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L1yocZKoeLDijMV5gRT8t81ZXa9cWqATyY/Q3hvfpHw7tocH//n9loh1Qs190ylt6hwABr0+TXyVjoNSGoCw8ak8dpxdc+BPBO1ITDQEpNqBLER+jKu9UjhYz4BKztNfpxDvuIPh4rQ9l18t2gDbH/BEqrIUtnT5wPwn38Le5EGyW9nGstnAmBS8Prxtv38mfz65BdptELQpZRzUHBdt19teIwqHWeuQdcV580+rvVnRL0ZJBv3LBD2CWz4iuPOHjHRThZfOBGyzsinfyLJHERUq3I+2A0TNuv6tqRwXtD5hC3etSLueTDnWAQoryqJZX0use0n5Q+nPM8+2glpfrw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SnLenq9K; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SnLenq9K;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dvYDj2cGLz2xRm
	for <linux-erofs@lists.ozlabs.org>; Mon, 19 Jan 2026 12:45:07 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768787102; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=70OK0vfG6EdaS0YAPabCTxwfq6NC1XRXCyBnAyA6LFo=;
	b=SnLenq9Kh4J6eHO6QnW55tvcjj9JstXBIjdOZ6WwNda3a2b+9M4wcCy6+RdQiVf/3quw72gHFD85GtKHT1GLCYFAVk2OHi+nTzRv9bGjBW2LuJU+58DRtMwnN/Bcilr5HDQAFK1rBSVA2oFQxTiyOUenQOSurH6d6Mi5zuK72PU=
Received: from 30.221.131.184(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WxHDcRg_1768787100 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 19 Jan 2026 09:45:00 +0800
Message-ID: <e4a45ea4-a0e9-4b8e-ab8b-b4dbb6a2ba21@linux.alibaba.com>
Date: Mon, 19 Jan 2026 09:44:59 +0800
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
Subject: Re: [PATCH v15 2/9] erofs: decouple `struct erofs_anon_fs_type`
To: Hongbo Li <lihongbo22@huawei.com>
Cc: chao@kernel.org, brauner@kernel.org, djwong@kernel.org,
 amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20260116095550.627082-1-lihongbo22@huawei.com>
 <20260116095550.627082-3-lihongbo22@huawei.com>
 <20260116153829.GB21174@lst.de>
 <c2f3f8bd-6319-4f5a-92cf-7717fa0c0972@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <c2f3f8bd-6319-4f5a-92cf-7717fa0c0972@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/19 09:34, Hongbo Li wrote:
> Hi, Xiang
> 
> On 2026/1/16 23:38, Christoph Hellwig wrote:
>>> +#if defined(CONFIG_EROFS_FS_ONDEMAND)
>>
>> Normally this would just use #ifdef.
>>
> How about using #ifdef for all of them? I checked and there are only three places in total, and all of them are related to FS_PAGE_CACHE_SHARE or FS_ONDEMAND config macro.

I'm fine with most cases (including here).

But I'm not sure if there is a case as `#if defined() || defined()`,
it seems it cannot be simply replaced with `#ifdef`.

Thanks,
Gao Xiang

> 
> Thanks,
> Hongbo


