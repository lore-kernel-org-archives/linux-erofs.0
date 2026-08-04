Return-Path: <linux-erofs+bounces-4132-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C767CC55172
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 10:06:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDq1s27dyz3092;
	Tue, 04 Aug 2026 20:06:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785837969;
	cv=none; b=Pfyx7Sotbowc/g1ZM6ZUD0DDFD0gX7ar8GP/wFkerGqXRiilF/5meDmZ0CDhiPTEsg1Q46GUzAXn9x1eSxrWFkjYLiPxmkyuHhzY7O5vjlz8L55VxJsriaM9Ha2si3lwVSz2DXVM9vG2uvhsgAW5v0FEvANdHbd/jqdbKyv5a2aHTMP2ctoKZ8TeH6stwddbX8MKFedKDXpQyRyjqgXrsZ3FpmtZknUmdRbSPMiOhtOR73DdAsQRaKsn+jNgZ1eXRD+i8ZD98Q1rptksa5jzrjc1z5PVM/wpvYpr6EhoFAusQNFpoW5oFVyzDu+RufeyUW/CjM6d/AxTTz+rBJ9PZw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785837969; c=relaxed/relaxed;
	bh=sw9QLN4Eo22U6hV0yvAqFQYyIGZYoQWv7uAFLRvStsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gwuJdaEHZOvRqbgU0YEYmn8Ii88aEl01sVSmAnIeyrbBlTTmAI8W7QtTvF3+yfjaJv4CU71NdUclbDgGwoR31Nl0vukGfHUGjrRbG54BZf0owxRD5rI1b/2p3tlW0eg8bN8CcITNtqOomuepWrA+7v0+pO7nVB1lCr4ZOqtw4+G1uyZGMQiQWQGKEBxmd7iIRyAQr5WcNcxFFOzBN81QDYSwORTfE8mi+5eUpJzGQYTt0AZZ/fAvQ3yQaz0r/bM3YrTojDVzFFyiFXIWXVr3mC/MG7XjXrgxFWwHJoJPlpnWdAIpB9h51ZpjLvNxFsGk7salDTqScAm831Qn638ikw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=d1DXz1ey; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bmQQIzvq; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=d1DXz1ey;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bmQQIzvq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDq1r0YxMz2yMl
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 20:06:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785837964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sw9QLN4Eo22U6hV0yvAqFQYyIGZYoQWv7uAFLRvStsQ=;
	b=d1DXz1ey5NRzpJYHMmjcyZk7Vinsg3sOMa37LADYBzazR+VpO6sdEkMRWAlFZF/MCcKLgU
	ZlcodAivoD+lb0em8Tixo6i1PLgCu1Zh6DqQIQVaKspqPoro5z0MI+iRgQCAwGKHpt0iuV
	yB8ifMsh0aWAJaR51LCt1viPdy7Cu9k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785837965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sw9QLN4Eo22U6hV0yvAqFQYyIGZYoQWv7uAFLRvStsQ=;
	b=bmQQIzvq+v63hYquAtr/bsNS13LRuCpzWDfgCA8d+p4uWVAy/iPhHByQsGlVfMTfv4HvKd
	JdhVxR5rmunDcvrxOt0973d524nM+ePtQV6z36p6DKxKVi11P4Ko7aTjBQzVbGJWWsj+ev
	luecMsYS7pOk58Fc5bP6GT88v91Gzpc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-240-MyJDiyf8MBaCKMw0VZ2Eqg-1; Tue,
 04 Aug 2026 06:05:40 -0400
X-MC-Unique: MyJDiyf8MBaCKMw0VZ2Eqg-1
X-Mimecast-MFC-AGG-ID: MyJDiyf8MBaCKMw0VZ2Eqg_1785837937
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C952C18002CE;
	Tue,  4 Aug 2026 10:05:37 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E1323300019F;
	Tue,  4 Aug 2026 10:05:31 +0000 (UTC)
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
Subject: [PATCH v8 22/25] netfs: Check for too much data being read
Date: Tue,  4 Aug 2026 11:02:17 +0100
Message-ID: <20260804100224.2748935-23-dhowells@redhat.com>
In-Reply-To: <20260804100224.2748935-1-dhowells@redhat.com>
References: <20260804100224.2748935-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: rqVKXwCXfFafs1XYNmIqCpQBLXWBRymTcTztillDikY_1785837937
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
 fs/netfs/read_collect.c      | 57 ++++++++++++++++++++++++++++++++++--
 include/linux/netfs.h        |  1 +
 include/trace/events/netfs.h |  1 +
 3 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index e0fe7b13dd7a..8ab27103a86d 100644
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
@@ -226,14 +229,44 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
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
+			netfs_wake_rreq_flag(rreq, NETFS_RREQ_PAUSE, netfs_rreq_trace_unpause);
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
@@ -295,6 +328,7 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			notes |= MADE_PROGRESS;
 		}
 
+sreq_complete:
 		/* Remove if completely consumed. */
 		stream->source = front->source;
 		spin_lock(&rreq->lock);
@@ -319,6 +353,8 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	if (!(notes & BUFFERED))
 		rreq->cleaned_to = rreq->collected_to;
 
+	if (notes & ABANDON_RREQ)
+		goto out;
 	if (notes & NEED_RETRY)
 		goto need_retry;
 	if (notes & MADE_PROGRESS) {
@@ -543,6 +579,21 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
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
index fc316682dddb..856a6ba3fc71 100644
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


