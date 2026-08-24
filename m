Return-Path: <linux-erofs+bounces-4292-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484EBC5DF8C
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 00:43:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSsbQ1wG3z2y2P;
	Mon, 24 Aug 2026 10:43:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787532210;
	cv=none; b=JYEeznHrRdSyNq5sdqzkPK6oM3QAPBG9BLx0V8XIfYWHx0X6RSIFf/ySIcFws9vbbJVPJv2uguFiXauHIf3Z9btsvY94IYP0278wk2igKgxo4gvAkCnvVpJrXaxSsabqNsm9YgS+DnVF+fuSqvNg3E+Ruary/rXuWj9ZcYvM3F4kBjUWZVH9DSPInSwR0mFpWmvbeXiFfGBeRDB/k3E1N3fZR6vbmmoMGdsP62NN/P8cZv4NUx8gbGCmyIOoMn+HOWOWBrx70OtiHt8RtGRbrAupUvSZIwmHfgDqB49RulWNDfvSJKLm6eClNIrkbev9C2L6bTd3fIjKTln6zFme3w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787532210; c=relaxed/relaxed;
	bh=WdONH0C7Iil2+qdYRXoCAktbuDW0GcQ1KSpOSYK+ysY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Zw/wjcrpYSDbTeQL1Fu5TIb8j07zPEeXjt1wgDDiLUF42I4l3jXtMMKFwMM+5zu5AfpcugqGgEJjvShKc2QK8P79M2ffE7jXfLOMbax8QjmJhdTjN56nOQIxA/ZEb0LMg4iGGxRzYm32HK7ldAJIgngmDnwXNplRxuz6WyTA8r6CBXHErt6Is85prpf3BHT9oxKz0o7pt8fJc78Qjc4ccj1JwTTov9l3kC8gexD+1AhTspKVuk5skhaSAMCLLtP90i1GsKAwSiZl/Yn+uhXF42knQOIHxAfQyeQUR2TAh8iNRQxY6BVQq8r1rkL6leymYjGOwDz4YkCCrSOWGXfjQA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQ1likrG; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQ1likrG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSsbP3XQRz2xns
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 10:43:29 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B446143709;
	Mon, 24 Aug 2026 00:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328BC1F000E9;
	Mon, 24 Aug 2026 00:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787532205;
	bh=WdONH0C7Iil2+qdYRXoCAktbuDW0GcQ1KSpOSYK+ysY=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=IQ1likrGxzUrrHngXVaXm68hrNC8wtpKo6NWG9tVuplQamnuBBr5YDmMCNOp0Sy1c
	 rE4t1FPWBd3bMyEazhd3qWR1RlXz+ujRN6nIE+kXUauj6MiQAiOK0aUH6E5Dtb0rEV
	 4WLIQFr+tvwv1iBntbjuolZgTpvQ9njVmvOjYvv51YSASRtgAIWNI6bzqovpN3159f
	 CfHqlcb0luKt8N5LldCFOyXbrgD49HfiDxqcA42txpLabx/sBYEJ+V3nPEmZ9/v/2+
	 0nlnoqLSZMj1r4u3Ckia/himA0yB2NtOzWjAIUcX9uBcvpT6SUj2uGI8blCWoUwG2X
	 pLnrMMmL5ciwQ==
Message-ID: <df2be99b-8dc1-49c8-b2b3-fb18a97d66e0@kernel.org>
Date: Mon, 24 Aug 2026 08:43:21 +0800
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
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
To: Geert Uytterhoeven <geert+renesas@glider.be>, Gao Xiang
 <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>,
 Michael Bommarito <michael.bommarito@gmail.com>
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 18:00, Geert Uytterhoeven wrote:
> When NR_CPUS is less than 16, or when SMP is disabled, the default value
> of 16 is invalid.
> 
> While actual configuration picks up a sensible and valid default
> (NR_CPUS or 1), "make savedefconfig" will still write a line like
> 
>      CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> 
> to the defconfig file, even if that matches the sensible default.
> 
> Avoid needlessly enlarging the defconfig files, and reduce churn for
> updating them, by specifying valid defaults depending on SMP and
> NR_CPUS.
> 
> While at it, make the prompt depend on SMP, as there is no point in
> asking the user about the maximum number of decompression streams if
> there is only one valid answer.
> 
> Fixes: c9b47e6b23114e93 ("erofs: cap LZMA stream pool size")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

