Return-Path: <linux-erofs+bounces-3977-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB06C531C7
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 13:06:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4vdn3SQDz2ydn;
	Wed, 22 Jul 2026 23:06:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784725581;
	cv=none; b=aAr4BPfWKmRl+OHK2MnNout2w0q6NEuLSgzubCcVmEYxGmoX3krEtQKMiPrsTAFTo2VLjNqn3f+CFu2HXkQna9q+pFFDa8KK+eQYnCWeaBXgM6qRS0KPN71j8VmfUoNFlSOSzz4Vje48/AAgpJ9wtnTc9ZqoV8OXz0jNxZFQdGuCquqwSYwLyYO4nUipz23dDndUMAyIBzpbgLnynd8vRURi6g34PqEIg2/GMeu0yGGAV7qpyX93TgRiB6/jv7zkxWWWCsxwn00zPSBAPmwLeVXAO2UZ7ZRw0JhZ32MYOfzuaIvcjrpCTkupiYovcoCPMgiZQ8nU3gpbUslOUpubPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784725581; c=relaxed/relaxed;
	bh=FWEY43vPNI+Bcv/QY/9mbIT/8heayVctqcSbg2SNB9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=m723yQNPwsn5JVYTizRWkN5N9uqh9wUzCgsCm8nE7TiVrj39EayxnlKbWRU0/+apcf8glW3b9Di7BTs8VKnTExkGN/XpB9AvZRB6lk36U1OQdsETrs6czNsqgTJ9yr2xvODLdwpOYzvYkAnemYkqc15DmqSJpeBpu0owrzE0aaJIlO+pPsVdnYcb7LxUYVZsbB6PjRt/r3+plru/ngTlT5KEg28ndv9khBBAEi4pJHdI9aAj3aJj7so0yRFoce7fE4SV09eRQ1gL7LMYnysx5+TiHDn5zO6ewoCW1qObHxSp/NYazeo4KZMjCqQwFxKb5eNusOIm08oYyFrx06VXgQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OUuRTe7i; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OUuRTe7i; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OUuRTe7i;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OUuRTe7i;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4vdm483Sz2yFK
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 23:06:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FWEY43vPNI+Bcv/QY/9mbIT/8heayVctqcSbg2SNB9E=;
	b=OUuRTe7iRdmeXVvcMAIYCKQiwIM8Cfr3rp2LbABT9ep7Ng91AO+RdEbIOW8VWk83JiVmId
	FPyMV+bw3hrL1E4VxhtQ3c3FwtD/u3RV1ZRfbbV+6anNcoQgmlNrt+fQWlDhQs5ghSPfwc
	ZXi00hshNnRoA56DmQaKfu4MndyjHAQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FWEY43vPNI+Bcv/QY/9mbIT/8heayVctqcSbg2SNB9E=;
	b=OUuRTe7iRdmeXVvcMAIYCKQiwIM8Cfr3rp2LbABT9ep7Ng91AO+RdEbIOW8VWk83JiVmId
	FPyMV+bw3hrL1E4VxhtQ3c3FwtD/u3RV1ZRfbbV+6anNcoQgmlNrt+fQWlDhQs5ghSPfwc
	ZXi00hshNnRoA56DmQaKfu4MndyjHAQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-StQwzKBvP-mGBHI2z4ecjA-1; Wed,
 22 Jul 2026 09:06:10 -0400
X-MC-Unique: StQwzKBvP-mGBHI2z4ecjA-1
X-Mimecast-MFC-AGG-ID: StQwzKBvP-mGBHI2z4ecjA_1784725567
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B58D91955D8E;
	Wed, 22 Jul 2026 13:06:07 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DEB351800623;
	Wed, 22 Jul 2026 13:06:01 +0000 (UTC)
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
Subject: [PATCH v7 27/29] netfs: Check for too much data being read
Date: Wed, 22 Jul 2026 14:02:14 +0100
Message-ID: <20260722130218.78958-28-dhowells@redhat.com>
In-Reply-To: <20260722130218.78958-1-dhowells@redhat.com>
References: <20260722130218.78958-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: HxtyDIT3gNFb447d8udgB3Dl6dVH62INsri_Ta7Yzl0_1784725567
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Put in a check in read subreq termination to detect more data being read
for a subrequest than was requested.  In the event that this happens, abort
the rest of the read request on the basis that some of the read buffer may
have been corrupted and return -EIO.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_collect.c      | 56 ++++++++++++++++++++++++++++++++++--
 include/linux/netfs.h        |  1 +
 include/trace/events/netfs.h |  1 +
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index e0fe7b13dd7a..ea65483d2537 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -19,8 +19,9 @@
 #define MADE_PROGRESS	0x04	/* Made progress cleaning up a stream or the folio set */
 #define BUFFERED	0x08	/* The pagecache needs cleaning up */
 #define NEED_RETRY	0x10	/* A front op requests retrying */
-#define COPY_TO_CACHE	0x40	/* Need to copy subrequest to cache */
-#define ABANDON_SREQ	0x80	/* Need to abandon untransferred part of subrequest */
+#define COPY_TO_CACHE	0x20	/* Need to copy subrequest to cache */
+#define ABANDON_SREQ	0x40	/* Need to abandon untransferred part of subrequest */
+#define ABANDON_RREQ	0x80	/* Need to abandon the rest of a request */
 
 /*
  * Clear the unread part of an I/O request.
@@ -201,6 +202,8 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 		notes = BUFFERED;
 	else
 		notes = 0;
+	if (test_bit(NETFS_RREQ_ABANDON_REQ, &rreq->flags))
+		notes |= ABANDON_RREQ;
 
 	/* Remove completed subrequests from the front of the stream and
 	 * advance the completion point.  We stop when we hit something that's
@@ -226,14 +229,43 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 		if (netfs_check_subreq_in_progress(front))
 			notes |= HIT_PENDING;
 		smp_rmb(); /* Read counters after IN_PROGRESS flag. */
+
 		transferred = READ_ONCE(front->transferred);
+		if (unlikely(transferred > front->len)) {
+			/* Ugh...  A subreq overran its allotted length.  It
+			 * may have corrupted the read buffer.
+			 */
+			set_bit(NETFS_RREQ_FAILED, &rreq->flags);
+			set_bit(NETFS_RREQ_ABANDON_REQ, &rreq->flags);
+			notes |= ABANDON_RREQ;
+		}
+
+		/* Deal with an abandoned request.  Wait for each subreq to
+		 * complete before abandoning them.
+		 */
+		if (unlikely(notes & ABANDON_RREQ)) {
+			if (notes & HIT_PENDING)
+				break;
+
+			/* The subreq now belongs to us. */
+			stream->error = -EIO;
+			stream->failed = true;
+			rreq->abandon_to = front->start + front->len;
+			rreq->error = -EIO;
+			transferred = 0;
+			trace_netfs_rreq(rreq, netfs_rreq_trace_set_abandon);
+			notes |= ABANDON_SREQ;
+			goto sreq_complete;
+		}
 
 		/* If we can now collect the next folio, do so.  We don't want
 		 * to defer this as we have to decide whether we need to copy
 		 * to the cache or not, and that may differ between adjacent
 		 * subreqs.
 		 */
-		if (notes & BUFFERED) {
+		if (notes & ABANDON_SREQ) {
+			/* Don't collect anything. */
+		} else if (notes & BUFFERED) {
 			size_t fsize = PAGE_SIZE << rreq->front_folio_order;
 
 			/* Clear the tail of a short read. */
@@ -295,6 +327,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			notes |= MADE_PROGRESS;
 		}
 
+sreq_complete:
 		/* Remove if completely consumed. */
 		stream->source = front->source;
 		spin_lock(&rreq->lock);
@@ -319,6 +352,8 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	if (!(notes & BUFFERED))
 		rreq->cleaned_to = rreq->collected_to;
 
+	if (notes & ABANDON_RREQ)
+		goto out;
 	if (notes & NEED_RETRY)
 		goto need_retry;
 	if (notes & MADE_PROGRESS) {
@@ -543,6 +578,21 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 		break;
 	}
 
+	/* If the subrequest read more than it was supposed to, abort
+	 * the request with EIO as we may have clobbered other parts
+	 * of the buffer that are already read.
+	 */
+	if (subreq->transferred > subreq->len) {
+		trace_netfs_sreq(subreq, netfs_sreq_trace_too_much);
+		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+		subreq->error = -EIO;
+		trace_netfs_failure(rreq, subreq, subreq->error, netfs_fail_read);
+		trace_netfs_rreq(rreq, netfs_rreq_trace_set_pause);
+		set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
+		goto skip_error_checks;
+	}
+
 	/* Deal with retry requests, short reads and errors.  If we retry
 	 * but don't make progress, we abandon the attempt.
 	 */
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 820b7d7ed226..6d1201fbb59c 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -280,6 +280,7 @@ struct netfs_io_request {
 #define NETFS_RREQ_FAILED		3	/* The request failed */
 #define NETFS_RREQ_RETRYING		4	/* Set if we're in the retry path */
 #define NETFS_RREQ_SHORT_TRANSFER	5	/* Set if we have a short transfer */
+#define NETFS_RREQ_ABANDON_REQ		6	/* Set if the request is to be abandoned */
 #define NETFS_RREQ_CACHE_STOP		8	/* Set to stop caching (ENOBUFS or error) */
 #define NETFS_RREQ_CACHE_ERROR		9	/* Set if we got an error from the cache */
 #define NETFS_RREQ_OFFLOAD_COLLECTION	12	/* Offload collection to workqueue */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 071d20e80f13..723cb7315308 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -132,6 +132,7 @@
 	EM(netfs_sreq_trace_submit,		"SUBMT")	\
 	EM(netfs_sreq_trace_superfluous,	"SPRFL")	\
 	EM(netfs_sreq_trace_terminated,		"TERM ")	\
+	EM(netfs_sreq_trace_too_much,		"!TOOM")	\
 	EM(netfs_sreq_trace_wait_for,		"_WAIT")	\
 	EM(netfs_sreq_trace_write,		"WRITE")	\
 	EM(netfs_sreq_trace_write_skip,		"SKIP ")	\


