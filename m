Return-Path: <linux-erofs+bounces-4317-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F681C5DF94
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDFr2zZmz2yCr;
	Tue, 25 Aug 2026 00:44:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582672;
	cv=none; b=e7FGTNFmdfd+5G/x957+r/Vb1h3Sdzh6Lje5URmCPSxjTbtf7TPmuTKUQeuD23dqDEZGHm021v/OMmLKz6DKXhYYyVO+17K38WH3ZgAV3hzGCjZOLD41q+gp2Uu8kzGo5OtgD8vavMqwZ+B0mZxeJgZtdYbp91TWfOI8KT9OcndFV+5vkGxVnRs41twGA7DulqHNlxGkHY/hlXfLS3r1hlK3B6yjteTxWKwrJ/EdI4ubuANsjMK/40Wnn93qpQ2fQqlX0RYwmq9J7bW7nNsiOL8bsHF6aM2RaAiaGyTfS3Wwz+pTH2eWUynUcYCjYYALq8SDVgXFmnrZXEQuqfFYXA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582672; c=relaxed/relaxed;
	bh=na3Caw1f/gh59s0Uf9hdmse2XsohuJJX+14MfsyaNfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=C3e4IXzAQ4C7hrwAn0vUEuJNzrJy9Jyp1Ko/jBYRP+YAT7VkPSRtECL7f9+sav1tjjx0I8aaZPIyymx+q2SUpR5BY94fnMe++VuLYG0od1aI4OSSA254cesZbkcuz1en6DiugpfxhepKyIrfB+cazsrQm5ag9Xv+t9xd1R/W4LTXaNws9XzHTisx5Dh9W9Y/Gr1pWWx1CFjF2NW1Y1w3SEuRkQt7eS1NKEdTa1BsFHIEqBmTIL9D1zVsW4KpVZymfn0ZDJUOXKkAJ216fygRzeAJ6FVE73Vx48k/QvesMiZCWnViPauEPhQSrnsBnZniUirW9zsj6lCTw5s843Y0iw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OdEj96q4; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OdEj96q4; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OdEj96q4;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OdEj96q4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDFq3q1Bz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:44:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na3Caw1f/gh59s0Uf9hdmse2XsohuJJX+14MfsyaNfA=;
	b=OdEj96q4qtmeQBvhuITN4Yp4VWPEGNf4/S8/bpZ6vlsHnEGfOymJXSOp/3aQ0Fae1Egqdx
	Y3dQKYXvQmpyGfrMI6+bDNQuKoDMub8VlJSn2IOd4ATJUzW5y2ZdytlM7px0E+Ul7JKg6c
	iNis25h6+tF47fr70U9YmeJzMJN+1vo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na3Caw1f/gh59s0Uf9hdmse2XsohuJJX+14MfsyaNfA=;
	b=OdEj96q4qtmeQBvhuITN4Yp4VWPEGNf4/S8/bpZ6vlsHnEGfOymJXSOp/3aQ0Fae1Egqdx
	Y3dQKYXvQmpyGfrMI6+bDNQuKoDMub8VlJSn2IOd4ATJUzW5y2ZdytlM7px0E+Ul7JKg6c
	iNis25h6+tF47fr70U9YmeJzMJN+1vo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-MI7FYOHcNm2fc5zylT1LyA-1; Mon,
 24 Aug 2026 10:44:26 -0400
X-MC-Unique: MI7FYOHcNm2fc5zylT1LyA-1
X-Mimecast-MFC-AGG-ID: MI7FYOHcNm2fc5zylT1LyA_1787582662
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39FD5186057F;
	Mon, 24 Aug 2026 14:44:22 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24E081800348;
	Mon, 24 Aug 2026 14:44:15 +0000 (UTC)
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
Subject: [PATCH v10 19/35] netfs: trace: Rejig a couple of the tracepoints
Date: Mon, 24 Aug 2026 15:41:12 +0100
Message-ID: <20260824144130.759997-20-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: HEaihZPDtBLJSxe5p667-OXVisdlXKeUSR8AJwN9Zt8_1787582662
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
index 72afc17ecbb3..94e180ec6e41 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -172,7 +172,7 @@ static void netfs_read_unlock_folios(struct netfs_io_request *rreq,
 		fpos = folio_pos(folio);
 		fend = fpos + fsize;
 
-		trace_netfs_collect_folio(rreq, folio, fend, collected_to);
+		trace_netfs_collect_folio(rreq, folio);
 
 		/* Unlock any folio we've transferred all of. */
 		if (collected_to < fend)
diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index ac16bb8210d1..883843270699 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -198,7 +198,7 @@ bool netfs_pgpriv2_unlock_copied_folios(struct netfs_io_request *creq)
 
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
index e23300c56d00..6439210d0705 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -495,6 +495,7 @@ TRACE_EVENT(netfs_folio,
 	    TP_STRUCT__entry(
 		    __field(u64,			ino)
 		    __field(pgoff_t,			index)
+		    __field(unsigned long,		pfn)
 		    __field(unsigned int,		nr)
 		    __field(enum netfs_folio_trace,	why)
 			     ),
@@ -505,9 +506,11 @@ TRACE_EVENT(netfs_folio,
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
@@ -654,31 +657,25 @@ TRACE_EVENT(netfs_collect_sreq,
 
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


