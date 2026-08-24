Return-Path: <linux-erofs+bounces-4305-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C39C5DF9B
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:43:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDD26RFyz2xpv;
	Tue, 25 Aug 2026 00:42:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582578;
	cv=none; b=EkVEYUas6zXz9SUSinCAog+bNwdADcZ1bfe8OM3SSMexh4Cc25jiBBY1AzOjmlEDRrmfdWwd0/pLBc7W0lFPlpHOfPX2QVarCirjvuYOIZVGvkMg75uYX2pXA81mVIcZXRZC8yN/qN9wAHOk5UUhAET37ZGyjU/EkQw61X+TpNSugzzO0Mf2OvCDQ/pOi6fvC4HoilMQiW5KGC9PU+WMTpHSxjFgwEZev8GZ0oGK005415jZNyzzYtDJ+FQq0io2Th3M4PYi/5Hk88TANpds7xK6r0AyLldOYZz8QjsGYUQsKo9v/5qzGq384kOTLy17e8SL1/6UX/jNB8ts2lR7UA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582578; c=relaxed/relaxed;
	bh=gRNZmNiLLHfpFB28y7PTJWtB/r0o/0KMXHwmtUXX9FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=D1+DlU5hFLyDsVst7Ps3EeGkRBIjVW26RvKmTa3f108pI2V7cdRXK/W5dIIgshHDgqg84sTXLOBaGwyQxLHSRoorpR8GvuSbz8BvSj8b/Ae4rS9SPIx1RcuLylimVmECoqmv8NLsW6O/PI4UX5ll04P+NQPapyxMHRI4nG+kn5jmTb1UoGZkawomDPA/SRGTtCttTYJyW9osNDCisOzn1F5YGDDXCoiUNGtobaP6SiDcU9VRjIAXwIA4Fym+RJ5QE/pUD1mHDW7Qimz7mnE7i/pB+5XsgIHDRYRHswumRf3WADudZo4Z2X2aX0MC5byE/7r+TsV+1Ak4iPnukrc4bg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LwHaOJ4t; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LwHaOJ4t; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LwHaOJ4t;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LwHaOJ4t;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDD12smzz2xmh
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:42:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRNZmNiLLHfpFB28y7PTJWtB/r0o/0KMXHwmtUXX9FU=;
	b=LwHaOJ4toQuckrgwVCMHExjOBdWeqE32pZqFCDBWkgZApWHHu5G0ggOOC9ReU53QWd6fPj
	h7tD0sgM/5ordJyuPCx+uwBcfyK33P8CRnXEiYHcFGWUPbKl9iDUIFjpmHOeJop8pyG+Yq
	tcelR7SF26N1uOwK0VpoTwmMKPnEBA8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRNZmNiLLHfpFB28y7PTJWtB/r0o/0KMXHwmtUXX9FU=;
	b=LwHaOJ4toQuckrgwVCMHExjOBdWeqE32pZqFCDBWkgZApWHHu5G0ggOOC9ReU53QWd6fPj
	h7tD0sgM/5ordJyuPCx+uwBcfyK33P8CRnXEiYHcFGWUPbKl9iDUIFjpmHOeJop8pyG+Yq
	tcelR7SF26N1uOwK0VpoTwmMKPnEBA8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-aImLARBcPzGnjMDOa9oV5Q-1; Mon,
 24 Aug 2026 10:42:49 -0400
X-MC-Unique: aImLARBcPzGnjMDOa9oV5Q-1
X-Mimecast-MFC-AGG-ID: aImLARBcPzGnjMDOa9oV5Q_1787582566
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B9D5195FCFC;
	Mon, 24 Aug 2026 14:42:46 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DEA8C1955DAA;
	Mon, 24 Aug 2026 14:42:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v10 07/35] netfs: Bulk load the readahead-provided folios up front
Date: Mon, 24 Aug 2026 15:41:00 +0100
Message-ID: <20260824144130.759997-8-dhowells@redhat.com>
In-Reply-To: <20260824144130.759997-1-dhowells@redhat.com>
References: <20260824144130.759997-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 6Rbt2V34u64p5kguP9l-AjmkZetW5mlQEFyn8BBciek_1787582566
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Load all the folios by the VM for readahead up front into the folio queue.
With the number of folios provided by the VM, the folio queue can be fully
allocated first and then the loading happen in one go inside the RCU read
lock.  The folio refs acquired from readahead are dropped in bulk once the
first subrequest is dispatched as it's quite a slow operation.  The
collector waits for NETFS_RREQ_NEED_PUT_RA_REFS to be cleared so that it
doesn't unlock folios before the xarray has been scanned for them.

This simplifies the buffer handling later and isn't noticeably slower as
the xarray doesn't need to be modified and the folios are all already
pre-locked.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c       | 103 +++++++++++++++++++--------------
 fs/netfs/internal.h            |   1 +
 fs/netfs/misc.c                |  19 ++++++
 fs/netfs/read_collect.c        |   7 +++
 fs/netfs/read_retry.c          |   7 +++
 fs/netfs/rolling_buffer.c      |  75 ++++++++++++++++++++++++
 include/linux/netfs.h          |   1 +
 include/linux/rolling_buffer.h |   3 +
 include/trace/events/netfs.h   |   3 +
 9 files changed, 177 insertions(+), 42 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 7e58aec6cdff..77f7dfc816a8 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -54,6 +54,42 @@ static void netfs_rreq_expand(struct netfs_io_request *rreq,
 	}
 }
 
+/*
+ * Drop the folio refs acquired from the readahead API.
+ */
+static void netfs_bulk_drop_ra_refs(struct netfs_io_request *rreq)
+{
+	struct folio_batch fbatch;
+	struct folio *folio;
+	pgoff_t nr_pages = DIV_ROUND_UP(rreq->len, PAGE_SIZE);
+	pgoff_t first = rreq->start / PAGE_SIZE;
+	XA_STATE(xas, &rreq->mapping->i_pages, first);
+
+	folio_batch_init(&fbatch);
+
+	rcu_read_lock();
+
+	xas_for_each(&xas, folio,  first + nr_pages - 1) {
+		if (xas_retry(&xas, folio))
+			continue;
+
+		if (!folio_batch_add(&fbatch, folio))
+			folio_batch_release(&fbatch);
+	}
+
+	rcu_read_unlock();
+	folio_batch_release(&fbatch);
+	trace_netfs_rreq(rreq, netfs_rreq_trace_ra_put_ref);
+	clear_bit_unlock(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags);
+	wake_up(&rreq->waitq);
+}
+
+static void netfs_maybe_bulk_drop_ra_refs(struct netfs_io_request *rreq)
+{
+	if (test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+		netfs_bulk_drop_ra_refs(rreq);
+}
+
 /*
  * Begin an operation, and fetch the stored zero point value from the cookie if
  * available.
@@ -74,12 +110,8 @@ static int netfs_begin_cache_read(struct netfs_io_request *rreq, struct netfs_in
  *
  * Returns the limited size if successful and -ENOMEM if insufficient memory
  * available.
- *
- * [!] NOTE: This must be run in the same thread as ->issue_read() was called
- * in as we access the readahead_control struct.
  */
-static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
-					   struct readahead_control *ractl)
+static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
 	size_t rsize = subreq->len;
@@ -87,33 +119,6 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
 	if (subreq->source == NETFS_DOWNLOAD_FROM_SERVER)
 		rsize = umin(rsize, rreq->io_streams[0].sreq_max_len);
 
-	if (ractl) {
-		/* If we don't have sufficient folios in the rolling buffer,
-		 * extract a folioq's worth from the readahead region at a time
-		 * into the buffer.  Note that this acquires a ref on each page
-		 * that we will need to release later - but we don't want to do
-		 * that until after we've started the I/O.
-		 */
-		struct folio_batch put_batch;
-
-		folio_batch_init(&put_batch);
-		while (rreq->submitted < subreq->start + rsize) {
-			ssize_t added;
-
-			added = rolling_buffer_load_from_ra(&rreq->buffer, ractl,
-							    &put_batch);
-			if (added < 0) {
-				folio_batch_release(&put_batch);
-				return added;
-			}
-
-			if (!rreq->progress_at)
-				netfs_read_set_unlock_at(rreq);
-			rreq->submitted += added;
-		}
-		folio_batch_release(&put_batch);
-	}
-
 	subreq->len = rsize;
 	if (unlikely(rreq->io_streams[0].sreq_max_segs)) {
 		size_t limit = netfs_limit_iter(&rreq->buffer.iter, 0, rsize,
@@ -211,8 +216,7 @@ static void netfs_issue_read(struct netfs_io_request *rreq,
  * slicing up the region to be read according to available cache blocks and
  * network rsize.
  */
-static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
-				    struct readahead_control *ractl)
+static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 {
 	ssize_t size = rreq->len;
 	uoff_t start = rreq->start;
@@ -291,7 +295,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		break;
 
 	issue:
-		slice = netfs_prepare_read_iterator(subreq, ractl);
+		slice = netfs_prepare_read_iterator(subreq);
 		if (slice < 0) {
 			ret = slice;
 			netfs_cancel_read(subreq, ret);
@@ -305,6 +309,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		}
 
 		netfs_issue_read(rreq, subreq);
+		netfs_maybe_bulk_drop_ra_refs(rreq);
 
 		if (test_bit(NETFS_RREQ_PAUSE, &rreq->flags))
 			netfs_wait_for_paused_read(rreq);
@@ -342,6 +347,7 @@ void netfs_readahead(struct readahead_control *ractl)
 {
 	struct netfs_io_request *rreq;
 	struct netfs_inode *ictx = netfs_inode(ractl->mapping->host);
+	ssize_t added;
 	uoff_t start = readahead_pos(ractl);
 	size_t size = readahead_length(ractl);
 	int ret;
@@ -363,11 +369,24 @@ void netfs_readahead(struct readahead_control *ractl)
 
 	netfs_rreq_expand(rreq, ractl);
 
-	rreq->submitted = rreq->start;
-	if (rolling_buffer_init(&rreq->buffer, rreq->debug_id, ITER_DEST, rreq->gfp) < 0)
+	/* Load the folios to be read into a bvecq chain.  Note that this
+	 * acquires a ref on each folio that we will need to release later -
+	 * but we don't want to do that until after we've started the I/O.
+	 */
+	added = rolling_buffer_bulk_load_from_ra(&rreq->buffer, ractl,
+						 rreq->debug_id, rreq->gfp);
+	if (added < 0) {
+		ret = added;
 		goto cleanup_free;
-	netfs_read_to_pagecache(rreq, ractl);
+	}
+	__set_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags);
+
+	rreq->submitted = rreq->start + added;
+	rreq->cleaned_to = rreq->start;
+	netfs_read_set_unlock_at(rreq);
 
+	netfs_read_to_pagecache(rreq);
+	netfs_maybe_bulk_drop_ra_refs(rreq);
 	return netfs_put_request(rreq, netfs_rreq_trace_put_return);
 
 cleanup_free:
@@ -461,7 +480,7 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 	iov_iter_bvec(&rreq->buffer.iter, ITER_DEST, bvec, i, rreq->len);
 	rreq->submitted = rreq->start + flen;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
@@ -536,7 +555,7 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	if (ret < 0)
 		goto discard;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
@@ -693,7 +712,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	if (ret < 0)
@@ -758,7 +777,7 @@ int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 	if (ret < 0)
 		goto error_put;
 
-	netfs_read_to_pagecache(rreq, NULL);
+	netfs_read_to_pagecache(rreq);
 	ret = netfs_wait_for_read(rreq);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 4ea3ef8b3bb0..5680e37fc70d 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -79,6 +79,7 @@ ssize_t netfs_wait_for_read(struct netfs_io_request *rreq);
 ssize_t netfs_wait_for_write(struct netfs_io_request *rreq);
 void netfs_wait_for_paused_read(struct netfs_io_request *rreq);
 void netfs_wait_for_paused_write(struct netfs_io_request *rreq);
+void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq);
 
 /*
  * objects.c
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index f58a0d45e614..eafc4edae6a0 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -563,3 +563,22 @@ void netfs_wait_for_paused_write(struct netfs_io_request *rreq)
 {
 	return netfs_wait_for_pause(rreq, netfs_write_collection);
 }
+
+/*
+ * Wait for the readahead-acquired refs to be put.
+ */
+void netfs_wait_for_put_ra_refs(struct netfs_io_request *rreq)
+{
+	DEFINE_WAIT(myself);
+
+	for (;;) {
+		trace_netfs_rreq(rreq, netfs_rreq_trace_wait_put_ra_refs);
+		prepare_to_wait(&rreq->waitq, &myself, TASK_UNINTERRUPTIBLE);
+		if (!test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+			break;
+		schedule();
+	}
+
+	trace_netfs_rreq(rreq, netfs_rreq_trace_waited_put_ra_refs);
+	finish_wait(&rreq->waitq, &myself);
+}
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index a29b694ce1e8..72afc17ecbb3 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -147,6 +147,13 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		slot = 0;
 	}
 
+	/* We have to wait for readahead refs to have been released before we
+	 * can unlock any folios as the ref-dropper walks i_pages and the only
+	 * thing preventing these folios from being removed is the folio lock.
+	 */
+	if (test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+		netfs_wait_for_put_ra_refs(rreq);
+
 	for (;;) {
 		struct folio *folio;
 		uoff_t fpos = rreq->cleaned_to, fend;
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index f5c5ed12dd02..61dbd644d6bb 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -292,6 +292,13 @@ void netfs_unlock_abandoned_read_pages(struct netfs_io_request *rreq)
 {
 	struct folio_queue *p;
 
+	/* We have to wait for readahead refs to have been released before we
+	 * can unlock any folios as the ref-dropper walks i_pages and the only
+	 * thing preventing these folios from being removed is the folio lock.
+	 */
+	if (test_bit(NETFS_RREQ_NEED_PUT_RA_REFS, &rreq->flags))
+		netfs_wait_for_put_ra_refs(rreq);
+
 	for (p = rreq->buffer.tail; p; p = p->next) {
 		for (int slot = 0; slot < folioq_count(p); slot++) {
 			struct folio *folio = folioq_folio(p, slot);
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index 8c0026836f9c..ff6c7ee23f4d 100644
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -153,6 +153,81 @@ ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
 	return size;
 }
 
+/*
+ * Decant the entire list of folios to read into a rolling buffer.
+ */
+ssize_t rolling_buffer_bulk_load_from_ra(struct rolling_buffer *roll,
+					 struct readahead_control *ractl,
+					 unsigned int rreq_id, gfp_t gfp)
+{
+	XA_STATE(xas, &ractl->mapping->i_pages, ractl->_index);
+	struct folio_queue *fq;
+	struct folio *folio;
+	ssize_t loaded = 0;
+	int nr, slot = 0, npages = 0;
+
+	/* First allocate all the folioqs we're going to need to avoid having
+	 * to deal with ENOMEM later.
+	 */
+	nr = ractl->_nr_folios;
+	do {
+		fq = netfs_folioq_alloc(rreq_id, gfp,
+					netfs_trace_folioq_make_space);
+		if (!fq) {
+			rolling_buffer_clear(roll);
+			return -ENOMEM;
+		}
+		fq->prev = roll->head;
+		if (!roll->tail)
+			roll->tail = fq;
+		else
+			roll->head->next = fq;
+		roll->head = fq;
+
+		nr -= folioq_nr_slots(fq);
+	} while (nr > 0);
+
+	rcu_read_lock();
+
+	fq = roll->tail;
+	xas_for_each(&xas, folio, ractl->_index + ractl->_nr_pages - 1) {
+		unsigned int order;
+
+		if (xas_retry(&xas, folio))
+			continue;
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+		order = folio_order(folio);
+		fq->orders[slot] = order;
+		fq->vec.folios[slot] = folio;
+		loaded += PAGE_SIZE << order;
+		npages += 1 << order;
+		trace_netfs_folio(folio, netfs_folio_trace_read);
+
+		slot++;
+		if (slot >= folioq_nr_slots(fq)) {
+			fq->vec.nr = slot;
+			fq = fq->next;
+			if (!fq) {
+				WARN_ON_ONCE(npages < readahead_count(ractl));
+				break;
+			}
+			slot = 0;
+		}
+	}
+
+	rcu_read_unlock();
+
+	if (fq)
+		fq->vec.nr = slot;
+
+	WRITE_ONCE(roll->iter.count, loaded);
+	iov_iter_folio_queue(&roll->iter, ITER_DEST, roll->tail, 0, 0, loaded);
+	ractl->_index    += npages;
+	ractl->_nr_pages -= npages;
+	return loaded;
+}
+
 /*
  * Append a folio to the rolling buffer.
  */
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 8c78c91fefd9..16cc0858c613 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -278,6 +278,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_FOLIO_COPY_TO_CACHE	10	/* Copy current folio to cache from read */
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
+#define NETFS_RREQ_NEED_PUT_RA_REFS	17	/* Need to put the folio refs RA gave us */
 #define NETFS_RREQ_USE_PGPRIV2		31	/* [DEPRECATED] Use PG_private_2 to mark
 						 * write to cache on read */
 	const struct netfs_request_ops *netfs_ops;
diff --git a/include/linux/rolling_buffer.h b/include/linux/rolling_buffer.h
index 9e5dad29669c..761735bdf3ab 100644
--- a/include/linux/rolling_buffer.h
+++ b/include/linux/rolling_buffer.h
@@ -48,6 +48,9 @@ int rolling_buffer_make_space(struct rolling_buffer *roll, gfp_t gfp);
 ssize_t rolling_buffer_load_from_ra(struct rolling_buffer *roll,
 				    struct readahead_control *ractl,
 				    struct folio_batch *put_batch);
+ssize_t rolling_buffer_bulk_load_from_ra(struct rolling_buffer *roll,
+					 struct readahead_control *ractl,
+					 unsigned int rreq_id, gfp_t gfp);
 ssize_t rolling_buffer_append(struct rolling_buffer *roll, struct folio *folio,
 			      unsigned int flags, gfp_t gfp);
 struct folio_queue *rolling_buffer_delete_spent(struct rolling_buffer *roll);
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 4f5a447d92b1..0202ba4ccbd0 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -59,6 +59,7 @@
 	EM(netfs_rreq_trace_free,		"FREE   ")	\
 	EM(netfs_rreq_trace_intr,		"INTR   ")	\
 	EM(netfs_rreq_trace_ki_complete,	"KI-CMPL")	\
+	EM(netfs_rreq_trace_ra_put_ref,		"RA-PUT ")	\
 	EM(netfs_rreq_trace_recollect,		"RECLLCT")	\
 	EM(netfs_rreq_trace_redirty,		"REDIRTY")	\
 	EM(netfs_rreq_trace_resubmit,		"RESUBMT")	\
@@ -70,9 +71,11 @@
 	EM(netfs_rreq_trace_unpause,		"UNPAUSE")	\
 	EM(netfs_rreq_trace_wait_ip,		"WAIT-IP")	\
 	EM(netfs_rreq_trace_wait_pause,		"--PAUSED--")	\
+	EM(netfs_rreq_trace_wait_put_ra_refs,	"WAIT-P-RA")	\
 	EM(netfs_rreq_trace_wait_quiesce,	"WAIT-QUIESCE")	\
 	EM(netfs_rreq_trace_waited_ip,		"DONE-IP")	\
 	EM(netfs_rreq_trace_waited_pause,	"--UNPAUSED--")	\
+	EM(netfs_rreq_trace_waited_put_ra_refs,	"DONE-P-RA")	\
 	EM(netfs_rreq_trace_waited_quiesce,	"DONE-QUIESCE")	\
 	EM(netfs_rreq_trace_wake_ip,		"WAKE-IP")	\
 	EM(netfs_rreq_trace_wake_queue,		"WAKE-Q ")	\


