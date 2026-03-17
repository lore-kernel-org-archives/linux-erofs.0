Return-Path: <linux-erofs+bounces-2788-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0F5F3381D
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 09:02:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZmDf3KMRz2yhX;
	Tue, 17 Mar 2026 20:02:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773738130;
	cv=none; b=SjPHH8v+2bNjEwFzFXhVAf4n3jh7iiY/KC0pUmCEcupOZCd0KxEV5ifB4vgFkNtISqwZXVdlBPCv6JItr55zaBVfk7ntdAMJo3QOLinNS/NbCwvwh0SqRGfOGgRRWz9ZthVxCPgPhGTMoEb1oUW/oLi6UCu7BqTqVA73wn3Rdy86Ns70sWCjKqTlDvlDl9fy7s27HfkArFFykR+ZVWxxvF0MR3LWkWJWsPXdB5rpYG+4N1S2VXNxUwgU0RYeIMGmUtlmpRrqWHsSDLQdskPTIEE0wrvgSDkqGayOibz9375AQNTpywFpYeeVZ6N5+MinW8x5mq/KHmA6bBZpD+qhmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773738130; c=relaxed/relaxed;
	bh=b8s3fNEru4H+ywrRmYVvvILJ9TuMiOnN0FZsbaquUHk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jD1U3jxCU19wi3G4Q4TNhCrSQ+xEWpAQygwiy8PuQMiRpuc1MPFHnrsc9sBx4nFyEWdAXwOe10tSavY9imJAEnBZPQ0x0vVj9uibweCxUND+LA1nlN3gyQjnY38uXmzbpnwRhghXu3VcrQxS4FFldZEregfrepFqWWCWXm+BuEUto0Ak3+BCnM3Dp+U/TgCgFdy17qrl3S6C2wqKuTLp2+nH1Ehp/mlkvuyc0/kXLFbAWoanoCayRNR61hx+91DMPoDSx3SZ9TVEiJFz5DLMiWpblKYLux75DsWyZbinzxHkAqwFTv1u9vbSpc68y//dnDVePXMJY3F/Oqaa47LaSA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Nu9cWBeG; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Nu9cWBeG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZmDX0Vw7z2yh4
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 20:02:01 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773738117; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=b8s3fNEru4H+ywrRmYVvvILJ9TuMiOnN0FZsbaquUHk=;
	b=Nu9cWBeG/XE2IaXtYdADMZMmmtjpeYqRWo8Cp91Wr0ln6ZOrCWz/put04dkcETjlAokv3zriZaECjxufKZaiV8mS/LQjoy5F70JlaZopiGB/DktQdYitdcAymJrlLuvXevv+yA7AEeRjbo9+zcYdQtn4+6/WAYegCxgYddZ1a40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.AO0j4_1773738115;
Received: from 30.221.133.143(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.AO0j4_1773738115 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 17:01:56 +0800
Message-ID: <6f30b996-51b6-403f-b343-3935b6464676@linux.alibaba.com>
Date: Tue, 17 Mar 2026 17:01:54 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: validate z_extents against inode size
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: yifan.yfzhao@foxmail.com
References: <20260317082115.34389-1-singhutkal015@gmail.com>
 <09e4e9bf-e214-4b40-8d2f-44596fd7c8e8@linux.alibaba.com>
In-Reply-To: <09e4e9bf-e214-4b40-8d2f-44596fd7c8e8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/17 16:34, Gao Xiang wrote:
> 
> 
> On 2026/3/17 16:21, Utkal Singh wrote:
>> z_extents is read from on-disk metadata and used as the upper bound
>> for extent lookups in z_erofs_map_blocks_ext().  A corrupted value
>> can be arbitrarily large (up to 2^48-1), causing erofs_read_metabuf()
>> to access offsets far beyond the actual extent table.  The resulting
>> garbage is parsed as z_erofs_extent records, leading to wrong physical
>> addresses used for I/O, silent data corruption, or crashes.
> 
> No, I don't think it needs to be fixed since it won't cause any
> harmful behavior if the image is already corrupted.
> 
> Please don't submit any patches like this if you don't have any
> reproducer and i_size is too long can cause overly long time,
> but the image can be valid.
> 
> 
>>
>> Since each extent covers at least one logical cluster, the extent
>> count cannot exceed DIV_ROUND_UP(i_size, 1 << z_lclusterbits).
>> Validate z_extents against this bound at inode initialization time
>> and reject invalid values with -EFSCORRUPTED.
>>
>> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
>> ---
>>   lib/zmap.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/lib/zmap.c b/lib/zmap.c
>> index 0e7af4e..2f679b7 100644
>> --- a/lib/zmap.c
>> +++ b/lib/zmap.c
>> @@ -675,8 +675,26 @@ static int z_erofs_fill_inode_lazy(struct erofs_inode *vi)
>>       vi->z_lclusterbits = sbi->blkszbits + (h->h_clusterbits & 15);
>>       if (vi->datalayout == EROFS_INODE_COMPRESSED_FULL &&
>>           (vi->z_advise & Z_EROFS_ADVISE_EXTENTS)) {
>> +        u64 max_extents;
>> +
>>           vi->z_extents = le32_to_cpu(h->h_extents_lo) |
>>               ((u64)le16_to_cpu(h->h_extents_hi) << 32);
>> +
>> +        /*
>> +         * Each extent covers at least one logical cluster, so
>> +         * the extent count must not exceed the number of lclusters.
>> +         * Reject bogus values to prevent out-of-bounds metadata
>> +         * reads in z_erofs_map_blocks_ext().

How do you define out-of-bounds metadata read? as long as it exists
in the image, and the extent can be parsed correctly, it should be
considered as valid rather than corrupted.

Or if it triggers end-of-device or end-of-image, erofs_read_metabuf()
will trigger EIO instead; or if fails due to some sanity checks, it
should fail in the corresponding logic instead of here.

Please identify which behavior we really need to fix:

  - if some metadata is strictly invalid, we should return corrupted
    image indeed;

  or

  - we just allow such metadata because it defines valid according
    to EROFS on-disk format and never let them generate bad behaviors
    to the system, e.g.

      - Crashes (in that case we should fix the crashes);

      - DOS (we should allow users' interruption, for example
        i_size == 2^48 is valid, but it should take time, what we'd
        like to do is to allow user to interrupt this; rather than
        just set some arbitary meaningless small values).

Thanks,
Gao Xiang

