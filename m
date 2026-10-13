Return-Path: <linux-erofs+bounces-4726-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CAACCC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 08:16:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3nHD2MBlz30VM;
	Tue, 13 Oct 2026 19:16:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791879400;
	cv=none; b=K0RrQroKnAddipaHct224KENBD/EUjSYaazcpRMH6Ar+ZltscnfYaM1c8lQPhdQ40aKAYXqd0u4pLEQuc4VXDm572M8DjbNYiC/APkAzoX8wwF1vgCCuDRC45YJo649XbGRj94tSNDg+o3a+2unaVfzwNC9AgKzvWsR3oOTIqM4GOaB+LlSJJuG/4fCYHVkjeVSllgckt316w84/jJlvJ2xalC4GTnylXwMRN72+6XQKRpClccrdz4YkCrGE8Xe8eNEbvghRPQUfbBsFbPhgTSb2z/wAI0/qwXZJqT5TK04wlT6f+4QxerolSjjHoyBNtSFxewuXXo6sF9sxM61otw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791879400; c=relaxed/relaxed;
	bh=10xqpOPjo9d02qrdR+y1QjD6wm0apoWOTLYxCcvp86U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWa7tRgCZ11qDzhdqOAIM9n4F/o8EPHsmJhF0RlTbSlqoH0ugZyLj27Ib/ru3EsOzbQa+tzhATCtLsFG53nyISb17O3qAW5jdo01+EfknRACmzygUpbjr+6aInMsDSJ+t9xfFW2UY7ewo+N1NgwCi3AbgemsHb4wB+69qMr0nqZVX0YQvhA3Tk3qcODYPvX95wsxj9NWrXXawmNwZBTDBNV61ygN3yIzazu2KsOwzhnPal8nIQAkQ8ZN05VF5Uqy+BwaQfpM8LoxcyaKXhQ5Um9pOQgX7ssDpExRmjh0f0I3YjZze24Zriz/zNeyIz+u/jPgEM+qzGqDub0Wh8BzHg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AqDbgD7R; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AqDbgD7R;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3nHC2gfSz2yLY
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 19:16:39 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D94B460A66;
	Tue, 13 Oct 2026 08:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69301F000FF;
	Tue, 13 Oct 2026 08:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879396;
	bh=10xqpOPjo9d02qrdR+y1QjD6wm0apoWOTLYxCcvp86U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AqDbgD7RPDZnA8yWlYoCzTaFRLOEfIfXzuIMKlCL0epBr0Q3gbAfflTnYwIztLzRJ
	 1GIASb+SV5fm+Wt6MXY0BlSjWTWYgCjYU6cR5YuG0eJyHI69gxSY70lyorCsP211Xx
	 4ut57CQ/1zfAAnpUaD51OQclSZdWPg5JoTu35UR5W2wJc6escRvVEKOJwduD/6jILN
	 ldUfK5O6TW3PM6fj3iL/ZkdIjm31vtT9H7502xcv3vCGKHJihsf9p7e1XMCwMX8bJh
	 ide58ONFM3JIvdrsvoZbUry/Ff2H9kJrzppM1DZBNC88QSLZfn4gGrjOW0TL1fDahr
	 PuPREpWrFOp7Q==
Date: Tue, 13 Oct 2026 10:16:29 +0200
From: Gao Xiang <xiang@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	stable-commits@vger.kernel.org, xiang@kernel.org,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-erofs@lists.ozlabs.org
Subject: Re: Patch "erofs: remove fscache backend entirely" has been added to
 the 6.18-stable tree
Message-ID: <as3o3Q8X-2gK2HyF@XiangdeMacBook-Pro.local>
Mail-Followup-To: Greg KH <greg@kroah.com>, stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
	xiang@kernel.org, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-erofs@lists.ozlabs.org
References: <20261013020044.2527207-1-sashal@kernel.org>
 <as3drCZLoTUPS_oC@XiangdeMacBook-Pro.local>
 <2026101352-subtract-deflector-a77b@gregkh>
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
In-Reply-To: <2026101352-subtract-deflector-a77b@gregkh>

Hi Greg,

On Tue, Oct 13, 2026 at 09:59:58AM +0200, Greg KH wrote:
> On Tue, Oct 13, 2026 at 09:28:44AM +0200, Gao Xiang wrote:
> > Hi Sasha,
> > 
> > I'm not sure why we need to backport this into stable kernels, as there
> > are users who use EROFS over fscache on these stable kernels.
> > 
> > The functionality works and it's a breaking change.  Could you please
> > kindly tell why?
> 
> Why would you have a breaking change in Linus's tree?  We never break
> existing users, so how was this ever accepted in mainline?

Because the similar + better functionality "erofs over fanotify" is
already available in the recent upstream, and it has simpler interfaces
than "erofs over fscache.", so we don't actually break users as long
as one of those functionalities exist ("erofs over fanotify" or
"erofs over fscache".  Many stable kernels don't support "erofs over
fsnotify", so backport this commit will make existing users using
old stable kernels have no choice (no "erofs over fanotify" nor
"erofs over fscache").

The commit message is already described well I think. 

> 
> As this removal fixes known bugs, isn't that a good thing for those
> older users as well?  Why would you want them to run broken systems?

I think it depends on the importance of the bug, at least "erofs over
fscache" is usable (and it's used by vendors) on stable kernels, but
it's unneeded to address every edge case found by LLMs since I mostly
think it doesn't impact the real use case, and as I said, we have
a new unique interface ("erofs over fanotify") now, but only on very
latest kernels.

Also there could always be breaking changes for various reasons (e.g.
obsolete/dispute filesystem breaking changes these years like
bcachefs, etc), will these commits be backported to all stable kernels
too?

Thanks,
Gao Xiang


>
> thanks,
> 
> greg k-h
> 

