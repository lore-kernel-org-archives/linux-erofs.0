Return-Path: <linux-erofs+bounces-3633-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A22CD98E6
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 12:55:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfn5V5QNqz2yfD;
	Tue, 16 Jun 2026 22:55:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:41d0:203:375::b6"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781614510;
	cv=none; b=VtavGfNoHu9T+c+Io0MPwfoZd/adITPsRctccOdftTRb+ctXm+tjt0AhoCsQNnGgzfWkBv8gr66FmqUjz7QBdfMhD4wl2QSOIEQrNyu4Slc31b/qBZGqBXVwOZF3p3cnQ0CnUQIw0gp786G78bDtk/NVZn3Z0yojVBXZZshzlI8GGcyvOTUIhSCyeL0CvC10ulz+BcUzCLxfCmq0Dxj6YqGgLogEuLRPvp7h7gYP4/uhzdwrHX0Fbmg8CyR5EsAfaXKaaV0oL7DlrMRgREYBiGIyHQ/31oAqCt3tZHaVGfefCmo6BdSiEv4D8SGdbu1J7EfpWooF31vGxRlp42mcmg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781614510; c=relaxed/relaxed;
	bh=wv0+MgqNRvRce0wQH8tzVOBI1JIX52tUPZ58AWe7J8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kX7JNzl4A0hhDRYJX09cQ/ycnUwhVl6u7b+ANwMznhiXuJTEiWEWdoim3afNlNDgEm17M/rELU0enWHQJF4Gjla5Vej+6NQ6fISXm7FGCC6G2zrlenCAGzB9kWuWyfcCQj0yiUFQYTf6hoCuTYgkijh8KtptKeArcODxYeRezsticZxY+X+YMf37Wyypv4R7L3niN7yES5kkjHiX1Z82tmjUv76YCsWamwa4L4P8yCroxHnRAqyK48kJHAo8VxS/+r3RCqrDeIaZ7wHqDlN4I/u96yn43gN8WQB9PZJmdZCdJBhp2/db9SsxaOZcwe4CyJDj7Nki3JIbcD2UOAlYeA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; dkim=pass (2048-bit key; unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=DXl5YP4w; dkim-atps=neutral; spf=pass (client-ip=2001:41d0:203:375::b6; helo=out-182.mta1.migadu.com; envelope-from=chenxiaosong@chenxiaosong.com; receiver=lists.ozlabs.org) smtp.mailfrom=chenxiaosong.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=DXl5YP4w;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chenxiaosong.com (client-ip=2001:41d0:203:375::b6; helo=out-182.mta1.migadu.com; envelope-from=chenxiaosong@chenxiaosong.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 364 seconds by postgrey-1.37 at boromir; Tue, 16 Jun 2026 22:55:05 AEST
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [IPv6:2001:41d0:203:375::b6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfn5P2tdmz2yZZ
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 22:55:05 +1000 (AEST)
Message-ID: <b6b19c84-7734-42ea-b2ec-9ace1f36ad08@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781614119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wv0+MgqNRvRce0wQH8tzVOBI1JIX52tUPZ58AWe7J8U=;
	b=DXl5YP4w2nX9zBF/auRW6duXvS9I+LFh6H72wP2z7tgKv4bVq1GepXsY8YwJgiuxk/3GYJ
	utsvh8oA1hM5Kec1L2eqj7x9jLuM39MuNcqFVWCQlxcbVvJf5UuT7X6eGlgcHbnkR/32DA
	5PNFdhWzOvpVWaJ/smJLv8N+zcFXXuBpa/tcwnDrn+6tX8vWPV0jrQwPKilpFVlwL6JsyU
	NgC8RocoDRsvVJelCGWkydzsykPdIiiMd9+HKmhv/CAAb0NJhfq7tp8HQgIgsnKJEnb/FJ
	zY3lj94Gbuc4hUnVoAKzBsLPkNkrQsg062VkaRzcyMkvx+Oemz6MzQHqkEjodQ==
Date: Tue, 16 Jun 2026 20:47:29 +0800
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
Subject: Re: [PATCH v4 30/30] CHANGES
To: David Howells <dhowells@redhat.com>,
 Christian Brauner <christian@brauner.io>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>,
 Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
 Marc Dionne <marc.dionne@auristor.com>,
 Eric Van Hensbergen <ericvh@kernel.org>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260616100821.2062304-1-dhowells@redhat.com>
 <20260616100821.2062304-31-dhowells@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260616100821.2062304-31-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Is this patch missing the subject and commit message?

On 6/16/26 18:08, David Howells wrote:
> ---
>   fs/netfs/iterator.c    | 22 ++++++++++++++--------
>   fs/netfs/read_retry.c  | 12 +++++++++---
>   fs/netfs/write_issue.c | 24 ++++++++++++++++++++++--
>   fs/netfs/write_retry.c | 23 ++++++++++++++---------
>   fs/nfs/fscache.c       |  3 ++-
>   fs/smb/client/file.c   |  2 +-
>   6 files changed, 62 insertions(+), 24 deletions(-)

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


