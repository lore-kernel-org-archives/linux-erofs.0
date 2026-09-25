Return-Path: <linux-erofs+bounces-4604-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C5EC9830E
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Sep 2026 06:53:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hrhHx1lvvz2y7Y;
	Fri, 25 Sep 2026 16:53:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790319229;
	cv=none; b=VE7PJqWhg6KFaLfBDpYD6KgEh44Ih4hsQxPJE54aUaHmskmMOAGkwpbf6B4ICLY437XlXLcTqaa1fJUlnKvc/DNd3EfW5p8hDDkbcar/pfDOYdH89DmXg7IJqluLPhb68JyuqJ/cpLcR0rLr6dizh23bPLmuIvda2AJaElEaIJ1r1I+LVIwqyqtXmKEcnHorTCVPwUGDagAv8THK0q1/7O7zXTShenCyKovngK7A7Velk/pDG6IuIwbpLl1DIsB4+3nNXAlL0Mrs2RZtWp6Ttgxe0KQhgtchw2S8UUF+ntHbtCusj5DRAVLjDZgP0B6dIW3tQH/q49hECsfAq5AQ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790319229; c=relaxed/relaxed;
	bh=KV1kJEu9MWCxcXdqLjfpsTub2AJOESaQRgwi2TfgLL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DebTg83Bg4jG6C68sjp9SJpv2O+EKUhjnGpbmRXP86pnrzvrZSG6w9WTKCUKfTWsfcGXxFnHS1BkASC9kBy2AbIVfOUfR/nXfziIhd64dEwDSC+2z+IQu6RrxKN6IXefLmsPHJTkCVmDtIVToILJtquIbZEx3MRnss9Wn5q/2AO7XLwSKfwZpp0eXS7RXJNdnSTYpK9rGzVFQm5qwAH14askEPAZnunT/htO9buPQ9GSLy4NhhRBJROHCV0ht+DFr2R/XVEiQKvDZX6XFn3y60CKr/Ql5im3lURVwdz25Fv+EACS6wUR4Jx0yTCGWmsLXL27tBCY98lYCPxgUl6Csg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UIPhYy/v; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UIPhYy/v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hrhHw2J3mz2y2J
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Sep 2026 16:53:48 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FDF9419F7;
	Fri, 25 Sep 2026 06:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDFA1F000FF;
	Fri, 25 Sep 2026 06:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790319224;
	bh=KV1kJEu9MWCxcXdqLjfpsTub2AJOESaQRgwi2TfgLL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UIPhYy/v6lOlVOrdKTETZSFGQOUQDX4VvpgoOAgfsEWsEbR0WGx6L3qbsCmdY984L
	 AXL4dg4kYZaFrLO8YGgfDtN5Qe72DWU5dDtzLq9qkBew6ZKV0UaKfWf6lVobzyr2vr
	 uH5afNmXfUs3SsmRZ2RL5i2b9JqB0ivO86CLDHtGg8X7ulkUlPO9PEUT3eTvzPRi+Q
	 ZCoJS54GVLNIQvIoKxXSXIL3rorzGMkFXrvWdV8+c8L+fVqPJ+oVIhuge680tnMcNM
	 S6B3nfh+f0adbHsBaejq3savqsC8rLoyjYcAYwDemT/IhJIoVo1b8vn4an7rNAzoby
	 qwZEyqt5ju17Q==
Date: Fri, 25 Sep 2026 08:53:36 +0200
From: Gao Xiang <xiang@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Artem Dinaburg <artem@trailofbits.com>, stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Sandeep Dhavale <dhavale@google.com>,
	Will Shiu <will.shiu@mediatek.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Alexandre Mergnat <amergnat@baylibre.com>
Subject: Re: [PATCH 6.1.y] erofs: Fix detection of atomic context
Message-ID: <arYacJ7KdcTO7UDQ@MacBookPro.fritz.box>
Mail-Followup-To: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>, stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Sandeep Dhavale <dhavale@google.com>,
	Will Shiu <will.shiu@mediatek.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Alexandre Mergnat <amergnat@baylibre.com>
References: <20260922200448.27724-1-artem@trailofbits.com>
 <arSoAUX4jDzgY-rG@MacBookPro.fritz.box>
 <2026-09-24-daily-reply-0004-re-erofs-atomic-context-follow-up@kernel.org>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2026-09-24-daily-reply-0004-re-erofs-atomic-context-follow-up@kernel.org>

Hi Sasha,

On Thu, Sep 24, 2026 at 01:13:23PM -0400, Sasha Levin wrote:
> > Thanks for your effort, this commit has a follow-up commit
> > commit c99fab6e80b76422741d34aafc2f930a482afbdd
> >
> > erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC
> >
> > could you please consider backport those to stable kernels as well?
> 
> c99fab6e80b7 ("erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC")
> is queued for 6.1 together with this patch, and 6.6.y and 6.12.y already
> have it. I've also queued both commits for 5.15. 5.10 doesn't need either,
> since it always hands decompression off to the workqueue.

Thanks for the effort!

btw, just correct a bit 5.15.y also has commit 648f2de053a8 ("erofs: use
workqueue decompression for atomic contexts only"), so

upstream commit 12d0a24afd9e ("erofs: Fix detection of atomic context")
upstream commit c99fab6e80b7 ("erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC")

are also needed for 5.15.y.

Thanks,
Gao Xiang

> 
> -- 
> Thanks,
> Sasha
> 

