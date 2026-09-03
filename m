Return-Path: <linux-erofs+bounces-4464-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FC8C624D6
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 06:07:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hb8JN52Tbz2y2X;
	Thu, 03 Sep 2026 16:07:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788415636;
	cv=none; b=liBy5+AoV2GnHJOBo3O5Qf74cLqcpwUxCjeXFdpYisO/2ebm2o8ZIJ1Epx+vYy5BDpdOv8ktDP1/V+/DS9E3xGD25xRENmmIpxG3cIM9H3umA3sfgdyu+MGEHfqhITXJDb614OP5BLrZ/obkgJKmFVDf89Zsa5s5+h2ogBN623AKGYR/9vOORwy1L91ej0dSLYtEIXWBmz4N6yQqpRS/5Vcyvf6HRumS1zOm1LTZWr+Mpq3lly/oJUyrOcPaf4K/72sHQgsnOK7jsFWyI1qKMT/RtG+PyT4v2Gali3SjcwxT2bhermE4ApUQBjwg8cDLzF/vsGN8ksIFkrBSmpV0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788415636; c=relaxed/relaxed;
	bh=HpHIM6EYgD3LFqRo4UeY/HdeHCEhzL5x2gf9Hr6c2As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VkXYc8OLRwfVCNMb/FH/Whfst+m5MBHCtLiNVIrJj+fmnHEkNpVtVBxk51WvnXOh91kEyP0dYsbOKTXawp3FHqXk1/dQrQKDu/7dDQLISA8cpTw1wy9TRLzIJWvaMd88wFFqegODikD7r120Z6+ETBweJTN2JDk049AQpn8m0jG9WwGp0iuIylFmDx2TzIzPBcCKeorgKM04WOfXeHhtiZjIAVvQRUbtG+KwByGj4KkmYI7O71Mhdw70VKgxkjsff0bL283fuGbi54LbfRGGrY2EI5+fb3o7JRGWekBuHZ8KnjF7e2Ovkq6crgC5VqB6xOn68TqL2wcjubSlo/qXJw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iOFOO94I; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+8b5d57f6b71d8aa82db3+8411+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iOFOO94I;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+8b5d57f6b71d8aa82db3+8411+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hb8JF2z6kz2y2Q
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 16:07:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HpHIM6EYgD3LFqRo4UeY/HdeHCEhzL5x2gf9Hr6c2As=; b=iOFOO94IlAKiLitTeC8cPFrRcc
	Vd6TfSV7EkxpMY0epB9jCn8rmR+LQsZQws5lIvwXeIaJxcRHoM+zm9nWyrX2ovpAfyg2x8hImuiIc
	dqLamJXQnhD7UY9IZrYWygE4Jh77K/UGI57A5K3hJdA+Jee1Mi1zcpchxJZbdz8/EnkMrTgfjBieF
	KZPfyHtijfrmoSPvWM9O2iy8Cq7wGFnsoLgRCflF53yRTPc54Dvg/jUb1xGPaC2arDfe+8W5Fk1D9
	EfGrJa2KHPQg1ENHtQ7qAxCkm7gaeK7rK4pm2hngDxr/ubl+LUnxWMC70IaJQPHN/R3vTtVpazBHE
	L7zUw/pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x20am-0000000GRmn-12az;
	Thu, 03 Sep 2026 06:06:32 +0000
Date: Wed, 2 Sep 2026 23:06:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/36] netfs: Keep track of folios in a segmented
 bio_vec[] chain
Message-ID: <apkOaPegouqBcHee@infradead.org>
References: <20260902173350.3468672-1-dhowells@redhat.com>
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
In-Reply-To: <20260902173350.3468672-1-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

<broken record mode>
Please split out changes to core infrastructure.  Make sure they are
also useful and used outside of your little corner.  Ensure they can
be an are properly tested by either having common test exercise them
or adding new easy to run test in common testsuites like xfstests
or blktests.  And make sure the changes to the core code are relatively
self-contained and reviewable.
</broken record mode>


