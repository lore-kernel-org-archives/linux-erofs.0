Return-Path: <linux-erofs+bounces-3807-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871C0C43458
	for <linux-erofs@archiver.kernel.org>; Thu,  2 Jul 2026 16:51:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4grjZg09qHz2xPb;
	Fri, 03 Jul 2026 02:51:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783011082;
	cv=none; b=QbKl3/UJI34WVLeFYof2zKowsjFO/6LZOFf/5NsDNo658kbW3CH36NDQaIXcdRLZcgdqdSzlfuCTfXXWJLJvVwIKLAXigHD39lW0F/KI0s3GUQdTgzA87KD1iLvDt3TuVbSijFY5Y7RZkBYJR2RGG7uFyKxdElmUrMqfl0pjH7b9Fa+WUweGQ7Ly38T7V0oW+KU43BZ1ld2EX23Bxn8P93ri8+w87SWCFnksJgg5Pfz8ExCU+AXhA0zT8XZaYgrsvqVaOLl7RsBRVvkiHbQkLc52KBfz3uYedk5kB1BQKfLmNE7ABm+uDSQlTZW85Gw4XGtvFxsO9qcT8wUENINWeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783011082; c=relaxed/relaxed;
	bh=ydgqm4JLD9wHorHnF+2XAPjVnBLFS4UbABn2TMKW9lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6UiqJQzIxjUCSP8zp7xWGwcRbcdpJ2rI7JjdPp5VjtowqPRQqATYOF1YYpXTcEoxhPqQw3jIdH0awKZnGRXRLyMVi5XMQT7Qp9BF5UJYs5Ol2Ls4CR6Q4me5qVn91jnZYD+flhpewvfb9wXXcq9LEag5Gz1Zwo2Hs40mRPSHKrY4pHWt8OIROnu/P7rwnLHsuHSlLVNFFzPsFbeVQXLot9WyPY5Jy9VuRcqM6QLwWhf3lDIIEuF/gaMddL32xuymxHmObVnmwYHZ32xMKRZX0bL5ILUPIW98PTorIp9f996beUEiEPXmgjrXFeJo1G6yDefjOQedxNDGxmECTZ91A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ymepa36T; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=djwong@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ymepa36T;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=djwong@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with UTF8SMTPS id 4grjZd67L8z2xLq
	for <linux-erofs@lists.ozlabs.org>; Fri, 03 Jul 2026 02:51:21 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 1383940C06;
	Thu,  2 Jul 2026 16:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D15C81F000E9;
	Thu,  2 Jul 2026 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011078;
	bh=ydgqm4JLD9wHorHnF+2XAPjVnBLFS4UbABn2TMKW9lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ymepa36TovSJKNYZV3u+xpDtmvDD0jgD8tu6oITOhStEqSB4dFm2GSNjYvX6a/XhD
	 idd1sj/Z9E/KlApdD9cMjRLqTlqdgS1ZGfahdEB1adsC1jHUM18Idy2FDJdP+91o7q
	 QlYswMBkWSAqfhgV/t0BjA2QDKkEneDGjH+Gl5qKC5w3Z9fiVXFpsrFrRHn8BhtWaG
	 lcACOAbDkojouQsXQtSoi47LOb5OGkLJW+AXDJEZT+ElhlEosUQhZ2/nNXhEJR9+aI
	 PyMC3eJrsnz1BJ5WVFaLKabv6f9zwLwtBLpgZ7fU4xVDkd9t8o3JJ3wtYAC95RX0Zj
	 PrPeMRFBP/AuA==
Date: Thu, 2 Jul 2026 09:51:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	"open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>,
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>,
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>,
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>,
	"open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
Message-ID: <20260702165117.GK9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com>
 <20260702140705.GE21339@lst.de>
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
In-Reply-To: <20260702140705.GE21339@lst.de>

On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> In terms of merge logistics, I wonder if we should delay this and
> the previous patch to the next merge window so that we can minimize the
> cross-subsystem merge pain with more file system iomap conversion.
> If none of them actually happen until rc6 or so, orif  the merges aren't
> painful we could still pick them up late in the merge window.

I'd say everything but this patch should go in during the merge window
for 7.3, along with clear instructions to brauner/torvalds to expect
this patch to appear right before 7.3-rc1 gets tagged, to clean up all
the other changes that come in.

--D

