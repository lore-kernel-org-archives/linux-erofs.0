Return-Path: <linux-erofs+bounces-2805-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E996EFED9E3
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 15:25:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZwlC1lCjz2yh4;
	Wed, 18 Mar 2026 02:25:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773761143;
	cv=none; b=lfwHB1vDq8qJn8Wpfha5NQtXAaNrKKNze09XrRwUJuAfWUPYMHjbFhk0B4t89k2Jp1R4TpdeB8FHe15hJhPAXMTF7uhsAD2PtTqeMzxkomHfTGPvXAt0woCr0hN2VgV1nCHCOqwojdknGx+yrTRjCQzY/ZsJDD/mRv/HDdV10wW2ZJtTzTS2SnF8LKg6rGVDt3eshnMZSH2zcs/6HbttG817TC8JNYwz2QgO0vLvgxtjEdBRwHG/tzuQxvH60gz9fpk5OMUlaIgfKIouJZVBZsZP5059yl0vS0yZn0yKWEEC4/mLnZkWF0eP1tshbDlMrdsuLjVQQibMe3dDE4knVg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773761143; c=relaxed/relaxed;
	bh=abC6g6w5z9kg/+YyTadJL5jmEFeDsHYXASkf4aqjRS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AbMQd71ZstzN18nzKP8EbzfhVvecSH8ClDf2xrxujfXJH/+2XsIOou59i+6S8YYeE43sxuIOLB6+Mejby2YBlVjydsUfFOarZ4hGJyxsWK7Ix29gu3vt+GFk+9SezCIfqJMLV+mxO5lYDi/P1JeB9JmkeqWrXVasxAyq1PLuz1VIZj2rANVVB6sc9gnaDJ2GmUUu1+pmWuvjkslkiDYeVI1sam5BTX2jLjrzHYGBdyq3f5pkCxpoNKWz+dP/nxgSiZzlTTTLY0hvZme3EnnwBn/+VHxiQyop9+lCPdiZ8fIqYG43RqjF45zrVow8Uy3Nlu2VKPVk279onr7VDljBWw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xB0bBir3; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xB0bBir3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZwl84SNNz2xVT
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 02:25:39 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773761135; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=abC6g6w5z9kg/+YyTadJL5jmEFeDsHYXASkf4aqjRS4=;
	b=xB0bBir3JZb4qX6RsjPzi8wXT0RUfVxS+XgbwDMqhYCofOklYZF5FhbsGppt0L7zZJMRWO6pvKhtlNLJ8XbkQ79VkXHpFIHBOZEPioz10lvOuJwIa/OiRtH9GpOtjklqE2Sj2JE60FvrU3fahBcqVj5JT9f1lixvxs1U8ZidvIA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.BTdle_1773761133;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.BTdle_1773761133 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 23:25:34 +0800
Message-ID: <e7285eaa-281e-4a5e-adc6-8af88b166b43@linux.alibaba.com>
Date: Tue, 17 Mar 2026 23:25:33 +0800
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
Subject: Re: [PATCH v2] erofs-utils: lib: harden h_shared_count in
 erofs_init_inode_xattrs()
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
References: <20260317151514.3529-1-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260317151514.3529-1-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/17 23:15, Utkal Singh wrote:
> `u8 h_shared_count` indicates the shared xattr count of an inode. It is
> read from the on-disk xattr ibody header, which should be corrupted if
> the size of the shared xattr array exceeds the space available in
> `xattr_isize`.
> 
> It does not cause harmful consequence (e.g. crashes), since the image is
> already considered corrupted, it indeed results in the silent processing
> of garbage metadata.
> 
> Let's harden it to report -EFSCORRUPTED earlier.
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
>   lib/xattr.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/lib/xattr.c b/lib/xattr.c
> index 565070a..9d52a18 100644
> --- a/lib/xattr.c
> +++ b/lib/xattr.c
> @@ -1182,6 +1182,13 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
>   
>   	ih = it.kaddr;
>   	vi->xattr_shared_count = ih->h_shared_count;
> +	if (vi->xattr_shared_count * sizeof(__le32) >
> +	    vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) {
> +		erofs_err("invalid h_shared_count %u in nid %llu",

I think this line is incorrect (did you compile at least?), also
you need to Cc LKML <linux-kernel@vger.kernel.org> for all
kernel patches.

Thanks,
Gao Xiang

