Return-Path: <linux-erofs+bounces-4416-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4335C624D0
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 10:53:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZfj506bCz2xmh;
	Wed, 02 Sep 2026 20:53:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788346408;
	cv=none; b=G+YKrj358nRd1pBLvEx/DHuLA/wj/JK4rguUH7ZrzUDpSqDmEpm1d1rJbWWnUqNoOjJASZena+je1ZvHQwi2UtnMN5u8R4/vU7hFNWLJhXyvkwuUfXg1tINcezQmfPC70CAcKkGhZ22vNiGs1TmkzWuWF8VWNmlOH1xlgtbVSuZyJH0fflJrP7qIjPkyUNFnPs0oZoulsxqjUfkgfZAd9lDHfWAs4cOeVcFr7++/8pqR0yRG8tQa72aHtjtrLIZSVdfq3ErA6EKkd0zh7ZRm+6BGhzHfmmjwxCO9HJqxeTO75Zsmv+cMtNUYLxnCIUP+LU/pLKNSvg8woc5pSGKGOw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788346408; c=relaxed/relaxed;
	bh=PDMuxGaclIhCULVHM63Tu//SkyV5zPfhxAoYuBXM7BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FylPcPxKtVfBWebIJyD3uwqvxE5xfjQ/eKRTGVhK9LJQMMTTkw8tfgX3ZyzTS2PSvNfj8A4+wJyg8/XniJq/Yz8rWXfeFi6gChaePC5QVWQdUtUUgGGEx8fSthL4TS/k+kimSCXFT8lMw2t44mzLsw0xUhVFhb9ZBVdDXvo53x2j9GyOzr/RWpYZXwuT7+B5Oh+a0CiA6FUAnFdCQCp/39683gTs1wzydMpmo1DbgTOxBylcO+YdoX+8zOVk2y0igf6l1C1Yp45NJ6jFx0DlV0+HebIkrnzu2fDdVvRkkWF83ujYoIBY6+uXEXyl5Y5pqn0I35p/tvB4r7qQgR4qEA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O2WBDTT7; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O2WBDTT7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZfj36M93z2xLd
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 20:53:27 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ABCC600D1;
	Wed,  2 Sep 2026 10:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801A91F00A3A;
	Wed,  2 Sep 2026 10:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788346404;
	bh=PDMuxGaclIhCULVHM63Tu//SkyV5zPfhxAoYuBXM7BM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O2WBDTT70K9lE3liIgDZbfk+4SVP46QKijOy8ctdllC6rnUG/W+hH+yzsmtcQ4a+S
	 VIkHDt5iLylXqH4GkUAk5zinW712PvmN4plLvSHMW5nfbHc0U8iXbE810+u71TZhl2
	 jDH69m+LdOuDJAElhG51pVNUT8xkCPqUfD18dlwbnJBU6vDkL0Lp+3mcLiRzLd2pYd
	 SN5uCGwN353CRhkho9AFKqukEbPDRcK6SZzVrc3BzgC/SYrRii1l5MjwrlxWYdrpK5
	 BjFtk2qZpGOKPXKeE5DDm3Wf0YipvHINjp9cSBg/nQRvmmkpYLOE3weIeTctZ9Nev8
	 0DI4Ir3r73Y0g==
Date: Wed, 2 Sep 2026 18:53:16 +0800
From: Gao Xiang <xiang@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] erofs: add sysfs feature entry for xattr prefixes
Message-ID: <apgAHPzvGe4bEPJx@XiangdeMacBook-Pro.local>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260902015039.54190-1-jefflexu@linux.alibaba.com>
 <2026090256-impart-headstand-7d29@gregkh>
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
In-Reply-To: <2026090256-impart-headstand-7d29@gregkh>

Hi Greg,

On Wed, Sep 02, 2026 at 07:36:13AM +0200, Greg KH wrote:
> On Wed, Sep 02, 2026 at 09:50:39AM +0800, Jingbo Xu wrote:
> > Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
> > supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.
> > 
> > Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
> > Cc: <stable@vger.kernel.org> # 6.4+
> > Reviewed-by: Gao Xiang <xiang@kernel.org>
> > Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> > ---
> > changes since v2:
> > - add Reviewed-by tag (Gao Xiang)
> > - update list in Documentation/ABI/testing/sysfs-fs-erofs
> > (https://sashiko.dev/#/patchset/20260901062243.109172-1-jefflexu%40linux.alibaba.com)
> > ---
> >  Documentation/ABI/testing/sysfs-fs-erofs | 2 +-
> >  fs/erofs/sysfs.c                         | 2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> Why is adding a new feature a stable thing?

It's not a new feature (Also, this patch has 3 lines diff):
This is a bugfix to address the missing part of
commit 6a318ccd7e08 ("erofs: enable long extended
attribute name prefixes"") since every on-disk features
should be shown in `/sys/fs/erofs/features/*` according to
the definition of:

What:           /sys/fs/erofs/features/
Date:           November 2021
Contact:        "Huang Jianan" <huangjianan@oppo.com>
Description:    Shows all enabled kernel features.
...

IOWs, this sysfs entry should be part of commit 6a318ccd7e08
to indicate this feature is supported since Linux 6.4+

Thanks,
Gao Xiang

> 
> confused,
> 
> greg k-h
> 

