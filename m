Return-Path: <linux-erofs+bounces-3587-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984CDCD8CA8
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jun 2026 01:48:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gdtLv5dZ4z2yT0;
	Mon, 15 Jun 2026 11:48:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781488119;
	cv=none; b=YfOIFcNmJxfayilEGZ71/Kugcql3eLoEqBApUJ4XQLZ8a4wwhS33xBqOhepM/uNnnaFYywCDaLGiqsyhBvs/uIMYZmIDVjTjX3TyIIlGfy6kL2+J8K+3mN01MB7ssmRCsOOWk7iLWrcOAw97QrhA3kEz3Vex03rzkHjkuim05QxTIZxnV3Nl6slkeQwKnPxVVgULCx7Ha6fDe5gKMidz633Lc0Dxi0E3LdgauMrxbr9mLAdoTQ9HZI4bRy7g96g6S7QDF7S9MPULVPTvgEIMGknKJJmVEd34F3Rvw1dWu6GmyHuzoKwiZxdTXKiqaKJO7L8QA2NY8idwxMwdbC8reQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781488119; c=relaxed/relaxed;
	bh=6e2ar3eQRlEx3kixdwmw+YpE0tNSl9Wm2mAa1feuOik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vln4MEDILYjSGMbHwWQtB07rEzpVB9Wr8xRVtR6HcaoueDSpAqowEr6goL6JKR27DDuds7G5wVsK7GXtfpNFrMhdi00ryOFAwSUky9Ns9ndotwrRwT5BUIpu8nV1ys5SCl0Mw2Vd8TQDHeZ68wBeQWqJl1uFKhjcBlEc/If9yveonA9UQJp2St/B6lNY6+IFCPa5kK+wSMeWrVwNuVipc5z0ajFgflejvAV2uHGpPoIry+ANzFr/vvSPLZpkwNFStmS483nVhbknOXgyp7/iD1ljFjlHD4JO/1wnLZRjzgfEbEyBWebBxl9AP/PT9ROeJ6373MdnIOzbUGFCo0qQCQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GbYu6ogB; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GbYu6ogB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gdtLs2Ycnz2yFc
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 11:48:35 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781488106; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6e2ar3eQRlEx3kixdwmw+YpE0tNSl9Wm2mAa1feuOik=;
	b=GbYu6ogBRz/nkwJZEHXvNFfKN2hltQW336H0oJyUkswyLFj3u+s+5By/ToiKnGrqhUHeTNz68SSo+Bhb7XlWzrrLByruMyWQQ13iagVUWVF9xkjY0WzwveRr+oLbCOZW5vZcHc/4PGjddWDQeYx4MwsmPXGPLrbVwUg1wYOEohE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X4oaiq-_1781488104;
Received: from 30.221.132.227(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4oaiq-_1781488104 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 09:48:25 +0800
Message-ID: <555d6eec-7ddf-451e-98a3-70f7612a98c6@linux.alibaba.com>
Date: Mon, 15 Jun 2026 09:48:23 +0800
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
Subject: Re: [PATCH v1] fsck.erofs: implement thread-safe global LRU metadata
 cache
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <423c662c-e8b4-4802-b7bf-34abd71a82ae@linux.alibaba.com>
 <20260613101038.86333-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260613101038.86333-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/13 18:10, Nithurshen wrote:
> Hi Xiang,
> 
> What if rather than caching the raw metadata bytes, the userspace
> cache will focus on caching the parsed structures (such as the
> computed erofs_map_blocks mappings) to save the worker threads
> from redundantly parsing chunk indexes and calculating offsets.
> 
> Can I replace this malloc-based raw buffer approach and focus v3
> patch on an LRU cache for the parsed block mappings to reduce the
> CPU overhead during the concurrent directory traversal?

I don't think it's worth unless you provide enough number to show
which really reduces the CPU overhead.

decompressed metadata cache is only useful for metabox, but I don't
think it's prioritized for now.

Thanks,
Gao Xiang

> 
> Thanks,
> Nithurshen


