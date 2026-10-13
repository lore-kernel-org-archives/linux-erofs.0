Return-Path: <linux-erofs+bounces-4732-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40218CC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 11:30:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3sZv3cb1z3brc;
	Tue, 13 Oct 2026 22:30:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791891031;
	cv=none; b=DPtsSBKbodmVzNXv+5wQhvLQ6Qdj7fugKnDiM7iupcK/6KrAO1nhYDv3NW1BjZvQa5G3kHvJcf+54xUKu20AApUBHUmQMyHfbqGEeBCJrqBx3F4xULAmESCPx09Hg78WNa0w8o0EnUyRXd7qDBl16Eh/XQl0TRixBkFaGT/J2XMsAdig92A8WpzBDxIkG5uMEuESsgbkAKEe3doGRI46/N0jauMwqUf+4dfrX/I+iTZf5NDMcWkI0d+i7lt4q3n0WCOiaUo+oPNLnHDj1LpbhZ5vt5mYqZ6tTFUm2TekAWH0BFtO/9kTnX2FjLH0ktCsHnQV8IjdwnYU3PcEsPrQcA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791891031; c=relaxed/relaxed;
	bh=AbuubQMqIWURa7xcEbVazmv8Iuf/praRkVi4La8Wohk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWlvjYxw4hCRUqza2ZQXl1iVYuXxY1BSpnbqHJiZXBOCuEeNuUikONK9BNKpHRDC2SCgUoMlgUuW7S9sVvvW9tumWMaxdWgrz8u/UL3CQThLDaDf/mY/fVGza5wltCkCRTsu+9YEoosND0qy3lS88b65NN4kFsuzBVEpQIHCZr5D/wbeOdDhtRYwEFMBYoYuOxDpQQzbnLhbIqSYrwM5Mu59E2AoLgddL7DQ68h0pS8I7ExQu4l5S+/wtFaiddW12YRZf6lU2nUvbX2Wngt/8pfrg2dPrzj5rfx7qFpXPHmjb2gjFjhKahnI3NrnsD7h8RcyX4DUrEnJiMWuBs2Gug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R5hcsCUD; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R5hcsCUD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3sZt2d46z3br2
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 22:30:30 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4392406B2;
	Tue, 13 Oct 2026 11:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3BE1F000FF;
	Tue, 13 Oct 2026 11:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891026;
	bh=AbuubQMqIWURa7xcEbVazmv8Iuf/praRkVi4La8Wohk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5hcsCUD+0eCdv9NN4nVV9gF7Adq/8hoJYhkSW0Yc7Fnrm9yKSN/5jYQXr6b3cQAQ
	 m7b3qgWKFpAMNP1u1LPLaQomj8Iz8rQI/pu9R5HPaTQ7ezc9cEPGGBzb8f7DODKQXJ
	 kI9lOJYOKWHo50TO0QHiPQegeVDb7zESky9eVS+ztKIfDzh+9E1W/HsNivAcY5rZ+l
	 jlikqKQmEYRJJclxbEvivy/XhiqaTNQQkCQkj1NM2jI9rtNFQL8QP9R/wAJhs0gg11
	 txYr7UFZ6ReXzpAGsEC/xqBl8iF9u9cS2eVNtnwBg/2aNkZGMNxJBDctaZVF/ZzJnO
	 yKBwQy4srEcVg==
Date: Tue, 13 Oct 2026 13:30:20 +0200
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
Message-ID: <as4WTEbunXMcOIvc@MacBookPro>
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
 <as3o3Q8X-2gK2HyF@XiangdeMacBook-Pro.local>
 <2026101340-upcountry-wildland-6ebf@gregkh>
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
In-Reply-To: <2026101340-upcountry-wildland-6ebf@gregkh>

On Tue, Oct 13, 2026 at 12:37:56PM +0200, Greg KH wrote:
> On Tue, Oct 13, 2026 at 10:16:29AM +0200, Gao Xiang wrote:
> > Hi Greg,
> > 
> > On Tue, Oct 13, 2026 at 09:59:58AM +0200, Greg KH wrote:
> > > On Tue, Oct 13, 2026 at 09:28:44AM +0200, Gao Xiang wrote:
> > > > Hi Sasha,
> > > > 
> > > > I'm not sure why we need to backport this into stable kernels, as there
> > > > are users who use EROFS over fscache on these stable kernels.
> > > > 
> > > > The functionality works and it's a breaking change.  Could you please
> > > > kindly tell why?
> > > 
> > > Why would you have a breaking change in Linus's tree?  We never break
> > > existing users, so how was this ever accepted in mainline?
> > 
> > Because the similar + better functionality "erofs over fanotify" is
> > already available in the recent upstream, and it has simpler interfaces
> > than "erofs over fscache.", so we don't actually break users as long
> > as one of those functionalities exist ("erofs over fanotify" or
> > "erofs over fscache".  Many stable kernels don't support "erofs over
> > fsnotify", so backport this commit will make existing users using
> > old stable kernels have no choice (no "erofs over fanotify" nor
> > "erofs over fscache").
> > 
> > The commit message is already described well I think. 
> > 
> > > 
> > > As this removal fixes known bugs, isn't that a good thing for those
> > > older users as well?  Why would you want them to run broken systems?
> > 
> > I think it depends on the importance of the bug, at least "erofs over
> > fscache" is usable (and it's used by vendors) on stable kernels, but
> > it's unneeded to address every edge case found by LLMs since I mostly
> > think it doesn't impact the real use case, and as I said, we have
> > a new unique interface ("erofs over fanotify") now, but only on very
> > latest kernels.
> > 
> > Also there could always be breaking changes for various reasons (e.g.
> > obsolete/dispute filesystem breaking changes these years like
> > bcachefs, etc), will these commits be backported to all stable kernels
> > too?
> 
> Sometimes, yes they are.
> 
> But this makes sense, I'll go drop this patch now, thanks.

Thanks, Greg.  As I said, "erofs over fscache" is still used by
Xiaomi on old stable kernels for example:
https://lore.kernel.org/all/20260923084823.496741-1-hwenwur@gmail.com

But we prefer to use fanotify in recent kernels and it has
a simpler and unique interface than the old one.

There is no need to leave two same functionality features within
the same codebase, so we deprecated fscache two years ago, and
removed it months before so that we could sunset the old
interface over time.

I think another similar example is XFS v4 format, The kconfig says
that it will be removed in 2030 as well:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/Kconfig?h=v7.2#n51

Thanks,
Gao Xiang

> 
> greg k-h
> 

