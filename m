Return-Path: <linux-erofs+bounces-4318-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D21C5DF94
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDG34K50z2yCL;
	Tue, 25 Aug 2026 00:44:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582683;
	cv=none; b=Z6PeKS6jmJsOQ5mkPCtpeV1Amzxu0Gpcv58gK0fYZ+k6m38g9YBHOfD8c1BQmikJyPrO6hFFfy2q2ceexmmwCPX9E5Ue/kuqtbZdY4DQ3TtzCtP2RqG24x4PnUg/+1iriNsKW4G8LsCdzWRH2zCSY4mM4xMb36JzsoccoVhojfW1jLwarn3JeZKfsDORpr1Lodk2agw1+aj5Ld1wOpVAQ55kdmQrP+H+D+PioqGcdo2YK55vOF/pXZ3jGuSUOs67+dieFhqod8Zrv+5zXXT5K/ssjjINZpXJ+ak5nSvsGtMCcnZicOmK+EkumSc+4mfLPvbPfyo1eU8g6SCy8yKuhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582683; c=relaxed/relaxed;
	bh=gyAlcOnJzmfzASmgtzD8YShFZnNf+3YpRDZZvlK08ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=k+sl0S7lhA/GSjQrRRfWsc65lZZbEEujKaC65K+IStOx2ANNeKOl+F27LceUOuOGjr8cQSpmE/Weu6fmCqYRh3e+xv+BvbnYVz7XL1PxjQBEfRzI8UTM1/mfrscsM6obSFWcsnUciejZT26v+IqFa1a6kYKMbnu0mtdUmWLSkLOfW4cp8ALx8lV/MbU0zA3/GSSx/dBOH9Uipf7xTuWIIdZQta6VHbYcaeGY1R5tg1Bf+rieQqaDsd3LHSifqDJb8jmBpcdTs4xMaR9+p0My89E22lrBHpQQXsOYusoR99JeRVNY0PI0zRGmonE+Ol5F0SkpqzzQzCPVj/LMcYUmMw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cntFjCh6; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cntFjCh6; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cntFjCh6;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cntFjCh6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDG24KTcz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:44:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyAlcOnJzmfzASmgtzD8YShFZnNf+3YpRDZZvlK08ds=;
	b=cntFjCh6DUk0ks2/g6l+QaD6WE/mvvs5reVdPtLwO1QX6W7UlWKOi4WpKKfHOr57ZSqIcq
	JdnpzcOe3/nYQiL+7Oa0+fjvm0m9bjT4vLn104bkWafBPsoH4FyjAujYcAgeD5RwjrXvj9
	wYCs+HRdd0MJ/mysTggR/cDBMnPFp5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyAlcOnJzmfzASmgtzD8YShFZnNf+3YpRDZZvlK08ds=;
	b=cntFjCh6DUk0ks2/g6l+QaD6WE/mvvs5reVdPtLwO1QX6W7UlWKOi4WpKKfHOr57ZSqIcq
	JdnpzcOe3/nYQiL+7Oa0+fjvm0m9bjT4vLn104bkWafBPsoH4FyjAujYcAgeD5RwjrXvj9
	wYCs+HRdd0MJ/mysTggR/cDBMnPFp5o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-aH7RqJJcN92veFWctk50sw-1; Mon,
 24 Aug 2026 10:44:33 -0400
X-MC-Unique: aH7RqJJcN92veFWctk50sw-1
X-Mimecast-MFC-AGG-ID: aH7RqJJcN92veFWctk50sw_1787582670
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEC0519775A6;
	Mon, 24 Aug 2026 14:44:29 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2AA230002ED;
	Mon, 24 Aug 2026 14:44:23 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 20/35] netfs: Add some functions to wrap the all-queued handling
Date: Mon, 24 Aug 2026 15:41:13 +0100
Message-ID: <20260824144130.759997-21-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Zdhz6H4F6LZHD9vZ63S7gbS38wfdhXB4jg0Q4WHMtYE_1787582670
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add some helper functions to wrap the handling of the NETFS_RREQ_ALL_QUEUED
flag and to insert the appropriate barriers.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c     |  9 +++------
 fs/netfs/direct_read.c       |  9 +++------
 fs/netfs/internal.h          | 19 +++++++++++++++++++
 fs/netfs/misc.c              |  2 +-
 fs/netfs/read_collect.c      |  4 +---
 fs/netfs/read_pgpriv2.c      |  3 +--
 fs/netfs/read_single.c       |  9 +++------
 fs/netfs/write_collect.c     |  3 +--
 fs/netfs/write_issue.c       |  7 ++-----
 include/trace/events/netfs.h |  1 +
 10 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 77f7dfc816a8..03e095060162 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -303,10 +303,8 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 		}
 		start += slice;
 		size -= slice;
-		if (size <= 0) {
-			smp_wmb(); /* Write lists before ALL_QUEUED. */
-			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
-		}
+		if (size <= 0)
+			netfs_all_subreqs_queued(rreq);
 
 		netfs_issue_read(rreq, subreq);
 		netfs_maybe_bulk_drop_ra_refs(rreq);
@@ -319,8 +317,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
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
index 09e86183b26b..df04ee82e34b 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -314,6 +314,25 @@ static inline bool netfs_check_subreq_in_progress(const struct netfs_io_subreque
 	return test_bit_acquire(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 }
 
+/*
+ * Indicate that we've generated and queued all the subrequests we're going to.
+ */
+static inline void netfs_all_subreqs_queued(struct netfs_io_request *rreq)
+{
+	smp_wmb(); /* Write lists before ALL_QUEUED. */
+	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
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
index 94e180ec6e41..f758ab0aaf5d 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -447,10 +447,8 @@ bool netfs_read_collection(struct netfs_io_request *rreq)
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
index 883843270699..aab156d00031 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -155,8 +155,7 @@ void netfs_pgpriv2_end_copy_to_cache(struct netfs_io_request *rreq)
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
index 6d0f72797351..4ed50ac7c1f8 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -518,8 +518,7 @@ static void netfs_end_issue_write(struct netfs_io_request *wreq)
 {
 	bool needs_poke = true;
 
-	smp_wmb(); /* Write subreq lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &wreq->flags);
+	netfs_all_subreqs_queued(wreq);
 
 	for (int s = 0; s < NR_IO_STREAMS; s++) {
 		struct netfs_io_stream *stream = &wreq->io_streams[s];
@@ -665,9 +664,7 @@ int netfs_writeback_single(struct address_space *mapping,
 		netfs_issue_write(wreq, stream);
 	}
 
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &wreq->flags);
-
+	netfs_all_subreqs_queued(wreq);
 	netfs_wake_collector(wreq);
 
 	/* TODO: Might want to be async here if WB_SYNC_NONE, but then need to
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 6439210d0705..1687b974900c 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -47,6 +47,7 @@
 	E_(NETFS_PGPRIV2_COPY_TO_CACHE,		"2C")
 
 #define netfs_rreq_traces					\
+	EM(netfs_rreq_trace_all_queued,		"ALL-Q  ")	\
 	EM(netfs_rreq_trace_assess,		"ASSESS ")	\
 	EM(netfs_rreq_trace_collect,		"COLLECT")	\
 	EM(netfs_rreq_trace_complete,		"COMPLET")	\


