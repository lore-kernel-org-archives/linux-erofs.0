Return-Path: <linux-erofs+bounces-3767-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6412CDE008
	for <linux-erofs@archiver.kernel.org>; Fri, 26 Jun 2026 04:31:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gmjRZ1Hd0z2yYd;
	Fri, 26 Jun 2026 14:31:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782448282;
	cv=none; b=h5Ll5R3RH+MpO9tJolqxzegWaFFZDDewF1neopDgO/Xd2TkNpr1ht9k4RvjaocnM0qo8I6y4ToYEHP+aOTFcpooSn2gVuG9CEp2NUs+Ta23XoQ1Q4aF3cMisKHIRPjUVfE7gdrmo2orfPrG4o5Kgwo0Bm6zdLhaFusA0CiFt0Y0cL/Tu+5PILjqMRj3ZvB33W34VSduGztssWuVFSb7WYVdhy9R2MJopNDtItsrVDDs1lyVL7bkUNjqOuztSrxEMy3G1iNClYaHUc62zwvj7xIP87P7KoDMBzW4DgDUwWnI0cp232g9mpg0QCm3ADLjxvh7eThzrtGQ8WkgrRVkNSw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782448282; c=relaxed/relaxed;
	bh=EEU3xELJqHidlkaHSvcWmH5JF+Sp/Xnst3OP92YZemU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHxCxlfAWJgQWQR6dyLqjDqeYA815N+z79q2rU1Ezm9HKVE4/f5hze5XKlSZ9vkaEzZYIyf9g6zD3yR4iF+qzjxL6ovn4xFP3YxISYAYs2lW/N1JiLO2EZWBM4mjHNSgPnfRWXk75TywoxTWkUxEezetHfqZpc15i2PVBC/g1kTR3s6kS1CskVnK/BvJvaS2dg8sHQdDomnB/2yzrST/HHRP64n+99xkMTWT/N+7+Cbwyq58neqK6b/OLfNtOWLov0YHzkQ4UeqB2q6/mq+ShnESsj2XjCUzH77NAeBNLPoah26OtzUA/gpgc/R+flQm2gUD5vL1XvzItHTxm5Lg2w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gmjRY3nLHz2yVv
	for <linux-erofs@lists.ozlabs.org>; Fri, 26 Jun 2026 14:31:21 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8F7368B05; Fri, 26 Jun 2026 06:31:17 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:31:17 +0200
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
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260626043117.GB8078@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de> <20260625174758.GE6078@frogsfrogsfrogs>
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
In-Reply-To: <20260625174758.GE6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 10:47:58AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 25, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > Currently the iomap buffered read path tries to build up read context
> > (i.e. bios for the typical block based case) over multiple iomaps as
> > long as the sector matches.  This does not take into account files
> > that can map to multiple different devices.  While this could be fixed
> > by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> > over iomaps actually was a problem for the not yet merged ext2 iomap
> > port, as that does want to send out I/O at the end of an indirect
> > block mapped range.
> 
> This really puts the onus on block-mapped filesystems (e.g. ext2) to
> merge adjacent maps into extents.  Granted they *probably* already have
> been doing that.

Yes.  In fact the ext2 conversion was the first ask for this change,
because they do not want unlimited merging but kick off I/O at the
indirect block boundary.

> > So instead of adding more checks move over to a model where a bio only
> > spans a single iomap.  Change ->submit_read to be called after each
> > iteration, and pass a force argument to indicate that the bio must
> > be submitted set on the last iteration.  Switch the bio based users
> > to always submit, while keeping the single submit for fuse.
> 
> Is fuse the sole reason for the "force" parameter to exist?  I wonder if
> fuse could drop its submit_read function and call fuse_send_readpages
> after the iomap_read{ahead,folio} function returns?

Probably..


