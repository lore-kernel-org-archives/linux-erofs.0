Return-Path: <linux-erofs+bounces-4120-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D9BC55172
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 10:04:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDpzr1z5zz2yMl;
	Tue, 04 Aug 2026 20:04:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785837864;
	cv=none; b=Irvc4qIEeKBi2XJc7poStAo2UqCocbqAUsfLjs4Wkv7UkFkf5SPPj1tDqNJiSHdZ9YR2DcQY3mFMqviG64NHJN7RsYEEpd4Sxa7zEf5M6uYCORf97UVoBDTYBzc5ffb8Wo5car4BgcO01PiFxZ114b9ObIFRD72yeabP0dZFeg7bLpjIhAsSGWslmr9xZhTnxGzL8833iGReoeXSNzU4HYCvHiEkV77wNDbfK3mmbaEFZS+Gkk6Ib/758liko9ct1YL5lGdXqK89TgAtaspnc492fT/MwdWt8RZP7eKSTNJo8UbOufQ7mZhYkvB9r+AC9Ig1DNPiBjlT7aHLJBb4sA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785837864; c=relaxed/relaxed;
	bh=Mi6aeoMT9xaXVA4O3DA9ScLWnT8a4KHMBpulrvNzWqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=D/7iPtC/WzoTCEWIjnrF+gpXdGYfscw8wa/wl0XglD+WPJD/12lmZpNI2zPBrmW7C1iBNZEYWgyj8VyTm0kwLKDPRNe169LzTaQS4vBmscWxRaN050dMcpCLsrLa5FaRIvUhZiTVbAoibYjPJMoab43fErrnxq9GiBwVanKfWjZ9zZC3fdzu2NrQU+Wf7H9PkpHpVFKJODVI37Jfl2KqjcyIY+rQbaMUum847D3hPbgQ9DKAMty1aCi10xSyFSdvm9rjjB29jWwxIt5UkijjOKOfNVNqzFZsAOxs5DwXlwgyxTyNqfLW4urnVUNDhlHerN4+1e3OoszwUcbLQNwODg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=A1Oo+ueW; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eWKy7L7v; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=A1Oo+ueW;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eWKy7L7v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDpzq2Tgmz2xpn
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 20:04:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785837859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mi6aeoMT9xaXVA4O3DA9ScLWnT8a4KHMBpulrvNzWqI=;
	b=A1Oo+ueWdj5/Uks2wnXeH+H787HLvN8k4fV73ss658zXIAooOQPC5+f8XWH5OfY2/JFa6/
	J+FRIOcwz2XomthrpDgzfbysh4PBGZx0oVivm1jAHxiuZ5jRYSWXbqpUkLXh0BtBR0/zip
	FGykbf0Ww8CwoUBArMFk+wAByIK7gTs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785837860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mi6aeoMT9xaXVA4O3DA9ScLWnT8a4KHMBpulrvNzWqI=;
	b=eWKy7L7v0NCaQxYIL3qKUtq8UGe+adTewMf+cpmElfaTAnLx+gAVKsaCARWbp54rGRIPyp
	XygWOmpR06hn6L730iseshbnm4sgYOwvMJanHbu7233XuA8bJoLCTDFihU7mE6kaAd4ZXX
	Codfejle71mr0ohpdgg1w1uGOJy4vzk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-Tt7vrssfPwWXrCWw5IYGBw-1; Tue,
 04 Aug 2026 06:04:13 -0400
X-MC-Unique: Tt7vrssfPwWXrCWw5IYGBw-1
X-Mimecast-MFC-AGG-ID: Tt7vrssfPwWXrCWw5IYGBw_1785837850
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE8A818002CC;
	Tue,  4 Aug 2026 10:04:10 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3ED361956087;
	Tue,  4 Aug 2026 10:04:04 +0000 (UTC)
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
Subject: [PATCH v8 11/25] smbdirect: Support ITER_BVECQ in smbdirect_map_sges_from_iter()
Date: Tue,  4 Aug 2026 11:02:06 +0100
Message-ID: <20260804100224.2748935-12-dhowells@redhat.com>
In-Reply-To: <20260804100224.2748935-1-dhowells@redhat.com>
References: <20260804100224.2748935-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: hgFkq93xSPdwais_5nE7d2FZuQB5TCSThdW0a0sBzdk_1785837850
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
 fs/smb/smbdirect/connection.c | 67 +++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index 8adf58097534..f5e7e75dd809 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -5,6 +5,7 @@
  */
 
 #include "internal.h"
+#include <linux/bvecq.h>
 #include <linux/folio_queue.h>
 
 struct smbdirect_map_sges {
@@ -2006,6 +2007,69 @@ static ssize_t smbdirect_map_sges_from_bvec(struct iov_iter *iter,
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
+	const struct bvecq *bq = iter->bvecq, *next;
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
+			next = bvecq_next(bq);
+			if (!next) {
+				if (WARN_ON_ONCE(maxsize > 0))
+					return -EIO;
+				goto out;
+			}
+			bq = next;
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
@@ -2155,6 +2219,9 @@ static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 	case ITER_BVEC:
 		ret = smbdirect_map_sges_from_bvec(iter, state, len);
 		break;
+	case ITER_BVECQ:
+		ret = smbdirect_map_sges_from_bvecq(iter, state, len);
+		break;
 	case ITER_KVEC:
 		ret = smbdirect_map_sges_from_kvec(iter, state, len);
 		break;


