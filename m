Return-Path: <linux-erofs+bounces-4368-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C23C61DD9
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Aug 2026 14:52:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXJBZ6BxBz2xlZ;
	Sun, 30 Aug 2026 00:52:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788015142;
	cv=none; b=Zp7CdPw1nQ/Wq4NtmQCYa4D/emyBoU/1lYhHMbCfuU6gST+WFdO4oC0ro3dlVh3Jl9R5HghjEu3mzKRJHwxsg5DKuaBQE69qYtAk6L9y1FDsC/7yZKbGCrm3wagWEXGeJfLG1rvLAiV16DMojOCqfNKtvC5BPe7iCNjvVIT1sVguVCpBKybem36Qfy+JCwoHVZlI9eER4FeqL+Ez8AKOSdPi+lbUDeNU1rSXx+JgqXNyVNZy67yI4tZNMoA8hs0LbWs8h0IBpKBY3igbscjNf6TKW8KaonPUyFXDde9h4HQhDN3nMj2n1e4LUs9VE4AMDd0fEWK5gZDsu0F2pZVTNw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788015142; c=relaxed/relaxed;
	bh=Bx10bEY/grytVZ3FAi9tmQtowXP7McpUMX6Ne8Ta2yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4w1c01Rs6I9c5NS0Sdz/72nRtaQXAe1yCz7StTvlD9no9mX+bKbO63MUfFIH4uyYVesCEuYOybRwsjqg/gCo7irprvg2PDnLbQ4ie1V3gzRK0bGrXthzXiGG67soDiw4oouaAPJ+Bb/nm1uMGbmEuvDm9fKue6bBBGOFjirMcBj5GAwOuP5sHrx3ZlbDa7bguBVMwpHFIr56XVfx//sMxO/ToLeIxOHEBOmSTe31e0op4jmjlkqqezx/g14Qs0dUhldSy31m4aPv8moKcQ/LnzvKfh5HgjKcYPzO2jQNlt3X3jMtzZwiUu9XkSNPO6n+kLRvVmAYVX+Tjs1gHlThQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yyM1OyiD; dkim-atps=neutral; spf=temperror (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+43861feed20c552e5b26+8406+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.helo=bombadil.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yyM1OyiD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=temperror (SPF Temporary Error: DNS Timeout) smtp.helo=bombadil.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+43861feed20c552e5b26+8406+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXJBN1P03z2xLg
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 00:51:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bx10bEY/grytVZ3FAi9tmQtowXP7McpUMX6Ne8Ta2yA=; b=yyM1OyiDLAU2UCK0dYc1cSrokc
	jpImvVd9z4tjGyxdwdGEqJBU38z/QPxwVqOGAQjQ9Nlgj4CnZLuUFvCyvRuA53HWoq39j9YQy2JAB
	Qjb1/OeESL/bty10UMyaiyPVmeqCSfMQLjZ2gTso4CZ/aNmKdjEnGY3hBz7VcI1LmFvEff3fAKpOC
	i19PVvkCnNuoKDM++itYauWh0TNvpMZUKZvYd7Uq6SK0I5xfmA7TbqTRYSunX2y3ucbBmKbLkVIHE
	GcRN/ORqp4cZFsywN1Tow9VP6qWIgd0PBdG3FQkHDKdhUiBOVoylfhq1EaV5waddpugOP4Y887Gth
	giBEqlVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0KP0-000000072CH-32rN;
	Sat, 29 Aug 2026 14:51:26 +0000
Date: Sat, 29 Aug 2026 07:51:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
Message-ID: <apLx7pdNVkHPkrAq@infradead.org>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
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
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This causes regressions in xfstests xfs/006 xfs/264 when running with
a RT device because reopening the dm substitutef RT device returns
-EBUSY:

[   20.814542] XFS (dm-0): log I/O error -5
[   20.815055] XFS (dm-0): Filesystem has been shut down due to log error (0x2).
[   20.815960] XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
[   20.906440] device-mapper: zone: dm-1 using native zone append
[   20.954262] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16
[   20.970876] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16

I'm also a bit surprised a RFC patch without any xfs rviews landed in
Linus tree, especially as the series alsso got various NAKs..


