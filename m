Return-Path: <linux-erofs+bounces-3706-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7721ECD98F6
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 05:52:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkHQY1DHyz2yVP;
	Mon, 22 Jun 2026 15:52:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782107525;
	cv=none; b=KF72fJGm8f8D9Ua8jesYZwXuzvFeJxUyckQ11TxXHj/KbJXpy1stMGf4MO6Foqc8FpiBR7HqwKnT3jw0s9DVk+AvxwuHxRhMFCjwJxCyrc1DUPw+90NVstKQlIgRdIIcpOSpU+gtKAz/Iql1J5hndkMKv9DcZ8dzev6ccR/TdfbAKCwJdg8LlFm1fWO9J7P8PEnYoVr94qFQSoX71IZJE0OOSLfsStcx6oSidyc1wazRbsyZzE0gO+LvJO3afg67h17E/hdXFgkD6IzlG0QcK15MIpa8P9tImsGZu8dZ5MWCdWBMftijBImDqqZj7vAtiCJWRbl5Du3rg1IGagJgjA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782107525; c=relaxed/relaxed;
	bh=yH0G0MgETg7Oe3omWmp44CsC9IA7RpwOCBDGLc2x2XY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N3O05DWBrPrwzvIC3LUjpBh4dmjMd0OL+YCzIKtTLpJ8REgR3JLXw2yp8AEFqekJETK/3zh9XuF5vgU0viev0STWmZZM3pt0Blzd0wQBfuZAjbzzMLExackTiiQ24D4Yg9B6z+S2Q9HiDpU0X+kz2/QQpKK6lPh6bl3tL/j8w5RI3rfsTW6GYca6XEsF4zGNjSFdCUykMfMuei55F8m+2wW4917rC1vMKc+xVGrLEPIe//Lhc+fP6AFAFD1xqUf0KBzPpy2ErxQubmamT5fnLTXjwgiaf3ub4lfshJTJJjMH22wqq2uPqBleCKqWZymZjfoC3JAWFJI3iUbf8exrwg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=C3zaaiAt; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=C3zaaiAt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkHQV3C4Fz2xwH
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 15:52:00 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782107506; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yH0G0MgETg7Oe3omWmp44CsC9IA7RpwOCBDGLc2x2XY=;
	b=C3zaaiAty4ycS8UP5J2022BcF2mRC74BybHQeKEd24p1xSrB6mA1QJnEOUY/3CPA9h6wJ6XKzxyu6zNfzvWZt7A6le0DGOIf4HTUpkEnYo0gnjcFFFtzTk2B1HmBLtqQ++rwVQvcR730ey2Zh2hxhDr616/WbLbQxo5yraiAKmo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5HdX1o_1782107502;
Received: from 30.221.130.114(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5HdX1o_1782107502 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 13:51:43 +0800
Message-ID: <adbeabf4-8f3b-48db-bf28-de040863c04e@linux.alibaba.com>
Date: Mon, 22 Jun 2026 13:51:41 +0800
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
Subject: Re: [PATCH] iomap: submit read bio after each extent
To: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, Joanne Koong
 <joannelkoong@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260619050105.439956-2-hch@lst.de>
 <20260619-kundgeben-hippen-abrunden-643fba56e35d@brauner>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260619-kundgeben-hippen-abrunden-643fba56e35d@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christian,

On 2026/6/19 18:15, Christian Brauner wrote:
> On Fri, 19 Jun 2026 07:00:53 +0200, Christoph Hellwig wrote:
>> Currently the iomap buffered read path tries to build up read context
>> (i.e. bios for the typical block based case) over multiple iomaps as
>> long as the sector matches.  This does not take into account files
>> that can map to multiple different devices.  While this could be fixed
>> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
>> over iomaps actually was a problem for the not yet merged ext2 iomap
>> port, as that does want to send out I/O at the end of an indirect
>> block mapped range.
>>
>> [...]
> 
> Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
> Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

btw, could we address this issue in the 7.2 cycle?

Not because that is a quite common case and needs a rush fix,
but Just because that can be reproducible under given
circumstances and users can get corrupted data.

Or if we need to hear thoughts from others, I think we could
delay one or two weeks though.

Thanks,
Gao Xiang

