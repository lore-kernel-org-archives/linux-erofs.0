Return-Path: <linux-erofs+bounces-3751-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9B4CDB479
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Jun 2026 14:06:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4glkHb70WVz2yVv;
	Thu, 25 Jun 2026 00:06:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782309963;
	cv=none; b=Rp+edVgd+2NffW8VMZdyEfx9zCcuuBjuhribYcTiUh7sCY1rD+XFwxwNSFVWB9+gkkSUS0TkVdH6BVbiY23tQjCZXaDSLOim52DQBV23ym8WE8P1S7GIXbg1AGQQ5N7EWVmXLEVkYLEDDIWXq6bkjyDgJdlNQKLPTuxSclBQXZ4q4yGLnmbaj6J6tsdxg39nt+F3ra05q5aKn3K+gp4abNARrctHgVJRmUT9rvOMWaRvJjqLRmNq3z320tGkeCZYRSp87JtvTfApa+9xAKz460y94OcjPTpN+CvnqHvhp6QjGMM/aPPn242P84nCTuj08uXRveH4GUgEanjqpy3Vcw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782309963; c=relaxed/relaxed;
	bh=w5mvddVPYHkVPCT3UIzummcftFIgUwg/5BZvD4vnY7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=biVeGcKT0fOqCqF/0mX1Xw42gy/oYHaAoC8Rg9S4LKAlasQ6xju6YY86eQwis0xsmJs8k6zHBuWT7brv6f2B/3hbH+UKAZrcspCs1S6OdkqTQ4xtxdQ78v/gFD85C8ls1lLt2alrzQYOiLG4mJynXD0w3MmxNeGCp6kNhc+ymxUuvg9uRZzOd+ui4fBVeIbMmk3jtDBwn/Lqv9Bzj4e24rxWwYSOvO03jgSTayuimyUg6fgj1dQ7/L0BxpanRbWZv1jkPaS9LG+zOEvC8hgggE1wMVo5zTsVaGPVDwMQ7wsJgyvJINsjbyrA+3ihB4e31GnA6dKWlzp+IIJi+6/9OQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4glkHb29Mzz2ySg
	for <linux-erofs@lists.ozlabs.org>; Thu, 25 Jun 2026 00:06:03 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 127DD68B05; Wed, 24 Jun 2026 16:06:00 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:05:59 +0200
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
Subject: Re: [PATCH RFC v2 07/18] fs: maintain a global
 device-to-superblock table
Message-ID: <20260624140559.GB7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-7-7df6b864028e@kernel.org>
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
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-7-7df6b864028e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI, I still think maintaining a dev_t to sb mapping vs having a holder
register a claim is a major step backwards architecturally.  I spent
a lot of effort to get us out of this.


