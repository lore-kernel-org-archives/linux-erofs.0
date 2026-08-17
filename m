Return-Path: <linux-erofs+bounces-4244-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9838BC5DF70
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 08:54:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNmqT408Sz2xy6;
	Mon, 17 Aug 2026 18:54:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786956885;
	cv=none; b=J4jbG4tpBs+f5rjBHyMeRkIE+R8soKtlj+Th8O+6n/t1VbUclxRBwCXuYFVw2PoPgQwsvag07C/Q+Sidz6Gsv9B7y3OhYMBAT+S7u830eONBC0XEFeaNxuFmB8Cb+V0DPfuir5/rIgQm6nwkEevbKvF/12MzNS6aVbRVPixh2HBZ+1K/v1Skd8cQDLHSue1ukET5VFc4GX3mcwhBRUobfsI9CVSzVTKzZVORU0U0Qkg8l2/6EteZEjPt0lZSmcxOD69EdiaJv5qxXfFWY1F/oY6KJ7JC0V3cMDba+x7COyddH3r/5RGxXcuvBas4mVcHVHfPoS7+hi63BJJY5ilHOw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786956885; c=relaxed/relaxed;
	bh=0YH9DMmf0CJSIQD3g9u/Rz4rhSst1aZlH2cCZklKEss=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FthVmrt0X1Aile8XSL7sR1EE7tmA5X8F9SVkdDwzIyEBXJXFgE1BG1YWrtc8Sd7a54yeVR8JedZMx7UsSeCc41psuy1Tzj2SzgkmVFtOAv6vukaJLa/1/mthYXS45AVEuGUkyo/jNIWs2vS5xx7vMyjQRsziY/R/NIhLpnh6SVs3vzj6vVsJSGXGVZZ58YOr+6O8G+aw/+HovVFhhaqn6I2RPMFfu3As17WWFYJiSDcj10kQpPHX6nuVG5IHZpXB6ItZEOc8RP4fzuWPu0X5m1F/DWQVK9fiSA6q1CQsxx2rrGyFsdG4ZqgpYfYB6+FQkdYAzV4U2r7FsTJ1+fDX7g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JENCxmXI; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JENCxmXI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNmqS5ygbz2xWV
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 18:54:44 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24BF643C5D;
	Mon, 17 Aug 2026 08:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB9F1F000E9;
	Mon, 17 Aug 2026 08:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786956882;
	bh=0YH9DMmf0CJSIQD3g9u/Rz4rhSst1aZlH2cCZklKEss=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=JENCxmXIYM6lBeA1+4lXjo6QxJLZeC/2exLKqvXDKlyRbsr9YrkF0vFQMTg9li4SW
	 4ncdFaiFH8LkFJS3LYJLrTdlsXs3WAl+mycIFIlwp5E3MPzEzcvRAtc98yEjn9F1of
	 8jmha4VTiiWZElku1cvLinNq1qXKY6Qa0KNcLFH3ZoeYBdsLDi3aolnFyMP2Wr5YbG
	 Hcd6X/1wKFGzE3jN12T+knUBF/v+5F+Je+5O3/5ydcfCHAgWFD8gdVERopig3sm2Jo
	 X59V9bb3gUEnpMellxMBTS/9/EwGyixQomKhsf5sTkpBkay9cQW7984QepZJCMG8YN
	 3Ra8NSfQmFEgQ==
Message-ID: <68fd8196-dabf-4288-bd95-7500a7408c32@kernel.org>
Date: Mon, 17 Aug 2026 16:54:37 +0800
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
Cc: chao@kernel.org, Gao Xiang <xiang@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-kernel@vger.kernel.org,
 Shirisha G <shirisha@linux.ibm.com>
Subject: Re: [PATCH 1/1] erofs: fix unused pcluster_pools for higher page
 sizes
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-erofs@lists.ozlabs.org
References: <cover.1786884312.git.ojaswin@linux.ibm.com>
 <808f25346aeac628aa9968f786fdbba09366fd76.1786884312.git.ojaswin@linux.ibm.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <808f25346aeac628aa9968f786fdbba09366fd76.1786884312.git.ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/26 21:07, Ojaswin Mujoo wrote:
> pcluster_pool[] hardcodes {1,4,16,64,128,Z_EROFS_PCLUSTER_MAX_PAGES+1},
> but the assumption of Z_EROFS_PCLUSTER_MAX_PAGES == 256 is only right
> for 4k page sizes. For higher page sizes like 16k or 64k, This results
> in us ending up with clusters bigger than what we will ever use, since
> we only support upto 1MB of compressed data. For example, on 64k page
> size we will only ever use clusters with nrpages= 1, 4 and 17.
> 
> This patch fixes the allocation for such higher pages sizes by adding
> some compile time checks.
> 
> Below are the clusters created right after boot on a 64KB page size
> machine
> 
> $cat /proc/slabinfo | grep pcluster | cut -d" " -f1:
> 
> Before the patch:
> 
> erofs_pcluster-1
> erofs_pcluster-4
> erofs_pcluster-16
> erofs_pcluster-17
> erofs_pcluster-64
> erofs_pcluster-128
> 
> 
> After the patch:
> 
> erofs_pcluster-1
> erofs_pcluster-4
> erofs_pcluster-17
> 
> Fixes: 9f6cc76e6ff0 ("erofs: introduce physical cluster slab pools")
> Reported-by: Shirisha G <shirisha@linux.ibm.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

