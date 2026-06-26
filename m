Return-Path: <linux-erofs+bounces-3768-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54767CDE010
	for <linux-erofs@archiver.kernel.org>; Fri, 26 Jun 2026 04:33:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gmjTy0hPrz2yYd;
	Fri, 26 Jun 2026 14:33:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782448406;
	cv=none; b=oIr4Du5tQvFb4fzN1vpkBeZTwAEhr/jv4bkTHVlzRsEGdM5wLng1y4keHeZesb+ovH/61lh0H3hVSlwzLWFyiKEpATRhrIt6bO9ECDaqDLBDk205oEgL3KTlFuSBbsi1bcZMfxHB14fD9805Dvgm+XyvAjQ8lcDauqYZj2bxNr8SHvLnGuccR4YqbgZ5/u+DEIr2nO50GRti7g5s9bFunCwCw/mWpalmPuYpELf4Vjd8Zxr9kkmmkBPZoCNNghiiEYkjRVSngBdbINPteMKo8Zlfuz7hxHFedLi/aTJ6LOG2NRyaR9VmH6D74TuIXJPNtbxy2BIM9Snh4OVwe44IGA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782448406; c=relaxed/relaxed;
	bh=oZ4s5vje8oPK1WcvxdP758K71oqwHOoXoI7OqdTvqdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brzwXBfXtIbXiDKIjwCNvcWCVXjLBhpn5sr7xgYiUdalpFynLA/WELQ5GgcsrJab6Q2aYi5qhX6Ea1+ekeCGbWz3vxH2lGJATxFlcs64EiLFwvuxfGq5IGhNm1AmmBJ5xJ20i2YTpM5mI6ZoHfWNM7uDNlkrZR6Jyw54SufpUb0QNQ7QFuiq1EwLsSw9EKIVrIA6EzL4R8nYOOT9HG3zazbJe4yTmphlREoCuR0i01Lkj6tezrHM3kvkd6eeZyMJJ5+lK7BhuMy9nuujtYLmzhzXc7bsG8560VOZFhz+jcwQflXc3xZpEyMDZjwFkrJUdAUXCemcXC0rMcsC8+XJ0g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gmjTx11ttz2yVv
	for <linux-erofs@lists.ozlabs.org>; Fri, 26 Jun 2026 14:33:25 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 398A168B05; Fri, 26 Jun 2026 06:33:20 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:33:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260626043319.GC8078@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de> <20260625174758.GE6078@frogsfrogsfrogs> <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com>
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
In-Reply-To: <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 11:32:40AM -0700, Joanne Koong wrote:
> Yes, that works. I think that's a good idea. fuse only needs
> submit_read logic for readahead. The change would just be:

A nice, I'll fold that in.

> If this fix needs to go into 7.2 though, maybe it makes sense to land
> the v1 implementation [1] + the xfs integrity fix now and do the fuse
> change later?

In a way this is actually simpler as it doesn't require the prototype
change.  And it'll avoid both a temporary fuse performance regression
and a bit of churn.


