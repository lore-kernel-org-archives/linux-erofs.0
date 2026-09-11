Return-Path: <linux-erofs+bounces-4542-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF912C88E4A
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 10:33:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh9r173Tfz2yFj;
	Fri, 11 Sep 2026 20:33:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789122817;
	cv=none; b=Bg+Scn+km3/MeDms+vfxzj4vg3Sq31vugCsWWSBQCHOKNgaxcYvEKTswklXG/JhDrQTAt8nZIeE4/pUIheggDjCqWpkruoG5LkBVSAu6/eAX64WhGwk94XI9ATmHaojR4RJrTeA5Lq6ba0NiWxDQnVHwudamnXRjrVcXrCYY0aDVcQzCY5Lz3h0v0H6lMQ0OWxZ/ML5EGmf0hc5MWPiSVccifU28Vzsr2X7jUe+HGw8xwo5sKyUUk74TRCeL6UXZ6c1uroJI+WRIlITv73jsMSClUg2+hwBT+OthsYPeZoxX/IDUqsVR3BT5w02E+q2b76cr5kajPEguGhBcnRkn/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789122817; c=relaxed/relaxed;
	bh=sr+9J/UL+VXa6NRwiQbwbcxbJO5zN32zS4Yo68Xd5e4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=En7OFqSgXksKWapzYP+ks5DJU+pRnYz6EFFvv3KXLw1RAvZCx8xzriG0MhTR1rfRolFD32/HnIOVIA/Sk8rRF2F9dvIWWipGJQZLGTHSQYfe8vK/zavVdk2QGFiHwUE/EPP9K6RP8FBiJjeY0ViD5EdnXEgjSIOwgu0IZOFCfaWijAEsdHMUNKI/zUWZkdyRQ5sIp9mkrCFkungy/XR0fMxqGUBkM0P/+3ROGB6NJwdIw43f9l1gSKP+mhS1iC3Tl605bhSPOI13KtjHXg1bM6C+DSsVvuukFGLGvckLta9zO0t612lERqQbIS3wR0+SmzkWzA88tPV4kQ1NIJ6YAw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oz2zE3mc; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oz2zE3mc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh9r12JZWz2xpv
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 20:33:37 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BF0443534;
	Fri, 11 Sep 2026 10:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B21F000FF;
	Fri, 11 Sep 2026 10:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789122815;
	bh=sr+9J/UL+VXa6NRwiQbwbcxbJO5zN32zS4Yo68Xd5e4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oz2zE3mccR0sZyn/jATmc/AYL1KLiLhBbmt5S77+SMEma8SP7g2ZHM7/lrD4tc+S3
	 NSD1mlYH/0ywhBVAtXRgK2jPc9Qv0u3Hs+v0BXruN726R+Gm7tWlBnqkiROe1dLGtk
	 Y03AlCimCf+Tc11Yc3LC2bGGQow+4rYxGBZ20DboOtsuisfR4DuC9iz6grF8ypbn7P
	 TEg9TRo9LcX+x3AAE/4IcvYNSQW8bkO4Vu5fvQ7BpyejaQusdioAZBg4/MmZZAeCK7
	 k/mHctVwTs5BSEnl/7yoX4sjd5w5d8YaPK0D0HnyMdc9UuGmOnbq42c2J2ya+R8mBJ
	 gM+KWEF6XSzvA==
Date: Fri, 11 Sep 2026 18:33:30 +0800
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <yifan.yfzhao@foxmail.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v2 1/2] erofs-utils: mkfs: defer compressed metadata
 generation
Message-ID: <aqPY-mqxmuZcugRb@XiangdeMacBook-Pro.local>
Mail-Followup-To: Yifan Zhao <yifan.yfzhao@foxmail.com>,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260911035917.161686-1-xiang@kernel.org>
 <tencent_56C5B5ED8833DCAB79CB06F495CF93AE5808@qq.com>
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
In-Reply-To: <tencent_56C5B5ED8833DCAB79CB06F495CF93AE5808@qq.com>

Hi Yifan,

On Fri, Sep 11, 2026 at 04:35:37PM +0800, Yifan Zhao wrote:
> 
> On 11/9/26 11:59, Gao Xiang wrote:
> > Generally, unique addresses should be assigned after the size of
> > the primary device is decided.
> > 
> > Defer compressed metadata generation until after
> > erofs_update_all_devices().  This is used to support multi-device
> > compressed filesystems (including fsmerge support for compressed
> > images.)
> > 
> > Signed-off-by: Gao Xiang <xiang@kernel.org>
> > ---

...

> > +			++nexts;
> >   		}
> > -		++nexts;
> > +		inode->z_extents = nexts;
> Hi Xiang,
> 
> I think this line seems redundant as `z_extents` is not used with encoded
> extents disabled.

I've addressed most of your comments, except above.
Since it's no harm to leave a valid number here and it can be used
later if needed.

Thanks,
Gao Xiang

