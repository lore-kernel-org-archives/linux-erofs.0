Return-Path: <linux-erofs+bounces-3289-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9E2ED7B86
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Apr 2026 08:02:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fvxZx0H2cz2yFl;
	Tue, 14 Apr 2026 18:02:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776153752;
	cv=none; b=Nb/8kSVZr0WDnnQloQ1OjO2K6tzuR2BgoqPBzf6atHsFVxXCphLtFYcDgjiUFozPv9aFOu4p0EkoGDTrbevmsWXcvwjOD7SFa8iVZDxhfdNCdFf+zEhR+mbyC71Zw4xg+lEzChvP9NbdYy5r1E9vZuQm8o74z3iMY32ZO6H7YlHZW8OIkGKDteC7EUhKIcOirhfKBGmy1NjO9qMG8jPSs96AeaLcFAX2z4ZQmgMle6RMUYwBx9NjFtlVoezRZoUnMgj+CzAxGK3RvNIeMVRtNLK54MzCZdVrRlVSwl35a+9q0obw1s67TRth5z8mj1mu/Ff9cMUJCaTUJw22/X6Q3g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776153752; c=relaxed/relaxed;
	bh=JJFZCN3rB5RE2spFMluEVpX8vCNqZ50mkbSkFhz2niU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:Date:
	 Message-ID:Content-Type; b=i1NVKAdkUhHmEpmRQ/t85wIapH48e4R1hSs00F636e6G18/aKhyA8AbFwZNWOKLdJupv+KJzoTSFQk3bpAsZEWN3c3V/pkHCHkOTDNjm1Meb1kdIwpmOWMpNw1kP/MxGFKEpEFOzTrMEvigifwrvRYmXElvylgZ1KHF0JPq1w8yu9M0RWtxsFys5GfY16sl1uHMUNuQWAUNcSzfsp6ssedXXJz4rCIPIr8OC92QBnfQyDjM78WESHCHi3yuxtGZAoOdZWMwvg4/9ZuEDZltfmp53tmI+4gvVIHUeeIK/c9L+jU4CEOGdYW8LSUo+KuKNjZtXkRXSX1RSnLQjFrGCmQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RGxZjl2z; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=feNrTJkR; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RGxZjl2z;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=feNrTJkR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fvxZq2Bw5z2xnj
	for <linux-erofs@lists.ozlabs.org>; Tue, 14 Apr 2026 18:02:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776153740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJFZCN3rB5RE2spFMluEVpX8vCNqZ50mkbSkFhz2niU=;
	b=RGxZjl2z6/cfQWb/f1fhIvHSQ5QozDL3lWjRDjqJyYEpvlgzziZ+kyCNpmifTw8510d3aU
	gotHfV7QGVvZTib9GhWN5I/XsBjIGs6aVSKc6Hon5F1HifVa4S458LU4ni2tV1GZ8Xh0+M
	xfg0oO2PpyKN67SrYPyLCQNcHdTzjg8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776153741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJFZCN3rB5RE2spFMluEVpX8vCNqZ50mkbSkFhz2niU=;
	b=feNrTJkR4WiFL5NXDk6u3zqL4e+UjNweWA9DB6zTAH0i5ZITz4mfBwnEM0viAcZagZxfao
	T3gsHGJpLTkjGS/ZfJNEHp9UOZZsObRcHtAsUR660HXEQ6q9i6j/k2HE41vZna5JVo0QmL
	fEsdGdQLzsXL56XvvKOwaFpanEY9ohE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-e-mrVy0ROXuXltmJMHSNPA-1; Tue,
 14 Apr 2026 04:02:16 -0400
X-MC-Unique: e-mrVy0ROXuXltmJMHSNPA-1
X-Mimecast-MFC-AGG-ID: e-mrVy0ROXuXltmJMHSNPA_1776153733
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22DE118011FF;
	Tue, 14 Apr 2026 08:02:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.34.160])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 227F518002A6;
	Tue, 14 Apr 2026 08:02:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <9639cd12-5e9d-4eb4-9d9c-f5047ccad7b7@samba.org>
References: <9639cd12-5e9d-4eb4-9d9c-f5047ccad7b7@samba.org> <52ad0aa6-d8dd-4ba1-adf2-f79128df9d90@samba.org> <20260326104544.509518-1-dhowells@redhat.com> <1180465.1774867781@warthog.procyon.org.uk>
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
Date: Tue, 14 Apr 2026 09:02:00 +0100
Message-ID: <3755493.1776153720@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 7szJWsTYFbwIht1GObsiqPVTDCnok5IGfpJ-Gh_OcDo_1776153733
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3755492.1776153720.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable

Stefan Metzmacher <metze@samba.org> wrote:

> Any idea on how to resolve the actual conflict?

I didn't manage to beat the bugs out in time (turned out several were
preexisting).

However, if you look here:

https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?=
h=3Dcifs-next

I've stacked my patchset on top of yours and modified smbdirect_connection.=
c
appropriately.

David


