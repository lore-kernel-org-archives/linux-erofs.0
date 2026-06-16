Return-Path: <linux-erofs+bounces-3630-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB27CD98DA
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 12:39:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfmlG4Z28z2xVK;
	Tue, 16 Jun 2026 22:39:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781613562;
	cv=none; b=XuZnzHWDF8g/pLQxz99wHu7Y4KuiECKf5rLVH9ZbhyVPEXtl+0ppueKKRg4055wNUGDB9zn2nPyJtQ7EcxNJPuF1ExlCR+x+iFsUWiz/+DdtBYEPLIxbQl2649aIS2A+5+e990/76sr0NFOIEpYxY7bGPHvSMF64QXyUTnMenJ6cL85inEfDkIWZXeXdOdi8rgOGW1qyOUUJaSeh09QVB6pBSvr8X3UeVZJSn0B+JrbKIDQYBa0sOmsFXUAvgwmK4345Y5WdIHxAHaxq1b8Vm+YQ45vap9uyKh45nhypVLqsAHRNs+jkjyKwzihGs/LQ4lYnl8rZRjPJx7DQZsQr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781613562; c=relaxed/relaxed;
	bh=5EdZEQr56NngtMqetLIh7uZxlqXA7wuIkjKsBUo8El4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k6NEvI1fqRZfPJPu19r+YQOANNGbjcBbDfwony978O3ipSKTCnCrw8LNIUEaOnVl5wOjT0e+6hmoZIUIbwJPjak+xO4Guf/tp3JxconKMc4KE7Uw1mYMJb9LyW6U85J1s/jfvxDWX9UZp4u/8ufCCUDoLsWTD6rbYLuQnk2uCI1WSaMRAkvNIMqOXmZrUmpb9sQjPv3NiE7KQltYcwx/+zDiPHjdhW1PS4X0ojTR0EDyWvAVrt8GZxoV/AUVZhYBVDez28VIbMDttnZtve3GC6QbRFNyNUNmfQNdMfXNDrO1I5vCz3a6ytaem4HyDGVy1i7XQyh5vlixQnqClVnEtQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zCeou/M6; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+89a3462ad52732eb22ed+8332+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zCeou/M6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+89a3462ad52732eb22ed+8332+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfml91cNPz2xKh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 22:39:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5EdZEQr56NngtMqetLIh7uZxlqXA7wuIkjKsBUo8El4=; b=zCeou/M6O+/c/sRe+2gVAa7PYn
	/KGY5iI9ZorqbKaBi5gXM79A0Hdh87LTj912G443HMxkWrGn0vWchAG3TFECfQnM6v2lC/uSjBqoL
	unuBQjir0+H5uXtGG+05z7ucyZOR3NZABpZ7FpeNTbGirx4ZEz4FAR6SX5JEPMTJs3QKNHb8IbzXe
	hJKSVJQ8C87eIs1+oQfvfAYMlUhbS3Kmcvbh4MlMQ0PC+8gj2+I35CR8YcARLds8XWm4PWNEx5RcB
	qN3CmCnObaGamY5XTxdYAdmKdHlFGMP265JrzvBpMWrwOKmazoOKLhJSUJMFBSoGutNBxFM4b5WQ2
	bOx5tseA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZT4C-0000000FlxD-2thP;
	Tue, 16 Jun 2026 12:38:56 +0000
Date: Tue, 16 Jun 2026 05:38:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Paulo Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/30] netfs: Keep track of folios in a segmented
 bio_vec[] chain
Message-ID: <ajFD4ELy4yBpu0fb@infradead.org>
References: <20260616100821.2062304-1-dhowells@redhat.com>
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
In-Reply-To: <20260616100821.2062304-1-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 16, 2026 at 11:07:49AM +0100, David Howells wrote:
> Hi Christian,
> 
> Could you add these patches to the VFS tree for next?

Really?  Not only are we in the merge window, but this is gigantic
unreviewable series, which consequently has none of the relevant
reviews.

Please try to work like everyone else and split out useful parts.  E.g.
if your new iter type is useful there must be smaller standalone
candidates for it that can explain the use.  Having to wade through all
of netfs to try to understand it is not really going to fly.


