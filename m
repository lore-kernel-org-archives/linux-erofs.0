Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB239C4167B
	for <linux-erofs@archiver.kernel.org>; Wed,  6 Dec 2023 05:55:14 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=AH1r7Or5;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SlRSx3T1Nz3cZy
	for <linux-erofs@archiver.kernel.org>; Wed,  6 Dec 2023 16:55:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=AH1r7Or5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+2d31c4bdfe93494595b7+7409+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SlRSj2ZVXz3c4s
	for <linux-erofs@lists.ozlabs.org>; Wed,  6 Dec 2023 16:54:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Epg/iXYkY+1k3eZKM14iUxoA+UE8xascWdRNU509WEI=; b=AH1r7Or5zoUct39UOS7X8uhjM/
	ZiUNF74wEtopkSsYjRN4ZiT+Q5RDAfrGjr2SdG2lYRso2gu9KpXtKwk60gz8irSWJAAQdmmFCaTEL
	SzY/rogxAQvA7E28MbalnxTm3ENVynpcioekCUIHWOMylS+mP3+gVaUE9mTXoi268lvfIjLdzx8gy
	KJ4Ze8tYIRqVan/Kdng7awTtiEGY+yfEO2mGuyBJruCAYOU4SPpu5BrZ55s3w5ET/sudLHNfZi9Fm
	RGHdjWS7by3ADPe4JZlkDzpRcg6HmO7sizVltW2W1zG8KT62VV/j/an1o/4xPCND1GnBbvrQyIKqD
	pYwXk3tQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAkrP-0098Oa-0t;
	Wed, 06 Dec 2023 05:54:15 +0000
Date: Tue, 5 Dec 2023 21:54:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next RFC 00/14] block: don't access bd_inode directly
 from other modules
Message-ID: <ZXAMh02h4FAwt2FY@infradead.org>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: hoeppner@linux.ibm.com, vigneshr@ti.com, yi.zhang@huawei.com, gfs2@lists.linux.dev, clm@fb.com, adilger.kernel@dilger.ca, miquel.raynal@bootlin.com, agordeev@linux.ibm.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, agruenba@redhat.com, linux-scsi@vger.kernel.org, richard@nod.at, willy@infradead.org, linux-bcachefs@vger.kernel.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, jejb@linux.ibm.com, p.raghav@samsung.com, gor@linux.ibm.com, hca@linux.ibm.com, joern@lazybastard.org, josef@toxicpanda.com, colyli@suse.de, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, sth@linux.ibm.com, yukuai3@huawei.com, dsterba@suse.com, konishi.ryusuke@gmail.com, axboe@kernel.dk, tytso@mit.edu, martin.petersen@oracle.com, nico@fluxnic.net, yangerkun@huawei.com, linux-kernel@vger.kernel.org, kent.overstreet@gmail.com, hare@suse.de, jack@suse.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
  roger.pau@citrix.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Dec 05, 2023 at 08:37:14PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Patch 1 add some bdev apis, then follow up patches will use these apis
> to avoid access bd_inode directly, and hopefully the field bd_inode can
> be removed eventually(after figure out a way for fs/buffer.c).

What tree is this against?  It fails to apply to either Jens'
for-6.8/block or Linus tree in the very first patch.

