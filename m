Return-Path: <linux-erofs+bounces-4603-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE22C98321
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Sep 2026 17:13:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hrL5d4n6kz30T2;
	Fri, 25 Sep 2026 03:13:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790270021;
	cv=none; b=S3JcrksHWqqXT9scsUuOScJsO5fQaS2Xi/N1HwSROcWbpNOvCjYiINJVZZrhIZYvEk1pubPTA7cWGD+uCVCkD5SiwqsoSkmGPbA4sZ1E5u6OJVDEl39b40biL+s4gSLZb+8os/w+7XuS63438S1UdBWTqI7sFofgjaZGW6ZP2y9ARKGyW8AAAIvXqJZYkG/cXhHv0zYX6FxP2n5Bfrrxv8QUuYoGPN20HMEASYpPBj5stmHMZlBuToj/bqqSK1mcwxZF3zWQXsyMjj3ICkOdwdRI7SfBU3a/TQ0YirftuMZWC8otKjtXVzLyZBMgghkkyC/7Xzctr43HJ93CNyHYow==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790270021; c=relaxed/relaxed;
	bh=kxMY1nqX0yyGvdIZz68ICS3+ucAiC6IkbfSFVxjdUOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mObjEZramtvJ8B6d+f7lWzkg8Am53y/t4MM+cCMoSm2NZH3pSpqNaom7aHgDMO3MHKylfxO7tiCr6hd+o0Ru+WUlEL5GOcvBVoUmufTUnMM3LZixfp591AMkRwi7z5cQpMfmz1+SCmFwR+oKPnov5JBaKdw8TD5c4Xhux4ZTwBlt2ivoy2REel4hivNKN/IP8nDtc4SKuJcd2m/uyfWC6V6dbRQesxgRtRsvrR2TJDXFmp0kPRFEFj5tXoyo1AO0cu228amTGrqBXYxZ6WYjzfJlRgRCm3/eTpqIDvkFxaD/lAV/l6alL0libRKY2DDfSoZIS7dbJKuznQsM+4WQSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OkpYA0br; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OkpYA0br;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hrL5d0YrGz2y7Y
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Sep 2026 03:13:40 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5177C43D1D;
	Thu, 24 Sep 2026 17:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958A91F00899;
	Thu, 24 Sep 2026 17:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790270018;
	bh=kxMY1nqX0yyGvdIZz68ICS3+ucAiC6IkbfSFVxjdUOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkpYA0br9Z+nqOV6iwnooU3a9PFXfF17GLqHBA8ks2ICgq3akAIEaf5EH7r+eIXgt
	 zij7fZYbcT4cuaKvQhUaU48PdhNqZz6ocloJViw6PD4OObn8I+0/PUbxYirtuERCQF
	 /+8CeWqaqmK9J87vCLJcVewgG5JA9A5FHOO3FJVtJeQFpLuhqxRzPAXPxTwmNptRPf
	 uMuwvFJweuNOmRqN8AwyrPf1Xc/r6oXKudf4qcEhQM5G6UmARw0GPJFOVRAhjKpUyX
	 7Gkxnn9eb8QHizZ+exKAVGQgkmfZR3ocE2LPVskflvOdmG4b2BEtHSZEk5ZAFBHCrh
	 9y+6lF7yrncxg==
From: Sasha Levin <sashal@kernel.org>
To: Artem Dinaburg <artem@trailofbits.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Sandeep Dhavale <dhavale@google.com>,
	Will Shiu <will.shiu@mediatek.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Alexandre Mergnat <amergnat@baylibre.com>
Subject: Re: [PATCH 6.1.y] erofs: Fix detection of atomic context
Date: Thu, 24 Sep 2026 13:13:23 -0400
Message-ID: <2026-09-24-daily-reply-0004-re-erofs-atomic-context-follow-up@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <arSoAUX4jDzgY-rG@MacBookPro.fritz.box>
References: <20260922200448.27724-1-artem@trailofbits.com> <arSoAUX4jDzgY-rG@MacBookPro.fritz.box>
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
Content-Transfer-Encoding: 8bit

> Thanks for your effort, this commit has a follow-up commit
> commit c99fab6e80b76422741d34aafc2f930a482afbdd
>
> erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC
>
> could you please consider backport those to stable kernels as well?

c99fab6e80b7 ("erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC")
is queued for 6.1 together with this patch, and 6.6.y and 6.12.y already
have it. I've also queued both commits for 5.15. 5.10 doesn't need either,
since it always hands decompression off to the workqueue.

-- 
Thanks,
Sasha

