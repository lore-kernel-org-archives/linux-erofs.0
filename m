Return-Path: <linux-erofs+bounces-4413-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5C8C61DFD
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 05:41:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZWnN2h4Xz2xyh;
	Wed, 02 Sep 2026 15:41:44 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.168.172.158
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788327704;
	cv=none; b=Ih+c0X96BDjDue/GDh6UPtAop8RBn+90ZG/751wbCI0ouwpB5n2gxI+alrGVo/1ToKPkCxgRe7d0l67jrvGWXfXBPBLCCiKVRs9LRiOWEzo7WUmaB0RQZGqdCoZufCH20iL8wZkMtDYBthB+CjIWVTkrHB391m7+SmpWzjWBAz16ZaoDvYtrBvmU2WeI6IL8/ja238iNTZSTBqQjOu7UV0jSpAQE2elqohH5Wxr6NBZMWKRUOgfkeT3dBxz1Oem4SWVC0ogU66N4dUJs0+/ChmlrfnssDiuhbK0rhlgHEMG7AHdRpF+cqsOC15HQDgce6SjZENvU870rJEx2ONiXEA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788327704; c=relaxed/relaxed;
	bh=PJCI6i7V/wFce8AUhshXMkXSRKsOlbkxU2lQ04jOOs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4dGrAW8pTkO/SBUej9RtRTSdbl++ClHrQBb5/Cgw6hqK8hhpFu5bxwDMiKvyelUyNgvUvPxvXFWKKRQcva8XIT1w/KHZtaOxw+nRdG0Fks7Fw94W3jSzcdHlQNP0I3kmg3u6A6axMk7Fk+orWLHxG0BWfPuu+zhuB8ckDVNKVADNuQOhP6hHG6pRcesQQjQPKXoOOjCHU0ogH9RW/DRy2xDibllzCG0yrxwi2kkTV9elDK04TmqhZN2yJwCC0oFln7TpTsf1yL7EfzmLuZKHRuGklbwHLpJZZAJ27b2lC7qqMhHa0t91JD6UDQncoYfQfFUVHLZu/8v98FeZtBdsQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=kroah.com; dkim=pass (2048-bit key; unprotected) header.d=kroah.com header.i=@kroah.com header.a=rsa-sha256 header.s=fm3 header.b=pOpRn89o; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=WU4ELURF; dkim-atps=neutral; spf=pass (client-ip=103.168.172.158; helo=fhigh-a7-smtp.messagingengine.com; envelope-from=greg@kroah.com; receiver=lists.ozlabs.org) smtp.mailfrom=kroah.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kroah.com header.i=@kroah.com header.a=rsa-sha256 header.s=fm3 header.b=pOpRn89o;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=WU4ELURF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kroah.com (client-ip=103.168.172.158; helo=fhigh-a7-smtp.messagingengine.com; envelope-from=greg@kroah.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 315 seconds by postgrey-1.37 at boromir; Wed, 02 Sep 2026 15:41:37 AEST
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZWnF2jyvz2xmh
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 15:41:37 +1000 (AEST)
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BF42F14000E6;
	Wed,  2 Sep 2026 01:36:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 02 Sep 2026 01:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1788327377; x=1788413777; bh=PJCI6i7V/w
	Fce8AUhshXMkXSRKsOlbkxU2lQ04jOOs0=; b=pOpRn89oKfXMbVB4IHy2XyWZUB
	SHvn+WFG7uVbIGVV4iCmQQp5XCGGRnNwspgGCOdwviasEbsvCReb+jdmJZxwYalr
	oq6cjQLX8KteWzjKbhPJlbfiq4b8ud06v/aOT7H+qfD/KsMTvWjLSOzwFMyr6R8j
	RjXbXKZfIhJYY0iD85OqUDCiRpm4jxbOeBfmLbfK4nkaNXwYIhB8wDXKV1eDlnLd
	A7O5tOOTwz58JRQZ/hVe/iDpZ6fjKFnJc/J0gRVQmF9rjKAohIutoRtK8BeJzoaz
	RU4Q0DMYQVLenjw41HQ4+tz/l7F1Nn1L7VSsAisP6HOmgbuSn036jDnjd+9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788327377; x=1788413777; bh=PJCI6i7V/wFce8AUhshXMkXSRKsOlbkxU2l
	Q04jOOs0=; b=WU4ELURFpJToA+jfFoPcJpdtmGWdajbhjrxGDlcrxrpnc11Cxvt
	YfffoR/OKaLnvSs0PVJNrUnv5pb6Jv1WSkfMElWcmyHITyPeZ9GdVkVrDOdqK08Z
	B95sXSY/H/NuXPCX6p11GqbGDE5kOBFIlt5F84JHFG6AMgQHiTpSkf4j48wicS/9
	oEsINE3HE/dMYx1E1+n9MRoPML1quXefUufLFQy4f4rwKCRDfwYiRcRASm/5K2Vw
	ariUW/aXPGY363DV9dIV0FU8Zz3W4CSezTzGzFU2PCHOkCzuZJNPx+gdY/W+yBZr
	atuL6ULsYt6wMsc9BvXT7TkKIZ0xJkg+FiQ==
X-ME-Sender: <xms:0bWXan-C7rlSvBPoE9pL7Ys_3_1_GyjM4HehYUsn3nPyhZ0ZOtx4gw>
    <xme:0bWXao7xXxPciZdCT2e-OI1v5LHaZy3w7-db8H_2t2rCTlbbwVZCpJsrX8f542KQ-
    cFmlhojVre59NGRzOtkJnxiDcBUnNs-Cm55lHTur3AeM2xtiDA>
X-ME-Received: <xmr:0bWXaob1MWXHgfeYarEmfhDy2G8fT55pPJ0CwR3maWG5VVgwbNtZWEzyCte1XaXtALtcsLCFhpexWe1_cQbuiMSBIP6JVSmDpvb4ffzJmAE>
X-ME-Proxy-Cause: dmFkZTEEY+aIF/abJ1woA5nNoxceSix/Y0lRQ7imY2ry6xzAMDiU2lIIvHIWCZMLc92alb
    N6oIoRf2+ZI9pwQ5IZN420c+clXTXHs9/TYz2SvV+QdrTMz7QquKD0iUpLZc8fMbciqB2I
    8u1sF5xX8FcuA8WfkarGWNEnFQcVM8uIctOhTQIl9WzZF5ZLnogQXm1Rc8IYi34vBgSMg5
    teKpzsNVo65SqiG48iceh8aj9kF22VRaabXaGRL6ZKhvKd8wvMNojnUyOOAozDm1CoBWri
    R3Kd8OrQPR1JZytrxoP/9yUCDQtaHI/pG8iZOLsU/CS4JgHrJ2dvr74+ujKIEPLU62vCa6
    TDM/FmKK9dR4dAocvOSsGKfyiEOMc3BVxVDyY/vZbCx3Kek7/JayJbszeyNbauWG/MQ20G
    kMY0BkF3xO/cneCFTi8/iR+m0xorWwAISUbsYfGDHbCHQ6EStKpRk1AyjR4vh04KUVtPBp
    wJvoeyePwhCeAqdxFt6RGp5913MkkDbrLOqMGEaQLZoQFliE0lKfJ2ovkYRJCNmOcvaDmq
    MIVJxvJg5OGcBNFPfJ8Rcg9avzzrv9wKmbos+e2+F5XhKL3Zwp/jdV/oXqx459GH35f3ya
    7DI0N2EfiNiy+wOZ8WLWkNXX9zkPSGxLXDb8p77Rgkw2nNjqguLT8gWvluUg
X-ME-Proxy: <xmx:0bWXai8tgiJaYkYvj4bi70oICzN9b31RJ71XI2irNRfp8x3ebOy2jA>
    <xmx:0bWXanQK1fF1vTapJKJLHwTcOmiF8Z5PcChRz8UhHwJVjtS5Dkyz1g>
    <xmx:0bWXalIr6tqEoHRIYK1KD0Q_hUhJzKeHaN6zEg5SDfKwvSroeFdbwA>
    <xmx:0bWXahSv8-Zm1e9WIzrNUg_yYFR52WVVdr_HWwTg5oWnLoCPzFgpqw>
    <xmx:0bWXamLHwKxYyDG6VgPNpZ-3dNfVAvnVd7dvMCL2l3XjX_Z7L28hYV1m>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 01:36:16 -0400 (EDT)
Date: Wed, 2 Sep 2026 07:36:13 +0200
From: Greg KH <greg@kroah.com>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] erofs: add sysfs feature entry for xattr prefixes
Message-ID: <2026090256-impart-headstand-7d29@gregkh>
References: <20260902015039.54190-1-jefflexu@linux.alibaba.com>
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
In-Reply-To: <20260902015039.54190-1-jefflexu@linux.alibaba.com>

On Wed, Sep 02, 2026 at 09:50:39AM +0800, Jingbo Xu wrote:
> Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
> supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.
> 
> Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
> Cc: <stable@vger.kernel.org> # 6.4+
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> ---
> changes since v2:
> - add Reviewed-by tag (Gao Xiang)
> - update list in Documentation/ABI/testing/sysfs-fs-erofs
> (https://sashiko.dev/#/patchset/20260901062243.109172-1-jefflexu%40linux.alibaba.com)
> ---
>  Documentation/ABI/testing/sysfs-fs-erofs | 2 +-
>  fs/erofs/sysfs.c                         | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)

Why is adding a new feature a stable thing?

confused,

greg k-h

