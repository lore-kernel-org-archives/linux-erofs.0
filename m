Return-Path: <linux-erofs+bounces-3919-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DAD3C44501
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jul 2026 10:33:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h18Wz3rpFz30HB;
	Thu, 16 Jul 2026 20:33:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784197999;
	cv=none; b=ho0VJYWTGrX4TNkBvn4Ew4P387IwrYvET9llNjXIgslpeEcLelr79wZ+4rmA75qW3klF188DE4MN24FPcaE4A6429tXCly+x+k6xGxz8VO1GCrf745Bhdb5BSUySsfUwFU5FypjCXKa8ftik9/dDyUpygDRLjHgFNivwBtk+Oen3fPICo8mdLVV5z0bYoiaYPJFkjHQQWaj91ggxT1Ff2n18YzIefAoeFHIEIJuL6DvsrDUrIDjl5Iwk0pbY1kB1MqzfSSFYFMkXGr5TFz4RvYOTKB4iqmfP9U4gZpIfL9+AJjGpAs4Trv589IAYU8nPzFhuSWDXzsqUI+J/sxSsxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784197999; c=relaxed/relaxed;
	bh=BjMurCLWO0ABSGwoVAMVzJXBhWmh2vtP4MtSdwthwFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Z+EERbMANuakqNvhgHnJf+h0y2eamr2xQS27wPV6TbI5z2uiZGUfb5t7uJ78j0zEJR9FGAcL/nEUEkYLtpKoAbzar5MWsgM0lUyOA7thUTzZND/KgPpfUhpmTIDFTVLT9FCJLFUByOXIcpbfm/bD+koQIBZKw4UWYY6rFkui5wfo1Z/qq18/ljJhZBDOVptCyPMurQ1Io+8S9mDs9ZLt307mkPNvWd1ehs4quEj3OdIcHd9efee5iRuwJanEHVGHdJMVc9GBDc/KVT4kHg4RYD6PR47ZrorbHpiCucU0GfxApKGQj816+y3SN2I9AaSR66QNOA6WnEqbL+vnSdCrpw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LAV3ANv5; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hSNaX9Ql; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LAV3ANv5;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hSNaX9Ql;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h18Wy4VvKz2y8F
	for <linux-erofs@lists.ozlabs.org>; Thu, 16 Jul 2026 20:33:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BjMurCLWO0ABSGwoVAMVzJXBhWmh2vtP4MtSdwthwFE=;
	b=LAV3ANv5c6dBvqQGPjJRIuKcHgqEye7+2Uw8q5uOQDxGRyyki8FgIhUp4+F/syFJssH8o2
	FURk57Lde/PB4D1Be2XcGyY3sKaxnecK2u1aO7kIK1zWbkH7cNsaSwG3Ojx+9puiLe63Sx
	n41NOwL/zdar0Z5P7Rpj0JYzMYWk4XM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BjMurCLWO0ABSGwoVAMVzJXBhWmh2vtP4MtSdwthwFE=;
	b=hSNaX9QlNlAuxjQ5QZXx8+ntqXY5DiwTkxsiJzmErjtl7cm4QpC/YABDlPG5l2xipDesuW
	imhKvBvC7Gk3KHHYDrwvVBnyubE4o3M8uR3Eka+GEMebLflDny2qhJkHZOQTc/cbJG/pvV
	5b651dR2ZTtdrqr1MWVBQtHfHzbRTjo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-rwLgDHTiNIeNuVrtxwxTRA-1; Thu,
 16 Jul 2026 06:33:09 -0400
X-MC-Unique: rwLgDHTiNIeNuVrtxwxTRA-1
X-Mimecast-MFC-AGG-ID: rwLgDHTiNIeNuVrtxwxTRA_1784197986
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3539318002F2;
	Thu, 16 Jul 2026 10:33:06 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C6ED41800286;
	Thu, 16 Jul 2026 10:32:59 +0000 (UTC)
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
Subject: [PATCH v6 17/24] smbdirect: Remove support for ITER_FOLIOQ from smbdirect_map_sges_from_iter()
Date: Thu, 16 Jul 2026 11:30:16 +0100
Message-ID: <20260716103030.3065561-18-dhowells@redhat.com>
In-Reply-To: <20260716103030.3065561-1-dhowells@redhat.com>
References: <20260716103030.3065561-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 7zryeFjooPzNiAfGQhqZU3sKgeNhGt5vwHdnUUxdRtw_1784197986
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
index 4d2a1700104e..8858e1dfbc25 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -6,7 +6,6 @@
 
 #include "internal.h"
 #include <linux/bvecq.h>
-#include <linux/folio_queue.h>
 
 struct smbdirect_map_sges {
 	struct ib_sge *sge;
@@ -2130,70 +2129,6 @@ static ssize_t smbdirect_map_sges_from_kvec(struct iov_iter *iter,
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
@@ -2224,9 +2159,6 @@ static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 	case ITER_KVEC:
 		ret = smbdirect_map_sges_from_kvec(iter, state, len);
 		break;
-	case ITER_FOLIOQ:
-		ret = smbdirect_map_sges_from_folioq(iter, state, len);
-		break;
 	default:
 		WARN_ONCE(1, "iov_iter_type[%u]\n", iov_iter_type(iter));
 		return -EIO;


