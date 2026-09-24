Return-Path: <linux-erofs+bounces-4600-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB3BC98304
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Sep 2026 04:28:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hr16k2C8yz2yft;
	Thu, 24 Sep 2026 14:28:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790224110;
	cv=none; b=SAlP5GF9/H5ukMFZLr+yz3ypLhpC8Lu5Yn/r6yfnVeeygWakLDhy/dgSTIPtHL89jMvXBDdCvr4fnmatXB02vL4kj3wBB0u04f6/aTQyFkkXyWDi8Vl5OnI73onARIfji3EtOF9Rb4f9E8FiPiAxx6mAkyR9/GS7TzIa8x/a1u+R6CfgKrON2SIi6uO9AUNKnuFHLL3r6px499Pr6dUSdEJUZny6IuZvg+feC4p6zv5+5J9aN/JGxV5D2bQFVHtwMP9HIj6FJ7DFgA+LGZe36ocR0qzuZiWyMynevmgEPOV5mSW7pcAPkaEL0haQhAl3aZkt/b5mkSEZAARvboqTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790224110; c=relaxed/relaxed;
	bh=AMdxEOW2X4XJBSZCaDEFc4BpLNjP8026Li2ryRQqEck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qb4FGi1uY4eOkYjJvClMbZrR1LlM8ZsTJyFIt2EJMQnOAGFT56fpqkwYawHoncY5snkpyJHk2ggIkYJlZ/yR53MXvw9pl0zlE6P/zXlU3KrbrV7gzNxmLn/+vEWgsiO5zLxs+sCVwwiE2K6DbuZXHFeTy58M+L+NMwrvp9Dc2qNZtNSphnE+ix8eMoyKmpHn44jIB+B8AaUpWFdh3yaZkyqJWIGUONxxIFiNpETQxoNr77pzmywlx9S4GS5yuc/h7TGgCfV1bfb6ura3ixmyhpNBj28de0zYXTpoL8pKB6ZI0u78+vypSAzRB7UwRy1fIF8yXTiHmFEme1vz+4hbDA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SsKOx0LP; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SsKOx0LP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hr16j2dH4z2yD3
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Sep 2026 14:28:29 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AC0C601FF;
	Thu, 24 Sep 2026 04:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD291F000FF;
	Thu, 24 Sep 2026 04:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790224106;
	bh=AMdxEOW2X4XJBSZCaDEFc4BpLNjP8026Li2ryRQqEck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SsKOx0LPUddnTdITTUfC64RXC2qfeA9NbyjUFDcQQrY9JvDdrvvSC7gySwBRoyovx
	 GwWroStO9/d6dDCdJHZ/ZGYOUXVcpi53BMCdXZtwPu0JHppiglBWLWy2FsjMGVWce0
	 7b2wmLylMEfThntuhQXH+axgdFxQGBiMaxLhmRlKCEpzaZ9YBG5232qIjhTOuKr9oh
	 lDlbTBsxrRGIcZ6pFUAtG8pJeBDhjdMgbT4+EVxx7T87ZdmOwo/c+o5TPAGDIdZOTX
	 /w/NXsq0wRFDye9JAjIzpk6HIcTCqLl8C7ZNXtL64UhuhAKKmZPzkdCQfZ+Tpe0LvZ
	 08PRMnGUi97xw==
Date: Thu, 24 Sep 2026 06:28:20 +0200
From: Gao Xiang <xiang@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>, Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
Message-ID: <arSm5OXgLD0xkTsv@MacBookPro.fritz.box>
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

friendly ping.. since I'm working on 7.4 cycle too, could you add the
latest v6 series to vfs-7.4.super so I could pull it in too?
https://lore.kernel.org/r/20260812142907.1010046-1-gscrivan@redhat.com

Thanks,
Gao Xiang

> 

