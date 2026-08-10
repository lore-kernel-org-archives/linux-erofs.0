Return-Path: <linux-erofs+bounces-4173-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B643C5B56A
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 14:50:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJd3J5B60z3078;
	Tue, 11 Aug 2026 00:50:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786373436;
	cv=none; b=b0r/ytMHTSYxIoVQSJLJ1GP+nhkl/+KH3HqMDBraE3CEzupe3rSUqKxWAzaLCZYLig9451z+6jFj6pr6tjtMR7fJ/pIyVQ1vCYsHLAhEAsK7C+4oEqE6G40Uu3CEv7X2+Cs5duqvE6KTjJKCPIG97pKx/IwS1pLkTFjjr38PwnflOcuARLB8GXXt+batFuuRtx43H68N/kveKyTjyuEVFP6H86ZDAJrc44bC4EsTfijwQyFDqED4TpMO4BQD7BjTwa2nehQ9zUmjrJunAaZjPj0r0XUfClzkdSM3uvWE8e4d3UVpLhzn1pOuV6eXRUOd7oA5VZHA+iyXHluTCyEL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786373436; c=relaxed/relaxed;
	bh=3RLUsXNrqEFA9AsI6Bz/RMT6tC6+vpBaTozDF4VmJDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=fKR6xbnyz8MpY1VqhmmWwfUS0F8EOytWKGvR4E78QwdSp9FkIKSdDuVx6umBcf/IJ86PjiXQHh0bnYaBI3l3vmEoKKk3YZx2ad+vRdWk+sXte5Sw8rPu7sQAQ2+kbV0vUNEeFhbb7TlW68Af0LKGb1eEUAdbU3N2EBT4w3jp8A8m4XOV6ddLWzpQIbD1FwSgauxHFzueNy68a1yiLF1lSzNkCtS/CPy5M6r1vX89JqFDSY1nkQ/0bUb+WlqnT9DDousSEBCKw6XDoZjU21DmwSvZw6YHuF0H8i3eu4JorVEIdwYr07rz4gJSSdwVPlniMFmdZ1NkVsagjxIzq42IxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YjvUP3Aj; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YjvUP3Aj; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YjvUP3Aj;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YjvUP3Aj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJd3H48WPz2ytv
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 00:50:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RLUsXNrqEFA9AsI6Bz/RMT6tC6+vpBaTozDF4VmJDk=;
	b=YjvUP3Aj8B5Jf15tEcxH1zJZaJ5ua0/dsJyTm2Uzi6A7MaT5oGr3o6kH987Llm5RUygKLa
	v/EJ3oP0/DW7dzqDnKU8PMwPEOp73tFhIVqg5UKYwilzDEjnE3wqyrhu/EClamKyL20k8h
	9slN/LaCEN3Efwm0ZuLqWFguMleBU98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RLUsXNrqEFA9AsI6Bz/RMT6tC6+vpBaTozDF4VmJDk=;
	b=YjvUP3Aj8B5Jf15tEcxH1zJZaJ5ua0/dsJyTm2Uzi6A7MaT5oGr3o6kH987Llm5RUygKLa
	v/EJ3oP0/DW7dzqDnKU8PMwPEOp73tFhIVqg5UKYwilzDEjnE3wqyrhu/EClamKyL20k8h
	9slN/LaCEN3Efwm0ZuLqWFguMleBU98=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-74fGHb6MN8CnG4ErwpDMCA-1; Mon,
 10 Aug 2026 10:50:27 -0400
X-MC-Unique: 74fGHb6MN8CnG4ErwpDMCA-1
X-Mimecast-MFC-AGG-ID: 74fGHb6MN8CnG4ErwpDMCA_1786373425
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDE4B195608F;
	Mon, 10 Aug 2026 14:50:24 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BA1819560AB;
	Mon, 10 Aug 2026 14:50:18 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v9 18/26] smbdirect: Remove support for ITER_FOLIOQ from smbdirect_map_sges_from_iter()
Date: Mon, 10 Aug 2026 15:47:35 +0100
Message-ID: <20260810144746.574036-19-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: WD9I-fFETPqNHKkSURYG4MDzCNXmnhB_XE7WO4VacTY_1786373425
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

netfslib now only presents an bvecq queue and an associated ITER_BVECQ
iterator to the filesystem, so it isn't going to see the ITER_FOLIOQ
iterator.  So remove that code.

Netfslib also won't supply ITER_BVEC/KVEC iterators, though smbdirect
might; further in future, it won't supply iterators at all, but rather a
bvecq slice (that can be used to construct an iterator).

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Stefan Metzmacher <metze@samba.org>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Stefan Metzmacher <metze@samba.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/smbdirect/connection.c | 68 -----------------------------------
 1 file changed, 68 deletions(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index f5e7e75dd809..f217cf127cf9 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -6,7 +6,6 @@
 
 #include "internal.h"
 #include <linux/bvecq.h>
-#include <linux/folio_queue.h>
 
 struct smbdirect_map_sges {
 	struct ib_sge *sge;
@@ -2131,70 +2130,6 @@ static ssize_t smbdirect_map_sges_from_kvec(struct iov_iter *iter,
 	return ret;
 }
 
-/*
- * Extract folio fragments from a FOLIOQ-class iterator and add them to an
- * ib_sge list.  The folios are not pinned.
- */
-static ssize_t smbdirect_map_sges_from_folioq(struct iov_iter *iter,
-					      struct smbdirect_map_sges *state,
-					      ssize_t maxsize)
-{
-	const struct folio_queue *folioq = iter->folioq;
-	unsigned int slot = iter->folioq_slot;
-	ssize_t ret = 0;
-	size_t offset = iter->iov_offset;
-
-	if (WARN_ON_ONCE(!folioq))
-		return -EIO;
-
-	if (slot >= folioq_nr_slots(folioq)) {
-		folioq = folioq->next;
-		if (WARN_ON_ONCE(!folioq))
-			return -EIO;
-		slot = 0;
-	}
-
-	do {
-		struct folio *folio = folioq_folio(folioq, slot);
-		size_t fsize = folioq_folio_size(folioq, slot);
-
-		if (offset < fsize) {
-			size_t part = umin(maxsize, fsize - offset);
-			bool ok;
-
-			ok = smbdirect_map_sges_single_page(state,
-							    folio_page(folio, 0),
-							    offset,
-							    part);
-			if (!ok)
-				return -EIO;
-
-			offset += part;
-			ret += part;
-			maxsize -= part;
-		}
-
-		if (offset >= fsize) {
-			offset = 0;
-			slot++;
-			if (slot >= folioq_nr_slots(folioq)) {
-				if (!folioq->next) {
-					WARN_ON_ONCE(ret < iter->count);
-					break;
-				}
-				folioq = folioq->next;
-				slot = 0;
-			}
-		}
-	} while (state->num_sge < state->max_sge && maxsize > 0);
-
-	iter->folioq = folioq;
-	iter->folioq_slot = slot;
-	iter->iov_offset = offset;
-	iter->count -= ret;
-	return ret;
-}
-
 /*
  * Extract page fragments from up to the given amount of the source iterator
  * and build up an ib_sge list that refers to all of those bits.  The ib_sge list
@@ -2225,9 +2160,6 @@ static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 	case ITER_KVEC:
 		ret = smbdirect_map_sges_from_kvec(iter, state, len);
 		break;
-	case ITER_FOLIOQ:
-		ret = smbdirect_map_sges_from_folioq(iter, state, len);
-		break;
 	default:
 		WARN_ONCE(1, "iov_iter_type[%u]\n", iov_iter_type(iter));
 		return -EIO;


