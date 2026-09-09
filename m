Return-Path: <linux-erofs+bounces-4524-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA99C79FBB
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Sep 2026 21:22:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hgDKZ3GJpz302T;
	Thu, 10 Sep 2026 07:22:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788988946;
	cv=none; b=I6KjNcfvqL7PfS6nL0Q4JWjgTUjfBEL783C/XcK2DeIOZHLClQDoODepz9cGK45WsEq8qreaXysISFJHWe5lMT4D3aPCEog/GLR1CSrGRujPc/B+UbgBC/jDLyStlKAn/2HewXPjvJe+x/gH4rlx7hgcUlgaoCPqk/5ldnMwSsyW6aT2ox7lH0UdTzi3u0+KnNu5J4WSMOXrXprGI0+inAvG22o2E2hMYsELxymhI1AhMR6lKthgW6smz/ntSeMfq05Z3jPW8aUyAGLPvGW/FpzoFmdg+0Qi72KsIID7YJgqdj/IXyu89WC0j23JbSj4kH7Z5o1b7bePvesgWN9Pmw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788988946; c=relaxed/relaxed;
	bh=XsW6lJv/Bxdj2Oiz5fJR6QVOHYJCmPAhWfl3TIaVqsE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=AScdHHEJT6dtaReP4GykD01oV4+Xp6hij7hqktR36G9XRXurbYVqWraasZFDwdizDH3gSEb9AwrZTE7tjfzNziys5CfAo54Lli7c++96DBgb5lURPOsIv+nA8y+RiH5QvsIfOQShNvdH9bRoY2Q9p6PpgnTCnON81Oh0rV46n9R9NWCphHLWuO4Ae+5wXwPdT/jvjyn+Tc6paHMzLD0I5fPE7cboe2z5aNpcjc+vqLOlXqSA4bCy/dFyniTeBy5JacIuZopgtl2hOAP+1xye8G6KHPUX8YVvAt6oEChryEJuU658TpJ6VVg5imz1QjxtazjMa622kphifRBG2WZuAw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=nvPxz3C1; dkim-atps=neutral; spf=pass (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org) smtp.mailfrom=manguebit.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=nvPxz3C1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=manguebit.org (client-ip=143.255.12.172; helo=mx1.manguebit.org; envelope-from=pc@manguebit.org; receiver=lists.ozlabs.org)
X-Greylist: delayed 1194 seconds by postgrey-1.37 at boromir; Thu, 10 Sep 2026 07:22:24 AEST
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hgDKX08Kjz2yyJ
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 07:22:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XsW6lJv/Bxdj2Oiz5fJR6QVOHYJCmPAhWfl3TIaVqsE=; b=nvPxz3C1HCEzGPmCdRVEArPWdb
	bAiKEoVUeEHWMf10rF39TDfqobn3II5ANtmoNi+bLfojXAY/Dj9TfjWusQtYJUMgcrTXmxeX9jx1w
	RaalzMmKyu4mlaasbHSPzH0BGEergiJtp9KOaB453dEAOXahz96SQ2VmLWzn4xC0Oe0qTqK2iXRYR
	l2g/jkSNsmpt9X7oqdXvZFPVz+mq74UdeKX5LleBRDeXEZAD8k2RK30rkw9KXPJsLgQHpMTrps641
	t5XBovqqp7Y4U7laHq/4g3TA1A4A+twfjM009AdSX7Cw5LsJHRVHkYktJ7vGfKqI4SOQyN+EPMFN1
	s/ZFOktA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4PQq-0000000146Q-3izt;
	Wed, 09 Sep 2026 18:02:12 -0300
Message-ID: <b38953d143e8949d66415c461f46eb68@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner
 <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>, Matthew Wilcox
 <willy@infradead.org>, Namjae Jeon <linkinjeon@kernel.org>, Marc Dionne
 <marc.dionne@auristor.com>, Stefan Metzmacher <metze@samba.org>, Eric Van
 Hensbergen <ericvh@kernel.org>, Dominique Martinet
 <asmadeus@codewreck.org>, Ilya Dryomov <idryomov@gmail.com>,
 netfs@lists.linux.dev, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v13 8/8] netfs: Set subrequest->source at alloc before
 trace emission
In-Reply-To: <20260909072105.1663687-9-dhowells@redhat.com>
References: <20260909072105.1663687-1-dhowells@redhat.com>
 <20260909072105.1663687-9-dhowells@redhat.com>
Date: Wed, 09 Sep 2026 18:02:12 -0300
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

> Set subrequest->source in netfs_alloc_subrequest() before we emit the trace
> line indicating we allocated the subrequest.  Note that this requires the
> allocation of the subreq in netfs_read_to_pagecache() to be pushed to after
> the decision about what sort of subreq it should be.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org

Reviewed-by: Paulo Alcantara <pc@manguebit.org>

