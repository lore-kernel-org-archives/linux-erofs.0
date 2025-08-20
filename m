Return-Path: <linux-erofs+bounces-846-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A36CA0EDC
	for <linux-erofs@archiver.kernel.org>; Wed, 20 Aug 2025 09:12:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4c6LLs63Sgz2yGM;
	Wed, 20 Aug 2025 19:12:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1755681141;
	cv=none; b=T6OPrM8XuS2DYubIsL/wcvwcU/eMS6hsWq2HL5DmbgRzrxFO8bG2sOaML+6/vaq6BZxIfx5SLHl163Uipp5KyxKh8egDdn/HM1kU9ID4UKzZOpvJ/QWpmMDkSRBHgWZ4gJsUuzT3yU+Uu88ypIuzvmYdkwC0wGUWbnzLuvDxIa/3T9ioJ2tXYbHcVxOCIWDGAoHrhnvkEXf96FolFNUXEptGKwp/EMd3p5qt9lf/u9MzgEGqQEsIp5SNGHcSoMNG1Wbv6rVOiHgsQQMylMiRLwu6J4faDzG4W96i1wdlAe1+5EGZ+Hgv4j50S53pJa1jr2BCeKgyfSVgdrriM52RIw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1755681141; c=relaxed/relaxed;
	bh=XQBk6oqy+leo1n0PrUIigin3kri/WbgiEQJZm7Oi/ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OBX1iamvtvrxyk+Rag9mlaEnOuBOjGahr90WDuwc7I5+P9vNnWBGoMFmaahUEYls/cQaW5qEK83tdwBt3yijAQkzBFp0Py0XfCkt8ThbaG3CDy8A44tx2XskRYXfFMYXfehr2U3svKqVNU8dzAiV9JS4rz4NWw20z2baNlm2p8aEmbkgfXCDzE+k0s4GatOWOgep++FtrMqtifLNIR2KTQ5qys0RCblMQ29Zm5E1uSr275JcK0lQo8tRDHLRN+AJ1I/eNvTZRUNmpruC0fdxBxQ7ifOY2LRuACgCIIGy44kNNmVDum8bB34VyBP/l5E8dUpddE+Kqy/fNkdv/O8hfA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IC9N2NsJ; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IC9N2NsJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4c6LLq5P0Lz2xQt
	for <linux-erofs@lists.ozlabs.org>; Wed, 20 Aug 2025 19:12:18 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755681133; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XQBk6oqy+leo1n0PrUIigin3kri/WbgiEQJZm7Oi/ro=;
	b=IC9N2NsJETz/N5saT5wAOdqj12s8KFGmYod9a6uipJqED0edEBWDNFy2IPzW1Lpl49Ya5Kw3sWdR6ohCeX9nedkfYNzmYiHztsyXXSyIUK7IlEl/moA3msWmTl8JGfx0MeyGrd7JU4dhEW10fCu2qFn7/ZSXxQJfU1tcNN+5F/g=
Received: from 30.221.129.108(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WmBY6qy_1755681131 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:12:12 +0800
Message-ID: <5be2a340-acbc-4ce9-8bb6-1bfb91562944@linux.alibaba.com>
Date: Wed, 20 Aug 2025 17:12:09 +0800
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
Subject: Re: [PATCH v1] erofs-utils: mkfs: Implement 'dsunit' alignment on
 blobdev
To: "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
 "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>
Cc: "Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>,
 "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>
References: <20250820072352.4151620-1-friendy.su@sony.com>
 <39f81655-8bef-428c-843b-b57c9e50c90d@linux.alibaba.com>
 <TY0PR04MB61910F716A77A3E6F0F8FE43FD33A@TY0PR04MB6191.apcprd04.prod.outlook.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <TY0PR04MB61910F716A77A3E6F0F8FE43FD33A@TY0PR04MB6191.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2025/8/20 17:00, Friendy.Su@sony.com wrote:
> Hi, Gao,
> 
> Thanks for your review !
> 
>> As for this patch, what if the inode itself is
>> chunk-deduplicated, could we apply this if the inode
>> only has one new chunk instead at least for now?
> 
> Do you mean inode has 3 chunks, chunk#2 and chunk#3 duplicate chunck#1?
> 
> This patch only makes the 1st chunk exactly written to blobdev aligned on dsunit. Deduplicated chunks will not be written to blobdev.
> 
> In example above, chunk#1 is written to dsunit aligned block addr, chunk#2,#3 are not written. The next file will be written from next dsunit alignment addr.

What's your `--chunksize` ? consider the following:

  chunksize = 4096
  dsunit = 512 = 2M

and two inodes:

inode A (8k)    2M, 2M+4k

inode B (12k)   4M, 2M, 4M+4k, 4M+8k?

Is it possible? what's the expected behavior of
this case.

Thanks,
Gao Xiang

> 
> Best Regards
> Friendy Su

