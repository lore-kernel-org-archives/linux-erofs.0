Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94EF606A31C
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 19:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAwokv9u
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPtwD621dz2ylm;
	Thu, 12 Nov 2026 06:33:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794425580;
	cv=none; b=Yr0M3igrBlpij7EodTQGCU6vaRKSD+9wSsoS+8DgGs3mL1NU8VKWIgNeN+g/M5GLCSx/p6J3qtA3tcm8gaAr7kculkkNBb0F7Qq/4/zSmxC0UM6iNfoTC0EMkxbD2ywlAsmLxOFefiPlwgqAL8asUjgYJA66j4QzCHn1gO0vvSrA9d5g20viI5DIm7V1jIMLH1wAjUlkE3/+Iiuz/LqIVh0zV3xGXUCOWHB4EFn7pkLjOPJju5kFxy0L06WFNBsUDg7L6lUc9WTLoJummD8p29KgqWJB/tyFXe8i46bp8kG2S1B43Wh64pmZa6lzdPD+NpwUEW5ZCSsLElwhYBlttg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794425580; c=relaxed/relaxed;
	bh=Fes9FPtsLKfqHmPVcvpxVOfAN/gOdDJJxJ44rGZjokU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3SQnIdIFiCoUjUsJTbf+68bMJjxnvIq51yY5wfPz2hDjNCJwfzr5eA1Q67w5k7lMzFefY+A2mVPDM/0bp9Gn4uHBtaS+I7RiBXn5J5QI0HcdMjicEa8gcxMUOJ9viiKZlGdIsmetB6C2Gpx8KDw+V8AHaFtsX/dCKHI6719Stcgp7MYt1GgmkUs9SIRkBPwI8y5tDcdhdickZpwPGtmW4EIDuUKj0XN+3xDG8apT9GFM0qbgIYytGE80gkRLFmIytzLWKIL3hC8id7Aq9fbx51k7jgj7O20EMrqTc2bHqPNIO5yRoFS2HMUUkcXtEQm7NLrpNxQHhq/vcWZJudPCQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAwokv9u; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAwokv9u;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPtwC4QPgz2yNj
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 06:32:59 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3781741426;
	Wed, 11 Nov 2026 19:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0D61F00A05;
	Wed, 11 Nov 2026 19:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794425577;
	bh=Fes9FPtsLKfqHmPVcvpxVOfAN/gOdDJJxJ44rGZjokU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PAwokv9uNWTvsDzvS9gdrLQ2vPV7+rqM+JtOA9rCtUByaXsTVqZJFF/2lbpJaaG31
	 R1pKFvXu5oaUVZtDdu0aMaPhW9CLe8egEoZrC2ANh+2DOch9r5Telq4OH4iQCk5iy8
	 AP1cXtUS4RmMqDz51LL1OrT3yVzmWRhIl/v/jsH4OdVLF6QOPsZZLBBC3nKQiAH0GP
	 AWlmC5JIC5Z0B/Md3DjRiNEqovl/5yJS2tdvRu9zANXZ5fkJOogMkFOAs/hfxymT9g
	 vY5rGXMFuQiyDxj1r6XTPKmYwtuNKSM0b+YYk0ag1K/CQXhFTINqE6ar8jb7p79jn9
	 /PWnpAJjl1mhg==
Date: Wed, 11 Nov 2026 20:32:49 +0100
From: Gao Xiang <xiang@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] erofs: reset buf->off in erofs_init_metabuf()
Message-ID: <avTC4Q5Ps2xBxslw@MacBookPro.fritz.box>
Mail-Followup-To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com,
	jefflexu@163.com, dhavale@google.com, hongbohbli@tencent.com,
	guochunhai@vivo.com, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
References: <20261111141529.719166-1-zhanxusheng1024@gmail.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261111141529.719166-1-zhanxusheng1024@gmail.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:15:29PM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> erofs_init_metabuf() sets buf->off only for the block device and keeps
> the old value when it switches to the metabox or the managed cache.
> erofs_bread() adds buf->off to every offset, so the result depends on
> how the buffer was last initialized.
> 
> getxattr and listxattr init the same buffer twice, for the inline and
> the shared xattrs, with in_metabox taken from different places.  On a
> block device mount with fsoffset=, if the inode is outside the metabox
> and COMPAT_SHARED_EA_IN_METABOX is set, the shared xattrs are read at
> their metabox offset plus fsoffset.  The same image mounted file-backed
> returns the right values.
> 
> Reset buf->off on every init.
> 
> Fixes: 414091322c63 ("erofs: implement metadata compression")
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

