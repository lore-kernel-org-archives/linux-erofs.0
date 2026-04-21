Return-Path: <linux-erofs+bounces-3344-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D657F327B3
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Apr 2026 07:18:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g0DHP24tQz2ySW;
	Tue, 21 Apr 2026 17:18:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776755937;
	cv=none; b=R5+GzN6FNQdpJb5GlRvNGdCxK6CugoAe07HKn/nVHSkWra1toMSH9fqv9jAc34dDFz9GAKuB1DCP/L0S1bafCVEBPP4zk4qrbzrAAhO9RB60AttM0QBa/jB8MsEaC0MGXSg1fjzLDQU6OTYIF8amVn/1SNjs4x0XyCht7mEK0mrT98vEXXrrX6cwMyZZay0gACPaX3P87766SPdide1ccMwl+tJGQtTmGfjfRyHXqGDz4mYgx5JFgmIuntqt/fgBGzoSDwVyTF5mzhuij45Pcmj2Huh6y666ajhE+EtdVRb2Oga7u7N0CgWwjEUDeSFye9RtXTqNsoeDhz3vxhQbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776755937; c=relaxed/relaxed;
	bh=Yj5v8822X+T0xcWU9Pegwpe+LDwEGV/nZZ4K5oY0kDs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d10bfrI7PB1mLRr6fb+KWcnPrdLEnqN2j9VGtS4pdYqZ9/xF/SjrhGwJals6KZ7aDleEKFwg+YPigK5zRgU6NjDlTFl7eDbHScPlGm9+cHyxrwjEOOq1ucpPkqutqrxYOyn8Q3dNBWliwrczFb5Z+UqE1MHF+euI3MZbb8mbnr+OodVIfoKLKLaOVMn5u7rgPYpzIdWzxYuJRmVDl/Q+MknQh1qGuW8zGWyRXNbD056VK5qzplGTUQglYedMG+dqi2sYO1MlTq4K8/qYmXm0zWM8VjDtg+tt0qNQgb5TaY7qXhKDfwLjdVd/bCQg3Y+AXUlXMccLv4e0Gi4AfvmObg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=hULAVxHR; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=hULAVxHR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g0DHN2C2Pz2xlK
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Apr 2026 17:18:56 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C16506001A;
	Tue, 21 Apr 2026 07:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615CFC2BCB5;
	Tue, 21 Apr 2026 07:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776755932;
	bh=S6ukYIEa7PkKZt0aeWQsFUMV2dD52iDECI8Kl9MrcyU=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=hULAVxHRy4aIDb5Ad7g3vKoJlGRKEvPgaMlRs457W+tQEkuJcbi5XXwXWPbeBd6GL
	 fpll86KYG4FB9e2yC1vHxBK2sbhpXpcp0fyW+0L/+yMUhQaNpEF6zCBM83JSvmo/Cv
	 WVddOy7TbqdGj1JRtsmUTwwz8ZIqulDYWgKNa8cSrV8bKfragjFV0aBSt5J3nbN6cy
	 60z8JQv6Mug2uVGwquPf/LNSJvg8dgDE/nP7QgdRQtc/JBlbib5wiJK6Rj9z6AfwrV
	 rEvqRRchy0smmcarGlNUj6g3WIhZiUwMvdqZ3TIkteEW29chcD5/Qd8GN/lsJ4SCdD
	 7FYcL1oiC4oFg==
Message-ID: <56b30a7d-05a4-4b79-a743-0ed4a4b510c0@kernel.org>
Date: Tue, 21 Apr 2026 15:18:49 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>,
 oliver.yang@linux.alibaba.com
Subject: Re: [PATCH] erofs: fix offset truncation when shifting pgoff on
 32-bit platforms
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20260420034612.1899973-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260420034612.1899973-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/2026 11:46 AM, Gao Xiang wrote:
> On 32-bit platforms, pgoff_t is 32 bits wide, so left-shifting
> large arbitrary pgoff_t values by PAGE_SHIFT performs 32-bit arithmetic
> and silently truncates the result for pages beyond the 4 GiB boundary.
> 
> Cast the page index to loff_t before shifting to produce a correct
> 64-bit byte offset.
> 
> Fixes: 386292919c25 ("erofs: introduce readmore decompression strategy")
> Fixes: 307210c262a2 ("erofs: verify metadata accesses for file-backed mounts")
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

