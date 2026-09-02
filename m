Return-Path: <linux-erofs+bounces-4412-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A3E1C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 05:39:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZWkZ1LjPz2xyl;
	Wed, 02 Sep 2026 15:39:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788327558;
	cv=none; b=jDzUQpsa41qFMHZFwObLOmrzjNCl9o20anew51zNOQ37QxH4CGFFkmTcmY8tIDl2DVjFBvld63dPWcfIyLp3OitaVv0zLmBk4RGCr/2W01tXmCvED1o1CAXKaPGWMDrFuV+JXcpJ4BxNgnmz+OGSn1n+bhzi7UjMiUKJKNQYVKWjjQ4N6opYAPyei+LqZJm4/KJp8zitbgPpI3a+iURje6WeEzUt8tcytK9ZZAa9RNaR6k3JujFQyRyojw1CRXWDeT9SpRGvUZUkVdHHkyM8JIi4FKfayfJp2PVKXSG85MJYG7ppxJrYm4gov9KIkKo3EX7AFfM92OTvjbEBZI8oQA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788327558; c=relaxed/relaxed;
	bh=CRkNX4cQTY5etRTJOCaqWjzWOoYLNAiVIcrIYTGECAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fu9QEu/0wqUaavot9D3Q7HLZ4yWVNNaUlym8Sl6d9LDGF1wAoY9wuwn2kZC4kSSe8aPf4t9KXP44Vy8ijIsFN2ItLhfq1i0W4Dcz2H60zn/IOf1IPFgIMaNiY4A+0nRlA4SGtXYmbcoE/lI/TR9bgVbQxk6Jy5hhhSjhaftA0ZcSWV4sHx3kXCay8KNj2M6cpjgUAZTSjPb8p6J5HIPnqKfUOra/rF5V1P4hOQQDJQNFkS4sypVDDCukcsNn7bpN+74vR1jIBLi3fKDneEAB5cJrIB9l8ukpLasAaHFtecP5It3ZyT3ohBIWDH6Wq90BIJHTamrX5zobHDjSfvaXng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 460 seconds by postgrey-1.37 at boromir; Wed, 02 Sep 2026 15:39:17 AEST
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZWkY0LvSz2xyh
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 15:39:16 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1BC8F68C4E; Wed,  2 Sep 2026 07:31:29 +0200 (CEST)
Date: Wed, 2 Sep 2026 07:31:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 08/18] fs: add dedicated block device open
 helpers for filesystems
Message-ID: <20260902053128.GA23581@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org> <20260901221314.GC6038@frogsfrogsfrogs>
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
In-Reply-To: <20260901221314.GC6038@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 03:13:14PM -0700, Darrick J. Wong wrote:
> Hmm.  I /think/ this might be causing regressions in xfs/006,
> generic/311, and xfs/264 on XFS realtime filesystems.  Each test fails
> with a mount failure due to a busy device:

Yes, I bisected thee failures to "xfs: port to fs_bdev_file_open_by_path()"
as reported on Saturday.  Besides the failures I also still have the
same architectural objections to this whole series as before.


