Return-Path: <linux-erofs+bounces-4186-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A61FC5AD7B
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 20:31:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJmcg32cLz2yrW;
	Tue, 11 Aug 2026 06:31:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786393891;
	cv=none; b=EzYSSKCyDT6GVpLCo9ikQWdUjCKW/jxgnFDRkEL8vpScEEOOu4PR/P4M5IfHAThMl1d28w0l7MoRYndEvS2ON6UUyZMygClitHQsHzBHR6Om2+kobtnQPLaNt86Qm4woWRmQkQWtWQx6Vjk+r+IYlhUMQfFRoJVa7Ic2gf8fxuXhpioisBJ/DtLhX/vjiEOc+yjo4hZKOgxYHYdc+8en2lpkRfZ3CI+U+Qft3ialrfaU+Ep6/W4kam6dUaq89klnTtl07y3sbpw9Jeue2VkfBsYQoNBeS8gu0nsF3dwbSk7BNeTUVScT7XQQhI2LpKAiNu6uflM2GAySPW5WP4Sd+w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786393891; c=relaxed/relaxed;
	bh=N+nHIX4qndv3AfBXSobDAVXCw7W2PVPh2/yZZQrRWZU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:Date:
	 Message-ID:Content-Type; b=PUH3i+iM171qSFSNGkxcnydYlBxBguWoNt70jKZtbssX3HtY1Bs8CwoAzSN05ro0zxKyIC03YJQnVT/foGlGADxoaQ1VhvLWE/7zdblCRJGwBrpslUUwghzxjNp8v/je7oionhX8qSsZvDSptpT5Ag/VcZ2roqrBWFCuBRl9XgrKWkVJAPnVUChEpX1Gh7D8blFxlgc0Kc4kJpVjGT/qpaK1ReYESbX0e6KRmZT2hCp00irLZ6e6hJbjtxFlKOaYJDvvDrte/pP2Jymy6yJpjiazewRxBa31icpYA0otkcljj3CNKdvwjehtNhp/x39rVgfAsYwZA5UIQKc7uZVmqw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cWLbI9Dj; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DFiienUg; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cWLbI9Dj;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DFiienUg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJmcd5TcQz2xLf
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 06:31:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786393883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N+nHIX4qndv3AfBXSobDAVXCw7W2PVPh2/yZZQrRWZU=;
	b=cWLbI9DjNZqP0bOUzpNFWt4VUzsxt6tCIww0Ph97nrSdcZFKCYwjcVCddbpcrG4O4LJJa4
	DE7QACMNte5lUMzuMX7mZWsc+HOQR86/6vFdJvLe1vbImzaLoJF1w3kKi3BfSY79taWME2
	b2qxD0gRoL7DF8ClSY3qDTNmEGsRYQ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786393884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N+nHIX4qndv3AfBXSobDAVXCw7W2PVPh2/yZZQrRWZU=;
	b=DFiienUgnF3IlOJMVoM+bk5Jlh6DaIAQmvROAblki+M0HbGvCADmIzd/awcB0k9hyuGH0e
	Y1+YNy5ixtQ5bvLUlIXmU+sDUklUWvEC+aE/CCpe+ouoV76opboFK+Uo/78S7tQ4T5HST+
	J6W+JO0P+2/7xQq77AORKmV6sZFABZw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-8366SUk-OtWzAoVznGm_-g-1; Mon,
 10 Aug 2026 16:31:19 -0400
X-MC-Unique: 8366SUk-OtWzAoVznGm_-g-1
X-Mimecast-MFC-AGG-ID: 8366SUk-OtWzAoVznGm_-g_1786393877
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03F33195608A;
	Mon, 10 Aug 2026 20:31:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2A89D1800346;
	Mon, 10 Aug 2026 20:31:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <anooK9-UCNTmoSAq@casper.infradead.org>
References: <anooK9-UCNTmoSAq@casper.infradead.org> <20260810144746.574036-1-dhowells@redhat.com> <20260810144746.574036-5-dhowells@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Christoph Hellwig <hch@infradead.org>,
    Paulo Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>,
    Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Marc Dionne <marc.dionne@auristor.com>,
    Stefan Metzmacher <metze@samba.org>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-block@vger.kernel.org
Subject: Re: [PATCH v9 04/26] Add a function to kmap one page of a multipage bio_vec
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
Date: Mon, 10 Aug 2026 21:31:03 +0100
Message-ID: <586048.1786393863@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: bGKn2caPBYVVck_vaFDrdA0zQCpp-YUH9fplEmD7XYU_1786393877
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <586047.1786393863.1@warthog.procyon.org.uk>

Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Aug 10, 2026 at 03:47:21PM +0100, David Howells wrote:
> > Add a function to kmap one page of a multipage bio_vec by offset (which is
> > added to the offset in the bio_vec internally).  The caller is responsible
> > for calculating how much of the page is then available.
> 
> I think this should be kmap_local_bvec().  Living in bvec.h makes sense,
> but keeping it in the kmap_local_ namespace is better than putting it in
> the bvec_ namespace.

Christoph disagrees with you:-/

David


