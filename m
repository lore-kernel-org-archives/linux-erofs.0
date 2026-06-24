Return-Path: <linux-erofs+bounces-3750-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7147CDB479
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Jun 2026 14:05:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4glkGf0J5kz2yVv;
	Thu, 25 Jun 2026 00:05:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782309913;
	cv=none; b=Oawl+xklNpijxYSidHcwPcQEuI+gOHIQNp0ps8hnP0BPuT+Vs03CrGIutgDctDhbLx7VwygIlAcdXRTByr2fVqzNlG4unNmhzycNvftU49iLEJSGfIw7XCFqbOVfyVLMrDsWNhPGIGIauDNSDN7pO59nwiAp8DsRv0PjtG7AVsSX2w83sIWPehF39MUm6ROiGNwwdn+RLa0g6gnLXlNKvemD6Xyu4+2eSGRR6OWFClcwl/Dp3Ao3GqYUqyQ6y/p8IB4oxhxgPo4PU4+pI1VJCRf8gdP9SEveSx4xt7MY4OlojSzNDCtxigh7rv2fWLPitOBhj1FM+/v1Gt2uq2zZAg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782309913; c=relaxed/relaxed;
	bh=0V+CejDYq6egdbTs/Ni/cpGwJBJ5NgllGYau6siJ+rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0OG8JzJNueYhEXSijlBee7tHdk3c7Sdwz+5+1uT5yuX8GXSS4YgMdBahkrmXnrAKzDBtfNXLYlt3/OOvvHRaW1hOgK1QEbfmKNxEYQlr6ehlhFc0s91ahqiGOP1T7+IitFt8X+MLWHsZoxdhyJlwJazdssXuJojqVFb1slDMg00SEUph3K75en4HtVs037B332Y/fnfZFEzXOs+yaBaqtEq48ewbXO3bSXWiL5o+pBYm4bi/PkbCLQqHXSky5/dPDeyBqZ3LRMCcAweD36wpKBRhU4Ydp9P76ZMkRTAw0OaaMEAvrHqSHUSti9yoKeT7FH2ZPcx1PrlzKpPc8m0ig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4glkGc5JQDz2ySg
	for <linux-erofs@lists.ozlabs.org>; Thu, 25 Jun 2026 00:05:11 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 786DA68B05; Wed, 24 Jun 2026 16:05:05 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:05:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 01/18] xfs: fix the error unwind in
 xfs_open_devices()
Message-ID: <20260624140505.GA7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
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
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 16, 2026 at 04:08:17PM +0200, Christian Brauner wrote:
> Since the rt and log block devices are closed in xfs_free_buftarg() the
> buftarg owns the device file. The error unwind does not respect that:
> when the log buftarg allocation fails, out_free_rtdev_targ frees the rt
> buftarg - releasing rtdev_file - and then falls through to
> out_close_rtdev and releases it a second time.
> 
> The unwind also leaves mp->m_rtdev_targp and mp->m_ddev_targp pointing
> to the freed buftargs. The failed mount continues into
> deactivate_locked_super() -> xfs_kill_sb() -> xfs_mount_free(), which
> frees them again.
> 
> Clear the buftarg pointers once the unwind freed them and clear
> rtdev_file once the rt buftarg owns it, so nothing is released twice.
> 
> Reachable when a buftarg allocation fails after the data buftarg was
> set up: an I/O error in sync_blockdev() or an allocation failure in
> xfs_init_buftarg() while mounting with external rt and log devices.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I actually have a major rework of this area pending, but it probably
won't land for 7.2, so we might as well get this local fix in ASAP.


