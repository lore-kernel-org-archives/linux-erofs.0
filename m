Return-Path: <linux-erofs+bounces-3265-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4604CE99059
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 09:03:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsW6l6Mztz2yZ6;
	Fri, 10 Apr 2026 19:03:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775811791;
	cv=none; b=DWjSwqkc4y1RVF1Sto3jR2DwlWFQV2kk+q7N99r5CzYxc3h9Gguplm73nNgD/hfyqLw7+/YgaLg9qJz3M0Vz5qX4zYHtjSeoeJ43c5qPvnSQN2DQHwF+OSmDkvpJuCsujQhT3BY0rlUxZaPDCX4IhIyG+jRsWPDuV8uCAT+HMT0354iHZT0nrpwIxUo+Aj5sgvvj+VgqaUw1Ea2YRqA6nfvxjqRVfsj9CUKkDEXPqG1tL/Qk+6pulroOCW5eHojrAKzpNfvDeE8976WtYOg5YyvgCpSyQ+l2DVk98pW7SvChIWZfr9ZrP2nCMYx36QpNbOFjSHRjOLF/a7gBwOY9hw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775811791; c=relaxed/relaxed;
	bh=forOFrPyu5Q08G2ykBikyfX5j8/G9BBHB1ga9Qe4bA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KS5W362G9xsbv3PWcVFkVlUJ3CxPnTXu1kXBR+B0CTZcxwdqy0oMEyq4zjpb1Obzu6rdqUbWkr9xagYQLtCtY1yw1yr+YXQEqfEvXIrOl6rH+8Wu+kQ1SenqxH5jJ2ELHKORb2g/X96tUBfox3BXK8BwKfIvgak+LJTdPE/7tT0hpjyHQUfhWvU3mdJOZ34zYNsOkiobYJ5oqhysyITesaWbCfEpE93KPxLYOVMxwiuIj3Lh/akeaRuI/kao+n0nSdVQG1XMlGXc5CPdcolsYcjj5unJxiZWom9mECK2jPiA40KD8CnXmFaQsj/RELyamSxuFjvYMVzom9fNbqDFhw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oFnmHm3S; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oFnmHm3S;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsW6k6PFGz2xTh
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 19:03:09 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775811786; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=forOFrPyu5Q08G2ykBikyfX5j8/G9BBHB1ga9Qe4bA4=;
	b=oFnmHm3ScUrIn3GsFwTcvDxzcMoJpGEsPlxCfZJKNwwHIt2seY25k1ocaJK8nSntLssTjs3kwgtDkVKSh2c0ecHwXHJPfDpEb/4eQ6UUSXLxssIg6cR9niioK825ovTbUD/+Fv0/SM3KcOGTKmV8vhOvyeRb9mhGyWhMOp7qUhQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X0kq4cf_1775811784;
Received: from 30.221.132.105(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0kq4cf_1775811784 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 17:03:05 +0800
Message-ID: <85a0c42a-1e8e-492f-95c9-5a724abf70dd@linux.alibaba.com>
Date: Fri, 10 Apr 2026 17:03:04 +0800
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
Subject: Re: [PATCH v1] erofs-utils: mkfs: fix fingerprint not set in certain
 modes
To: "Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>,
 "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Cc: "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
 "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>
References: <20260410060539.417457-2-Yuezhang.Mo@sony.com>
 <c1514566-e3ca-4ef6-b23b-054f9e1a49c5@linux.alibaba.com>
 <TY0PR04MB63283F67989B4A1649F6149E81592@TY0PR04MB6328.apcprd04.prod.outlook.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <TY0PR04MB63283F67989B4A1649F6149E81592@TY0PR04MB6328.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/10 17:00, Yuezhang.Mo@sony.com wrote:
>> On 2026/4/10 14:05, Yuezhang Mo wrote:
>>> In certain modes, such as "--tar=f --sort=none", data is written to
>>> the image before fingerprint calculation. In this case, ->datasource
>>> will be set to `EROFS_INODE_DATA_SOURCE_NONE`.
>>>
>>> The original `erofs_set_inode_fingerprint()` function only attempts to
>>> read data from a local file or disk buffer; it cannot handle the
>>> `EROFS_INODE_DATA_SOURCE_NONE` case, causing fingerprint setting to be
>>> skipped.
>>>
>>> This patch adds handling for the `EROFS_INODE_DATA_SOURCE_NONE` case,
>>> reading data from the image and calculating the fingerprint.
>>>
>>> Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
>>> Reviewed-by: Friendy Su <friendy.su@sony.com>
>>> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
>>> ---
>>>    lib/inode.c | 20 ++++++++++++++------
>>>    1 file changed, 14 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/lib/inode.c b/lib/inode.c
>>> index 2cfc6c5..51d5266 100644
>>> --- a/lib/inode.c
>>> +++ b/lib/inode.c
>>> @@ -1975,6 +1975,13 @@ static int erofs_set_inode_fingerprint(struct erofs_inode *inode, int fd,
>>>
>>>        if (!ishare_xattr_prefix_id)
>>>                return 0;
>>> +
>>> +     if (inode->datasource == EROFS_INODE_DATA_SOURCE_NONE) {
>>> +             ret = erofs_iopen(&vf, inode);
>>> +             if (ret)
>>> +                     return ret;
>>> +     }
>>> +
>>>        erofs_sha256_init(&md);
>>>        do {
>>>                u8 buf[32768];
>>> @@ -2018,12 +2025,6 @@ static int erofs_mkfs_begin_nondirectory(const struct erofs_mkfs_btctx *btctx,
>>>                        goto out;
>>>                }
>>>
>>> -             if (S_ISREG(inode->i_mode) && inode->i_size) {
>>> -                     ret = erofs_set_inode_fingerprint(inode, ctx.fd, ctx.fpos);
>>> -                     if (ret < 0)
>>> -                             return ret;
>>> -             }
>>
>> I vaguely remembered we have to leave it here since
>> otherwise it may impact compressed files.
>>
>> Also EROFS_INODE_DATA_SOURCE_NONE means that mkfs
>> dump will change nothing about that, so I suggest
>>
>> apply erofs_set_inode_fingerprint() to every
>> EROFS_INODE_DATA_SOURCE_NONE user
>> (e.g. in lib/tar.c) instead.
>>
> 
> Hi Xiang,
> 
> This will bring a bit big code change.
> 
> How about changing it like this? It maintains the original
> order and the change is simple.

`EROFS_INODE_DATA_SOURCE_NONE` should assume that metadata
is done as-is, that is the current design principle.

using erofs_iopen() to reuse erofs_pread() is really
unexpected for me TBH.

Thanks,
Gao Xiang


