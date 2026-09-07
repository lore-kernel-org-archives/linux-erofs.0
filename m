Return-Path: <linux-erofs+bounces-4489-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E191C79F89
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 11:12:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdktm22YZz2yvP;
	Mon, 07 Sep 2026 21:12:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=162.62.57.210
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788779552;
	cv=none; b=Zku+1Oy7mw49wMCSR6/yioLFLavkdiXi8drwTA/xUtTHvuhR9K8A6vO7yiA5GYYwZQbma7GC6r5p8ppJOhXvDiKz0i41e4Gid8Sxba4v9mEOzIgQvrYyOBGayq59N/+ufdeH/nMXm8h8ZQy5kG5og97Vp00aflyDdkL9YVUPjC+j/wqwTy7S5W6k5L5FvsUTttf6z4JzWg3xaR+l/ucJvGzObVI0CrKmGVJjPvhFXD1WV9wgTkGjUrxXizvjqTv9MA4JLt/ttvuWzbR+3Bgx9feAk9SzsqfBhuhPz4cIm2Hkh1Rfn+1M5jlQKLN3pxXaEmDxrfnrJOlQdrZNnnqaUw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788779552; c=relaxed/relaxed;
	bh=xL/RUKcMfTNpuBM4DBev+X4S75F9/VVNtRorB4a8Bkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=osMih11TbMOYDsk2YGmS3ywU5BtApDCopyqNnGaxx00ceZpi52AU8CP1i4sDCNKq5m7Zcu8sM2S41QKmai6zBqKtR4b0ipP/JNueL5YY2Cfd94aV2VExo7Ern0JlJ7nVdvoc4rQLjl6e+/7JBP6vNnb7wsbZXBHmX6ptShGsnNS2+49siYvR8puE3XK6WJvrrBwZIxw7KXxrbonm4tvc6ygx8xLDKQ34badl7enGHgcumZZfyr1Oz8jV1+cLrhosejrF/wRwXAupIq+JWrqURYARSFaAG7mtjATUHucj1fbjhlPGMz9NRV8KoqrRRopiEUmCCENIwqRTAHrziAXKiw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=dOIGPM11; dkim-atps=neutral; spf=pass (client-ip=162.62.57.210; helo=out162-62-57-210.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=foxmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=dOIGPM11;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=foxmail.com (client-ip=162.62.57.210; helo=out162-62-57-210.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org)
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdktd5flyz2yjw
	for <linux-erofs@lists.ozlabs.org>; Mon, 07 Sep 2026 21:12:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1788779538;
	bh=xL/RUKcMfTNpuBM4DBev+X4S75F9/VVNtRorB4a8Bkg=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=dOIGPM11ir9oucxlzaDB8wkC+aQAnzduWC0b4xYYKbDdNaFaYBotl3T4VTWRnhezi
	 RBvYjV2CeHdBVp/YoA27E/mQaPVWSBiFfQoKSqM4M6vfMXlvdFn+zbATfmTxW/r5PN
	 GVrnsHvVu3dLrvM6VbF1E91PyRh7evcdbOPNsqFM=
Received: from [127.0.0.1] ([124.70.231.58])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 112B9AE2; Mon, 07 Sep 2026 19:04:18 +0800
X-QQ-mid: xmsmtpt1788779058t8ubvr2x9
Message-ID: <tencent_B0673C3FB942146BB5B3CD80ADEE2CDBD20A@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5Mg3w2A37VF6Nnb7NHEmm0HZukIOuJoHFnJ8WUXaO7kDYby2lS/
	 s6gnF8jLfPqT4WJSotFhpqga5PQUUuM0ChyLl3QHYnq3sU82zyg4MvAX7JGxeKHEK+J+sUTcx88S
	 tRnDdSxDb42BaCvt7U+DyH72bso4y9rM9xnLbseyM2GCOBAmD/tlHxhRvima345efzL9D14JnkBA
	 NmZfeGiF0NIp/21qeODsdK19I4b0B6pUESzHe/0sS3+h66zvGohSoJnFi70Qw5i4xByIXnSrtkEX
	 1Qb4BHO9AQwd71ehE+CxGVS6oxU7LYhJnibinTCUpfbbJO8J7CFxaMUjneG007FSHJVLk6DDwbjp
	 C1tKZlrhBEkFjjnh2QpDocW9B//4CcxPO4A4zZSpwKHSMKztDo9XxVcJO0zHxB2XsicYGxuic5oL
	 QbRgToPwwQqm7CqClB6XOfAwaE8RcYiTUtNtIFSUgdrxomG7FOU9Zz6Y5HfcYe9Wywz3ZC/6NB3E
	 lgNGbMTxR0QBP4kpGD6lpaBnFQTS66RkZ9RA0eyXBFwWRVggLHB0Pep7udh/yA7UkNPWw2bvEEgc
	 xkHwDHiF9vts6HfRaolU/rcAYUwbsRyj5tfU4RnvFFNqTwqHmuSSEnSuq2OjU4a8ujzJOxhK/fMm
	 OvjGjBVj7J4ZaauNyKXxPi4kiEYa88f09ZmwBIQq1qyqsrEIXckibYvZJLsQNsagUn1ibBuCZ1gb
	 w0d9pgFUbwD5iv31TqjQipatrFJblptzs8ntixL3WmJos37iEXZKQh+vytVERpAgn501f/oRT9nw
	 B/OKwL8DUwUZmzHf8aXSKNngifj8b5NoBLN0sAsLkRA5faby85XweF2gplyIqrTxfAIRN0LA2HaS
	 928YzIq0xaXp/jQoYiMyAUv+QHK0PyQ/uPWXpj15lMQhSWQffVbPO/RqqJ3aYjZLR5xPxRmE/bg2
	 xPjB9F+vbBodQfLq7K2vuWlmhQlqWWFF+HNIt41CLi/ura1S237eepcloaISCbh9T3FDH/02izr5
	 7E4BA+8d5pbn8INX/w
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-OQ-MSGID: <c2c74072-4797-44c4-a780-bb1ee25d5c11@foxmail.com>
Date: Mon, 7 Sep 2026 19:04:18 +0800
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
Subject: Re: [PATCH 2/2] erofs-utils: lib: fix direct S3 writes to blob
 devices
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260907083027.13793-1-xiang@kernel.org>
 <20260907083027.13793-2-xiang@kernel.org>
Content-Language: en-US
From: Yifan Zhao <yifan.yfzhao@foxmail.com>
In-Reply-To: <20260907083027.13793-2-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

missing #include "liberofs_cache.h" in s3.c

remotes/s3.c: In function 's3erofs_remote_getobject':
remotes/s3.c:1068:54: error: invalid use of undefined type 'struct 
erofs_bufmgr'
  1068 |                         sbi->devs[device_id - 1].bmgr->vf : 
&sbi->bdev;


Thanks,

Yifan

On 7/9/26 16:30, Gao Xiang wrote:
> From: Yifan Zhao <yifan.yfzhao@foxmail.com>
>
> Direct S3 writes target the primary device and may leave the selected
> blob device shorter than its allocated extent.
>
> Write objects at device-relative offsets on the selected device.
> and extend it to the final block boundary.
>
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Yifan Zhao <yifan.yfzhao@foxmail.com>
> Signed-off-by: Gao Xiang <xiang@kernel.org>
> ---
>   lib/remotes/s3.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
> index 56ab808..01dd1ff 100644
> --- a/lib/remotes/s3.c
> +++ b/lib/remotes/s3.c
> @@ -1054,15 +1054,19 @@ static int s3erofs_remote_getobject(struct erofs_importer *im,
>   
>   	resp.pos = 0;
>   	if (!sbi->available_compr_algs && im->params->no_datainline) {
> +		unsigned int device_id = im->params->ddev_id_def;
> +
>   		inode->datalayout = EROFS_INODE_FLAT_PLAIN;
>   		inode->idata_size = 0;
>   		ret = erofs_allocate_inode_bh_data(inode,
>   				DIV_ROUND_UP(inode->i_size, 1U << sbi->blkszbits),
> -				im->params->ddev_id_def);
> +				device_id);
>   		if (ret)
>   			return ret;
> -		resp.vf = &sbi->bdev;
> -		resp.pos = erofs_pos(inode->sbi, inode->u.i_blkaddr);
> +
> +		resp.vf = device_id ?
> +			sbi->devs[device_id - 1].bmgr->vf : &sbi->bdev;
> +		resp.pos = erofs_pos(sbi, erofs_inode_dev_baddr(inode));
>   		inode->datasource = EROFS_INODE_DATA_SOURCE_NONE;
>   	} else {
>   		if (!inode->i_diskbuf) {
> @@ -1179,7 +1183,7 @@ int s3erofs_build_trees(struct erofs_importer *im, struct erofs_s3 *s3,
>   		ret = __erofs_fill_inode(im, inode, &st, obj->key);
>   		if (!ret && S_ISREG(inode->i_mode)) {
>   			inode->i_size = obj->size;
> -			if (fillzero)
> +			if (fillzero || !inode->i_size)
>   				ret = erofs_write_zero_inode(inode);
>   			else
>   				ret = s3erofs_remote_getobject(im, s3, inode,


