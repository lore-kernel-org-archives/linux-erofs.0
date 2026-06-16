Return-Path: <linux-erofs+bounces-3632-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A9ECD98E1
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 12:51:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfn1d0g6tz2ykX;
	Tue, 16 Jun 2026 22:51:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781614309;
	cv=none; b=J3XZiaO1ykwBam7Acr67RbF/IEJdaWB8w1SNwwrnPjQcg7lUHA/DyEuA+XqqDosZ5TxQ9CBg6W2kzvd9TrTwySj+qAeLOuT6hoxDTevOxfzeZS4UKaWRY4s7j8ep5nTtP8C5Tg00kzxeomQrT9WUtU0zuu3BmaDpU0avxm9yLtrsyngcNWCzfwrNXylrR6kbdyGhba4Bfi6aIherGo/OPTCshK6hHfhykadynLBr/lTzYONMNH6j/0Xq7pgOODGY88OaSrMm1PtFMlSX0dZ0LvYlLAx2N/c1hSusReubYxLHShwTcOBNxooMQyREbOHknvEZ5muROTgzGghaNeDbUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781614309; c=relaxed/relaxed;
	bh=2f4COWRiqc1S5CKA80N1C8fgQscr8BG6DIsFW1ivm9s=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:Date:
	 Message-ID:Content-Type; b=J/EdQAXdOcW4xsS1ZcRjAMDxDKHOJuID9KG0WgSi16NC7v9D+Rd6yLCmDAyYDCDCzZSkWnZl985pwhCpA9z2nc9xWJ7cexXFy63SbaJLhRKro/D4JrR/UEjw9IfV3Krc263/8FQsEg0KOlnVgfnABzG62t+VYnr0ekAisxBsoEV953tQI1HAFXRJowIOr//P6+72J15cPno/ifwkIXV/J5orL4VQTexT2FGDAt8/aQD+oAecBceYk5MCsOgRuUXZTLW2vkkfEkXI/ANnNN1knTKsdg0/2eXTrs3wwS6xtfRllTz9/+m3XDrG1trbtzw2YBqd3VYxs/nZSxO8J2WzYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iG2xFe5y; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hov/D7OX; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iG2xFe5y;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hov/D7OX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfn1b5drcz2yZZ
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 22:51:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781614302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2f4COWRiqc1S5CKA80N1C8fgQscr8BG6DIsFW1ivm9s=;
	b=iG2xFe5yczJEt0ulHy4Dq5jsci/WLDJuFlkdnrzkvvngUJa4EZt+8OgJhaw1Yiv2L4kccK
	qFGjM51yLy+0a6j2RityLY5YA0s+Ail3yK3tSKZbMgj/vVkE/sfp/251mpZ8BYqFKTchx0
	6dRG3JQ3Sot9pNQ6hKyVMQ80sKwLitU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781614303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2f4COWRiqc1S5CKA80N1C8fgQscr8BG6DIsFW1ivm9s=;
	b=hov/D7OXeOy3yD/d9UC8n2fMT/k9/7bFmD1ghBn8yJNDUltZ3A8LwMdWYLoc9kiwWeU97n
	t6okbD8+XQikg0fM5QVqA+TvNBx3JuMBhZgS546CrAHvUMMVzHOc+lq7aPv9ARh3WUytsA
	4tvt2L1Ievx9BC9HleXatohAYbyhtB8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-Whce7UpKPGSqU5IuIZNo8g-1; Tue,
 16 Jun 2026 08:51:36 -0400
X-MC-Unique: Whce7UpKPGSqU5IuIZNo8g-1
X-Mimecast-MFC-AGG-ID: Whce7UpKPGSqU5IuIZNo8g_1781614293
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E88D19560B3;
	Tue, 16 Jun 2026 12:51:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.50.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D8853008B3E;
	Tue, 16 Jun 2026 12:51:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b6b19c84-7734-42ea-b2ec-9ace1f36ad08@chenxiaosong.com>
References: <b6b19c84-7734-42ea-b2ec-9ace1f36ad08@chenxiaosong.com> <20260616100821.2062304-1-dhowells@redhat.com> <20260616100821.2062304-31-dhowells@redhat.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Matthew Wilcox <willy@infradead.org>,
    Christoph Hellwig <hch@infradead.org>,
    Paulo Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>,
    Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 30/30] CHANGES
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
Date: Tue, 16 Jun 2026 13:51:23 +0100
Message-ID: <2102921.1781614283@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: MPPhKn4Dd37nEm22URY7IBf57ajY-dFhp05skBeUKwM_1781614293
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2102920.1781614283.1@warthog.procyon.org.uk>

ChenXiaoSong <chenxiaosong@chenxiaosong.com> wrote:

> Is this patch missing the subject and commit message?

No.  I got distracted and forgot to finish folding its contents down into
earlier patches.

David


