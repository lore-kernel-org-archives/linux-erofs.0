Return-Path: <linux-erofs+bounces-3972-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B7DC4453C
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 13:05:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4vd33Pnrz2yfS;
	Wed, 22 Jul 2026 23:05:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784725543;
	cv=none; b=dKDMcqRnyh5GXRs9Zy1OmqK+fCSgQX3hDPibSAwACaGsXIWhNXuamSEUEhvn7YsH1lcQX9oW9L0Rz7jUi45FnXXaIt7KIp9MJPRNM1cCQVvWOawddrc0tEV0kiD4P45Unf+x9G494RvGiTfcnuBJPe4y6QNA0IqNMofX6q1lTd5zv0KnH371Rry4TGwQlnlDuRjt4BDwttqEpysT3UupdM7i8YpxXJwjQH1FJNgQ549Ea/30Cp4KbKDmuZ8s26zNSmUfXG0RQcToNCv+rpGfQSA0EzxL16zHJWfWympLqa51ssrSGE3FTIQuCDrdDrZy5+5Z+dkTFKvcwhwoMmJFaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784725543; c=relaxed/relaxed;
	bh=3RLUsXNrqEFA9AsI6Bz/RMT6tC6+vpBaTozDF4VmJDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=nzjQzKfrgeSltuJo2VmzBRN6xGi3xw6KVlDhxhlGWVAePuGOCNFa7mPWLr75aLINcCxxP7oMQDCsuHUIjMHKPznGGw3JtcRrG4+o95zM1K8++LPWJiy/2m5F8iCoyAa4zIV9HqREamUDvOxk4hOzEe2uyBtZy/dICJASF78wE6et3J3QAu6OUP52nFqx4i3GLjfrGhbDHbfu0yHXVh4NM5mncjBW7HEDQbmhK6xh1BaLpJ/xmm1Mh3VH2MRO/WYSNbBq8nQ1176wpM5WNXNlZQF4TMNs6VO5aWmkSmMqY4cDIss5byDq4+LJLy7zGs8zkM2JfV6rIJpViVlpQu2vVw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BJJDTEJt; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fQSQ+Ioc; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BJJDTEJt;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fQSQ+Ioc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4vd23Bqzz2yfH
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 23:05:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RLUsXNrqEFA9AsI6Bz/RMT6tC6+vpBaTozDF4VmJDk=;
	b=BJJDTEJtBe8FbvuCJQCkdoqAI8VYWwwWRj0QRb4rCOdRHtGcPRcsJ5CI23gibgdLDfyBgK
	nGb0xo7WNU1YdJ18HNW95SjUBF/7pa8Z+iMsFTAVS7zcASzp9Og0Ih2hFLebpMo8OkrW1u
	X0+jNjX93LGpQ8Qf/D+Ug3XdlpzMnhY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RLUsXNrqEFA9AsI6Bz/RMT6tC6+vpBaTozDF4VmJDk=;
	b=fQSQ+IocvC7THIv9OSMl9ZZPZRdBJ2M3lZUS0PZu4IK2FFNp9kXUla2HNmMxx0Ugq6ds6J
	sJQUscoKbaVEwbA8EQw/TL0kuQN8AhHyPbKk+ZGHZ0P/tK4/ntlkaIPxc/M7Peyc95CEKd
	9v0dO89z1mTPfNsFl4tORkZuQ1O2Ztc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-2kXFrg0GNWaZoMnQkAEDQg-1; Wed,
 22 Jul 2026 09:05:33 -0400
X-MC-Unique: 2kXFrg0GNWaZoMnQkAEDQg-1
X-Mimecast-MFC-AGG-ID: 2kXFrg0GNWaZoMnQkAEDQg_1784725529
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D9A61955F3F;
	Wed, 22 Jul 2026 13:05:29 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 57C04D70;
	Wed, 22 Jul 2026 13:05:23 +0000 (UTC)
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
Subject: [PATCH v7 22/29] smbdirect: Remove support for ITER_FOLIOQ from smbdirect_map_sges_from_iter()
Date: Wed, 22 Jul 2026 14:02:09 +0100
Message-ID: <20260722130218.78958-23-dhowells@redhat.com>
In-Reply-To: <20260722130218.78958-1-dhowells@redhat.com>
References: <20260722130218.78958-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: mMygnwZxkiIBzV0ovd2NKRkmAKcDYdERgAdvaeYdMoA_1784725529
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


