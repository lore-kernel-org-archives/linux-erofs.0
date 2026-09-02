Return-Path: <linux-erofs+bounces-4459-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4AEC61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 17:38:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZqhb1zvrz2yDD;
	Thu, 03 Sep 2026 03:38:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788370719;
	cv=none; b=oc/LIY3h2ZNnq73/46NXTA26Nz/TQ/Xr1kSt6Jd/5DG1BR9g/Y1Lb9RHLj/LJ3N79rxSwCmWM6jjYa1+6vLdH2P7jEAveuiQxeCMYz67TqN5K4zH11mRrMfdPqk/gzqm7xRBgwJSN/CelLNvO8iZqfX931MUMZeNyl8CW00xWb5t15AbAjHVKuDD1E0XngKmCZlCtSgEEBpmN/pcspDqNstYfAQ1QyjlQ7SMMqrxyyAzvVGuqfzPRzr7IQDfsObjJyatjqss2o1pBtBtsuGUGHDvyjVvU4FnNYr+1lpNTmMqXl9YNfuXlguJb1Mx+j0IqmdVuGMB5wTOWu4HYe4RRA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788370719; c=relaxed/relaxed;
	bh=x4GiOpymXcCnOnlIQLz3VcFoY9LdDvbwT8O6R33lWtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=I0tiph11EOUFJTVQJ3lcBzfwc5mfFKvTMflbt44xkSBdlnLyXlzyiVzQeGkkePXvEQ0N44Hcl9Uc1Ne5aBsRbq1eWjXXk/FxDlm3+jJIE+UuBeqX/sySBIC96pPaQL7N75caDwWPNigG/DiHivGpmINfB+Htm6ixOkQEjBzYYubRLewBYATLnx2hnjz6eVUb/iyGfhw8mWLLg91b6vL1DtBzBCjwsf2Ym1GucnoePMOOKCocGG/7G27nbf6fCzlx1rcbzTMhDPhqhk9K83FzSgwgXxGjeGNAU/4q8jIaYClPqP59/Xz/xt+iqqEqNN9G8NXenP7lq4gbnHsTRu9fDA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hHo9Oo/L; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hHo9Oo/L; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hHo9Oo/L;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hHo9Oo/L;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZqhZ1f4Gz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 03:38:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x4GiOpymXcCnOnlIQLz3VcFoY9LdDvbwT8O6R33lWtY=;
	b=hHo9Oo/LI52JyO1TJJSqBdTK7pgJ9MRQn8ufk/GcoSYdWddP+b6278gPDRR9yAfxsyQDZo
	GSBUj8EKOk5WKPzoUMGhvn51WpTsyVZy7zOW6JgdnKts6rQchZx49Sbqse9u5YCnJ523ba
	FEd2SOXyXyjkSMww8vxf10W0zbR4vFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x4GiOpymXcCnOnlIQLz3VcFoY9LdDvbwT8O6R33lWtY=;
	b=hHo9Oo/LI52JyO1TJJSqBdTK7pgJ9MRQn8ufk/GcoSYdWddP+b6278gPDRR9yAfxsyQDZo
	GSBUj8EKOk5WKPzoUMGhvn51WpTsyVZy7zOW6JgdnKts6rQchZx49Sbqse9u5YCnJ523ba
	FEd2SOXyXyjkSMww8vxf10W0zbR4vFI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-lJivZFv0PeqF6oApKchmvw-1; Wed,
 02 Sep 2026 13:38:30 -0400
X-MC-Unique: lJivZFv0PeqF6oApKchmvw-1
X-Mimecast-MFC-AGG-ID: lJivZFv0PeqF6oApKchmvw_1788370707
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AB5A195604B;
	Wed,  2 Sep 2026 17:38:27 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE4421800765;
	Wed,  2 Sep 2026 17:38:20 +0000 (UTC)
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
Subject: [PATCH v11 33/36] netfs: Set subrequest->source at alloc before trace emission
Date: Wed,  2 Sep 2026 18:33:45 +0100
Message-ID: <20260902173350.3468672-34-dhowells@redhat.com>
In-Reply-To: <20260902173350.3468672-1-dhowells@redhat.com>
References: <20260902173350.3468672-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: FtCI8Fl_4icI9AHE2LTKW9I4NfLY1AaX-C0jJOo_NyA_1788370707
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Set subrequest->source in netfs_alloc_subrequest() before we emit the trace
line indicating we allocated the subrequest.  Note that this requires the
allocation of the subreq in netfs_read_to_pagecache() to be pushed to after
the decision about what sort of subreq it should be.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/netfs/buffered_read.c | 69 ++++++++++++++++++++--------------------
 fs/netfs/direct_read.c   |  3 +-
 fs/netfs/internal.h      |  3 +-
 fs/netfs/objects.c       |  4 ++-
 fs/netfs/read_retry.c    |  3 +-
 fs/netfs/read_single.c   |  2 +-
 fs/netfs/write_issue.c   |  6 ++--
 fs/netfs/write_retry.c   |  3 +-
 8 files changed, 45 insertions(+), 48 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 94bf9a2c2321..5178d9bba453 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -295,8 +295,11 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 	do {
 		int (*prepare_read)(struct netfs_io_subrequest *subreq) = NULL;
 		struct netfs_io_subrequest *subreq;
+		enum netfs_io_source source;
 		ssize_t slice;
 		uoff_t hole_to, cache_to;
+		size_t len = size;
+		bool copy = false;
 
 		/* If we don't have any, find out the next couple of data
 		 * extents from the cache, containing of following the
@@ -327,48 +330,34 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 			continue;
 		}
 
-		subreq = netfs_alloc_subrequest(rreq);
-		if (!subreq) {
-			ret = -ENOMEM;
-			break;
-		}
-
-		subreq->start	= start;
-		subreq->len	= size;
-
-		netfs_queue_read(rreq, subreq);
-
 		uoff_t zero_point = netfs_read_zero_point(rreq->inode);
 		uoff_t zlimit = umin(zero_point, rreq->i_size);
 
-		_debug("rsub %llx %llx-%llx", subreq->start, hole_to, cache_to);
+		_debug("rsub %llx %llx-%llx", start, hole_to, cache_to);
 
 		if (start >= hole_to && start < cache_to) {
 			/* Overlap with a cached region, where the cache may
 			 * record a block of zeroes.
 			 */
 			_debug("cached s=%llx c=%llx l=%zx", start, cache_to, size);
-			subreq->len = umin(cache_to - start, size);
-			subreq->len = round_up(subreq->len, occ->granularity);
+			len = umin(cache_to - start, size);
+			len = round_up(len, occ->granularity);
 			if (occ->cached_type[0] == FSCACHE_EXTENT_ZERO) {
-				subreq->source = NETFS_FILL_WITH_ZEROES;
+				source = NETFS_FILL_WITH_ZEROES;
 				netfs_stat(&netfs_n_rh_zero);
 			} else {
-				subreq->source = NETFS_READ_FROM_CACHE;
+				source = NETFS_READ_FROM_CACHE;
 				prepare_read = rreq->cache_resources.ops->prepare_read;
 			}
-
-			trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
-
-		} else if (subreq->start >= zlimit && size > 0) {
+		} else if (start >= zlimit && size > 0) {
 			/* If this range lies beyond the zero-point, that part
 			 * can just be cleared locally.
 			 */
 			_debug("zero %llx-%llx", start, start + size);
-			subreq->len = size;
-			subreq->source = NETFS_FILL_WITH_ZEROES;
+			len = size;
+			source = NETFS_FILL_WITH_ZEROES;
 			if (rreq->cache_resources.ops)
-				__set_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
+				copy = true;
 			netfs_stat(&netfs_n_rh_zero);
 		} else {
 			/* Read a cache hole from the server.  If any part of
@@ -379,22 +368,33 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 
 			_debug("limit %llx %llx", rreq->i_size, zero_point);
 			_debug("download %llx-%llx", start, start + size);
-			subreq->len = umin(limit - subreq->start, ULONG_MAX);
-			subreq->source = NETFS_DOWNLOAD_FROM_SERVER;
+			len = umin(limit - start, ULONG_MAX);
+			source = NETFS_DOWNLOAD_FROM_SERVER;
 			if (rreq->cache_resources.ops)
-				__set_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
+				copy = true;
 			netfs_stat(&netfs_n_rh_download);
 		}
 
-		if (size == 0) {
-			pr_err("ZERO-LEN READ: R=%08x[%x] l=%zx/%zx s=%llx z=%llx i=%llx",
-			       rreq->debug_id, subreq->debug_index,
-			       subreq->len, size,
-			       subreq->start, zero_point, rreq->i_size);
-			netfs_cancel_read(subreq, ret);
+		if (len == 0) {
+			pr_err("ZERO-LEN READ: R=%08x l=%zx/%zx s=%llx z=%llx i=%llx",
+			       rreq->debug_id, len, size,
+			       start, zero_point, rreq->i_size);
+			break;
+		}
+
+		subreq = netfs_alloc_subrequest(rreq, source);
+		if (!subreq) {
+			ret = -ENOMEM;
 			break;
 		}
 
+		subreq->start	= start;
+		subreq->len	= size;
+		if (copy)
+			__set_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
+
+		netfs_queue_read(rreq, subreq);
+
 		rreq->io_streams[0].sreq_max_len = MAX_RW_COUNT;
 		rreq->io_streams[0].sreq_max_segs = INT_MAX;
 
@@ -418,10 +418,9 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq)
 		if (size <= 0)
 			netfs_all_subreqs_queued(rreq);
 
+		/* See if the cache indicated this should be cached. */
 		if (mark_cursor.bvecq) {
-			/* See if the cache indicated this should be cached. */
-			bool copy = test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
-
+			copy = test_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
 			netfs_mark_copy_to_cache(rreq, &mark_cursor, slice, copy);
 		}
 
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index 058cc6bb7124..40407bf9aa3f 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -33,7 +33,7 @@ static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 	do {
 		struct netfs_io_subrequest *subreq;
 
-		subreq = netfs_alloc_subrequest(rreq);
+		subreq = netfs_alloc_subrequest(rreq, NETFS_DOWNLOAD_FROM_SERVER);
 		if (!subreq) {
 			/* Stash the error in the request if there's not
 			 * already an error set.
@@ -42,7 +42,6 @@ static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 			break;
 		}
 
-		subreq->source	= NETFS_DOWNLOAD_FROM_SERVER;
 		subreq->start	= start;
 		subreq->len	= size;
 
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index bdf0f1ddcfec..e1e051ef60b4 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -93,7 +93,8 @@ void netfs_get_request(struct netfs_io_request *rreq, enum netfs_rreq_ref_trace
 void netfs_clear_subrequests(struct netfs_io_request *rreq);
 void netfs_put_request(struct netfs_io_request *rreq, enum netfs_rreq_ref_trace what);
 void netfs_put_failed_request(struct netfs_io_request *rreq);
-struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq);
+struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq,
+						   enum netfs_io_source source);
 
 static inline void netfs_see_request(struct netfs_io_request *rreq,
 				     enum netfs_rreq_ref_trace what)
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 6852fa27eeb3..64fbb6e6c445 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -213,7 +213,8 @@ void netfs_put_failed_request(struct netfs_io_request *rreq)
 /*
  * Allocate and partially initialise an I/O request structure.
  */
-struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq)
+struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq,
+						   enum netfs_io_source source)
 {
 	struct netfs_io_subrequest *subreq;
 	mempool_t *mempool = rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool;
@@ -230,6 +231,7 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
 	INIT_WORK(&subreq->work, NULL);
 	INIT_LIST_HEAD(&subreq->rreq_link);
 	refcount_set(&subreq->ref, 2);
+	subreq->source = source;
 	subreq->rreq = rreq;
 	subreq->debug_index = atomic_inc_return(&rreq->subreq_counter);
 	netfs_get_request(rreq, netfs_rreq_trace_get_subreq);
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index 9dc531659259..08b0bf526759 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -210,12 +210,11 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 		 * and insert them after.
 		 */
 		do {
-			subreq = netfs_alloc_subrequest(rreq);
+			subreq = netfs_alloc_subrequest(rreq, NETFS_DOWNLOAD_FROM_SERVER);
 			if (!subreq) {
 				subreq = to;
 				goto abandon_after;
 			}
-			subreq->source		= NETFS_DOWNLOAD_FROM_SERVER;
 			subreq->start		= start;
 			subreq->len		= len;
 			subreq->stream_nr	= stream->stream_nr;
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index 9fd07dbb08b5..46dc22c3859b 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -86,7 +86,7 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 	struct netfs_io_subrequest *subreq;
 	int ret = 0;
 
-	subreq = netfs_alloc_subrequest(rreq);
+	subreq = netfs_alloc_subrequest(rreq, NETFS_DOWNLOAD_FROM_SERVER);
 	if (!subreq)
 		return -ENOMEM;
 
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index a12846a66a3c..08bc84182847 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -193,11 +193,10 @@ struct netfs_io_subrequest *netfs_alloc_write_subreq(struct netfs_io_request *wr
 {
 	struct netfs_io_subrequest *subreq;
 
-	subreq = netfs_alloc_subrequest(wreq);
+	subreq = netfs_alloc_subrequest(wreq, stream->source);
 	if (!subreq)
 		return subreq;
 
-	subreq->source		= stream->source;
 	subreq->start		= stream->issue_from;
 	subreq->len		= stream->buffered;
 	subreq->stream_nr	= stream->stream_nr;
@@ -245,10 +244,9 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
 {
 	struct netfs_io_subrequest *subreq;
 
-	subreq = netfs_alloc_subrequest(wreq);
+	subreq = netfs_alloc_subrequest(wreq, stream->source);
 	if (!subreq)
 		return;
-	subreq->source		= stream->source;
 	subreq->start		= start;
 	subreq->stream_nr	= stream->stream_nr;
 
diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index c61bed687244..7fa09e190203 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -158,8 +158,7 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 		 * and insert them after.
 		 */
 		do {
-			subreq = netfs_alloc_subrequest(wreq);
-			subreq->source		= to->source;
+			subreq = netfs_alloc_subrequest(wreq, stream->source);
 			subreq->start		= start;
 			subreq->stream_nr	= to->stream_nr;
 			subreq->retry_count	= 1;


