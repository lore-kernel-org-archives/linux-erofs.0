Return-Path: <linux-erofs+bounces-1485-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9921D1D899
	for <linux-erofs@archiver.kernel.org>; Thu,  4 Dec 2025 08:42:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dMSgV1XLHz2xFn;
	Thu, 04 Dec 2025 19:42:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1764837750;
	cv=none; b=a+fHk28dHVwg4KDq6DpFBGUywx5/xdzhK5Anr3AFcR4uvPodU3Rwhh+um6WtrrmLELmp0YW5LWbKypib4eB8HKuIn46ySymXqsm/d9N3CmGdOsDoE6nz/vzo39bAQp8hIckShXpoFX8ki+mmApfuL1bXqqVslquEEmkswTGRAcz4LA1dMxIXYTfzDIuEI+Rd9MSGzRCWWiECxN2bv+3/dp3D5KUsSBfAbop0yRdPXYB54X6gLBDTotCGLH/7n2WFvIBP6UagLaKvEt7GfOTICOZ0T3chTNmMFMAr9fdCUMTn54OQeInC2iqInXJ0yCE3OjRKF8eJEiMxWAhocUryUw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1764837750; c=relaxed/relaxed;
	bh=OJwT0fnEBiwKh/h7+SesO0/efu+14TMk0y0KuZgBUk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofrx4eos5hn1ZADPTs/kgmjfXyPy50Sd4s73Ump4vX8pOoNycakbDZnnIihsrJacjcKoVMvvbjZW6X+Wt90W2eWO+ob0NT7PdKgvz91fkqfEqaNZI2+taHoMNc5irpApdjB+5/kRBcY+VJQlQMVdsGEa/5pBWftmJJVA3qLDDU6fsnKl1Z3Mk0JihXAIZJZu0kO+r+NktcCz/EaeeJwThKE5v+UlBXOaq3gTlloIhkqp4Ze08m5lHdx/AJpSrzXy0xoSlHvg2j97LyumhMSaJnuRK+v5maxzoFbDihg9kFWTa7iNfB+dKG4hCIOVSuJwis0fzeBilkR+7DMFsQz7NQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SSy101sv; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SSy101sv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dMSgR69Z0z2x99
	for <linux-erofs@lists.ozlabs.org>; Thu, 04 Dec 2025 19:42:25 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764837741; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OJwT0fnEBiwKh/h7+SesO0/efu+14TMk0y0KuZgBUk4=;
	b=SSy101svHfXpn6zPmMQ2C2xmpV/8dgQXTk4VGmjtIq5UkJx8s3BpeQUHe1FL8Z/Jwyh7npKC739+IGyJ7DK4mcsfV/Mte3Anyyb/4hRxzCLWmmSUtWhPff5D689KBX2ltQTqrx2jrNCpVbx7s7RcnuyBp4Mp4mnH09ocdtSkUjw=
Received: from 30.221.129.242(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wu3gB4._1764837739 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Dec 2025 16:42:19 +0800
Message-ID: <60c42161-afda-4095-81df-09880794b4ea@linux.alibaba.com>
Date: Thu, 4 Dec 2025 16:42:19 +0800
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
Subject: Re: [BUGFIX] [PATCH] erofs-utils: lib: fix erofs_io_sendfile() once
 more
To: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org
Cc: jingrui@huawei.com, wayne.ma@huawei.com
References: <20251204072657.1017332-1-zhaoyifan28@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20251204072657.1017332-1-zhaoyifan28@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/12/4 15:26, Yifan Zhao wrote:
> Misuse of constant parameter `count` leads to an infinite loop in
> `erofs_io_sendfile()`. Fix it.
> 
> Fixes: 53255c7 ("erofs-utils: lib: fix erofs_io_sendfile() again")
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>

Thanks for the fix!

Thanks,
Gao Xiang

