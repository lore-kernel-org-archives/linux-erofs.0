Return-Path: <linux-erofs+bounces-2907-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B341094474
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Mar 2026 13:39:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fdLBZ61Hjz2yZN;
	Sun, 22 Mar 2026 00:39:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774100358;
	cv=none; b=RWNYUIJrKlrmL8iJSfhMWy4wO8pwuY/zp0Z9VbUIxu16Uqpw+iilXRGte0SVa4NKhOCMm4CBmzVht1PnKseWQg4JRm1XGq+hJSzWumeC5l2CDQ3y+WA+sWSxnqKgtCQieFc8SAQbe0FCZ8yMF5fjNHYiT0d8Zf9fG0H8nUKf6yO7dZNny5RHc5rarnZauyhcORI7Xexb2yNFjg4HaN1m8A1FozlXxf3auhUPghQtv5xgblmjaX9f6QT37XZgh4nO03MGgMh82qeniwuVJstoRiScFtWlqzi0evQgXEDKVXSXUBktO3Eaew7iRImgKcQoorJ25ge4Yx5hLTA72DKrhw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774100358; c=relaxed/relaxed;
	bh=O8nOpWvuwodnXSrZzbuKR4IwQ3cpjF/NiFwmG3l02L0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BIE/+Lbo61pD/Ww+Yfequm3dlsiaq8d90UaKDW5jN9zN89VfcteaFAkrW7JEKlNUeyIJFD1GWAPSsPT4Mk564uza0Tm+hfgYdeZzfRu0V0zfUTQmvx2HD7a3nLBysvigf7A0EVR7GjF8eezreFJ/FD46zOUWF9QyKUh239YsrkOH2kTaaZZ92jhkZTrKdxmiVC8p6CeB04DUTTFzZF0ttM4Jka4nNZNrG1Mq0QEYPCN92RrhfY0eImz2ZWTctmAMPoAMgbBIgXns5bykBM5f/vWtASnxISEQ8Jftd1/Z1M4LA23RbXb2XcO9B84wbboFDr/OREdmORmUFh5RrWeQjw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ntKuouRy; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ntKuouRy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fdLBV513hz2yYq
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Mar 2026 00:39:10 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774100342; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O8nOpWvuwodnXSrZzbuKR4IwQ3cpjF/NiFwmG3l02L0=;
	b=ntKuouRyW3dflUsOypNHgWWfT7grTTGSuvDl8opsGBYDMSQKxjQiq05s1a4vVSnfuFfepGILd4sGFZPanijRBfi3cX3QnaFwYMP7Odzx0l6KbZJuOi2ZKuu6QykY5o7t4FF+ymT/C3x5lcVl+2pFtwkACyoaEeSPnx/aZow6TsE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.OvyzD_1774100341;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.OvyzD_1774100341 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 21:39:01 +0800
Message-ID: <a2c19923-89fb-4225-a468-b1629cc07328@linux.alibaba.com>
Date: Sat, 21 Mar 2026 21:39:01 +0800
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
Subject: Re: [PATCH] erofs-utils: fix resource leaks and missing returns on
 error paths
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, newajay.11r@gmail.com, xiang@kernel.org
References: <d8e7345e-a1cb-4234-b03f-a3089f7a1c27@linux.alibaba.com>
 <20260321071542.80503-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260321071542.80503-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/21 15:15, Nithurshen wrote:
> Hi Xiang,
> 
> Thanks for the suggestion.
> 
> I have started working on formalizing the truncated image
> scenario into a test case for experimental-tests. I'll
> implement it so that we can automate the image corruption
> and verify the FUSE daemon's error-handling behavior in
> future.
> 
> Since there is already a test-case I sent with code 028,
> is it okay if I send this one with 029?

Any number is fine, or just use 99 when submitting.

> 
> I will send the patch for the test case shortly.
> 
> Thanks and Regards,
> Nithurshen


