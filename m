Return-Path: <linux-erofs+bounces-3034-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E7D710A1E65
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Mar 2026 10:49:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhLB06Rlfz2yhD;
	Thu, 26 Mar 2026 21:49:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774522152;
	cv=none; b=eK5JP7mSFlf1v4ssbrkkmoR/kvD13ujl18eM4P+rwNfUV9EiAlrx/DqOxu/42zw9gtwBuMuUTvmFU9wfyfQaTwIf4cvXh4ZZMb/R/l7/ycna2oVnbT2AG/MoH7OziRsmb0kwKxeTqmLz/sxB0QbxdDC5FD6vtnMEovBzIDocUUQER92nOBZlIhkVhGiALoetJfHNjsm9Hzyt7jP//Lkj9GjcL8bMQ5kQfwpzgKBJmVhHR3wxIw6pIihaOQnnY/l6uGFAU7EjlNrv0aLaBcs6acwDUbyXrYEkEsHsvIeEDclawdT0UBIoj9oeSSDMhFjd1sojSeLqe91ymalV1XHG2w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774522152; c=relaxed/relaxed;
	bh=k0QgTm96/panRDmu2v4v3cUuvffY71COarsUF9Amqek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=HCzoXpy+WcbgWvREUbKSOHIikaMoBVmOVFa+JEErhzySwzobl6VKLgmzaM9cD/TP2hOkmgPHT2PTq/9wStPtWTQbpnuHxgh4VmNVhLTXCxOefuuiDcoF3ioeJoZfOUONN/W/OpB+NGpAPMBSCMpQIzQ+E/mlqEBEvPqh67dKfM/0h76+T7LozeFe7W0Gjg9iGc88PEYOgCqT1ksPqrTKR3PryDlv9tmn7K6npo+cLcJX7hAiCq/rg7ke0O+LImlj37Syci1HkbYVcIDazh8FcmPYolUxRGyjaXKUeNyoP6AtVqy1OF6EvCGP274VleD/AE/wD3dKLfc46YjrOallNA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E80fRei9; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Xg+xsF/h; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E80fRei9;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Xg+xsF/h;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhLB004qHz2xN8
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 21:49:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0QgTm96/panRDmu2v4v3cUuvffY71COarsUF9Amqek=;
	b=E80fRei9fbG7useIJQllFInO2b5+7Ajf0K48EIp5jJiVSGoQC0l86CehirqDV4mStftNwW
	5DRz5+MSph+1xUExcCo+aAt2Cajsi5c+tUGTUFauJa3xbnaouSplLSoLiWz4Im+hrzge83
	eVm/C8a6BF7DwQwiYbNQ3Pju1nCJhDA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0QgTm96/panRDmu2v4v3cUuvffY71COarsUF9Amqek=;
	b=Xg+xsF/hH93KDIsN/sHJclrhGeUSYdOJSAv0aUus8iFZIlPaSmRXBYu0Odf+4zVlkgaDom
	6QYV5wO4CeIUlaSpPcaGL1bgOPmZSkbtR900kbW0d8mwiF/hjCg6f8mZ1XLaNDt/gyuu34
	waPIf31VEhljGOOw5qwwiL0jnfQiX7E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-0-W5qP_vNJW-BBJ5KPgU-Q-1; Thu,
 26 Mar 2026 06:49:04 -0400
X-MC-Unique: 0-W5qP_vNJW-BBJ5KPgU-Q-1
X-Mimecast-MFC-AGG-ID: 0-W5qP_vNJW-BBJ5KPgU-Q_1774522141
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 466FE195609E;
	Thu, 26 Mar 2026 10:49:01 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.121])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0E991955D84;
	Thu, 26 Mar 2026 10:48:54 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 20/26] netfs: Remove netfs_alloc/free_folioq_buffer()
Date: Thu, 26 Mar 2026 10:45:35 +0000
Message-ID: <20260326104544.509518-21-dhowells@redhat.com>
In-Reply-To: <20260326104544.509518-1-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: UcjTr8ehM48C-dyM3VvoQ1Tcw0Sdb79IbyiTZZ_6iGE_1774522141
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Remove netfs_alloc/free_folioq_buffer() as these have been replaced with
netfs_alloc/free_bvecq_buffer().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Steve French <sfrench@samba.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/dir_edit.c         |  1 -
 fs/netfs/misc.c           | 98 ---------------------------------------
 fs/smb/client/smb2ops.c   |  1 -
 fs/smb/client/smbdirect.c |  1 -
 include/linux/netfs.h     |  6 ---
 5 files changed, 107 deletions(-)

diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index 59d3decf7692..d6a9bb4e2039 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -10,7 +10,6 @@
 #include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/iversion.h>
-#include <linux/folio_queue.h>
 #include "internal.h"
 #include "xdr_fs.h"
 
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index ab142cbaad35..a19724389147 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -8,104 +8,6 @@
 #include <linux/swap.h>
 #include "internal.h"
 
-#if 0
-/**
- * netfs_alloc_folioq_buffer - Allocate buffer space into a folio queue
- * @mapping: Address space to set on the folio (or NULL).
- * @_buffer: Pointer to the folio queue to add to (may point to a NULL; updated).
- * @_cur_size: Current size of the buffer (updated).
- * @size: Target size of the buffer.
- * @gfp: The allocation constraints.
- */
-int netfs_alloc_folioq_buffer(struct address_space *mapping,
-			      struct folio_queue **_buffer,
-			      size_t *_cur_size, ssize_t size, gfp_t gfp)
-{
-	struct folio_queue *tail = *_buffer, *p;
-
-	size = round_up(size, PAGE_SIZE);
-	if (*_cur_size >= size)
-		return 0;
-
-	if (tail)
-		while (tail->next)
-			tail = tail->next;
-
-	do {
-		struct folio *folio;
-		int order = 0, slot;
-
-		if (!tail || folioq_full(tail)) {
-			p = netfs_folioq_alloc(0, GFP_NOFS, netfs_trace_folioq_alloc_buffer);
-			if (!p)
-				return -ENOMEM;
-			if (tail) {
-				tail->next = p;
-				p->prev = tail;
-			} else {
-				*_buffer = p;
-			}
-			tail = p;
-		}
-
-		if (size - *_cur_size > PAGE_SIZE)
-			order = umin(ilog2(size - *_cur_size) - PAGE_SHIFT,
-				     MAX_PAGECACHE_ORDER);
-
-		folio = folio_alloc(gfp, order);
-		if (!folio && order > 0)
-			folio = folio_alloc(gfp, 0);
-		if (!folio)
-			return -ENOMEM;
-
-		folio->mapping = mapping;
-		folio->index = *_cur_size / PAGE_SIZE;
-		trace_netfs_folio(folio, netfs_folio_trace_alloc_buffer);
-		slot = folioq_append_mark(tail, folio);
-		*_cur_size += folioq_folio_size(tail, slot);
-	} while (*_cur_size < size);
-
-	return 0;
-}
-EXPORT_SYMBOL(netfs_alloc_folioq_buffer);
-
-/**
- * netfs_free_folioq_buffer - Free a folio queue.
- * @fq: The start of the folio queue to free
- *
- * Free up a chain of folio_queues and, if marked, the marked folios they point
- * to.
- */
-void netfs_free_folioq_buffer(struct folio_queue *fq)
-{
-	struct folio_queue *next;
-	struct folio_batch fbatch;
-
-	folio_batch_init(&fbatch);
-
-	for (; fq; fq = next) {
-		for (int slot = 0; slot < folioq_count(fq); slot++) {
-			struct folio *folio = folioq_folio(fq, slot);
-
-			if (!folio ||
-			    !folioq_is_marked(fq, slot))
-				continue;
-
-			trace_netfs_folio(folio, netfs_folio_trace_put);
-			if (folio_batch_add(&fbatch, folio))
-				folio_batch_release(&fbatch);
-		}
-
-		netfs_stat_d(&netfs_n_folioq);
-		next = fq->next;
-		kfree(fq);
-	}
-
-	folio_batch_release(&fbatch);
-}
-EXPORT_SYMBOL(netfs_free_folioq_buffer);
-#endif
-
 /**
  * netfs_dirty_folio - Mark folio dirty and pin a cache object for writeback
  * @mapping: The mapping the folio belongs to.
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 173acca17af7..0d19c8fc4c3d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -13,7 +13,6 @@
 #include <linux/sort.h>
 #include <crypto/aead.h>
 #include <linux/fiemap.h>
-#include <linux/folio_queue.h>
 #include <uapi/linux/magic.h>
 #include "cifsfs.h"
 #include "cifsglob.h"
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d9e026d5e9f9..252e7757d21c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -6,7 +6,6 @@
  */
 #include <linux/module.h>
 #include <linux/highmem.h>
-#include <linux/folio_queue.h>
 #define __SMBDIRECT_SOCKET_DISCONNECT(__sc) smbd_disconnect_rdma_connection(__sc)
 #include "../common/smbdirect/smbdirect_pdu.h"
 #include "smbdirect.h"
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 3345c88bbd8e..9d8576a62868 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -463,12 +463,6 @@ void netfs_end_io_write(struct inode *inode);
 int netfs_start_io_direct(struct inode *inode);
 void netfs_end_io_direct(struct inode *inode);
 
-/* Buffer wrangling helpers API. */
-int netfs_alloc_folioq_buffer(struct address_space *mapping,
-			      struct folio_queue **_buffer,
-			      size_t *_cur_size, ssize_t size, gfp_t gfp);
-void netfs_free_folioq_buffer(struct folio_queue *fq);
-
 /**
  * netfs_inode - Get the netfs inode context from the inode
  * @inode: The inode to query


