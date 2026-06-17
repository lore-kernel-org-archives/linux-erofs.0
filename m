Return-Path: <linux-erofs+bounces-3659-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A606DCD98E2
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Jun 2026 06:25:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ggDPQ4wkQz2xnK;
	Wed, 17 Jun 2026 16:25:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781677530;
	cv=none; b=EyyiT7p/AsvgojvcWeOdNlLOmpTVjVocNHkIk6x7xUqugO8V2k2U/yuK0jI4LnsXGllEJ+gBlAc+PqrUvhbaDteZa6xpV/+pu8gupYwv5ZFc8ZBVJXHxsb7d3dlFyFrKDpaxVMoKEPxbbQddymX3X25pY/Mny38VxSO9DgNu3ox2cmEmQV+E0PGGyrFIl71nw1nWbBWEK1nYOqoybnkveCe3iam2BEMD/i/4d3XyzObrWoBdemc4W5BdxPkW0nkxsBbqhFjlgRIXF/GCcPCkWvzhnu9Upb61y9V0RlcPUhc1DN8akgtuWZ7wIqvxqJlsDbEoJAxvNP0b0E5Tnjmu0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781677530; c=relaxed/relaxed;
	bh=ZRecdmIP5T0Ca9Z8ncbOVHLMKVOcrh9BwgpAdUYzDXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GseRamquUaOfcqduG3vL/F6FZ8RjdSUVxKDMNuBIJJfGntk21u9Icr0qiMe85gOTyF5n0owXmyJh8eJ0rjYTyBIxazUGd8JT/7y+jKQC6DZaU0eunKHTl4GGfv095m0bQZ8+YaxNKYoL2Ktl2H/pJ+tP2L5cZmdomSYOaXjGqg0RBeziiwBa0HVnfai1sq3l8w4Sh3w7j+shM1EmnLFd4fizxEI7Xj2MLgGM2FvxLtIhJIxHwR/sehH7ZlSfBzxnHEhT3oewCdJ+PEn7210fM7xtjiV448MnL14rqzUZcPmAsRxCBgfdDeUKpG4ZOYlqCCEiv89SoOBeiO7IiZe9Rg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ggDPP4qDCz2xll
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 16:25:28 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1092068AFE; Wed, 17 Jun 2026 08:25:24 +0200 (CEST)
Date: Wed, 17 Jun 2026 08:25:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash
 table
Message-ID: <20260617062523.GA20041@lst.de>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org> <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org> <20260616123443.GA21024@lst.de> <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
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
In-Reply-To: <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 16, 2026 at 04:59:53PM +0200, Christian Brauner wrote:
> > Err, no.  block devices need to have a specific owner.  If erofs wants
> > to share a device between superblock it needs to come up with an entity
> > that owns the block devices which is not a superblock.
> 
> It already did.
> 
> > IMHO sharing devices between superblocks is a bad idea, but that ship
> > has sailed, but please keep it contained inside of erofs.
> 
> We need a simple device number to superblock mapping anyway and that can
> simply be centralized in the vfs. And it can work with anon device
> numbers and block device numbers uniformly.

No, we don't need a secondary device number to sb mapping.  On the other
hand we do need the deviceloss, freeze etc upcalls to work for owners
that are not file systems like mdraid or dm, even if they have been
slow to pick this.  The whole idea of the holder ops is to abstract
away from who holds it instead of adding back the broken hard coding
of the superblock.  Otherwise you're just badly reinventing get_super.

If erofs already has an owner entity it just needs custom holder ops for
that.

