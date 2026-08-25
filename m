Return-Path: <linux-erofs+bounces-4340-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58353C61DB9
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Aug 2026 12:56:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTnq21mtmz2xKh;
	Tue, 25 Aug 2026 22:56:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787662606;
	cv=none; b=fIAkr7LYgC2WTwI2h+E2hc2A7gepkxeovZPyA/kCoxD+e876NdCdPZteunJRS+JDnrPB0kmKQ4MylZWb8mb1SdbAQoMOO3uUYSz1ICAd6wK1xxBExD92PYA0tXMjJbfK+UONWACdNgPWpCJ+V7a5WwVw9fo3em0JMYKUIlZ2CwYIKO3vtjEU8WQf4gwiF0qVGapOGAbqt2hlY/dUfHPzlSlIAuDkoTIOL79IV00piFlod2JWf4fU60fcg7wbWwuJsLW3xMjFO24GGhVcS0c10UHXbZBZCY6yfkg5g1258HXEItT/VQlL4moxzHi/mh6dEgizzrCMoZXQvLn/XTOVhg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787662606; c=relaxed/relaxed;
	bh=z/ovVZcfipLTI7orQj6c9Fnp4FS3AHdc5YjHdm7Y4sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gw7BOfw7Ctny2iTeBnQwZZJbYVgr3n9GE7d0AtiDFD68S+iNB3ZSsc5Ig0VpFkBG0dgfuGELnF347aBuwlU8apZGIPHWNSbcJ+QxqkCYDV7ZK3ITs8zmicjkTQ7TtC6WjTCqNZ/8xzEJgu2Qv+JCRYgUcHD8Eq7sNcJ4Smekzj+JeqF9JU+x0LEp9vGXJw3Lr+8c5HB10YwrCz2hX6YecMAc5RCUlBSatDNcVGDUuOJQqo8+09vqMm3UMwhbakfV7Mk46eoNAaSRWLETp1hwRm2DsfFw7ta4JLkKzFniyuYcSc69zmJfr9i5BzvOo1GzHPVQZybpT+jgRKS4hq8T0g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F0qm2Wca; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F0qm2Wca;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTnq12LTwz2x9g
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 22:56:45 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE1BB6011F;
	Tue, 25 Aug 2026 12:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A7A1F000E9;
	Tue, 25 Aug 2026 12:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662602;
	bh=z/ovVZcfipLTI7orQj6c9Fnp4FS3AHdc5YjHdm7Y4sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F0qm2WcaJCvtSCWXUoM8lXAy9poMyMPGxxdYgnna08NG3W32u2IKXn/z1AIg9a68b
	 97FiLwiXr9Ipi4Z/9vGeqJTbp3k7g+8ZReRnK7fdily9avVJt0yYE2fwc6C1Ep8G3X
	 AND2Hi9wVHYp1FJPlCYYds/CaIrWBwWC9imAfQBDPGzN4n2eIs1oPqIgM3lofBTE7M
	 KrBmLJsuFCAu0wKnVvadYLrRsCYy4MNmtrZyfNLUbagoKZCINmnL3XoSogqnl6kOwV
	 bbM7Mx/RJkB0Rz7Fu0eT9ID3/4jr51IqVRZfwbvIZOQZClz+kMoHMAbPGIUhe/KIcI
	 ZAT25u0umxxyw==
Date: Tue, 25 Aug 2026 20:56:34 +0800
From: Gao Xiang <xiang@kernel.org>
To: Chris Ayoub <cayoub@openai.com>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v2] rebuild: prevent quadratic snapshot merges on wide
 directories
Message-ID: <ao2RAhl25I-H-rTN@192.168.5.19>
Mail-Followup-To: Chris Ayoub <cayoub@openai.com>,
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>
References: <20260810-rebuild-wide-directory-index-v2-1-3a977092b7ea@openai.com>
 <CADh04Ha-okHEq+GbD0hizFVPcxE=aqFbgvJpz550yFBV6wsF7Q@mail.gmail.com>
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
In-Reply-To: <CADh04Ha-okHEq+GbD0hizFVPcxE=aqFbgvJpz550yFBV6wsF7Q@mail.gmail.com>

Hi Chris,

On Mon, Aug 24, 2026 at 02:10:06PM -0700, Chris Ayoub wrote:
> Hi Gao,
> 
> Gentle ping on this v2. Please let me know if any further changes are needed.

Thanks for the patch!

Yes, I don't forget this one, but I am working on another erofs-utils
change too.  I will adapt this patch manually later.

Thanks,
Gao Xiang

> 
> Thanks,
> Chris
> 

