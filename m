Return-Path: <linux-erofs+bounces-2774-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7ACFB5EA6
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 02:16:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZbDZ2cgCz2yVP;
	Tue, 17 Mar 2026 13:16:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773713790;
	cv=none; b=D+QyK9uv3iH9ws8eF/yCbgCY5K5wPrT9PU4IhaTQxHULPhy6kFMnapcOeIoUWVw9dqRasN8ndd9saKZNuu8dNnDbwHqdcEyA2QnO0vgoROEM0orkxd/jYwyDWFyUb3oJ0O+wi378Sxixq0C9EM8yopLrHxS9Rcwwjx/+kDF5Q71881h1Hs715cEJjTWJ0cPdI3T+PYtQLKm8piNx0cX/cPkRoXgNIOXuLUEcutqLMyDKanrw2vfhBmChViJ1FNY7CtlQVnUBQvq2vOfTkQ9eGx+gwWLs/BGmWuFSpa5gldcNtG4MAkXawfv2c3RZwVoT12Kr5OLepomDQ7YE+VbTHg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773713790; c=relaxed/relaxed;
	bh=QJQLS13vQviNyQxlEp0NeOQaKM59IrW6ra1sn0ir/Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mQFVLijoTFcATr9aeM8AM8F57fC/IbGdyTaPthXT1Gdz2s622Ry5NpmP+xM46Z0w2cytI9uNKRufECyyXKFTnuM5vnXzRxG+fHZ5HO35RkA8pDn8NcBMFNXRffEfz+TOuOJJX7C0edswbFeYa7jlNO3DkFZKfbv0vew45Elbwc+zND+l2J08F8lIWSFbKXnudNhL+Tr29QjuYgyilIaTycZkCiMP6Wmkc3+L/JUcDV1JwDzPu84d+eRpaQqamtDCd/Z6TCdJ0HJhmiQQUw3NJ7W5iW63lN94O6U5lFumHxTKmW+plldEs8aF/yUBFqTC7y5aKaIwv90yILjWuncC7w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fTuaAZRA; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fTuaAZRA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZbDX04lFz2yTK
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 13:16:25 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773713781; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QJQLS13vQviNyQxlEp0NeOQaKM59IrW6ra1sn0ir/Sk=;
	b=fTuaAZRAgmor9/LKmin16/akVx7Chrs9X2lv3Q/wh0QKRBKi0ZCJcCpbbWNdRcKmHJnV9MzX6FHy3fhpgmIfD/IOxgS5dOWgEWatjp0KWeZAZNIDSDu4QUPdNnUmo3hjHm5E6hTk+5mm6O7hFXr9jY9yZvlB9ggzwhyL4Ziz3mc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X.9Hg6A_1773713779;
Received: from 30.221.133.143(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.9Hg6A_1773713779 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 10:16:20 +0800
Message-ID: <964b9ef0-388e-4b92-becf-2bd9094893db@linux.alibaba.com>
Date: Tue, 17 Mar 2026 10:16:19 +0800
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
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20260316201919.41839-1-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260316201919.41839-1-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/17 04:19, Utkal Singh wrote:
> erofs_init_inode_xattrs() reads h_shared_count directly from the on-disk
> xattr ibody header and uses it to size a heap allocation and drive a
> read loop without checking whether the implied shared xattr array fits
> within xattr_isize.
> 
> A crafted EROFS image with a large h_shared_count but a minimal
> xattr_isize causes the subsequent loop to read shared xattr entries
> beyond the xattr ibody boundary, interpreting unrelated on-disk data
> as shared xattr IDs.  This affects every library consumer -- dump.erofs,
> erofsfuse, and the rebuild path (lib/rebuild.c) -- none of which call
> the fsck-only erofs_verify_xattr() before reaching this code.

I don't think other than fsck tool, this must be checked, since it
won't cause any harmful behavior but the filesystem image is already
corrupted, and because of the corruption, the user should get the
corrupted result, but it still have no impact to the whole system
stablity.

> 
> Validate that h_shared_count fits within the available xattr body space
> before allocating or reading.  Use a division-based check to avoid any
> theoretical overflow in the multiplication.

I don't think it will overflow according to the ondisk format.

> 
> The subtraction is safe because callers above already reject
> xattr_isize < sizeof(struct erofs_xattr_ibody_header).

Please add a reproducible way.

> 
> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
> ---
>   lib/xattr.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/lib/xattr.c b/lib/xattr.c
> index 565070a..6891812 100644
> --- a/lib/xattr.c
> +++ b/lib/xattr.c
> @@ -1182,6 +1182,16 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
>   
>   	ih = it.kaddr;
>   	vi->xattr_shared_count = ih->h_shared_count;
> +	/* validate h_shared_count fits within xattr_isize */
> +	if (vi->xattr_shared_count >
> +	    (vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) /
> +			sizeof(u32)) {

Can we avoid division?

> +		erofs_err("bogus h_shared_count %u (xattr_isize %u) @ nid %llu",
> +			  vi->xattr_shared_count, vi->xattr_isize,
> +			  vi->nid | 0ULL);
> +		erofs_put_metabuf(&it.buf);
> +		return -EFSCORRUPTED;
> +	}
>   	vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count * sizeof(uint));
>   	if (!vi->xattr_shared_xattrs) {
>   		erofs_put_metabuf(&it.buf);


