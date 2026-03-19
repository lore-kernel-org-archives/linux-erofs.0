Return-Path: <linux-erofs+bounces-2844-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D3A108E1DC
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Mar 2026 10:27:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fc22T6hryz2ynv;
	Thu, 19 Mar 2026 21:27:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773916065;
	cv=none; b=cXos5hprk94DnY21Z723aX460BDPTNosOuh+val5GrVyuFkxJMvByPsFGRhUoGTOSekUUpAlncOraIOIJCwKrK/CkkVZ2zIuYZj/B0QpK6NTlynk3sikDhiAdpNtqkC+p8JVHVIoUDCXJKyPHlLDCTV10YhBBQPxmTVH63pKGqxnHpkmkyiaPRfgSB7hj23dXjB486bTqFGOpl5M8yu5hzQ55qF5gxP+xZEb/6IIo3pE6vQaujj+oV3AQtiseSgNqFnHlxYSsBrgHZkq6DPg8qbFa3l/g0PuhTxujcsdWOUkganArTS07Kwrc60cgXH6Lo+1oKYQnWwVt55QkheMAw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773916065; c=relaxed/relaxed;
	bh=qSbzKs4pcui0wJXfAzrWfeQiKqQuk7KvdFqEYLKwL5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nyi7GGgdodsgX6T9woD9CJqbFNhJdRo5Pd2zkddhVPutBpa88HcsPKxH5MnN8Cum22XSr/JxcrJF8i8B5WpMb+ciV7xSOYjeS2rSkQxZPhoyzK9aWCoGQUMmosodJBb2RY0RbBhwr9ht/7YObyvintwkXvAFiPWKg1Xt2rRKqFyLuvzk/LyQrw89wSlWemDfD2wlcT6IkqV8f5Hf4lqt68U3ECG9xHqK3+Q+BwjKWcMuBLXY0kqU1qwW2zUuJ0Xca8MGamTN7OqVI9bccS5w4PM99pdg/NOzls/kCNzgO1w72/hheid9QvU26plHFJXo5ekuOCS87ffccVzyjQp9eA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qEiAkVqN; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qEiAkVqN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fc22Q3hKvz2ykV
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Mar 2026 21:27:40 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773916056; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qSbzKs4pcui0wJXfAzrWfeQiKqQuk7KvdFqEYLKwL5E=;
	b=qEiAkVqNSxWDeicKiDmzTbR7lttNvqug7fLEKBczuMni4MtC77jirz38+vTYJWcDcqqfXlv/3fQQ4xVHWahdQAdImSLaCC0xPc5Y5j6enQppjhTKZUIzGgqd6aAG69HRJbjSO6bSE8GKc64XTxJAzdKumsz6MrlQVdbphHDa/cQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.IB28v_1773916053;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.IB28v_1773916053 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 18:27:34 +0800
Message-ID: <0f4ece6c-c957-476d-8cc4-fa79bf459acc@linux.alibaba.com>
Date: Thu, 19 Mar 2026 18:27:33 +0800
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
Subject: Re: Incorrect Cc addresses in my recent emails
To: Utkal Singh <singhutkal015@gmail.com>, Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org
References: <CAGSu4WNAFw=yChmynVCYSfJiSJ3LbohTjV97JsJK5EBipwz38g@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAGSu4WNAFw=yChmynVCYSfJiSJ3LbohTjV97JsJK5EBipwz38g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/19 12:22, Utkal Singh wrote:
> Hi Gao Xiang,
> 
> I owe you and the list an apology.
> 
> The incorrect Cc addresses in my recent emails (gaoxiang25@kernel.org and

Why "gaoxiang25@kernel.org" was your fault?

The patch with the incorrect "gaoxiang25@kernel.org" Cc
https://lore.kernel.org/r/20260316085300.19229-1-lasyaprathipati@gmail.com

is not sent by you, correct?

> yifan.yfzhao@linux.dev) were my fault. I used stale entries from Gmail
> autocomplete without verifying them against lore.kernel.org or the

I don't think Gmail web UI can send patches directly.

> MAINTAINERS file. That was careless, and I understand why it raised
> concerns.
> 
> I have removed every stale address from my contacts. Going forward, I will
> verify all recipients against get_maintainer.pl and the existing thread
> headers on lore before every send.
> 
> I also recognize that the volume of my patches over the past two weeks has
> made your review work harder, not easier. I will slow down, consolidate
> related fixes into proper series, and focus on quality over quantity.
> 
> I appreciate the time you have spent reviewing my work, and I take your
> feedback seriously.

Please claim here that you are not using and will not using
any AI to write patches in public, otherwise I will simply
ignore your following patches unless your contribution is
necessary to be fixed.

Everyone can do vibe-coding (including me), I don't think
it's fair that everyone throws "raw" patches made by AI to
me and let me take my own time to review.

Thanks,
Gao Xiang

> 
> Best regards,
> Utkal Singh
> 


