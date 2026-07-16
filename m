Return-Path: <linux-erofs+bounces-3912-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9C6C44501
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jul 2026 10:32:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h18W21b6Gz30C6;
	Thu, 16 Jul 2026 20:32:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784197950;
	cv=none; b=IgPiG1grBehk5VWOqwVk4I1q6E5Xg1BBFVpLgh1JFL77k//l/GeVuUm4M7ZY1RlO3ERHj5deDv8jMXm9srgiWzyuVtSWKCpT4f6uKIaBSQ8/t6olIwUPLjGOv42oa9lf0ovN2K99troHQ7lzkXnBa8zzX95aeeJip+O2rK0UlBV8WLf0r2B3SeNXUPWbs+0RVuNyEBCU+QG2xh39PuuN/rHf0DsH+0nwinqrW991OyEtlRJe6YQjSZGczS2o/G7Y56E69FyvfFNQMcSfty2nysiptbePdUoTCZ8QvfmTs/UVhm/Ao3ldsHzf5E7WQiXme7g+zzDOHCD0ZV9Yk+cj2w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784197950; c=relaxed/relaxed;
	bh=TC7u1wJqNrRG8z8GLvvATlIZdgquMp2P+436mVi2G3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=FtU9CeWFHNNd1HEvpxMa47BiFrXaygxSXEJ9LR39R8YxSifwvKS3U+Qlpxgn9/OjwOVClsm8uM4TwbszkegGZ2QFZ/aV1aDr7eG5lXupSR8PiqN7J7sNhkRTUzTT/+y/hlyrDarPwWosZLBnPvULZAR1sjDc1fXXdC2JjCGAzYbtDaG8Ia0SsJFWiG7p0AIIxh50FbETl4OpyOR9MX3pc4KjYpXkEieoUlmN+pEaVkQGTwMEMeo3VM2tTj5FNBJK/5UblJtAbEYX2xP1nEo3jTyhgsDXabOu0gkCBA8suR8njaY9vyrJebCEpWIY3EnEQJsqvNzxKIn0duyog/sxtw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LPQCleRh; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LPQCleRh; dkim-atps=neutral; spf=permerror (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LPQCleRh;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LPQCleRh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h18W125kmz2y8F
	for <linux-erofs@lists.ozlabs.org>; Thu, 16 Jul 2026 20:32:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TC7u1wJqNrRG8z8GLvvATlIZdgquMp2P+436mVi2G3I=;
	b=LPQCleRhWLCjYvlVNLkMtT7jEV9d+uOlbylSD2QYzmmNQOhwK2X0FsoSt9y+snDbDzr0QY
	LmvkgVg7OfCjnYdAv3iW0thzCRV8ETyLJAKoOl6G2/L7baAzZ4iHrIASjWL1OAfdLGnl8F
	w03RtgsZ9Wz8WSZ+boUoMUFvYdiuVQI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TC7u1wJqNrRG8z8GLvvATlIZdgquMp2P+436mVi2G3I=;
	b=LPQCleRhWLCjYvlVNLkMtT7jEV9d+uOlbylSD2QYzmmNQOhwK2X0FsoSt9y+snDbDzr0QY
	LmvkgVg7OfCjnYdAv3iW0thzCRV8ETyLJAKoOl6G2/L7baAzZ4iHrIASjWL1OAfdLGnl8F
	w03RtgsZ9Wz8WSZ+boUoMUFvYdiuVQI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-gG-u_WZAM1GRnOj1UfxImQ-1; Thu,
 16 Jul 2026 06:32:20 -0400
X-MC-Unique: gG-u_WZAM1GRnOj1UfxImQ-1
X-Mimecast-MFC-AGG-ID: gG-u_WZAM1GRnOj1UfxImQ_1784197938
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1DAD1954B27;
	Thu, 16 Jul 2026 10:32:17 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BAA61800347;
	Thu, 16 Jul 2026 10:32:11 +0000 (UTC)
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
Subject: [PATCH v6 11/24] smbdirect: Support ITER_BVECQ in smbdirect_map_sges_from_iter()
Date: Thu, 16 Jul 2026 11:30:10 +0100
Message-ID: <20260716103030.3065561-12-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 8nkV24mlnNAgUuLodjf02xaMi1GSElGZNWdp8olc_5I_1784197938
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add support for ITER_BVECQ to smbdirect_map_sges_from_iter().

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Stefan Metzmacher <metze@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/smbdirect/connection.c | 66 +++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index 8adf58097534..4d2a1700104e 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -5,6 +5,7 @@
  */
 
 #include "internal.h"
+#include <linux/bvecq.h>
 #include <linux/folio_queue.h>
 
 struct smbdirect_map_sges {
@@ -2006,6 +2007,68 @@ static ssize_t smbdirect_map_sges_from_bvec(struct iov_iter *iter,
 	return ret;
 }
 
+/*
+ * Extract memory fragments from a BVECQ-class iterator and add them to an RDMA
+ * list.  The fragments are not pinned.
+ */
+static ssize_t smbdirect_map_sges_from_bvecq(struct iov_iter *iter,
+					     struct smbdirect_map_sges *state,
+					     ssize_t maxsize)
+{
+	const struct bvecq *bq = iter->bvecq;
+	unsigned int slot = iter->bvecq_slot;
+	ssize_t extracted = 0;
+	size_t offset = iter->iov_offset;
+
+	maxsize = umin(maxsize, iov_iter_count(iter));
+
+	do {
+		struct bio_vec *bv;
+		size_t bsize;
+
+		while (slot >= bq->nr_slots) {
+			if (!bq->next) {
+				if (WARN_ON_ONCE(maxsize > 0))
+					return -EIO;
+				goto out;
+			}
+			bq = bq->next;
+			slot = 0;
+		}
+
+		bv = &bq->bv[slot];
+		bsize = bv->bv_len;
+
+		if (offset < bsize) {
+			size_t part = umin(maxsize, bsize - offset);
+			bool ok;
+
+			ok = smbdirect_map_sges_single_page(state,
+							    bv->bv_page,
+							    bv->bv_offset + offset,
+							    part);
+			if (!ok)
+				return -EIO;
+
+			offset += part;
+			extracted += part;
+			maxsize -= part;
+		}
+
+		if (offset >= bsize) {
+			offset = 0;
+			slot++;
+		}
+	} while (state->num_sge < state->max_sge && maxsize > 0);
+
+out:
+	iter->bvecq = bq;
+	iter->bvecq_slot = slot;
+	iter->iov_offset = offset;
+	iter->count -= extracted;
+	return extracted;
+}
+
 /*
  * Extract fragments from a KVEC-class iterator and add them to an ib_sge list.
  * This can deal with vmalloc'd buffers as well as kmalloc'd or static buffers.
@@ -2155,6 +2218,9 @@ static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 	case ITER_BVEC:
 		ret = smbdirect_map_sges_from_bvec(iter, state, len);
 		break;
+	case ITER_BVECQ:
+		ret = smbdirect_map_sges_from_bvecq(iter, state, len);
+		break;
 	case ITER_KVEC:
 		ret = smbdirect_map_sges_from_kvec(iter, state, len);
 		break;


