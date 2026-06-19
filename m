Return-Path: <linux-erofs+bounces-3689-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2030CCD98F8
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jun 2026 16:32:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ghjmX31CKz3bqM;
	Sat, 20 Jun 2026 02:32:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781886732;
	cv=none; b=lYcsK8Efm+7lVXNdCiXoeCqOBEPnKB8ZCnFWKqslH6Zt2lJ3ui3qg3bGNJDu/L8Fgi7C8/ZmbxFDpS1dz7GtPz5ahxdejyBOC975hG42LXbUXMTqYceyrXl4s8Wt+HLYXb9OhhS4237Z1zXs/xnk+CL2j6EtQj/KSwz2P+M+A5QzYg+K/wRzMBa3owqQPIu0tqOVV+c/bB+THWXv4HbxEPj/KSzJRUMzLrnv5q9ZTgrA+MlaQFqLsxTN3sXHQcahmPn/7xtpFlYObnbab2KE1clsGN4LX/r4zFloo1ZcBBr5vnmpk8+2/zhos7jf31196MJuVpojdB8XkqQIymH/ug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781886732; c=relaxed/relaxed;
	bh=GQ5NCQJ48zlDZ6QI1bTvxz8N867xlcMzmYl0qy8Ug9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HJflJo9c8U6ryI3OkNcO1/ueDuRYvYlE18PQW8RUhrdSU2kMLUiHj9FPEQLF5Lkbx/Zii0wDBSCIWKJSsm2vRFgS6LfU6kHhWKAZ8wG+mTJUNxDW90E+LbyPNFVkK3yw/1Q/T0qRRNM3fClWvE9tO9NdKNavYyEZImwr1W2QjJiESiH3pyaSECEeTwmwP7MbHe1Uz/QWAqbXYE824tY+wXdVm2BvbSXKpE1FdVe4DmhuOp90mxdpJ55LvM6vbBAOnLt9dyZolFS0f8RXjoSaMifmVPeaw2G7xB9DoJ5MzbUiNpyP23+u/qQO3+bhv8niXjbvxEl52waNGO0pOIPPNw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tJChjHLI; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tJChjHLI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ghjmV3lbrz3bpm
	for <linux-erofs@lists.ozlabs.org>; Sat, 20 Jun 2026 02:32:08 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781886723; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GQ5NCQJ48zlDZ6QI1bTvxz8N867xlcMzmYl0qy8Ug9o=;
	b=tJChjHLI6QFTAog5PTD8/Du6+gfVXlwDIDm9ML1bYGI/xCaMCSV+nmE178W6A+HaxiO1xcwpYHd9R8dUVAItpYtvKcrcgAXxMX8q0BvvtRVIVub44jHiaYjQIlrTqk3KgzALkZ5EWs4HUOmCDIj/7NHV1KG9580S+ghN+BEilPc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X5A7CyP_1781886721;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5A7CyP_1781886721 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 20 Jun 2026 00:32:02 +0800
Message-ID: <ee412c09-dd3f-4918-88de-3bedf6f25122@linux.alibaba.com>
Date: Sat, 20 Jun 2026 00:32:01 +0800
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
Subject: Re: [PATCH] erofs: complete fscache pseudo-bio once when a read is
 split
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260619135800.1594811-1-michael.bommarito@gmail.com>
 <bffc5b69-2f90-41f5-9b93-fe527da63f64@linux.alibaba.com>
 <CAJJ9bXws=fnBgMMbGcuWdhSRRe2yNb-QjFP-CKW=vaA0dWd+-g@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAJJ9bXws=fnBgMMbGcuWdhSRRe2yNb-QjFP-CKW=vaA0dWd+-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/20 00:21, Michael Bommarito wrote:
> On Fri, Jun 19, 2026 at 10:20 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>> fscache is already deprecated, I will remove this path
>> in this or the next cycle: it's not worth to improve
>> this, and bio_inc_remaining is suspicious since I never
>> tend to introduce chain pseudo-bios.
> 
> I didn't chase a POC for this one, but I can't rule out an LPE on the
> or at least helpful shaping from this.
> 
> I know it's not relevant going forward, but the UAF / double free will
> live forever unless stable@ gets something.

It's already _deprecate_ for almost two years: and
I believe there should be more serious issues all
over the kernel, why just focus on a deprecated
feature?

Or please provide an accurate reproducible way first
so that I can play with that myself, I think I can
fix it in a cleaner way. If it's really necessary,
it will be fixed to the stable kernels only later,
but this feature will be removed in the near future
upstream instead.

Thanks,
Gao Xiang

> 
> Thanks,
> Mike


