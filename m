Return-Path: <linux-erofs+bounces-4094-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD274C55182
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 23:14:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDXYz4kQYz306N;
	Tue, 04 Aug 2026 09:14:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785798871;
	cv=none; b=N2LrVy1znzKvRumdYW5kY/vLnEIXBHnIeqUCJmbaf0GnnuqDScay+7AWrwRF7XeNMUSyAQoCJ9V9HkQNSKtwHVmKHux6+V8ebkmgldQlTGX2HXX9N5JJJzmRCRQbSIgfEFBzAs9CVK1xS2JWPSlaymcV/awGwT3ashGxFK3KRdsTDABPP0FhEc4tIDIORTKJUqkQE3Do+yrWphXpi8hg92yHKfsbwkqAkz1Mgo8E7BISuWsITIlOXbjr808dCdrm5xWsIjTYlyze4YCv4Uh/cWrBUFoP7lwZgNYeZ5iw6vyJJtCN7BJiXwYuFP0gkanUhThO8JAEkkjbsQNFKpkrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785798871; c=relaxed/relaxed;
	bh=YLvIUDXY7mxxoHFW0PZDy5RY4AXjiXB542Tx7kT3d+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nY4oCpx3rkQ49Uz55Gu8AUT3x8Sv3qwH81bwQGVvtC70aCeR3FnKsu9p03UsK9UXMrfiLKQUqJHzpw2qrieynjXVkaL+ttpA5Qg+Lz04hA/t9ymCmdTu/+N2yvL+YTULEgCFpT0CTT2RNe7nDjdhVlaUoP4HUVTQsGW/1H9584AgtF6WsUUuN73nsC7RjYiDQwKSIIqpVSh6Dwn2/vi01KX+DrhUMNiuZsKM8lZPqzmLVyr+I+7GBnkmlp/nGHT5y2bIe5REeUPONLuOd9WSXu66MdMtVsXv7hLO601ZtKvyX9ZBddVVYdhq4HHdnSjFZUhCuz9exLKqobn25dj5Jw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNe5kHIW; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNe5kHIW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDXYx5D7bz2yWK
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 09:14:29 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7168D60A69;
	Mon,  3 Aug 2026 23:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415A81F00A3A;
	Mon,  3 Aug 2026 23:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798866;
	bh=YLvIUDXY7mxxoHFW0PZDy5RY4AXjiXB542Tx7kT3d+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VNe5kHIWmpaxizxOPHWZZQnubSSZNVke7dWWlHgVht956vW/L7M+ZcX1lFaV1Xfwh
	 Cf+JcxH0Th7ESw/dWpm05pI9SPP4ViIJqA9Ii9il1k9sA0j2CXO51kTJHCwnevQiQK
	 DEShTV7xirj3E2sSargEkBs3YFwvga5SyIpCPxPMc6GUngmg3yUw5dM4UIdkqUxzrf
	 KmCXqERrGPXsL76p55pJ2TJ4zPK9xOyTWtRL6T/jtgcMAAxP1xfm5sg6g/LG3EXKyf
	 mQkwWAe+KnxkbwH1vRaJlqOkL15ggUYOpxINPdCKrURBKDG+l0QfosyjOXjrTYRr40
	 0dE0BvvAhS2Mw==
Date: Tue, 4 Aug 2026 07:14:20 +0800
From: Gao Xiang <xiang@kernel.org>
To: Martin Pitt <martin@piware.de>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
Subject: Re: [PATCH] erofs-utils: mkfs: emit an inode's xattrs in a canonical
 order
Message-ID: <anEgzI65bTzw4mn9@XiangdeMacBook-Pro.local>
Mail-Followup-To: Martin Pitt <martin@piware.de>,
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
References: <ampZ6MVV1nN3YzQ_@piware.de>
 <am9FM_v9vAAzlR5H@XiangdeMacBook-Pro.local>
 <am9GZFlgLYn9HFci@XiangdeMacBook-Pro.local>
 <anCAMSZK9ow3eGQD@piware.de>
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
In-Reply-To: <anCAMSZK9ow3eGQD@piware.de>

Hi Martin,

On Mon, Aug 03, 2026 at 01:49:05PM +0200, Martin Pitt wrote:
> Hello Gao,
> 
> Gao Xiang [2026-08-02 21:30 +0800]:
> > > Thanks for the patch!
> > > 
> > > I wonder if the following diff works too (but untested):
> > > 
> > > Since I'd like to unify comp_shared_xattritem, if yes, could you resend
> > > a new version (or if some bug happens) as this so I could merge this.
> > > 
> > 
> > Sorry... It should be 
> 
> That's a nice idea, thanks!
> 
> > diff --git a/lib/xattr.c b/lib/xattr.c
> > index a9486e4..6a8775b 100644
> > --- a/lib/xattr.c
> > +++ b/lib/xattr.c
> > @@ -400,17 +400,44 @@ static struct erofs_xattritem *erofs_get_selabel_xattr(struct erofs_sb_info *sbi
> >  	return NULL;
> >  }
> >  
> > +static int erofs_comp_xattritem(const void *a, const void *b)
> > +{
> > [...]
> > +	ret = memcmp(ia->kvbuf, ib->kvbuf, min(la, lb));
> > +	if (ret != 0)
> > +		return ret;
> > +	return cmpsgn(la, lb);
> 
> This actually fixes the already existing sorting on main, too: The previous
> `la > lb` never returned -1, so the sorting was half-broken.

Yes..

> 
> > +	 * Keep each inode's xattrs ordered by name.  listxattr(2) makes no
> > +	 * promise about the order it reports, and tmpfs varies it from inode
> > +	 * to inode, so appending in listing order would emit the same set of
> > +	 * xattrs differently from run to run and make images unreproducible.
> > +	 */
> > +	list_for_each_entry(pos, hlist, list)
> > +		if (erofs_comp_xattritem(item, pos->item) < 0)
> 
> The items need &, otherwise it reinterprets the first 8 bytes of struct
> erofs_xattritem, and you get bogus results. I fixed that.
> 
> There is a plot twist: Last week, when I investigated that and wrote the
> reproducer, I was still on Fedora 44's 7.1.4 kernel, and the reproducer
> reliably failed. Now I updated to 7.1.5, and it passes. This is probably the
> effect of https://lkml.iu.edu/2602.2/00479.html and/or
> https://lkml.org/lkml/2026/2/27/1141 , but it might explain why you may not
> have seen the result. Funny timing! In other words, with recent kernels
> tmpfs now reports the xattrs in insertion order instead of random.
> 
> But it still differs between running on *different* file systems, so the
> justification stands, just the reproducer changed. I changed it to accept a set
> of directories, defaulting to /tmp (which is usually tmpfs on modern distros)
> and /var/tmp (which ought to be disk-backed, btrfs in my case). With the fix,
> the erofs image comes out identical in both cases, while it differed between
> backing file systems even on 7.1.5 (just that *within* the tmpfs runs it is
> stable now). I also updated it to set 10 xattrs instead of 3, for more
> confidence.

I think we need to add a formal xattr reproducible testcase to
experimental-tests branch.  If you have time you could help add one
to ensure the order; or I could also find time too.

Thanks,
Gao Xiang

