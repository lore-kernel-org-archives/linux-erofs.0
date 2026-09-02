Return-Path: <linux-erofs+bounces-4442-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECE0C624D3
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 17:36:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZqf33sS6z2xlv;
	Thu, 03 Sep 2026 03:36:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788370587;
	cv=none; b=j8OCH+ORAskZ0e0HvT06JpgFZC4obpCCM43UI9z7KuBvoAAWTK5cwzRtdalKeY0Hh/hLiMJfts13w0oJN8vFB/jMv05qj4/IvsSih0m2AGNY8a1v0JQQR8cod75GnEWPJlDJyqvIzX9JIw4d3rj2UcIkbB7+f6lGKSQzjES+KaT57iUeJS8RNFIHLXAnLLPceIpcmFcpRAc9v+eUTxbRJL0kDnQ+V66r1+AU21Fi0ipXYz4dTOJOmQ+nz7vITx83NWz2IKkRLipJyvvQkq94icyHrX08oc1Yu5thw223HMNBf7ed03XsI4WNM5g/E2tmFqhP+i2Cn9NwRgQHOnJmDg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788370587; c=relaxed/relaxed;
	bh=aJrAdA0TGp7O7440CD9gCdpQeZaF/fjPNzjd2iWORZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=InlPF9G/6MJbNfUPu8KFUH5JhrJH6YN7eEeBADlaxHtX/I38xYz2EmUu31Vd9Sj3MzZzio8M01TLgg/nKlKul+pPkGzyEt9thMtxsqFZlP1XhucHqQKLM2M35xlNQhSCbTPC3Xkv5XVP3MtRJ/quCGxzkDFqeZpcU97TrQ9DYEqK/e98WxkfYtP97TVPEi14Wtwp159f2nJGy/SgYIN119/sWIN3wKMorb7Yipa2EuH0W/YGJFvxPnwXXVbHcKdKwZLy7KaPncSE3TAAadhPRw+1Fh4l32V5Kt6gzGnuaep0wVmIdAxbR+giqt+/nZ2F3jlABbHpWd4lcq2BYcJsSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=byZ+F1im; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Qe50YAPO; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=byZ+F1im;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Qe50YAPO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZqf23WHHz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 03:36:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJrAdA0TGp7O7440CD9gCdpQeZaF/fjPNzjd2iWORZQ=;
	b=byZ+F1imlk1f7kuAxjm0s/M0/b0mt4MnnAnF09FfLnOeRGXZBRzmqtQwENFg+BK4Y/7AF6
	r+bzomh3nikQrAyh4bY+scD7cKYDmCplyRE78JvLrVUNMB+u4NTxYiGr4lx61UpEhH9XOf
	1bzFunz1E6LX2rYDzwjbCdKbHvlaWno=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJrAdA0TGp7O7440CD9gCdpQeZaF/fjPNzjd2iWORZQ=;
	b=Qe50YAPO4CQjt7rhQIGenlaJcDEvaERcDkWFZgNqX/x6M5DL3UPqlNqEZpiFphgXQmmUe6
	OsUfRHNtILBZf7+yhFOWS99+BsbIox3hP73FdsvV1Blfj0LZjXcwdseHuF3IxHfAGQxYLm
	sYTeHfHD0IAwX8aEl1iPbb/GUZEXM28=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435--F0jxgTBME6-GNhNuUz5Dg-1; Wed,
 02 Sep 2026 13:36:17 -0400
X-MC-Unique: -F0jxgTBME6-GNhNuUz5Dg-1
X-Mimecast-MFC-AGG-ID: -F0jxgTBME6-GNhNuUz5Dg_1788370574
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88AD21829E21;
	Wed,  2 Sep 2026 17:36:14 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7528726C;
	Wed,  2 Sep 2026 17:36:08 +0000 (UTC)
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
Subject: [PATCH v11 16/36] netfs: trace: Rejig a couple of the tracepoints
Date: Wed,  2 Sep 2026 18:33:28 +0100
Message-ID: <20260902173350.3468672-17-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: SA3AIDrNnr386q2KkxNgUAcjogxSgQazkxgDQmn4dz0_1788370574
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Rejig the following tracepoints:

 (1) Change netfs_folio to show the pfn.

 (2) Change netfs_collect_folio to show a folio index range rather than
     file position range and don't show the cleaned_to or collected_to
     points.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_collect.c      |  2 +-
 fs/netfs/read_pgpriv2.c      |  2 +-
 fs/netfs/write_collect.c     |  2 +-
 include/trace/events/netfs.h | 23 ++++++++++-------------
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 6576a9b8671d..61f2664de6d3 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -192,7 +192,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		fpos = folio_pos(folio);
 		fend = fpos + fsize;
 
-		trace_netfs_collect_folio(rreq, folio, fend, collected_to);
+		trace_netfs_collect_folio(rreq, folio);
 
 		/* Unlock any folio we've transferred all of. */
 		if (collected_to < fend)
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index 4d50585f69a6..bf4d9d6877d7 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -201,7 +201,7 @@ bool netfs_pgpriv2_unlock_copied_folios(struct netfs_io_request *creq)
 
 		fend = min_t(uoff_t, fpos + flen, creq->i_size);
 
-		trace_netfs_collect_folio(creq, folio, fend, collected_to);
+		trace_netfs_collect_folio(creq, folio);
 
 		/* Unlock any folio we've transferred all of. */
 		if (collected_to < fend)
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index ba2327ce96e8..e01233de41f5 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -207,7 +207,7 @@ static void netfs_writeback_unlock_folios(struct netfs_io_request *wreq,
 
 		fend = min_t(uoff_t, fpos + flen, wreq->i_size);
 
-		trace_netfs_collect_folio(wreq, folio, fend, collected_to);
+		trace_netfs_collect_folio(wreq, folio);
 
 		/* Unlock any folio we've transferred all of. */
 		if (collected_to < fend)
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index f69cac698f74..b18952627f16 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -497,6 +497,7 @@ TRACE_EVENT(netfs_folio,
 	    TP_STRUCT__entry(
 		    __field(u64,			ino)
 		    __field(pgoff_t,			index)
+		    __field(unsigned long,		pfn)
 		    __field(unsigned int,		nr)
 		    __field(enum netfs_folio_trace,	why)
 			     ),
@@ -507,9 +508,11 @@ TRACE_EVENT(netfs_folio,
 		    __entry->why = why;
 		    __entry->index = folio->index;
 		    __entry->nr = folio_nr_pages(folio);
+		    __entry->pfn = folio_pfn(folio);
 			   ),
 
-	    TP_printk("i=%05llx ix=%05lx-%05lx %s",
+	    TP_printk("p=%lx i=%05llx ix=%05lx-%05lx %s",
+		      __entry->pfn,
 		      __entry->ino, __entry->index, __entry->index + __entry->nr - 1,
 		      __print_symbolic(__entry->why, netfs_folio_traces))
 	    );
@@ -656,31 +659,25 @@ TRACE_EVENT(netfs_collect_sreq,
 
 TRACE_EVENT(netfs_collect_folio,
 	    TP_PROTO(const struct netfs_io_request *wreq,
-		     const struct folio *folio,
-		     uoff_t fend, uoff_t collected_to),
+		     const struct folio *folio),
 
-	    TP_ARGS(wreq, folio, fend, collected_to),
+	    TP_ARGS(wreq, folio),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	wreq)
 		    __field(unsigned long,	index)
-		    __field(uoff_t,		fend)
-		    __field(uoff_t,		cleaned_to)
-		    __field(uoff_t,		collected_to)
+		    __field(unsigned int,	nr)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->wreq	= wreq->debug_id;
 		    __entry->index	= folio->index;
-		    __entry->fend	= fend;
-		    __entry->cleaned_to	= wreq->cleaned_to;
-		    __entry->collected_to = collected_to;
+		    __entry->nr		= folio_nr_pages(folio);
 			   ),
 
-	    TP_printk("R=%08x ix=%05lx r=%llx-%llx t=%llx/%llx",
+	    TP_printk("R=%08x ix=%05lx-%05lx",
 		      __entry->wreq, __entry->index,
-		      (uoff_t)__entry->index * PAGE_SIZE, __entry->fend,
-		      __entry->cleaned_to, __entry->collected_to)
+		      __entry->index + __entry->nr - 1)
 	    );
 
 TRACE_EVENT(netfs_collect_state,


