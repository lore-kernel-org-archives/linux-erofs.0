Return-Path: <linux-erofs+bounces-3064-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCBF10F3DEE
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:28:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmGl6tVlz2yZN;
	Sun, 29 Mar 2026 05:28:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774722495;
	cv=none; b=OF+8aWOMJzAb7eLH2uY+IRu6ShxJzIpY0wCrBemujvPRgqbg3aqMcCksx8kYAeDlEGkiW58JMxF/7f9K2ZqGPQjmxnLycUp/R9f78sWmo2anX5ISydgTyztXqz2ZiD2TIlVFefexB7xBPKy80Y6UU2UJ/jnXwbM25o7aZdPVlutvMOs3n9tarsTNgiLQ8MjlUI6g1M1pmAQulFCllfvg98GjzFfLYNcUk8ET1XYAN8rkh4p/kmJO9itOwHksyqs0bNZQBsAz8+if3Ei9BHjNBIUc4fZH0POdhWWeLOEbECCmeRj+cDiLqczKNPhjpSoGKTj+cyAvsXW1Tu3RaXl2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774722495; c=relaxed/relaxed;
	bh=eneYkUaGNQxVaJ+FyiE6Puc0DLjeVqMvpsPglKgRZDc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=dI9gHnPNpDVLqZzmOQR43Hfh4TQQ4lHOXEacg9JJNx4WSHFySOwx1tAY+of5GZ9VpVXyhfc679SxZLdyKHnysrIBljwHVabZS9q9ACDnLDH3IuwICpPuOR34WyIfC/BghMMCv/h1d+AIZ8+physAA75ocILUN9P9KdP8/TbDRY7GKDFhPlYUpQko8lAfdqj1gi7S1YoL8sXquvLCAZCjPwItbu2pdNOUY2KmiuZE0QgtRDCAt/Uo0nz5Kq4+rnA3k1pM+WBdarvJWfFNM2MkYUW9ZBeYczNCGR8l9UamkYS3Jg+hvO9GYOUWoy8mmj6xGc8Z/6CrLePfqPG0G7jZsA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=yV3i1ZDX; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=yV3i1ZDX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmGk4PLHz2ySY
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:28:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eneYkUaGNQxVaJ+FyiE6Puc0DLjeVqMvpsPglKgRZDc=; b=yV3i1ZDXK5EP1hNmZxbH/02Szf
	WQxC6OwS5mlem0F8BGjttX7h18KoSHbC0p2ZFNWIl6OfFQbhmrgItu+J8wNr1Werr/qAMI6z6XsHN
	DVDGDfJnlfc/EQzfo9vaIiL60AqN8bUwbyS43nLgHHG5c4MyH3GFkACVC8r/Z4SUCWPmXjrgH1dIo
	4ss35KIRn098GQxrF/1YfwPahfjBG5venCzwkrm14SlsG6PZOOlkEkkrJ076yt/sIYk+MV9S2L9Qc
	nb9DyiO2xACZ9VJEYvcPxNSyiInLhKb1gRkz2+CA9TVcrQNMJc96B9+GOzI3zXLvgla2n4snmsOae
	ZwNRAgyw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YHq-00000001ng2-0xPm;
	Sat, 28 Mar 2026 15:21:30 -0300
Message-ID: <ae7728f96fd050ec3224ddcfb539eeae@manguebit.org>
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
 linux-kernel@vger.kernel.org, Deepanshu Kartikey <kartikey406@gmail.com>,
 syzbot+9c058f0d63475adc97fd@syzkaller.appspotmail.com, Deepanshu Kartikey
 <Kartikey406@gmail.com>
Subject: Re: [PATCH 02/26] netfs: Fix kernel BUG in netfs_limit_iter() for
 ITER_KVEC iterators
In-Reply-To: <20260326104544.509518-3-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-3-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:21:30 -0300
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

> From: Deepanshu Kartikey <kartikey406@gmail.com>
>
> When a process crashes and the kernel writes a core dump to a 9P
> filesystem, __kernel_write() creates an ITER_KVEC iterator. This
> iterator reaches netfs_limit_iter() via netfs_unbuffered_write(), which
> only handles ITER_FOLIOQ, ITER_BVEC and ITER_XARRAY iterator types,
> hitting the BUG() for any other type.
>
> Fix this by adding netfs_limit_kvec() following the same pattern as
> netfs_limit_bvec(), since both kvec and bvec are simple segment arrays
> with pointer and length fields. Dispatch it from netfs_limit_iter() when
> the iterator type is ITER_KVEC.
>
> Fixes: cae932d3aee5 ("netfs: Add func to calculate pagecount/size-limited span of an iterator")
> Reported-by: syzbot+9c058f0d63475adc97fd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9c058f0d63475adc97fd
> Tested-by: syzbot+9c058f0d63475adc97fd@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>  fs/netfs/iterator.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

