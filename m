Return-Path: <linux-erofs+bounces-2318-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B8B3EF99EA
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Feb 2026 02:44:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fCYK91pBMz2xln;
	Sat, 14 Feb 2026 13:44:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771037069;
	cv=none; b=Wud5qzldID3hCtcslrOOeig+uh0/0NRANFPAB2yESzeotsfO1GrI/qjfyZaeLIqr48uYdfLQZ/qcyAbfAld79ONDKv0zjcJj67xm0y7f7FIqVR2OeAI46ddihrleiuDfRqHBAgMx80jJcVVuExZE/OLKJXBS1s+z2uOIFLvSlaifCAGRR3hK4iA3aREukvki7Xt+ZL7a5myAw93m5ZF72zHGMtFr/FeFvpvPRm6L84Na9AORT6F2yoGpbHLKsSAxFHxs/8GvmMS0vGPORl12a9uxcn5E/Fb6Q/dIsTNKcp6YsQsO5iL2VZOpOw+PxM3qIV1agqfcq8zeeiTUEjatdA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771037069; c=relaxed/relaxed;
	bh=yirB9/4LDiWmr8q/m75cr3j4OYclYINLRP1aL/K+uXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfgUUVoEA3VkWXRxOJf99MadF03HBpi119hjDVBOHzhbwLVsRQysobdp0fF1w0tlTnRPf3rwgLiL5ZLRpiu3g9vP8wHvTCVpqbDgoPNuNTvUcJCmPcAQhXCHmx/EjE2yF7MxlN2FLgdk3nv9ekPV7qVGzlDIGteqUpocoCq67QjofjuOIVUO2GH4Dsvdsx9XSygxJPkXlQ0XGIqovwNAfqzcbmt8IGulRcmJg6An8lUDUzxD1G4wdYShzoN8TD3sZuBezc+PANAQ4feslK4kW8ulotG/XXpeUWouO+Ji3OOFgs2D4y1R/sB2EO8aeecOlLguExAU+MduDJ4ya9ejBw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=IWgRSP6g; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=IWgRSP6g;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fCYK83WQGz2xSF
	for <linux-erofs@lists.ozlabs.org>; Sat, 14 Feb 2026 13:44:28 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D28F041E4A;
	Sat, 14 Feb 2026 02:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A34C116C6;
	Sat, 14 Feb 2026 02:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771037065;
	bh=yirB9/4LDiWmr8q/m75cr3j4OYclYINLRP1aL/K+uXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IWgRSP6goIyRjbWPfxTVg2485HnAvjm2Mndgwbq22cAtx6knnPfwOQZ36JqBVMSTE
	 NxFRc1HCpzqUmH4gsWPN19+rOk8BZO7k/b2pW2BzEjW+Vxf+u6cLd/bM0VcCXF/X2o
	 hvz3YbP8fqBHZbtEqEw8v06H8n7xFoNSx4OFsvruDuc8tMCN5JfIDxHGXAVaxPAs10
	 qQG+K+Ua7xiVmVchl/48FYrJyWb1Hz5pEvc2aYxsPCoDbfCMMYF2NDnIp/5TxEqPVF
	 kb2TQMlzOsl6KZ6+LX6xRHO+NT/Lrf+qyZGoeOMDQ0U3p6e4BNC3yYbnOyHNp8UKUA
	 hODAGW5HI/f3w==
Date: Sat, 14 Feb 2026 10:44:20 +0800
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <zhaoyifan28@huawei.com>
Cc: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	jingrui@huawei.com, wayne.ma@huawei.com, zhukeqian1@huawei.com
Subject: Re: [PATCH 1/2] erofs-utils: manpage: document missing options for
 mkfs.erofs
Message-ID: <aY_hhKH67D4JVVyf@debian>
Mail-Followup-To: Yifan Zhao <zhaoyifan28@huawei.com>,
	linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	jingrui@huawei.com, wayne.ma@huawei.com, zhukeqian1@huawei.com
References: <20260213073241.525158-1-zhaoyifan28@huawei.com>
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
In-Reply-To: <20260213073241.525158-1-zhaoyifan28@huawei.com>

Hi Yifan,

On Fri, Feb 13, 2026 at 03:32:40PM +0800, Yifan Zhao wrote:
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> ---

I rearrange this a bit and apply it to -experimental.

Thanks,
Gao Xiang

