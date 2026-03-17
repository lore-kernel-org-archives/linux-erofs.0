Return-Path: <linux-erofs+bounces-2793-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2F3FD8744
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 11:30:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZqWW1DRhz2yjV;
	Tue, 17 Mar 2026 22:30:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773747015;
	cv=none; b=eSX6bjriZqEI841Sy9CwUt62hqZt0ZDwDAA5y0cxWnnEUmqBIGF++vgyrYYSIADjV8IeX3ZbamyqV8z9AXYwfBLCqljKsRIfO5SI0/qoz9eygwr0WW9d5f0W6P1zB9CDlOkrSBG2qtjtdUcpwuTdnSy4KPVBEdgESB17PmQ44lVs5JxvKMNmNjPVUcYKTIDzwGlVTAdH64gd5Lhe5DOIUurRrRG829rsErtRO8f3V5IYCe0jfEu91G2pu0+p/2WQL06+pYmPafGLoh6t+1hJ/NiidHmZRB9g0s3DnGug2wdRJD50HuFb9330mzYeFE2rsMlkPc55tWrEenhDg7G9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773747015; c=relaxed/relaxed;
	bh=d8SbDEpEgO4go5LhD2G/yFZRP0UVKYFTzzy4IOaWVXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fWjFa3ne8RVipey/l/B/qZ9gSWdq+lZQgqstuCEVPy2qPN9nwRLpt3FdNoHI3oCGj/VaoWozA/v0JSNG+Hvi3c6fHunrEkuHxsiiluVOFmYUjGjExkxpIjD4JcA6uQexrSmjtP01vmNa5ZoqcXFV4hqnt0fn8hHtEns1X/nrk2QnGMjWG5+x0gbn0p1/ki5V40iERLPh4M8u6IJr4jZdbqnPcivVhTfGRCTJYbsLLHuZTTanlwgpFulm3WM+Olk/yVSvBBx892EJZsTP4sLTzAjyEoWLkzrqSX0DJWwU73erVgmPrjFqBgOFxqVlUPrdLk7H2Ylr0zaKquj1xxwnKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cFAPSS7D; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cFAPSS7D;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZqWS4p6vz2yjN
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 22:30:11 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773747006; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=d8SbDEpEgO4go5LhD2G/yFZRP0UVKYFTzzy4IOaWVXM=;
	b=cFAPSS7DYmN7E92Xfd3Ho+JL84piLjFI6QQhL8433H9vqjVaO+vI02m8Grp2jsZrkX3OktyrubFtnqyyPCsuqOFylrly0CKLD2mnxKUjCCIgmyIEa3QlvbdySymjHQvqv9iLhZ0jdTdRVsYO4qY6ffunuZbuAzkHczQI5X7xWos=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.Aps6M_1773747004;
Received: from 30.221.133.143(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.Aps6M_1773747004 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 19:30:05 +0800
Message-ID: <e8729997-91ca-4bf0-bb52-78eec7fc7f2f@linux.alibaba.com>
Date: Tue, 17 Mar 2026 19:30:04 +0800
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
Cc: xiang@kernel.org, yifan.yfzhao@gmail.com
References: <20260317111743.84988-1-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260317111743.84988-1-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/17 19:17, Utkal Singh wrote:
> erofs_init_inode_xattrs() reads h_shared_count from the on-disk xattr
> ibody header and uses it to size a malloc and drive a loop that reads
> shared xattr IDs.  If h_shared_count exceeds the space available
> within xattr_isize, the loop reads past the intended ibody region
> and the malloc is oversized.
> 
> Validate that h_shared_count does not exceed the number of __le32
> entries that fit after the ibody header.  Return -EFSCORRUPTED with
> a diagnostic message on failure.
> 
> Reproducer:
>    mkdir testdir && echo hello > testdir/a.txt
>    setfattr -n user.test -v val testdir/a.txt
>    mkfs.erofs test.img testdir
>    # corrupt h_shared_count (offset = nid*32 + inode_size + 4) to 0xFF
>    # then: fsck.erofs --extract=/tmp/out --xattrs test_corrupted.img
>    # Without patch: silently processes invalid shared xattr IDs
>    # With patch: returns -EFSCORRUPTED
> 
> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
> ---
>   lib/xattr.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/lib/xattr.c b/lib/xattr.c
> index 565070a..5888602 100644
> --- a/lib/xattr.c
> +++ b/lib/xattr.c
> @@ -1182,6 +1182,14 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
>   
>   	ih = it.kaddr;
>   	vi->xattr_shared_count = ih->h_shared_count;
> +	if (vi->xattr_shared_count >
> +	    (vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) /
> +	    sizeof(__le32)) {
> +		erofs_err("invalid h_shared_count %u in nid %llu",
> +			  vi->xattr_shared_count, vi->nid | 0ULL);
> +		erofs_put_metabuf(&it.buf);
> +		return -EFSCORRUPTED;
> +	}

Again, why not `vi->xattr_shared_count * sizeof(__le32) >
	vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)`?

Thanks,
Gao Xiang

