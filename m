Return-Path: <linux-erofs+bounces-4156-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E5DC5AD55
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 14:48:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJd0n6Yd6z2yxN;
	Tue, 11 Aug 2026 00:48:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786373305;
	cv=none; b=IH/H03QEH4iglJB8tnSlyuJtX3B/71helwR2jd/l+VUtKBnUKVClnwRqNbZuyx+BiBriqa+NU3qn2htwI5qgEMYMNpVNxISJEmQbSDKnBhJG0hJqScUhi23S1NLfsZL1D2OL/YtiMNWXrA/bAXXZ8tu6iYJFm45kngFlVGCf3fQlL0Cqn4W6tz3kSdQSApciY/tX9+QM4w4YGr2Y7DXm5VIzmLWAjQi5TkKskDhhwMq6Y8aPo8OL31dzSRPsUuGTiOGNWnmteOt3yR39TGsPqhEdi7lZDDFYmeyMYVAEcfstFOXBvhEhd44rTfwGryheoNdyVKcsig7uC8aHKZRwCA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786373305; c=relaxed/relaxed;
	bh=qKqqlAm044G0H8upKuwa2R/tvw9kpivbRfvFHRDyOYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PGIxe6IjFRd8KfSGLpwucZDMWezt7bZ536BIY863dmleW+ysRdk2Ns9PGtiXm2cELQsTkiLRGrc7rWUU4imvKkqneSEyo5ytBVaCjg1yFFqQ3VfzqcEpfXHN2+h8DVYYwnpI9v+fX+S0Hzzd2mh/pNPyuioMG3oAFE4PDxKWq9jDc1fxY0pO+KdMo6ACTT9IgeDiXICWy20rqnX74W1qG2oUlfoykAVcHGRu8uSMoeV7jXcCIDlgUWjysGMzQEHZ1OSOim20t8ZPuLGZkEM2lcUMnPV0EzXFdU+WiZhInjDzYEmEKwm2KmgFHH+ELpJxVWI8aFbR+C8sH8hZWgJEfQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c2TafouA; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c2TafouA; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c2TafouA;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c2TafouA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJd0m6LL2z2ytv
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 00:48:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKqqlAm044G0H8upKuwa2R/tvw9kpivbRfvFHRDyOYM=;
	b=c2TafouAxZSNwvqc4NzK8tKmEf+xOzGeTLy5VxldLg+OSuFeqZmRirCOmRZemp4QJ8pT2R
	Mx1eBnSq8Wbbtn7Ttngqxs3Z7vQZ92GIB3vY3WL23hIFnh+MugG5x5vCzWyTUzMX3hyzgn
	0PaePboyvjeAVD2mx5INj2f4J7sb95M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKqqlAm044G0H8upKuwa2R/tvw9kpivbRfvFHRDyOYM=;
	b=c2TafouAxZSNwvqc4NzK8tKmEf+xOzGeTLy5VxldLg+OSuFeqZmRirCOmRZemp4QJ8pT2R
	Mx1eBnSq8Wbbtn7Ttngqxs3Z7vQZ92GIB3vY3WL23hIFnh+MugG5x5vCzWyTUzMX3hyzgn
	0PaePboyvjeAVD2mx5INj2f4J7sb95M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-CUK7ID0vPJ6RdgHTNAi6uA-1; Mon,
 10 Aug 2026 10:48:15 -0400
X-MC-Unique: CUK7ID0vPJ6RdgHTNAi6uA-1
X-Mimecast-MFC-AGG-ID: CUK7ID0vPJ6RdgHTNAi6uA_1786373292
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB14219560AD;
	Mon, 10 Aug 2026 14:48:10 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 395EE1800346;
	Mon, 10 Aug 2026 14:48:01 +0000 (UTC)
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
Subject: [PATCH v9 01/26] netfs: Fix read progress reporting
Date: Mon, 10 Aug 2026 15:47:18 +0100
Message-ID: <20260810144746.574036-2-dhowells@redhat.com>
In-Reply-To: <20260810144746.574036-1-dhowells@redhat.com>
References: <20260810144746.574036-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: OrRH4sEO0xCyjHwi1KrxzOvRANDVGD6qHIvS0gRHwXE_1786373292
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

For really big read RPC ops that span multiple folios, netfslib allows the
filesystem to give progress notifications to wake up the collector thread
to do a collection of folios that have now been fetched, even if the RPC is
still ongoing, thereby allowing the application to make progress.

This works by taking the current rreq->cleaned_to value (which indicates
which folios have been unlocked) and adding the stashed size of the next
folio to it.  cleaned_to, however, is subject to 64-bit tearing on a 32-bit
arch.

Fix this by stashing the next progress notification point as a size_t
(which won't tear) to be added to rreq->start (which won't change), with
the collector thread calculating that from cleaned_to plus the next folio
size.

Further, however, if the folios are small, the collector thread gets
constantly woken up - which has a negative performance impact on the
system.

Fix that too by setting a minimum trigger of 256KiB or the size of the
folio at the front of the queue, whichever is larger.

Also, make sure rreq->cleaned_to is initialised up front, along with
rreq->collected_to and stream->collected_to.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Link: https://sashiko.dev/#/patchset/20260804100224.2748935-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c |  4 ++++
 fs/netfs/objects.c       | 32 ++++++++++++++++++++------------
 fs/netfs/read_collect.c  | 27 +++++++++++++++------------
 fs/netfs/read_single.c   |  2 ++
 include/linux/netfs.h    |  2 +-
 5 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 7fdfa4f27e34..af14beeb6d11 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -106,6 +106,9 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
 				folio_batch_release(&put_batch);
 				return added;
 			}
+
+			if (!rreq->progress_at)
+				rreq->progress_at = folioq_folio_size(rreq->buffer.tail, 0);
 			rreq->submitted += added;
 		}
 		folio_batch_release(&put_batch);
@@ -387,6 +390,7 @@ static int netfs_create_singular_buffer(struct netfs_io_request *rreq, struct fo
 	if (added < 0)
 		return added;
 	rreq->submitted = rreq->start + added;
+	rreq->progress_at = added;
 	return 0;
 }
 
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 01461a74642d..e88293cdb834 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -41,24 +41,32 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 
 	memset(rreq, 0, kmem_cache_size(cache));
 	INIT_WORK(&rreq->cleanup_work, netfs_free_request);
-	rreq->gfp	= gfp;
-	rreq->start	= start;
-	rreq->len	= len;
-	rreq->origin	= origin;
-	rreq->netfs_ops	= ctx->ops;
-	rreq->mapping	= mapping;
-	rreq->inode	= inode;
-	rreq->i_size	= i_size_read(inode);
-	rreq->debug_id	= atomic_inc_return(&debug_ids);
-	rreq->wsize	= INT_MAX;
+	rreq->gfp		= gfp;
+	rreq->start		= start;
+	rreq->collected_to	= start;
+	rreq->cleaned_to	= start;
+	rreq->len		= len;
+	rreq->progress_at	= ULONG_MAX;
+	rreq->origin		= origin;
+	rreq->netfs_ops		= ctx->ops;
+	rreq->mapping		= mapping;
+	rreq->inode		= inode;
+	rreq->i_size		= i_size_read(inode);
+	rreq->debug_id		= atomic_inc_return(&debug_ids);
+	rreq->wsize		= INT_MAX;
 	rreq->io_streams[0].sreq_max_len = ULONG_MAX;
 	rreq->io_streams[0].sreq_max_segs = 0;
 	spin_lock_init(&rreq->lock);
-	INIT_LIST_HEAD(&rreq->io_streams[0].subrequests);
-	INIT_LIST_HEAD(&rreq->io_streams[1].subrequests);
 	init_waitqueue_head(&rreq->waitq);
 	refcount_set(&rreq->ref, 2);
 
+	for (int s = 0; s < NR_IO_STREAMS; s++) {
+		struct netfs_io_stream *stream = &rreq->io_streams[s];
+
+		INIT_LIST_HEAD(&stream->subrequests);
+		stream->collected_to = rreq->start;
+	}
+
 	if (origin == NETFS_READAHEAD ||
 	    origin == NETFS_READPAGE ||
 	    origin == NETFS_READ_GAPS ||
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 23660a590124..91b187db0bca 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -112,7 +112,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 	if (slot >= folioq_nr_slots(folioq)) {
 		folioq = rolling_buffer_delete_spent(&rreq->buffer);
 		if (!folioq) {
-			rreq->front_folio_order = 0;
+			WRITE_ONCE(rreq->progress_at, ULONG_MAX);
 			return;
 		}
 		slot = 0;
@@ -120,8 +120,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 
 	for (;;) {
 		struct folio *folio;
-		unsigned long long fpos, fend;
-		unsigned int order;
+		unsigned long long fpos = rreq->cleaned_to, fend;
 		size_t fsize;
 
 		if (*notes & COPY_TO_CACHE)
@@ -133,12 +132,12 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 			      rreq->debug_id, folio->index))
 			trace_netfs_folio(folio, netfs_folio_trace_not_locked);
 
-		order = folioq_folio_order(folioq, slot);
-		rreq->front_folio_order = order;
-		fsize = PAGE_SIZE << order;
+		fsize = folioq_folio_size(folioq, slot);
 		fpos = folio_pos(folio);
 		fend = fpos + fsize;
 
+		WRITE_ONCE(rreq->progress_at, fend - rreq->start);
+
 		trace_netfs_collect_folio(rreq, folio, fend, collected_to);
 
 		/* Unlock any folio we've transferred all of. */
@@ -146,7 +145,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 			break;
 
 		netfs_unlock_read_folio(rreq, folioq, slot);
-		WRITE_ONCE(rreq->cleaned_to, fpos + fsize);
+		WRITE_ONCE(rreq->cleaned_to, fend);
 		*notes |= MADE_PROGRESS;
 
 		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &rreq->flags);
@@ -232,7 +231,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 		 * subreqs.
 		 */
 		if (notes & BUFFERED) {
-			size_t fsize = PAGE_SIZE << rreq->front_folio_order;
+			uoff_t unlock_at = rreq->start + rreq->progress_at;
 
 			/* Clear the tail of a short read. */
 			if (!(notes & HIT_PENDING) &&
@@ -257,7 +256,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 				transferred = front->len;
 				trace_netfs_rreq(rreq, netfs_rreq_trace_set_abandon);
 			}
-			if (front->start + transferred >= rreq->cleaned_to + fsize ||
+			if (front->start + transferred >= unlock_at ||
 			    test_bit(NETFS_SREQ_HIT_EOF, &front->flags))
 				netfs_read_unlock_folios(rreq, &notes);
 		} else {
@@ -477,15 +476,19 @@ void netfs_read_collection_worker(struct work_struct *work)
 void netfs_read_subreq_progress(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
-	size_t fsize = PAGE_SIZE << rreq->front_folio_order;
+	struct netfs_io_stream *stream = &rreq->io_streams[subreq->stream_nr];
+	size_t progress_at = READ_ONCE(rreq->progress_at);
+	uoff_t update_at = rreq->start + progress_at;
+	uoff_t transferred_to = subreq->start + subreq->transferred;
 
 	trace_netfs_sreq(subreq, netfs_sreq_trace_progress);
 
 	/* If we are at the head of the queue, wake up the collector,
 	 * getting a ref to it if we were the ones to do so.
 	 */
-	if (subreq->start + subreq->transferred > rreq->cleaned_to + fsize &&
+	if (progress_at != ULONG_MAX &&
+	    transferred_to >= update_at &&
+	    transferred_to - update_at >= 256 * 1024 &&
 	    (rreq->origin == NETFS_READAHEAD ||
 	     rreq->origin == NETFS_READPAGE ||
 	     rreq->origin == NETFS_READ_FOR_WRITE) &&
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index 8833550d2eb6..de67ac41548d 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -170,6 +170,8 @@ ssize_t netfs_read_single(struct inode *inode, struct file *file, struct iov_ite
 	if (IS_ERR(rreq))
 		return PTR_ERR(rreq);
 
+	rreq->progress_at = rreq->len;
+
 	ret = netfs_single_begin_cache_read(rreq, ictx);
 	if (ret == -ENOMEM || ret == -EINTR || ret == -ERESTARTSYS)
 		goto cleanup_free;
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index d0b62d53eea9..cc8d6500d059 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -247,6 +247,7 @@ struct netfs_io_request {
 	unsigned long long	submitted;	/* Amount submitted for I/O so far */
 	unsigned long long	len;		/* Length of the request */
 	size_t			transferred;	/* Amount to be indicated as transferred */
+	size_t			progress_at;	/* Report read progress when hit this much read */
 	long			error;		/* 0 or error that occurred */
 	unsigned long long	i_size;		/* Size of the file */
 	unsigned long long	start;		/* Start position */
@@ -263,7 +264,6 @@ struct netfs_io_request {
 	atomic_t		subreq_counter;	/* Next subreq->debug_index */
 	unsigned int		nr_group_rel;	/* Number of refs to release on ->group */
 	spinlock_t		lock;		/* Lock for queuing subreqs */
-	unsigned char		front_folio_order; /* Order (size) of front folio */
 	enum netfs_io_origin	origin;		/* Origin of the request */
 	bool			direct_bv_unpin; /* T if direct_bv[] must be unpinned */
 	refcount_t		ref;


