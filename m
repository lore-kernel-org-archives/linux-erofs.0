Return-Path: <linux-erofs+bounces-3631-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE123CD98E1
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 12:40:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfmmb3GRnz2yR5;
	Tue, 16 Jun 2026 22:40:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781613631;
	cv=none; b=SEMzQIb/8p99qp0kzP+piXRrTU71iuxKb0HcuPNaPJL3mAJGdr7/OWcyi5r4CU5B/DpvjJmWd7M7HVOc33smTgCe4gCark0b/Qcd5MaN030VxY/rmkNOP6Y/iGgxNQI3hdk00FaZgNe5WMU4DdkVOPqTsozGV+G1H7h1tvEO4EQg8xGtrK8vamxMbgSn698YnxqUL5On9pkzLEjibqX3aZrTUPFGNQ4g2QptxxwObKUOZ9iymBtKW2ZFRrlwcVv+L/i8qV3dQLqXN59+XdKWc152NayMDciWVsWox6mH9Qj+FU59z0djW+/k+GphYFTC1WXAVX1RGN2xDWbyyQexFA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781613631; c=relaxed/relaxed;
	bh=MmAwi/IJGsmer9zh3pSBBl0V97Nus2WHIHnO5/iiiyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/T8hq9+VwV0svOlEgDdAcSKtBfQfQZaB5NJVeGq/YoSkNqpWAcYRu8DjSv/MUjXc09nCblBbtVRJc3fh5Sn2HmCLZEIfBzVCdvxuHvrPcIUsKhIWy85+RP9eprI332F91XVs6y+WVOjca4qsXcVGEIvkW9sPcbyIdZygHPbeenMgLEfVOZhu0MCNWeLJoDz1dc7uabIkYIsUdMV5C391Te3fZh6m/UAP2S2TiepxVSQZyBgdltgkHfv1Xiz/sB4tn0z5iecFQ4ytFpk1pthGyIW/a/Ap8WtbONXLHyp0z4XvxxymZqK1xCE6vM9RNEUc251TqlvC/gvyQNigxCw8A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 340 seconds by postgrey-1.37 at boromir; Tue, 16 Jun 2026 22:40:30 AEST
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfmmZ10tXz2xBb
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 22:40:30 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DE2768C7B; Tue, 16 Jun 2026 14:34:43 +0200 (CEST)
Date: Tue, 16 Jun 2026 14:34:43 +0200
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
Message-ID: <20260616123443.GA21024@lst.de>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org> <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
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
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 02, 2026 at 12:10:08PM +0200, Christian Brauner wrote:
> fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
> forces the holder to be exactly one superblock and prevents several
> superblocks from sharing one block device. That's what erofs is doing.
> 
> Introduce a global dev_t-keyed rhltable mapping each block device to the
> superblock(s) using it. The holder argument becomes purely the block
> layer's exclusivity token (a superblock, or a file_system_type for
> shared devices) and is no longer needed by the fs specific callbacks.

Err, no.  block devices need to have a specific owner.  If erofs wants
to share a device between superblock it needs to come up with an entity
that owns the block devices which is not a superblock.

IMHO sharing devices between superblocks is a bad idea, but that ship
has sailed, but please keep it contained inside of erofs.


