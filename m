Return-Path: <linux-erofs+bounces-3115-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13F9FB3D17
	for <linux-erofs@archiver.kernel.org>; Mon, 30 Mar 2026 10:50:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fkp1G2qjpz2xpt;
	Mon, 30 Mar 2026 21:50:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774867810;
	cv=none; b=NombpD+eUzE4M2W7w68/pfrjapRasZTExoyP5i9eUPpMllNHnjbjd9fbci2GkaFE9CNTPqsYFGBvdXQrDeYi+FW6cGY4dE9caTqrGOeHHDh6pcGVabhveJXyckWnW/RfX0SOJGpeVx4nB5cXQ6fLpgn8qtx/BWE/pX8eS+A72vfA77KMxddqqPpT8400jVpAsCYB4kLlwXN+7OmEiRM3kj1aCUN8lUFM1roqWs5KablhcBWIqbOuUlMJ2KH0w3Bd1lu2rqrwyZb8MHGgJ465PsP3RajXyHLx/nd9DW/cEUTBf3x0DA/Rq/nvX0Xb5WsUHLgjHHAW6iKKzCCXVgkiCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774867810; c=relaxed/relaxed;
	bh=4WG/SeRSfzsyNWeLhZKLjrg2/KPXx46Pf/FiBPy0PmY=;
	h=In-Reply-To:References:To:Cc:Subject:MIME-Version:From:Date:
	 Message-ID:Content-Type; b=JstE6qPQkK3S8wjO1Xxvnv9iWRjHo/5ZveVi+whHuJOSBOGaZ2Jj4vLiQFJUbKFeCTA3jt4yfZO+QKNQWeOnQ1eavJHlhfA9SGHNIOrY+xypYM+ar4XQuFzEYJ7vfdJ+cpFnvLgjoFwT05z5JFL57YY35YTNCyfTZzW79MwReRULuOuP/oYr4xfWwQTXZ2ALNfrhXZ9f4WBoPELkoizoiSVpbYoqaXH5HcKaF1zA75ymE3+3uJeCXv5uRUmfjb2LHrNcz/nhXicncW8tUhmqbu1L1Cx84yCz19foa+8Ttq5fFBOBMkAJQDh4UJyOwbHrzfAUKH8qsgIP/+BbJIVL0w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=houGbcd0; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=houGbcd0; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=houGbcd0;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=houGbcd0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fkp1D74nLz2xlK
	for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 21:50:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774867802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4WG/SeRSfzsyNWeLhZKLjrg2/KPXx46Pf/FiBPy0PmY=;
	b=houGbcd0Jc2a8fiOvBhdq/afzjWyqe5nmyXp8PhUwDLY2tccFaDjNUw0pkh18V+pajlDOx
	+ZRn4WbJ0DeL22l/wowZ4FmXbttHsAGbRW5lRfIQJ66UUqsEr5Y8d3gv65KNbgpiptBVyM
	Un4/kF69Z9zY/3k0MKCj6HsBLqMr27M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774867802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4WG/SeRSfzsyNWeLhZKLjrg2/KPXx46Pf/FiBPy0PmY=;
	b=houGbcd0Jc2a8fiOvBhdq/afzjWyqe5nmyXp8PhUwDLY2tccFaDjNUw0pkh18V+pajlDOx
	+ZRn4WbJ0DeL22l/wowZ4FmXbttHsAGbRW5lRfIQJ66UUqsEr5Y8d3gv65KNbgpiptBVyM
	Un4/kF69Z9zY/3k0MKCj6HsBLqMr27M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-426-JLNIgM7fPXu4cdrMLHIQ5w-1; Mon,
 30 Mar 2026 06:49:58 -0400
X-MC-Unique: JLNIgM7fPXu4cdrMLHIQ5w-1
X-Mimecast-MFC-AGG-ID: JLNIgM7fPXu4cdrMLHIQ5w_1774867795
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B30281944F11;
	Mon, 30 Mar 2026 10:49:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.35.245])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 543211955D84;
	Mon, 30 Mar 2026 10:49:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <52ad0aa6-d8dd-4ba1-adf2-f79128df9d90@samba.org>
References: <52ad0aa6-d8dd-4ba1-adf2-f79128df9d90@samba.org> <20260326104544.509518-1-dhowells@redhat.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Matthew Wilcox <willy@infradead.org>,
    Christoph Hellwig <hch@infradead.org>,
    Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Paulo Alcantara <pc@manguebit.com>, Jens Axboe <axboe@kernel.dk>,
    Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Marc Dionne <marc.dionne@auristor.com>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>,
    Trond Myklebust <trondmy@kernel.org>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/26] netfs: Keep track of folios in a segmented bio_vec[] chain
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
From: David Howells <dhowells@redhat.com>
Date: Mon, 30 Mar 2026 11:49:41 +0100
Message-ID: <1180465.1774867781@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: RfuOJyDhdX4IsjnEhZKuATsuFZHC-HFYPhuqBgkzPBE_1774867795
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1005366.1774861048.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable

Stefan Metzmacher <metze@samba.org> wrote:

> Another possible way would be to skip this for now
> cifs: Remove support for ITER_KVEC/BVEC/FOLIOQ from smb_extract_iter_to_r=
dma()
> and I rebase my changes on top of Davids patches assuming they
> will be stable commits (at least up to
> cifs: Support ITER_BVECQ in smb_extract_iter_to_rdma())

I could certainly split my removal patch.  I want to remove FOLIOQ support,
but I can leave KVEC and/or BVEC if they're still needed.

David


