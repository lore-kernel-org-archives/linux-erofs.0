Return-Path: <linux-erofs+bounces-3753-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B0EFCDB479
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Jun 2026 14:07:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4glkKZ6XVjz2yVv;
	Thu, 25 Jun 2026 00:07:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782310066;
	cv=none; b=IqKv3MW6cQRoW+zCm+JWGXuTjei8rCWiuJ1GUb4LXwb6/rEGYfGK4Vbh9ksGn8i5sPpEDX3scz/VO0bPeSh9wFX0WeYpbljVDgBebAGTfTARxES3fv39Kd+wLltB+/WEIurVst6d0g9+7nKFHe9w3GRRKFbH0pcGdAQHyojkKNtNfsv3vSCGxS/yeW681NSqwS5sBz17/XARw1ic0COd/mrIY+fNGf4samgvJa+kythhkTLO/zzoLwodJQ94bIzbqPiE4QFXHOcPIj8wDdrvzfcMHS9j0dn2PnzeqachgK/ru5TzvlPTfJU3D7s9Fs2UAjh671Bp5YEGOwtUAS+Rkg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782310066; c=relaxed/relaxed;
	bh=Ad7M3xysLuYYxJa+eQoxMDSPz79ZV7szCzjZry9M5Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bc0/LeGRVfupQvexq5pmsX/7tn3NSwnhAvRqY00aC3BF7wTUnKI0SJFOyFMvmLk9LcS0Sj5bi8+xaBFJxfIRdU5Lc2G9bJ7VBOTGe999xYwUw4rHwy88SE7x4S0bz9q9m4zUBgsYgwhBZ62lOFAVAsrhoV2ZGRoHU+L1q/AzI22/sRie94fuv97tSVnkgAOUnu31ZUnHmMySlJW3YnRy9MC2GTW7/OIKhn7y591iLtP/8HyODwJSS+kqA07yhByJIeXJLFQua1VKNFP4FhDajl0W2rGW1nF4R3GoB+gSIw+d+Mc9q2WYDyoJVGa/la0QqXXBDV4hEViAEkgleu5hgQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4glkKZ2MmZz2ySg
	for <linux-erofs@lists.ozlabs.org>; Thu, 25 Jun 2026 00:07:46 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 18A7E68B05; Wed, 24 Jun 2026 16:07:43 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:07:42 +0200
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
Subject: Re: [PATCH RFC v2 17/18] fs: look up the superblock via the device
 table in user_get_super()
Message-ID: <20260624140742.GD7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>
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
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 16, 2026 at 04:08:33PM +0200, Christian Brauner wrote:
> user_get_super() still finds the superblock for a device number by
> walking the global super_blocks list under sb_lock. Every superblock is
> registered in the device table under its s_dev since sget_fc() inserts
> it there, including superblocks on anonymous devices, so use the table
> instead.

So what is the benefit of this?  It's not like any of these are heavily
used fast paths.


