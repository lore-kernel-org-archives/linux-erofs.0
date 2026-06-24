Return-Path: <linux-erofs+bounces-3745-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D860CCDB470
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Jun 2026 07:34:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4glYcF1Z8lz2yYq;
	Wed, 24 Jun 2026 17:34:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782286493;
	cv=none; b=ob0nKS2+OyxPlQJOa59vu2mF8dHfh7DQr1zokyNv5EL/LfWQBaD2RaAYnm5O6KZIDYyT3SJhEQOAdNELoE3bm0IFra6xLWEfIx5hskcTmGdctLDBaUL9dqrHTOpv4gI23sAVf1lW5IXs/6GNXpowW7AM70v0yEE/uPbsc7kxgR8e2Bl/drcoAw4KuL5pnydS5kIU94sXPleHH+7bJUOR9Ux41xdfZ5RxuBJyew1Ai48CX6V1iSsIjnRYiSs8WN0IFOGh/2sUcyqfYG85OHYvjpjVik6klX0t3JGo8iBR49t8nQ5Rb1c52y53KtrRGXCAZr0nk99ypDSMZ8mk2YOjHw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782286493; c=relaxed/relaxed;
	bh=qpRsn3HwrSkmpEGxx63HR4rsvKYNVyBC2o4Rzly2H0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvFfwdKwjCXi+uDR5VIvbTqCgz3opbasAZdjmLnta2iYfpB7uS/Mm3o5qtw4zeqF0wg4LA9ijSMpc8p3d72hSB1dF3D+MkA5EulZXA847mbw3VYr9KiRZSmAfi7WgDM7bZbqS1LHz6eM/E0oLfPluSAFFqv4WBX1IkWz4DUjWTX7/Jd2To86r1wZbv4oQ1zYzkN18wZuWou/qeOJXxEpiXb2caNGlFKRXGyEMJMOFoXCK9YVwAVc+IdpI/grho1bB/akSDoVQfVpjCxTi2k3bIDRjPeCExBHkcMCpp6DkwZdnsCbHLWS9TjlEjaJwF6lH+f20g7bSmC16oYumVxsSw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4glYcD1LZ8z2yQn
	for <linux-erofs@lists.ozlabs.org>; Wed, 24 Jun 2026 17:34:51 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBD9E68BEB; Wed, 24 Jun 2026 09:34:45 +0200 (CEST)
Date: Wed, 24 Jun 2026 09:34:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260624073445.GA12359@lst.de>
References: <20260623135208.1812933-1-hch@lst.de> <20260623135208.1812933-3-hch@lst.de> <CAJnrk1agx-qUizNzCnzvZ6Marf7u-K4EtKOak4c2MQN1sJfgNA@mail.gmail.com>
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
In-Reply-To: <CAJnrk1agx-qUizNzCnzvZ6Marf7u-K4EtKOak4c2MQN1sJfgNA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 23, 2026 at 10:29:54AM -0700, Joanne Koong wrote:
> >  void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
> > -               struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io)
> > +               struct iomap_read_folio_ctx *ctx, bool force,
> 
> nit: might simplify things to drop the unused force arg

I guess this is not directly used as a method, so we could.

> >
> > -       while ((ret = iomap_iter(&iter, ops)) > 0)
> > +       while ((ret = iomap_iter(&iter, ops)) > 0) {
> > +               iomap_submit_read(&iter, ctx, false);
> >                 iter.status = iomap_read_folio_iter(&iter, ctx,
> >                                 &bytes_submitted);
> 
> should the submit_read happen after the iomap_read_folio_iter() /
> iomap_readahead_iter() instaed of before? From what I see, it looks
> like iomap_submit_read() would hold the iter state of the next
> mapping. It seems like in iomap_bio_submit_read_endio(), the
> iter->iomap.flags would be the next extent's flags instead of the one
> that needs to be submitted?

Yeah, the iter state would be wrong here if anyone actually used it.
But the only thing we actually ever use from it is the inode in XFS.

So I'm tempted to instead just adopt the signature to not pass the
iter, as nothing should rely on it.  The only interesting thing I could
think of for the future would be to pass on private data, but that's
probably better left for when we actually need it.


