Return-Path: <linux-erofs+bounces-3574-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF013CD98CC
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Jun 2026 03:42:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gc5213F07z3brB;
	Fri, 12 Jun 2026 13:42:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781235769;
	cv=none; b=OBQTSs0i/ApPKMuc+WG5O5d8t2oX197zH7BSbRFU/URX/fGtUCwpl2Lda0XlEWrl9LpWsoywdV/lwtxKbrCLgkhtK5tWN5lokh5C93TNoCCUuC6BVkXGuZLArFfiI3UJFYDNq1l6k/K5Tw1Zxo433L/yM3y3pkaNyl/EcPNISffkp/OYa6l3jxZf+o2kmnkjYzIT7UyS4h4Yz592/DIYEJyva9OtF+Y+viGcZOl6yzPFfuj8/+odVWzjfXFz+I0EWQdkr1QHB2EIDbIPc+3U02nH87J5QXhQ3jtsFWloPVSYnHdatNmJexGa2Napaihs6W06CEYrlsyc0YOAHPuO2w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781235769; c=relaxed/relaxed;
	bh=KlewREvmlKxyUSiB6UGySm1S0lQUskxigHenXGFtImY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oMFsnzIQy4wtqb7lwEh5dUZ0gfPFmY1eOumvWCzOTFcZVwuGFDAG4fya9thPl8LaRAASOf7tIiUNsnF5n7T4AuM/nFGbPUdH06xFhy5DkIo93r81uhXcws0Fgby1deehKhUZaWHtLGBwtCaQUH0WEKTb31UbCnCCi4HdiqITpIIpkSYNAVepDNJhXi1xch6wqLNoKtOTOg/u1AsZM02OCgLECSMcxusvZgBmuIN55ziDqRzd0/dP1BUPlmyLg/UaVONUcCp0qU8GoaKXUlZFeLvuccCtVhznrFuBD7B8CdxgT+amPHgyZOH/EzmOX7NMkm2aKHrPEUXUGKgeGIAuIw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=irLGz5l+; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=irLGz5l+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gc51y5jrVz3bpt
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Jun 2026 13:42:45 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781235761; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KlewREvmlKxyUSiB6UGySm1S0lQUskxigHenXGFtImY=;
	b=irLGz5l+TZ6C5zoR3hDaq6+d54HSHWG4QwVUHzhHj5Jutd4E6DAJ16BujfZag38IivwxPf547x4RH4f9sFP+5cq3hA4HnOnFG6ifEG6olAndOufE7V/o97p96wgsJsBWg7NqO54krJnSOszPwRlYwls9DDwWkK86549g509HbUM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X4fy44o_1781235759;
Received: from 30.221.132.172(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4fy44o_1781235759 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 11:42:39 +0800
Message-ID: <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
Date: Fri, 12 Jun 2026 11:42:38 +0800
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
Subject: Re: [PATCH] erofs: prevent buffered read bio merges across device
 chunks
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, yekelu1@huawei.com, jingrui@huawei.com,
 zhukeqian1@huawei.com
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260612033244.993507-1-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/12 11:32, Yifan Zhao wrote:
> EROFS chunked files may place adjacent logical chunks on different
> devices. The physical block numbers are per-device, so two neighboring
> chunks can still look sector-contiguous to the generic iomap buffered
> read code.
> 
> For example:
> 
>          logical file offset
>          0          8K         16K        24K
>          +----------+----------+----------+
>          | chunk 0  | chunk 1  | chunk 2  |
>          +----------+----------+----------+
>               |          |          |
>               v          v          v
>            dev 1      dev 3      dev 3
>            sector 8   sector 24  sector 40
> 
> The transition from chunk 0 to chunk 1 crosses a device boundary, but
> iomap can still treat sector-contiguous bios as mergeable without
> checking whether they belong to the same device.
> 
> The pending bio, however, is still bound to the previous block device:
> 
>          bio->bi_bdev = dev 1
> 
>          file 0..8K   -> dev 1, sector 8
>          file 8..16K  -> dev 3, sector 24
>                           (must not be added here)
> 
> If the second range is added to the same bio, it will be submitted to
> dev 1 and read from the wrong backing device, which is easy to trigger
> with readahead.
> 
> This only affects paths using erofs_aops, where buffered reads go
> through iomap bio helpers.
> 
> Fix by install EROFS-specific iomap read ops and split the pending
> buffered read bio whenever the next mapped range belongs to a different
> bdev. After the split, fall back to the generic iomap bio read helper
> for the normal sector-based merge checks.
> 
> Reported-by: Kelu Ye <yekelu1@huawei.com>
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>

I think it's an iomap bug instead, see:

iomap_bio_read_folio_range(), we should fix iomap instead.

Thanks,
Gao Xiang


