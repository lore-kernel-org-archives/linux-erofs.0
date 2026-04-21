Return-Path: <linux-erofs+bounces-3346-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFE8F327B9
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Apr 2026 07:39:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g0Dkd2FrPz2ySW;
	Tue, 21 Apr 2026 17:39:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776757145;
	cv=none; b=M9pEhEIvLuB2m0g2BGXGhTqkFjeoGWql2sMPY65E/I0gH0T9jr3VvQqfmHDpzFLDn2eQe69ltC59P06BuCzmyJG2Vv5EQJXzqthUi9QRoyE4VaYHfytZOMT5bquY1MKG0wIHIVdMgi/Hr5ZHTSvaAaf4Epu+Po6Mi4M6BTaFFL+eP1gCoo8dGmaBwCOcc4s8PQRdTVRm5Kct1Si+IOyLfTzN7TvO6yJkssUQpM0ar5on+v8XZlmCnvk7MSQLJqbHN8N/PebTU89eqGBUVEJG0uPWwzyAX66lF1tzxYCE6RmIsRlT4nGujraYFfPnTZsuixG5XzTUjUxZaLnR0kWUmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776757145; c=relaxed/relaxed;
	bh=bBR+x8/rFj/yPCNM4srOeJsm+pZYnjkZyx2mrSw3Ooc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bgksIVZ04tXTRbz8y5t3oJgp3+l1AE0L9TXolmEoXo2AnkIv07MmXyQ8i80WhLJ1b0+mbynCA7/9yoLGpjxQytsS21Gg6apgOGSvk3/gcCbCy/7CMPp+EpGi8FMIZZLPFhoWtadhzD+uShrnnWV00Hqeu1wzPQEJGOvT3r/M6A+Xuduf7tovnYBkEknwK62NpoL97KDFbM9UAd/D/+ULPixE1YeGUWPLx7wzBcPWcUPlidgQ4vcnRJG5IIU9qbKa+fSINGT6GaNrzLFGhzz4qWd/ZpGVv6TESblEyps4Ct7ERw5gT8o1evZ1ph66MUWnVY6WPjqu9Y4zw+O9Vu+y1w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sNl7Ekjz; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sNl7Ekjz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g0Dkb1MJhz2yFl
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Apr 2026 17:39:01 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776757136; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bBR+x8/rFj/yPCNM4srOeJsm+pZYnjkZyx2mrSw3Ooc=;
	b=sNl7Ekjz4XaeEI2G5MZXWT4zcQ3aWmuestUG0HBFB3V+Pd5+nqwG6xZKEV04wiwc/jSmjVeIV+yuBFNj7F2U8zcxNbIs7gKa0AM/5YK9p4DgYl7hQu54i/5nfqHbKuel5rz/ynQc3mqrdRttZfKry7Xd+Uv4mQWvwNY6nxyi5FA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X1S7tuK_1776757134;
Received: from 30.221.132.26(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1S7tuK_1776757134 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 15:38:55 +0800
Message-ID: <d1fe814b-9527-4dc7-b79a-9952b4199242@linux.alibaba.com>
Date: Tue, 21 Apr 2026 15:38:54 +0800
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
Subject: Re: [PATCH v3] erofs: fix the out-of-bounds nameoff handling for
 trailing dirents
To: Chao Yu <chao@kernel.org>, linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>, Yuhao Jiang <danisjiang@gmail.com>,
 Junrui Luo <moonafterrain@outlook.com>, stable@vger.kernel.org
References: <20260416063511.3173774-1-hsiangkao@linux.alibaba.com>
 <20260416094408.3466613-1-hsiangkao@linux.alibaba.com>
 <b9d787ce-9020-4140-8d13-23a20809976d@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <b9d787ce-9020-4140-8d13-23a20809976d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/4/21 15:26, Chao Yu wrote:
> On 4/16/2026 5:44 PM, Gao Xiang wrote:
>> Currently we already have boundary-checks for nameoffs, but the trailing
>> dirents are special since the namelens are calculated with strnlen()
>> with unchecked nameoffs.
>>
>> If a crafted EROFS has a trailing dirent with nameoff >= maxsize,
>> maxsize - nameoff can underflow, causing strnlen() to read past the
>> directory block.
>>
>> nameoff0 should also be verified to be a multiple of
>> `sizeof(struct erofs_dirent)` as well [1].
>>
>> [1] https://sashiko.dev/#/patchset/20260416063511.3173774-1-hsiangkao%40linux.alibaba.com
>> Fixes: 3aa8ec716e52 ("staging: erofs: add directory operations")
>> Fixes: 33bac912840f ("staging: erofs: keep corrupted fs from crashing kernel in erofs_readdir()")
>> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
>> Reported-by: Junrui Luo <moonafterrain@outlook.com>
>> Closes: https://lore.kernel.org/r/A0FD7E0F-7558-49B0-8BC8-EB1ECDB2479A@outlook.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>> ---
>> v3:
>>   - Disallow unaligned nameoff0 to avoid petential oob reads as well.
>>
>>   fs/erofs/dir.c | 29 ++++++++++++++++-------------
>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
>> index e5132575b9d3..d074fded1577 100644
>> --- a/fs/erofs/dir.c
>> +++ b/fs/erofs/dir.c
>> @@ -19,20 +19,18 @@ static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
>>           const char *de_name = (char *)dentry_blk + nameoff;
>>           unsigned int de_namelen;
>> -        /* the last dirent in the block? */
>> -        if (de + 1 >= end)
>> -            de_namelen = strnlen(de_name, maxsize - nameoff);
>> -        else
>> +        /* non-trailing dirent in the directory block? */
>> +        if (de + 1 < end)
>>               de_namelen = le16_to_cpu(de[1].nameoff) - nameoff;
>> +        else if (maxsize <= nameoff)
>> +            goto err_bogus;
>> +        else
>> +            de_namelen = strnlen(de_name, maxsize - nameoff);
>> -        /* a corrupted entry is found */
>> -        if (nameoff + de_namelen > maxsize ||
>> -            de_namelen > EROFS_NAME_LEN) {
>> -            erofs_err(dir->i_sb, "bogus dirent @ nid %llu",
>> -                  EROFS_I(dir)->nid);
>> -            DBG_BUGON(1);
>> -            return -EFSCORRUPTED;
>> -        }
>> +        /* a corrupted entry is found (including negative namelen) */
>> +        if (!in_range32(de_namelen, 1, EROFS_NAME_LEN) ||
>> +            nameoff + de_namelen > maxsize)
>> +            goto err_bogus;
>>           if (!dir_emit(ctx, de_name, de_namelen,
>>                     erofs_nid_to_ino64(EROFS_SB(dir->i_sb),
>> @@ -42,6 +40,10 @@ static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
>>           ctx->pos += sizeof(struct erofs_dirent);
>>       }
>>       return 0;
>> +err_bogus:
>> +    erofs_err(dir->i_sb, "bogus dirent @ nid %llu", EROFS_I(dir)->nid);
>> +    DBG_BUGON(1);
>> +    return -EFSCORRUPTED;
>>   }
>>   static int erofs_readdir(struct file *f, struct dir_context *ctx)
>> @@ -88,7 +90,8 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>>           }
>>           nameoff = le16_to_cpu(de->nameoff);
>> -        if (nameoff < sizeof(struct erofs_dirent) || nameoff >= bsz) {
> 
> You mean?
> 
> if (!nameoff || nameoff >= bsz || nameoff % sizeof(struct erofs_dirent))

The explanation can be seen as:
https://sashiko.dev/#/patchset/20260416063511.3173774-1-hsiangkao%40linux.alibaba.com

But I think `nameoff < sizeof(struct erofs_dirent)` is also fine?
I could also switch to your suggested version.

Thanks,
Gao Xiang


