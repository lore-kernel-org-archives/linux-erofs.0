Return-Path: <linux-erofs+bounces-3769-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF3DCD4F26
	for <linux-erofs@archiver.kernel.org>; Fri, 26 Jun 2026 06:16:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gmln97441z2yYf;
	Fri, 26 Jun 2026 16:16:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782454605;
	cv=none; b=EgWyslxwNbegGJzF3Qp3dQQQZTvMtDOnHtqVWst+h9wTEZEfMx//Bry1CJY4cRCaWqi1JyZ2DkgYQNxnNs2xraxFjDyeCmrydfYTY6W0il2TlXLYFHbvthMPoJjFCNDwJOnwdQeAcaTfhRCuuWlgbcHhh4XqzL9hz4xLbX461yK2L+Sd7D33NGLCB4jF6+HiE9QBwIYHskVlSPUftPjyVoNqGkBWcWauvXab90/+9CcXGOU0LUjX99mVLqC9FkoTmTv/QuHa1wcd6U8JeR1cBEd2f9mVZQZebBarsooaLFsGbCWTLBaSImPqVnODVDpyEjXqlx33hci59qKrXt8D0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782454605; c=relaxed/relaxed;
	bh=DnWW2B02tJo8s3QUwD8/aXFmynbEd9S+n8wSCnsIiSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLnEFghFLHALohT11YSjRcsTKxBJtyuo2s8RHZRvtu3uoaPIeZthdelLuM+DzbH/pFobZDhLn4D0uj4fhrA8wdlERGjXAQ1jy8iDa6U5jh9ehQt7c+cD4B1noK5IojKALR3ATtvyupUvn38W75o+G0Ggpi4b3ESQqeCJaDUvqtWhaSufUeK+gF4gVu1MLuYk1BLUqKtaBRTkmGkKcv0YV2rRMXiMc51dA+qsPNtrysAEpW3n0YvWw7M0Gm1LXjNnju748her66dX6xN0ZneY1TX2WalxSa+s4nE2jAD+lJDavgc8EHzFJOvH2KrUMBg20evIU2G52VHsCiat6eU29A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gmln76zr4z2yYd
	for <linux-erofs@lists.ozlabs.org>; Fri, 26 Jun 2026 16:16:43 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0352068B05; Fri, 26 Jun 2026 08:16:37 +0200 (CEST)
Date: Fri, 26 Jun 2026 08:16:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260626061637.GA10337@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de> <20260625174758.GE6078@frogsfrogsfrogs> <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com> <20260626043319.GC8078@lst.de>
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
In-Reply-To: <20260626043319.GC8078@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 06:33:19AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 11:32:40AM -0700, Joanne Koong wrote:
> > Yes, that works. I think that's a good idea. fuse only needs
> > submit_read logic for readahead. The change would just be:
> 
> A nice, I'll fold that in.

Btw, can I get a signoff from you for this?  It looks like splitting
this into a separate patch actually works better.  If you have a
preferred commit log I'd take that as well instead of mine.

This is what I'm currently testing:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/iomap-read-submit-bio

