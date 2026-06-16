Return-Path: <linux-erofs+bounces-3624-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB58CCD98CF
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 10:12:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfjTq1r4Vz3c2Z;
	Tue, 16 Jun 2026 20:12:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781604751;
	cv=none; b=JnXHNzxoS7pXlrmm3lf7Vge2QFy1YY8tn9fgcMKvTMqNImGnLTyjHX2RhuSqi49dDGfT7j+lRlwCkpsXYa601fkVf8zpjvbFSCFvs85kiFsV3ETPhMZmDP48149hE3rSITObh41zvhls8db+6ODGO3w4o9IiC1C9/C+CFa/FscbE597Hmf46daoJxkdq3mKxZ7JFgckHOGACtaN2mmihpen9nHxVmtmet+1Zj/Ez+h++jr5QdtOpruZAJVA+TP6z0i7CR3nua4gxDv3aUgKSTLMgFvZXKeyKRPFAcOniOoGflc/6DQ3F9hNcN+pQfx5PhuXoqnfDeiTCtjrCzFw5yg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781604751; c=relaxed/relaxed;
	bh=f97ABxHjRNMpwCISt1swTvlPaBA4vicFtsj/v71c+y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=d+fVyK5WN9qjvVvZUw4F7sxF6a0XYQQHK8UHlti/7ZboUeYxZxF2gjR79Zh9sSD4LYVksSorksXFwRlHkxXvSpcxUUeuVb+8LkG1+0e6v7Xz+ajCbOnF4f4N6sJkugi9FLLgesWAHorGqdp+oN1wL6LkbJaF5r37qDmUESdSsyOMP09xJonFUtiL547vjWLnmPYY1E1tcgy/iIQj/ty24nVt3egDowQJkHbZs6lt3cYnoKycfT4oX2tk1Nw0LzNGhDzyTdPNcaBbbQVZRvBPPKHgQLbJMOgvmlQtpNcd9Y6VbQxY/N9Axl81zhLoAw+kxcWX1jKvELVaqHG/y2lWyQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OSc920bD; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OSc920bD; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OSc920bD;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OSc920bD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfjTp1WVLz3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 20:12:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f97ABxHjRNMpwCISt1swTvlPaBA4vicFtsj/v71c+y4=;
	b=OSc920bDM1ImEPrQ2VC+g6b9WKyYd+MPML/k8evlSd6V+LDL1qq2aRcm4NH+X0PU1BLNvK
	+I+NGO9xqYRdPgIv7vUugtVITDvLZWFOPiP+IUK3KYsY3qqyX6HrPuTxZBDojVLthI6Vm9
	aQQKuHFUNjJKtIANmC7Xx1kZN799rpE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f97ABxHjRNMpwCISt1swTvlPaBA4vicFtsj/v71c+y4=;
	b=OSc920bDM1ImEPrQ2VC+g6b9WKyYd+MPML/k8evlSd6V+LDL1qq2aRcm4NH+X0PU1BLNvK
	+I+NGO9xqYRdPgIv7vUugtVITDvLZWFOPiP+IUK3KYsY3qqyX6HrPuTxZBDojVLthI6Vm9
	aQQKuHFUNjJKtIANmC7Xx1kZN799rpE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-E0TD0ZO-MaSWI_Dt2BS9YQ-1; Tue,
 16 Jun 2026 06:12:23 -0400
X-MC-Unique: E0TD0ZO-MaSWI_Dt2BS9YQ-1
X-Mimecast-MFC-AGG-ID: E0TD0ZO-MaSWI_Dt2BS9YQ_1781604741
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE9AF1955D99;
	Tue, 16 Jun 2026 10:12:20 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06FBE1800348;
	Tue, 16 Jun 2026 10:12:14 +0000 (UTC)
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
Subject: [PATCH v4 28/30] netfs: Limit the minimum trigger for progress reporting
Date: Tue, 16 Jun 2026 11:08:17 +0100
Message-ID: <20260616100821.2062304-29-dhowells@redhat.com>
In-Reply-To: <20260616100821.2062304-1-dhowells@redhat.com>
References: <20260616100821.2062304-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: awyvVtnBym6rMbn2LCoxKcr2xQZoqejOdCZ2KpDArmI_1781604741
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

For really big read RPC ops that span multiple folios, netfslib allows the
filesystem to give progress notifications to wake up the collector thread
to do a collection of folios that have now been fetched, even if the RPC is
still ongoing, thereby allowing the application to make progress.

The trigger for this is that at least one folio has been downloaded since
the clean point.  If, however, the folios are small, this means the
collector thread is constantly being woken up - which has a negative
performance impact on the system.

Set a minimum trigger of 256KiB or the size of the folio at the front of
the queue, whichever is larger.

Also, fix the base to be the stream collection point, not the point at
which the collector has cleaned up to (which is currently 0 until something
has been collected).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_collect.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 9efcc0e63a96..fdb6aebc0a7b 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -492,15 +492,15 @@ void netfs_read_collection_worker(struct work_struct *work)
 void netfs_read_subreq_progress(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
-	size_t fsize = PAGE_SIZE << rreq->front_folio_order;
+	struct netfs_io_stream *stream = &rreq->io_streams[subreq->stream_nr];
+	size_t fsize = umax(PAGE_SIZE << rreq->front_folio_order, 256 * 1024);
 
 	trace_netfs_sreq(subreq, netfs_sreq_trace_progress);
 
 	/* If we are at the head of the queue, wake up the collector,
 	 * getting a ref to it if we were the ones to do so.
 	 */
-	if (subreq->start + subreq->transferred > rreq->cleaned_to + fsize &&
+	if (subreq->start + subreq->transferred >= stream->collected_to + fsize &&
 	    (rreq->origin == NETFS_READAHEAD ||
 	     rreq->origin == NETFS_READPAGE ||
 	     rreq->origin == NETFS_READ_FOR_WRITE) &&


