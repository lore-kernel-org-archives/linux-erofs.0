Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15261C6FD1F
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Apr 2024 03:24:34 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=W+haD803;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4V8VV924xDz3bfS
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Apr 2024 14:24:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=W+haD803;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4V8VV25Qt2z3bfS
	for <linux-erofs@lists.ozlabs.org>; Wed,  3 Apr 2024 14:24:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1712114661; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7gEdQsMetpeSfZ07Kmis8GONB8g1zUj2Z/WnZOuRM88=;
	b=W+haD8031K6pAqTosR1UpWFkQu5wPUore5OSd4bDVeVM0iAoOcs4AVQNAd573lHZ5SlswbyevyQ/GLS0mxy3Am/z6QdolyZUb/sA6eYAWjcaAI2G2C+XnC8Chrex2pTzvx28ewHcc6XZHpDulcfIw7atQEUxEDLMBQnBynP4JNs=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0W3qE47i_1712114658;
Received: from 30.97.48.165(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W3qE47i_1712114658)
          by smtp.aliyun-inc.com;
          Wed, 03 Apr 2024 11:24:19 +0800
Message-ID: <e6800de8-a07a-48ea-8866-38ce41cfa506@linux.alibaba.com>
Date: Wed, 3 Apr 2024 11:24:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] erofs: add a reserved buffer pool for lz4
 decompression
To: Chunhai Guo <guochunhai@vivo.com>, xiang@kernel.org
References: <20240402131523.2703948-1-guochunhai@vivo.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20240402131523.2703948-1-guochunhai@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
Cc: linux-erofs@lists.ozlabs.org, huyue2@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/4/2 21:15, Chunhai Guo wrote:
> This adds a special global buffer pool (in the end) for reserved pages.
> 
> Using a reserved pool for LZ4 decompression significantly reduces the
> time spent on extra temporary page allocation for the extreme cases in
> low memory scenarios.
> 
> The table below shows the reduction in time spent on page allocation for
> LZ4 decompression when using a reserved pool. The results were obtained
> from multi-app launch benchmarks on ARM64 Android devices running the
> 5.15 kernel with an 8-core CPU and 8GB of memory. In the benchmark, we
> launched 16 frequently-used apps, and the camera app was the last one in
> each round. The data in the table is the average time of camera app for
> each round.
> 
> After using the reserved pool, there was an average improvement of 150ms
> in the overall launch time of our camera app, which was obtained from
> the systrace log.
> 
> +--------------+---------------+--------------+---------+
> |              | w/o page pool | w/ page pool |  diff   |
> +--------------+---------------+--------------+---------+
> | Average (ms) |     3434      |      21      | -99.38% |
> +--------------+---------------+--------------+---------+
> 
> Based on the benchmark logs, 64 pages are sufficient for 95% of
> scenarios. This value can be adjusted from the module parameter.
> The default value is 0.
> 
> This pool is currently only used for the LZ4 decompressor, but it can be
> applied to more decompressors if needed.
> 
> Signed-off-by: Chunhai Guo <guochunhai@vivo.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
