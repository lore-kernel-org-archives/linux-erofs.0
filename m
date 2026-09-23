Return-Path: <linux-erofs+bounces-4597-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25EEBC982FA
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Sep 2026 09:32:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hqWw35BVgz2xdb;
	Wed, 23 Sep 2026 19:32:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790155955;
	cv=none; b=DVffbSRsJtCZryTyeFYkaZIDnPyj/oRALl7uYxRwszPtMvW5n8BG0zrsWFBStthPqHKyISucKTDnHXIs80HpsKpo8nnIdUlS9MBSlnYA144oIXShVn3BqbR/yj1eVGTWyfq7Y1+k38t1H58MKbR2VXNlgT86xVEXzDXVEFSWjWIdpVz/uyUt0Sh9Dxfx/kQFPbDnJZYZv5DVJ0Ur6iT9WuWHDzJTQtS824gEZ/3PlJdz3ytJ7sVQHlUeVLHFTU1a1iUWtc1IvqCc1qyJN5YKg8n+UdCMHvDZAOHEYbkDEjfVtQb+O2uavquKS/v7s3V6r6aquNl7T+QleLN/OYFV4A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790155955; c=relaxed/relaxed;
	bh=Idcu2s9vIAMTCtxMWlJwg9fNiWEVvBggt2XbsxTN/JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dts1NPIart6VkyIvd4/IoZHptFaoSNj3dV/PxyZq9lWeyXG0M/HblWfC8KYPrWBPjxLDL/Z82jaieWD8sgXvKrTj6AXc2CVyS2RcDG4rYXdhFnqJfXFZcCkPESordt8zdgJ03OCghrX7n0PeB514YrO3UtSyEMoJHdl/VKglihiMCeVyR7cbps1Gfeba5ePrDVm78GcTVhW1DJ18zAquOhTVBeR4RRGylAQkBFB8VCioBP2AGE80WDJbGA1s5vhq7OtUKxObgBSPb383dHHnHVueAk4oJbNNvpakqlLq3AL0O4Sp88iH/WmI5BD3xbukYOORQeg6zpTQLTlP9vSbgA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K86yTmvl; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K86yTmvl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hqWw146Tlz2xM9
	for <linux-erofs@lists.ozlabs.org>; Wed, 23 Sep 2026 19:32:33 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31FA243B6E;
	Wed, 23 Sep 2026 09:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F9D1F00893;
	Wed, 23 Sep 2026 09:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790155951;
	bh=Idcu2s9vIAMTCtxMWlJwg9fNiWEVvBggt2XbsxTN/JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K86yTmvlsPTpcjqDYcGBYLeA2+V5DQw1p9gUQBeh1SkYhBpdE+spvQ94FugArQz8S
	 t0Iyq1eaKwLucTsxtNzkOp7JjS+uQgZtxZP9Kw6YFBnZiA9/WKI2cZzKMOMv2j2ASh
	 o/NNDhgsErEUXAnW+38JD0L87bXSPJI1254GuE9Y=
Date: Wed, 23 Sep 2026 11:30:44 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wenwu Hou <hwenwur@gmail.com>
Cc: sashal@kernel.org, stable@vger.kernel.org, xiang@kernel.org,
	chao@kernel.org, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
	dhavale@google.com, lihongbo22@huawei.com, guochunhai@vivo.com,
	yinxin.x@bytedance.com, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH stable] erofs: fix large folio race in
 erofs_fscache_req_complete
Message-ID: <2026092320-process-federal-6533@gregkh>
References: <20260923084823.496741-1-hwenwur@gmail.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923084823.496741-1-hwenwur@gmail.com>

On Wed, Sep 23, 2026 at 04:48:23PM +0800, Wenwu Hou wrote:
> This patch is for stable only. Commit c37460cd9b2fc ("erofs: remove fscache
> backend entirely") upstream removed this code.

We need an ack/review from the maintainers of this code.  And if it's
removed in newer kernels, why not do the same thing here too?

thanks,

greg k-h

