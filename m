Return-Path: <linux-erofs+bounces-3359-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D6DFF885C
	for <linux-erofs@archiver.kernel.org>; Sat, 25 Apr 2026 15:29:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g2tzs302Rz2yYy;
	Sun, 26 Apr 2026 01:29:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1777130985;
	cv=none; b=P5nDVKRdhOddOe0APJgb9T5bWUotcJKl+9UYiHRnFcccPE5WokN6B1dIooGtPfd+5uvDgd2SrQlIwpWCZF9/3V0ACiPmVKcqjDCHWdSCym6QUkjkvt23fMANoRDi4mOyA8iWNfsuARNxBPFetm3jnqNCLNgqUy9t4NG+PRAlhF62n0V9SLM2z8RytAYwmRdfARcfYB76uxjOVi1gXBjEG/mCEO4y6X6uz479+UPNOv7jABhhi47pA1csxB6h2NFbQUeDzwumj523vEN9M59h2/vq+bOOrcE5mwfRrGcjoWXoEPkySIBWd15Vs1lF5eOpUwa7LFsJhHvzPOOLL6ZpAw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1777130985; c=relaxed/relaxed;
	bh=tuDUt9pwsTk6e1kR3YBYzwkqe1tEwTwHmCrl+PeuNho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ne3ClZgWbo8RWTzdqcZ/1PigMQCq13QmBcn2WFTDhkN6geRqqeckjC4/MCna2NtNWhVFxozsydavxo5gXanCueNHWja6kI87Yf/lLMkZSrFEmHGLHeKpx7KMxIih5ItuLsdjr9de9lUeHJ4j7AzY6mxIZMr12m/40suum/7OjAwExQfXLzlXtjFouJ1iLDKVgUw4X6ZrWqWbPnX3iSijjcg1XqSWd6R5NkKtYugL2/zFJ6j0ijbDq9utrxmE9r1pRbZ+eJu493tOYHYvptA4OQphsbYxZLQc9GTh4IXaDInUlqWzlcks0pC0JZplJ4imzWmdn+4TR/ZS228SYjJHxA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nnLdCOPx; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nnLdCOPx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g2tzq2Z6sz2yTQ
	for <linux-erofs@lists.ozlabs.org>; Sun, 26 Apr 2026 01:29:41 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777130976; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tuDUt9pwsTk6e1kR3YBYzwkqe1tEwTwHmCrl+PeuNho=;
	b=nnLdCOPxFLGU8+mN7W3g3mnYn6heAd7M2BiShmaSDRf9hl4Uax7DvBWtnPoOOWO5e4VFwLwQ2oa+cxq8qI+9CpXtnx5wHBhTcqdKkUA9Ls6KvuaXKjEoI27ceisuWC+R+EHME3aA4bWipSjNRh33TNzq1Dyt6xMrWNdcRYoCjhE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X1f69zC_1777130972;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1f69zC_1777130972 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 25 Apr 2026 23:29:33 +0800
Message-ID: <f5789b4d-512b-4596-af79-cd2b80172b88@linux.alibaba.com>
Date: Sat, 25 Apr 2026 23:29:32 +0800
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
 Gao Xiang <xiang@kernel.org>
References: <4a2f3801-fac1-42fe-ae75-da315822e088@salutedevices.com>
 <f1ed0cff-57ff-4fb3-b102-0a0a6d79f1a9@linux.alibaba.com>
 <2e916997-0557-45e7-831a-b436c07c5ba4@salutedevices.com>
 <c2d7d5ff-237d-48b5-82a2-ac4618f055cc@linux.alibaba.com>
 <97ca00c7-822d-4b57-9dc0-9b396049adc9@salutedevices.com>
 <8c0bdfab-dbf2-4f1e-8e2a-ce18f166d841@linux.alibaba.com>
 <2ca3c8c6-f3ed-40ca-8f5c-1b43df479ad7@salutedevices.com>
 <36cddf44-3e08-4a19-82ed-04ca178ffab5@linux.alibaba.com>
 <15702a84-ea4f-4d12-b9e5-a37a4c3bb014@salutedevices.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <15702a84-ea4f-4d12-b9e5-a37a4c3bb014@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Arseniy,

On 2026/4/13 15:20, Arseniy Krasnov wrote:
> 
> 
> 13.04.2026 10:08, Gao Xiang пишет:
>>
>>
>> On 2026/4/11 23:10, Arseniy Krasnov wrote:
>>>
>>>
>>> 10.04.2026 18:41, Gao Xiang пишет:
>>>> Hi Arseniy,
>>>>
>>>> On 2026/4/10 21:27, Arseniy Krasnov wrote:
>>>>>
>>>>>
>>>>> 10.04.2026 15:20, Gao Xiang пишет:
>>>>>>
>>>>>>
>>>>>> On 2026/4/10 19:37, Arseniy Krasnov wrote:
>>>>>>
>>>>>> (drop unrelated folks since they all subscribed erofs mailing list)
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> 10.04.2026 11:31, Gao Xiang wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 2026/4/10 16:13, Arseniy Krasnov wrote:
>>
>> ...
>>
>>>>>>>>
>>>>>>>> I need more informations to find some clues.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> So reproduced again with this debug patch which adds magic to 'struct z_erofs_pcluster' and prints 'struct folio'
>>>>>>> when pointer in 'private' is passed to 'erofs_onlinefolio_end()'. In short - 'private' points to 'struct z_erofs_pcluster'.
>>>>>> First, erofs-utils 1.8.10 doesn't support `-E48bit`:
>>>>>> only erofs-utils 1.9+ ship it as an experimental
>>>>>> feature, see Changelog; so I think you're using
>>>>>> modified erofs-utils 1.8.10:
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/ChangeLog
>>>>>>
>>>>>> ```
>>>>>> erofs-utils 1.9
>>>>>>
>>>>>>     * This release includes the following updates:
>>>>>>       - Add 48-bit layout support for larger filesystems (EXPERIMENTAL);
>>>>>> ```
>>>>>>
>>>>>> Second, I'm pretty sure this issue is related to
>>>>>> experimenal `-E48bit`, and those information is
>>>>>> not enough for me to find the root cause, so I
>>>>>> need to find a way to reproduce myself: It may
>>>>>> take time; you could debug yourself but I don't
>>>>>> think it's an easy task if you don't quite familiar
>>>>>> with the EROFS codebase.
>>>>>>
>>>>>> Anyway I really suggest if you need a rush solution
>>>>>> for production, don't use `-E48bit + zstd` like
>>>>>> this for now: try to use other options like
>>>>>> `-zzstd -C65536 -Efragments` instead since those
>>>>>> are common production choices.
>>>>>
>>>>> Ok thanks for this advice! One more question: currently we use this options:
>>>>> "zstd,22 --max-extent-bytes 65536 -E48bit". Ok we remove "zstd,22" and "E48bit",
>>>>> but what about "--max-extent-bytes 65536" - is it considered stable option?
>>>>> Or it is better to use your version: "-zzstd -C65536 -Efragments" ?
>>>>
>>>> I'm not sure how you find this
>>>> "zstd,22 --max-extent-bytes 65536 -E48bit" combination.
>>>>
>>>> My suggestion based on production is that as long as
>>>> you don't use `-zzstd` ++ `-E48bit`, it should be fine.
>>>>
>>>> If you need smaller images, I suggest: `-zlzma,9 -C65536 -Efragments`
>>>> Or like Android, they all use `-zlz4hc`,
>>>> Or zstd, but don't add `-E48bit`.
>>>>
>>>> As for "--max-extent-bytes 65536", it can be dropped
>>>> since if `-E48bit` is not used, it only has negative
>>>> impacts.
>>>>
>>>> In short, `-E48bit` + `-zzstd` + `--max-extent-bytes`
>>>> enables new unaligned compression for zstd, but it's
>>>> a relatively new feature, I still still some time to
>>>> stablize it but my own time is limited and all things
>>>> are always prioritized.
>>>
>>> Ok, thanks for this advice!
>>
>> FYI, I can reproduce this issue locally with `-E48bit`
>> on in 600s.
>>
>> I do think it's a `-E48bit` + zstd issue so
>> non-`-E48bit` won't be impacted and I will find time
>> to troubleshoot it this week.
> 
> Yes, without '-E48bit' we also can't reproduce it for entire weekend on several boards. No such panics.

Can you check if the following informal patch resolves
this issue?  I've checked it locally:

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 8a0b15511931..824ffe4b871c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1509,12 +1509,6 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
  	DBG_BUGON(z_erofs_is_shortlived_page(bvec->bv_page));

  	folio = page_folio(zbv.page);
-	/* For preallocated managed folios, add them to page cache here */
-	if (folio->private == Z_EROFS_PREALLOCATED_FOLIO) {
-		tocache = true;
-		goto out_tocache;
-	}
-
  	mapping = READ_ONCE(folio->mapping);
  	/*
  	 * File-backed folios for inplace I/Os are all locked steady,
@@ -1527,6 +1521,12 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
  		return;
  	}

+	if (cmpxchg(&folio->private, Z_EROFS_PREALLOCATED_FOLIO, NULL) ==
+	    Z_EROFS_PREALLOCATED_FOLIO) {
+		tocache = true;
+		goto out_tocache;
+	}
+
  	folio_lock(folio);
  	if (likely(folio->mapping == mc)) {
  		/*
@@ -1546,14 +1546,8 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
  			}
  			return;
  		}
-		/*
-		 * Already linked with another pcluster, which only appears in
-		 * crafted images by fuzzers for now.  But handle this anyway.
-		 */
-		tocache = false;	/* use temporary short-lived pages */
  	} else {
-		DBG_BUGON(1); /* referenced managed folios can't be truncated */
-		tocache = true;
+		DBG_BUGON(1);		/* referenced managed folios can't be truncated */
  	}
  	folio_unlock(folio);
  	folio_put(folio);


I will form a formal patch later with comments and commit
message later.

Thanks,
Gao Xiang

