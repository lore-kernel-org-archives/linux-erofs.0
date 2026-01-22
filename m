Return-Path: <linux-erofs+bounces-2136-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D9EC44500
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 09:06:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxZtR6XlPz2yFm;
	Thu, 22 Jan 2026 20:06:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769072783;
	cv=none; b=kt3V97mDC3ynoZG8PcjuSR3BSyTFgqim1cXiA0upF5u8HN0NgvZiW5TM45NRdNCawHL/oOEIJOxUkaI1Sig4k+deV63Pi0lc1eCINgo4B8V2aFEmDMpLkbAGySue3IaykPIczpCjI2FJvKHdILUXeJMCaMbq3oNt44IoOOdqPHFGZApV0q9/LYWGK9OgmrkqUoCGHqt8+HqesUmiYYkwoQcQcrA5gGKAE21VyKJ04SICsHNVdkphBJiUcajAPw584LZZIvGXFJl5+ChG9ltG6GJAGd2bOj2m7Dx9Djb61lHpR7mNf9ZBLAeh7c6ICk0CeiZWdiuUHyQpQ5xC7Nvjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769072783; c=relaxed/relaxed;
	bh=HbKWeyvTn7QxOcj5u7WlV6pTmyZV8T1oWJcfa2hM10s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Odw+HpJ/LiJreKf4XrLlo02DnGX2YCRk3pBhEbdrPurVYIFT6tyGha1jqpcuwVZzzb4Roj1ed/Gudee+v53fxNXQg95RcszxOD8B3Fd9B7tJngYdF6f8Xn3xFE0248YITapuRrX0Wjve3984yWZ8oaKs1AQ1soRNKo/PMU4LjW/8bsUuLOSED4qpuqwb1+IhXPSBnBTeM1abmbFugwDG20Qvc4HnK/Zgcu1dyG6NdEK0gCriBU2WDK1Y5hyGLK1gRDilULfGHYx+Xt1fmlCwWdNEORGRXyDOKM17ghAWC+NzxlxGXDfWNuZSkpdeh7K9orazjF1JfR8CYLOCs9gU3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=iwfuEehE; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=iwfuEehE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxZtR0Hd3z2xS5
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 20:06:22 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74C7343C51;
	Thu, 22 Jan 2026 09:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19936C116C6;
	Thu, 22 Jan 2026 09:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769072780;
	bh=SSlkbWXs2HBKgVgS0PNBzt2Rl9RgNm6VF2xx6qvdqMg=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=iwfuEehEn5/me+C5lK/pHv573lXyh8ASZz+dqf6ggc7NHG2Q61KRLzlSe3Ev+xRjJ
	 KJNnwHzW2B2rLGK0exqGLI8d6oyF1ksNoJuskqE/GrFjRk2FccIXSvjmStE05oFtoc
	 5sESwl6DE0IOo73Pa8HcW7nintmqL0ueYPlpRGXWpHZimBnNPapaZFScVan+e0K6HE
	 tDKPOA1rXOOZN2KtHQMq3DfgoWmdQwRN008IIiFNRlEesPLb8qRgolj739utEFVZUw
	 F+zB81PwwSq6FyCOfpy8r7OyIMlqZaN+KxiSohAAO54iWvqpUIcMUsxY4lowSg+EH7
	 MSPhvcs5bm9HA==
Message-ID: <3ade0cad-2053-42e9-b340-2eb2f6066675@kernel.org>
Date: Thu, 22 Jan 2026 17:06:23 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] erofs: fix incorrect early exits for invalid
 metabox-enabled images
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20251229092949.2316075-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251229092949.2316075-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/29/2025 5:29 PM, Gao Xiang wrote:
> Crafted EROFS images with metadata compression enabled can trigger
> incorrect early returns, leading to folio reference leaks.
> 
> However, this does not cause system crashes or other severe issues.
> 

Will be better to add:

Cc: stable@kernel.org

> Fixes: 414091322c63 ("erofs: implement metadata compression")
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

