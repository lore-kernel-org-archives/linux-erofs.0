Return-Path: <linux-erofs+bounces-4516-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1821CC79FAA
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Sep 2026 07:22:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfsgy3rYPz2ynZ;
	Wed, 09 Sep 2026 17:22:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788938526;
	cv=none; b=jjst2ikw2n43CODDrsM6bWf7gs8ZuYCXg+sT5+5HswG1qwGIcLUPLdKvMJTkpY4FfMPC+MdxZXQfet59cCGzKaR3btdjS+cNdMGL/7FXUIvV5/KTqfQaf7GNihq4SC643DzvJh6yWzeccFXlD1acV7srPTu6zmbXR0CZYLjctJbgjxwiwmMUPbIEjTINbhCQ5VLECQsP7jzutf7bUTRSO/HbFezTtwqwHvuoFHmCns8RC4CEgA3oYtw0x2rlhC8kg3bZdlxX7I4NdQKrIquehbDZJAw9CzeoELXpnAy/XZ8S/jFvEtmOC0q0LpKi3dCQHbBbUkV1TRtRoye+MjontQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788938526; c=relaxed/relaxed;
	bh=qqlNS8q69FtxFvuCMkUAvTzRLGn3SbS5MM4c4KSMrN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cIGc4lRw68N0pCxFzNotB8J7cu/zFwJpWVZYU8N73SsLCzoWzNyNCbGhbP7dBsYV2ylpqH7K6TqIXHpzvJccQsYxTIctfjBIZxeJ7nheXLEZ1JA2sWwFO+5eUu/lHJl+6OT1kljilXaxqO3JPqXvKWNNbINsUVQrWvg8WAqHT8LzKswvZ4x2uVwBUIexZGvybaGaVSbqm5Ns78yqS/Az0y+znhPaHDYNdpjENTb69/B2IzJpJCagOWHj//dVLcYQS9LFL1Iybkot1POAYSgMZfIxwHdhpvM6YqKgU7W+uPsFz1fwTAtptH02Yu63FoYdsa1N82SHOha9LqNvOp++bQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GHajuMvL; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UcjkihAr; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GHajuMvL;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UcjkihAr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfsgx3Smsz2y2J
	for <linux-erofs@lists.ozlabs.org>; Wed, 09 Sep 2026 17:22:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788938521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qqlNS8q69FtxFvuCMkUAvTzRLGn3SbS5MM4c4KSMrN8=;
	b=GHajuMvLfgNThiOWmjGxwZLM1axgGBdFdhq0zkbhFz9uODpGCVlCxNSH5jGAXmbiaZw7xn
	T7woxsRZNSRygfLQ0odlVDATe3739irXerv8w0o4xiX1ZBl3P8L1gDHo7qMhVIsqgsLrsw
	GCKewgOcrPp7NCFeeZaNMBBJKoKQ1HU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788938522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qqlNS8q69FtxFvuCMkUAvTzRLGn3SbS5MM4c4KSMrN8=;
	b=UcjkihArbXay4ccrTFJs1/PxuEC1ULs2llFWcRAeczUrcDo2nDPGSbd6p/Qrcfbqwxbg0F
	XTBDCzaBx6AC7saNIZvki62FX2oshZCCdJdknGlU8ZlpRkcGzn8/l5jjiwfdRFJ/57NqAY
	s9hAJDA2C7OnbIQPDUzlSN9q6x2PW7Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-eG-8yY5dO2m2xFl11_c_TA-1; Wed,
 09 Sep 2026 03:21:57 -0400
X-MC-Unique: eG-8yY5dO2m2xFl11_c_TA-1
X-Mimecast-MFC-AGG-ID: eG-8yY5dO2m2xFl11_c_TA_1788938515
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DABA2195609D;
	Wed,  9 Sep 2026 07:21:54 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 60869195608E;
	Wed,  9 Sep 2026 07:21:49 +0000 (UTC)
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
Subject: [PATCH v13 4/8] netfs: trace: Rejig a couple of the tracepoints
Date: Wed,  9 Sep 2026 08:20:58 +0100
Message-ID: <20260909072105.1663687-5-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Ww3YfSXZezVyUYHAFtpbnIjxl5KzYaSwZkZZA2RAI0s_1788938515
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Rejig the following tracepoints:

 (1) Change netfs_folio to show the pfn.

 (2) Change netfs_collect_folio to show a folio index range rather than
     file position range and don't show the cleaned_to or collected_to
     points.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
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
index 6114bdf27ce0..7194182b975c 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -156,7 +156,7 @@ static void netfs_writeback_unlock_folios(struct netfs_io_request *wreq,
 
 		fend = min_t(uoff_t, fpos + flen, wreq->i_size);
 
-		trace_netfs_collect_folio(wreq, folio, fend, collected_to);
+		trace_netfs_collect_folio(wreq, folio);
 
 		/* Unlock any folio we've transferred all of. */
 		if (collected_to < fend)
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 2491a0bc4179..21a661cd1ca4 100644
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


