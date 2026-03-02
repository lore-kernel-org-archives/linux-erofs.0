Return-Path: <linux-erofs+bounces-2456-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064DFEA4E04
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Mar 2026 13:51:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fPgM221X6z2xc8;
	Tue, 03 Mar 2026 00:51:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772459470;
	cv=none; b=itpbcDxHtCNEOXxfHaws+VkbsZvNXVAzJZzDvLgioeSboHSxVDNuEly1ehSKekduZFOAK4Gx16aAtoxCiBjFrWf4Js0tJhWrmWPuCG6Nrm9BuBMDhgZ7X6cWMh/MawD+V8JJdP9XOPrKCSVgyqa9itZK0r/CERWwVNnUW+hGjr9ScqrFOYdLroJRzbEvYRgi5vztAIGn8LKgveyJZ8Zi4OBa111llK4Q6Lpvi2WeDHYgub3hUK/eQ0GPsOw5pHL1g8WNd9x7L+Amh7b092ojrU5RaBhU+5oFuvNNTqOdHuGtwaxJRfa3WddvVAnkqzv1t2wmfI7o3/pkQxHzmDupvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772459470; c=relaxed/relaxed;
	bh=0mxOV7omutuRZu2xaV3AtdtQohZwv5xm8F7gjTBJ59Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKGi+v/aTmSvO6dMpGJDdrpS9LknH36qboXVhfwdI0IbfouMT8iQuTAaMh+1d/fkBH8QFv0pU/NEaRObb94FJWuDa/pDftlIbSb5sDOJC4YVjGfHnwpnMzXLF+WOUJH/+BOryCOSLCXyH84bnsOxwkOvjqfJ9YG2Zvp2qfPW4kP/vFGuu23Qb0y/ME+VLF5bfOBOphSiOwVh3/fpqvF3pMJThBaRZ/KdEjfwq3Uvf2PZzqNO7zheq+C4ugDL5SBVUOs3hN4RxeQ3iJ5rbsv7EA699hHhAi106Y83sUDrOiQlEy7VC8vLmYej2eq2jWG/oH0jehpm41PAqP0zmpAAaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=t9FoqLVN; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+ce5019daea4c3780914a+8226+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=t9FoqLVN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+ce5019daea4c3780914a+8226+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fPgLw3H4Pz2xGF
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 00:51:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0mxOV7omutuRZu2xaV3AtdtQohZwv5xm8F7gjTBJ59Q=; b=t9FoqLVNqtepR+hrSxb7DbRRW/
	ZEx/KAh3QPrXU9qH4AEFUMbbhSfoCIIS39yTzAfwZMdnXRn14QDzmT4c7ioUu7OdAJpPYhFIe/b7K
	4vy0fepxNw5kD67v7lgefavzXh0P0JjwKevMmcIkjXVfUWYlEZ55VH8qlUaF8/yZ+3YkbVx1Txz3m
	PFqH98KUC8WqrfNY7ItimnKHUm+G//woU6ICgtGA5R/mZIrwRK2F8ubn0L2uXBW+r6HR878wlftM6
	AmFx+g+vGqMyrWQjLlLHmK9kGab2HHHITzv6WnBN2ABtm4/SzBBGC4gJ3YqdTbW8/O4i/+CWuXYdR
	wjYc74hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx3fk-0000000DA78-1MN6;
	Mon, 02 Mar 2026 13:50:56 +0000
Date: Mon, 2 Mar 2026 05:50:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: jiucheng.xu@amlogic.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, jianxin.pan@amlogic.com,
	tuan.zhang@amlogic.com, Gao Xiang <xiang@kernel.org>,
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] block: avoild hang when bio_list is non-NULL in
 submit_bio_wait()
Message-ID: <aaWVwH_Xna22DTAq@infradead.org>
References: <20260302-for-next-v1-1-eb9339e8dc99@amlogic.com>
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
In-Reply-To: <20260302-for-next-v1-1-eb9339e8dc99@amlogic.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 10:51:03AM +0800, Jiucheng Xu via B4 Relay wrote:
> From: Jiucheng Xu <jiucheng.xu@amlogic.com>
> 
> When current->bio_list is non-NULL in submit_bio_wait(),
> submit_bio_noacct_nocheck appends bio to bio_list but skips IO
> submission, causing submit_bio_wait() to hang indefinitely.
> 
> Fix this by temporarily backup bio_list, setting bio_list to
> NULL before calling submit_bio(), then restoring bio_list
> after submit_bio() returns.

No.  Fix this by not doing something that is a bad idea.

> I've trimmed down the call stack, as follows:
> 
> f2fs_submit_read_io
>   submit_bio
>     mmc_blk_mq_recovery
>       z_erofs_endio
>         vm_map_ram

->bi_end_io code really should not be having random in_atomic()
checks that make it completely different, but even if they have
that need to use GFP_NOIO.


