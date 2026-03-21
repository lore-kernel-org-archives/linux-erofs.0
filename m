Return-Path: <linux-erofs+bounces-2896-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297911093170
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Mar 2026 05:16:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fd72m4zMCz2yYq;
	Sat, 21 Mar 2026 16:16:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774070208;
	cv=none; b=not0bSXCYmuRpiO64NyYFdT9JsbPJWf7ELVkTWHcAmG9Eq3uzoRSQw+KfZvjG7tq906HV7IczRerlk7KJH5FPuLeE9hQ6OubbNnABjBxG90MhrOUpDuTcbwlUi1rKN9wEnpefnWofynk2LLA2dvkfAGKm7ji4XRTOvpEAl6p51lUib3R2oCDPAwUR137Z7rcOJURptIjgsew5bAIgI68/212G7LtcJwcf+SJ5hHA5SxpgtkST1oK7G+9RqHaVuMOytM9bESc/h8g1JZgD91UaKen/5unVePWFq2a9CM3vFIUd8ZeZiN5x3gaSOP3f1SB5+YoARWVkUAWUEFsLQsRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774070208; c=relaxed/relaxed;
	bh=gJr7YRfigAaFvoUGMhjRgt17fBZ1PHu5Dw4qTqGIyC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OFMMn2a+CKvom4qBODl7Pt+scDa2xx5ZCIv8nRO04Ag2tru6gZ491mvo4fenWSHMMhvUvfySkuXtLYnx97kF29DNt+tKvLCUkpA7zDT8wwF0znU3DTmEHAgpgAyZQKTN32P0SaKTaTpop7KRUInW6YHmTNmwoJa68Rqx9LPTSVVlR0VaSjPCsjCi8qcx5IoLqglF68IPQPgRDVnHMsES8in5tIbuHegI/ZBy2qE7ioEIGBth5GFKGp61n1+yNI8ZsnupZ5pC5VQ4C7PKhGDdb/NeG5Kdfzqm/eRuZNcUfTMyBwAR5BDm1zx6jL01JcxZWQn1X/NFHZYPGt9QvhJyqg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Jx3QB5QH; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Jx3QB5QH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fd72k13mCz2xP9
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Mar 2026 16:16:43 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774070198; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gJr7YRfigAaFvoUGMhjRgt17fBZ1PHu5Dw4qTqGIyC8=;
	b=Jx3QB5QHgE7WVIzDCDF3vi0WMyc6g/xpo2mUskdv1AlsQ3vyt3tJo47f+Hk5X0fnNZfG2GBhxUQzlCXgpso+wiIISCchfEZJKDpAosYnZ2qw4oLoCu886UrF3/lEIm4FvzKZWgA4RxAhdpkNePOG5gwi4ersOnWuLepDxCjFvVQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.O3csY_1774070196;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.O3csY_1774070196 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 13:16:36 +0800
Message-ID: <d8e7345e-a1cb-4234-b03f-a3089f7a1c27@linux.alibaba.com>
Date: Sat, 21 Mar 2026 13:16:36 +0800
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
To: Nithurshen <nithurshen.dev@gmail.com>, newajay.11r@gmail.com
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260320165200.1862-1-newajay.11r@gmail.com>
 <20260321050725.60268-1-nithurshen.dev@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260321050725.60268-1-nithurshen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/21 13:07, Nithurshen wrote:
> Hi Xiang,
> 
> Both the patches LGTM.

I only see one patch here, if they are unrelated, please seperate
nto two patches intead.

> 
> I tested the missing return by truncating an image to force an I/O
> error, and the FUSE daemon now correctly aborts instead of hanging.

It seems the first one can be formed into a testcase
in experimental-tests?


> I also dynamically tested the memory leak fix using Valgrind with a
> 10MB file and an injected Z_STREAM_ERROR, confirming 0 bytes lost.
> 
> The only note is that this should be sent as 2 separate patches in
> the same thread.
> 
> Reviewed-by: Nithurshen <nithurshen.dev@gmail.com>
> Tested-by: Nithurshen <nithurshen.dev@gmail.com>

Thanks for the test.

Thanks,
Gao Xiang

