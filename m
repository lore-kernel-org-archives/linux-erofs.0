Return-Path: <linux-erofs+bounces-4420-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207E2C624D3
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 14:24:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZlMz64FFz2xmh;
	Thu, 03 Sep 2026 00:23:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788359039;
	cv=none; b=Bve97jQP0ljkds0jZbSMENYoAXCvAbscv/+Rg349WMr66+k0G2WUQdbdyV2PMaqSNt4MOh0SdP+sCzqfr8tcmoMSxtsWBi5ZoSaV9AYao+WVWbifEUobFQB3FJvo6a9yLEsuZY5/iAEjTlUuLFj1MZKIW3gnLpP65i6617XHuMjoNSd7ZAZv0/LB6ztBQyNyOKrxc7oCopgBsCZK0A3Clus2LDWOK8XjDNnudQb96lwUyV+bdmf1Zz42D1AxTXaVgJAw/I8KrU8FNON9l9YsHKZFkW8MxQRpY4ngGKWLFKKUxRiceLEOcOsnySbk7rknwsX4DYj/mIq6mLtEaugeVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788359039; c=relaxed/relaxed;
	bh=om+MNqUxN/33bSJrKK9AMyB00XG1e22iQta6RdD44JQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hh7tYFHPYRBpFbKT9/15lkfBE3PGyBvK5DteKR/FxFQKsAQaYx3RYknfOjoSqpIKDCgdWTZIfRFqV2tciRzbIaP9cdufRUPHxfo/YPEtUxPLs+Q6PG5k70Jdv0A2zCMUJQBdUgxmJ5+bryNOcOYAlICVN3YnxHlFEuHyudoS9xRzexPcqptwYGF5tO2y7iBuCRrdDOcyjxnjMtXgTul9BiPFC+PymWijkAMVVJ+Hf+IjZjSSoNNQ4zzz6u1Ua+bYg4C/v3vAWqhFGzb1HnUG874bBuyYcKi4W8KYymLtCzf8ch8t3mUXTSpQVgXuxRcu7cAvXkDvufgVdDkMp0dp9w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XceFYCkW; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XceFYCkW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZlMv2dKrz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 00:23:55 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFC1A60235;
	Wed,  2 Sep 2026 14:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BACF1F000E9;
	Wed,  2 Sep 2026 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788359030;
	bh=om+MNqUxN/33bSJrKK9AMyB00XG1e22iQta6RdD44JQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XceFYCkWoPM5mKujykC1r/IrtNDtFN0WQaxzjdNmFfANhDxwRkeAcKEJewYRieJg3
	 kPA4Cga/waZkjoc6jRUr/gNroO1z613dWxGub9caE7/GqDCsxP+X3/RBhthdNbkwuw
	 QcrMVTlbUDxrCvTevhdT33+2FZzCTzGhhkIjL4QGDAk/dPC2Gu6FE57h4L8xidnzZm
	 BpH06xE3B16yU2ckhRzKUNKItxFm6rX03lxAIyaygR3KJ8PLZXkJOvJW6JeK1XA8Ad
	 b+KnahFAUM6WT9FjlahU6FcW8BPAbrytgE+8JssV/4Ky31aLeHtoU8EpGqaKzrXnD6
	 ISqYQDjV67IKQ==
Date: Wed, 2 Sep 2026 22:23:39 +0800
From: Gao Xiang <xiang@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] erofs: add sysfs feature entry for xattr prefixes
Message-ID: <apgxa_Lnsg738c5e@XiangdeMacBook-Pro.local>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260902015039.54190-1-jefflexu@linux.alibaba.com>
 <2026090256-impart-headstand-7d29@gregkh>
 <apgAHPzvGe4bEPJx@XiangdeMacBook-Pro.local>
 <2026090249-rework-vividly-5abb@gregkh>
 <apgLrJqst_kGUq1D@XiangdeMacBook-Pro.local>
 <2026090258-zealous-oyster-2874@gregkh>
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
In-Reply-To: <2026090258-zealous-oyster-2874@gregkh>

On Wed, Sep 02, 2026 at 01:54:08PM +0200, Greg KH wrote:
> On Wed, Sep 02, 2026 at 07:42:36PM +0800, Gao Xiang wrote:
> > On Wed, Sep 02, 2026 at 01:38:16PM +0200, Greg KH wrote:
> > > On Wed, Sep 02, 2026 at 06:53:16PM +0800, Gao Xiang wrote:
> > > > Hi Greg,
> > > > 
> > > > On Wed, Sep 02, 2026 at 07:36:13AM +0200, Greg KH wrote:
> > > > > On Wed, Sep 02, 2026 at 09:50:39AM +0800, Jingbo Xu wrote:
> > > > > > Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
> > > > > > supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.
> > > > > > 
> > > > > > Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
> > > > > > Cc: <stable@vger.kernel.org> # 6.4+
> > > > > > Reviewed-by: Gao Xiang <xiang@kernel.org>
> > > > > > Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> > > > > > ---
> > > > > > changes since v2:
> > > > > > - add Reviewed-by tag (Gao Xiang)
> > > > > > - update list in Documentation/ABI/testing/sysfs-fs-erofs
> > > > > > (https://sashiko.dev/#/patchset/20260901062243.109172-1-jefflexu%40linux.alibaba.com)
> > > > > > ---
> > > > > >  Documentation/ABI/testing/sysfs-fs-erofs | 2 +-
> > > > > >  fs/erofs/sysfs.c                         | 2 ++
> > > > > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > Why is adding a new feature a stable thing?
> > > > 
> > > > It's not a new feature (Also, this patch has 3 lines diff):
> > > > This is a bugfix to address the missing part of
> > > > commit 6a318ccd7e08 ("erofs: enable long extended
> > > > attribute name prefixes"") since every on-disk features
> > > > should be shown in `/sys/fs/erofs/features/*` according to
> > > > the definition of:
> > > > 
> > > > What:           /sys/fs/erofs/features/
> > > > Date:           November 2021
> > > > Contact:        "Huang Jianan" <huangjianan@oppo.com>
> > > > Description:    Shows all enabled kernel features.
> > > > ...
> > > > 
> > > > IOWs, this sysfs entry should be part of commit 6a318ccd7e08
> > > > to indicate this feature is supported since Linux 6.4+
> > > 
> > > Ok, but as this has not been present for a very long time, did anyone
> > > even notice and need this now in stable kernels?  :)
> > 
> > I think Jingbo needs it (btw, I'm no longer in Alibaba Cloud
> > anymore).
> > 
> > Also it would be better to port this into stable kernels so
> > that users can get the supported on-disk features in a more
> > unique obvious way.
> 
> Ok, that makes more sense, sorry for the noise!

Thanks for your suggestion and time too!

Thanks,
Gao Xiang

> 
> greg k-h
> 

