Return-Path: <linux-erofs+bounces-4236-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 239FEC5B572
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 01:34:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNb3x2Jc3z2y71;
	Mon, 17 Aug 2026 11:34:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786930493;
	cv=none; b=kf/mU2xEs+Oun7WxMMHW2oVUHLr8UP5yzkjSs6h/bqotF+qdLdFh7xot5OCQlNF8jaMxQBsxxdTQxC7vq2RQjL+Jr+wdH+9dbOL4UMi+RnuSF+rm2tiswEkAM6q7rS1UqFEk4evQiJiuqWL1PxYb0IUimcHpH1sxlSlejzpuBi+MVyYIwppG5PxJMFQ7VF5PwaLqxK72ejfcrw3eL5AyGOymVDk+zC9LwaRDzVEYHabZqY91opaGm3sGiS/+WBjqJm87DUrCUEnSAXiPKpq/+52uKaB1040l3Qd/WhYWgRuntVAJ/xievL+9MtoN9kLuHy/FnaCkKartzMOT+h6Zfw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786930493; c=relaxed/relaxed;
	bh=+M0Ig2bI89DLBk7czXEVENLWuPH8Hkt5TDkGEpg4ZpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KufjrFIzdbMMaWrmjQJJR6Uw9feZ4vcMXyoa7A3vri1iDdKxKb3alyetzHU2ysuCbGKyEF02TPy97DH7qwd/tIxj20vWFpDy3ERecXxIaNBCAOH0FILVp0+tCHeiS4mhrEIMzE05EFDD25KTToTQK/5mur+1++hWSbEf+1ZW8SLxjMy3hweMMOYY8pXF/70UDFl492NMh0RUKzBwv4JvJxppdao73dA8m6uiGYrvbcmcMZFiWioIdNdeS3H7uTMuoJFU5P28Pkday1P1amw28qt8bJFhqyv6yKbVK9gdGtJoD6aislZIlMXl9B1OhsYf3Icq+1hTaY28BOm+61qwOQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a3plpabn; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a3plpabn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNb3w2Nt5z2xlv
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 11:34:52 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C02D60120;
	Mon, 17 Aug 2026 01:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F721F000E9;
	Mon, 17 Aug 2026 01:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786930487;
	bh=+M0Ig2bI89DLBk7czXEVENLWuPH8Hkt5TDkGEpg4ZpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a3plpabnNhKk5xFNG86aVRWNSdl7xbqnMLPzZSkVke8eo69LX0EaEvNkqjtaBbFuP
	 Y7gVVQKEpl9eKWS+dCom8oG1msoMAA6xZMoFOAbqpiBR/ydC1HEbEfxJTAmfEin6tj
	 l1GyXvwv0/xGWY11V0848lHIdKA0SCHg7vREM5pdmR/o02BmkKgvrs0aXfzUwwGeUx
	 3i5x2uYlDLbAVTVl656sz5LTDbHekPVz6Du0Vr3UknG7Lc+Ob7oKiyef3XhyXwAf+J
	 Igpdi7Wpxn8QmCea2VXtMOYMHaCBrFPG+NJzBSj5uL5YFiknQc4ID0KhcaI9z5ib6X
	 pUA8M/+2Q0xVQ==
Date: Mon, 17 Aug 2026 09:34:37 +0800
From: Gao Xiang <xiang@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-kernel@vger.kernel.org,
	Shirisha G <shirisha@linux.ibm.com>
Subject: Re: [PATCH 1/1] erofs: fix unused pcluster_pools for higher page
 sizes
Message-ID: <aoJlLYGaHcwGY7nL@XiangdeMacBook-Pro.local>
Mail-Followup-To: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-kernel@vger.kernel.org,
	Shirisha G <shirisha@linux.ibm.com>
References: <cover.1786884312.git.ojaswin@linux.ibm.com>
 <808f25346aeac628aa9968f786fdbba09366fd76.1786884312.git.ojaswin@linux.ibm.com>
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
In-Reply-To: <808f25346aeac628aa9968f786fdbba09366fd76.1786884312.git.ojaswin@linux.ibm.com>

Hi Ojaswin,

On Sun, Aug 16, 2026 at 06:37:09PM +0530, Ojaswin Mujoo wrote:
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

Thanks for catching this, looks fine to me:

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

