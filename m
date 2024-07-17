Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA72C3DA4B
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Jul 2024 06:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1721198117;
	bh=xzrEBhpceecZZ3mKiO8ySct8kxKG/Lt1GghL1tTf7oQ=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=RUH3zM7NH1RSgIUYXM8GyP4BhvVeG6af4xJkXkpbBJjdR5OG1mPANW9RFLpIAVmI5
	 cuMio62xpVB7EFhr1W1NrCDT7j+3ZUXIkSj7U7+9pgg32irEHNPp5NWos8lEbKxpFd
	 J5udfCOeG8PVjIa+KydA6POkblF1JR8PWI0xXQDS08BJFag/BfHF/RwivB9d6DH1Y5
	 WHxgA9ZFa0BwqRHpMjq0AdYKpymmOjCH9P6hZA254ga4lkI/RBJXVEzrVRpjB+enIt
	 cHDE0DcbGLMgAdijMEN8mF//1VBUI98Q2OE71b+mEVdHXQw95JpKcdPjOwWz6eUli3
	 piwI5sg/1rRMQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WP5ln5SZSz3dHM
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Jul 2024 16:35:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WP5lg5CL8z3cFw
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jul 2024 16:35:05 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WP5dD5mqfzxT4d;
	Wed, 17 Jul 2024 14:29:36 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 7F1F5180087;
	Wed, 17 Jul 2024 14:34:28 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 14:34:28 +0800
Message-ID: <9e531afd-45e8-471b-8074-8ae5c90aceb0@huawei.com>
Date: Wed, 17 Jul 2024 14:34:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: support STATX_DIOALIGN
To: Gao Xiang <hsiangkao@linux.alibaba.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <huyue2@coolpad.com>, <jefflexu@linux.alibaba.com>,
	<dhavale@google.com>, <dhowells@redhat.com>
References: <20240716124534.2358151-1-lihongbo22@huawei.com>
 <afe7b51b-b235-4ad5-80a5-16e0e61e149e@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <afe7b51b-b235-4ad5-80a5-16e0e61e149e@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
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
From: Hongbo Li via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Hongbo Li <lihongbo22@huawei.com>
Cc: netfs@lists.linux.dev, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/7/17 10:00, Gao Xiang wrote:
> Hi,
> 
> On 2024/7/16 20:45, Hongbo Li wrote:
>> Add support for STATX_DIOALIGN to erofs, so that direct I/O
>> alignment restrictions are exposed to userspace in a generic
>> way.
>>
>> [Before]
>> ```
>> ./statx_test /mnt/erofs/testfile
>> statx(/mnt/erofs/testfile) = 0
>> dio mem align:0
>> dio offset align:0
>> ```
>>
>> [After]
>> ```
>> ./statx_test /mnt/erofs/testfile
>> statx(/mnt/erofs/testfile) = 0
>> dio mem align:512
>> dio offset align:512
>> ```
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   fs/erofs/inode.c | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
>> index 5f6439a63af7..9325a6f0058a 100644
>> --- a/fs/erofs/inode.c
>> +++ b/fs/erofs/inode.c
>> @@ -342,6 +342,25 @@ int erofs_getattr(struct mnt_idmap *idmap, const 
>> struct path *path,
>>       stat->attributes_mask |= (STATX_ATTR_COMPRESSED |
>>                     STATX_ATTR_IMMUTABLE);
>> +    /*
>> +     * Return the DIO alignment restrictions if requested.
>> +     *
>> +     * In erofs, STATX_DIOALIGN is not supported in ondemand mode and
>> +     * the compressed file, so in these cases we report no DIO support.
>> +     */
>> +    if ((request_mask & STATX_DIOALIGN) && S_ISREG(inode->i_mode)) {
>> +        stat->result_mask |= STATX_DIOALIGN;
>> +        if (!erofs_is_fscache_mode(inode->i_sb) &&
>> +            
>> !erofs_inode_is_data_compressed(EROFS_I(inode)->datalayout)) {
>> +            struct block_device *bdev = inode->i_sb->s_bdev;
>> +            unsigned int bsize = (bdev) ? 
>> bdev_logical_block_size(bdev) :
>> +                        i_blocksize(inode);
> 
> I guess in this way you could always use
>              stat->dio_mem_align = bdev_logical_block_size(bdev);
>              stat->dio_offset_align = stat->dio_mem_align;
> ? since bdev won't be NULL.
> 
Yeah, only the EROFS_FS_ONDEMAND config is on, the s_bdev can be NULL.

Thanks,
Hongbo

> Otherwise it looks good to me.
> 
> Thanks,
> Gao Xiang
