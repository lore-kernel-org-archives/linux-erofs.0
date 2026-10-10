Return-Path: <linux-erofs+bounces-4686-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF48CA9EBE
	for <linux-erofs@archiver.kernel.org>; Sat, 10 Oct 2026 07:17:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j1w6d4CDgz2xyh;
	Sat, 10 Oct 2026 18:17:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791616665;
	cv=none; b=Yqb+Wk4WBk0NDdAwofG2L+2rOXGLKXR8DoD2aJjHrUFpgXqPyH/QYrUUpGBBm4b9pxWkJ5Dsa74lXCQ/6Egea6ZTQ1G+aNDur9qq9hRiW2OigEafnM+Q1GfF5XaDW0JihZUwySBgRWhMDlVbMxEloxGXgDFBN0yI5uMQP1Oyb86CZVw3XxmkBd8ztJ1TciYlbw8EI+W3Xnrkc0q9YPacstqOsa5F9wY5pbHUAp87fo4NSqDm+dHzXkbiJu/TucjDuvQZDFKVS+ic7S2s8YF3pT5EeCY4T4FcDMChjozrkh3C4XPUpBDflE0ztCMR21PU3VazT8yd5rUH82u2PhAyTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791616665; c=relaxed/relaxed;
	bh=LjaoX7Zu0LcypZ9rSEHpW4L8GeX+4hGgjpaev3HY+BA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z+QcrzCO5HdIWrgQWdqkrFnvVQmVYOcj8sIWLIpPayr77VUSYi5tuK4FKqp4GaGSvitH3RqUoStI3S1UKE7XD+twB1T1KTywQlqD1WlVEzP9A8p+4l32X3DfNLDWbWcshx4bPWkDX6xpuCYrMjZa5f/Qysbz0qSOMrqLlp+Pb0wBEJ56lHLe/56iwZ4ZmjZpsY/hk9Pu9dwzfqoXthZktH4H/oRAJH84wLIQOwqOgiodL5bmlh0JqwnEPBhTZ6W+79eHfrJRRub55ZALMXdr0CsNaWoh/keM5GkQjGwmE4biPK1lGZw1gAXqP/R6iWbEXD29tKd9RhAkaY/5clxtaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQ5UpPih; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQ5UpPih;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (unknown [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j1w6c4r3xz2xsW
	for <linux-erofs@lists.ozlabs.org>; Sat, 10 Oct 2026 18:17:44 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E0EB601F0;
	Sat, 10 Oct 2026 07:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731821F000FF;
	Sat, 10 Oct 2026 07:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616661;
	bh=LjaoX7Zu0LcypZ9rSEHpW4L8GeX+4hGgjpaev3HY+BA=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=ZQ5UpPih/Tz9/Paz6Wvf+ZLJkIth3WlLAL42Y/yg3dRilGulBZczhkzGjEjnLQwPR
	 GU+JBuxigErrJ/ljpA0ocLbGlqfwsuGwyYMC/DXoKFBso27eqFRA08hF/XycpbnnJq
	 9NjftyW1dzYzFEdnOOcdCt6r7tMYgD4546yCusKN/PKdRXiyFLDD1nNS8qe4+BM9md
	 10vN3oSAwrM2FivSErZ0X7/H3BcQ55wqzH0RPdeNBgQ/jzZreUcHySwDdF58E2HR5j
	 WArCisIwYs2jrN2RiLl/nqz01n9FjHzMXtsVwwOtBjnNtQ3Yr69C37jISfEu/C/kpa
	 v4+U18wMUKpEQ==
Message-ID: <6e1b9e96-eb98-4eec-9c34-5bd9ca2f9808@kernel.org>
Date: Sat, 10 Oct 2026 15:17:38 +0800
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
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] MAINTAINERS: erofs: update my email address
To: Jingbo Xu <jefflexu@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 xiang@kernel.org
References: <20260921030417.87932-1-jefflexu@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260921030417.87932-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/21/26 11:04, Jingbo Xu wrote:
> From: Jingbo Xu <jefflexu@163.com>
> 
> This email address will not be available in a few days.
> Update my own email address to jefflexu@163.com.
> 
> Signed-off-by: Jingbo Xu <jefflexu@163.com>
Acked-by: Chao Yu <chao@kernel.org>

Thanks,

