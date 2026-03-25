Return-Path: <linux-erofs+bounces-2979-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031D1FEC0F4
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Mar 2026 01:01:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgTBB23fLz2ygh;
	Wed, 25 Mar 2026 12:01:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774400482;
	cv=none; b=MOAQ9AAF1VmdVDtLLr1KM8FHlB5hF5FZ7jyyqWqBABWpDx1DU/8yRHs0fq36I2DLyuUWaCM/Ff/Izj4CcXfz4PAz1wSmKLQu2UgkHLCacwk/f8Y7mztP/iOIwWmJJuO8rnA57FEYOoG6km1bF57nFWo7LHoGqlgXy9XdHulauJ7bTeVvci2LfvbQrt4Get5Z7FToE4WlgpYIT8afzmAgzkKWEd8X3jD5wcpYax0oR3CmMlit9yEY2xvb0rGNnOGYh0qCSkqOSx5Q819hBapAT79m95UvScrTWh5ROl0tIjYGjTe/e+zpgub9Tx7U1VIEjz8vUXcxvsrsaZdB789NPg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774400482; c=relaxed/relaxed;
	bh=lCVVCb6bvjigpk0YgQbcxBqpg/Dxtj+wiLOaZEtNyh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ABtdPRkqeK0449bnr1tsfdJyBGoAxZL0DMDFpa7gzDtjlAv0ah+uiT9nEIh8iQWOrgtRRkoNI8Rsjal1rSEtLFk8ttXQuokEHrQa1H5i80/e46BxPmvBNem0nJunPwJWLERvR9oWoFtsU3ieBLsudH90YW/dkCfSbwsJJTJ5O5h7B+2qB4e2iFHmTowkxIztUY0RPzjiDhPv0AoA/f6p4cm2t5uSH+kci/v1MJPh+CayVUKnq1RitkjS39ogRjr8uGEweeCO06SwZ3Qg/Q7QNwj+j3u7bjXofj8fKh2WNrzA6ymB1l91FAiW9PNI3ozyONPL1zRrzAC2215x99irjA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ELzxRQRX; dkim-atps=neutral; spf=pass (client-ip=113.46.200.219; helo=canpmsgout04.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ELzxRQRX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.219; helo=canpmsgout04.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgTB817dNz2yTK
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Mar 2026 12:01:17 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lCVVCb6bvjigpk0YgQbcxBqpg/Dxtj+wiLOaZEtNyh4=;
	b=ELzxRQRXSMLIjuAM5Xp23+lewOig+Oza1sqzTH0Akl2nuxGQ2/UJXgMnfdcvMLpp4oWmSn+zE
	Wlbxk8JC9U/voBSs2Sx+ezm9Vq8YW3/NINmNBUoYHXGuy01DYPyv3hID7svX2I+Y8IQyrCpkObN
	a3wxuer7gRyj2P16AYQ+VUc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fgT2w700vz1prmY;
	Wed, 25 Mar 2026 08:55:04 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 239CE40561;
	Wed, 25 Mar 2026 09:01:13 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemr500015.china.huawei.com (7.202.195.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Mar 2026 09:01:12 +0800
Message-ID: <31af2fe2-76f8-47b4-a18d-64b487847ba5@huawei.com>
Date: Wed, 25 Mar 2026 09:01:11 +0800
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
Subject: Re: [PATCH v2] erofs: fix .fadvise() for page cache sharing
To: Gao Xiang <hsiangkao@linux.alibaba.com>, <linux-erofs@lists.ozlabs.org>
CC: LKML <linux-kernel@vger.kernel.org>
References: <20260324155407.371642-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20260324155407.371642-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500015.china.huawei.com (7.202.195.162)



On 2026/3/24 23:54, Gao Xiang wrote:
> Currently, .fadvise() doesn't work well if page cache sharing is on
> since shared inodes belong to a pseudo fs generated with init_pseudo(),
> and sb->s_bdi is the default one &noop_backing_dev_info.
> 
> Then, generic_fadvise() will just behave as a no-op if sb->s_bdi is
> &noop_backing_dev_info, but as the bdev fs (the bdev fs changes
> inode_to_bdi() instead), it's actually NOT a pure memfs.
> 
> Let's generate a real bdi for erofs_ishare_mnt instead.
> 
> Fixes: d86d7817c042 ("erofs: implement .fadvise for page cache share")
> Cc: Hongbo Li <lihongbo22@huawei.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> v2:
>   - handle super_setup_bdi() failure properly.
> 
>   fs/erofs/ishare.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
> index 829d50d5c717..ec433bacc592 100644
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -200,8 +200,19 @@ struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
>   
>   int __init erofs_init_ishare(void)
>   {
> -	erofs_ishare_mnt = kern_mount(&erofs_anon_fs_type);
> -	return PTR_ERR_OR_ZERO(erofs_ishare_mnt);
> +	struct vfsmount *mnt;
> +	int ret;
> +
> +	mnt = kern_mount(&erofs_anon_fs_type);
> +	if (IS_ERR(mnt))
> +		return PTR_ERR(mnt);
> +	/* generic_fadvise() doesn't work if s_bdi == &noop_backing_dev_info */
> +	ret = super_setup_bdi(mnt->mnt_sb);
> +	if (ret)
> +		kern_unmount(mnt);
> +	else
> +		erofs_ishare_mnt = mnt;
> +	return ret;
>   }

ok, looks good.

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

Thanks,
Hongbo

>   
>   void erofs_exit_ishare(void)

