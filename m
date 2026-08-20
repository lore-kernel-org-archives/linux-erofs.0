Return-Path: <linux-erofs+bounces-4269-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 528E1C5DF85
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:36:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQkx15WqMz2xWR;
	Thu, 20 Aug 2026 23:36:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787232981;
	cv=none; b=G1X4u0uKUZxq7g0UB7dGIw0aB7uiZbnJQIVdZZfpjpbGBvXRibpvCyXeKd4meF4uuenFHoCr2LfWOP/zlgb1xkPs+f1Al+TW5njmh9rPrdPE5YdT5OX8oifmfzXBeKeU+7qev8566QmzWFn3ocOTlgKqCjD+Xw7hsVFJB2/GATu2G/j7w3Fj2NUxJCncivR6RZcEDhZg6xJIcehQjEupnNZEaVJrEPCbnwpRihNMP+kRpq40FEffx7AA47rFZE5UuX3/56K0NZ5jjgCfUrvdDOg0u6hH7raXjQaQ7ui2c5C2VWSnCcdUwGzmKSHU3fOBiYbK9X8gotHx/w+SiNKr1A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787232981; c=relaxed/relaxed;
	bh=CwcEUbYO4HWf1Px33ZovDCtsznzv2AsinQ8h6cepSGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Bk3d44Jk6H8meCfYZgwZzPbo89nFSiliCACm2rN/Fs1TfFvj9QYlmoIIA0G+wZjY+Xo5fCqeQ0NHm9HyFur2R1/pE1Kdm9ILq/HUPkRpTvg10CmVCXb/pfxnxIjtEDparIA2XaVve+zOe3YjvihtIRU4bhoTWNexMkQeV1Nx5aEeC0uLwfFpHu6S8hfORU3krOreUjsgKopj3hqK7Q4rwMsMhZZi2feCJbvBIXje7bBbnPkt8dXBRuCjucdYS7V2B3fTuRnq9f+CTwK2rsQfJIl0hm2XlIu5rfg4mse89gwhTuTQuY/Kn3MwjU7tg2rfZCmuzh8+Ne/ulBSjYvWYQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pcCqHOAg; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pcCqHOAg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQkx04zq7z2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:36:00 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787232955; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CwcEUbYO4HWf1Px33ZovDCtsznzv2AsinQ8h6cepSGU=;
	b=pcCqHOAg91/E5ehWDgraCmcK0AfLojgWE2c0ttK/8i9+66srrhFh4r8tA7OzVjkesV5GducqHIizM+il9Z2AY8YrGZr7d2oEj0WtJBpEsaVUc7mQ6n80Eb49hFTpvB6OHuGlRkdMcAlMuNepcN0G1+IocOOY9nJEn8su/3laGH8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9Jd65l_1787232952;
Received: from 30.42.155.165(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9Jd65l_1787232952 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 21:35:53 +0800
Message-ID: <eb253f13-11a3-4728-b3d6-dc2c336c66cc@linux.alibaba.com>
Date: Thu, 20 Aug 2026 21:35:52 +0800
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
Subject: Re: [PATCH] erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
To: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260818113713.116849-1-jefflexu@linux.alibaba.com>
 <aocCPbxFolZd_VIk@XiangdeMacBook-Pro.local>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <aocCPbxFolZd_VIk@XiangdeMacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/26 9:33 PM, Gao Xiang wrote:
> Hi Jingbo,
> 
> On Tue, Aug 18, 2026 at 07:37:13PM +0800, Jingbo Xu wrote:
>> When inode_share is enabled, erofs_ishare_fops.llseek falls back to
>> generic_file_llseek, which treats the whole file as data and always
>> returns i_size for SEEK_HOLE, hiding real holes in sparse files.
>>
>> Switch it to erofs_file_llseek instead.  For user files f_mapping->host
>> is always the real erofs inode, so SEEK_HOLE/SEEK_DATA resolve the
>> per-file on-disk layout via iomap_seek_hole()/iomap_seek_data().
>>
>> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
>> ---
>>  fs/erofs/data.c     | 2 +-
>>  fs/erofs/internal.h | 2 ++
>>  fs/erofs/ishare.c   | 2 +-
>>  3 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
>> index d2f01245ee79..09d668deb86d 100644
>> --- a/fs/erofs/data.c
>> +++ b/fs/erofs/data.c
>> @@ -509,7 +509,7 @@ static int erofs_file_mmap_prepare(struct vm_area_desc *desc)
>>  #define erofs_file_mmap_prepare	generic_file_readonly_mmap_prepare
>>  #endif
>>  
>> -static loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
>> +loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
>>  {
>>  	struct inode *inode = file->f_mapping->host;
>>  	const struct iomap_ops *ops = &erofs_iomap_ops;
>> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
>> index 57bd21859c65..3263c11d714c 100644
>> --- a/fs/erofs/internal.h
>> +++ b/fs/erofs/internal.h
>> @@ -528,6 +528,8 @@ static inline struct inode *erofs_real_inode(struct inode *inode, bool *need_ipu
>>  }
>>  #endif
>>  
>> +loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence);
>> +
> 
> Could you move this line below erofs_fiemap()? I hope all declarations
> in data.c are closer.

Sure.

> 
> Otherwise it looks good to me,
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> 
> Also could you help write a test for this functionality too?

Will post the test later after posting v2.

-- 
Thanks,
Jingbo


