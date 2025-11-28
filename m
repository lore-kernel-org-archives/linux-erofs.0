Return-Path: <linux-erofs+bounces-1447-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A1D1D116F5
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Nov 2025 11:43:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dHryv3Yhkz2yFy;
	Fri, 28 Nov 2025 22:43:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1764330199;
	cv=none; b=g1EG+ltBK7xd8GqkZ4VI9/Tysa9ZVmb5labv+fMgxJOWZPBYCK7tiGIdkWYAcY6j24dXHDm6Uig8he1awtEMlvtXUhpuzH129tfI++RCrhsWgtl5U0LL1o5KH4tvpIoFOntKWACBZGebFdminx763HHGTx4cW0iWNqNSXZ/GVm2kUQwzqGZbRktAEzwlpdLnwsNmWSxh4kCLiKDWNzxPjW1eiVsPN/Qg5zdxuW24lLvRGN6hLr2ZmzclEYuCEqxvTzC5xu1t9UuBpw148mJgbAVkcKQAHL0uJZ/zU07rh/XvC4eKK7a1iX3CeMGdjq2SG3wyKf2Z1gK3LO6KT3QwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1764330199; c=relaxed/relaxed;
	bh=1YYiVMINGA0paHxdxtG3NM/BE73Z3W3E7oJ5vVmIsJE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lrkXrI3nkuTR4eoheZc7drvYx0fDt5gGL04tbNync9rVwVK6bZvYz5MSCqOU/aVj0bdFiL+dgc11LEXAu5HRRb3ri9roQStZtjJk18aLG9ZvqKeg3/F0mQYICLdUnNJt4sNDiXJU5HS5D5EFFcWt7ucjRwgMPO6XTgi63WeSAWVXYymW0ienzNfC5FG7H8YqPPCmFRevATy5Ep1Up47rkCvGzTEcTy5NnE0e63IkRVIFrWQdPQsAVrjrDpDinFC7SmiILod2aGIiJkInzOsYl7U7QFYsYtgH3g0YNXzf/ZkX9j+x96OXbqdHZrzKWSp+ZP/kPiP6VX41MVHEzq/f9w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=J9yRIziS; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=J9yRIziS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dHryt411rz2yFs
	for <linux-erofs@lists.ozlabs.org>; Fri, 28 Nov 2025 22:43:18 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3947760158;
	Fri, 28 Nov 2025 11:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942FAC4CEF1;
	Fri, 28 Nov 2025 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764330194;
	bh=P1q5vgB4xcD4mDXF+HPQato11wVPRDdiW7VYmH75Yzo=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=J9yRIziSDPJtywXFpYVsn0+1w+Wkrv3Xxw7pZPB61Wt8dqVQI1GR3TaTtn8EUECT/
	 9R3AUNg+L7LKhLcqz5m7fbJ4BqtRP20k09uGPcWC1qxRGrABq0sJAtCzYlArVYsIBe
	 kd3cUCePSEUIt/aetgI0Abe5nLm0w/JaQNOt1Ycy+SkqdubRZGEwleR6JwDfwFc+/i
	 TDB6JhKgz4V0G+WLydJBHML9Pw7hSMVATbBYvtw9Rr6AEfZG7sWUY2zdCqMF/1eBKq
	 joI/d/pd1Od0jZMW4j+MSouLMKVR/onbvOpKX/vFPjW5yS2Huse+HHVjzvdQWdyJMw
	 F4AQVK/3FH/VQ==
Message-ID: <bfa9d99a-cd4a-4bfb-9257-8fe70f8b6ffe@kernel.org>
Date: Fri, 28 Nov 2025 19:43:11 +0800
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
Subject: Re: [PATCH] erofs: tidy up z_erofs_lz4_handle_overlap()
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20251125170102.3604700-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251125170102.3604700-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/25 01:01, Gao Xiang wrote:
>  - Add some useful comments to explain inplace I/Os and decompression;
> 
>  - Rearrange the code to get rid of one unnecessary goto.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

