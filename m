Return-Path: <linux-erofs+bounces-2209-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89373D72345
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jan 2026 07:43:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dy90c0xYwz2xJ5;
	Fri, 23 Jan 2026 18:43:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769154224;
	cv=none; b=Nrifj71BicELWkbIfMCbssbv1+uFvd5LCqI5/M/d/LigQ+Vdkye0+my/nm14LNmJjfa4Nod3n6K73jpHWPGpAp95xr9w9+ZH+VODcZRj86WWPEOTmvSkJd6jBVDEAe8okYrcMR28EC6EVtL1jTQc0KZ3v/kWzGBY6POjdWKfzwbIkwnu5yFtNyJcupH3vbpGCSg0rK+iJfWe7+vn16l6fs6cKZdUBuASFmLX0LIUwE+VpqSXnQAvWncRnL5or+I+f+89ysJGGWOh8EXIc8rPF3iQUhTvNwTpmOinlO+t142ymbZtGEd/wOJ8JHIoPpVN2LVlFEzmOyibBdmNbQBucg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769154224; c=relaxed/relaxed;
	bh=WdcxlWt6tlFFJCr6TlsKyX2Fw2k1tpZaSSFEJHukB3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i2WKodXQIDVXaA4W+OYZZAjtj0rj8fE8D3JwxfYrv+Miye48HlE9u1fdQ1gzhx755emGaHAkZq5fYPXtPAU+AH5oDpcHP1bFASB7x7NAm4iwY0YFCJsOYAdtfiOb+iBtBm7ME0bc/9xe+4Ccf7a+CLzKzKgEQkWbuTnWcbxsxkwuNIyL4MRf28OKI/jKkJTaQcwEUkx1kSWVa4N9XAazB9aRKmVOAykrGiScavrxbh1WccNr18K1e5FMNRs43G7iI5XiUd6rAZeg8rkjTw0Xg/gJ2vzmTTgzaVk6uQQNoQBz0IWMIU3oF+14cqqX2VYHLx7sXnFjoG5FaXQbbv6yQA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Zo96Mnae; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Zo96Mnae;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dy90Y3jCHz2xHt
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 18:43:39 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769154140; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WdcxlWt6tlFFJCr6TlsKyX2Fw2k1tpZaSSFEJHukB3A=;
	b=Zo96MnaeE+9cLUM1iJfAy8jxlDwGNtrzEXEUqo1ZvRl/ehFXHfuoNM8Sk4tvi2KpOwsYln+bwGkOceskFZXVU334cSoqFNWNCyqDQ/wUkMf7Wh0JcN8AA1VrtevVcPYl5d9szABKPGjDmoBA6Rjh9FlmUrzZaGtYd/luUJgvYN8=
Received: from 30.180.182.138(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wxf-YOt_1769154134 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 15:42:15 +0800
Message-ID: <e0b170ec-253e-49ed-be62-9a90e9eb9053@linux.alibaba.com>
Date: Fri, 23 Jan 2026 15:42:14 +0800
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
Subject: Re: [PATCH v16 04/10] erofs: add erofs_inode_set_aops helper to set
 the aops.
To: Christoph Hellwig <hch@lst.de>, Hongbo Li <lihongbo22@huawei.com>
Cc: chao@kernel.org, brauner@kernel.org, djwong@kernel.org,
 amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260122133718.658056-1-lihongbo22@huawei.com>
 <20260122133718.658056-5-lihongbo22@huawei.com>
 <b20b263d-132b-464e-8314-d3f795e5e582@linux.alibaba.com>
 <20260123061825.GA25722@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260123061825.GA25722@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/23 14:18, Christoph Hellwig wrote:
> On Thu, Jan 22, 2026 at 09:54:15PM +0800, Gao Xiang wrote:
>>> @@ -455,6 +455,29 @@ static inline void *erofs_vm_map_ram(struct page **pages, unsigned int count)
>>>    	return NULL;
>>>    }
>>>    +static inline int erofs_inode_set_aops(struct inode *inode,
>>> +				       struct inode *realinode, bool no_fscache)
>>> +{
>>> +	if (erofs_inode_is_data_compressed(EROFS_I(realinode)->datalayout)) {
>>> +		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
>>> +			return -EOPNOTSUPP;
>>> +		DO_ONCE_LITE_IF(realinode->i_blkbits != PAGE_SHIFT,
>>> +			  erofs_info, realinode->i_sb,
>>> +			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
>>> +		inode->i_mapping->a_ops = &z_erofs_aops;
>>
>> Is that available if CONFIG_EROFS_FS_ZIP is undefined?
> 
> z_erofs_aops is declared unconditionally, and the IS_ENABLED above
> ensures the compiler will never generate a reference to it.
> 
> So this is fine, and a very usualy trick to make the code more
> readable.

Yeah, I get your point, that is really helpful and I haven't
used that trick.

The other problem was the else part is incorrect, Hongbo,
how about applying the following code and resend the next
version, I will apply all patches later:

static inline int erofs_inode_set_aops(struct inode *inode,
                                        struct inode *realinode, bool no_fscache)
{
         if (erofs_inode_is_data_compressed(EROFS_I(realinode)->datalayout)) {
                 if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
                         return -EOPNOTSUPP;
                 DO_ONCE_LITE_IF(realinode->i_blkbits != PAGE_SHIFT,
                           erofs_info, realinode->i_sb,
                           "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
                 inode->i_mapping->a_ops = &z_erofs_aops;
                 return 0;
         }
         inode->i_mapping->a_ops = &erofs_aops;
         if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && !no_fscache &&
             erofs_is_fscache_mode(realinode->i_sb))
                 inode->i_mapping->a_ops = &erofs_fscache_access_aops;
         if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) &&
             erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
                 inode->i_mapping->a_ops = &erofs_fileio_aops;
         return 0;
}

Thanks,
Gao Xiang

