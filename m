Return-Path: <linux-erofs+bounces-4424-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80AF3C624D4
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 15:58:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZnSy5Rrzz2xyl;
	Thu, 03 Sep 2026 01:58:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788364706;
	cv=none; b=ToCqHzv0zKelAIKzGanfUApvyg3QEAlB7ASSGFxskJ4F4a6z+pkHgyGMu5BXiZtTSG/DZ1NZm2uHH+pirV8sgXjHYmlGaRugF3CSKcWu1S6KjpIz0FL90JRYNjx0JD9kKmLHycLWlc4e8syuew9yJzJXMIKkih7/ZCHkhSxf6yH0xdse4ARFFl58wmg1hvLAHvOK/Biwln9MvrlpVYM0kbJh8KKJUgZh9mtbh8aVpPLtogsXYUF8YFQFpmcGt7K+gT2H3bVF38+/l+K9E03/YHNbOrimfRhArC+Qj8gRg4fHX1kqcclo14qAT3zs4+E8VWoLXYkViSSSx4Ctm2wfPA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788364706; c=relaxed/relaxed;
	bh=/F+VdnaOW5wjYPcylvMvjMlhsFkA4sztVg1TvgQpQpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kwzm/R5zMeEmpx1qzl2cjlYLIfR7StWdSsaz/J5TsohWt+fQZmB8r3VLLW2a9y/+jC1RZeci0mrbCnYXou9eKlFj55VogcPCuDJoBvPWW6368EOnfqfeV5Y93H5jSl89Tk4WxX1QqZoGiM8zpOkH8cPxzSUnPUBPZAlVBwrjocSyHzlXKsVPYR6AEtfeKT7JSwwiciXoETLIOaxxSI1GhRz1WZOH39KQ76h7hdKkJvmWgH/r7tTxB9aOQBJy56Jcztvl9bxlK41p/zo7xADpybJDngjY95gIEBzL0QA8X5iR2p0owCyVsRWOeInpyokcoqLk4KGo5tdp1KOh+an+xQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XlaXgv1i; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XlaXgv1i;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZnSx6wYWz2x98
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 01:58:25 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B372D4135F;
	Wed,  2 Sep 2026 15:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8541F000E9;
	Wed,  2 Sep 2026 15:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788364702;
	bh=/F+VdnaOW5wjYPcylvMvjMlhsFkA4sztVg1TvgQpQpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XlaXgv1i8UQdvbJzCPN3TuZTui7wcM3XN9sXBIVVOYC+5E4yVJBiliqjsvU+IjLbl
	 HG+h5vEDK39g5JsOSeZoHo54FzQxq25+x2v2YeMzXayHf9co0GAFaPmfc2J8ZJr8Zn
	 Gf+xDsGRiJTjQoIX7U1ec1Z96NUqjVLG1Tc0dIlXucwcAchbeGPMGcDNFfNgIM05SY
	 PB8Kj8L4z4EmlcfhuQq9rUhahl+pmYwaizZiYZLKwKqEC17N8bsXkvqbNg7lBfKc2D
	 cebGLik9adahRYmdM3RDr91Di/m7aB/FNJmy4QcyqPTJshrsfm73LvVFr6MS95y+Uv
	 wXZhqM+ya4vhA==
Date: Wed, 2 Sep 2026 23:58:12 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org, stopire@gmail.com,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 5/5] erofs-utils: mkfs: enable `--blobdev` for flat inode
 layouts
Message-ID: <aphHlNHyv85i1A3u@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	xiang@kernel.org, linux-erofs@lists.ozlabs.org, stopire@gmail.com,
	zhanxusheng@xiaomi.com
References: <20260902025031.50499-1-xiang@kernel.org>
 <20260902025031.50499-5-xiang@kernel.org>
 <20260902081141.3309090-1-zhanxusheng@xiaomi.com>
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
In-Reply-To: <20260902081141.3309090-1-zhanxusheng@xiaomi.com>

Hi Xusheng,

On Wed, Sep 02, 2026 at 04:11:41PM +0800, Zhan Xusheng wrote:
> Hi Xiang,
> 
> --blobdev without --chunksize works here, and fsck.erofs --extract returns
> the tree byte for byte.
> 
> Two things in erofs_allocate_inode_bh_data().
> 
> The bmgr initializer is dead, since the chain below covers all three signs
> of device_id, and for device_id > 0 it picks the metazone.
> 
> The new message prints the sentinel when the metazone is the unavailable
> one.  mkfs.erofs --incremental --MZ over an image built with --MZ:
> 
>   e1959e9  cannot allocate data in the metazone when unavailable for ...
>   0badea0  cannot allocate data in unavailable device -1 for ...
> 
> Both refuse it, so nothing changed there, but "device -1" no longer tells
> the user which target was meant.

Those comments above are hard to follow for me.

Could you just submit patches instead to demo your intention?

I could apply directly if your suggestion makes more sense.

Thanks,
Gao Xiang

> 
> Thanks,
> Zhan Xusheng
> 

