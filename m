Return-Path: <linux-erofs+bounces-2310-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D838CEE3698
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Feb 2026 17:21:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fBhtP3GGcz2yFm;
	Fri, 13 Feb 2026 04:21:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770916909;
	cv=none; b=bPrVB3emdUPiTVyIV8xZNMm/kR2/yAxZB+UXbVFBDwyNPpvCvOH4fnhY3MP6YkmYy9N1GA7dZxf+/EvPzeoSzBs/72qOBOOameKS6UdyFvVwWvdShUSIqqAOo6QJxUYUrAdYUVD1L6vRqx99U67N2BTm/XIIZJ8kKd3U/RdRfRUJxN+rKU+zrCY2AD0TpGp1pbbSSBMBH9MlPWCMoD8ey4a7v7yt2ixvmF3CFStIk4ek7CzFe69vYtNJIqddHV5s2RiBS0MGOKV+qcIZkvJTP7j+yGbRut4CKu+LDxxqZ2tI2mVN3Mj17bl5IVCVi9FQEk8gkA2BzgYFUfSdhlpIuA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770916909; c=relaxed/relaxed;
	bh=9Aa4rbmlYiVI89s111f1jx2XKdUKvK9ff9PwMORVJl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BuOKrYgLxa21oQ28gUCyKF8sFZ17MoQg2I6rBcYzOoC5Se1trd/5s9HYpNCM+WwJloz6+6FzPH36Zj4JAVu6fHz+/aR+iixbm6GHYxtuEkTPjzuWMthDrXzDRDj61isp2cm02YONNK9ZF2epRPFRuNm17BAlEIUmqfeqgBSF+wgifUd+88VSJwNpqyVwMcHPn0nMoRJD3zCdT8zXn37m2VBiDRYESjswY2RxW/TCAqWwVY9e8z0M9a752UGTYXqHCCUiiBoDo1xcdNe7ujexWqTfKP+0cTxRde6VrXP9zyfhWTEXqLaDkfBxIyHgLvYkd84egMvELafKUt9RH3LgSw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=trwa7FgV; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=trwa7FgV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fBhtN4Gjyz2xHX
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Feb 2026 04:21:48 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B66660010;
	Thu, 12 Feb 2026 17:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4FAC4CEF7;
	Thu, 12 Feb 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770916905;
	bh=+Ia4sKtMBVo0Lo80nCC0DmJXxbEo2VmVxUBLFeek+FU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=trwa7FgVIfn+ncghIremtGkGI8luAKwpHInWG3pCGGgHevrgDC/zY95Gd77xAVTit
	 lHmuHZrN98/50TSmrjkQoyzK7diGKFinFiqTbMFu+2k8StebrFBnWjFdbrZMJ/Z60c
	 KWnKCUxxhFLFoLA7jcuqcOtwJExwG4nH2i798PblwiyPDvxPgnAccOw0gXu+huxbJq
	 U/FsEAoTYGve8eD+jqO4w3+30FxWdIajp0OxqSQGzKW5nXXcfSD7pA2iLzQDR0TzYt
	 SppOUCQpQwD26/+x6mhFMwvFUuCZIWQ0jpPv/YiL05CUFfB6luhgBZU+7974d7qhY+
	 6BMiJBWU0PcaA==
Date: Fri, 13 Feb 2026 01:21:40 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jonathan Calmels <jcalmels@nvidia.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH] erofs-utils: lib: relax erofs_write_device_table()
 device table check
Message-ID: <aY4MJG_lHXy-bxWd@debian>
Mail-Followup-To: Jonathan Calmels <jcalmels@nvidia.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260212001302.72193-2-jcalmels@nvidia.com>
 <a4712179-0675-464d-8991-301e260f15bb@linux.alibaba.com>
 <aY4EXe96VKXsCb8R@nvidia.com>
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
In-Reply-To: <aY4EXe96VKXsCb8R@nvidia.com>

On Thu, Feb 12, 2026 at 09:00:18AM -0800, Jonathan Calmels wrote:
> On Thu, Feb 12, 2026 at 05:13:31PM +0800, Gao Xiang wrote:
> > External email: Use caution opening links or attachments
> > 
> > Thanks for the patch, could you elaborate how to use this?

...

> 
> I'm relying on the library not the CLI, I think the equivalent would be:
> 
> mkfs.erofs -Efragments,noinline_data,ztailpacking a.erofs a/
> mkfs.erofs -Efragments,noinline_data,ztailpacking b.erofs b/
> mkfs.erofs merged.erofs a.erofs b.erofs
> mkfs.erofs --incremental=data merged.erofs c/

Could you document this in the commit message?

I think it makes sense, also lacks of `-z`
if `-Efragments` is specified.

> 
> > > diff --git a/lib/super.c b/lib/super.c
> > > index a203f96..d38396f 100644
> > > --- a/lib/super.c
> > > +++ b/lib/super.c
> > > @@ -392,7 +392,7 @@ int erofs_write_device_table(struct erofs_sb_info *sbi)
> > >       if (!sbi->extra_devices)
> > >               goto out;
> > >       if (!bh)
> > > -             return -EINVAL;
> > > +             goto out;


How about updating to the following instead for now?

        if (!sbi->extra_devices)
                goto out;
-       if (!bh)
+       if (!bh) {
+               if (erofs_sb_has_device_table(sbi))
+                       return 0;
                return -EINVAL;
+       }

        pos = erofs_btell(bh, false);
        if (pos == NULL_ADDR_UL) {


Thanks,
Gao Xiang

> > > 
> > >       pos = erofs_btell(bh, false);
> > >       if (pos == EROFS_NULL_ADDR) {
> > 

