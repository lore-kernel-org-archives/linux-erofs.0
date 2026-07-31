Return-Path: <linux-erofs+bounces-4063-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE24C54F54
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 13:32:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBRng2RlKz2y1F;
	Fri, 31 Jul 2026 23:32:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785504743;
	cv=none; b=Q18y24SYfNXCFaIaS5NkS/DVPOfPaa7KnT3WhdKbhVbFzdF6bLEn6O3QBOC50P5x3RXUl0axwI3FxNJil5vP0T9V2wjs2SNGFj2N7+5rjhxDgB1xZc5S1snBu2FwNVQeHYs08xEtFT4tRgqcgIJUCRLEiO7Gg74WOFs6cdrLzkLA8Yi+ofQB2tyLmLsieR1jKTy6wMbPtGgCaOUoU7dorsrAFCnL8HYM3nyNVDoghyjs95f4eHe9sfR8ERH4Z9HE89snU2BDuEHnbsOSqbFJJjth3ncB9EUBiJ35EQK5kBMTAp7RrUn7UMBauqfcRa9EYkt2e6QUCJpD1epC/FRGpg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785504743; c=relaxed/relaxed;
	bh=q5ZBFRjSaRWG49SYZwkFXwAI+svIJcrU39TitSzCLBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0XnEFZ5dnkgN/iOrQGMcVclV8dka8Igov7asHxRzzSTMWm5nLUptGu/PFCl6qnHOF3yz1NcN0sxj9D4B1/Euu7VtpGDh3TZ0/GDI4paUInWWZbAtwKPk/3OiOyhiYlWdabS0hVZcw7M2OspCB8iXdXi2SdHklIbWkboga2y4RlNzP5mW749AZt9Qo64STQkRsdF8hsGzPSMxGrELTJrv/N5uADT4uK9nN3V2zzRz4Z4RZDZ7NYRdZ12yHFfsdZidB+6R27GHWb+M/A33KAifzsg3OYpDUMf97mHJh7lE1C4TfFZPcDCp7dwmx77q8Wr7Czv2H6nzlzoxlCd4QUdXQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cghnf9Y7; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cghnf9Y7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBRnf2cRwz2xl5
	for <linux-erofs@lists.ozlabs.org>; Fri, 31 Jul 2026 23:32:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A23DE6004E;
	Fri, 31 Jul 2026 13:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0281F000E9;
	Fri, 31 Jul 2026 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785504739;
	bh=q5ZBFRjSaRWG49SYZwkFXwAI+svIJcrU39TitSzCLBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cghnf9Y7m8MyEdcVdGGtuv0KC9YXXAr1PAJJwjsKSvF36iYMcLbKLJFyiqGYY44TX
	 0Ji9gvJVwsEwrxwTJ/UIOndwlJbbMwf0EsokkC2iRbBddxaTFoM4jmmHc4TllPO1jo
	 EDG4nbpuwJDImziUksRNRSDxW0+hHYWqXI4PVNpdlQJDBNqdiBKv6LLz4k5EXHCe3G
	 PN3cQzIXUxmmKIisdwKmHNpaRfC8cDYq8Z5nDc2BGetjkQZ+BmVNB9NIWse8YD1cOh
	 MZEFkKGADviTAoD2GWXRmE7uPFrYK0UEBKyRCydoL+QHnso3vVVVgXf+e2ZU7kmhW/
	 Pc/207QXqETow==
Date: Fri, 31 Jul 2026 15:32:15 +0200
From: Christian Brauner <brauner@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-erofs@lists.ozlabs.org, 
	xiang@kernel.org, linux-fsdevel@vger.kernel.org, amir73il@gmail.com
Subject: Re: [PATCH] erofs: reuse superblock for file-backed mounts
Message-ID: <20260731-geheilt-launenhaft-lehrjahr-7cc61610ee1c@brauner>
References: <20260730124120.1501126-1-gscrivan@redhat.com>
 <amtJX8aTZT5d_sP3@pedro-suse.lan>
 <8733x0k2p1.fsf@redhat.com>
 <87fr10h2wh.fsf@redhat.com>
 <20260731-geeilt-hasen-demografie-83c895f789ea@brauner>
 <8733wz1ekh.fsf@redhat.com>
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
In-Reply-To: <8733wz1ekh.fsf@redhat.com>

On Fri, Jul 31, 2026 at 03:19:58PM +0200, Giuseppe Scrivano wrote:
> Christian Brauner <brauner@kernel.org> writes:
> 
> >> >>> The time difference shows that sharing the superblock also benefits
> >> >>> the page cache and inode cache, as subsequent mounts of the same image
> >> >>> avoid re-reading the backing file.  This is particularly useful for
> >> >>> container hosts running multiple containers from the same base image.
> >> >>
> >> >> Doesn't this approach break-down as soon as you get to change SB flags (through
> >> >> e.g mount -o remount)? It will change superblock flags for all of them, right?
> >> >>
> >> >> (I don't think you can switch off the superblock transparently on a
> >> >> reconfigure?)
> >> >
> >> > This is the same preexisting behavior for block device mounts.  That
> >
> > Yeah, and it sucks ass. :)
> > Only an incompatible vfs-level RO/RW property causes a silent reuse to
> > fail. Otherwise it not possible to detect that a superblock has been
> > created and requested mount options silently ignore.
> >
> > In other words, doing this unconditionally is incompatible with current
> > userspace.
> >
> > Btw, I added FSCONFIG_CMD_CREATE_EXCL for this reason which refuses to
> > reuse an existing superblock for filesystems that would otherwise end up
> > sharing a superblock. This way userspace is guaranteed to not silently
> > get filesystem options ignored.
> >
> >> > said, I realize this can feel confusing since EROFS is not a block
> >> > device and allowed this so far.
> >> >
> >> > One way to solve this could be an explicit mount option "share_sb" that
> >> > is opt-in and, once set, blocks any remount operations.  Would that
> >> > work?
> >> 
> >> Would something like the following fixup on top of the previous patch be
> >> acceptable (suggestions for better names are welcome)?
> >
> > The patch as written still means that a task A creates a new erofs mount
> > with for file F and marks it as shared. Another task B creates new erofs
> > mount expecting to get a new superblock and will end up sharing it with
> > task A instead.
> >
> > That is still quite the behavior change and could be used to subvert
> > workloads expectations and be used in (odd) attacks.
> 
> no, my suggestion is that task B gets the same superblock created by A
> only if it also specifies share_sb.

Yeah, that works.

> If the option is not specified, as is the case for existing workloads,
> then it gets a new superblock even if A is already mounted with
> share_sb.

Sounds good! Ship it.

