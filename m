Return-Path: <linux-erofs+bounces-3256-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732E4EA3C5C
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 06:54:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsSFm5DCxz2yZ6;
	Fri, 10 Apr 2026 16:54:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775804044;
	cv=none; b=mlOw2bPcLGTSmGPV2ONXXl5QSl0qXlBWcU0+WImNq6q45HpH241YUN49YB8dtlp/P0bmwjPZRnPnL2WHHujIkHnWUkhotHj3yXf6NJHqtl2+bTOKZD0f0pzdf14bUphzUjaUxYHs1XQkCYcSSQoT3dM/GC8ALMvNS6uE0sPvVNvqxxpV0DuVPig8a6AOEW0IxofkdRRt6YgHo8S1VjwK3v6QwfuaUUhPbMIbC7FbDE1cQLOM/TVK4gCMCFES9YPiU82o/tNWW8UoZuTa9Mc5txv/HFUf8rpkLnJMLbhtNssSLjNj+4fDP7Y0iLwu7+bK7uhS2Jjbkv+u4xRdb5oVQw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775804044; c=relaxed/relaxed;
	bh=hv3yx+Z5xGwtPsumKZcBu9Ev0HSuYFqAR7IiXit0aUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kv2IFCpm8avhEkbKYdnttT1baOS+Z2H+Ki9m3S4g0pwQOGx7LAlLix1pscL598FU4jGeryLC2xY+2bA4JTp4W2EA58dhjWf9o+kw4HpuMFrcsGrPGD/1lBk4rVNPgHstpmdli66cNXq6prPgD1fpxrW4UxgSZMxWkpYdtFfom6Ni0s54w6TqDJoiZNnEVWt7s7QyMazuarGDmTlNmtFXT647vacFemf0xTsgqizOFUWPinpVfoXbCjsKwY46JplSTsLBqvns7AQf4LoRuHWHPOewyaRJRW0Z5b1JeJC632C5n3Rx1FRteGEUZbN5qYpSK4ZZfor1NdB+T5fpw8+sdw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A2C1cjJS; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A2C1cjJS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsSFk3cKfz2xTh
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 16:54:00 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775804036; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hv3yx+Z5xGwtPsumKZcBu9Ev0HSuYFqAR7IiXit0aUY=;
	b=A2C1cjJSwltEN+62VAoh5Whf1okvxkINDGCR0eJx/WYng1ZykE3il6qQC0itSfbHFSefwDQuPlqYBj5szUlxfpayUJ3oJTSJD+kMqSuI9P2AkKLM/QRaOuFVyUNc1T9PuOj4GggjwRKvZPwBYYjiuPeK+VQUP9Od+jYeT6f13c8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X0kNEnP_1775804033;
Received: from 30.221.132.105(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0kNEnP_1775804033 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 14:53:54 +0800
Message-ID: <c1514566-e3ca-4ef6-b23b-054f9e1a49c5@linux.alibaba.com>
Date: Fri, 10 Apr 2026 14:53:52 +0800
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
Subject: Re: [PATCH v1] erofs-utils: mkfs: fix fingerprint not set in certain
 modes
To: Yuezhang Mo <Yuezhang.Mo@sony.com>, linux-erofs@lists.ozlabs.org
Cc: Friendy Su <friendy.su@sony.com>, Daniel Palmer <daniel.palmer@sony.com>
References: <20260410060539.417457-2-Yuezhang.Mo@sony.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260410060539.417457-2-Yuezhang.Mo@sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yuezhang,

On 2026/4/10 14:05, Yuezhang Mo wrote:
> In certain modes, such as "--tar=f --sort=none", data is written to
> the image before fingerprint calculation. In this case, ->datasource
> will be set to `EROFS_INODE_DATA_SOURCE_NONE`.
> 
> The original `erofs_set_inode_fingerprint()` function only attempts to
> read data from a local file or disk buffer; it cannot handle the
> `EROFS_INODE_DATA_SOURCE_NONE` case, causing fingerprint setting to be
> skipped.
> 
> This patch adds handling for the `EROFS_INODE_DATA_SOURCE_NONE` case,
> reading data from the image and calculating the fingerprint.
> 
> Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
> ---
>   lib/inode.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/inode.c b/lib/inode.c
> index 2cfc6c5..51d5266 100644
> --- a/lib/inode.c
> +++ b/lib/inode.c
> @@ -1975,6 +1975,13 @@ static int erofs_set_inode_fingerprint(struct erofs_inode *inode, int fd,
>   
>   	if (!ishare_xattr_prefix_id)
>   		return 0;
> +
> +	if (inode->datasource == EROFS_INODE_DATA_SOURCE_NONE) {
> +		ret = erofs_iopen(&vf, inode);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	erofs_sha256_init(&md);
>   	do {
>   		u8 buf[32768];
> @@ -2018,12 +2025,6 @@ static int erofs_mkfs_begin_nondirectory(const struct erofs_mkfs_btctx *btctx,
>   			goto out;
>   		}
>   
> -		if (S_ISREG(inode->i_mode) && inode->i_size) {
> -			ret = erofs_set_inode_fingerprint(inode, ctx.fd, ctx.fpos);
> -			if (ret < 0)
> -				return ret;
> -		}

I vaguely remembered we have to leave it here since
otherwise it may impact compressed files.

Also EROFS_INODE_DATA_SOURCE_NONE means that mkfs
dump will change nothing about that, so I suggest

apply erofs_set_inode_fingerprint() to every
EROFS_INODE_DATA_SOURCE_NONE user
(e.g. in lib/tar.c) instead.

Thanks,
Gao Xiang

