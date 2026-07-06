Return-Path: <linux-erofs+bounces-3852-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E91C43602
	for <linux-erofs@archiver.kernel.org>; Mon,  6 Jul 2026 15:52:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gv84N3KtNz3bby;
	Tue, 07 Jul 2026 01:52:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783353124;
	cv=none; b=J+29LEfZGAPbLCR9H88TAXEfievn4yU7P61adUcO65A4t7xVbXHDL4nr5RjKIW1ZqIDnEg1o+n4WKggAX1yj2BLhkSsspMGFimrXRggNlDEMWj6tvGGgSn8pueJxueNYz4fSZYqSCa6kY8GuZgNf9N3NDqGwTmZZpjEbvGue9Y8Lll1fqWqyXOEdXvzsW0ZpaKUxenfaomEShohJZaugFGIMBkqiwtGb5BUHqyN6zOxWxby0XDWC+kWYhcp8+8zCgH6Z8jdqKy631P038rugKyH6aE6hzaWfZ79Z5X4R4Fer4FOn+tQZdc/eSrvM+MlpFXc87q2fh6wYA125sAnB8A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783353124; c=relaxed/relaxed;
	bh=URQzIFfS1/Haxdbz2Ns3BTAOv0VzNelQyqgK4lKywjc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:Date:
	 Message-ID:Content-Type; b=hcsnISV9pqHxvZkoQskKfMDDqgfNPq8yDllHpKwJI9tHfy3jQscLrfC4PO4xjwKyiIBo7Bc1dCDXKREaS7hk0ZBICwVz4FP47gbjRXegqNTfL3fSq1WM55fwVrg+4nicw3wFIw0MBzdtA8AVm/gqrTyPyRXcd1ynlvjX/RFrVGL/lSm9G6bTa0NhS1gLpDkMYzKLC2ruIlSBBa5ECE5hlXlIwP84wDvgu0xW0atB43yrUwudskWZu6g0iYntEzlW58GPINXo8lXdPobX2cdjedfvLSffI6FVv2RxvjLJrBDlefGhAfspl69zhYCKSsUrx3lJ6Z8ApS3g/LcBZ2P5HA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TdSKIvDz; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TdSKIvDz; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TdSKIvDz;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TdSKIvDz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gv84M3yp5z2yVZ
	for <linux-erofs@lists.ozlabs.org>; Tue, 07 Jul 2026 01:52:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783353119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=URQzIFfS1/Haxdbz2Ns3BTAOv0VzNelQyqgK4lKywjc=;
	b=TdSKIvDz1tJ+4tk+PiOpq+sw0977pnwzoTbB77KhdpQUGV4e9HchtR8TLLn2hJ729xHTg7
	+mav2wJfKwJpvte+KcBMWjH+3hwF8FpJcNvbdtVJibm8oX2a964CTCXNT25BHQkBloc5YO
	pG/O3GzjY4Ku3xOtMMxummGUSs941rg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783353119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=URQzIFfS1/Haxdbz2Ns3BTAOv0VzNelQyqgK4lKywjc=;
	b=TdSKIvDz1tJ+4tk+PiOpq+sw0977pnwzoTbB77KhdpQUGV4e9HchtR8TLLn2hJ729xHTg7
	+mav2wJfKwJpvte+KcBMWjH+3hwF8FpJcNvbdtVJibm8oX2a964CTCXNT25BHQkBloc5YO
	pG/O3GzjY4Ku3xOtMMxummGUSs941rg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-GUd2VfxQPRuPQ_RMGkZGbw-1; Mon,
 06 Jul 2026 11:51:55 -0400
X-MC-Unique: GUd2VfxQPRuPQ_RMGkZGbw-1
X-Mimecast-MFC-AGG-ID: GUd2VfxQPRuPQ_RMGkZGbw_1783353112
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CED291955DE7;
	Mon,  6 Jul 2026 15:51:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.159])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E3E741956053;
	Mon,  6 Jul 2026 15:51:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260706152737.1231312-1-dhowells@redhat.com>
References: <20260706152737.1231312-1-dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
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
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/21] netfs: Keep track of folios in a segmented bio_vec[] chain
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
Date: Mon, 06 Jul 2026 16:51:44 +0100
Message-ID: <1232537.1783353104@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: sSMiJ3joWoik5xjW5KWOUvA6IHXWdbKCMnVjrrpznv0_1783353112
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1232536.1783353104.1@warthog.procyon.org.uk>

Apologies...  The outgoing MX decided to go offline in the middle of that:

	error: `git send-email`: 4.7.1 Service unavailable - try again later

So I've re-sent it.

David


