Return-Path: <linux-erofs+bounces-4519-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0011CC79FAA
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Sep 2026 07:22:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfshM4hKwz2ypw;
	Wed, 09 Sep 2026 17:22:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788938547;
	cv=none; b=lg0D+jopzP9dVCHL1NSbCLBt7cCOFpmQWWBnof+khQHy2Z6pfsmWU2Q9WJprOu/ULIi4yfB2KgKRED3ms+dttaKVWgkFH43mPF3x5br7wRK1EX1lkYywSaZOjh3nPIiyG9U74uE3Gg/mpXDXVfuWgIDoCHTflUW4sUjh8Ef1DBnqxviqKxc6/+5UiH3IF5iIzCP41MdxhjUvj8lpRuk0sL2Ztr29PK8lXkVwy5Wx0Wv+Kt7NEjXs9UjYkTTeRNiiwfAZ19Ns6UkpRnxct/w949tFmK6RB0xa8j5vaotDUu5n6rau7Qj6FDGzwExmZEuF2TQin2wYY6hHuIp8FfxA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788938547; c=relaxed/relaxed;
	bh=nAsW5yEg0j90AdMORlt1/NoxAV0LXUfyFEbbAwn2YKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=AZgxyj/RuOJ805VV2SzIbcAfocojRJu8gFAVVGY4SdWCgtILq3wny+NYeacCOzMOCVHNa8Z6gJP7N5Q0GmN6L4J+2Vytb0iQYnxC0FvmENjZ2WrcE91OnjEcF09wJyellO2ra0BElOV4SjWDnLo9Udc9Keo2kyAFhkpCTlEpDhwo6+2VAFpBRcY60qeCmHlZHl3+raGCeUW32KHk1lZB8sObwQ9KE6IRgEsGut+ER3HK/b3vXAj4D1z9foqrozyXrrkg+GZivBgOxE5DwJ+fyFW/h11rX1baaehiF1pGVFWIXcU5mlicydmY6a4OuM6RyUOIrTzJ+fUN10pJux02+w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Lh7tXSEk; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Wx0VRUix; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Lh7tXSEk;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Wx0VRUix;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfshL4bdQz2y2J
	for <linux-erofs@lists.ozlabs.org>; Wed, 09 Sep 2026 17:22:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788938542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAsW5yEg0j90AdMORlt1/NoxAV0LXUfyFEbbAwn2YKU=;
	b=Lh7tXSEkfSZvVIXBpJ+EdpT76o3TOfXopnO2fuVySFkMFedCrgrAbbHk3E+aDzfR7fW/hJ
	74IgxOzkmAZZIaWYWyY8bkj68xwk3DyeaIfyEZt8M70UOTv3Dg60nPM1CDYf/RquSMdaz4
	twLGAHnGxpKb4OxJVrtAfkqetWwN6r8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788938543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAsW5yEg0j90AdMORlt1/NoxAV0LXUfyFEbbAwn2YKU=;
	b=Wx0VRUix9jzivrM75X+BArqeJI04lph3aa/b78BCCJ5gdC7qYFk6MIH0BpipNO0txBxhEg
	4Y5WQu1uG0QyRfObM05qMKqMIeuHCtnVKcsg3FkjZ3JdkqABh9AEfQ46nQQySmwSN0EABE
	M7rr1foUE2qvUokwYEvuhNGhIe/hvEE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-oVNCwf8NO6mt5eFhg8VtfA-1; Wed,
 09 Sep 2026 03:22:19 -0400
X-MC-Unique: oVNCwf8NO6mt5eFhg8VtfA-1
X-Mimecast-MFC-AGG-ID: oVNCwf8NO6mt5eFhg8VtfA_1788938536
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5C601955F17;
	Wed,  9 Sep 2026 07:22:16 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42C6C180036E;
	Wed,  9 Sep 2026 07:22:11 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
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
Subject: [PATCH v13 7/8] netfs: Add some functions to wrap the all-queued handling
Date: Wed,  9 Sep 2026 08:21:01 +0100
Message-ID: <20260909072105.1663687-8-dhowells@redhat.com>
In-Reply-To: <20260909072105.1663687-1-dhowells@redhat.com>
References: <20260909072105.1663687-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: I20oRio8w0pOmv2sKy90l_7iJ92lRM-vTPsXmXFhzM0_1788938536
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add some helper functions to wrap the handling of the NETFS_RREQ_ALL_QUEUED
flag and to insert the appropriate barriers.  Also add an
smb_mb__after_atomic() after the set_bit() to make sure stuff after the
set_bit() in the same thread doesn't get ordered before.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c     |  9 +++------
 fs/netfs/direct_read.c       |  9 +++------
 fs/netfs/internal.h          | 20 ++++++++++++++++++++
 fs/netfs/misc.c              |  2 +-
 fs/netfs/read_collect.c      |  4 +---
 fs/netfs/read_pgpriv2.c      |  3 +--
 fs/netfs/read_single.c       |  9 +++------
 fs/netfs/write_collect.c     |  3 +--
 fs/netfs/write_issue.c       |  6 ++----
 include/trace/events/netfs.h |  1 +
 10 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 54287a8ef0f8..887d45f3745a 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -355,10 +355,8 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 		}
 		start += slice;
 		size -= slice;
-		if (size <= 0) {
-			smp_wmb(); /* Write lists before ALL_QUEUED. */
-			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
-		}
+		if (size <= 0)
+			netfs_all_subreqs_queued(rreq);
 
 		if (fq) {
 			/* See if the cache indicated this should be cached. */
@@ -378,8 +376,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 	} while (size > 0);
 
 	if (unlikely(size > 0)) {
-		smp_wmb(); /* Write lists before ALL_QUEUED. */
-		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+		netfs_all_subreqs_queued(rreq);
 		netfs_wake_collector(rreq);
 	}
 
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index aa10af5171a8..5405e108b7a3 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -84,10 +84,8 @@ static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 		size -= slice;
 		start += slice;
 		rreq->submitted += slice;
-		if (size <= 0) {
-			smp_wmb(); /* Write lists before ALL_QUEUED. */
-			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
-		}
+		if (size <= 0)
+			netfs_all_subreqs_queued(rreq);
 
 		rreq->netfs_ops->issue_read(subreq);
 
@@ -99,8 +97,7 @@ static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 	} while (size > 0);
 
 	if (unlikely(size > 0)) {
-		smp_wmb(); /* Write lists before ALL_QUEUED. */
-		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+		netfs_all_subreqs_queued(rreq);
 		netfs_wake_collector(rreq);
 	}
 }
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 3aebe4a4f7b0..d579c5d79609 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -341,6 +341,26 @@ static inline bool netfs_check_subreq_in_progress(const struct netfs_io_subreque
 	return test_bit_acquire(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 }
 
+/*
+ * Indicate that we've generated and queued all the subrequests we're going to.
+ */
+static inline void netfs_all_subreqs_queued(struct netfs_io_request *rreq)
+{
+	smp_wmb(); /* Write lists before ALL_QUEUED. */
+	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+	smp_mb__after_atomic();
+	trace_netfs_rreq(rreq, netfs_rreq_trace_all_queued);
+}
+
+/*
+ * Query if all subrequests are queued.
+ */
+static inline bool netfs_are_all_subreqs_queued(const struct netfs_io_request *rreq)
+{
+	/* Read lists after ALL_QUEUED. */
+	return test_bit_acquire(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+}
+
 /*
  * fscache-cache.c
  */
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index eafc4edae6a0..a3cd76d584b8 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -424,7 +424,7 @@ static int netfs_collect_in_app(struct netfs_io_request *rreq,
 			need_collect = true;
 			break;
 		}
-		if (subreq || !test_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags))
+		if (subreq || !netfs_are_all_subreqs_queued(rreq))
 			done = false;
 	}
 
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 01ea1ddae04b..cb97dedad170 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -462,10 +462,8 @@ bool netfs_read_collection(struct netfs_io_request *rreq)
 	/* We're done when the app thread has finished posting subreqs and the
 	 * queue is empty.
 	 */
-	if (!test_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags))
+	if (!netfs_are_all_subreqs_queued(rreq))
 		return false;
-	smp_rmb(); /* Read ALL_QUEUED before subreq lists. */
-
 	if (!list_empty(&stream->subrequests))
 		return false;
 
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index bf4d9d6877d7..5280b606fda4 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -158,8 +158,7 @@ void netfs_pgpriv2_end_copy_to_cache(struct netfs_io_request *rreq)
 		return;
 
 	netfs_issue_write(creq, &creq->io_streams[1]);
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &creq->flags);
+	netfs_all_subreqs_queued(creq);
 	trace_netfs_rreq(rreq, netfs_rreq_trace_end_copy_to_cache);
 	if (list_empty_careful(&creq->io_streams[1].subrequests))
 		netfs_wake_collector(creq);
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index de67ac41548d..ccb5fc809d99 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -113,14 +113,12 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 				goto cancel;
 		}
 
-		smp_wmb(); /* Write lists before ALL_QUEUED. */
-		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+		netfs_all_subreqs_queued(rreq);
 		rreq->netfs_ops->issue_read(subreq);
 		rreq->submitted += subreq->len;
 		break;
 	case NETFS_READ_FROM_CACHE:
-		smp_wmb(); /* Write lists before ALL_QUEUED. */
-		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+		netfs_all_subreqs_queued(rreq);
 		trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
 		netfs_single_read_cache(rreq, subreq);
 		rreq->submitted += subreq->len;
@@ -136,8 +134,7 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 	return ret;
 cancel:
 	netfs_cancel_read(subreq, ret);
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+	netfs_all_subreqs_queued(rreq);
 	netfs_wake_collector(rreq);
 	return ret;
 }
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 7194182b975c..6d99d4a6f780 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -371,9 +371,8 @@ bool netfs_write_collection(struct netfs_io_request *wreq)
 	/* We're done when the app thread has finished posting subreqs and all
 	 * the queues in all the streams are empty.
 	 */
-	if (!test_bit(NETFS_RREQ_ALL_QUEUED, &wreq->flags))
+	if (!netfs_are_all_subreqs_queued(wreq))
 		return false;
-	smp_rmb(); /* Read ALL_QUEUED before lists. */
 
 	transferred = LONG_MAX;
 	for (s = 0; s < NR_IO_STREAMS; s++) {
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 5d130df2ff0d..9a528da4bf9f 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -520,8 +520,7 @@ static void netfs_end_issue_write(struct netfs_io_request *wreq)
 {
 	bool needs_poke = true;
 
-	smp_wmb(); /* Write subreq lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &wreq->flags);
+	netfs_all_subreqs_queued(wreq);
 
 	for (int s = 0; s < NR_IO_STREAMS; s++) {
 		struct netfs_io_stream *stream = &wreq->io_streams[s];
@@ -789,8 +788,7 @@ int netfs_writeback_single(struct address_space *mapping,
 stop:
 	for (int s = 0; s < NR_IO_STREAMS; s++)
 		netfs_issue_write(wreq, &wreq->io_streams[s]);
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &wreq->flags);
+	netfs_all_subreqs_queued(wreq);
 
 	netfs_wake_collector(wreq);
 
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index c9ec4da97f0b..303309be253f 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -47,6 +47,7 @@
 	E_(NETFS_PGPRIV2_COPY_TO_CACHE,		"2C")
 
 #define netfs_rreq_traces					\
+	EM(netfs_rreq_trace_all_queued,		"ALL-Q  ")	\
 	EM(netfs_rreq_trace_assess,		"ASSESS ")	\
 	EM(netfs_rreq_trace_collect,		"COLLECT")	\
 	EM(netfs_rreq_trace_complete,		"COMPLET")	\


