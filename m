Return-Path: <linux-erofs+bounces-3586-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26A0CD8CA8
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jun 2026 01:26:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gdssM5vjnz2yT0;
	Mon, 15 Jun 2026 11:26:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=45.249.212.187
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781486791;
	cv=none; b=egseItS0mKtHXt6Yj8BRD7tzRKdktaqBPVNLB/CPFF/iE+QEBxXMhPhuJqJB2RSIKvo7P57hhEQhmJLjEF02pjB6BUTj8/Ccfhib/sIW+quxXpigTUDJc3cxJfYeq7Xkaxctov6ZeoIfxH31qD1OHwLorR8aRVmiiagr9tawq/0bVE+r1aPoOzHCVDTUhziJcD1AtSyjDUO98GeXkzX65u7VhlxPjZxZ9C3GCvWunvrGe0AgtMIs8jbejhjQdwbBljI9PBHg/1x1bkYpHcHi866LRzKoc5HUB6QCF7ANYWeqaLPiGUqrsVQMPcygtw4LKhWj5u41muwgFmyWKLHSRA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781486791; c=relaxed/relaxed;
	bh=tIUCnVj6NdE+05UAjJNPyabizqyUB0Qk7xKO+9pSNys=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NA3qZRCq8/9rYzMc8vwX9cBuxJN8Ul4CERTz5voddl4P23K46DAC1qmE4SqdBQ/jtEKl/IiL/DL2o9LHOiIiCwz0//6xYKE1fWB+OhEiin4n4Si1ir1hk/S+oQ2C8R5AYW02uwEn75tE+ykJvmeqyXLb5kngESVEp/I5g7s57D+Oqh86Uxs8/s+bkAD5dcisC3yqPwXOvY/Do3CB4JcZYO2H+MKtqnQ0FbIzbdIRacHtLbb/IQVzUqilTcQFXpk9oPU/IbAameyWOGkzAD1CL4qmpcXKwest0C+R791vyNeopc/KoOQN62IBMSHb1EAj4yiuLnfq8KJn3FO6QOp+AQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B+zuHAA9; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B+zuHAA9; dkim-atps=neutral; spf=pass (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B+zuHAA9;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B+zuHAA9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gdssJ2Klfz2yFc
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 11:26:28 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tIUCnVj6NdE+05UAjJNPyabizqyUB0Qk7xKO+9pSNys=;
	b=B+zuHAA9hrVqGLRH1sovzRe30h42jjkMT/0SjUlD1m5flyS8d6NCFlKWYKDTI51uj88XH+8po
	VELHh9jP4zU8SuQ4s1rabJIH9OJndaUnrF3sv9UBVQcvdzZZWQWuocjbgsb3s6LtWaQK0JF1OxD
	2qoIW1AZHYLwhtgwWy0wskY=
Received: from canpmsgout11.his.huawei.com (unknown [172.19.92.148])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4gdsrm4NLYz1BGLR
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 09:26:00 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tIUCnVj6NdE+05UAjJNPyabizqyUB0Qk7xKO+9pSNys=;
	b=B+zuHAA9hrVqGLRH1sovzRe30h42jjkMT/0SjUlD1m5flyS8d6NCFlKWYKDTI51uj88XH+8po
	VELHh9jP4zU8SuQ4s1rabJIH9OJndaUnrF3sv9UBVQcvdzZZWQWuocjbgsb3s6LtWaQK0JF1OxD
	2qoIW1AZHYLwhtgwWy0wskY=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gdsgr05QtzKm4v;
	Mon, 15 Jun 2026 09:18:16 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 903004048B;
	Mon, 15 Jun 2026 09:26:15 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemr500015.china.huawei.com (7.202.195.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Jun 2026 09:26:15 +0800
Message-ID: <51c13a05-a4f5-4bbe-ad1a-ba167fa2e76c@huawei.com>
Date: Mon, 15 Jun 2026 09:26:14 +0800
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
Subject: Re: [PATCH] erofs: clean up erofs_ishare_fill_inode()
To: Gao Xiang <hsiangkao@linux.alibaba.com>, <linux-erofs@lists.ozlabs.org>
CC: LKML <linux-kernel@vger.kernel.org>, <oliver.yang@linux.alibaba.com>
References: <20260607172132.2695176-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20260607172132.2695176-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500015.china.huawei.com (7.202.195.162)



On 2026/6/8 1:21, Gao Xiang wrote:
>   - Use the shorthand `si` to replace the overly long `sharedinode`;
> 
>   - Introduce erofs_warn() and get rid of barely-used _erofs_printk();
> 
>   - Get rid of the variable `hash`;
> 
>   - Simplify error paths.
> 
> Cc: Hongbo Li <lihongbo22@huawei.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

Thanks,
Hongbo

> ---
>   fs/erofs/internal.h |  2 ++
>   fs/erofs/ishare.c   | 45 +++++++++++++++++++--------------------------
>   2 files changed, 21 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 4792490161ec..9e2ae7b61977 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -23,6 +23,8 @@
>   __printf(2, 3) void _erofs_printk(struct super_block *sb, const char *fmt, ...);
>   #define erofs_err(sb, fmt, ...)	\
>   	_erofs_printk(sb, KERN_ERR fmt "\n", ##__VA_ARGS__)
> +#define erofs_warn(sb, fmt, ...) \
> +	_erofs_printk(sb, KERN_WARNING fmt "\n", ##__VA_ARGS__)
>   #define erofs_info(sb, fmt, ...) \
>   	_erofs_printk(sb, KERN_INFO fmt "\n", ##__VA_ARGS__)
>   
> diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
> index 6ed66b17359b..35cbd0bc04d7 100644
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -40,49 +40,42 @@ static int erofs_ishare_iget5_set(struct inode *inode, void *data)
>   bool erofs_ishare_fill_inode(struct inode *inode)
>   {
>   	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
> -	struct erofs_inode *vi = EROFS_I(inode);
>   	const struct address_space_operations *aops;
> +	struct erofs_inode *vi = EROFS_I(inode);
>   	struct erofs_inode_fingerprint fp;
> -	struct inode *sharedinode;
> -	unsigned long hash;
> +	struct inode *si;
>   
>   	aops = erofs_get_aops(inode, true);
>   	if (IS_ERR(aops))
>   		return false;
>   	if (erofs_xattr_fill_inode_fingerprint(&fp, inode, sbi->domain_id))
>   		return false;
> -	hash = xxh32(fp.opaque, fp.size, 0);
> -	sharedinode = iget5_locked(erofs_ishare_mnt->mnt_sb, hash,
> -				   erofs_ishare_iget5_eq, erofs_ishare_iget5_set,
> -				   &fp);
> -	if (!sharedinode) {
> -		kfree(fp.opaque);
> -		return false;
> -	}
>   
> -	if (inode_state_read_once(sharedinode) & I_NEW) {
> -		sharedinode->i_mapping->a_ops = aops;
> -		sharedinode->i_size = vi->vfs_inode.i_size;
> -		unlock_new_inode(sharedinode);
> +	si = iget5_locked(erofs_ishare_mnt->mnt_sb,
> +			  xxh32(fp.opaque, fp.size, 0),
> +			  erofs_ishare_iget5_eq, erofs_ishare_iget5_set, &fp);
> +	if (si && (inode_state_read_once(si) & I_NEW)) {
> +		si->i_mapping->a_ops = aops;
> +		si->i_size = inode->i_size;
> +		unlock_new_inode(si);
>   	} else {
>   		kfree(fp.opaque);
> -		if (aops != sharedinode->i_mapping->a_ops) {
> -			iput(sharedinode);
> +		if (!si || aops != si->i_mapping->a_ops) {
> +			iput(si);
>   			return false;
>   		}
> -		if (sharedinode->i_size != vi->vfs_inode.i_size) {
> -			_erofs_printk(inode->i_sb, KERN_WARNING
> -				"size(%lld:%lld) not matches for the same fingerprint\n",
> -				vi->vfs_inode.i_size, sharedinode->i_size);
> -			iput(sharedinode);
> +		if (si->i_size != inode->i_size) {
> +			erofs_warn(inode->i_sb, "i_size mismatch (%lld != %lld) for the same fingerprint",
> +				   inode->i_size, si->i_size);
> +			iput(si);
>   			return false;
>   		}
>   	}
> -	vi->sharedinode = sharedinode;
> +	vi->sharedinode = si;
>   	INIT_LIST_HEAD(&vi->ishare_list);
> -	spin_lock(&EROFS_I(sharedinode)->ishare_lock);
> -	list_add(&vi->ishare_list, &EROFS_I(sharedinode)->ishare_list);
> -	spin_unlock(&EROFS_I(sharedinode)->ishare_lock);
> +	spin_lock(&EROFS_I(si)->ishare_lock);
> +	list_add(&vi->ishare_list, &EROFS_I(si)->ishare_list);
> +	spin_unlock(&EROFS_I(si)->ishare_lock);
>   	return true;
>   }
>   

