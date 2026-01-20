Return-Path: <linux-erofs+bounces-2095-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC52D2ECE9
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Jan 2026 14:33:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwVDl4RSJz3c5c;
	Wed, 21 Jan 2026 01:33:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768919607;
	cv=none; b=hD8huiLZAaGRDvzGo1LLEIWruuL+vkzOLrKBKypD95eBKlXdjfaD7DPUJSpNKiz3Rdp8LEFy7v3h0f//zbgpFpr8ubN4Sj0v9L0nR7YivQzqVFHvMbkiwbMW3b7ZVyPBh0coYIp5NT+8jx3kPLfA6QPMUXoa0niRvFRxZ3tWi7RIFjYSe2z/l3xuIoQKRXk3IgjwEwu7PRgXxV6et068AV0KXZ4r8+6sfDgORGMZs0DwQnAEEvBXQu9cmZwlyX7BcRc72N91Akr4FkvGcvSu2CPFAZ/iRNz4QibvM5xQt1Kc99om54eb42PLMpDBMMB3FdtC0x1KebT8bEpXEOt8vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768919607; c=relaxed/relaxed;
	bh=yWIejA1XsWO4Z+7v755Hy5Bf7y9GZugnLbqFrHS4ZOM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Hspm69BWNG+/EQP4WNQp01W0YbSu2/ZeaAckt50u+QpgD3Ln8pZ9+Jz5XL1VMP8aAzpxLb37Iw4a9gCfYauBT2rpu0YuhzDvu8nfGoe6O9cOlHKUPF2U4aXDMCnPa3iYNhQPpUbwcUM17M7ygYFILgeEXwduODpFF7Q7sbtEb2x19YsYyaFC2qxdxCbakey4mho7TYe8A0WQC0vxgN32FzPO3tB1G1mQgzuF6vt1m3fTGC8DW6fwVDodeSQTYE37cUziBw1ESi37mtScdIM68Qa/7kl3wQPr3fdoyQIe0IFTycXgE87U5APNfFEbN0XnB+MJWQNe9TLTSbnkXIUJUA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=H37U843o; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=H37U843o;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwVDd0fGxz3c55
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 01:33:19 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768919587; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=yWIejA1XsWO4Z+7v755Hy5Bf7y9GZugnLbqFrHS4ZOM=;
	b=H37U843oOahFniSg+v/p6C5lukxD1x/QCnDmWMr5p2vFybXzg7PpkCZu+YO48SKbJ4pWaa3leDWqs8f70q3/pjqZSGaRyIsLvsFhJJJVEFzNdZEn82NRRmu0kfMFR+qddttGwGQJt3Gxfqz/cc4PKRrOhwklYTdBvMJ0YaK5wfI=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WxUiYiY_1768919583 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 22:33:04 +0800
Message-ID: <2b2880c0-f929-45a7-8dcd-24b1a3e94634@linux.alibaba.com>
Date: Tue, 20 Jan 2026 22:33:03 +0800
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
Subject: Re: [PATCH v15 5/9] erofs: introduce the page cache share feature
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Hongbo Li <lihongbo22@huawei.com>, chao@kernel.org, brauner@kernel.org
Cc: djwong@kernel.org, amir73il@gmail.com, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260116095550.627082-1-lihongbo22@huawei.com>
 <20260116095550.627082-6-lihongbo22@huawei.com>
 <3ae9078a-ba5c-460d-89ea-8fdbdf190a10@linux.alibaba.com>
In-Reply-To: <3ae9078a-ba5c-460d-89ea-8fdbdf190a10@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/1/20 22:19, Gao Xiang wrote:
> 
> 
> On 2026/1/16 17:55, Hongbo Li wrote:
>> From: Hongzhen Luo <hongzhen@linux.alibaba.com>
>>
>> Currently, reading files with different paths (or names) but the same
>> content will consume multiple copies of the page cache, even if the
>> content of these page caches is the same. For example, reading
>> identical files (e.g., *.so files) from two different minor versions of
>> container images will cost multiple copies of the same page cache,
>> since different containers have different mount points. Therefore,
>> sharing the page cache for files with the same content can save memory.
>>
>> This introduces the page cache share feature in erofs. It allocate a
>> deduplicated inode and use its page cache as shared. Reads for files
>> with identical content will ultimately be routed to the page cache of
>> the deduplicated inode. In this way, a single page cache satisfies
>> multiple read requests for different files with the same contents.
>>
>> We introduce inode_share mount option to enable the page sharing mode
>> during mounting.
>>
>> Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   Documentation/filesystems/erofs.rst |   5 +
>>   fs/erofs/Makefile                   |   1 +
>>   fs/erofs/inode.c                    |  24 +----
>>   fs/erofs/internal.h                 |  57 ++++++++++
>>   fs/erofs/ishare.c                   | 161 ++++++++++++++++++++++++++++
>>   fs/erofs/super.c                    |  56 +++++++++-
>>   fs/erofs/xattr.c                    |  34 ++++++
>>   fs/erofs/xattr.h                    |   3 +
>>   8 files changed, 316 insertions(+), 25 deletions(-)
>>   create mode 100644 fs/erofs/ishare.c
>>
>> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
>> index 08194f194b94..27d3caa3c73c 100644
>> --- a/Documentation/filesystems/erofs.rst
>> +++ b/Documentation/filesystems/erofs.rst
>> @@ -128,7 +128,12 @@ device=%s              Specify a path to an extra device to be used together.
>>   fsid=%s                Specify a filesystem image ID for Fscache back-end.
>>   domain_id=%s           Specify a domain ID in fscache mode so that different images
>>                          with the same blobs under a given domain ID can share storage.
>> +                       Also used for inode page sharing mode which defines a sharing
>> +                       domain.
> 
> I think either the existing or the page cache sharing
> here, `domain_id` should be protected as sensitive
> information, so it'd be helpful to protect it as a
> separate patch.
> 
> And change the description as below:
>                             Specify a trusted domain ID for fscache mode so that
>                             different images with the same blobs, identified by blob IDs,
>                             can share storage within the same trusted domain.
>                             Also used for different filesystems with inode page sharing
>                             enabled to share page cache within the trusted domain.
> 
> 
>>   fsoffset=%llu          Specify block-aligned filesystem offset for the primary device.
>> +inode_share            Enable inode page sharing for this filesystem.  Inodes with
>> +                       identical content within the same domain ID can share the
>> +                       page cache.
>>   ===================    =========================================================
> 
> ...
> 
> 
>>       erofs_exit_shrinker();
>> @@ -1062,6 +1111,8 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
>>           seq_printf(seq, ",domain_id=%s", sbi->domain_id);
> 
> I think we shouldn't show `domain_id` to the userspace
> entirely.

Maybe not bother with the deprecated fscache, just make
sure `domain_id` won't be shown in any form for page
cache sharing feature.

> 
> Also, let's use kfree_sentitive() and no_free_ptr() to
> replace the following snippet:
> 
>           case Opt_domain_id:
>                  kfree(sbi->domain_id); -> kfree_sentitive
>                  sbi->domain_id = kstrdup(param->string, GFP_KERNEL);
>                       -> sbi->domain_id = no_free_ptr(param->string);
>                  if (!sbi->domain_id)
>                          return -ENOMEM;
>                  break;
> 
> And replace with kfree_sentitive() for domain_id everywhere.
> > Thanks,
> Gao Xiang


