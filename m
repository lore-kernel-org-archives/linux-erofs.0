Return-Path: <linux-erofs+bounces-4419-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A76C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 11:55:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZh5915lvz2xmh;
	Wed, 02 Sep 2026 21:55:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=202.12.124.151
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788350157;
	cv=none; b=Mf5TLFGo+639OJzoeDSmZ4stlCe8fF/eQRtGeeDUmdsXdAQu+VX0770zA7lH9lPPiYBIRlSsgz15OZz3j2UsH+vDxMmSt4gIvqKT4ttcbA+NrgtryAMfiOQNehp+/bYBUjCdQS2LLvBOl8z8LZICKbkzEA+A+hCDQJJUOR57kQRBr0f+gjsRfjKDQlHsonH4bNqN4JKQDGG7xihHh+NXrt0LvUl3X/r+2uY/YxNaleSXaPteqjgbOZHOXKBaRyITZzHP+RNH4ooBmV8z8HEqaRdLqT5qDBvz4KDh233VBoeZJUhS0FBSesn2ZGE2MZe17vx5WJpzC3s9U0nnsl4mxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788350157; c=relaxed/relaxed;
	bh=T8Ta5dWC3iBQKIe7qAuLecVMVEjIkycgwE+Mr3w9bDo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzcN0CUwN/xmfULaTLn573NGV6Zo0ByqQtzX7Hy0yZrhQ7IdParaweK50rww2IpBahVHliQaQo2xKUxJBlcXeJ6ifxrlPCxM20wY4OYXW6e1+QEM44GLoUNrIUk0GokgsRU8kTtjwwCYVsGLF6ABJscri1x4kHjj56WcUPJP2XR7i4e8wFnhfrfEzHA1yeIsPbyZR7z1kRNJXsx83P/L3L5dTV/YlcZSGeDrD9xJ26FR+KLbuhAx8gXzqbNmEZO1QZho8QprnPqEUSwr0r19bByHel2yxEm3oUVSC7Fj9jnjuJYNm6Kp/yJwKFFMaF8usaPsR51yTQB1mGVY2DL7OA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=kroah.com; dkim=pass (2048-bit key; unprotected) header.d=kroah.com header.i=@kroah.com header.a=rsa-sha256 header.s=fm1 header.b=ra9H0Yvc; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=CoezHoSo; dkim-atps=neutral; spf=pass (client-ip=202.12.124.151; helo=fout-b8-smtp.messagingengine.com; envelope-from=greg@kroah.com; receiver=lists.ozlabs.org) smtp.mailfrom=kroah.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kroah.com header.i=@kroah.com header.a=rsa-sha256 header.s=fm1 header.b=ra9H0Yvc;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=CoezHoSo;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kroah.com (client-ip=202.12.124.151; helo=fout-b8-smtp.messagingengine.com; envelope-from=greg@kroah.com; receiver=lists.ozlabs.org)
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZh5773Vjz2xLd
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 21:55:55 +1000 (AEST)
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id CF8BC1D000D6;
	Wed,  2 Sep 2026 07:55:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 02 Sep 2026 07:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788350152; x=1788436552; bh=T8Ta5dWC3i
	BQKIe7qAuLecVMVEjIkycgwE+Mr3w9bDo=; b=ra9H0Yvc06w8a4i2Mr9PN+fn6A
	5/f71qutVXClxp8cj/DQrWjSGdNyN0GJ1AgahqpDaeIwDFFUXqTbPl/xyzUBixiS
	pC/8kQqs6ogixbMC1YEPqNtWmrquW3kKIPmeEg0D+kxOMmV81WxJVHRDSXLzUfXa
	X381eos3ezytpkdkdrJeuUdyzIZCSc+mAjzXaVB3NKNRbxzV/BvZl+jgaJtZtNLZ
	eyj2VhzRKiIzNbtT1fhfzRflo1sE9AF2UGNpmHYiCYRKwWHfbb37QMOiIjKalx/V
	soa+ikfy6xgXbrqnkQiNXGtCwPitLtAqMq4LyjjsaZrnIfwh4Gge5c1dw5Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788350152; x=1788436552; bh=T8Ta5dWC3iBQKIe7qAuLecVMVEjIkycgwE+
	Mr3w9bDo=; b=CoezHoSoD19NrdrpilCXpNReX7RE96MFFFphDn4XWH5dS5QZ89C
	hNqacLnh32Ub4mKnXK5tbPLsxGkWAm6lDSuz7pGcdhq6J7fF5ns8Gg+IgwvbLEm/
	4AWQC5NmZpXhbEp8PzIBChDCjXmsJEZ4Xlo0jMCKDFzz0ZX0ci83hFXABZe1Klqf
	qgM9frxjGNRVUFDolE5feaUOUv/vPMk2VOjjPxJUPpCE3kmXkXnDVgg2jK9bvsOD
	q2FgFYtQTrNdXYMIOOZqF6+VZVFZvvnz48DHvx4X5Z7LxHdYF2ZI/e7Og4K0zqBb
	TOuDl4jq4og2SbZVpdla34llsOJAPKwBYCQ==
X-ME-Sender: <xms:yA6YavaUMuF3aTBncCSjFYNIFWb7KxQb7VVygQN4ZthXEQK4mKvjWQ>
    <xme:yA6Yajm4pivoUPPvBSM4wjKobq3p-7bwWvkEJVK2aAfNjTvLup7Z28psPY1BACnSO
    mmNGIzMkc8SkIrFA6S0r0L_x5t5DTfb3nOehxYPWyib5pZpAg>
X-ME-Received: <xmr:yA6YalUudsE68TE07Rj_x6kAYehz1dZSOi9NXCrzNSEji021mZTIHMgjjLPOgJmnVAbWTX9iZUosAFC0RBDAWteVGQGzZ1JMnJa5IBbFJJk>
X-ME-Proxy-Cause: dmFkZTFe488197dB6Kik+J0Fs7xaGaBq5nNfTkYsjiWm9HfNozAMDVGdAgxUgOIiADB8Ll
    CHhgKEkZSuR1+dCHfrf0f20PU4fd+cYta99XPtep9/mBv9tqyy0VkUrCWj6pQcI/cNFo7C
    gs3JGCFUPhZ9h4WOluGPu/wrrzh4J/LGGMGfqnlyNNgyazV+QgUSUBfChGTlqa7ZM37zco
    2fgefX2SQV94ZqSd72WCc6NudRzhoJlZQ6QMMN1KlOZ0SfaWQeZGcqibcG9LdHSH143J4r
    3sm5gLtJX+puYCqsUh9gGVMGRQYv3jVnuNqo99bW6sJOPqR3BODxE6UmZCNy+KX1hkf3Zz
    W8JmuXTectD6FjtDckpY8DK7HKlgcXqQ3p3JQRR4POTnMNtkKg8sUh/acwNe0pgw6TL+un
    gMmXzpbOhOvQliQBudC/lNWxKWB0nlWugR0xI6iUYjuNyevu1iiv5uKQ4cSReUtcSZo5vI
    duNC0EPxawBJ9ADrt42y/+MvWGw9CjXWGJXLroEFW7AwzEVgQSpaIZF2lynoFRGPDxxcmZ
    R+ZtzoMBE4IgZcexAEyrtqOKHCSR0C24vb1Vsqv97K3i2qM+BPpRsl9CIxe3RClpeFEj6J
    yjN3b+u+lHVse6bmVg/3i4cCoS5E7lNmPQ/iJUSlFivzHFGMMSZ80wACj+4w
X-ME-Proxy: <xmx:yA6YalJXbJcQ8Hw2U3s7TeOp9t3bIg4PoMtGKCre9OADACUUqe5hhA>
    <xmx:yA6YalttqE3fwQoIwpYoe8MiPorA046m5b3G9ocPq_940y0RhPx6EQ>
    <xmx:yA6Yaq3Rul0ox9wyG3RuMzSgQtYT8gG_KqfE-OieM8HZgLgDI6vvxQ>
    <xmx:yA6YatNFJFUFLGyXBL9O4vTJChbmrD-MoQxCScChJO_XORiejELPNg>
    <xmx:yA6Yaknp1r1vYNNpzbMna-fqvzvzGYVwoyi1c0el68GjgPsHbsg2QbRX>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 07:55:52 -0400 (EDT)
Date: Wed, 2 Sep 2026 13:54:08 +0200
From: Greg KH <greg@kroah.com>
To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] erofs: add sysfs feature entry for xattr prefixes
Message-ID: <2026090258-zealous-oyster-2874@gregkh>
References: <20260902015039.54190-1-jefflexu@linux.alibaba.com>
 <2026090256-impart-headstand-7d29@gregkh>
 <apgAHPzvGe4bEPJx@XiangdeMacBook-Pro.local>
 <2026090249-rework-vividly-5abb@gregkh>
 <apgLrJqst_kGUq1D@XiangdeMacBook-Pro.local>
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
In-Reply-To: <apgLrJqst_kGUq1D@XiangdeMacBook-Pro.local>

On Wed, Sep 02, 2026 at 07:42:36PM +0800, Gao Xiang wrote:
> On Wed, Sep 02, 2026 at 01:38:16PM +0200, Greg KH wrote:
> > On Wed, Sep 02, 2026 at 06:53:16PM +0800, Gao Xiang wrote:
> > > Hi Greg,
> > > 
> > > On Wed, Sep 02, 2026 at 07:36:13AM +0200, Greg KH wrote:
> > > > On Wed, Sep 02, 2026 at 09:50:39AM +0800, Jingbo Xu wrote:
> > > > > Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
> > > > > supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.
> > > > > 
> > > > > Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
> > > > > Cc: <stable@vger.kernel.org> # 6.4+
> > > > > Reviewed-by: Gao Xiang <xiang@kernel.org>
> > > > > Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> > > > > ---
> > > > > changes since v2:
> > > > > - add Reviewed-by tag (Gao Xiang)
> > > > > - update list in Documentation/ABI/testing/sysfs-fs-erofs
> > > > > (https://sashiko.dev/#/patchset/20260901062243.109172-1-jefflexu%40linux.alibaba.com)
> > > > > ---
> > > > >  Documentation/ABI/testing/sysfs-fs-erofs | 2 +-
> > > > >  fs/erofs/sysfs.c                         | 2 ++
> > > > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > Why is adding a new feature a stable thing?
> > > 
> > > It's not a new feature (Also, this patch has 3 lines diff):
> > > This is a bugfix to address the missing part of
> > > commit 6a318ccd7e08 ("erofs: enable long extended
> > > attribute name prefixes"") since every on-disk features
> > > should be shown in `/sys/fs/erofs/features/*` according to
> > > the definition of:
> > > 
> > > What:           /sys/fs/erofs/features/
> > > Date:           November 2021
> > > Contact:        "Huang Jianan" <huangjianan@oppo.com>
> > > Description:    Shows all enabled kernel features.
> > > ...
> > > 
> > > IOWs, this sysfs entry should be part of commit 6a318ccd7e08
> > > to indicate this feature is supported since Linux 6.4+
> > 
> > Ok, but as this has not been present for a very long time, did anyone
> > even notice and need this now in stable kernels?  :)
> 
> I think Jingbo needs it (btw, I'm no longer in Alibaba Cloud
> anymore).
> 
> Also it would be better to port this into stable kernels so
> that users can get the supported on-disk features in a more
> unique obvious way.

Ok, that makes more sense, sorry for the noise!

greg k-h

