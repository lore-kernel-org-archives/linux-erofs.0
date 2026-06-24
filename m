Return-Path: <linux-erofs+bounces-3752-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00C46CDB481
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Jun 2026 14:06:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4glkJY2KMWz2yVv;
	Thu, 25 Jun 2026 00:06:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782310013;
	cv=none; b=NcltdGo5gsCjaQu54nmnwTva2XUopXtncam0FAMcajoq/XnPrdWKLnttkd5uaD+RyEJayj7nNu8cwy9sKfHfZrDL/pZnQh2UcIjbprPOD8RVryfsWUIHKoNkrTa5vDgv/SyUrnI5B1yTjrtDDwCjnpjqaeWNc1ukHGq9WvB9ejjZXo2OtX1nji36/yA3bp4xXsJK/v/S5//iILjGETCzruhSh2/XIxHZmQr8GLtRhZ6jT1893f6SoWfH35Fm7G20g/ZacVQawHyvNKnOVP9GoEDjLfyT1msWR49Swf9JqvqAYTe/7sr0+htE8kM48/np8TsjhZaGywKN/upOQdQEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782310013; c=relaxed/relaxed;
	bh=edPrI9BW3vauMpH/cCRyyZuqQ+gXZcJUJ5WkoCrCWu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7kBDDDj17nypkCiE/pqvq1R7aDCvuEvV6gQNDCjCrY74sWBx9JYUfWl2PYw7Iw7Rel77/+d/L+ZxEdf/9EowN3KJnSVkZxAKvHPTPzWQv3RDbZypYEl86TlrGj0dPfG8/DTlEApl/hHe7TMdLElTEo9RVwyLo/dlFNa1ODun6rHrm30oLRHuc/rTN1oncshsQ9N+Pa8WEs0KJly5sqkXcSR3pEehQHRiYCM9MEdl/HyJEzaNyEqfcgHlDT2dMYJS2UB8akOC2dMDUi6/B8aB+jRHycbxwe2DDbfVmUwdM/tr96E67N18Bkq+Fh+lR89NGMD3LXfKo9HdcnWHo419Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4glkJX5DJLz2ySg
	for <linux-erofs@lists.ozlabs.org>; Thu, 25 Jun 2026 00:06:52 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7FDC568B05; Wed, 24 Jun 2026 16:06:49 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:06:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 08/18] fs: add dedicated block device open
 helpers for filesystems
Message-ID: <20260624140649.GC7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org> <xlfnmwv2upjia6ozd4z5l5icaewor4a6cgkafnigulndzmt6r7@rhay3h3wablo>
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
In-Reply-To: <xlfnmwv2upjia6ozd4z5l5icaewor4a6cgkafnigulndzmt6r7@rhay3h3wablo>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 06:28:50PM +0200, Jan Kara wrote:
> > +static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
> > +{
> > +	struct super_dev *sb_dev __free(kfree) = NULL;
> 
> Frankly I find the use of __free on sb_dev more confusing than helping in
> this function. If you didn't use it, you could remove the somewhat
> confusing retain_and_null_ptr() calls below, remove this initialization and
> just put one kfree() into the error handling branch when super_dev_insert()
> fails...

It is.  __free is really annoying for anything but trivial local
scope only variables.  

