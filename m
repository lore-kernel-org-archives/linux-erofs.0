Return-Path: <linux-erofs+bounces-4315-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49294C5DF94
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDFd34ZZz2y83;
	Tue, 25 Aug 2026 00:44:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582661;
	cv=none; b=HfOaehwhvLWOiKl2Mqyessj795M+rCnXKMmQ3D3vUVSyPlEHDP2qgGiOOzZoIQ7w1PzSy9hsf/iKoCsUyYBXTRnOkHSJVJahld9lzvGWmWcEmcILZz3kXiiYOMtvdMMCZgx75nsnsNHzUf6Mx9BlQniu0pEuHMEVWVt8AzzSEQZe6iAONgr1j7G2KErbeE/E/JoZ2NSaMnxMaYeAG/mHMgQHKRQ9X+O282bi3/GzDZMFjoQ1UlQYl97E6ZcwDTOzkTzUOTiO5n98vc1wGgzvIZdGjCjhcJPfnlgHSRC2TmXvAP4JEXI5v1/kvjSo4Ztai+pLM3pErMdkH1127V8DFg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582661; c=relaxed/relaxed;
	bh=9rm9NpPcIh/jFryu1IF6Xb6qZ4y4/kpSxxSi4Ji3UH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lrxDXzyqhOU+J2VtRpxpjCinc2Tq1n0mQSDH0WLOZh4RIdFFzox3i4aRtUHPtPLCytem+P6sBRDwLUt+FZttIrUIfJIqpq1VoCcKuDJT8NtTcNRhGO2MFMfXzr2DfSO9RV5fdQeO2evMlfSW2JZRvqaKyKv5NogpS63UW9f3iVpLWSnsZMYr3OXfdmdPUAb+iALNO/7Ec6ps3VpXsWU1MX3GTWpxJLwz0jq5dYJUoE4XxdI0ZM7vPGMVSK9g3/+MoUrYyBDIP91+z3+idHroDJaFDo8rG+tPGJzOAQfKH/aRDsp+VWvzQw0AMhcUSOwCluHFRk3zbdQdXDl0hJ7hiQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dzcAuVLR; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cYkWotOG; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dzcAuVLR;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cYkWotOG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDFb6MKRz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:44:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9rm9NpPcIh/jFryu1IF6Xb6qZ4y4/kpSxxSi4Ji3UH4=;
	b=dzcAuVLRMoZHrEd6a0RnO2nJKFkgVz2keDw3pxwX+oJAttqXpH+J5BWi9SjjtIXJYRA3WR
	IWWID/lugjcSJdcOt2Euoz9KJgVcERTpyZv8Q+4WzBCes8NpAN3UUJoJZrZAZq4/a/rBtP
	N123rHtVhcCuyKWZlge+HkCYOUZkxmQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9rm9NpPcIh/jFryu1IF6Xb6qZ4y4/kpSxxSi4Ji3UH4=;
	b=cYkWotOGcxSqk9t5RUCrejrRdFHg88PA8t5bA63soPPKBEbitSohI81cK5wS8c8hV1ZTNM
	85VWZo2XIw91qKklunWwS22XklHVPJrWZuJCVdgIqbI/SjOOiXHC/rMhmOqFWN9Zz99U/a
	r4Os7w+v5TxxWObazrHKhBeg/FlwH64=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-lfEsx3z8P2WhCtc69nCW9Q-1; Mon,
 24 Aug 2026 10:44:10 -0400
X-MC-Unique: lfEsx3z8P2WhCtc69nCW9Q-1
X-Mimecast-MFC-AGG-ID: lfEsx3z8P2WhCtc69nCW9Q_1787582646
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95E4A1944DE3;
	Mon, 24 Aug 2026 14:44:06 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7DD2D26C;
	Mon, 24 Aug 2026 14:44:00 +0000 (UTC)
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
Subject: [PATCH v10 17/35] netfs: Remove the writethrough code
Date: Mon, 24 Aug 2026 15:41:10 +0100
Message-ID: <20260824144130.759997-18-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: N17wY_gRqQWku4zc0tSkb2soUdTA99Xd1B5QBwHI8hA_1787582646
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Remove the netfs writethrough code as it's very tricky to get the locking
right and it will probably deadlock if used in conjunction with Ceph
snapshots because it excludes writeback for the duration, but to flush out
old snapshots, it does a synchronous flush that invokes writeback.

Instead, O_SYNC writes do a flush after performing the write - which is
already there as the callers of netfs_perform_write() all call
generic_write_sync().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/9p/vfs_addr.c             |   1 -
 fs/afs/file.c                |   1 -
 fs/netfs/buffered_write.c    |  56 ++-----------------
 fs/netfs/internal.h          |   7 ---
 fs/netfs/main.c              |   1 -
 fs/netfs/stats.c             |   4 +-
 fs/netfs/write_collect.c     |   2 -
 fs/netfs/write_issue.c       | 104 +----------------------------------
 include/linux/netfs.h        |   1 -
 include/trace/events/netfs.h |   8 +--
 10 files changed, 9 insertions(+), 176 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 1ac0b3dcc077..2129fcb0f65c 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -124,7 +124,6 @@ static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 	struct p9_fid *fid;
 	struct dentry *dentry;
 	bool writing = (rreq->origin == NETFS_READ_FOR_WRITE ||
-			rreq->origin == NETFS_WRITETHROUGH ||
 			rreq->origin == NETFS_UNBUFFERED_WRITE ||
 			rreq->origin == NETFS_DIO_WRITE);
 
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 3380a0d20c0f..99987f6bbc36 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -400,7 +400,6 @@ static int afs_init_request(struct netfs_io_request *rreq, struct file *file)
 		}
 		break;
 	case NETFS_WRITEBACK:
-	case NETFS_WRITETHROUGH:
 	case NETFS_UNBUFFERED_WRITE:
 	case NETFS_DIO_WRITE:
 		if (S_ISREG(rreq->inode->i_mode))
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index df496873e4f4..ead22980075f 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -91,44 +91,14 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct netfs_inode *ctx = netfs_inode(inode);
-	struct writeback_control wbc = {
-		.sync_mode	= WB_SYNC_NONE,
-		.for_sync	= true,
-		.nr_to_write	= LONG_MAX,
-		.range_start	= iocb->ki_pos,
-		.range_end	= iocb->ki_pos + iter->count,
-	};
-	struct netfs_io_request *wreq = NULL;
-	struct folio *folio = NULL, *writethrough = NULL;
+	struct folio *folio = NULL;
 	unsigned int bdp_flags = (iocb->ki_flags & IOCB_NOWAIT) ? BDP_ASYNC : 0;
-	ssize_t written = 0, ret, ret2;
+	ssize_t written = 0, ret;
 	uoff_t pos = iocb->ki_pos;
 	size_t max_chunk = mapping_max_folio_size(mapping);
 	bool maybe_trouble = false;
 
-	if (unlikely(iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC))
-	    ) {
-		wbc_attach_fdatawrite_inode(&wbc, mapping->host);
-
-		ret = filemap_write_and_wait_range(mapping, pos, pos + iter->count);
-		if (ret < 0) {
-			wbc_detach_inode(&wbc);
-			goto out;
-		}
-
-		wreq = netfs_begin_writethrough(iocb, iter->count);
-		if (IS_ERR(wreq)) {
-			wbc_detach_inode(&wbc);
-			ret = PTR_ERR(wreq);
-			wreq = NULL;
-			goto out;
-		}
-		if (!is_sync_kiocb(iocb))
-			wreq->iocb = iocb;
-		netfs_stat(&netfs_n_wh_writethrough);
-	} else {
-		netfs_stat(&netfs_n_wh_buffered_write);
-	}
+	netfs_stat(&netfs_n_wh_buffered_write);
 
 	do {
 		enum netfs_folio_trace trace;
@@ -390,15 +360,8 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		pos += copied;
 		written += copied;
 
-		if (likely(!wreq)) {
-			folio_mark_dirty(folio);
-			folio_unlock(folio);
-		} else {
-			netfs_advance_writethrough(wreq, &wbc, folio, copied,
-						   offset + copied == flen,
-						   &writethrough);
-			/* Folio unlocked */
-		}
+		folio_mark_dirty(folio);
+		folio_unlock(folio);
 	retry:
 		folio_put(folio);
 		folio = NULL;
@@ -420,15 +383,6 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			ctx->ops->post_modify(inode);
 	}
 
-	if (unlikely(wreq)) {
-		ret2 = netfs_end_writethrough(wreq, &wbc, writethrough);
-		wbc_detach_inode(&wbc);
-		if (ret2 == -EIOCBQUEUED)
-			return ret2;
-		if (ret == 0 && ret2 < 0)
-			ret = ret2;
-	}
-
 	iocb->ki_pos += written;
 	_leave(" = %zd [%zd]", written, ret);
 	return written ? written : ret;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 431ec77b1305..09e86183b26b 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -157,7 +157,6 @@ extern atomic_t netfs_n_rh_write_zskip;
 extern atomic_t netfs_n_rh_retry_read_req;
 extern atomic_t netfs_n_rh_retry_read_subreq;
 extern atomic_t netfs_n_wh_buffered_write;
-extern atomic_t netfs_n_wh_writethrough;
 extern atomic_t netfs_n_wh_dio_write;
 extern atomic_t netfs_n_wh_writepages;
 extern atomic_t netfs_n_wh_copy_to_cache;
@@ -217,12 +216,6 @@ void netfs_issue_write(struct netfs_io_request *wreq,
 size_t netfs_advance_write(struct netfs_io_request *wreq,
 			   struct netfs_io_stream *stream,
 			   uoff_t start, size_t len, bool to_eof);
-struct netfs_io_request *netfs_begin_writethrough(struct kiocb *iocb, size_t len);
-int netfs_advance_writethrough(struct netfs_io_request *wreq, struct writeback_control *wbc,
-			       struct folio *folio, size_t copied, bool to_page_end,
-			       struct folio **writethrough_cache);
-ssize_t netfs_end_writethrough(struct netfs_io_request *wreq, struct writeback_control *wbc,
-			       struct folio *writethrough_cache);
 
 /*
  * write_retry.c
diff --git a/fs/netfs/main.c b/fs/netfs/main.c
index 9f72e5054aff..3908ea2422c8 100644
--- a/fs/netfs/main.c
+++ b/fs/netfs/main.c
@@ -45,7 +45,6 @@ static const char *netfs_origins[nr__netfs_io_origin] = {
 	[NETFS_DIO_READ]		= "DR",
 	[NETFS_WRITEBACK]		= "WB",
 	[NETFS_WRITEBACK_SINGLE]	= "W1",
-	[NETFS_WRITETHROUGH]		= "WT",
 	[NETFS_UNBUFFERED_WRITE]	= "UW",
 	[NETFS_DIO_WRITE]		= "DW",
 	[NETFS_PGPRIV2_COPY_TO_CACHE]	= "2C",
diff --git a/fs/netfs/stats.c b/fs/netfs/stats.c
index 84c2a4bcc762..a10d34f88597 100644
--- a/fs/netfs/stats.c
+++ b/fs/netfs/stats.c
@@ -32,7 +32,6 @@ atomic_t netfs_n_rh_write_zskip;
 atomic_t netfs_n_rh_retry_read_req;
 atomic_t netfs_n_rh_retry_read_subreq;
 atomic_t netfs_n_wh_buffered_write;
-atomic_t netfs_n_wh_writethrough;
 atomic_t netfs_n_wh_dio_write;
 atomic_t netfs_n_wh_writepages;
 atomic_t netfs_n_wh_copy_to_cache;
@@ -59,9 +58,8 @@ int netfs_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&netfs_n_rh_read_single),
 		   atomic_read(&netfs_n_rh_write_begin),
 		   atomic_read(&netfs_n_rh_write_zskip));
-	seq_printf(m, "Writes : BW=%u WT=%u DW=%u WP=%u 2C=%u\n",
+	seq_printf(m, "Writes : BW=%u DW=%u WP=%u 2C=%u\n",
 		   atomic_read(&netfs_n_wh_buffered_write),
-		   atomic_read(&netfs_n_wh_writethrough),
 		   atomic_read(&netfs_n_wh_dio_write),
 		   atomic_read(&netfs_n_wh_writepages),
 		   atomic_read(&netfs_n_wh_copy_to_cache));
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 100a5038c61e..244a68e04624 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -214,7 +214,6 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 	smp_rmb();
 	collected_to = ULLONG_MAX;
 	if (wreq->origin == NETFS_WRITEBACK ||
-	    wreq->origin == NETFS_WRITETHROUGH ||
 	    wreq->origin == NETFS_PGPRIV2_COPY_TO_CACHE)
 		notes = NEED_UNLOCK;
 	else
@@ -411,7 +410,6 @@ bool netfs_write_collection(struct netfs_io_request *wreq)
 	switch (wreq->origin) {
 	case NETFS_WRITEBACK:
 	case NETFS_WRITEBACK_SINGLE:
-	case NETFS_WRITETHROUGH:
 		netfs_wb_end(ictx);
 		break;
 	default:
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index d68d130d6da0..6d0f72797351 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -96,7 +96,6 @@ struct netfs_io_request *netfs_create_write_req(struct address_space *mapping,
 	struct netfs_inode *ictx;
 	bool is_cacheable = (origin == NETFS_WRITEBACK ||
 			     origin == NETFS_WRITEBACK_SINGLE ||
-			     origin == NETFS_WRITETHROUGH ||
 			     origin == NETFS_PGPRIV2_COPY_TO_CACHE);
 
 	wreq = netfs_alloc_request(mapping, file, start, 0, origin);
@@ -365,11 +364,7 @@ static int netfs_write_folio(struct netfs_io_request *wreq,
 		streamw = true;
 	}
 
-	if (wreq->origin == NETFS_WRITETHROUGH) {
-		to_eof = false;
-		if (flen > i_size - fpos)
-			flen = i_size - fpos;
-	} else if (flen > i_size - fpos) {
+	if (flen > i_size - fpos) {
 		flen = i_size - fpos;
 		if (!streamw)
 			folio_zero_segment(folio, flen, fsize);
@@ -611,103 +606,6 @@ int netfs_writepages(struct address_space *mapping,
 }
 EXPORT_SYMBOL(netfs_writepages);
 
-/*
- * Begin a write operation for writing through the pagecache.
- */
-struct netfs_io_request *netfs_begin_writethrough(struct kiocb *iocb, size_t len)
-{
-	struct netfs_io_request *wreq = NULL;
-	struct netfs_inode *ictx = netfs_inode(file_inode(iocb->ki_filp));
-
-	netfs_wb_begin(ictx, false);
-
-	wreq = netfs_create_write_req(iocb->ki_filp->f_mapping, iocb->ki_filp,
-				      iocb->ki_pos, NETFS_WRITETHROUGH);
-	if (IS_ERR(wreq)) {
-		netfs_wb_end(ictx);
-		return wreq;
-	}
-
-	wreq->io_streams[0].avail = true;
-	__set_bit(NETFS_RREQ_OFFLOAD_COLLECTION, &wreq->flags);
-	trace_netfs_write(wreq, netfs_write_trace_writethrough);
-	return wreq;
-}
-
-/*
- * Advance the state of the write operation used when writing through the
- * pagecache.  Data has been copied into the pagecache that we need to append
- * to the request.  If we've added more than wsize then we need to create a new
- * subrequest.
- */
-int netfs_advance_writethrough(struct netfs_io_request *wreq, struct writeback_control *wbc,
-			       struct folio *folio, size_t copied, bool to_page_end,
-			       struct folio **writethrough_cache)
-{
-	int ret;
-
-	_enter("R=%x ic=%zu ws=%u cp=%zu tp=%u",
-	       wreq->debug_id, wreq->buffer.iter.count, wreq->wsize, copied, to_page_end);
-
-	/* The folio is locked. */
-
-	if (*writethrough_cache != folio) {
-		if (*writethrough_cache) {
-			/* Did the folio get moved? */
-			folio_put(*writethrough_cache);
-			*writethrough_cache = NULL;
-		}
-		/* We can make multiple writes to the folio... */
-		if (wreq->len == 0)
-			trace_netfs_folio(folio, netfs_folio_trace_wthru);
-		else
-			trace_netfs_folio(folio, netfs_folio_trace_wthru_plus);
-		*writethrough_cache = folio;
-		folio_get(folio);
-	}
-
-	wreq->len += copied;
-
-	if (!to_page_end) {
-		folio_mark_dirty(folio);
-		folio_unlock(folio);
-		return 0;
-	}
-
-	ret = netfs_write_folio(wreq, wbc, folio);
-	folio_put(*writethrough_cache);
-	*writethrough_cache = NULL;
-	wreq->submitted = wreq->len;
-	return ret;
-}
-
-/*
- * End a write operation used when writing through the pagecache.
- */
-ssize_t netfs_end_writethrough(struct netfs_io_request *wreq, struct writeback_control *wbc,
-			       struct folio *writethrough_cache)
-{
-	ssize_t ret;
-
-	_enter("R=%x", wreq->debug_id);
-
-	if (writethrough_cache) {
-		folio_lock(writethrough_cache);
-		netfs_write_folio(wreq, wbc, writethrough_cache);
-		folio_put(writethrough_cache);
-		wreq->submitted = wreq->len;
-	}
-
-	netfs_end_issue_write(wreq);
-
-	if (wreq->iocb)
-		ret = -EIOCBQUEUED;
-	else
-		ret = netfs_wait_for_write(wreq);
-	netfs_put_request(wreq, netfs_rreq_trace_put_return);
-	return ret;
-}
-
 /**
  * netfs_writeback_single - Write back a monolithic payload
  * @mapping: The mapping to write from
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 14a24bb80af5..b6e5f6dc54e2 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -209,7 +209,6 @@ enum netfs_io_origin {
 	NETFS_DIO_READ,			/* This is a direct I/O read */
 	NETFS_WRITEBACK,		/* This write was triggered by writepages */
 	NETFS_WRITEBACK_SINGLE,		/* This monolithic write was triggered by writepages */
-	NETFS_WRITETHROUGH,		/* This write was made by netfs_perform_write() */
 	NETFS_UNBUFFERED_WRITE,		/* This is an unbuffered write */
 	NETFS_DIO_WRITE,		/* This is a direct I/O write */
 	NETFS_PGPRIV2_COPY_TO_CACHE,	/* [DEPRECATED] This is writing read data to the cache */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 111c02817bea..ccb9f3c30432 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -30,8 +30,7 @@
 	EM(netfs_write_trace_dio_write,		"DIO-WRITE")	\
 	EM(netfs_write_trace_unbuffered_write,	"UNB-WRITE")	\
 	EM(netfs_write_trace_writeback,		"WRITEBACK")	\
-	EM(netfs_write_trace_writeback_single,	"WB-SINGLE") \
-	E_(netfs_write_trace_writethrough,	"WRITETHRU")
+	E_(netfs_write_trace_writeback_single,	"WB-SINGLE")
 
 #define netfs_rreq_origins					\
 	EM(NETFS_READAHEAD,			"RA")		\
@@ -43,7 +42,6 @@
 	EM(NETFS_DIO_READ,			"DR")		\
 	EM(NETFS_WRITEBACK,			"WB")		\
 	EM(NETFS_WRITEBACK_SINGLE,		"W1")		\
-	EM(NETFS_WRITETHROUGH,			"WT")		\
 	EM(NETFS_UNBUFFERED_WRITE,		"UW")		\
 	EM(NETFS_DIO_WRITE,			"DW")		\
 	E_(NETFS_PGPRIV2_COPY_TO_CACHE,		"2C")
@@ -221,9 +219,7 @@
 	EM(netfs_folio_trace_redirtied,		"redirtied")	\
 	EM(netfs_folio_trace_store,		"store")	\
 	EM(netfs_folio_trace_store_copy,	"store-copy")	\
-	EM(netfs_folio_trace_store_plus,	"store+")	\
-	EM(netfs_folio_trace_wthru,		"wthru")	\
-	E_(netfs_folio_trace_wthru_plus,	"wthru+")
+	E_(netfs_folio_trace_store_plus,	"store+")
 
 #define netfs_collect_contig_traces				\
 	EM(netfs_contig_trace_collect,		"Collect")	\


