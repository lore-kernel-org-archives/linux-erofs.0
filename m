Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C15DBC46467
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Jan 2023 16:25:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NsY1n2WBGz3cFr
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Jan 2023 03:25:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KQKdAC03;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KQKdAC03;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KQKdAC03;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KQKdAC03;
	dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NsY1h45cMz3c6s
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Jan 2023 03:25:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673454308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxBHdaiEAq2LsScflLkdFvYTtC4L7dZmM1H1mv+PG5k=;
	b=KQKdAC03C4OMo/w0rmu0uLum6vA/lNhYf4+TD/0a6Fjk37fP7WjmQ2iGWsg5lllv7aCeEy
	pFouo3QTyuczijcJTjsIiwafIkR4XjZ8SneY0/K9ImG9bZDNFF8SgRV4SQfE277xpqUKPV
	7iAvN6/jaMfII9bCFNEqmRzWAHdfH+s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673454308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxBHdaiEAq2LsScflLkdFvYTtC4L7dZmM1H1mv+PG5k=;
	b=KQKdAC03C4OMo/w0rmu0uLum6vA/lNhYf4+TD/0a6Fjk37fP7WjmQ2iGWsg5lllv7aCeEy
	pFouo3QTyuczijcJTjsIiwafIkR4XjZ8SneY0/K9ImG9bZDNFF8SgRV4SQfE277xpqUKPV
	7iAvN6/jaMfII9bCFNEqmRzWAHdfH+s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-86uM21hhPZONYQ_5UmZHIw-1; Wed, 11 Jan 2023 11:25:03 -0500
X-MC-Unique: 86uM21hhPZONYQ_5UmZHIw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E8373C0F22C;
	Wed, 11 Jan 2023 16:25:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 626DE40C1060;
	Wed, 11 Jan 2023 16:25:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2431994.1673453386@warthog.procyon.org.uk>
References: <2431994.1673453386@warthog.procyon.org.uk> <20221226103309.953112-3-houtao@huaweicloud.com> <20221226103309.953112-1-houtao@huaweicloud.com>
Subject: Re: [PATCH v2 2/2] fscache: Add the missing smp_mb__after_atomic() before wake_up_bit()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2432455.1673454299.1@warthog.procyon.org.uk>
Date: Wed, 11 Jan 2023 16:24:59 +0000
Message-ID: <2432456.1673454299@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Hou Tao <houtao@huaweicloud.com>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-cachefs@redhat.com, houtao1@huawei.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

David Howells <dhowells@redhat.com> wrote:

> What two values are you ordering?
> 
> If we're using this to create a critical section, then yes, we would need a
> barrier to order the changes inside the critical section before changing the
> memory location that forms the lock - but this is not a critical section.

Actually, that said, the ordering is probably between the bit being cleared
and the task state.

David

