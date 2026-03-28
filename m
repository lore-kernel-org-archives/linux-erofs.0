Return-Path: <linux-erofs+bounces-3066-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B135510F3DF2
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:29:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmJF2rCLz2ygp;
	Sun, 29 Mar 2026 05:29:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774722573;
	cv=none; b=cFNXox4N+JA4bRWZqjmkTxFlGmSGgJbBRYiu/riB7F8LLpC3VEQpWSfGeXou9jWYIJoExvf8YurHJ1dO3NyCDpWcZQTnpeGnN1L6NHnR9+kTdKq9t/JZniIwtoEVmqG6yDIZmAaebl1V6Fgl+Ezf1pqkpP1nAbATU5h9GKD0+jlchA9tCgySav7fZ+2Bhbey2QGc2J2OJQNLxgYazedR1r68SNAQOeP5/9V+pOQMbQS+iEX2ImLYMDLqppoZ8M9YpOeiaAxtbCFJ7soEVdVXs951LfFkP8BHViRjaNDDCotfl+PCfyxk4g/rxqZ2zxOjaZETmTEfqnGhiqojc761Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774722573; c=relaxed/relaxed;
	bh=pjWAhC/pRJ11i7dihmGstGNUCTp1Y38MOjqiDtDdmNs=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=mMsGMCTAlOEEXjYTCCQNRwxYyoq6oG60vF9ccck3PqcUCl5Nh1Dup7NYlLDjm4su5IBtBSPwPbIB2qTqSecBN9HUDdR3RNT+FnyqUTisJQeThjnYkrvYpPLOgvEA9ZjIyck8U5mNd6+RAcscSUcakqmJ05Xs0svKR6l9Gplp4WhHZXnapxOXIY0bWywxXqPdC1K0ddQRe3YYhBsDL0WKwmYQ1zRHSvZMwtr6RYtlrxD1ONr6pWGAYcAjm+p1hlOQAPZT6qQ0+/cvoRerhY8sgLR+Gh2q0Ir8r15+r2IoZJmQX+fp+bOZu6k8Mw1fKHU/DfEgzwh7rvXrZRIm05nFaQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=INI1qEvU; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=INI1qEvU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmJD2Y8Vz2ySY
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:29:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Sender:Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=pjWAhC/pRJ11i7dihmGstGNUCTp1Y38MOjqiDtDdmNs=; b=INI1qEvUexzKgv/Xbd2+s18EwR
	FHn0RIWLefTqo8OnxI0eiHFe9yd7Wgk/um9AhFcKtHPtEj01PXM9wvSUs1TZpqUIivsMSujqn6m4H
	FCZtN/q1vNxkgyKtNOQXjPsMRItEkBEEQNQF+f24nBty5o3q03Of/pZbvCNmaXH2ohSyObbv6UhIB
	7kVxtfq63z13dLrvUOvCGkoT1TUXPgcqcT7AEjbl4Coiu0gkejZqcv1EnPTOxgzJEykcTZRPObyVS
	ir/wFgpEVQaYdVONbf2uxhfixfCy/hJKtlytT0+DYASOdIEVyJmgYwXaxHFqR6Y5NHxFF2vgzdYCf
	NohctqLA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YPY-00000001nlp-2Cuc;
	Sat, 28 Mar 2026 15:29:28 -0300
Message-ID: <7e285c78b2f745b0b4c33db2af7b6d26@manguebit.com>
From: Paulo Alcantara <pc@manguebit.com>
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
 linux-kernel@vger.kernel.org, NeilBrown <neil@brown.name>
Subject: Re: [PATCH 07/26] cachefiles: Fix excess dput() after end_removing()
In-Reply-To: <20260326104544.509518-8-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-8-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:29:28 -0300
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
Sender: pc@manguebit.org

David Howells <dhowells@redhat.com> writes:

> When cachefiles_cull() calls cachefiles_bury_object(), the latter eats the
> former's ref on the victim dentry that it obtained from
> cachefiles_lookup_for_cull().  However, commit 7bb1eb45e43c left the dput
> of the victim in place, resulting in occasional:
>
>   WARNING: fs/dcache.c:829 at dput.part.0+0xf5/0x110, CPU#7: cachefilesd/11831
>   cachefiles_cull+0x8c/0xe0 [cachefiles]
>   cachefiles_daemon_cull+0xcd/0x120 [cachefiles]
>   cachefiles_daemon_write+0x14e/0x1d0 [cachefiles]
>   vfs_write+0xc3/0x480
>   ...
>
> reports.
>
> Actually, it's worse than that: cachefiles_bury_object() eats the ref it was
> given - and then may continue to the now-unref'd dentry it if it turns out to
> be a directory.  So simply removing the aberrant dput() is not sufficient.
>
> Fix this by making cachefiles_bury_object() retain the ref itself around
> end_removing() if it needs to keep it and then drop the ref before returning.
>
> Fixes: bd6ede8a06e8 ("VFS/nfsd/cachefiles/ovl: introduce start_removing() and end_removing()")
> Reported-by: Marc Dionne <marc.dionne@auristor.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: NeilBrown <neil@brown.name>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: netfs@lists.linux.dev
> cc: linux-afs@lists.infradead.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/cachefiles/namei.c | 36 +++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

