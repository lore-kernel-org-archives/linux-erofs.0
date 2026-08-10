Return-Path: <linux-erofs+bounces-4179-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EA7C5AE49
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 14:51:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJd4974Syz3024;
	Tue, 11 Aug 2026 00:51:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786373481;
	cv=none; b=nMeWY6CnGOhKcWhaFG1MbFEnx2+3r+618D82pZfaA2wxCUaAnQi7KQ3eXQDF+wArEYV8V4Z7n3xjKsZRJuowwIogi13fEyCNac5Bno4OoCDd9MF3WubwNB44i4Sd6M7sFK61eI8qrQtMXdzuB0pfx9yt/PnGEhkJ+pZTznq//kveW3yegvrn/YzvZ+oUmVSMJqeeDlMt8pSvWGAFUrylUrg52sEjqvMVh1/zzj2facHPfWdAqZtCL2ROxdQHlF7HBQUC0wfHT81kiDyqfHhHlndFmwVMVrQiO46vJ3oWxws4Aq/TsSms28SvesfMYKd1da3E868U8O46UfLle4qEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786373481; c=relaxed/relaxed;
	bh=WpRWdWQ2o2csTkSLqj2j6GymBuhovuv+4XkP7R//hNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=g+pwR8SRDODVfx52l0Y23mEk6PydtnsWeJRoN+nl6hlCVwWF+UrpEwXmnxpEjnQiuhQ0mKoqaw9hrLNINko09vLqxyB/ajTnco6e2+eEeQ8t39TNPTyEi7rCkB+3pl7J61YdBgS9OWq3DPLKYLWmGXBvwNV5xPLi4tojoOVJuz/FvrnPMyaDzxTOb9cMQ+qwSl91BlbeJD122rGrIa/0jpIdEYetjVQ0Mlvg0y6zp/Ax7ek2ATc/D7IQuDmK3Txw3Wd6Ir7UOnkwO4ZMS2Xru5kaYbjNYqpdxA1VIdoHxaDHrmrTqaOktyGrqRx0F3jd1SiQrZlsn/ClIB7NY3Q3tQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Df9QZOPC; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gv2L+sHb; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Df9QZOPC;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gv2L+sHb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJd4911Tkz2ytv
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 00:51:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WpRWdWQ2o2csTkSLqj2j6GymBuhovuv+4XkP7R//hNk=;
	b=Df9QZOPCnCVV9O/NBK68iqC62cJsyEaZzETeif9Desiz/xu/JNNs8+kHEKI/iECICm3k+8
	ltBNF12vdgEy3jiXrRXSXTPvyQ+MArkKMclodOqS9hrAJGWPYntTkIk6l/RV4ZyatkCxY+
	xg0xemMPzdOWhEdECI2cuNVUqcMD6ao=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WpRWdWQ2o2csTkSLqj2j6GymBuhovuv+4XkP7R//hNk=;
	b=Gv2L+sHbXO8ttbqnes4kcn6yj8/su2SftTGkhuBhGwwhtF7YzRAcDu88OszmbwRznMU+us
	xz7KHB8kYDYhF8wAh/88FlBhvSv/8eS5yxgyADpZqcfM9yD3Jv4f08QUEcpgHFYoWWCp9s
	+c1nAfKSwzHy4uzHhqGXQxPl1Y7D5vo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-BOOmvZM4Oo-IXxWzXkFNKQ-1; Mon,
 10 Aug 2026 10:51:12 -0400
X-MC-Unique: BOOmvZM4Oo-IXxWzXkFNKQ-1
X-Mimecast-MFC-AGG-ID: BOOmvZM4Oo-IXxWzXkFNKQ_1786373469
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCCB618001E3;
	Mon, 10 Aug 2026 14:51:09 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 14659426;
	Mon, 10 Aug 2026 14:51:03 +0000 (UTC)
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
Subject: [PATCH v9 24/26] netfs: Check for too much data being read
Date: Mon, 10 Aug 2026 15:47:41 +0100
Message-ID: <20260810144746.574036-25-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: zu53nfZSbB70dd7n2-DCqDNxP5x3QZTg8xMgELmz_Wo_1786373469
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
 fs/netfs/read_collect.c      | 23 +++++++++++++++++++++++
 include/trace/events/netfs.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index cf7c36037edc..21eb7f74d66e 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -307,6 +307,14 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			notes |= HIT_PENDING;
 
 		transferred = READ_ONCE(front->transferred);
+		if (unlikely(transferred > front->len)) {
+			/* Ugh...  A subreq overran its allotted length.  It
+			 * may have corrupted the read buffer.
+			 */
+			stream->error = -EIO;
+			stream->failed = true;
+			goto abandon_request;
+		}
 
 		/* If we can collect the next folio from a pending op, do so,
 		 * but we should only do it if we don't otherwise need to wait
@@ -627,6 +635,21 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
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


