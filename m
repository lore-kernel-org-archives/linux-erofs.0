Return-Path: <linux-erofs+bounces-2227-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D5CD35687
	for <linux-erofs@archiver.kernel.org>; Wed, 28 Jan 2026 07:03:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f1Csl2ys7z2xT6;
	Wed, 28 Jan 2026 18:03:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.221
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769583803;
	cv=none; b=ahd9bnuqoMkHX8bUEC6J94QD9oaRykKMEDycK93iddj6+aFTLIaTKB9pVnhfVhpiGv8kMxm0Z4LkIcBZ5t+Ydx2CgjQf1DfrLo9OJc/1wg5ZH0qzADT6a1qb4sTdnasUAn77EDDkyu7AZvJFgaWk1Yb1hPCigepw8xvu4GpzBwapKA1CcJpEI2ul2TECl3kF2vYtjMX1ZIWdGS7H5TDmz6r6eRpIxtI4SP16OFpiARNATg33k/mcq5kPR2j6Yw4RKRJN1igJnnkAZt1YS4bH7hwYlwkMhyamXEkM0VYFsvi62iaho6vylbrXWIAF85gLKFVBRMqPFC3pdH09GWlrUA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769583803; c=relaxed/relaxed;
	bh=2JE77C3WoMF07IQoxW1zz8PRs9ELDFw0flhm0hIqVt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bvLZHQ0wjP7bLy8mYxukWrlDARNx2ZXjTPhT5jmwWuokPdWLD6ugW7Tw6LFTEbH8n3DRHFzAJ+zRkA6gQBuRwg67zJfwdvrlFfpRMyZ2FwkQ/O/u+zsSfubEBlPTIo8rMaCCgvDXLlW42KVTkO+Gh98NDtGV7mTI2pngXSiOJTBbbWh9dJ9RhOZx65OHSijnpsHnvAKZ+EBHXSpJxEfGRmFr6AttyRqq+iWtol6BznuAswf+huRCVzQGPtbdgn85FcZYxKDYJyb1PaIxuZQOP0fGBL+mSREP1DC0eHlyZvTKcRHJafgifgvhhzk2zOTWE3YMlVh/2Eh/oc/RPtzimw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=GDWzbg0V; dkim-atps=neutral; spf=pass (client-ip=113.46.200.221; helo=canpmsgout06.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=GDWzbg0V;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.221; helo=canpmsgout06.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f1Csh1n9Lz2xHt
	for <linux-erofs@lists.ozlabs.org>; Wed, 28 Jan 2026 18:03:17 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2JE77C3WoMF07IQoxW1zz8PRs9ELDFw0flhm0hIqVt4=;
	b=GDWzbg0VGF5OyCe0TUgRocjgDQFnuRR0QMeSFXWWbV64IHRWbuMcQGOuSI6BzQvH4pjDFKzky
	yTmVrItBuUJEl5yMyenSmIuiozdJDNKxTRJsv3H/CKO+LVhJ9BNFMpKAKsb8m4T46nHY6eAbq9V
	uP06GGBSgXrtqwDDOD5T7GM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4f1CnS3n5yzRhs8
	for <linux-erofs@lists.ozlabs.org>; Wed, 28 Jan 2026 14:59:40 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id A1D9940538
	for <linux-erofs@lists.ozlabs.org>; Wed, 28 Jan 2026 15:03:08 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemr500015.china.huawei.com (7.202.195.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 28 Jan 2026 15:03:08 +0800
Message-ID: <bac55082-bb1b-4e7c-8a53-95394bb9a5ec@huawei.com>
Date: Wed, 28 Jan 2026 15:03:07 +0800
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
Subject: Re: [PATCH] erofs: mark inodes without acls in erofs_read_inode()
To: <linux-erofs@lists.ozlabs.org>
References: <20260128035408.2172802-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20260128035408.2172802-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500015.china.huawei.com (7.202.195.162)

Hi, Xiang

On 2026/1/28 11:54, Gao Xiang wrote:
> Similar to commit 91ef18b567da ("ext4: mark inodes without acls in
> __ext4_iget()"), the ACL state won't be read when the file owner
> performs a lookup, and the RCU fast path for lookups won't work
> because the ACL state remains unknown.
> 
> If there are no extended attributes, or if the xattr filter
> indicates that no ACL xattr is present, call cache_no_acl() directly.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>   fs/erofs/inode.c |  5 +++++
>   fs/erofs/xattr.c | 20 ++++++++++++++++++++
>   fs/erofs/xattr.h |  1 +
>   3 files changed, 26 insertions(+)
> 
> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> index bce98c845a18..2e02d4b466ce 100644
> --- a/fs/erofs/inode.c
> +++ b/fs/erofs/inode.c
> @@ -137,6 +137,11 @@ static int erofs_read_inode(struct inode *inode)
>   		err = -EFSCORRUPTED;
>   		goto err_out;
>   	}
> +
> +	if (IS_ENABLED(CONFIG_EROFS_FS_POSIX_ACL) &&
> +	    erofs_inode_has_noacl(inode, ptr, ofs))
> +		cache_no_acl(inode);
> +
>   	switch (inode->i_mode & S_IFMT) {
>   	case S_IFDIR:
>   		vi->dot_omitted = (ifmt >> EROFS_I_DOT_OMITTED_BIT) & 1;
> diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
> index 512b998bdfff..14d22adc1476 100644
> --- a/fs/erofs/xattr.c
> +++ b/fs/erofs/xattr.c
> @@ -574,4 +574,24 @@ struct posix_acl *erofs_get_acl(struct inode *inode, int type, bool rcu)
>   	kfree(value);
>   	return acl;
>   }
> +
> +bool erofs_inode_has_noacl(struct inode *inode, void *kaddr, unsigned int ofs)
> +{

How about put the definition and declare of erofs_inode_has_noacl before 
the erofs_get_acl helper? Since it is no need to resolved the context 
conflicts for page sharing.

Otherwise it looks good to me:
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

Thanks,
Hongbo

> +	static const unsigned int bitmask =
> +		BIT(21) |	/* system.posix_acl_default */
> +		BIT(30);	/* system.posix_acl_access */
> +	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
> +	const struct erofs_xattr_ibody_header *ih = kaddr + ofs;
> +
> +	if (EROFS_I(inode)->xattr_isize < sizeof(*ih))
> +		return true;
> +
> +	if (erofs_sb_has_xattr_filter(sbi) && !sbi->xattr_filter_reserved &&
> +	    !check_add_overflow(ofs, sizeof(*ih), &ofs) &&
> +	    ofs <= i_blocksize(inode)) {
> +		if ((ih->h_name_filter & bitmask) == bitmask)
> +			return true;
> +	}
> +	return false;
> +}
>   #endif
> diff --git a/fs/erofs/xattr.h b/fs/erofs/xattr.h
> index 36f2667afc2d..a3ceefa1554d 100644
> --- a/fs/erofs/xattr.h
> +++ b/fs/erofs/xattr.h
> @@ -30,4 +30,5 @@ struct posix_acl *erofs_get_acl(struct inode *inode, int type, bool rcu);
>   #define erofs_get_acl	(NULL)
>   #endif
>   
> +bool erofs_inode_has_noacl(struct inode *inode, void *kaddr, unsigned int ofs);
>   #endif

