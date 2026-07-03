Return-Path: <linux-erofs+bounces-3815-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE651C43458
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Jul 2026 10:37:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gs9Ds2L48z2xd2;
	Fri, 03 Jul 2026 20:37:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783075053;
	cv=none; b=WR5ByV+76i05ZJCSlxQQBbWdbYe+lUQ406JyWFhEiK15Jsy3m9exZhFv//7on8jlD497JsWoE5ewBfopvK6efX/DK4JBBodU2JpceEzCr2PdyDwWEoBBCsN8OpSJOF13ehzI3xHxISyDuyy3dHOvqCuVgeGckXJmS6gz0QxduklXYrO55d61FhqYNXn6Ay+XIm+Fiz0h9+LxSTx/y9Jj9+yORxjsL5mj0J4cjFIWQmlbKp0tmgm6tGywEdVEw31VTKNp9tkoNmjsIvGJrvrG6teKfWBO7IgBMZDPxvTzYoCfB48iYU1NH9ogr0vz5qXlhiscTuO6pJ15hi1yxhLTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783075053; c=relaxed/relaxed;
	bh=ibq5yGoOYYUKiAiXchC0WA0gL3l+/26cw0R84LkFjaY=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=X6yy4lNSJS3gptKcSJe7wyi+szqXMyEnQbevRcaZdWMAwnRgu2yo5XD9jclCrGAfnx8dBmRKd8uLOahywkUcOy7SrlfjdAvDRNb0dUa3kH9kg/qr8z1YV32z4pY8tK9ncRCfstSzCbM79apl+5lXqflh/MLO3X6JDScC3j12+Lg2G2MSuTgPZCbDemdRqoiliUjVWOnu8K6J/8trd5+BVyX/IEby32Bsbvj7pcE2WjkOpm87HFQuT7ucNiL6Y/QEL62DBgp1NJ1gNiK3oc5KbUsmoTS/1IIbWvS3KFFgpCsau/zo2a0Pjx5fBYbqmErLFWyW0pSK0FfImCU0pbw8bQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8LzFtRD; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8LzFtRD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gs9Dr0DLSz2xPb
	for <linux-erofs@lists.ozlabs.org>; Fri, 03 Jul 2026 20:37:31 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B4B7601C2;
	Fri,  3 Jul 2026 10:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CFA1F000E9;
	Fri,  3 Jul 2026 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075047;
	bh=ibq5yGoOYYUKiAiXchC0WA0gL3l+/26cw0R84LkFjaY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=W8LzFtRDEJ+LA4ga+f6QzIP5wIjhPrvbgSkeN5H9fdUp8ldRpYac+VP2pbFWqLIaZ
	 VOZRYcIErzh7ZZVI1opgKNPyPdXZNYzLlXZRZvIfpIEGsP8CRSvmh6dp1f1DUAQ8eT
	 REmssNKn6FgP95Nylwk1jyDskOejoq/ZtxJV6+SZMcueW6AmnmkTRlSc0afIY2ZaY4
	 0j6EQgUmekHKxLsbkP1RtsOiATrm0qsMc/rLKl6p2+xyg60HQXm8THGcRmHmGEbsA5
	 +KIVTrOUxI8EdD77tZ08aAlBNDaVgctnhdPNMu6u++MTrLUeeidjuDh4Pwu7QdGwKu
	 L34A4eoQ9xeiA==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 brauner@kernel.org, willy@infradead.org, hsiangkao@linux.alibaba.com, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Dan Williams <djbw@kernel.org>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
 Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 Hyunchul Lee <hyc.lee@gmail.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
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
In-Reply-To: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com>
 <20260702140705.GE21339@lst.de> <20260702165117.GK9392@frogsfrogsfrogs>
 <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Date: Fri, 03 Jul 2026 12:37:14 +0200
Message-Id: <20260703-nachrangig-gegeben-befestigen-8219a53648c7@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1636; i=brauner@kernel.org;
 h=from:subject:message-id; bh=d4s4dMLniDIuK4LTsTNvbrHzQ5sC7wrFJBhb2lMg/u0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5T7iz7fS6t1kzwm8fcparv3KDyXRbpMKKF15fNPbwT
 dVe5OMk1lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRtgxGhmMbHf76zT147eA7
 nZiMnzu9Q+v+PNtl5pjYUP6f6/XP/z8YGe7siubVVw14xJBz7G+cn2VOrNK0S08/rfgQ3Ddj8wq
 eCi4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-02 18:47 -0700, Joanne Koong wrote:
> On Thu, Jul 2, 2026 at 9:51 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > > Looks good:
> > >
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > >
> > > In terms of merge logistics, I wonder if we should delay this and
> > > the previous patch to the next merge window so that we can minimize the
> > > cross-subsystem merge pain with more file system iomap conversion.
> > > If none of them actually happen until rc6 or so, orif  the merges aren't
> > > painful we could still pick them up late in the merge window.
> >
> > I'd say everything but this patch should go in during the merge window
> > for 7.3, along with clear instructions to brauner/torvalds to expect
> > this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> > the other changes that come in.
> 
> Just to clarify, did you mean this patch and the previous one? If i'm
> interpreting Christoph's concern correctly, I think he's worried about
> other filesystems converting to iomap using the ->iomap_begin() /
> ->iomap_end() functions still? That sounds like a good plan to me, for
> v3 I'll submit everything but this patch and the last one and then

Ok, so we'll do the prep for vfs-7.3.iomap (aka to be merged in the
v7.3-rc1 cycle)...

> submit these patches (and any cleanup ones that become necessary) to
> Christian right before 7.3-rc1 gets tagged (which as I understand it,
> is when the merge window is about to close).

and merge these _after_ v7.3-rc1 has been tagged...


