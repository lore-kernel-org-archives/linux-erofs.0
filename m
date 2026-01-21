Return-Path: <linux-erofs+bounces-2108-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB00DD262B2
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Jan 2026 05:23:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwsz76NGkz2yDY;
	Wed, 21 Jan 2026 16:22:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768972979;
	cv=none; b=JMns7LkRy7JNlefavmk3iCDzYVPv6ssB6kOrZmGkN72U/7nNA7fNxDnsxX7E6K6+h6CXaf+/WktgFaughFRPVwi7zhj4NixM0IXNnQJeiwa5rEpmhKFz15i9qYfdBW5b4d4GHZSaIAH7XwtHyayxG8xAwY9VYL1HfS12tiLeSUhBUc2HcIXscmtoboPJyKoCUI3+v4DRquwyR4X9gP1CyUaRCFsuhYeEj4gpNw3pIrrr45fH4d8VVF/aV3DGwAVoV8tsTElGC54+T/aKOGtMHUNXEOmt+USzPux6Qip9qLbscz7ayCj72+z6LtEY7uO/6Ao5v+9o4kcoyx2Lclc2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768972979; c=relaxed/relaxed;
	bh=7tJQ3ny11m4NeNY10DlaxnzDHUoKfyh619KNLYGdOXE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LMJJbpz9JDi948k9Rm3tUWgHZxExVEjZyqhr+xAmWmUcHzwm2Cxv0T9KHMeOHEKMispRgmVZ7twjxivI+BT9cnfhM/6FXjX5qmAei1SkeFIiGteIk3F1atXGG95eyO+ROye2RssZ/TDkyxaS2dmpBhaq3R59F63hSgpIuDJ1By+MMfVlRHmjatflCbrf9odFD8TqKI7z/wAikIHn9Xo6ubBgYS3w4AggtF1jlScu5qnNI+i9DBeLH19ye118YR5smq9r64KcgOCP7GBO3OLZIukePtU741LMtvLfjbXALGmYQxZqLLxodJJetmNEYtJGPAl9qkw2n/DuclqbJRWIZA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=K0GVCYYW; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=K0GVCYYW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwsz66f2Mz2xqD
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 16:22:58 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85FE060007;
	Wed, 21 Jan 2026 05:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBE2C116D0;
	Wed, 21 Jan 2026 05:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768972975;
	bh=xHE4aqZ9DuqHfdpaw3/YMWfNk7td3F1IGYexUKS1LeI=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=K0GVCYYWbgo+312eqKS++FBQG/v06ra25GzVr+G8q7ygGo6mIyaEkVrewlN/qfQIm
	 RtSrWwHwraR/0p6jw6m0nc9W110I1nvKonph3ZMsKIwAtRQWxTRdQ0kgyoIsRNBaSu
	 zp2Lty81/hTY2A+qprDPJCKtauP706yJl7QmWq/fFTlrUyjMMTSKsg3wsUkGjeS018
	 UgINvZi46rlA1iDEdn8pQ2AvRrbjaxZ+5gtkSbQv082oyvi307SuAh+C9TzvN8l+Ld
	 gRdy2HurhM5c2e6E9h10HLlZDP9Zs9Gra9mJjWfTkhd081aomZQQPKa0KWIx4qX8VH
	 6PZKP+D2uyh8g==
Message-ID: <fd5c68d8-f544-4b39-90a3-6d183909be8d@kernel.org>
Date: Wed, 21 Jan 2026 13:22:50 +0800
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
Subject: Re: [PATCH v2] erofs: Use %pe format specifier for error pointers
To: Ferry Meng <mengferry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20251208093138.127880-1-mengferry@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251208093138.127880-1-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/12/8 17:31, Ferry Meng wrote:
> %pe will print a symbolic error name (e.g,. -ENOMEM), opposed to the
> raw errno (e.g,. -12) produced by PTR_ERR().
> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

