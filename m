Return-Path: <linux-erofs+bounces-2967-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39219F532C7
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Mar 2026 02:25:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffv5L6S3bz2yj1;
	Tue, 24 Mar 2026 13:25:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774319110;
	cv=none; b=Jf1/bW8o3mepg3QhywprtnLRZwzNwVAdmEePdghbwtzJJUHw1HS6z4ftKvoiPlN4bCxvt1H6CVdt3oZmqP8UTI8W441ugpB7y9I5bJw7b61U0NFtRAJrSeSuNYXQWkSoWDqifqKybHmkAMLtneEMcEzb+WtWfwU7en1UEQAxT2HdlRAMFFwmk0S14tarzNp7pYDPQW+txBdsMyEHyTdSa8WuFiXvnJ6g/AJnDgpLgkQEKKzyOtvEIZr8URbLf9WrDYYQWMC3PK5VRhIy+lRbkVn3UqxmU83uvls53W6+Rq9NKxWpyEfxvQ9ZL1JypS56bQANzwGmCAakFZm2B6DepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774319110; c=relaxed/relaxed;
	bh=WpN0mI+CiekGT3pQv7cElpiCqSQyUImlVpSl4bDuZNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BI+c4iwPPA1lT0pMyJyAG8V5CDd6S5BFmzUQakPnMa+ATFjHGs/+s5BKQ3GUFX0pVUIafr4Ayo7piD8Ks+75q/jZI90HAJeC2BL1LuBSq4mSVTTtlILH/Jl/hGzx4gZh43WlquXgSQ6DyMRzM92bM6LMkMVcbAVq6LV7edRUQO76fIvbvt+lo5Ssl7yJTwoyq1fQwxLz1dR+IKvD4XgKbwOKbQi8bpi0ylbxOMCSaYx/+hN/SjLu2KoK3Gt68LudWHfWHQjSgqQ4xO5QAPsNZFu0ZYrL0VZ7tCZVkVlZZmP8s3LECuSDmZbkBpwDlNz1Zzwj2Cx6zEwGxj9y/Ej2WA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NZFFXYs4; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NZFFXYs4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffv5J59WDz2yhZ
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Mar 2026 13:25:07 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774319103; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WpN0mI+CiekGT3pQv7cElpiCqSQyUImlVpSl4bDuZNI=;
	b=NZFFXYs4Ds0aTXiOVX04+qPaTl48O6Rz4kebiEXO1wzI4Dkep4JOKkjy8Ud3H7QK9RkIDa/5QBhBy/QRlBoXHU2+z5xTPt7WxlnjAicFG47bDEdRTTd85jzD3cxoeddJDfylvWPVLUmSaCk/H4xV9e9rQhr5v5iCzp1OA/JGyik=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X.cto9G_1774319100;
Received: from 30.221.131.232(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.cto9G_1774319100 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 10:25:00 +0800
Message-ID: <dde1dbef-d6fe-4861-b884-b8ba1105ac3c@linux.alibaba.com>
Date: Tue, 24 Mar 2026 10:24:59 +0800
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
Subject: Re: [PATCH v2 6.1] erofs: Fix the slab-out-of-bounds in
 drop_buffers()
To: Denis Arefev <arefev@swemel.ru>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
 syzbot+5b886a2e03529dbcef81@syzkaller.appspotmail.com
References: <20260323135936.15070-1-arefev@swemel.ru>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260323135936.15070-1-arefev@swemel.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/23 21:59, Denis Arefev wrote:
> commit ce529cc25b184e93397b94a8a322128fc0095cbb upstream.
> 
> This was accidentally fixed in commit ce529cc25b18, but it's not possible
> to accept all the changes, due to the lack of large folios support for
> Linux 6.1 kernels, so this is only the actual bug fix that's needed.
> 
> [Background]
> 
> Syzbot reported that a KASAN slab-out-of-bounds bug was discovered in
> the drop_buffers() function [1].
> 
> The root cause is that erofs_raw_access_aops does not define .release_folio
> and .invalidate_folio. When using iomap-based operations, folio->private
> may contain iomap-specific data rather than buffer_heads. Without special
> handlers, the kernel may fall back to generic functions (such as
> drop_buffers), which incorrectly treat folio->private as a list of
> buffer_head structures, leading to incorrect memory interpretation and
> out-of-bounds access.
> 
> Fix this by explicitly setting .release_folio and .invalidate_folio to the
> values of iomap_release_folio and iomap_invalidate_folio, respectively.
> 
> [1] https://syzkaller.appspot.com/x/report.txt?x=12e5a142580000
> 
> Fixes: 7479c505b4ab ("fs: Convert iomap_readpage to iomap_read_folio")
> Reported-by: syzbot+5b886a2e03529dbcef81@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?id=c6aeabd0c4ad2466f63a274faf2a123103f8fbf7
> Signed-off-by: Denis Arefev <arefev@swemel.ru>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

