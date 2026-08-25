Return-Path: <linux-erofs+bounces-4341-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14585C61DBE
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Aug 2026 13:08:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTp4B20Jpz2xKh;
	Tue, 25 Aug 2026 23:08:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787663290;
	cv=none; b=dGQJXfxke94qeILJc0JpKl5AGrCMfK2GhHB+NhBHoFSvEvxT5Uj1t8SCx/LfZIaQ2uBTajmu+W8Na5VDusf5qawT96uDIqYFyBJ1TN3Q3BV6MF18RVpUufgHau69FZo26l6Px0AXO/SBdRzARIpcnNnpqnou11lxmhYpMaxalwn+n+yK9xsN5c3fy4fFiC5SXQ59XE8d6fwIzFP5X0S/ye4BqW5bTmBnd2vZezHzCGALYTN7X0vwyTshUyXygPyMf1o9gg4cBSn5CEiszX6ntCKdBGxRdgkwPSFYKChAZyQ3f9rPi6ueeuK1RUB9tN5aMayVwQvaotn4B7JlGHaPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787663290; c=relaxed/relaxed;
	bh=e3Z35nT9ig35NqUBVaCr/ENh+yH0JwTsr32Pd2D9w54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSF/By/sgMHNZoNTACxpi9cuB63GYzwrmSuucTmzwarZAJbnA7zGE0dkjLEtBktN66mHZV7BQq3K2VFtjyD68b5lN0wLpK8RGji6rNHSNGV/Y12wos2SzRoM7ZQQPw8xCQN/jV5O/OPQhIcH4xhyAs7JRPjbz6EvqhXznMWNrffuCR8p03LvW1xgkuX/E5CNzBV77Ia5wxsm+GJS0k2/GaRBhcpNpV3xX5EQ28ejtsGaaC9JnUdjq216sh6d+/d6vJl7+T07plJWA1uYjBWtIXybycNQXnXcGdBQw0AVQkOcZMvPiTarHxr+488CQOD2LSz8/CQNXPfLdvTI5U0DzQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXnEpZwn; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXnEpZwn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTp4937syz2x9g
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 23:08:09 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F0436011F;
	Tue, 25 Aug 2026 13:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B771F000E9;
	Tue, 25 Aug 2026 13:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787663286;
	bh=e3Z35nT9ig35NqUBVaCr/ENh+yH0JwTsr32Pd2D9w54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WXnEpZwna6XBIwOC66tzfPeEqnNYCgsl+javvuC4rprU5QEztq5VTzsDjj27t08B1
	 oM0d4FPhOfsOUiHVQIXWRIb3xFVViashnMze2/ufIt8iQ8yWv8Qb9zPT0eovGBd3bq
	 18gf8k1BG8eAmMYEPsLQ1TQbYm89g3rnjg19/Fvi6magr2hAGp9GWIlNf0jPyMDFC4
	 +EfiM7n6DWqBDUkF/hqUICBz5lOh0fUnMyCRjK2jhqybKHJCN4crHUmsg7kAft74iu
	 fWamfqeZ5Us1lMnZanBkKEUbPDGCxDT3v2F5Tq01r9n2kaCHQJWO7nGC3aSLXgdFOl
	 EmsYS98lOa4wg==
Date: Tue, 25 Aug 2026 21:07:59 +0800
From: Gao Xiang <xiang@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>, Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
Message-ID: <ao2Tr6HQoVFHmRaq@192.168.5.19>
Mail-Followup-To: Christian Brauner <brauner@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
References: <20260811071241.389589-1-gscrivan@redhat.com>
 <20260811071241.389589-2-gscrivan@redhat.com>
 <antDVPzz0tbn2kTU@XiangdeMacBook-Pro.local>
 <20260825-gorilla-zuhilfenahme-unfug-4b81185496a3@brauner>
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
In-Reply-To: <20260825-gorilla-zuhilfenahme-unfug-4b81185496a3@brauner>

Hi Christian,

On Tue, Aug 25, 2026 at 02:32:48PM +0200, Christian Brauner wrote:
> On Tue, Aug 11, 2026 at 11:44:20PM +0800, Gao Xiang wrote:
> > (+ cc vfs maintainers)
> > 
> > Hi,
> > 
> > On Tue, Aug 11, 2026 at 09:10:50AM +0200, Giuseppe Scrivano wrote:
> > > vfs_get_super() already implements the common get_tree pattern of
> > > looking up an existing superblock via a test callback and initialising
> > > a new one with fill_super otherwise, but it is private to fs/super.c
> > > and only reachable through the get_tree_nodev()/get_tree_single()/
> > > get_tree_keyed() wrappers, none of which let a filesystem supply its
> > > own test callback.
> > > 
> > > Rename it to get_tree_super() and export it so filesystems that need a
> > > custom superblock matching policy can reuse it directly instead of
> > > open-coding sget_fc() + fill_super().  No functional change.
> > > 
> > > This is a preparatory fix for the next patch.
> > > 
> > > Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > 
> > With the new vfs_get_super() helper, it seems much cleaner compared
> > to the previous versions.
> 
> I'll add this patch to the vfs-7.3.super tree post -rc1 and then you can
> pull it in. Thanks!

I guess you meant vfs-7.4.super? If yes that would be fine, I'm willing
to land this feature for 7.4 too.

Thanks,
Gao Xiang

> 

