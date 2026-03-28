Return-Path: <linux-erofs+bounces-3067-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E349410F3DF1
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:35:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmQX4Fktz2yh4;
	Sun, 29 Mar 2026 05:35:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774722900;
	cv=none; b=O8GuABM2txwH6VvMCzNxQnRtiWGB/EsunQmdpwzgUXQxYAhivtqVrwOkNPea2AG1Z5wwH8CCB7h5CMY4L2fgel/tiEneRQIyivrA+t1GwzdU3y/7KAxwqmXawn70y5Vwr4u+ELEoPJeAj13CaXxaGd4vg0rmpdUYASzXnTRSTjEn36UJVfQ2SYM19JAh4E2N8Cc/qo02qOlhSTDXxHBPMlnkiR4pDo+R0dUTz3MGfH0uR8DgNv6vfG2mFtDgJUreyuyAGlMxHo40cCBfXcDiNV+QqhExFcY1lccmTEXxEx/ccvlD9DJTMf1N+Y7GHuX1AXxT/CuXYfCV6dhKCebSUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774722900; c=relaxed/relaxed;
	bh=1ub/AEo4t598Shwt8YJggaAGXX2PtzkMnlWDy9kFv50=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=d6NQuiw672CgJNY0mCNAYDREeyHepP/KypNEqC7YDB3Lla2awhfCHkF8Cyy//ogCKY9Bg+vQZMiONeY+L7ncNY87jrINK6/s7VFG8qedEaZnjCfLkROZrkv1bR9MH1+Ll7lypSw8yRg4rXvvcFIRgGI6MgSM7Kv+K6pUu/rquDSsz+7w/ltVHYkz7qH6o2+JYfsFzDNDAtupv3M0iVZl4cd+lX2Ov6SylPwbRUZNwkSD021yUXUt2JYg8oj//XufAXcZ1PPBkjhi3PQQK+Mg+BBewbsOgKxMOlRqnkJyoOpnMuGndPUNGPnPYAnnTMqOcXqedwjwpJeTZ6K7YUHf3w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=h3K0MwFp; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=h3K0MwFp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmQW4H6Nz2ySc
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:34:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1ub/AEo4t598Shwt8YJggaAGXX2PtzkMnlWDy9kFv50=; b=h3K0MwFpfg1kOVZtxuEJyHiHDU
	tX+sBwyY714azoskpQItXMe6WutTWzchu+ys9rlEXgKMUrtoQP+IMK7Hh18U7+mCps3nul3d2umbw
	IJHgA8WWL0iyYLsgndr9cSUZImNlxqScEJ5a/cY81IMsSsmZddiHNvr2hSgXlDmbKrffLxIi7kQ55
	TEZXxMr/ZXA7DsiyEpV7PRv0ffUkbX//iDCTtHQnEthyuAIRc5hoXiq5/kBimytSBr/dMF3/I69Wd
	VNe0A33tRpWQ2TFaN+m/7OfnlPqLzI9sedM1p6tNFek3X4nJGAr+Mk7msLIlTjBzj+mSm7B1kiDht
	0HhLASww==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YUr-00000001nnY-0QeS;
	Sat, 28 Mar 2026 15:34:57 -0300
Message-ID: <16a6ca6a01cb7f65cf71c1358cf88f53@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner
 <christian@brauner.io>, Matthew Wilcox <willy@infradead.org>, Christoph
 Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>, Leon
 Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Marc Dionne
 <marc.dionne@auristor.com>, Eric Van Hensbergen <ericvh@kernel.org>,
 Dominique Martinet <asmadeus@codewreck.org>, Ilya Dryomov
 <idryomov@gmail.com>, Trond Myklebust <trondmy@kernel.org>,
 netfs@lists.linux.dev, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/26] mm: Make readahead store folio count in
 readahead_control
In-Reply-To: <20260326104544.509518-10-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-10-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:34:56 -0300
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
Content-Type: text/plain

David Howells <dhowells@redhat.com> writes:

> Make readahead store folio count in readahead_control so that the
> filesystem can know in advance how many folios it needs to keep track of.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netfs@lists.linux.dev
> cc: linux-mm@kvack.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  include/linux/pagemap.h | 1 +
>  mm/readahead.c          | 4 ++++
>  2 files changed, 5 insertions(+)

Reviewed-by:: Paulo Alcantara (Red Hat) <pc@manguebit.org>

