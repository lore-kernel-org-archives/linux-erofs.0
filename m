Return-Path: <linux-erofs+bounces-4476-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E4AC624DE
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Sep 2026 11:24:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbvJS4P41z2y2b;
	Fri, 04 Sep 2026 21:24:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788521096;
	cv=none; b=PmAIBx3PZEXv5USAPfscOLWkFyBbdc0MnlhDcrdMCOEY6cCH8g2Lp8D6pAV6cJ542fG+AUPQYB7FRhutVN/VAwsf9GYjsZXu26q3Wiqjp60M+yS30+CBzTVf5XNtB87vQNf1k1fIryMZsCRq2eY1uCuJt5KS8qG0bY+jxqThkBqzHEqCb79U5SnR+whDQUqR65nhrKX3Ko/z3NE97ADKuNwAFlKbOJNJ9k5QV8Okhf59/Bdc0XJOg+c021psmBs9Q8nv5yi0oPz2XDw6e7zEKcfLYvVny4zo+LYQAUi3oafD+NFZMqxrEDU3CFwZSm7Gxzo9t306MnMFUz/mBjDjUA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788521096; c=relaxed/relaxed;
	bh=wXAIsUMk6gu3wwu/1M3hOnT8S9NxPfHi8QsU5OdBIbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RczGSnnQ+ZigrcMH6Ib4OndtToqEBvcC0A9smV5wpuEhFwvlbE0K7d8MEBlZZxryg7I0NEAROd8h1BXUDtQ1kxDAoVtpZzTm/qmZBXmLe0YoMgh10d91dbLkh3IOmRjR4m+63ehg7+QH/71ZYtCzXBvuzk+KDeVwrW+5IfNb5rpYuFUOZjT3YQPsifXx1leKn9oxQv0aEZmEs116bS8+qmIOG2kFUhecGWVv0GXz6EW3Rk3tHgeDrSJmkdaG75EWQE9LpDt/rJebPAtJBS6FOonWrHXy6Q5+DB64pkakKVWAIh8mGAD09sL+ZuSY9OAAQiOv68eE4qpN0MPjcxbzJA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YPnynVv/; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YPnynVv/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbvJR1tmPz2y2M
	for <linux-erofs@lists.ozlabs.org>; Fri, 04 Sep 2026 21:24:55 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60E6D41ABB;
	Fri,  4 Sep 2026 11:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895551F00A3D;
	Fri,  4 Sep 2026 11:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521091;
	bh=wXAIsUMk6gu3wwu/1M3hOnT8S9NxPfHi8QsU5OdBIbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YPnynVv/AHbmOvM8ZdOZ0XH2A7JtrvOSB9ti3omM/ULbFnHcu+wyiJy1s/WFTp6zR
	 dr1OkV2xD3jHqNo32aP54joa14OhXLnHzCjTFpUIw9ZxjOnMxpWySXV9KvT7MsvyzL
	 C7CqTuP3GGES/FK0TA7fOnBKNyGqMa82XPhjGM42Pzgs5dYbumRBh/SrYA0rHnlZnU
	 BZxN3xcAUQv7w05JfWo8WhXHChRTGtFEuVcAqWX9XODfRk528Lyn4/dYwUJKRrLztD
	 k7rj9tSl6CjjkF5UhPJmHUquuZh9crQb/yaS28v8OM9RbJrMB7DeO9L3rANgTwrPQG
	 eTi9qwygZKzPw==
Date: Fri, 4 Sep 2026 13:24:45 +0200
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 08/18] fs: add dedicated block device open helpers
 for filesystems
Message-ID: <20260904-angedacht-hausrat-gebilde-69b0b13b5d3e@brauner>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org>
 <20260901221314.GC6038@frogsfrogsfrogs>
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
In-Reply-To: <20260901221314.GC6038@frogsfrogsfrogs>

On Tue, Sep 01, 2026 at 03:13:14PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 16, 2026 at 04:08:24PM +0200, Christian Brauner wrote:
> > Add fs_bdev_file_open_by_{dev,path}() and fs_bdev_file_release(). They
> > open the device with fs_holder_ops and register a claim in the
> > device-to-superblock table. Claims on the same (device, superblock)
> > pair share one entry, so when a filesystem claims a device it already
> > uses (xfs with its log on the data device), no second entry is added
> > and each superblock will be acted on once.
> > 
> > The holder argument remains purely the block layer's exclusivity token:
> > a superblock, or a file_system_type for a device shared by several
> > superblocks of that type. The shared case only becomes usable once the
> > fs_holder_ops callbacks resolve superblocks through the table instead
> > of bdev->bd_holder.
> > 
> > Convert the main device, setup_bdev_super() and kill_block_super(),
> > over: the open finds the entry registered by sget_fc() and claims it
> > again. cramfs and romfs bypass kill_block_super() so they can handle
> > MTD mounts and release the main device with a plain bdev_fput(), which
> > would leave the claim behind: the (dev, sb) entry would never be
> > unregistered and the passive reference it holds would keep the
> > superblock alive forever. Convert their release paths in the same
> > step.
> > 
> > The frozen-device check stays in setup_bdev_super() for the primary
> > device and is added to fs_bdev_register() for new claims, i.e. every
> > additional device a filesystem opens through the helpers. Only a
> > (device, superblock) pair the superblock claimed earlier may be
> > reopened while frozen (xfs with its log on the data device): the freeze
> > already covers that superblock through the existing claim, so nothing
> > escapes it. Without the setup_bdev_super() check a device frozen before
> > the mount even started (dm lock_fs, loop) could be mounted and written
> > to (journal replay) under an active freeze, because the primary open
> > reuses the entry registered by sget_fc() and never takes the new-claim
> > path.
> > 
> > Both checks read bd_fsfreeze_count only after the entry is published
> > (by sget_fc() for the primary, by fs_bdev_register() for new claims)
> > and pair with bdev_freeze() incrementing the count before walking the
> > table: either the mount sees the elevated freeze count and fails with
> > EBUSY, or the freeze finds the published entry and converges once
> > SB_BORN is set.
> 
> Hmm.  I /think/ this might be causing regressions in xfs/006,
> generic/311, and xfs/264 on XFS realtime filesystems.  Each test fails
> with a mount failure due to a busy device:
> 
>  --- /run/fstests/bin/tests/xfs/006.out	2025-07-15 14:41:40.170403463 -0700
>  +++ /run/fstests/logs/xfs/006.out.bad	2026-08-31 12:25:01.790239078 -0700
>  @@ -6,3 +6,7 @@ error/metadata/EIO/max_retries=-1
>   error/metadata/EIO/retry_timeout_seconds=-1
>   error/metadata/ENOSPC/max_retries=-1
>   error/metadata/ENOSPC/retry_timeout_seconds=-1
>  +mount: /mnt/s: /dev/mapper/error-test.006 already mounted or mount point busy.
>  +       dmesg(1) may have more information after failed mount system call.
>  +umount.nfs: remote share not in 'host:dir' format
>  +umount.nfs: /mnt/s: not mounted
> 
> I'm not sure what's going on here, but dmesg has this to say:
> 
> XFS (dm-0): Invalid device [/dev/mapper/error-rttest.006], error=-16
> 
> So my guess is that the SCRATCH_RT volume isn't getting unfrozen
> properly?

That's a pre-existing that this series just made obvious and is fixed by:

fe967191e585 ("fs: don't return -EINVAL for successful nested thaw")

The realtime dm device doesn't get unfrozen after a lockfs
suspend/resume cycle.

So xfs/006, xfs/264, and generic/311 wrap the rt device in its own
flakey device. That suspends data then rt with lockfs and resume rt then
data. So the rt thaw is a nested thaw.

A nested thaw drops the reference but thaw_super_locked() still returns
its -EINVAL because it's still frozen. So bdev_thaw() keeps the count on
error and dm unlock_fs() ignores the result.

That's been broken since 7366f8b6fc6a8. Before this series it was merely
silent on the rt device. We properly refuse mounting devices that are
frozen not just the main device.

And it also meant a second lockfs suspend of a leaked rt device never
froze the filesystem at all...

