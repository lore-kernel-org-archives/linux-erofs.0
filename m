Return-Path: <linux-erofs+bounces-3849-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0933DC43602
	for <linux-erofs@archiver.kernel.org>; Mon,  6 Jul 2026 15:36:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gv7kx50m7z3bps;
	Tue, 07 Jul 2026 01:36:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783352217;
	cv=none; b=BfIJuNmYaBfUxJ/lrqthwmB8TawYXH6+inZJnqY81Q4VxvR1WVtekXYkJExO7js6H3Nwv37k15RAblXsc/mgVz7usmiWmGm+OsmLefhWSxAQ/qT2PX9UZIK5IoPpHMXzUJyvJiQWFs2ZDcD48eqKYyX4o4c/4tkpwpIJOIWJM6fHxC3NgXGH7ASZrQFTw+ne0si6RIvmaMOXY/SWkK00gEokDRcXDmELc/DkJLnnfh16EO93gBHyZPmcXewIyigMrI+QsZlXSqbHCh6ZIK7UYLtEBrwpESTdALaQzwqdMx0uEjRyEyQ9nGpIldeLb7nSL0hK5R9F6CGJqXkWTD9G1w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783352217; c=relaxed/relaxed;
	bh=HfX4hKOxHGk+bf7dAxE3qPG38R5aFPeh/NdzY9CtdfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Z1BAOELQLPIB21pZqlLvm2PJP2rhbTGvKoeyI/DE956sow5zQiyegahM2pQBhywnxaA3S9vZQl9mrPHReOj+mQj+aGlKpqzfyeRGd2wHQB/BV2zrMiELCuz00YdijeE0CWpezGqnCh20HlBXt2HEjW7XUSQxbMQx3ZUqpoL/f5v3J4U8hQjlP029UGSbNjHgXbDjwZ13WVRknbzwogxqeC6yIxktD/MpWZNJvaQh7G4CCF0NWtFkEjkKpi0o6ANkDKPzO2DO9E6uF4bVUAtjORblvq4lntERetN9FmKI7TE/cbnAnt0vacj7qBoIZ3WVYXKCP/F3kh1HPv1WYza89Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AdrV4CRT; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IC6QuOv2; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AdrV4CRT;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IC6QuOv2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gv7kw6NQBz2yVZ
	for <linux-erofs@lists.ozlabs.org>; Tue, 07 Jul 2026 01:36:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HfX4hKOxHGk+bf7dAxE3qPG38R5aFPeh/NdzY9CtdfI=;
	b=AdrV4CRT2CPSwh+0pa2MJIylsUuCUlTuJiByV/bUnEEambIQpxa4hW3+o4w6UnuNS/s2uK
	0Zmdca54TAPDpXWQ/V3IaLR1NcBIPfrP7NGdE88ZJTI+zepApnmy4QHuS6EzJxH0J1Q5nb
	uIXhNL7v+aOiaftiG+ggbzyxFZbRqeY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HfX4hKOxHGk+bf7dAxE3qPG38R5aFPeh/NdzY9CtdfI=;
	b=IC6QuOv2eq+VpAcyVTqT2JieBjHpV2da4Ua5dPscfUdJHsXNkfQF/8Q3PMTJnDEN0bakBk
	/MRo9lgTfQUWiYaBUiZR6Ox6ylEPuVkYTV8RV7fYi6jI9S0gmfcCbiE7GH0SF0ehw9qFw/
	CfifeHykj5UsyWVaj0ysD5S0RJd6zhQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-ticSKwYuNrudCBLEZziNpw-1; Mon,
 06 Jul 2026 11:36:50 -0400
X-MC-Unique: ticSKwYuNrudCBLEZziNpw-1
X-Mimecast-MFC-AGG-ID: ticSKwYuNrudCBLEZziNpw_1783352207
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66340180122F;
	Mon,  6 Jul 2026 15:36:47 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 793811956096;
	Mon,  6 Jul 2026 15:36:41 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 19/21] netfs: Check for too much data being read
Date: Mon,  6 Jul 2026 16:34:05 +0100
Message-ID: <20260706153408.1231650-20-dhowells@redhat.com>
In-Reply-To: <20260706153408.1231650-1-dhowells@redhat.com>
References: <20260706153408.1231650-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: n4yEqZ10jtNM06O8Il3nHHO1JQdG9CLJsVKAUEHTeRM_1783352207
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Put in a check in read subreq termination to detect more data being read
for a subrequest than was requested.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_collect.c      | 8 ++++++++
 include/trace/events/netfs.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 802d1c40cce5..9efcc0e63a96 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -543,6 +543,14 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 		break;
 	}
 
+	if (subreq->transferred > subreq->len) {
+		subreq->transferred = 0;
+		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+		trace_netfs_sreq(subreq, netfs_sreq_trace_too_much);
+		subreq->error = -EIO;
+	}
+
 	/* Deal with retry requests, short reads and errors.  If we retry
 	 * but don't make progress, we abandon the attempt.
 	 */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 59f330003d02..cc29582f6245 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -134,6 +134,7 @@
 	EM(netfs_sreq_trace_submit,		"SUBMT")	\
 	EM(netfs_sreq_trace_superfluous,	"SPRFL")	\
 	EM(netfs_sreq_trace_terminated,		"TERM ")	\
+	EM(netfs_sreq_trace_too_much,		"!TOOM")	\
 	EM(netfs_sreq_trace_wait_for,		"_WAIT")	\
 	EM(netfs_sreq_trace_write,		"WRITE")	\
 	EM(netfs_sreq_trace_write_skip,		"SKIP ")	\


