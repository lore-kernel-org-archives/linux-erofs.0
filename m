Return-Path: <linux-erofs+bounces-4033-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F068C54F51
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jul 2026 20:19:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9Nwl2q8Lz2xwP;
	Thu, 30 Jul 2026 06:19:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785356391;
	cv=none; b=SRtAfvZ2oK7jLajbekBAGnZkPC5Z34dTZSppbV0eXBEyQPstfxi+I2sX/LX9UoWMNwhEL/oifaqjf4brHNp8zAqE1vEWFCdlTwKQaLj2pWYyQk3VBnS01jSlqCoju/88SgQkw6sWmyM+Cy4x7Djvy2f1ZRGNVY0KbuqrM62pmBAfAfUOVEX6MwLTkeSDNgpZBBFCM0G6ifPDP9GNgvz0VGP9YkvPYTrWnhqItF2A8u/a/6WWzQPRFOLi4MJHvx8fLJJq+kyQN6udlqBSCzHVMW/D4wdtJC5r67+wNw4XrEZ484CaALj5XVW+5noUPZqopNvS1UJ+wsGqd8xaSq+OCA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785356391; c=relaxed/relaxed;
	bh=WMt7YwCC0dDfpuE1qENmuDfw/kaJXYkfFl7nmsoBBlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eH1GyNnpzcTMzwluFEAhdsu6BRS4UX0GY5A1X+U/HpVpm/kxOVd3Q8sxzSP6w7UcNnFFl7bimZHIpjFrEIw4s7Z6fABe4eMOD5HTw1NUgcau2UHZf4R9Xgl3gvWunsGEvAFo2AjYyCTFY5qtnmQcRWlnXV7wnBkXjiAQHyyX/dyfNG5JiHqjrYkCWjw79wVs3BgJ0CtNo4xqaId/uR426iH1rHO1z0MuZaMwSKfOpoMe1Dm4X1vvFRwvZakX/RqNSYtB2bNh4DEOSFN0bdW/Gaot+IfI8bg+m7Y+fH93uG4Xhfm6A4wZ9VHywKk84B00ymaHUJzUKpWpum+QZcl5iQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0b/oTVX; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0b/oTVX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9Nwk2ytzz2xlZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 06:19:50 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B6B16001D;
	Wed, 29 Jul 2026 20:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1E11F000E9;
	Wed, 29 Jul 2026 20:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785356387;
	bh=WMt7YwCC0dDfpuE1qENmuDfw/kaJXYkfFl7nmsoBBlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z0b/oTVXfDeUmhppYK57JD4ImyHuFukTrqSMz+YA1SL4o5k6I8bfakyQ5hCj6twKK
	 cHqw7pWVvlHTBlwr2zy5V1eUmOtdRA8NgHJ+EHwJIl5s40TBmjYLrIEdu85jAvNPaN
	 QbI2fLdMSKGWMBB2WB8+zBXD251jWwQE9Il1tusrZFfzsp0tzYK64km1GSfhMrI3C1
	 zxH6cj+WGkzHAa55qaH4yI7LK6XtUH3JeyOTTs7kxqHk2sp8GMkHcevgNdB+sXD/Wp
	 SLto1yoiemZ13VJmPVfX61O20TfTxqhyza5eyUjItJxPZy81rPrawxoTsDRkf7AoKN
	 QOBJbypcJwzQw==
Date: Thu, 30 Jul 2026 04:19:29 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Gao Xiang <xiang@kernel.org>, Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, cyphar@cyphar.com,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
Message-ID: <ampgUYqGnEVhqhXt@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jan Kara <jack@suse.cz>, Gao Xiang <xiang@kernel.org>,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, cyphar@cyphar.com,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
References: <20260728160619.853924-1-gscrivan@redhat.com>
 <amlaIt8jjy_mSK-j@XiangdeMacBook-Pro.local>
 <7kgp355d25csimg5txuxhp33zmc5onxpyxdtkarmun62rblp7j@etbql27573dl>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7kgp355d25csimg5txuxhp33zmc5onxpyxdtkarmun62rblp7j@etbql27573dl>

Hi Jan,

On Wed, Jul 29, 2026 at 11:57:25AM +0200, Jan Kara wrote:
> On Wed 29-07-26 09:40:50, Gao Xiang wrote:
> > On Tue, Jul 28, 2026 at 06:05:32PM +0200, Giuseppe Scrivano wrote:
> > > Allow userspace to pass an already-opened file descriptor as the mount
> > > source instead of a path string.  This is useful for tools that already
> > > hold an fd to the image, such as composefs reusing an existing erofs
> > > backing file.
> > > 
> > > Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > > ---
> > > v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gscrivan@redhat.com/
> > > v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
> > > v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
> > > v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/
> > > 
> > >  Documentation/filesystems/erofs.rst | 15 ++++++
> > >  fs/erofs/super.c                    | 73 ++++++++++++++++++++++++-----
> > >  2 files changed, 77 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> > > index 4230884fb359..774e8b236d09 100644
> > > --- a/Documentation/filesystems/erofs.rst
> > > +++ b/Documentation/filesystems/erofs.rst
> > > @@ -139,6 +139,21 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
> > >                         page cache.
> > >  ===================    =========================================================
> > >  
> > > +File-backed mounts
> > > +==================
> > > +
> > > +When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed images
> > > +can be mounted directly without a loopback block device.  The backing file
> > > +can be given either as a path, or as an already-opened file descriptor.
> > > +
> > > +When a file descriptor is used, the kernel resolves its path and records it
> > > +so that /proc/mounts and similar interfaces can still report the mount
> > > +source.
> > > +
> > > +Only regular files are accepted as backing files; to mount an image that
> > > +resides on a block device, use the traditional block device mount path
> > > +instead.
> > 
> > Reviewed-by: Gao Xiang <xiang@kernel.org>
> > 
> > Hi Christian, Jan, could you ack this (`fc->source` filling when
> > `source_fd` is used) if possible?
> 
> Whenever I see a use of d_path() (or file_path() in this case) I'm a bit
> watchful because its result is inherently racy and unsafe. But in this case
> the result is only used for alloc_vfsmnt() which uses it for mnt_devname so
> in the worst case we'll get an unreliable path in /proc/mounts or similar.
> I guess that's acceptable. So feel free to add:

Thanks for your reply and comment.  Yeah, the result of d_path() can become
outdated later since it only uses seqcounts to ensure that within the process,
but here I also think "mnt_devname" usage doesn't really matter (but I hope
filling like this is fine and stable in the long term.)

> 
> Acked-by: Jan Kara <jack@suse.cz>

Thanks!

Thanks,
Gao Xiang

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 

