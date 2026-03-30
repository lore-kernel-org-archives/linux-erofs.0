Return-Path: <linux-erofs+bounces-3084-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8997FF492D
	for <linux-erofs@archiver.kernel.org>; Mon, 30 Mar 2026 01:45:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fkYx40lNCz2xly;
	Mon, 30 Mar 2026 12:45:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774835144;
	cv=none; b=HGBTYymnId767EeQEhZ1mKlCgOZ5MPAdzqXB3AW4ERUzcHME6XjqOUhrt1hLCkmQdREoFk2FBNjxeXi+gFKX5LUnz4MXML+j6E2FpG9ZSbUcmJ2s35iqesndYrsTIyflXeOH7/pkSUKLu1NKq6qNvoqZSNzuNO8pRY+xwQSvxmT47lfmnciv23egD2rKbkDKh+vb67bjuOM9FfNC/tCIN0y62+Fh4BAQdDtqp6y4qMe650cx5rnx9S/rEIdg5I3IaIfG3gnMJ/RGjZbPm/iKweCp/dbTYJ1faRTYhb2Z4ZxNuv4xiuqctBw2cvfdJLHFcew0XQ4TivOobDxKH5M86A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774835144; c=relaxed/relaxed;
	bh=yue2kRuUKBxWXT+eQPsYC0Q8ZWpLaD3+yheMEly2kuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QXCWUKPACryKS/uWcJNzkUmVEPayOFj1IRgZqosFFsZxpGHmUGYxA02iMb9EUfrKWRbAsCVl5qrkOy9QQWt2z66PgI5ljWdDBJ9vnilO8sZWUKDY1J9F9/CeLqir7i8G+cXafqQf8GIOD50D06r8FSSDxDIGLWZrT/dxsxE+rq9o2Mkdx7VtfWD3fcvEZ1qJxOR7+uwL4qqpYIxxvRAv8DJcPmTCnl5c5DFNH4/UCwtBsF9v61dkUOipHgTb/+zc6bMFnR5Xw1IIyO1vFzCaEwJuo8VSOcq3peD9GnKLIhjVNW+aVfFjxylhDTnaVAkJXqgxIF1Plrj3ZooUyrEpRA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SbHuoiqR; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SbHuoiqR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fkYx30Znlz2xMQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 12:45:42 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774835139; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yue2kRuUKBxWXT+eQPsYC0Q8ZWpLaD3+yheMEly2kuk=;
	b=SbHuoiqRVVXU+XbcJZZ07R7+2CGmX8wCRF9JOJg5F55dPFO3Q44KjdXc8u011H53tEgJ7lRt7geaXNhb6mv42RKv0d5fkJQwuOFogwT/OuMwUcD79S0KkKs6KD/35/FlToPsMz4cNBW0eFBcnk12pNHVOXKtFMVAz1SqbxqMUrU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.tjB3s_1774835136;
Received: from 30.221.131.246(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.tjB3s_1774835136 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 09:45:37 +0800
Message-ID: <9ab35d87-8421-4fac-a116-829392cbc51e@linux.alibaba.com>
Date: Mon, 30 Mar 2026 09:45:36 +0800
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
Subject: Re: [PATCH] erofs-utils: fix typos and enhance installation guide
To: Ajay Rajera <newajay.11r@gmail.com>, Saksham <aghi.saksham5@gmail.com>,
 Gao Xiang <xiang@kernel.org>,
 linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
References: <20260328201555.5192-1-aghi.saksham5@gmail.com>
 <CAMhhD9gRZTgxOqVJ0np9JO4kUuNBao2e2WEMmhfGCjwzdogqiw@mail.gmail.com>
 <CAMhhD9jUqxY3H7Let-cnpaOh3vijL7jJ78=9zEjw0yDRA8F6WA@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAMhhD9jUqxY3H7Let-cnpaOh3vijL7jJ78=9zEjw0yDRA8F6WA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/29 09:04, Ajay Rajera wrote:
> hi,
> Also, I noticed your commit message is missing a Signed-off-by tag.
> This is required before any patch can be merged.


We will not consider any patches for the README or docs/INSTALL.md,
as most content is superseded by the website.

Instead, I hope I could find time to rephrase the README to
reference the website instead.

Thanks,
Gao Xiang


> 
> Thanks,
> Ajay Rajera

