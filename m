Return-Path: <linux-erofs+bounces-3702-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5264BCD98F6
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 03:58:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkDvR56Ymz2yVP;
	Mon, 22 Jun 2026 13:58:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782100707;
	cv=none; b=ETrKzzac05YJ9Ld63brp6Stya02ymub7ZDvM/srzq+X6YixZkTHC/T6QJ+tXe8xF3AV3NCtXak7Wai6MKE7QU5oExvBEDQyhaOfx+RlxVJJTDZCo2GaiDRCXYWDu2aVCMbM3Edbr3fnsxI4zE4jOn6r7YWzjvVLt3hCyfvNs9vltxv4MTekh9zmILG1bRzhxfsXUxy+DR1BqtZqUJaP9A/+bmOzJyBIUKp3Ci44UPmzPOnelDmSMIMICEuWj5WaolTpxP9NeDu0viU9trIe13mSXogQCZDIshGZmddaH6F0Qw5XA4FhwRyB/nNKTo00sm5Zi07cwEkW9Dk3HAsEkrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782100707; c=relaxed/relaxed;
	bh=DYatlw9mYUQIl6x7eztwURwpwH/TjTI4BjsXzDBqKxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BetP9HvjBx8J6qmeVkMYv0+1awHf7QCG3wl47xgbfJsLY3INjGVisP4lYgJQvTEOjve4w75a3oQNXa+MMzrmbs5mOFql5IAzJwI3UEFctf9g27eMwNWKXn/sWwWTegcrSF7gyegijC9msqZC74ssS9LGCDjyexaRIw7oiNUIFpfMAGPfDFQpYR/D4okP4vGmf1+opsTNZLrMRiRCrVAfzTabpN9u3f09NvLGfBNX2DFLR6/J2Yh8bISqKfUhuDWtWmGyGJrd+c9R8bZLjbw6/eA80aWDe/LoVXreSByMheQWc5M9eLtGXyKYBS8iq1SCn5IA7bP4GZot6YnyrU7s8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fXXCpTwk; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fXXCpTwk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkDvN2yxCz2xwH
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 13:58:22 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782100699; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DYatlw9mYUQIl6x7eztwURwpwH/TjTI4BjsXzDBqKxk=;
	b=fXXCpTwkyjb2Yh2t5tVkLNdzQLyLHAUk3pF/VwEnFrOCowoUrPOzFQsVfanO3xnb0Jcne1JbnSVxcbXBuR7D3LoLrCDiWZ3VpKNTqiPb+Lnb2hi/0Xphz3M8DtmGWD73114bMWJO+qVHlxBa/XkXCgPoIlMgw/Vejc04FeFIJzQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X5H6zrb_1782100696;
Received: from 30.221.130.114(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5H6zrb_1782100696 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 11:58:17 +0800
Message-ID: <7f1e369d-f3fe-4aab-976b-29c5e765fca3@linux.alibaba.com>
Date: Mon, 22 Jun 2026 11:58:16 +0800
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
Subject: Re: [RESEND PATCH 2/2] erofs-utils: lib: honor rebuild whiteouts for
 recreated dirs
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: zhukeqian1@huawei.com
References: <20260622034248.1047783-1-zhaoyifan28@huawei.com>
 <20260622034248.1047783-2-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260622034248.1047783-2-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/22 11:42, Yifan Zhao wrote:
> When rebuilding from upper to lower, a whiteout below an already
> recreated directory should keep that directory but stop older lower
> entries from being merged into it.
> 
> Mark the existing directory opaque before applying the generic
> non-directory bailout.
> 
> Reported-by: cayoub-oai <276123840+cayoub-oai@users.noreply.github.com>

I hope it could be a real email if the reporter
can give us, which helps us to give the exact
credits too..

> Closes: https://github.com/erofs/erofs-utils/issues/49
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---
>   lib/rebuild.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/rebuild.c b/lib/rebuild.c
> index 51dfe18..108a464 100644
> --- a/lib/rebuild.c
> +++ b/lib/rebuild.c
> @@ -401,7 +401,13 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
>   			.nid = ctx->de_nid
>   		};
>   		ret = erofs_read_inode_from_disk(&src);
> -		if (ret || !S_ISDIR(src.i_mode))
> +		if (ret)
> +			goto out;

		if (S_ISDIR(d->inode->i_mode) &&
		    erofs_inode_is_whiteout(&src))

I guess?  If the upper is not a directory, I think
it should be ignored instead?

Thanks,
Gao Xiang

