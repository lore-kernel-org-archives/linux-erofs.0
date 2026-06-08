Return-Path: <linux-erofs+bounces-3526-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FB4CD8C9D
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Jun 2026 05:47:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gYgzn5fhdz2yR5;
	Mon, 08 Jun 2026 15:47:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780897653;
	cv=none; b=VbXRx48swKdYsh7wWqdyJGOpLOJdREIzXV4GOilL0NaK1EzkcfcgVmX26m4Qre8yYA79A9JZlNv+Md28wSlfqMIt+fJfT6S8gK/LOgaGNKuIdoam0qbmYJVcL7ceZkp5dls8S0vg0j7FfzGmuaMs7pSYewETzI14k3LS8+E7mgeYpejkeJMY4NOuIRH3gkN/uQXEwfDnSemaPu/drMjjdFvIRhkugGN/ZrChfjWIV6dStAI1W5XLGQF9RhdWbhbxBAmQ54W7lNzfL5XqlH3Ee6CL4eWGpoUUSCfZbjHwXlMDyNRhnEy6msUPcH9lu14HR7yh2upbkjAI1anvSMgGhg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780897653; c=relaxed/relaxed;
	bh=hlB46HKiYGvKpKR1bCWJmvd0hr/PjEuYmnUd0ykOlgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L3J3AvJY3HdoL7EkYPvxdB+OQiIvDjZZm3fMLRQ4ZFfc+oATNVnOHdxl6HaBGsfYZ/By8BEdQpzvzL9kREwOyO0fnVLACAUItuWf0Keze/aFX4e6w+zxn7WAI+4EgaYMAQ1AqcPN9Ztu+DpEZ3xHmzp/IZMqlmQW3ewuA18fnU8MmW2pmMEukzVlgEHRFrMGIzPAanduQA03wF/m2RfhigDjIJwrl3M+CD1tGkIOuqNkr1jsAU5sG9O9xVsNFvMb06OByt9T8JOF6v0PLM1RmwJ/9dM6FNLVpOi42/27D3ZqLV8xVp1avL+4k+ecnN/htg0JrRUf66pIbawz1gkhPg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bg0M28I0; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bg0M28I0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gYgzj5lQtz2xRs
	for <linux-erofs@lists.ozlabs.org>; Mon, 08 Jun 2026 15:47:26 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780897614; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hlB46HKiYGvKpKR1bCWJmvd0hr/PjEuYmnUd0ykOlgk=;
	b=bg0M28I0HcdxUFIrhGnKl6qgvB2dm+e1uHGlb7XgcfSRreCInNDJGjCjX8xP653hgYz8JyC3gAuosH2pV93+jIkLiwdlkDiXgxS4Ko+RRzRO90sKuog/8hlN1pZyx1XctbSR76Sij0KIE+DQrmopFtS3xIDZ5aie0OH1+NaQKMc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X4Jf1zE_1780897611;
Received: from 30.221.133.92(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4Jf1zE_1780897611 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 13:46:51 +0800
Message-ID: <9ddb3fab-e5b1-4dec-a73b-814e833e208d@linux.alibaba.com>
Date: Mon, 8 Jun 2026 13:46:50 +0800
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
Subject: Re: [PATCH] erofs-utils: build: link tools with liberofs dependencies
To: "zhaoyifan (H)" <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
 guoxuenan@huawei.com, zhukeqian1@huawei.com
References: <20260529071702.981596-1-zhaoyifan28@huawei.com>
 <aiA8AhQvFtK_QMwb@debian> <1c8489d6-c55b-426d-b965-b6b96caa616f@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <1c8489d6-c55b-426d-b965-b6b96caa616f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/7 19:29, zhaoyifan (H) wrote:
> 
> On 2026/6/3 22:36, Gao Xiang wrote:

...

>>> +])
>> Although I admit that I'm not super happy with this approach, but it
>> seems that we have to do like this.
>>
>> My only question here is that why  ${libxxhash_LIBS},  ${libxml2_LIBS}
>> and ${libnl3_LIBS} cannot be appended directly to LIBEROFS_LIBS as
>> others.
> 
> As these flags were conditionally appended to liberofs_la_LDFLAGS in the original lib/Makefile.am code path.

Can we append them into LIBEROFS_LIBS directly?

Thanks,
Gao Xiang

> 
> 
> Thanks,
> 
> Yifan
> 
>> But I think it's fine to guard `-lpthread` with enable_multithreading
>> tho.
>>
>> Thanks,
>> Gao Xiang
>>


