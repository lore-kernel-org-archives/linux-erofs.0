Return-Path: <linux-erofs+bounces-4079-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28940C55171
	for <linux-erofs@archiver.kernel.org>; Sun,  2 Aug 2026 13:01:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hCg0d3NrFz2yh4;
	Sun, 02 Aug 2026 23:01:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785675665;
	cv=none; b=iN3IaBohQtJdnxhYahIFjB9LT6QCRxlKXz6I6KvGABuyUGVCf0sVbfdYc0Sw5sOSNgv3xEH+wWu0b3ohyNYuobBVl9O3taxaxey3JAIuBrfWXdT/Cwbs6YYFg1ki1xGrgyBjDXZxOxMvmZjuhHk2pDgjfV3GxPW9Zkr5NAfOMJE2U++qXU9/v708KZxw5JjBWmBACQ0epi0AtqGoiFs0XpYFXvD6gpx5f7PSnku5Ow4nynjyw2Ye+oCN21jG3LgbnXVb1BL9ZP5O4kQpH92U2KXlunKIY4YZSeClWeLnyRSX3egu0GGmrWUxZUApTKdtcrwjkfylAZgnDuBHIprtzw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785675665; c=relaxed/relaxed;
	bh=Ti8hTGYrXPv1qMc2UPYlcwt7l5qaR4ux1Y49tLdd8NU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQ9kJIz5MA/oc30N6SdV4xNUlUP2lHJEp+M2k2FB5FFWK0imxdYDHVxIFJlQ+Q2Aw4Dm/Q2CIARGY2LO2uZcRq2cvvyJW0kXINy6AEHq02wG09TQ3WrJ0FBnNCYpgW+Vx+Yu/twbffVqgfOzKRGqZ8A5z/1o6mvGsuKSP0O/+b1Zp2Cp6lQvIgobplATbJMRNO6jCNhd+T8qwG95cQAneje30NTymso73YVNx7bwAHVEcak4QywKlCiCeZ69j4Sa6O8E0vvzN3t+r1nedrBJVczHxcge4XsNuzd/v+MwN9hgx2K4lWP/QFEBdUfbpzk7kKRT8Cfc+YHBrM4cE87x9g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G9IHRpJQ; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G9IHRpJQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hCg0c65X6z2yN8
	for <linux-erofs@lists.ozlabs.org>; Sun, 02 Aug 2026 23:01:04 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE1FE60DC3;
	Sun,  2 Aug 2026 13:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA811F000E9;
	Sun,  2 Aug 2026 13:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785675662;
	bh=Ti8hTGYrXPv1qMc2UPYlcwt7l5qaR4ux1Y49tLdd8NU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G9IHRpJQt0ReKswpGIuPP5oSLMaJaIjg0tyuDHTWofEGO4cRSCPMJoBRf8wTRnrZ3
	 B2graoxyf6bxevRji0UM2JjKApjdfffFHvLu+bZbJyt1BZ2ExXozoKH/yuQNdEfePh
	 FUOAmVKaISXVE8yUDazrjMwc0Jg7367k7DJBJ1JOywAmNO+2kB6KeJ4r5UlC/97x5U
	 eHsFhlp70Tq8XgH+YJS8LfDEQ+PuSG/qv/N6m0S46fo7AI99iBwk3UhRLs9c21EtQ7
	 E+ivASGFUaVHppdgs6tyH1bqQWidzavj3cdNqH9Zn7i3x7MAO4Xq/MQHXufcCxBIpF
	 REESPrbyuWFKw==
Date: Sun, 2 Aug 2026 21:00:56 +0800
From: Gao Xiang <xiang@kernel.org>
To: mike.malyshev@gmail.com
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH] erofs-utils: lib: follow symlinks on intermediate tar
 path components
Message-ID: <am8_iD0g9yTj2B1m@XiangdeMacBook-Pro.local>
Mail-Followup-To: mike.malyshev@gmail.com, linux-erofs@lists.ozlabs.org,
	Gao Xiang <xiang@kernel.org>
References: <20260725150920.1900298-1-mike.malyshev@gmail.com>
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
In-Reply-To: <20260725150920.1900298-1-mike.malyshev@gmail.com>

Hi Mikhail,

On Sat, Jul 25, 2026 at 03:09:20PM +0000, mike.malyshev@gmail.com wrote:
> From: Mikhail Malyshev <mike.malyshev@gmail.com>
> 
> mkfs.erofs --tar fails to convert layers that store files underneath a
> symlinked directory, a very common "usr-merge" layout in RHEL/UBI/Fedora
> based OCI images.  For example a base layer contains
> 
>     lib64 -> usr/lib64        (symlink)
>     usr/lib64/                (directory)
>     lib64/libc.so.6           (regular file, path goes THROUGH the symlink)
> 
> erofs_rebuild_get_dentry() walks the path component by component and, when
> it hits the "lib64" component, finds an existing dentry that is a symlink
> rather than a directory.  Since there are still components left to resolve
> it bails out with -ENOTDIR.  In practice this surfaces as a bogus ~2 TiB
> image and "Could not format the device", making the whole layer
> unconvertible even though nothing is wrong with the tar.
> 
> A real filesystem (and containerd's walking differ, which applies the same
> layers via fs.RootPath) resolves such a path by following the symlink to
> its target directory.  Do the same during tar rebuild: when an intermediate
> path component resolves to a symlink, follow it to the target directory
> (relative targets from the containing directory, absolute targets from the
> tree root), chasing chained symlinks up to a bounded depth to avoid loops.
> 
> Signed-off-by: Mikhail Malyshev <mike.malyshev@gmail.com>

Thanks for the patch and sorry for late reply.

Yes, I assume containerd will resolve the directories like this, but as
a quick reference, could you give some pointer how `tar` utility works
and `posix` documents this behavior?

I plan to release erofs-utils 1.9.3 without this patch soon, and it can
be addressed in erofs-utils 1.9.4 version.

Thanks,
Gao Xiang

