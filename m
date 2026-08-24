Return-Path: <linux-erofs+bounces-4336-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B84AC5DF9C
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 19:48:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTLzz0qYbz2y2c;
	Tue, 25 Aug 2026 05:47:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787600879;
	cv=none; b=P0pD+1tGjiMOFi1ApJqOdbXb8z0F6MR+RsAOMRe0sUSFZ/jy/pumin7JIOxbr8RlCidxlkIs2PlJNoIbpKh6ctkQz2IjsSl1b2PRMQC3L5JFQNCIBrV4fmiqvSUtS/Wxz1+7gbKt/bU6xapGB86q47UA2ujNSOGIEYJJIXWDEnYb3Syzs1ENr2xvnr6SzwD3j7LH81Bi5WFmnnIbSwMVV3+ihyx42WsPhPwG1guNKtf5gnDxwUcsl/F9clCT5fnH6mhWuV07e/Cjz0U5d/rHtwYAaG8TRgPaNwPI+e0Eb8TKjWxf6k3PhAJjMn9M6i6zc85/JjQFe0QHs5SnTzFQ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787600879; c=relaxed/relaxed;
	bh=8qU5H5HsiL1oxbfqE/+7Bg2lwE3XezcgSQ9LHhL9wLs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:Date:
	 Message-ID:Content-Type; b=cJTac4SZCD4Hs77npIHdqbG4Xe4cNOKP7i5VsdorZIxRTnq0ZK9q52xdKmGHCK5PW3FBaGbMV4e1fmo2Syk8LeVCPA9R/K5EBAqW8cTFBquxeEnvr12A+ZPGNYzg9A8/wc3A20zd/aNzKQQ05mUIja0WNxkN588eqwxezc21toxlUOErkl1LdNBXyHuNPeMf5BBJF6/La6oyI6msQ3WG/pG7wWMS94PVgTstYGMNkxKqCy/7E7SHgZr1pGfvwhK0D/xBVNcxv4er0fbPT5ZDxN9MShiaqkU4xWyCxq1SwjVsw7dGxdq1RL6iv8f0S15F/xhN+UlbNLMSdBdEO0+BGw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J/30wJza; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J/30wJza; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J/30wJza;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J/30wJza;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTLzx3SNWz2xr2
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 05:47:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787600871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qU5H5HsiL1oxbfqE/+7Bg2lwE3XezcgSQ9LHhL9wLs=;
	b=J/30wJzaei/aNv5opuVaMnqi988aTl7eq9ShdszZmcmW8ziandGBDLYn4xRRQKbeNJymFF
	cZCxYCckQTACQWCywKnBXArLxeqRPH0Pmx7mUuFOkcpuLvF2yu03CC0yrm548s82Ggza+e
	yWwDnF/FFSDrChU4LU8NsfA2XVm8ORc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787600871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qU5H5HsiL1oxbfqE/+7Bg2lwE3XezcgSQ9LHhL9wLs=;
	b=J/30wJzaei/aNv5opuVaMnqi988aTl7eq9ShdszZmcmW8ziandGBDLYn4xRRQKbeNJymFF
	cZCxYCckQTACQWCywKnBXArLxeqRPH0Pmx7mUuFOkcpuLvF2yu03CC0yrm548s82Ggza+e
	yWwDnF/FFSDrChU4LU8NsfA2XVm8ORc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-9XFVDZNVN-aHPcQHKQgWyA-1; Mon,
 24 Aug 2026 15:47:45 -0400
X-MC-Unique: 9XFVDZNVN-aHPcQHKQgWyA-1
X-Mimecast-MFC-AGG-ID: 9XFVDZNVN-aHPcQHKQgWyA_1787600862
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D45F184B396;
	Mon, 24 Aug 2026 19:47:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.15])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C8E871944B2A;
	Mon, 24 Aug 2026 19:47:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+1jF5qPZUhCevwbu7zQDEVWss6gMdoDMhqKqH3k7v=WStRtEA@mail.gmail.com>
References: <CA+1jF5qPZUhCevwbu7zQDEVWss6gMdoDMhqKqH3k7v=WStRtEA@mail.gmail.com> <20260824144130.759997-1-dhowells@redhat.com> <20260824144130.759997-31-dhowells@redhat.com>
To: =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FAur=3DC3=3DA9lien=5FCouderc=3F=3D?= <aurelien.couderc2002@gmail.com>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Christian Brauner <christian@brauner.io>,
    Matthew Wilcox <willy@infradead.org>,
    Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    Leon Romanovsky <leon@kernel.org>,
    Namjae Jeon <linkinjeon@kernel.org>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Marc Dionne <marc.dionne@auristor.com>,
    Stefan Metzmacher <metze@samba.org>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
    ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
    linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: READ_PLUS in NetFS? Re: [PATCH v10 30/35] netfs: Simplify read abandonment
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
Date: Mon, 24 Aug 2026 20:47:30 +0100
Message-ID: <771538.1787600850@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: R9MJMmj6ZD0IyntSB3uQAPLvS0Ler5x0TpIPuknHrJU_1787600862
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Aur=C3=A9lien Couderc <aurelien.couderc2002@gmail.com> wrote:

> What about READ_PLUS, i.e. sparse file reads? If you do this kind of
> work of handling partial abandonment, can such a work also benefit
> READ_PLUS?

READ_PLUS is NFS, right?

I'm not sure it would particularly help or hinder.

The VFS/VM only asks to read contiguous regions and netfslib breaks that up
into subrequests, but currently netfslib doesn't know anything about sparse
reads.  What I'm looking at with Ceph, for example, is that Ceph knows wher=
e
the gaps are and will clear them before terminating the subrequest.

Partial abandonment is for when some sort of fatal error occurs and we cann=
ot
finish the request.

David


