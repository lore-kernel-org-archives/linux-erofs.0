Return-Path: <linux-erofs+bounces-4178-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7B7C5AE49
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 14:51:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJd446Gmgz3078;
	Tue, 11 Aug 2026 00:51:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786373476;
	cv=none; b=G60bj5kSQM94Q/k00WeNWtE6g10c74QOATinSX5qrPHuCT1IhMEMIC2S6TUle8aFWDTt7y+6Hn6A8/g11MzQ4lPV7vUjFKARqNnu2Sr2PRBevK+s3UDFHTCmSaRjCoF39ljridqvc0MARZklHv9aAc1oP71m/Q8QagoJ1YM9uJILS381Yfcy5uD4wdBJz3rrH8WbIFqDJWorwk97H9UI5biVH0lmEXLe470FCFbqooVLIC9yaka94ya63M1+tZMU91iMMyUwuLu71ufiMxoBt6T/9lRKdvEN62ZyKnsYtnOD9lLM/LRFxiLrcIV7B3IE+H7ntp2YaNTY2K5RIATp0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786373476; c=relaxed/relaxed;
	bh=zCKCHVU4x1+k2/6kAbaEEPJTYyTGEg0cSKfx7OBMmiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=emX1blkBKjA5kWzu5vn4USCO9ljtdzrWguI+gDeAKDRbD1ooyfDiFfiaZM/lPMkI7fTDk7215HnPG02ebR6W3jcj2mFhX49SH2sSLffpPBJGCy0h27m9lcw28ornb2Hbzx38aKG8uczJ3eIA/FHyGMhm15mz3//ZYdR3neOnjQNo2977+JwtDDRBo/Zib2CTrW/EkPinjwYU+VszU5s0lZMQ8ISTQAh/FrvqB5VH3U9B+a1HKteSCqE8+cm6YThFYMiwriKJ3VIDrnR26+N0jelaYt9MZosMt6w3xYfKXbHFfDEYwb4LdmiZC5jyz8vcq0PnFLo0lwy1lcRGE+w+/A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ajZ9Di9b; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ajZ9Di9b; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ajZ9Di9b;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ajZ9Di9b;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJd433kChz2ytv
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 00:51:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zCKCHVU4x1+k2/6kAbaEEPJTYyTGEg0cSKfx7OBMmiQ=;
	b=ajZ9Di9bgWcWzkyiDNPj1a6nnFkqBCrxTD0hYbapJRtD9lg5OxBedIeu9sih/n/9FoQvxw
	kFPTLoiyVlD9I539n3EbWSguBQQsXlbqz7/sR6kbb3b2isUL5ZjQCd0JGLd3+huMqOX894
	2dMYIJnZl+rtQIYSJIFckIsq/HLQ6PI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zCKCHVU4x1+k2/6kAbaEEPJTYyTGEg0cSKfx7OBMmiQ=;
	b=ajZ9Di9bgWcWzkyiDNPj1a6nnFkqBCrxTD0hYbapJRtD9lg5OxBedIeu9sih/n/9FoQvxw
	kFPTLoiyVlD9I539n3EbWSguBQQsXlbqz7/sR6kbb3b2isUL5ZjQCd0JGLd3+huMqOX894
	2dMYIJnZl+rtQIYSJIFckIsq/HLQ6PI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-297-nWL5YjxwOEyHVhodz7oNqw-1; Mon,
 10 Aug 2026 10:51:04 -0400
X-MC-Unique: nWL5YjxwOEyHVhodz7oNqw-1
X-Mimecast-MFC-AGG-ID: nWL5YjxwOEyHVhodz7oNqw_1786373462
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E18581800578;
	Mon, 10 Aug 2026 14:51:01 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2768719560AB;
	Mon, 10 Aug 2026 14:50:55 +0000 (UTC)
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
Subject: [PATCH v9 23/26] netfs: Simplify read abandonment
Date: Mon, 10 Aug 2026 15:47:40 +0100
Message-ID: <20260810144746.574036-24-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: sMPgWdQhNpukQSzTaS5VEtg4MP6oH4IsvTG3_57GrlY_1786373462
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Currently, if one or more of the subrequests in a read request fails, the
read collection algorithm will attempt to salvage folios that are fully
downloaded but that span multiple subreqs, provided all of the contributory
subreqs succeeded, but this makes the algorithm quite complicated as a
subreq can contribute to multiple folios and a folio can be contributed to
by multiple subreqs.

Simplify this by just abandoning the rest of a read request once a
permanently failed subreq is hit.  This is what read_folio, DIO/unbuffered
read, gap filling, RMW and write preload all need to do; readahead is the
odd one out as it doesn't have any return other than unlocking folios.

With this change, even for readahead, the rest of the read is simply
abandoned; read() and suchlike will call ->read_folio() on each
non-uptodate folio to retry and retrieve the error.

Note that retryable failures still get retried by netfslib as part of the
request as before.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_collect.c | 190 ++++++++++++++++++++++++++++------------
 include/linux/netfs.h   |   1 +
 2 files changed, 137 insertions(+), 54 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 5d0a8a75ce26..cf7c36037edc 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -19,8 +19,8 @@
 #define MADE_PROGRESS	0x04	/* Made progress cleaning up a stream or the folio set */
 #define BUFFERED	0x08	/* The pagecache needs cleaning up */
 #define NEED_RETRY	0x10	/* A front op requests retrying */
-#define COPY_TO_CACHE	0x40	/* Need to copy subrequest to cache */
-#define ABANDON_SREQ	0x80	/* Need to abandon untransferred part of subrequest */
+#define COPY_TO_CACHE	0x20	/* Need to copy subrequest to cache */
+#define ABANDON_RREQ	0x40	/* Need to abandon the rest of a request */
 
 /*
  * Clear the unread part of an I/O request.
@@ -174,6 +174,78 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 	rreq->collect_cursor.slot = slot;
 }
 
+/*
+ * Abandon all remaining read results.  Once we've hit a permanent failure, we
+ * assume that the file is probably unusable.  In the event of readahead, in
+ * theory we might manage to read some data later in the file, that we could
+ * still unlock, but ->read_folio() will be called again.
+ */
+static void netfs_abandon_read_results(struct netfs_io_request *rreq)
+{
+	struct netfs_io_stream *stream = &rreq->io_streams[0];
+	unsigned int notes = ABANDON_RREQ;
+
+	_enter("%llx-%llx", rreq->start, rreq->start + rreq->len);
+	trace_netfs_rreq(rreq, netfs_rreq_trace_collect);
+	trace_netfs_collect(rreq);
+
+	if (rreq->origin == NETFS_READAHEAD ||
+	    rreq->origin == NETFS_READPAGE ||
+	    rreq->origin == NETFS_READ_FOR_WRITE)
+		notes |= BUFFERED;
+
+	/* Remove completed subrequests from the front of the stream and
+	 * advance the completion point.  We stop when we hit something that's
+	 * in progress.  The issuer thread may be adding stuff to the tail
+	 * whilst we're doing this.
+	 */
+	for (;;) {
+		struct netfs_io_subrequest *front;
+		unsigned long front_flags;
+
+		front = list_first_entry_or_null_acquire(&stream->subrequests,
+							 struct netfs_io_subrequest, rreq_link);
+		/* Read first subreq pointer before IN_PROGRESS flag. */
+		if (!front)
+			break;
+
+		front_flags = smp_load_acquire(&front->flags);
+		/* Order read of flags before read of anything else, such as error. */
+
+		/* Wait for each subreq to complete. */
+		if (test_bit(NETFS_SREQ_IN_PROGRESS, &front_flags)) {
+			notes |= HIT_PENDING;
+			break;
+		}
+
+		/* The subreq now belongs to us. */
+		if (!stream->failed) {
+			stream->failed = true;
+			stream->error = front->error;
+			rreq->error = front->error;
+			trace_netfs_rreq(rreq, netfs_rreq_trace_set_abandon);
+		}
+
+		stream->collected_to = front->start + front->len;
+		trace_netfs_sreq(front, netfs_sreq_trace_abandoned);
+
+		spin_lock(&rreq->lock);
+		list_del_init(&front->rreq_link);
+		spin_unlock(&rreq->lock);
+		netfs_put_subrequest(front, netfs_sreq_trace_put_abandon);
+	}
+
+	rreq->collected_to = stream->collected_to;
+	rreq->abandon_to = rreq->collected_to;
+	if (notes & BUFFERED)
+		netfs_read_unlock_folios(rreq, &notes);
+	else
+		rreq->cleaned_to = rreq->collected_to;
+
+	trace_netfs_collect_stream(rreq, stream);
+	trace_netfs_collect_state(rreq, rreq->collected_to, notes);
+}
+
 /*
  * Collect and assess the results of various read subrequests.  We may need to
  * retry some of the results.
@@ -193,6 +265,9 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	trace_netfs_collect(rreq);
 
 reassess:
+	if (test_bit(NETFS_RREQ_ABANDON_REQ, &rreq->flags))
+		goto abandon_request;
+
 	if (rreq->origin == NETFS_READAHEAD ||
 	    rreq->origin == NETFS_READPAGE ||
 	    rreq->origin == NETFS_READ_FOR_WRITE)
@@ -210,7 +285,9 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	/* Read first subreq pointer before IN_PROGRESS flag. */
 
 	while (front) {
+		unsigned long front_flags;
 		size_t transferred;
+		uoff_t unlock_at = rreq->start + rreq->progress_at;
 
 		trace_netfs_collect_sreq(rreq, front);
 		_debug("sreq [%x] %llx %zx/%zx",
@@ -221,25 +298,63 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			stream->collected_to = front->start;
 		}
 
-		if (netfs_check_subreq_in_progress(front))
+		front_flags = smp_load_acquire(&front->flags);
+		/* Order read of flags before read of anything else, such as error. */
+
+		if (test_bit(NETFS_SREQ_FAILED, &front_flags))
+			goto abandon_request;
+		if (test_bit(NETFS_SREQ_IN_PROGRESS, &front_flags))
 			notes |= HIT_PENDING;
-		smp_rmb(); /* Read counters after IN_PROGRESS flag. */
+
 		transferred = READ_ONCE(front->transferred);
 
+		/* If we can collect the next folio from a pending op, do so,
+		 * but we should only do it if we don't otherwise need to wait
+		 * for completion.
+		 */
+		if ((notes & HIT_PENDING) &&
+		    (notes & BUFFERED) &&
+		    !test_bit(NETFS_SREQ_HIT_EOF, &front_flags) &&
+		    front->error == 0 &&
+		    transferred < front->len
+		    ) {
+			stream->collected_to = front->start + transferred;
+			rreq->collected_to = stream->collected_to;
+
+			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &front_flags))
+				notes |= COPY_TO_CACHE;
+			if (front->start + transferred >= unlock_at)
+				netfs_read_unlock_folios(rreq, &notes);
+		}
+
+		/* Stall if the front is still undergoing I/O. */
+		if (notes & HIT_PENDING)
+			break;
+
+		if (test_bit(NETFS_SREQ_NEED_RETRY, &front_flags)) {
+			stream->need_retry = true;
+			notes |= NEED_RETRY | MADE_PROGRESS;
+			break;
+		} else if (test_bit(NETFS_RREQ_SHORT_TRANSFER, &rreq->flags)) {
+			notes |= MADE_PROGRESS;
+		} else {
+			stream->transferred += transferred;
+			stream->transferred_valid = true;
+			if (front->transferred < front->len)
+				set_bit(NETFS_RREQ_SHORT_TRANSFER, &rreq->flags);
+			notes |= MADE_PROGRESS;
+		}
+
 		/* If we can now collect the next folio, do so.  We don't want
 		 * to defer this as we have to decide whether we need to copy
 		 * to the cache or not, and that may differ between adjacent
 		 * subreqs.
 		 */
 		if (notes & BUFFERED) {
-			uoff_t unlock_at = rreq->start + rreq->progress_at;
-
 			/* Clear the tail of a short read. */
-			if (!(notes & HIT_PENDING) &&
-			    front->error == 0 &&
-			    transferred < front->len &&
-			    (test_bit(NETFS_SREQ_HIT_EOF, &front->flags) ||
-			     test_bit(NETFS_SREQ_CLEAR_TAIL, &front->flags))) {
+			if (transferred < front->len &&
+			    (test_bit(NETFS_SREQ_HIT_EOF, &front_flags) ||
+			     test_bit(NETFS_SREQ_CLEAR_TAIL, &front_flags))) {
 				netfs_clear_unread(front);
 				transferred = front->transferred = front->len;
 				trace_netfs_sreq(front, netfs_sreq_trace_clear);
@@ -248,67 +363,28 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 
-			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &front->flags))
+			if (test_bit(NETFS_SREQ_COPY_TO_CACHE, &front_flags))
 				notes |= COPY_TO_CACHE;
 
-			if (test_bit(NETFS_SREQ_FAILED, &front->flags)) {
-				rreq->abandon_to = front->start + front->len;
-				front->transferred = front->len;
-				transferred = front->len;
-				trace_netfs_rreq(rreq, netfs_rreq_trace_set_abandon);
-			}
 			if (front->start + transferred >= unlock_at ||
-			    test_bit(NETFS_SREQ_HIT_EOF, &front->flags))
+			    test_bit(NETFS_SREQ_HIT_EOF, &front_flags))
 				netfs_read_unlock_folios(rreq, &notes);
 		} else {
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 		}
 
-		/* Stall if the front is still undergoing I/O. */
-		if (notes & HIT_PENDING)
-			break;
-
-		if (test_bit(NETFS_SREQ_FAILED, &front->flags)) {
-			if (!stream->failed) {
-				stream->error = front->error;
-				rreq->error = front->error;
-				set_bit(NETFS_RREQ_FAILED, &rreq->flags);
-				stream->failed = true;
-			}
-			notes |= MADE_PROGRESS | ABANDON_SREQ;
-		} else if (test_bit(NETFS_SREQ_NEED_RETRY, &front->flags)) {
-			stream->need_retry = true;
-			notes |= NEED_RETRY | MADE_PROGRESS;
-			break;
-		} else if (test_bit(NETFS_RREQ_SHORT_TRANSFER, &rreq->flags)) {
-			notes |= MADE_PROGRESS;
-		} else {
-			if (!stream->failed) {
-				stream->transferred += transferred;
-				stream->transferred_valid = true;
-			}
-			if (front->transferred < front->len)
-				set_bit(NETFS_RREQ_SHORT_TRANSFER, &rreq->flags);
-			notes |= MADE_PROGRESS;
-		}
-
 		/* Remove if completely consumed. */
 		stream->source = front->source;
 		spin_lock(&rreq->lock);
 
 		remove = front;
-		trace_netfs_sreq(front,
-				 notes & ABANDON_SREQ ?
-				 netfs_sreq_trace_abandoned : netfs_sreq_trace_consumed);
+		trace_netfs_sreq(front, netfs_sreq_trace_consumed);
 		list_del_init(&front->rreq_link);
 		front = list_first_entry_or_null(&stream->subrequests,
 						 struct netfs_io_subrequest, rreq_link);
 		spin_unlock(&rreq->lock);
-		netfs_put_subrequest(remove,
-				     notes & ABANDON_SREQ ?
-				     netfs_sreq_trace_put_abandon :
-				     netfs_sreq_trace_put_done);
+		netfs_put_subrequest(remove, netfs_sreq_trace_put_done);
 	}
 
 	trace_netfs_collect_stream(rreq, stream);
@@ -337,6 +413,12 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	_debug("retry");
 	netfs_retry_reads(rreq);
 	goto out;
+
+abandon_request:
+	set_bit(NETFS_RREQ_FAILED, &rreq->flags);
+	set_bit(NETFS_RREQ_ABANDON_REQ, &rreq->flags);
+	netfs_wake_rreq_flag(rreq, NETFS_RREQ_PAUSE, netfs_rreq_trace_unpause);
+	return netfs_abandon_read_results(rreq);
 }
 
 /*
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 43696fc67a2a..f277c187c408 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -281,6 +281,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_FAILED		3	/* The request failed */
 #define NETFS_RREQ_RETRYING		4	/* Set if we're in the retry path */
 #define NETFS_RREQ_SHORT_TRANSFER	5	/* Set if we have a short transfer */
+#define NETFS_RREQ_ABANDON_REQ		6	/* Set if the request is to be abandoned */
 #define NETFS_RREQ_CACHE_STOP		8	/* Set to stop caching (ENOBUFS or error) */
 #define NETFS_RREQ_CACHE_ERROR		9	/* Set if we got an error from the cache */
 #define NETFS_RREQ_OFFLOAD_COLLECTION	12	/* Offload collection to workqueue */


