Return-Path: <linux-erofs+bounces-3062-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054B410F3DF2
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Mar 2026 18:25:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fjmCK4RKdz2ySc;
	Sun, 29 Mar 2026 05:25:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774722317;
	cv=none; b=d8FbXEu6hFkVRCQznZGlhzqZN/dqz7W4OJUbvzBiFMvTv3SKHDbkIV8Tzao8/0Qz6vdqOZ9TKfIDaFz5Ws9WdtbEdUbTYdeqQsQG4lKmxreZ+H9PuPdk9jMh+//fIQ+SBDTfecyVF4L1JVHNWWhJxvlKZHo6ycdPq9PHI79k700azf5KhfCYgpSgwm+xuz63khfYI3Iph4MUXbdoFjt6WuI5dFuxRYzCbFk/P516Xhv6ux+70M8Ruxl+pUln0+NO4DmxR4VflYQDT/AxNCReJBmHB7ksKg4ryx0J5UQxjb4WPdDLtNl1+LC5Mv0etfu55t+Aprn7B1YjbYMwfqhtpw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774722317; c=relaxed/relaxed;
	bh=Z69I1zT1OmIlOxzc4+bvhIZk7bvq6mzxmN8fD3QRepI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ggWr74sgQxwPWwP0CbfXAwNf3ruxg882aVcHdIlYUHoadiGccbqQdKyXA3yn4A9+4Tkf71TDnQVFVz7wIOvyn2TAe7Oh6cEM6cAfYCBYYTe0EYmUg04vrYMCD1D5KsTs0Yw+Hnm4KrZyTkMKLt9WcVhsj9/xM1bv20/fwc8Sz3pys95tZGV6DC3z37WCnpQ2Vq59FVN6DY2jzjLZOutME79mYw22YHlbPfgwZjhQ7SWFo+zC6U2JFt1LQBmvaVuO7vQSLU27yNujanoCZ4ZVFvTsdQj28yQLosVqhkMLMRyl4iNDL+UKrKxo63OTCblN7pRLf5h+KedxHXX8JLX6ag==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=TMb9A7G/; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=TMb9A7G/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fjmCJ6G90z2ySY
	for <linux-erofs@lists.ozlabs.org>; Sun, 29 Mar 2026 05:25:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z69I1zT1OmIlOxzc4+bvhIZk7bvq6mzxmN8fD3QRepI=; b=TMb9A7G/pcnhz10NHFrg51PrVr
	3wlDJUa9zCWpkzSuigzyubHdRaeadFWW5bNIQfibjOzJ36gZsqXjoEz2im+IrkaFsOMQi+703Ihf9
	V7cCTXht/7WmOhky3lKQ6qotzFfoDoJMprWEz4wD4ipBzN5t5VXUZKnbjWZ2zROFgvAghvudMEd8i
	z9rG34/EoZdtH4RtujdOR1Esk9o79ocIv83FbWbNMlzWKBVeG7jxKZ3SXAy+Boo03lDODOKmgkGq5
	PHcLbA7CrwToSA+EgZdrKMzTURZWJ1Yw9pn2KYFPlsCDrC7DFEr+0uWauT/U2dcFXrLN75pImJJ5x
	n2Iw4NyQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YLS-00000001ni6-2udw;
	Sat, 28 Mar 2026 15:25:14 -0300
Message-ID: <1776cecc9268b81b426c041fdceae5f8@manguebit.org>
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
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/26] netfs: Fix read abandonment during retry
In-Reply-To: <20260326104544.509518-6-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-6-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:25:14 -0300
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

> Under certain circumstances, all the remaining subrequests from a read
> request will get abandoned during retry.  The abandonment process expects
> the 'subreq' variable to be set to the place to start abandonment from, but
> it doesn't always have a useful value (it will be uninitialised on the
> first pass through the loop and it may point to a deleted subrequest on
> later passes).
>
> Fix the first jump to "abandon:" to set subreq to the start of the first
> subrequest expected to need retry (which, in this abandonment case, turned
> out unexpectedly to no longer have NEED_RETRY set).
>
> Also clear the subreq pointer after discarding superfluous retryable
> subrequests to cause an oops if we do try to access it.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
> ---
>  fs/netfs/read_retry.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

