Return-Path: <linux-erofs+bounces-3069-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B9810F3DF2
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:39:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmWJ5ZYfz2ySc;
	Sun, 29 Mar 2026 05:39:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774723148;
	cv=none; b=Z1niGoh4NN54brBbCqsWUN1uGCoqDbc3unxTs+tGoNP1WyYVHTSpMPxvgomQbNXspUkg64r/6GV2X6RKmmno7QhnSkNF3S6b++3B6BxRzE+9S6DcaIJ3259/bs0vYaDIUrvfbKTjz/tqJkOnSa6f7sxpayyTqIycPnP22LpFL70l/4x0oFV/tHzCKWqHt1njf4/6kqK141kOGE/HCCH3WmShYkgMpZRR+aN6GCtSJ0ANfGEgXj8ZeaWCbTBOh20MPdwxDaAmIGUeW3MMIaxvFJqEG6IgF7g7vnU+HAJw1Najk/EaqCHOhqv6YxCMukECHoGIgAAqN891ZJT3p+mg9A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774723148; c=relaxed/relaxed;
	bh=573aDEoyqmB61T/dYpePm3T63TSWPVNoRFziOtXONZk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=fQnN9tCvsBjMTPG1YFOWEdSz812GXm4fzAC322vhi/qqV648giKxFsdnmB7SVVmArD3JH4EQgdOTT5iifthuC4MGBq5mI3qwHW8kWfzP718PCM8xzJAtr888yU7otSNGd5A5emhb8WhlkzSvxC7rLZRKj7DujQ7F+a7xpNUh/FJRB+67TihpUJ4L55iMNTy8ExRUZd56SXxKVsF7+/l2uBJwLHoDBn28vPi1OlESfciNOaSUNAM+xqZ3wZ24W0vQjS9ystwD1KH6P0gsYt8hvqR98OwzqAWg16geq9NzQ3espAhmy9SQRD/jPD8ILP8uz8a87jWBqvaQefOjHRMOQQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=MuZX7p6p; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=MuZX7p6p;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmWH6bHrz2ySY
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:39:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Sender:Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=573aDEoyqmB61T/dYpePm3T63TSWPVNoRFziOtXONZk=; b=MuZX7p6pzKIlQ3I0kaGk10H+pA
	Gazy/lgHL4MMCy5gdYvuHCReAEsbI5h46iNkJk1M6vOsIdWP9H7my0T4BhALIgC6Lqp42Hhluw3sv
	gWyZIZ3xyQTVb/Y6Ps23tLcy/xOBhkBcgoMoqdMAYJ8arztBwiNprhtee5vVVI76BcwY3aA/E9Tyc
	hpBcRfyzKF1H4va+eua/rAfChu37qKLnGNFGjon2IWifvopnUl1EVx+kL+HxflKvCyVuYslSa2/dA
	Kw79773RJd+cafugBKuLkMwxMocSCrZKGEZUSP4peyWDjZAr05StLW/oYivnEqmQO4wwoPX+aZwV5
	VQdMT1ZA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YYr-00000001nqE-1oex;
	Sat, 28 Mar 2026 15:39:05 -0300
Message-ID: <73421f900b67a945faf33887ae581759@manguebit.com>
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
Subject: Re: [PATCH 11/26] Add a function to kmap one page of a multipage
 bio_vec
In-Reply-To: <20260326104544.509518-12-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-12-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:39:05 -0300
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

> Add a function to kmap one page of a multipage bio_vec by offset (which is
> added to the offset in the bio_vec internally).  The caller is responsible
> for calculating how much of the page is then available.
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
>  include/linux/bvec.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

