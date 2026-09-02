Return-Path: <linux-erofs+bounces-4418-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF675C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 11:42:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZgp30mQTz2xyl;
	Wed, 02 Sep 2026 21:42:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788349371;
	cv=none; b=TjIpromkgEkN7cQTs+xIrEwkx3uryGZ6MN1dEspgOkSPxdR/3Y2w845LmTWC5+DAwmkQ+CvLQxIwu05xlCG3X9mo1wJOtAYS+VDwn2MduCKbd0MYax4mxEKXPK2oUigWmjGjCdzZUGdE2JBUYfOmfePGdfYCyPu8MWQXy15d8nXoGhdT8/KSIUryOdeq9lfIjAHXjkPAfCcl7wTZBeVHg+ZAaD0wUH8FAyxS8Ljex8fmLiybzike+akx/nEjyDANWaD3vEfWygIAt8KMts715qLID4Ti/2SBH60QoUVJnpT8hyyYsQAU8V+8Y0Y08m0cdd0iknfcu0BL/blNCGM6BA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788349371; c=relaxed/relaxed;
	bh=cFFPJ4hUOzzDlJRQ41DwpLzXzqerXelk+5anGyTnowc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVXMgc/iLsPghCdNF7DhP20kB1PT/TBmXm+o+b49uR1EAbKxaMvtw5fh0jCE4cCutNt8JCIErlvbn25dU+KHfvk8ZtjO3rsgdiFi1FibYW9SZKXh8OqpyO1iwyUQyfjjToXEBlLYe82hT8jwQ+fG7Bvl+sKT8Gpds1F/uWJJ/JbKJVW4Bs8XDXajtSpU6NsjQijPzbn64aShq0rUyLSWRlTvoWt2BH0xYtW2llR3qJkC3R+JB17Te6d/yObnAX6m5v9FZGsBskBTCJ0aHjo3fk+Rp/JkxKPQKBf9Fau+T5saicduEgXol/CK6WYnRuNxlxCMimVMKP2VsoFeQqq9Bw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UFtbLdlB; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UFtbLdlB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZgp23Y3Gz2xpn
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 21:42:50 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B350B404C2;
	Wed,  2 Sep 2026 11:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A051F000E9;
	Wed,  2 Sep 2026 11:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788349367;
	bh=cFFPJ4hUOzzDlJRQ41DwpLzXzqerXelk+5anGyTnowc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UFtbLdlBlM7WFQSqLSMx8+G0ECZNG+Be0uAM9IlweuG2hYWsKyA4j+qR0N/5Bby7z
	 HLgCBNH5fVk4VklCspvFJi1JsBmwiVhP4kvM5E0+9XDmwJlMzYz6lpe6b7hwzYvGJ9
	 bzNjDnk2CRifv45QmtsHP2sqQA4ZDtyQXWq+kog4CMq1IZ0socfUmOYcdAliw8fcaU
	 DQpxB6gv+l2RY1T9seDTbDH2gLKEK76ZnQK/g937Tvyg7Ev4BjorPNQQeZ5MZ2Udg1
	 gMQwr1FXxk6SmJyGqA8Ig9p1qhN7DQbHk9oRHk8NzbAXdOt6Ac/PNOYnP0y98Q7JSC
	 mVo2Dpbs5duFQ==
Date: Wed, 2 Sep 2026 19:42:36 +0800
From: Gao Xiang <xiang@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] erofs: add sysfs feature entry for xattr prefixes
Message-ID: <apgLrJqst_kGUq1D@XiangdeMacBook-Pro.local>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260902015039.54190-1-jefflexu@linux.alibaba.com>
 <2026090256-impart-headstand-7d29@gregkh>
 <apgAHPzvGe4bEPJx@XiangdeMacBook-Pro.local>
 <2026090249-rework-vividly-5abb@gregkh>
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
In-Reply-To: <2026090249-rework-vividly-5abb@gregkh>

On Wed, Sep 02, 2026 at 01:38:16PM +0200, Greg KH wrote:
> On Wed, Sep 02, 2026 at 06:53:16PM +0800, Gao Xiang wrote:
> > Hi Greg,
> > 
> > On Wed, Sep 02, 2026 at 07:36:13AM +0200, Greg KH wrote:
> > > On Wed, Sep 02, 2026 at 09:50:39AM +0800, Jingbo Xu wrote:
> > > > Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
> > > > supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.
> > > > 
> > > > Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
> > > > Cc: <stable@vger.kernel.org> # 6.4+
> > > > Reviewed-by: Gao Xiang <xiang@kernel.org>
> > > > Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> > > > ---
> > > > changes since v2:
> > > > - add Reviewed-by tag (Gao Xiang)
> > > > - update list in Documentation/ABI/testing/sysfs-fs-erofs
> > > > (https://sashiko.dev/#/patchset/20260901062243.109172-1-jefflexu%40linux.alibaba.com)
> > > > ---
> > > >  Documentation/ABI/testing/sysfs-fs-erofs | 2 +-
> > > >  fs/erofs/sysfs.c                         | 2 ++
> > > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > Why is adding a new feature a stable thing?
> > 
> > It's not a new feature (Also, this patch has 3 lines diff):
> > This is a bugfix to address the missing part of
> > commit 6a318ccd7e08 ("erofs: enable long extended
> > attribute name prefixes"") since every on-disk features
> > should be shown in `/sys/fs/erofs/features/*` according to
> > the definition of:
> > 
> > What:           /sys/fs/erofs/features/
> > Date:           November 2021
> > Contact:        "Huang Jianan" <huangjianan@oppo.com>
> > Description:    Shows all enabled kernel features.
> > ...
> > 
> > IOWs, this sysfs entry should be part of commit 6a318ccd7e08
> > to indicate this feature is supported since Linux 6.4+
> 
> Ok, but as this has not been present for a very long time, did anyone
> even notice and need this now in stable kernels?  :)

I think Jingbo needs it (btw, I'm no longer in Alibaba Cloud
anymore).

Also it would be better to port this into stable kernels so
that users can get the supported on-disk features in a more
unique obvious way.

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 

