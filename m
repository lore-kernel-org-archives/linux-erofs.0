Return-Path: <linux-erofs+bounces-4461-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D100EC624D6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 17:38:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZqhs2sDLz2yYY;
	Thu, 03 Sep 2026 03:38:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788370733;
	cv=none; b=V9UCSVnqcFsuX///iBkmXpdszGcxEfZSXXWdXnvzuSAVhLba5ujzq4d5TRqDWysDaMmuLHaUemNpB2hqcgZ7jQ/1S//gfWSOM2iFtA+T/qvVI+zP4g8QgZzOJ2oga0MK0CCceuA05yyQW2RsFIi8/absp9gRQYIkj/NDUUB4uyPdfMv7sZNdWdW7EEgzGYkOQNgbWpW+aYLAomjc8X0sd3mUETr1S6BIQMU83bpfgYMMsPzb6qxjhfZV1nGCtdVCtlaTllHRqkYa2ChW0mNy/muRExm+bkrwve79T3Pk4IF3f7HNjZU0GBKfa/228anQcd4TsxNK4NzlIZLW/bp0eA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788370733; c=relaxed/relaxed;
	bh=xAQPSKbHDhhjvJMfHbAflRtuKuinLcohh3Mkhwc1Shc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UQbj7DrcOnojfgQYUeetwuSBIEsrffyh9KmWWZcpnWM5/cvSqn8ezNwNljR/KvHV69wf5hnoDaEI8eOlMCtkDBtjO/cOXeD/601K6nQBqujgNUC7yup70QLr3GR0AGOxwnthCT7QLLUfVLuzIl28ZsHBZYEAYetO067QgaWdnlw4Pz4z5XqfxJCVV6frMW8zOPiNYATyUoRMETMjPu0TxLQwBmLOE/hKW22HUmTclNvpHQifTJFt9TD93eCFYjh75P5QzyfoATnOyL6aygwlpgAyY2GDXpLIkdQG94Y8FTW86dB079ouSgNKrdh/foN/4fRQUnFRtCtEmG2q58ug5Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ICAGimlK; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ICAGimlK; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ICAGimlK;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ICAGimlK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZqhr2q0Rz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 03:38:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xAQPSKbHDhhjvJMfHbAflRtuKuinLcohh3Mkhwc1Shc=;
	b=ICAGimlKkNHGknyiO7X3Db6DwOHLLU/ToiuX/mHVfn/K8gXhPg+ka2+V+KfYek35eA4os0
	AYiIiiKjOR9hkklTYoMFoeIk7RqbyKi4gkJTb74Zm5Cu2CQb5A5Lx8CP9WQqcKxBKw868l
	/HTXstL94iU1tXZtc21F5HVEkp472Eg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xAQPSKbHDhhjvJMfHbAflRtuKuinLcohh3Mkhwc1Shc=;
	b=ICAGimlKkNHGknyiO7X3Db6DwOHLLU/ToiuX/mHVfn/K8gXhPg+ka2+V+KfYek35eA4os0
	AYiIiiKjOR9hkklTYoMFoeIk7RqbyKi4gkJTb74Zm5Cu2CQb5A5Lx8CP9WQqcKxBKw868l
	/HTXstL94iU1tXZtc21F5HVEkp472Eg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-Mm8ZRr3qNiaQs3DsKJiHcw-1; Wed,
 02 Sep 2026 13:38:45 -0400
X-MC-Unique: Mm8ZRr3qNiaQs3DsKJiHcw-1
X-Mimecast-MFC-AGG-ID: Mm8ZRr3qNiaQs3DsKJiHcw_1788370723
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 166FE192DD60;
	Wed,  2 Sep 2026 17:38:43 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E4211800643;
	Wed,  2 Sep 2026 17:38:36 +0000 (UTC)
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
Subject: [PATCH v11 35/36] netfs: Clean up now-unused code
Date: Wed,  2 Sep 2026 18:33:47 +0100
Message-ID: <20260902173350.3468672-36-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 9XppfmGNYe80d85LWezrE72OY_HFvjblj_KWDlDATik_1788370723
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Delete now-unused code from netfslib, given the changes to the writeback
dispatch code and the combination of ->prepare_xxx() and ->issue_xxx()
methods.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 217 -----------------------------------------
 1 file changed, 217 deletions(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 0a79da073f03..9a258386a1c3 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -222,70 +222,6 @@ struct netfs_io_subrequest *netfs_alloc_write_subreq(struct netfs_io_request *wr
 	return subreq;
 }
 
-#if 0 // TODO: Remove old stuff
-/*
- * Prepare a write subrequest.  We need to allocate a new subrequest
- * if we don't have one.
- */
-void netfs_prepare_write(struct netfs_io_request *wreq,
-			 struct netfs_io_stream *stream,
-			 uoff_t start)
-{
-	struct netfs_io_subrequest *subreq;
-
-	subreq = netfs_alloc_subrequest(wreq, stream->source);
-	if (!subreq)
-		return;
-	subreq->start		= start;
-	subreq->stream_nr	= stream->stream_nr;
-
-	bvecq_pos_set(&subreq->dispatch_pos, &wreq->dispatch_cursor);
-
-	_enter("R=%x[%x]", wreq->debug_id, subreq->debug_index);
-
-	trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
-
-	stream->sreq_max_len	= UINT_MAX;
-	stream->sreq_max_segs	= INT_MAX;
-	switch (stream->source) {
-	case NETFS_UPLOAD_TO_SERVER:
-		netfs_stat(&netfs_n_wh_upload);
-		stream->sreq_max_len = wreq->wsize;
-		break;
-	case NETFS_WRITE_TO_CACHE:
-		netfs_stat(&netfs_n_wh_write);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
-	if (stream->prepare_write)
-		stream->prepare_write(subreq);
-
-	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-
-	/* We add to the end of the list whilst the collector may be walking
-	 * the list.  The collector only goes nextwards and uses the lock to
-	 * remove entries off of the front.
-	 */
-	spin_lock(&wreq->lock);
-	/* Write IN_PROGRESS before pointer to new subreq */
-	list_add_tail_release(&subreq->rreq_link, &stream->subrequests);
-	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
-		if (!stream->active) {
-			stream->collected_to = subreq->start;
-			/* Write list pointers before active flag */
-			smp_store_release(&stream->active, true);
-		}
-	}
-
-	spin_unlock(&wreq->lock);
-
-	stream->construct = subreq;
-}
-#endif
-
 /*
  * Advance the state of the amount of data buffered on a stream.
  */
@@ -368,159 +304,6 @@ int netfs_prepare_write_buffer(struct netfs_io_subrequest *subreq,
 }
 EXPORT_SYMBOL(netfs_prepare_write_buffer);
 
-#if 0 // TODO: Remove old stuff
-/*
- * Set the I/O iterator for the filesystem/cache to use and dispatch the I/O
- * operation.  The operation may be asynchronous and should call
- * netfs_write_subrequest_terminated() when complete.
- */
-static void netfs_do_issue_write(struct netfs_io_stream *stream,
-				 struct netfs_io_subrequest *subreq)
-{
-	struct netfs_io_request *wreq = subreq->rreq;
-
-	_enter("R=%x[%x],%zx", wreq->debug_id, subreq->debug_index, subreq->len);
-
-	if (stream->source == NETFS_WRITE_TO_CACHE &&
-	    unlikely(test_bit(NETFS_RREQ_CACHE_STOP, &wreq->flags))) {
-		size_t dio_size = wreq->cache_resources.dio_size;
-		size_t len, disp;
-
-		disp = subreq->start & (dio_size - 1);
-		len = round_up(subreq->len + disp, dio_size);
-
-		subreq->start -= disp;
-		subreq->len = len;
-
-		__set_bit(NETFS_SREQ_CANCELLED, &subreq->flags);
-		return netfs_write_subrequest_terminated(subreq, subreq->len);
-	}
-
-	if (test_bit(NETFS_SREQ_FAILED, &subreq->flags))
-		return netfs_write_subrequest_terminated(subreq, subreq->error);
-
-	trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
-	stream->issue_write(subreq);
-}
-
-void netfs_reissue_write(struct netfs_io_stream *stream,
-			 struct netfs_io_subrequest *subreq)
-{
-	// TODO: Use encrypted buffer
-	bvecq_pos_unset(&subreq->content);
-	bvecq_pos_set(&subreq->content, &subreq->dispatch_pos);
-	iov_iter_bvec_queue(&subreq->io_iter, ITER_SOURCE,
-			    subreq->content.bvecq, subreq->content.slot,
-			    subreq->content.offset,
-			    subreq->len);
-	iov_iter_advance(&subreq->io_iter, subreq->transferred);
-
-	subreq->retry_count++;
-	subreq->error = 0;
-	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
-	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-	netfs_stat(&netfs_n_wh_retry_write_subreq);
-	netfs_do_issue_write(stream, subreq);
-}
-
-static void netfs_issue_write(struct netfs_io_request *wreq,
-			      struct netfs_io_stream *stream)
-{
-	struct netfs_io_subrequest *subreq = stream->construct;
-
-	if (!subreq)
-		return;
-
-	bvecq_pos_set(&subreq->content, &subreq->dispatch_pos);
-	iov_iter_bvec_queue(&subreq->io_iter, ITER_SOURCE,
-			    subreq->content.bvecq, subreq->content.slot,
-			    subreq->content.offset,
-			    subreq->len);
-
-	stream->construct = NULL;
-	netfs_do_issue_write(stream, subreq);
-}
-
-/*
- * Add data to the write subrequest, dispatching each as we fill it up or if it
- * is discontiguous with the previous.  We only fill one part at a time so that
- * we can avoid overrunning the credits obtained (cifs) and try to parallelise
- * content-crypto preparation with network writes.
- */
-size_t netfs_advance_write(struct netfs_io_request *wreq,
-			   struct netfs_io_stream *stream,
-			   uoff_t start, size_t len, bool to_eof)
-{
-	struct netfs_io_subrequest *subreq = stream->construct;
-	size_t part;
-
-	if (!stream->avail) {
-		_leave("no write");
-		return len;
-	}
-
-	_enter("R=%x[%x]", wreq->debug_id, subreq ? subreq->debug_index : 0);
-
-	if (subreq && start != subreq->start + subreq->len) {
-		netfs_issue_write(wreq, stream);
-		subreq = NULL;
-	}
-
-	if (!stream->construct)
-		netfs_prepare_write(wreq, stream, start);
-	subreq = stream->construct;
-
-	part = umin(stream->sreq_max_len - subreq->len, len);
-	_debug("part %zx/%zx %zx/%zx", subreq->len, stream->sreq_max_len, part, len);
-	subreq->len += part;
-	subreq->nr_segs++;
-
-	if (subreq->len >= stream->sreq_max_len ||
-	    subreq->nr_segs >= stream->sreq_max_segs ||
-	    to_eof) {
-		netfs_issue_write(wreq, stream);
-		subreq = NULL;
-	}
-
-	return part;
-}
-
-/*
- * Prepare and issue a subrequest.
- * TODO: Replace with combined ->prepare/->issue call().
- */
-static int netfs_prep_and_issue_subreq(struct netfs_io_request *wreq,
-				       struct netfs_io_stream *stream,
-				       struct netfs_io_subrequest *subreq)
-{
-	stream->sreq_max_len	= UINT_MAX;
-	stream->sreq_max_segs	= INT_MAX;
-	switch (stream->source) {
-	case NETFS_UPLOAD_TO_SERVER:
-		netfs_stat(&netfs_n_wh_upload);
-		stream->sreq_max_len = wreq->wsize;
-		break;
-	case NETFS_WRITE_TO_CACHE:
-		netfs_stat(&netfs_n_wh_write);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
-	if (stream->prepare_write)
-		stream->prepare_write(subreq);
-	netfs_prepare_buffered_write_buffer(subreq, stream->sreq_max_segs);
-	iov_iter_bvec_queue(&subreq->io_iter, ITER_SOURCE,
-			    subreq->content.bvecq, subreq->content.slot,
-			    subreq->content.offset,
-			    subreq->len);
-	trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
-	stream->issue_write(subreq);
-	return 0;
-}
-#endif
-
 /*
  * Issue writes for a stream.
  */


