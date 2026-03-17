Return-Path: <linux-erofs+bounces-2775-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A879FB5EA7
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 02:40:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZbln4nl4z2yTK;
	Tue, 17 Mar 2026 13:40:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773715205;
	cv=none; b=CDF1ylSbwgHSle4dzJ+bEPdUQ3qR0xYeUF+JBGEg2DrVuG2ZVtLbpTbWYNXrP3XR4PHVq6u5wVycppG/adgihiVM0Dzbr9kVs4a6qya0O2Nlp5/nWys4kzXQyQEV3+3Th8CnVOrnTHZVt4WxlnRtwU7hen2B9z67wg9h+iSpKgx33M9W7MITAblUyFPu6gx5chnRX9qmCXQ0Z/dVmmva80pwLSLBO/+lSlV22nQWU146nyaaMpTy8gWwdPcHmt7eOKs5eToeqUDLddyRQkKkMY4a/b/lIhgxKtW5S0ckwFD7AG3JvpZY3KEJk57acigpay0TBwvfjxIB6+ITrNNKbw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773715205; c=relaxed/relaxed;
	bh=K4uszCtajYEhDAgJtpsbz0EHboKu8UIxsiq66qhcWlE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Oox3U+glpafNzV0tB27Ck6/Qt9Q8Enmou/DbPQz0B+7S/tg/KBfUXDBhW4W3dAsraKkMnKGmcv03+4iksnz5zpdeK6ODJ4AUW2Q0T8g50s1YM/DEMyHmYO25Yfe9IUi82J+9Qx9Dt47jp0EQFml7JY7VljqPV1W6OaWuY80GZnLZuMGpOT036mfgcqsc3ALVtXagY+AWOb4EvuiHHB/OYbm8sJVumkO/j5MJdiUhhN+dGSdDk+TRp5k6aP79WVnVQvRbmqrFggqz0hihJSygENFvXHsYWsSJaxPdhZ79rjk37kjE9QIj+IdP4MC0lcEASoqKal3M9VKSFPYhSvbXtA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OkOiBNPj; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OkOiBNPj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZbll1KqRz2xb3
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 13:40:01 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773715197; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=K4uszCtajYEhDAgJtpsbz0EHboKu8UIxsiq66qhcWlE=;
	b=OkOiBNPjByGENDx3otkhbWsBPcE/lJ5WHOvC/gCM827+AlBWZugm1CiJXFT6OiJhB/g5VFuuaf9cbGNXSXlc11GHmbZXN/Q/X3tv1PcBiORchtWrns7KfQQoxxExJ8LYQJ601ikktb8jCk/mEjTXrhTOj3PaNC8STlmJV1X3vx0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X.9HpAQ_1773715195;
Received: from 30.221.133.143(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.9HpAQ_1773715195 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 10:39:56 +0800
Message-ID: <e0e651d1-3c78-4116-961b-0113bb8a0251@linux.alibaba.com>
Date: Tue, 17 Mar 2026 10:39:54 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: validate h_shared_count in
 erofs_init_inode_xattrs()
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20260316201919.41839-1-singhutkal015@gmail.com>
 <964b9ef0-388e-4b92-becf-2bd9094893db@linux.alibaba.com>
In-Reply-To: <964b9ef0-388e-4b92-becf-2bd9094893db@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/17 10:16, Gao Xiang wrote:
> 
> 
> On 2026/3/17 04:19, Utkal Singh wrote:
>> erofs_init_inode_xattrs() reads h_shared_count directly from the on-disk
>> xattr ibody header and uses it to size a heap allocation and drive a
>> read loop without checking whether the implied shared xattr array fits
>> within xattr_isize.
>>
>> A crafted EROFS image with a large h_shared_count but a minimal
>> xattr_isize causes the subsequent loop to read shared xattr entries
>> beyond the xattr ibody boundary, interpreting unrelated on-disk data
>> as shared xattr IDs.  This affects every library consumer -- dump.erofs,
>> erofsfuse, and the rebuild path (lib/rebuild.c) -- none of which call
>> the fsck-only erofs_verify_xattr() before reaching this code.
> 
> I don't think other than fsck tool, this must be checked, since it
> won't cause any harmful behavior but the filesystem image is already
> corrupted, and because of the corruption, the user should get the
> corrupted result, but it still have no impact to the whole system
> stablity.

Nevertheless, I'm fine if we try to harden this part, but the commit
message should clarify the impact: it actually has no stability impact
out of those images.

Also there are many threads with your contribution, it's hard for me
to follow those threads, now.

Would you mind raising a github issue
https://github.com/erofs/erofs-utils/issues

and list all your patches for merging (with meaningful topics are
preferred) ?

> 
>>
>> Validate that h_shared_count fits within the available xattr body space
>> before allocating or reading.  Use a division-based check to avoid any
>> theoretical overflow in the multiplication.
> 
> I don't think it will overflow according to the ondisk format.
> 
>>
>> The subtraction is safe because callers above already reject
>> xattr_isize < sizeof(struct erofs_xattr_ibody_header).
> 
> Please add a reproducible way.
> 
>>
>> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
>> ---
>>   lib/xattr.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/lib/xattr.c b/lib/xattr.c
>> index 565070a..6891812 100644
>> --- a/lib/xattr.c
>> +++ b/lib/xattr.c
>> @@ -1182,6 +1182,16 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
>>       ih = it.kaddr;
>>       vi->xattr_shared_count = ih->h_shared_count;
>> +    /* validate h_shared_count fits within xattr_isize */
>> +    if (vi->xattr_shared_count >
>> +        (vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) /
>> +            sizeof(u32)) {
> 
> Can we avoid division?
> 
>> +        erofs_err("bogus h_shared_count %u (xattr_isize %u) @ nid %llu",
>> +              vi->xattr_shared_count, vi->xattr_isize,
>> +              vi->nid | 0ULL);
>> +        erofs_put_metabuf(&it.buf);
>> +        return -EFSCORRUPTED;
>> +    }
>>       vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count * sizeof(uint));
>>       if (!vi->xattr_shared_xattrs) {
>>           erofs_put_metabuf(&it.buf);
> 


