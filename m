Return-Path: <linux-erofs+bounces-3515-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69478CD6E6D
	for <linux-erofs@archiver.kernel.org>; Thu,  4 Jun 2026 14:26:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gWRh35GzMz2y1Y;
	Fri, 05 Jun 2026 00:26:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780583171;
	cv=none; b=MY5r5nGm8Fkz63LsY4ds/uABSrJrmBkELbrmmgMKwtKBeOvUdHFRet+b0E11euw7AJ5fpGUjhdVrPOVbzhOKilXn7gAL7gAwPNtFXJT33jhUME7oK+LWtO75UkDq3CnDue3bV8gQ7CWVrQJd+vGpyBPTazGEY+CjhHEM18imh6YHMS6hdo25mggNzMWfUACFGa753BzgIcy6oVcCNfW+O5YlHBXo6Tfk4bAzCYvmjz0f7s/k4sQAHtHL3i/lc2ykhDBaL97KRFLUNa7Hx3EhP2tfltCeGbpixrU2GGMXsZnHH5VCv/fIIctEks33RPl7Mo2qnUq/2cZrftBELmDDmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780583171; c=relaxed/relaxed;
	bh=+hEgi4Js9Sg/b57dL6O3ikI5IA10/Ul0ztOGbyS/4bs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:Date:
	 Message-ID:Content-Type; b=l0IFk43kiighDFqImLZyTVbRG6Jd7h8BNepLovnSYXnmLGUIpXGXkqfe/Sku1P29LT1ZBjjXQ0qj8vBoVfELqbppG+e6NOeQGGKFQMvM44qRdBkrfZ5RrQEjrTsE7LZGvHHQYaMPeYZvygBoPpYFZLO7NA2ZP6H2TXtD72mGAGPPy+7TPMVZNgpbSafiGt/cJnIKiUz2uKnAKNHI/6K0t/uAQ8W7fqYugyvB0noZhrJOV5wf2lmeu1nd5WavU4Ta9iFG2TIBVsyMyzVMain1qPBMtx6XMixRDobxeipNSZxPXy6Ya/GaJUxe1htQsgqDaX/vTYF+l7Yn6ZCNDFvcDw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U1i6t3pi; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U1i6t3pi; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U1i6t3pi;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U1i6t3pi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gWRh21fdkz2xfB
	for <linux-erofs@lists.ozlabs.org>; Fri, 05 Jun 2026 00:26:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780583164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+hEgi4Js9Sg/b57dL6O3ikI5IA10/Ul0ztOGbyS/4bs=;
	b=U1i6t3piarlYuMh87LLfl7vs5YWK9KMQ0be75+cGzmsuNH0Ezybq1SaoYfUivmwmPayoao
	ZlZ8ktMI+PQs+MLoPS40c8f7W7+0s0aWoN8t2kcfPUAdxi6c9rDzAzvloOBSHcbnxanKsm
	gN96Gw3yarsXleZSquuWLcvdglRjtx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780583164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+hEgi4Js9Sg/b57dL6O3ikI5IA10/Ul0ztOGbyS/4bs=;
	b=U1i6t3piarlYuMh87LLfl7vs5YWK9KMQ0be75+cGzmsuNH0Ezybq1SaoYfUivmwmPayoao
	ZlZ8ktMI+PQs+MLoPS40c8f7W7+0s0aWoN8t2kcfPUAdxi6c9rDzAzvloOBSHcbnxanKsm
	gN96Gw3yarsXleZSquuWLcvdglRjtx4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-010EzjtuPq6sAk9ZnnOTDQ-1; Thu,
 04 Jun 2026 10:26:00 -0400
X-MC-Unique: 010EzjtuPq6sAk9ZnnOTDQ-1
X-Mimecast-MFC-AGG-ID: 010EzjtuPq6sAk9ZnnOTDQ_1780583158
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2813A1956094;
	Thu,  4 Jun 2026 14:25:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.50.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F3B2130001A1;
	Thu,  4 Jun 2026 14:25:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ahPodavlA-gt44FO@infradead.org>
References: <ahPodavlA-gt44FO@infradead.org> <20260518222959.488126-1-dhowells@redhat.com> <20260518222959.488126-6-dhowells@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Matthew Wilcox <willy@infradead.org>,
    Paulo Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>,
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
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-block@vger.kernel.org
Subject: Re: [PATCH v2 05/21] Add a function to kmap one page of a multipage bio_vec
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
Date: Thu, 04 Jun 2026 15:25:46 +0100
Message-ID: <127138.1780583146@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: lt0KzR68akmLudO4HVLyrM5f-4YdgXZjGqztDLVdVmg_1780583158
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <127137.1780583146.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> wrote:

> > +static inline void *kmap_local_bvec(struct bio_vec *bvec, size_t offse=
t)
>=20
> The name is rather confusing for something that does not map the entire
> bvec, and is an anagram of the existing bvec_kmap_local.  So please
> rename it to bvec_kmap_partial or something.

Sure...  But it then differs in pattern from the various kmap_local_*() tha=
t
we have.

> > +{
> > +=09offset +=3D bvec->bv_offset;
> > +
> > +=09return kmap_local_page(bvec->bv_page + offset / PAGE_SIZE) + offset=
 % PAGE_SIZE;
>=20
> ...  Also this can use shits and byte masking to be a tad more efficient =
and
> matching the rest of the bvec code.

PAGE_SIZE is a constant power-of-2, so it shouldn't make a difference if th=
e
compiler is doing its job properly, but okay.

One thought: I could just give bvec_kmap_local() an offset parameter and us=
e
that instead.

> Users of this would be interesting

It's used four times in patch 10 ("afs: Use a bvecq to hold dir content rat=
her
than folioq").  I could merge this patch (patch 5) into one of the other
patches, it's just been more convenient for it not be in a later patch when
flipping backwards and forwards to cut down on recompiling.

> and why you're not simply using a bvec_iter at page granularity, which is
> what other block kmap code does.

Because for the most part I don't want to do linear iteration.  There are a
number of cases:

 (*) Read-link and follow-link: For symlinks, there will only be a single
     block and it will fit within PAGE_SIZE.

 (*) Readdir and dir checking: I iterate over the directory contents using
     iov_iter and iterate_bvecq(), though I could also use bvec_iter inside=
 a
     loop to step through the bvecq chain.

 (*) Lookup: Follows the hash chain in the directory rather than searching
     linearly.

 (*) Editing of local directory copy: Doesn't do linear iteration, but rath=
er
     does random access of blocks in the directory.  (This is to avoid havi=
ng
     to reload the dir from the server when doing mkdir, rename, etc.)

Note that directories are 2K, not PAGE_SIZE, and, when editing, I may need =
to
modify more than one block in a directory operation and they may share a pa=
ge
(which may be part of a higher order page).  Can we drop 32-bit arches yet =
-
or, at least, highem support?

David


