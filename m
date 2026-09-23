Return-Path: <linux-erofs+bounces-4598-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A58C98302
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Sep 2026 17:30:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hqkWk2CKsz2xlJ;
	Thu, 24 Sep 2026 03:30:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790184642;
	cv=none; b=hEXSq8IKYN76M45mTAx6UOnlCxtDhLlU5UpD1txnW0LZwjIxeVQL76TF8GEHpMYWjkFGgJwVV182moXWhuptLJphc3NyhAk6FibL/c9m7+CAb6vZnznesDVfXmc92Gsd3WDzQlPK39flqpasAKtT0NPTxLqJWiQXidSs2CCIS3SQNV6U4jePLp8RppdibP5ghd9Low/QvJBpzNmzwwNcWhLYbjnrOX3+zVburrwrDB2KQXS0zWBZlS6ZTX5Z92HmJ/LKG6GnAIw2iVbpvXKcyhhgn1uublMSLtGF+G5LnOZeJ7qnl3EfvOwAk6AUnpww0l4K9xVRdKyZGZciVS2Trw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790184642; c=relaxed/relaxed;
	bh=nMTsJFIim5r1Qt5+GRLsacJwv4xPa7nGjJIm8ZL767A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjbHFX6tfmfpwcEHnU+OIpMd9wo+KIDXPJO0S2Y5/6v4OZ2+nWUSm7VU9Dch/j9ryZtSivkp4wYXgGcSfB0o2VM65lXcYW7evMDSayKZcZjQTbIDbN2zd/ztRyS9pgINcaEUXklwIRXHBDj52MxyLVP3E/wtWvgTvP0sbXN469X+TEYPi/AfA+Iueh9tqwC4PLFLXZOwvXztXnlhlb+hsMLImwMS9ihkdgO6BYBSRyOKmf09pnvZgx+WQB3fI7uCvuokiTA+KVR+31h+WOtZIKk5x5RUI0/yu1tIIERqo+LBVBRAVN2PVw1jSXJV8rckcIO0bKP8U83qUULNyeWFig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Th3WcPO/; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Th3WcPO/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hqkWj1Qk3z2xST
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Sep 2026 03:30:41 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25CEE60515;
	Wed, 23 Sep 2026 17:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2AC1F000FF;
	Wed, 23 Sep 2026 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184637;
	bh=nMTsJFIim5r1Qt5+GRLsacJwv4xPa7nGjJIm8ZL767A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Th3WcPO/FPHh1z/IPQ1ujJJ2k1zQR/X8fmsXgWI43OJgYkQ3yRZJQ1aBMRaXRmyJX
	 5bx8jQFhrdSWW9v4dz7QyL4MTbJAVwrn5EuGXOxMhnGhbkvPRSKoqampDecwvAxscK
	 6AETFPvEL9yKR1Gs/VIssl+HfTCXF3ADuL44bLswWLevmUVikaiExFyFJ0dLiRrDaN
	 nu6uRCOUHmKRTI4EyUgl8TSdWzhS8FwpLB7OooKkpHXZjDk5eIpmzaq59aBjhi6FYT
	 vydu5mdidB5XcT84y7AtI6tGbVLCL5FM3dZZiBfOuBFP3XuVkIeh4fV/4GwZY3sU8v
	 juAJK6CBqxNeg==
Date: Wed, 23 Sep 2026 19:30:31 +0200
From: Gao Xiang <xiang@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wenwu Hou <hwenwur@gmail.com>, sashal@kernel.org,
	stable@vger.kernel.org, xiang@kernel.org, chao@kernel.org,
	zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com,
	lihongbo22@huawei.com, guochunhai@vivo.com, yinxin.x@bytedance.com,
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH stable] erofs: fix large folio race in
 erofs_fscache_req_complete
Message-ID: <arQMt6-Kuc_TwHeT@MacBookPro.fritz.box>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Wenwu Hou <hwenwur@gmail.com>, sashal@kernel.org,
	stable@vger.kernel.org, xiang@kernel.org, chao@kernel.org,
	zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com,
	lihongbo22@huawei.com, guochunhai@vivo.com, yinxin.x@bytedance.com,
	linux-erofs@lists.ozlabs.org
References: <20260923084823.496741-1-hwenwur@gmail.com>
 <2026092320-process-federal-6533@gregkh>
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
In-Reply-To: <2026092320-process-federal-6533@gregkh>

Hi Greg,

On Wed, Sep 23, 2026 at 11:30:44AM +0200, Greg KH wrote:
> On Wed, Sep 23, 2026 at 04:48:23PM +0800, Wenwu Hou wrote:
> > This patch is for stable only. Commit c37460cd9b2fc ("erofs: remove fscache
> > backend entirely") upstream removed this code.
> 
> We need an ack/review from the maintainers of this code.  And if it's
> removed in newer kernels, why not do the same thing here too?

I hope the old kernels could still support fscache since some important
enterprise users (e.g. xiaomi) are still using "erofs over fscache" with
old kernels for their containers and they still need some time to
switch to the new way "erofs + fanotify" with newer kernels.

The patch looks good to me, for such simple stability fscache fixes,
I hope the fix could be landed into stable kernels:

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h

