Return-Path: <linux-erofs+bounces-3063-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F20510F3DEE
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:25:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmCn1JDtz2ySc;
	Sun, 29 Mar 2026 05:25:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774722341;
	cv=none; b=TzYELDgm/6Zfr5ENiW4TO7u4wiaYAoH8vgAgiXzec5YKZ+9bs22EnHWq0v/bSLwHpMMwNNZzX0i0RoXYbkt2ZwswYLIZd2QYXZFac3IVrbwz0LIuXRnejGDVtOFMqWC2KOVIPjT07JUHgPbu+nJ4S09ice0noEYjUdKw/GW3UBlTy7Xg4Ow+FxU2Rv6JBtb4G4bHcNgWoRAX+QlyzIofAazTFde1uNuyIYKrwE6mcYY433JsYQDoZTmkamHYKMy/58XmhhBdw/ILuOx1ZgvLFTrUTlIzhLYHdawSl5w0IyAZUq/6mMhjx01YXeES3aPqLGT5zzA6pigt7GFNandwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774722341; c=relaxed/relaxed;
	bh=vtvToygHD/XhQ/RgwXcfB1cu6LKJlBXHH2QlzqxoAkc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Z7upf1m8QXfXJjeuYrhiCRyLdqwrNclTSoEQ9vzEEgoWeqMms+pBKb4fMBOhU2kzIUqjI/N1lVVp/El7V2qD8tWOk87RMFyXFFufGaqGJ5kZNLkK6kZrFnPK1q6R9rFYOmShoemT08awhM11iSalzyLNX0AnD0PvfVZJ32P6616S6Bm1b2qP/YF64X7SbdglWHWZGC6nvy1JZfuph4czZSaRvg/UdaO/OAjzVk7Jo1i05acpD4mz/EMzUxLF5iTqXnRExi7qLdRw9C9FJ8st8LJjPRta5q3muX3IkCDJMrcbjFCrPp/V+GVlYjHNFv4BFgVfXhyQ38GBne7DaVXnyw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=rTHrKogG; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=rTHrKogG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmCl74x1z2ySY
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:25:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Sender:Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=vtvToygHD/XhQ/RgwXcfB1cu6LKJlBXHH2QlzqxoAkc=; b=rTHrKogGPS9SS4H5Xyzci5KbyJ
	XKCEjVCCUGW0MPjqZyKrvkvKJxf0WNl3E46gZ2GJLqoBxj9PZI5sg46wECKkS6vmMz3pg3uWz/iST
	d2AciCtqNPlAP3ARviB3hcA/WCr+iB1dl5GORx18D4DiXUBx2VslCgq3L5g2yQjs430mdesNStHxc
	l/i6xO/XxwNK1pBiWFgd3JEIQOqeTW/5iYWGNXyWaaUlKQ08SunfIbk7xXfm/gUUDS6JoRV8uRT6E
	KYWg4hW9AKFWaanekAYiM56fYDhBikopDjrQUVm6Et5i9/uyg8ClhrcpddsRsrWeVqLS8Nm+qgNl9
	X0nQJvTQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YLp-00000001nin-3OQp;
	Sat, 28 Mar 2026 15:25:37 -0300
Message-ID: <f73f5322e1e964404deefe64cc3e33db@manguebit.com>
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
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/26] netfs: Fix the handling of stream->front by
 removing it
In-Reply-To: <20260326104544.509518-7-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-7-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:25:37 -0300
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

> The netfs_io_stream::front member is meant to point to the subrequest
> currently being collected on a stream, but it isn't actually used this way
> by direct write (which mostly ignores it).  However, there's a tracepoint
> which looks at it.  Further, stream->front is actually redundant with
> stream->subrequests.next.
>
> Fix the potential problem in the direct code by just removing the member
> and using stream->subrequests.next instead, thereby also simplifying the
> code.
>
> Fixes: a0b4c7a49137 ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
> Reported-by: Paulo Alcantara <pc@manguebit.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/netfs/buffered_read.c     | 3 +--
>  fs/netfs/direct_read.c       | 3 +--
>  fs/netfs/direct_write.c      | 1 -
>  fs/netfs/read_collect.c      | 4 ++--
>  fs/netfs/read_single.c       | 1 -
>  fs/netfs/write_collect.c     | 4 ++--
>  fs/netfs/write_issue.c       | 3 +--
>  include/linux/netfs.h        | 1 -
>  include/trace/events/netfs.h | 8 ++++----
>  9 files changed, 11 insertions(+), 17 deletions(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

