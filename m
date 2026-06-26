Return-Path: <linux-erofs+bounces-3766-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE73CDE011
	for <linux-erofs@archiver.kernel.org>; Fri, 26 Jun 2026 04:30:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gmjQG2XTKz2yYd;
	Fri, 26 Jun 2026 14:30:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782448214;
	cv=none; b=MSGQOglegkENp/2e1NrRKbRBqnEa5+1M73CP2QSPRmHJMIby65G2SIRBey3bXfheA7ENAyu/rk9/okF/ELUlpsYvCYavqMLLhbNTCyu5YrrER0FQfnPLRzN/ZBCzteQsWJ3hn2q0MyQmeoJVVlo6IKhZp5dHD/UnEg7oaKCJABD6rslIE8yagUJukMIegFgwD/b9xKmfJcqry8T2R11ZiD0sMOaZuHQUh6ri4kVLCAiB4fc253rYXD8wqY23G7YoRRAEk0jw8T5glGhPCvRcgniYzD1HXHPDZA27QLoIu40pc81vmNXKemIQvuMuIclXs+Nk8W3Wpk6YDiJ3txzO8A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782448214; c=relaxed/relaxed;
	bh=2uvhb3zm4kPVUkIzWb5T3Cc199RzjAm0jrmzp6qhilg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/rBw5JiciFMuJhWUtJQ90g5oMCZRly/AnJqhSKEx6XvtUOpRP0MipwY9OGEo0sYKjUmBYgS24XyNXUmxxZ1pHCQllxPrYekYNoUIX7JkYRKvC38QdZl3XTc+lOK3qVf5EzDR2oq4i3cRCKdoxwab7sA4NhRJTIX10ZviOqCRJWq0yxEYBGC3koJ3Ga5pDb0n582uLyuH+bbRQzGRMXoniXVX5d1VWJFhK3rQSfU06bFxfVQuhaO6kNsll5USYjPRggt8SpyezBFG/yBLmjfpskhHRqrMWvwGowfF6SjGUAs4gP+odvzgoxQcAdcslBYSlzzfuh0GJ59nkJtnAWBLA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gmjQF1179z2yVv
	for <linux-erofs@lists.ozlabs.org>; Fri, 26 Jun 2026 14:30:11 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0259B68BEB; Fri, 26 Jun 2026 06:30:03 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:30:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: consolidate bio submission
Message-ID: <20260626043003.GA8078@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-2-hch@lst.de> <20260625172740.GD6078@frogsfrogsfrogs>
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
In-Reply-To: <20260625172740.GD6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 10:27:40AM -0700, Darrick J. Wong wrote:
> >  
> > +	bio->bi_end_io = end_io;
> >  	if (iter->iomap.flags & IOMAP_F_INTEGRITY)
> >  		fs_bio_integrity_alloc(bio);
> 
> Ah, so the bug here is that all the pagecache readers should have been
> allocating integrity information for the bio before submitting it?

Well, all the ones that set IOMAP_F_INTEGRITY, which really is just
XFS at the momen.  And because if the iomap refactoring for fuse XFS
is now using it's own submit callback and does not get it..

> And
> because it doesn't, iomap_finish_ioend won't do the read verification?

Yeah.

> So the block layer does it for us, and that's why we don't use the ioend
> chaining?  And (I guess) the future userspace interface won't have any
> means to get at the integrity data?

Yeah.


