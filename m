Return-Path: <linux-erofs+bounces-4195-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E543C5B572
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 15:44:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKGC336B9z2yyJ;
	Wed, 12 Aug 2026 01:44:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786463071;
	cv=none; b=WiXCPvFk2Fr+EF+ZDMzMks5cNf42YY3vfOi6v8+nvkB6GLxEBMTa2PEOrzcgGgEBGexHQf5o1OP5wGIadNtgQFnLf+3G8Sf7xlbhHLvOyyYPix/XdTUELym1kK7gd14yqCpi4+YbtFftDlvPi/g9pZpbmKSa2d0zxC/8HqR4Oxn92Oq2lKqRPgLM00jDlokyTQbjRv38dkA70YeUMLrH3FfEDdaqScJ+BntUKYJoAfNWpxHdFmjiGLwf4Oqob3oBqAWbO7oEFXSmLnhdKDagcUhfoEwMn13XE6PVsiW9OM/ip+BZUZ2NggkyVsfrnRHcnnfUAcv7i9Swygg3WcSl/w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786463071; c=relaxed/relaxed;
	bh=CFBgsLHMpPk8z90VQkLH1K1Iex607Whn5k4Eb5qr7XM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dp1iWd2j5A+ZoYjT7li6XwNALz5quwvVzoizxxQ4H/eq+TQGwAXwjRczC4bkUsa/dqMW9b6GpQz6beIQdA+zfO7tKq2jedbopJPxiRaZaeXV9Gm1dY8Mul0OpWPuWw45Nb2JyVCJG4qHTJHB4T7kNleXC9uS/B+Yj+zuWK7DYirFMeROjULoPvABJ+XFf/0+aSnv9aup0t7QFH6YXuqjAEigapyDqLIoHDnhSCIttZ0f4JAayOEEM5p1euuoQ1AN/jzdPh20zlvCUwGrELX3zj4Sq4p2Gj4xg6GHNvh4s2euSkxT930NuJZ5LLhZCIFICeTNAE3ZIaoGk2UknyTUhA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OJF9ag/l; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OJF9ag/l;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKGC24Grpz2yrC
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 01:44:30 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E33D741492;
	Tue, 11 Aug 2026 15:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88301F00A3A;
	Tue, 11 Aug 2026 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786463067;
	bh=CFBgsLHMpPk8z90VQkLH1K1Iex607Whn5k4Eb5qr7XM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OJF9ag/ly6TENKVM8oiFA9gGHVKCGFwbRuWP1EfYJ6oVLY7jHA1zSQ6K+z1EhuBkz
	 iOld8msMy2q3SBlka354waQFjFQluZL8xEZ2lTfgOARK7O+YXpdxVWNGKO1v5Tqhwc
	 DvmLB6O5NNjnONTFUKTVSEzkBq6Qi9gl6+y4hmhcvp6YNOrKLXAGiapJQXplQzVW8N
	 7o0GWt2oq10XvUzaJt25nAlSe1Qt921fU6h4ClbRiTVFr2dUDZLiYmkoug6OCWyLxj
	 dg0tCaFwd1tjFE1W1pRN6tP60Q6IKaUThH5iidgTbwtnMefmcHfImvgPr0mfiEAo1C
	 DypUfnjH/MXjg==
Date: Tue, 11 Aug 2026 23:44:20 +0800
From: Gao Xiang <xiang@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
Message-ID: <antDVPzz0tbn2kTU@XiangdeMacBook-Pro.local>
Mail-Followup-To: Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
References: <20260811071241.389589-1-gscrivan@redhat.com>
 <20260811071241.389589-2-gscrivan@redhat.com>
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
In-Reply-To: <20260811071241.389589-2-gscrivan@redhat.com>

(+ cc vfs maintainers)

Hi,

On Tue, Aug 11, 2026 at 09:10:50AM +0200, Giuseppe Scrivano wrote:
> vfs_get_super() already implements the common get_tree pattern of
> looking up an existing superblock via a test callback and initialising
> a new one with fill_super otherwise, but it is private to fs/super.c
> and only reachable through the get_tree_nodev()/get_tree_single()/
> get_tree_keyed() wrappers, none of which let a filesystem supply its
> own test callback.
> 
> Rename it to get_tree_super() and export it so filesystems that need a
> custom superblock matching policy can reuse it directly instead of
> open-coding sget_fc() + fill_super().  No functional change.
> 
> This is a preparatory fix for the next patch.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

With the new vfs_get_super() helper, it seems much cleaner compared
to the previous versions.

Since this series interacts with the other erofs ongoing patches.
So I hope at least [PATCH 2/2] can be routed into the erofs tree to
avoid unnecessary conflict resolving.

Maybe the simplistic way is vfs maintainers can ack this vfs patch so
that both patches can go through erofs tree for the next cycle
directly.


> ---

...

> +/**
> + * get_tree_super - Get a superblock, optionally sharing an existing one
> + * @fc: The filesystem context holding the parameters
> + * @test: Comparison function to find a matching existing superblock, or NULL
> + * @fill_super: Helper to initialise a new superblock
> + *
> + * If @test is non-NULL and matches an existing superblock, that superblock is
> + * reused; otherwise a new anonymous superblock is created and initialised with
> + * @fill_super.  Passing NULL for @test always creates a new superblock.
> + */
> +int get_tree_super(struct fs_context *fc,
>  		int (*test)(struct super_block *, struct fs_context *),
>  		int (*fill_super)(struct super_block *sb,
>  				  struct fs_context *fc))
> @@ -1278,12 +1288,13 @@ static int vfs_get_super(struct fs_context *fc,
>  	deactivate_locked_super(sb);
>  	return err;
>  }
> +EXPORT_SYMBOL(get_tree_super);

btw, some people prefer EXPORT_SYMBOL_GPL() for this kind of helpers.

Thanks,
Gao Xiang

