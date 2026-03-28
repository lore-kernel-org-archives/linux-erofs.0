Return-Path: <linux-erofs+bounces-3070-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9F9010F3DF2
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:39:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmXG3SyBz2ySc;
	Sun, 29 Mar 2026 05:39:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774723198;
	cv=none; b=GPx8ODKStLSeK5Dh2/UsIUbQ4UHr5KANIIUMYCRHmpR1TqdhOrOPpCRj8gzjOITFUVZit5hji3AFf/RBGNCKm+0ZHMHqRxxVNL5ZM8B4Rqkmou3mKcV4aNa3bPVoUShQ4F0rMNpSAaVpzdPLzcZIQlpRC3mLjK3134dulzrM6N8XzGoWf0o945E31AUsKViGHVZJQZ11P1ZR0OLmVZVtpb0322+SP8c5cvAhh5cS8vZxrwo5cpUUi78aiq8c7/Pxlp8JE68EZNTz/N3cQjedhLM26djpEPID8iOGpB/GtVagbCtc1fwD5mKWmSu+yRUJ0PJCBA8NtH6VpCjF7SUHNw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774723198; c=relaxed/relaxed;
	bh=TCGm0nfvvy8Bnnpu5UWLIv7a/i53kn4C96IdqEjuOQc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=BGxfXz3josFEpBtYyrkDmdTggEz335lAYWnMlBDlKeB7kmRxJxoFMIs6KR/peyxo5QfZ8NZDVYnHVJq4yuslGe3B5SgyO/nBZNTL49rbHSykbff4uOzwFBNYL7AsCa/bez/tNTV2SXcfJVAEp0g9JdVp26lu5Rcpu40jslUS1SDvHQtHUgsfgd9NQeYFc9vY7mfMu7sxwEbimNFh+tAexOgw++Gq17jO+7Pr0FZhfeGPP1iHLWAWYlr1+Qgff/aabP1z5LsSi5e9KzqeCj9KGIqO4xn0FHlVzUPJNdyuydrIOQ8ld1ARJ6MVsH7WcQQnP/OJrLgaoVT2mbHVyNa1Dw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=ku2cJz4o; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=ku2cJz4o;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmXF5JKLz2ySY
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:39:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Sender:Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=TCGm0nfvvy8Bnnpu5UWLIv7a/i53kn4C96IdqEjuOQc=; b=ku2cJz4o03JZhzhabC4ZS5XbZC
	8fH607SCqVF/YqtrusQ/G5FiG6gH1ajZx6cWgIFhW28kni4tJQct4RMgQn8dGRVZ1RN5Jse7vYmZf
	5d/os5vwEEuzHvfwVrVTc1ieO8ke+ivEj4m7QlAcf7wpkzbK1Jaz14/FR5wwoZKBGcKBiJpKNxIBA
	rwboQIKnYYfrjgvzfIj6gnW9K4GURLcYJODzbaH3GEGOIgChMG037qjdVMrGf+pdJHSj0knj3XJCj
	krzS92CQw5XYUHB4MVUnLZjm1yudidhzLUXsJXW52+cN57wlHUxvXKOdG/xxQS1kHTOJegmhMePBP
	FnrnG4EQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YZf-00000001nrA-1k06;
	Sat, 28 Mar 2026 15:39:55 -0300
Message-ID: <5ada775e751c32368a012f1d17c5323a@manguebit.com>
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
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 12/26] iov_iter: Add a segmented queue of bio_vec[]
In-Reply-To: <20260326104544.509518-13-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-13-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:39:55 -0300
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

> Add the concept of a segmented queue of bio_vec[] arrays.  This allows an
> indefinite quantity of elements to be handled and allows things like
> network filesystems and crypto drivers to glue bits on the ends without
> having to reallocate the array.
>
> The bvecq struct that defines each segment also carries capacity/usage
> information along with flags indicating whether the constituent memory
> regions need freeing or unpinning and the file position of the first
> element in a segment.  The bvecq structs are refcounted to allow a queue to
> be extracted in batches and split between a number of subrequests.
>
> The bvecq can have the bio_vec[] it manages allocated in with it, but this
> is not required.  A flag is provided for if this is the case as comparing
> ->bv to ->__bv is not sufficient to detect this case.
>
> Add an iterator type ITER_BVECQ for it.  This is intended to replace
> ITER_FOLIOQ (and ITER_XARRAY).
>
> Note that the prev pointer is only really needed for iov_iter_revert() and
> could be dispensed with if struct iov_iter contained the head information
> as well as the current point.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: Christoph Hellwig <hch@infradead.org>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: linux-block@vger.kernel.org
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>  include/linux/bvecq.h      |  46 ++++++
>  include/linux/iov_iter.h   |  63 +++++++-
>  include/linux/uio.h        |  11 ++
>  lib/iov_iter.c             | 288 ++++++++++++++++++++++++++++++++++++-
>  lib/scatterlist.c          |  66 +++++++++
>  lib/tests/kunit_iov_iter.c | 180 +++++++++++++++++++++++
>  6 files changed, 649 insertions(+), 5 deletions(-)
>  create mode 100644 include/linux/bvecq.h

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

