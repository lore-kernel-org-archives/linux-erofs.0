Return-Path: <linux-erofs+bounces-4231-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D049C5CFC1
	for <linux-erofs@archiver.kernel.org>; Sun, 16 Aug 2026 03:06:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hN17r0tYQz2xlv;
	Sun, 16 Aug 2026 13:06:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786849576;
	cv=none; b=M37qOu9qjyLKaDEx1PgU8A/PhqXqugo+XDinBVr16j8cklUlPvoClh6Uhny9nEYloCDGi0InIoG0SDRCOH2DgqhuyR3LcrjjvavgyUI5fBi/B2ujCc05RvgIg5wMoYhWILq55fEXVFhTvRCXZGMJL78/GPM1PIwxyk85ruP83qnqoCJ8nqv2ax6r/6RIFgRAlakLc6CecXruabe4xiEAm58jp66iRs0ik30k7Pquzipk9Lhk1ZIcFly6v6MY5zjTnU3KviyUOJDPV6YrIOQgrAAzOahc8VLIIoFmIYsrVZhzrxhphai9Lv3iNYVsAyP1y77fVcwjllnv5vMZ3Zf6Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786849576; c=relaxed/relaxed;
	bh=060ShLWrJV7mTpS31Y0pwec3LCvS1kdkKYa9G2GHM30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8dIPnazUvFga+FB0kr1AvRpxt0z/paVJfGG0VspwnhxbxIN40r5m1eJEJ5ft3WdoFzIG+cjhrzLttCxH54hoWqn8LeVQABsluWXT5aMQjDD772Yhgp+jDt8ChEtE4cNja4SRLSh+RnSPnLrk0/5YL3JZQ4mlHGn9FkuJf4DbtQPDccwZJpWyh+QuhqvLsNOyo5JqE+6H/riDOGjEYhAlGcnlSDfnsB0ltIM7MLiL7kvaFFaNy62SNFBFbpRBlWWU1/f66VocEEJ39s32QAmi5R0/6oZpI5E0wGfT83utrWr6+FTVlnPhomTdpcALeWMoXUxI4svXkigJGjbhko7hA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=drXHTBTH; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=drXHTBTH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hN17p6wM3z2xjM
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 13:06:14 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6253C43726;
	Sun, 16 Aug 2026 03:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7B71F000E9;
	Sun, 16 Aug 2026 03:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786849572;
	bh=060ShLWrJV7mTpS31Y0pwec3LCvS1kdkKYa9G2GHM30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=drXHTBTHV/2f1sV181figccMGL3UQmT/WeiA2AOYIxuUmlZnegMdgCQhXmY+WdW/d
	 F5jlytu+eJzOtvCMHoybH2dTnW7f0BxmmGz2p4XOf87NoDxohcfsv7pS5YAhKpNi+F
	 vfzBJSifVXnKp9Kbnxzr1A1PUWbwKF+dUbgt2JfLXLTY8S7DH5exAi1Z79FLtWwtA2
	 GegoagAmILeIkw0DxXcsl7B5geXcOosT/jk6amgROLD8YfayGe76Df34V6TjlqvgW/
	 xMZAWYZvZactxnxTYo+2l9GUDv+3EAsTPx0o4D73eBgAFCyFtTtWQAGmCaNw5HTQJ4
	 fcBIBaUwbm4Pg==
Date: Sun, 16 Aug 2026 11:06:05 +0800
From: Gao Xiang <xiang@kernel.org>
To: Bingwu Zhang <xtex@envs.net>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Bingwu Zhang <xtex@astrafall.org>
Subject: Re: [PATCH] erofs: remove erofs_dev_context->rwsem
Message-ID: <aoEpHV2r6ye_Ff3c@XiangdeMacBook-Pro.local>
Mail-Followup-To: Bingwu Zhang <xtex@envs.net>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Bingwu Zhang <xtex@astrafall.org>
References: <20260816-erofs-remove-rwsem-v1-1-78b60b855fa6@astrafall.org>
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
In-Reply-To: <20260816-erofs-remove-rwsem-v1-1-78b60b855fa6@astrafall.org>

Hi Bingwu,

On Sun, Aug 16, 2026 at 10:00:12AM +0800, Bingwu Zhang wrote:
> From: Bingwu Zhang <xtex@astrafall.org>
> 
> devs->tree is only modified in initialization and
> destruction code paths and will never be concurrent
> with data reading. Thus there is no need to guard
> idr_alloc/idr_find with a rwsem.

Thanks for the patch.

In principle, yes, but it's also no problem to leave it as-is in case
some use cases later need adjust the device_info of a dev for example
at runtime.

Or if it causes any noticeable performance penalty, that will be one
reason to drop it now.

Thanks,
Gao Xiang

> 
> Signed-off-by: Bingwu Zhang <xtex@astrafall.org>

