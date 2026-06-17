Return-Path: <linux-erofs+bounces-3657-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E56CD98F0
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Jun 2026 03:17:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gg8DB1SL6z3bqh;
	Wed, 17 Jun 2026 13:17:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781666234;
	cv=none; b=KOtnvHjhKqt0S5RTXpicZdZnb1xG5CuEUfjcI6IHiqEon/5hGHq97XUp5G1E8+MpJ9Z5W0ep7YcY4mg2wucwogHiKqVAashCLcZTEq6Q+ZKfUQyIxroQ1LaQxRxJCchCFxnj03teJ03OOk6u4YjJPKGP6w2otnJLOuU8yWIBhPFkBjeJbPoQvBy5czBh+8uLTUMpXHsNYDu2Ng+EfdbElJrDuJw5Ob0GlXGF4TPryhIJ5c5h9VuUlLYCYl4GbKfzR2aMYO/zHd4Hsso3YF0aeAF8bx7B3pui80t7UL7GWiliIT2wlinNeUoi7mgGhFTDdNyZYv8W9A+kiUoUXUMXVA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781666234; c=relaxed/relaxed;
	bh=/XxQiTXNtmMZZ+42Z8EigCzrFqlmyJmwNpk/XdekBPQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=K2V4JIMgxZPS9jhKtE/FWZJ5ZLOFvD8khBha/CrsdY2sm2L7kO1RLiIugPWIGzY4l2qBi6Ny4QqQKrPetfQ7P+jbgW4qobVyadPx/BWKP52l33qAj71xrIcEtXW40vVBBsLpetOxCVOnZxhFLeoNwZk7RNShUcErMPKpymxP6lRlTCiQntVcp+QCFSdTVkkONRik/NEcDyyNJMgy02VyJBMIsPjPuOIqdYfvAEta1P6hbkPKaYrwA1zFCxumI982wV/rNc7ox+dXba+Jnj1GzfFmCzFbUbljWGA3Tf2S8QfCbW1BD+KL2lGerxX8yNsRL4k/yvVfil7Kp9dICxQt6w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DALtP9L0; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DALtP9L0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gg8D912zVz3bpP
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 13:17:13 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 937AF43C3C;
	Wed, 17 Jun 2026 03:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE99A1F000E9;
	Wed, 17 Jun 2026 03:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781666230;
	bh=/XxQiTXNtmMZZ+42Z8EigCzrFqlmyJmwNpk/XdekBPQ=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=DALtP9L0p8+aUXxiIcMFKZv2rjiLUWzBIvBPlQEsPhx+JB6U1kt16NZbokcqsY6Ku
	 kI0vvEqBJu0k2wAT8WwWo1kkS8BIcegPyV9JNf+yOim12kDqg6o5KlfY0eg5FyQDFu
	 Y65s3EdSdcAc2iswoIOtP49uLt85K27I4qn9o3fG//A8IGVY8ZyIIArRb9SceLiFzY
	 5OdNg7da6E6ucmkp1Ws/jRfj6m+QU+aWlxGuOM56R003iYlM4ie9Rerf4Ct9HvTBk1
	 0LcQlYaH8Uvwn9oIJlWOkqc/KXYGLksTwj0AqseE7mhVF1WKH9rQ96EXUltheg0iEP
	 jSAU4Oa1Yqkog==
Message-ID: <77870acc-63a9-4408-a45c-2ec634ebf593@kernel.org>
Date: Wed, 17 Jun 2026 11:17:04 +0800
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
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 15/18] f2fs: open via dedicated fs bdev helpers
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-15-7df6b864028e@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-15-7df6b864028e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/26 22:08, Christian Brauner wrote:
> Route the extra device opens of a multi-device f2fs through
> fs_bdev_file_open_by_path() so each device is registered against the
> superblock, and convert the matching release in destroy_device_list()
> to fs_bdev_file_release(). The first device aliases the main bdev file
> opened by setup_bdev_super() and is already registered through it.
> 
> f2fs opened its extra devices without holder ops, so a freeze, sync, or
> removal of one of them was never propagated to the superblock.
> Registering them wires those events up: every device now freezes,
> thaws, syncs, and shuts down the filesystem like the main device does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

