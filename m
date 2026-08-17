Return-Path: <linux-erofs+bounces-4240-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B48FC5B572
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 08:07:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNlmc17m9z2y1Y;
	Mon, 17 Aug 2026 18:07:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786954032;
	cv=none; b=avniXUU36wTuO3WDM3CEBujkdNDdrlC0hgwgTJgWgJSIVh6yIDicQ/gAI517uf7zQ7WkfkvpSDZS0P4EkUWDW5iqMCPxPG94U0EtGiexFihFecwEl1NFoq5rR/z2S/2lNNNxlX2+vmYZ0atFIJkGjmqwFvuvBLxfMdje2CxaHYfiPG+ODSSTDycs8bXIWzvKtr9FYys2Jvm2GaCxkrbnXfQ81h6cb1mjaMLwodUP7eDgXO6aUP9mqdpnIeX4susfj0zac6CqXgY8SIJRwbtLk4HWUQ2y2KlpUCukHM4GR7qPU/9DTP2N6n+hDgrFUpvjdoKep+UmO+QRzmXvxC6Q9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786954032; c=relaxed/relaxed;
	bh=Tr/5LvYwvDujY6pEpgDa6NZZi0gBHtP9G5OH9zKqslg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JaplOPI3MMHEllTs4/I4euCOuGv+uDgnmlwUU+ozf7oOnNxjHU0SkoCwEgJJ4Ff/vjCdBGK6Puep3uVMQTG6CyIP4WWG2wJc7uvOIURK5GpMl3ncFuNM6yB9qc9trUO0u2zKwb19tr6p03NAbx16hNrCW2zgqIPOfoFoMMgN7vtKodH3/GH6jcRYAvVMGhiQDXcz9iDqZBr74j0UZeJGIKPBScuxLWDmE1f6NL9e8Yk59PFExHQHFV8PcWyMEyH+y10KgsgoqcmQOu/rGJJTgNLn8ASl0LDpGT8J8G7Xh5ju3fnWJtb1pmrVnEMRAIn1Y8V9eHjYM7bgIXb3YFM76Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V7XqmRoJ; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V7XqmRoJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNlmb39xYz2xl5
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 18:07:11 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC48042148;
	Mon, 17 Aug 2026 08:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29DD1F00A3A;
	Mon, 17 Aug 2026 08:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786954028;
	bh=Tr/5LvYwvDujY6pEpgDa6NZZi0gBHtP9G5OH9zKqslg=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=V7XqmRoJ7VJ32P/O+43p8Gh5zfbfK7ITqdtjb1P3gH+Ix3zAPR9X0tTATUXOPXp/N
	 lsZYhRNa1tQpDnhi5j27vk6BIYaFh/G/Ul/3v/2dS13Xmy1H1QGCiJ2rzyYB09Ihgf
	 vHkNgtYZq2SGoUiGwK7l6Cq0hCjttM2VYFB1L65qaPevgBda06xWWto093+pnUSR/1
	 1yXWUnKRtCS8eLB4IQchQGa3rEjtZubGxeKwwqz/g6Y2mEoTi4hRuJsYHqzrf2kze3
	 yPjSqrKOVOn3EvryrzrSwIFC4Z3zN6Hz2gpx+dgd/MSObVFK6JIaAjVSSG/zQ3ohpc
	 399ym3F599MEA==
Message-ID: <966c109e-f9e8-4d26-9d65-292949b1118b@kernel.org>
Date: Mon, 17 Aug 2026 16:07:05 +0800
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
 Haiyang Huang <huanghaiyang83@gmail.com>
Subject: Re: [PATCH] erofs: fix interlaced ztailpacking pclusters
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260814065946.78216-1-xiang@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260814065946.78216-1-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/26 14:59, Gao Xiang wrote:
> On-disk sizes of interlaced pclusters should be block-aligned, and
> ztailpacking interlaced pclusters should be invalid at all.
> 
> Currently, mkfs.erofs won't generate any interlaced pcluster with
> ztailpacking enabled, so this doesn't affect any existing valid
> filesystems.
> 
> However, crafted images can contain invalid interlaced ztailpacking
> pclusters, resulting in an out-of-bounds read from a kmap'd page and
> copying irrelevant kernel memory into userspace-visible page cache.

Nitpick, if this can only happen in a fuzz case, we can add unlikely for
!(map->m_flags & EROFS_MAP_META)?

> 
> Reported-by: Haiyang Huang <huanghaiyang83@gmail.com>
> Closes: https://lore.kernel.org/r/20260806065253.1083865-1-huanghaiyang83@gmail.com
> Fixes: fdffc091e6f9 ("erofs: support interlaced uncompressed data for compressed files")
> Signed-off-by: Gao Xiang <xiang@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

