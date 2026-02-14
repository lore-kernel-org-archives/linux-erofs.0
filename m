Return-Path: <linux-erofs+bounces-2317-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEBCEF99EA
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Feb 2026 01:04:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fCW6K6wkCz2xln;
	Sat, 14 Feb 2026 12:04:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771031097;
	cv=none; b=Oi4U+uWg72nBfBZVoBCDEozBDZSFYD3J90MkgTvq/ku+Cko1c+hwAyishonrC1VLQ5vCB1zEWCILptnZRLws5UPLjPjXO+fqwl+/5N/XUwq/adwTd3QAt/rxlvi9OBV2AuzdpVbphCmJuA+62WABkFKYsCJT27ZQpiI+RzwOvEE7Wv4MVU4Bqm5cXm0GZQOMCo4/RSRYiQXjQQztULujNzUtfWlRgOuYUlOmJ5B9FIZWya6WYpN8R/IhgXGxWDNcbR0OOW3H9BZNw1PkzcJANngAwn9io2ECiRFSmT7HpnQaRffZHrCxK6qz2/gMV0L22/d6/FU9bxLnjq5HuLWbsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771031097; c=relaxed/relaxed;
	bh=b8jpKimESx6PTjh1R8HBGFIOfiD1ZYYbNxc4mg8sUxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:CC:From:
	 In-Reply-To:Content-Type; b=dLkKBXtMFN3/bxzkNBq4Espn7X6YY7B9BzjoEgbZi7C0z9Cs3Og7xxdz0RIbo87APsh3bojJNDG/gnkoNQHplDKzmjCEnUMlTllrf6w3ljLSUzbLoNjkFLCTbrcWx18gpFChxesiQDnZ329BYlTlaV31Sgw0vaw4hgIclblIozO11DuNzWst9rcXMM763RUKevZMGBQvh5NcqkFa9EOuFFSBLYKF0MF78Jtudg+M+syOZ+mZ/MOHqwhOJE39frcAqHxwhLqtzOF0irTufbxTMjepj13kCdMd+rCzOM3uJKEBia6i58pznZIop2ktTQaLcCmZ6fRKnmH2SVnIcn27Fg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JFU45E0k; dkim-atps=neutral; spf=pass (client-ip=113.46.200.220; helo=canpmsgout05.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JFU45E0k;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.220; helo=canpmsgout05.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fCW6H15jZz2xSF
	for <linux-erofs@lists.ozlabs.org>; Sat, 14 Feb 2026 12:04:52 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=b8jpKimESx6PTjh1R8HBGFIOfiD1ZYYbNxc4mg8sUxE=;
	b=JFU45E0kfomb8J/BbVltQXIzVybu4oSLohBviveEztAUfCyY+2KLj/4i2BG2tdsjqQGsr7xSD
	6X6+POroXpSPNMV28pUASz7eLTNNTA8xMGFG2zg4Kx1UvoVBX38o4TuKsBtxu60HgW//hWDKAIh
	6dYs5BErJPbb5mC6cHjVeLs=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fCW0c5CjDz12LDJ;
	Sat, 14 Feb 2026 09:00:00 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id CE3D42012A;
	Sat, 14 Feb 2026 09:04:47 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemr500015.china.huawei.com (7.202.195.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Feb 2026 09:04:47 +0800
Message-ID: <c1cbb47f-2d18-4bf9-9c56-a6bbb3c1ed0f@huawei.com>
Date: Sat, 14 Feb 2026 09:04:46 +0800
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
Subject: Re: [PATCH] erofs: allow sharing page cache with the same aops only
To: <xiang@kernel.org>
References: <20260213073345.768320-1-lihongbo22@huawei.com>
 <aY-zU-R52VrbhGpL@debian>
Content-Language: en-US
CC: <chao@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <hsiangkao@linux.alibaba.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <aY-zU-R52VrbhGpL@debian>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500015.china.huawei.com (7.202.195.162)



On 2026/2/14 7:27, Gao Xiang wrote:
> Hi Hongbo,
> 
> On Fri, Feb 13, 2026 at 07:33:45AM +0000, Hongbo Li wrote:
>> Inode with identical data but different @aops cannot be mixed
>> because the page cache is managed by different subsystems (e.g.,
>> @aops for compressed on-disk inodes cannot handle plain on-disk
>> inodes).
>>
...
>>
>> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
>> index 4f86169c23f1..5b05272fd9c4 100644
>> --- a/fs/erofs/inode.c
>> +++ b/fs/erofs/inode.c
>> @@ -254,7 +254,8 @@ static int erofs_fill_inode(struct inode *inode)
>>   	}
>>   
>>   	mapping_set_large_folios(inode->i_mapping);
>> -	return erofs_inode_set_aops(inode, inode, false);
>> +	inode->i_mapping->a_ops = erofs_get_aops(inode, false);
>> +	return IS_ERR(inode->i_mapping->a_ops) ? PTR_ERR(inode->i_mapping->a_ops) : 0;
> 
> I hope there is an aops variable instead of assigning
> inode->i_mapping->a_ops directly.
> 

Ok, thank you.
>>   }
>>   
>>   /*
>> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
>> index d1634455e389..764e81b3bc08 100644
>> --- a/fs/erofs/internal.h
>> +++ b/fs/erofs/internal.h
>> @@ -471,26 +471,24 @@ static inline void *erofs_vm_map_ram(struct page **pages, unsigned int count)
>>   	return NULL;
>>   }
>>   
>> -static inline int erofs_inode_set_aops(struct inode *inode,
>> -				       struct inode *realinode, bool no_fscache)
>> +static inline const struct address_space_operations *
>> +erofs_get_aops(struct inode *realinode, bool no_fscache)
>>   {
>>   	if (erofs_inode_is_data_compressed(EROFS_I(realinode)->datalayout)) {
>>   		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
>> -			return -EOPNOTSUPP;
>> +			return ERR_PTR(-EOPNOTSUPP);
>>   		DO_ONCE_LITE_IF(realinode->i_blkbits != PAGE_SHIFT,
>>   			  erofs_info, realinode->i_sb,
>>   			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
>> -		inode->i_mapping->a_ops = &z_erofs_aops;
>> -		return 0;
>> +		return &z_erofs_aops;
>>   	}
>> -	inode->i_mapping->a_ops = &erofs_aops;
>> -	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && !no_fscache &&
>> -	    erofs_is_fscache_mode(realinode->i_sb))
>> -		inode->i_mapping->a_ops = &erofs_fscache_access_aops;
>>   	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) &&
>>   	    erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
>> -		inode->i_mapping->a_ops = &erofs_fileio_aops;
>> -	return 0;
>> +		return &erofs_fileio_aops;
>> +	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && !no_fscache &&
>> +	    erofs_is_fscache_mode(realinode->i_sb))
>> +		return &erofs_fscache_access_aops;
> 
> Can you rearrange it as
> 	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && !no_fscache &&
> 	    erofs_is_fscache_mode(realinode->i_sb))
> 		return &erofs_fscache_access_aops;
> 	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) &&
> 	    erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
> 		inode->i_mapping->a_ops = &erofs_fileio_aops;
> 	return &erofs_aops;
> 
Ok, they are equal. Since the EROFS in fscache mode can be fileio mode. 
And I will rearrange it in next version.

Thanks,
Hongbo

> ?
> 
> Thanks,
> Gao Xiang
> 

