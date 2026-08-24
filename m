Return-Path: <linux-erofs+bounces-4293-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA4CC5DF97
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 00:44:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSscD3dStz2y2P;
	Mon, 24 Aug 2026 10:44:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787532252;
	cv=none; b=eA4FNU3Yeg3I5BnqUYXwlsZc52ACiODqAxa0jSFfYNXwxnRwhss+6deOAxqwrD/pLE48DcN/ROfjB5Q7EvGp10x3h9wN49wbpHASBSdvukS72Ae625MmwmiF1YCFMfpcrJe0sT/RDWQheor1YjXTfs8BDL5xKUme96+/z3Qci0/eIwq4TTUvec7Q0/FRJnheBKNNdLHX8VM8ffmVP62DsFBkgZ1IAhloBB2vkrljX6rZrrK2vSqOMx/Ki45lfHKwgyynnlh9rCBewDfx4UCmtrfigA+8N+ydAu7JY2StgHdJFqX7VaN2n+mBQv19BbfgscQRbvkjuV1U6EDtP8z0tg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787532252; c=relaxed/relaxed;
	bh=mZ5K5rwI7nwTYOQqjFerlZVC7gSCH4r6hGJsHsj3hBw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZUxuv2nPQrmh3PjmX3p18neEnegtVmBSwS4UVSwSkx3sySbjTsBE8x28ToGyNzLJfMLKSS4cl22P+p2TH99ZhCCpWV0FnOxONw9sBnTjg46DP36alje53iOQ9IThOqhtN6pR8SVkOMUxbOB2yrGTvN/7UHAACQ9g/on59cPQ3UY2ODMWIR7HUQ8voAuO5k6ca8aukEVx7dvxePU59kDtYGd1ToiJxxFmERdROOw6gXNBHW1+yJxb3IwMoURXCc0GOgTiHx8TEM2UhHgDA+sGYQKi6Ht+x6jc4GAcWDVR6lYP8mnDj+a/JPNbgY61he45Cjq/m/PuLpy9lt2j/DYbgA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGDcNZB+; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGDcNZB+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSscC6DWvz2xns
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 10:44:11 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D38F600AD;
	Mon, 24 Aug 2026 00:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1C11F000E9;
	Mon, 24 Aug 2026 00:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787532248;
	bh=mZ5K5rwI7nwTYOQqjFerlZVC7gSCH4r6hGJsHsj3hBw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=QGDcNZB+WGe73sFwhClatS6Jyub/qRyUGxGEoiWM27GVPT2mTlKva1/brNI8shfrm
	 VFIocLuDLDkt+UL6Dyk1kW64qaYVDq52dxjR19wtXYv67Zg4ChEZUL2Rz9Z2GIIkYn
	 aeiiJOWSz6nWWRWZN3Fs0VFCpDu9thG74AnOVSpBdhSplAHGmpEE/0y7XppcpaXnxF
	 pU2QSJ7WGiKCN+10cTkDpcP3Ep0e6tzQHVbBtkDlDm7y1UUeZ/+uW6fCfKxtpRTrrZ
	 gRgfOis2Pu5w3jNA2+zdPk6Z0FlLZReu5zArKDJEPjltrxuKAViUL6cdg6/J8yKpxZ
	 BcL89YBpXkLeg==
Message-ID: <b74b343f-d9f2-48c4-b3cb-8deb6805d6d8@kernel.org>
Date: Mon, 24 Aug 2026 08:44:05 +0800
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
Cc: chao@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
 linux-erofs@lists.ozlabs.org
References: <20260820134006.66208-1-jefflexu@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260820134006.66208-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 21:40, Jingbo Xu wrote:
> When inode_share is enabled, erofs_ishare_fops.llseek falls back to
> generic_file_llseek, which treats the whole file as data and always
> returns i_size for SEEK_HOLE, hiding real holes in sparse files.
> 
> Switch it to erofs_file_llseek instead.  For user files f_mapping->host
> is always the real erofs inode, so SEEK_HOLE/SEEK_DATA resolve the
> per-file on-disk layout via iomap_seek_hole()/iomap_seek_data().
> 
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

