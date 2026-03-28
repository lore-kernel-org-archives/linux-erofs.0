Return-Path: <linux-erofs+bounces-3068-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640FA10BA423
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:36:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmSK0Yqkz2yh4;
	Sun, 29 Mar 2026 05:36:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774722993;
	cv=none; b=HnPWib16ANTJxz/c5/NtdqHTiIivu16UhsD54bHWI/52DP+zDCioOB6t+b+3qqRLoM5cJfxzi5/HPSHN6TG/FP1Mp2wtPXiGh/95YhIn1Z72Kd89+JZtAJMUd/xdexKAI7+NFl2GVS8UkQNZ1qZWP11TLE0hv8O/xlsFYr6RmjlMJOjhoDumtMwnhGzF63jyIL/IuO4bXifuWZhqvA9gLG+l7lQdfMdUjuOVKwetdLWenxLpsi1b9eyCLHf/z9RjbcajQ+p5bBbZ6+lNoj/NbnpX2Qfhx2+lzt7ILBO/R+ohHWONhToRxJedYY5rplZm4VdyNnxW7G0ZzFbl6nXFtw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774722993; c=relaxed/relaxed;
	bh=2G5EjnsDra2FRBDfpoHL88rw7wDpJJ6XyDPUAlNk2CE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=gEfzXphGGJYjRsBivirwaZw+Kvv3PhZy9Nw3j0pu6aRXdxcfcPkTzST4eT9QK6a/7F4vcXxkLlD4AEqb21+cEiU2c23QIeRwBF6GS+VS10jxhfGCI07JdeubRpEzcihvoDesyuyQIm0to7+jwhnq3iVv0sj8K+QEzbdN2y1wleZuKmOGx0vq1lAvfV0WTohLetZl45mnVhVaGCThlOq5OupQo6TuqqgTWmUzX7aITMhoLy1uvx5Lu/lG1eSGtA7YOhAMxXrUHySAoaSLwdji+bOHzFOkZ+4WzbPw0JzrGfXZSc7CYcziXa2Wm9X+Cg2HiFrfjpZRvbX63wmNkw2ycw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=l/xJtaqQ; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=l/xJtaqQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmSJ2k0Rz2ySc
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:36:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2G5EjnsDra2FRBDfpoHL88rw7wDpJJ6XyDPUAlNk2CE=; b=l/xJtaqQbIOEJk9zlI9x/R+HbG
	L3R5sAwTtHIxcRDqGQ/yRYtEadhEfcAjWRqZaSAkqrg5zakHzc+vhUyBV0Jsj+1zTGC4tqfKAWA7M
	Wo6es5dWLIMPpy6h76cu5buH4eOZavh8FiAkBQ6PFw8X/KsusWS5ujfeX8qOS1SNeFnzdeRyJTSKg
	zWLYh5AsjWaO+d4ynavPbCAidz0ioWER1Z+rwWyGvBgxCXD0UMShGguznBykol887FSTaTtPTcut8
	cO3L8CVZPJgZ7sLRxl6Q2/ts+kmHtPc4e4fiJYBKjnK360N/gJolVTh3J90rd7PpgFPZdHOtMtWJD
	DtIEPVPg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YWL-00000001nom-3cop;
	Sat, 28 Mar 2026 15:36:29 -0300
Message-ID: <9faf4ad6b806a377678a03917edc580b@manguebit.org>
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
Subject: Re: [PATCH 10/26] netfs: Bulk load the readahead-provided folios up
 front
In-Reply-To: <20260326104544.509518-11-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-11-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:36:29 -0300
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

> Load all the folios by the VM for readahead up front into the folio queue.
> With the number of folios provided by the VM, the folio queue can be fully
> allocated first and then the loading happen in one go inside the RCU read
> lock.  The folio refs acquired from readahead are dropped in bulk once the
> first subrequest is dispatched as it's quite a slow operation.
>
> This simplifies the buffer handling later and isn't noticeably slower as
> the xarray doesn't need to be modified and the folios are all already
> pre-locked.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netfs@lists.linux.dev
> cc: linux-mm@kvack.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/netfs/buffered_read.c       | 95 +++++++++++++++++++++-------------
>  fs/netfs/rolling_buffer.c      | 75 +++++++++++++++++++++++++++
>  include/linux/netfs.h          |  1 +
>  include/linux/rolling_buffer.h |  3 ++
>  include/trace/events/netfs.h   |  1 +
>  5 files changed, 138 insertions(+), 37 deletions(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

