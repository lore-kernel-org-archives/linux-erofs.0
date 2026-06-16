Return-Path: <linux-erofs+bounces-3620-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E38CD98E1
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 10:12:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfjTF3cTRz3brH;
	Tue, 16 Jun 2026 20:12:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781604721;
	cv=none; b=CXK5UQvrzxmyV6/lcswP5WS/3YciK0bpXFxbr1inCDaOmA5TTSSIMnR9fAIV0dIHBptdF5naQYhhlWnTnfCEvizvG2UwZSZ1K+e0Hu6bwdduDYwFSoStBqO19Kr4y2dNqNLsVBezOw4QfjHAXU1MTiRSnyNq/D46v38INHdFvhUnIEYfEgoYXmybWZjV6VJDuWJiirIK0i2obkMZYr1CC0SHf7IFbp1udrRCDuWPM62/RjPiA3hlAGmgiu4mlYTRD2hBl8pN/r9bVfN8Lu9jHt6nruFX62bA7dtNDm8aVAgziAY1r6HqhU2e/Qk4QNgXrJ4IMYHbxUDNNk5TZSv7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781604721; c=relaxed/relaxed;
	bh=DVlqEBXVaMky7fRh20tqJCgSzEW2xB3Oby52mxDOfOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UuPndMR3ZZ0WVSmszMFxws33qR/TNfP0E7s5g38Js7jAq/NRFkpk8c4Vl5WrWkM9Uv1LraZZrud70S1LEPPPNYrapBhHFe1rqYGVHR/DrjhfLpAXrLBTZr57Pgn0erNFCynjo7NWl6eBbGpxD0JluQMpMzSnwH6ECOHDh1p+xaWFSqX6yv2xxkZxMmP3KGmMeuFvnPxPW3WiroQx2fCHAR7z8YIzhZ3qJqufyspn6cm7/98nfmTVR3Xy9H3H39DDUkIEjuFgxiJLf9a4UJNojF4/bmjl6HyVY18NZAu3stE+vlgBO09I/Zb8fg/TtEWAnfZVhIgDbLN4deBeSSWtng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T+p6noZs; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T+p6noZs; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T+p6noZs;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T+p6noZs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfjTD3yxcz3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 20:12:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVlqEBXVaMky7fRh20tqJCgSzEW2xB3Oby52mxDOfOI=;
	b=T+p6noZsPlAQS75YXuUiyE+0QJ1CeHLSUycC9pyl3upRSeZA2cdrxnnAB8QQfQKfxYfU/V
	sCj55EIg3n/cDjYoYHuckJ7fT7pCdvSOc9CDJYB4yCbmqZjdKiGXMRY7ic4WlXDzkAoPJ7
	23YkYk1X+ZaXhF7P3Zi/CB+Vyf28sIA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVlqEBXVaMky7fRh20tqJCgSzEW2xB3Oby52mxDOfOI=;
	b=T+p6noZsPlAQS75YXuUiyE+0QJ1CeHLSUycC9pyl3upRSeZA2cdrxnnAB8QQfQKfxYfU/V
	sCj55EIg3n/cDjYoYHuckJ7fT7pCdvSOc9CDJYB4yCbmqZjdKiGXMRY7ic4WlXDzkAoPJ7
	23YkYk1X+ZaXhF7P3Zi/CB+Vyf28sIA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-wgxKAHcINtG02dxE1iiZUw-1; Tue,
 16 Jun 2026 06:11:54 -0400
X-MC-Unique: wgxKAHcINtG02dxE1iiZUw-1
X-Mimecast-MFC-AGG-ID: wgxKAHcINtG02dxE1iiZUw_1781604711
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D4FF197700F;
	Tue, 16 Jun 2026 10:11:42 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4264E3008B3E;
	Tue, 16 Jun 2026 10:11:36 +0000 (UTC)
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
Subject: [PATCH v4 23/30] netfs: Remove netfs_alloc/free_folioq_buffer()
Date: Tue, 16 Jun 2026 11:08:12 +0100
Message-ID: <20260616100821.2062304-24-dhowells@redhat.com>
In-Reply-To: <20260616100821.2062304-1-dhowells@redhat.com>
References: <20260616100821.2062304-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: ggCb23y3pSrXBCQmSp-boSrHTrklFDWRHJIqvN4IS9M_1781604711
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
 fs/afs/dir_edit.c       |  1 -
 fs/netfs/misc.c         | 98 -----------------------------------------
 fs/smb/client/smb2ops.c |  1 -
 include/linux/netfs.h   |  6 ---
 4 files changed, 106 deletions(-)

diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index b3e80c5c434f..b92d7aa6eeac 100644
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
index ee67a0681784..8fc4e5ef2152 100644
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
index 6e3d43c4643a..c14ae1a61a43 100644
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
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index d2a059d93807..a4efa313087d 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -481,12 +481,6 @@ void netfs_end_io_write(struct inode *inode);
 int netfs_start_io_direct(struct inode *inode);
 void netfs_end_io_direct(struct inode *inode);
 
-/* Buffer wrangling helpers API. */
-int netfs_alloc_folioq_buffer(struct address_space *mapping,
-			      struct folio_queue **_buffer,
-			      size_t *_cur_size, ssize_t size, gfp_t gfp);
-void netfs_free_folioq_buffer(struct folio_queue *fq);
-
 /* Writeback exclusion API. */
 bool netfs_wb_begin(struct netfs_inode *ictx, bool nowait);
 void netfs_wb_end(struct netfs_inode *ictx);


