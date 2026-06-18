Return-Path: <linux-erofs+bounces-3673-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B72BCD98F2
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Jun 2026 10:54:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ggyJx2KVdz2yRF;
	Thu, 18 Jun 2026 20:54:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781780049;
	cv=none; b=GlvM7SBgJrL3nLdNZVyDWcLpjdleexI5vnuE8A3wejDzY94G2eEqjqk80p+RYPgBhiSfoVPKcH61OmBf/Ke1VcP2omomU8hb3D4lPwuYq1Z2aLGSBs7ldMlRaoQnP0fYneIQVaxQMjZS+Z8B8usuY0YAe4aZYC6BVenRcBUGTEHRD+p8SjYNLyxu8KcWGMcJPQH9T3JjgnCJf4AEran/R8yTp/ss9Wm++ARlU/oQ15jg3Nr47T3iHpkLYeXlXqLrSH3N+Vc/CMvNMXNhhndFM/twQpTJ8u/pnQtpVRdu22639GuCfgUXX+3eYaWNqwDTMWr3yWMA+kX29488hFu3Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781780049; c=relaxed/relaxed;
	bh=tEOH4b2VpB+R+W//mgS8StroH3m8ebqKTodvw52Ib3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=br4mtm6dJBKr0RJv/OsK+1Gh2hKVfGsxDjPjC5F5eis+oyUoXLDB8BCmQP4l1XqAhpfjiYgA6SsAcaSHClB+ezBvFambyAlVbLPPzUTv/qHDQOywlNdOGkiQ2hF1CjVHNPE6Nj0eywF9PdAscTpXgj6fEHh0x30j2Gy79vDYcjWg/EbBJK17dvOOnVV4fH3Pp5r+WGaX/o3pO9rscbuhWgrbFI79Y/Nc4e4yOZ9GfyzlvKPSgKmo8f3DWZWb05ra507d4PiJGlzruakMB6YRwvYEy6oUTRYuw002EjeVLEKX7nlXt2h86De6YSRePfRD5JfOhCwb1KzZDYrDOw6Tbw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NZIXrNJF; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NZIXrNJF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ggyJv1D7Mz2yNn
	for <linux-erofs@lists.ozlabs.org>; Thu, 18 Jun 2026 20:54:05 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781780041; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tEOH4b2VpB+R+W//mgS8StroH3m8ebqKTodvw52Ib3A=;
	b=NZIXrNJFC5swS3UAlS7lX3zhmoXeH6mO6wDdsNNoPpqqv6E5aIFTcjlurVx03T1q1BTrsTfsvBNNDRHpjuLQoUHGNJKq/WZo6ONey4/6PjUjihOtqW402wK4DRXa2UcXanI/YFJlK9SY6IU4S9ItffWZLtrs+kA1jKPVBHAusk0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X56mOtU_1781780038;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X56mOtU_1781780038 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 18:53:59 +0800
Message-ID: <256c70c6-d4aa-493c-b777-ea9ab6298c93@linux.alibaba.com>
Date: Thu, 18 Jun 2026 18:53:58 +0800
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
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
To: Christoph Hellwig <hch@infradead.org>
Cc: "zhaoyifan (H)" <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, yekelu1@huawei.com, jingrui@huawei.com,
 zhukeqian1@huawei.com, Ritesh Harjani <ritesh.list@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
 <ajOzy2NPD2GlXcNt@infradead.org>
 <7a38b823-59f3-419e-9070-cbc848f6f1fe@linux.alibaba.com>
 <ajPIIU1JB9e0ksBt@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ajPIIU1JB9e0ksBt@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/18 18:27, Christoph Hellwig wrote:
> On Thu, Jun 18, 2026 at 06:14:03PM +0800, Gao Xiang wrote:
>> I think this patch can go alone seperately because the
>> correctness is okay and cross-subsystem git merge is
>> a bit of churn.
>>
>> I've pushed an chunk merging patch individually to -next
>> for this cycle too, and it should fix too many bios issue,
>> but even without that patch it won't impact the correctness
>> (just less performant.) I assume both patches will upstream
>> in the near future.
> 
> Thanks.  I'll get this patch dusted up for a formal submission in a bit
> and will send it out.

Thanks for the patch in advance too.

Thanks,
Gao Xiang

