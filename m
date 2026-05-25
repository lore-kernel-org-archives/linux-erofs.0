Return-Path: <linux-erofs+bounces-3484-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 645A8CD5BC0
	for <linux-erofs@archiver.kernel.org>; Mon, 25 May 2026 06:14:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gP5Dm6rQNz2yQn;
	Mon, 25 May 2026 16:14:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779689640;
	cv=none; b=I23P9RVc033quxx+af07csKSTE6zoT1ZwcVcRiF/jti899xEQkdaV4b53zzNO6PChlwj8wHKbOcx2OlDETjdydiBbUFep3xE+dnn4w8QB1oD85QfC9dLwWSj8+YJ11AaUkj8aEpLEkXGVtoJ0DlwpTEEBWwcgBSHmtdYRPx8l3daD77EkbXwgsI/Z//AC4Nb9WRyJ1NsBjD6w8wmbXmEi8mtNFyZnU55/4U5YYau2MsZDxz/upelbRsTCiyEplhGozenDs7iiLLEfaX8KYDKSZayJ7TX+t3BVdi0+qex5Yw4gAibKvfe9Sqz6TmZumErOExkWsumAYID+nSlWa5UeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779689640; c=relaxed/relaxed;
	bh=wR2vIyoI0N5pwT1BwNstwo6UsRKMLal3+wIAvkxVMvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxC85zGzkqk+vsCj4SNjmBQzPiWtDo/bOEb8lfNzFaM8bJQDUd+1oje39f4l42fE9NXThRr2VPieNibotjApkWBh1NTvC5aggLubiWzHUJ0OOPdszvr0xCnWxKHL2zlsW6lAimNwX2SnvmglVsS4x5yVfrPrB1Oah1E2ntIMl0ND9tl4WJdP3AQkqI39mxNji4qxIfcqs+iWPM04CUr6xbqyMGGVxBobRyrxANQuJ9mFLxhdFPl5G6FrAkgCE86fBWqMpPiVzPGC9VJEX47iheqhc7FKAOZnYfFJd2ip4GX/BLULJaq8IcB38pgU/rom7IiwckKClSJUu0m9j23UnA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zukCrUtu; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zukCrUtu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gP5Dm0dQYz2yN8
	for <linux-erofs@lists.ozlabs.org>; Mon, 25 May 2026 16:14:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wR2vIyoI0N5pwT1BwNstwo6UsRKMLal3+wIAvkxVMvs=; b=zukCrUtu3mimFKUeZm0RXMqQK2
	kGGyaNN6usXLgSEU9Gbgcd9Rnxu7OIAbwN70g4v7jeIBQ/PTGsCqjWKVowrD6E95c+yFcSirTXOCX
	2pmMIo7aGE4K8ub7kLxRf4wx2kyIwapXnUZXJ8vz4qq/X5GSoISA6ENIibRBD9mbRPRuKnzbWtC+4
	du5vhRkKVCfRUzFnwD/uNhod1/p6ROSCrwCQCyikwpZXMZzkuV18jBwoj5qRYOck+tIkbRXraPwLA
	GTRsNx3hGDic5W8Lre8E5Laissc7COmB0DCteaZNYnMjWR/chZwTY/tWp/j+wBVJA8AnEPVVK6dW0
	AL0uhuqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wROZT-0000000GOO6-1oJq;
	Mon, 25 May 2026 06:13:51 +0000
Date: Sun, 24 May 2026 23:13:51 -0700
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
	Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v2 06/21] iov_iter: Make iov_iter_get_pages*() wrap
 iov_iter_extract_pages()
Message-ID: <ahPon44OlN0SqzU6@infradead.org>
References: <20260518222959.488126-1-dhowells@redhat.com>
 <20260518222959.488126-7-dhowells@redhat.com>
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
In-Reply-To: <20260518222959.488126-7-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 18, 2026 at 11:29:38PM +0100, David Howells wrote:
> Make iov_iter_get_pages*() wrap iov_iter_extract_pages() for kernel
> iterator types (e.g. ITER_BVEC, ITER_FOLIOQ, ITER_XARRAY).  The pages
> obtained have their refcounts incremented afterwards if they're not slab
> pages.  ITER_KVEC is left returning -EFAULT.

Just kill off iov_iter_get_pages*, please.  Or at least stop using it
where these types matter.


