Return-Path: <linux-erofs+bounces-4314-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E5DC5DF9B
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDFX58GZz2y8f;
	Tue, 25 Aug 2026 00:44:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582656;
	cv=none; b=T2lEIqQYcS1AxTybxr8CRnvfYPNzjat3vR69AoQpfU/fKu5tLHdyT0S8EagxhmoShw5JFugSljJIzGpPbWFYHOAGpBCbKTXckfaFC5Z6fuHZ35rjALBH0idTgXK9gpEffIzKmzqDmsPcCrNNY2X9zaOd25ZUZlvpzAZ0yDLocP0lhrZoig29XVtS4ExY8ograTOiUc52UmkMW32JJdagpvN93yVyGmhFqGrsIdg76ZVb6+RJjDOD5TNV91QwnZ+bmaYvfs3DtxRJkIPJKj1iATbCDQUqU0SkoPDywymn8sYiPPsdgFuMJRQTGLIk5jOwEANcRCjiwFZOu2K2Dp4MfA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582656; c=relaxed/relaxed;
	bh=GsV/bFz2jJW8aQ9QDHq6eP6PICyJaBwOdY5nB5MwmFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VX4yqjUR+9fRW18U8qlHv3kqBkbvVxUMr60n/RbN4FROKEEPEAqSrCqFPjsui7AsrTh5EiCoT/Elanam1/muDs1FyPL1rbJsim9TkYaS9tJdrLgS9beIg7IEIs4iiUrhW4WdNv4s/kfGtqGhTd/pmoV5WT9xsXq+WtG2RU+PIwtiyRkUScmjTFyag/CrAR7IAxfAT/q0zju6jrCF9VqyrtMT5ktt3USynZmS3HWN43OXXIFH90WGe6UN1GCwFSAnNUfnagEoPvLrg68fX5KGql28nIpEwDPNGwx1X6FadpEYbUjcxyskt1rn6i2vYRTo9B4Fe/OZ7HwOIITBCZr2lA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Kengksoh; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V8rzaDSZ; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Kengksoh;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V8rzaDSZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDFW4trFz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:44:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GsV/bFz2jJW8aQ9QDHq6eP6PICyJaBwOdY5nB5MwmFQ=;
	b=KengksohncuWmkjQ1WuBI5Jvar0lXdcJ2Mn6BKD+uaeRypaYt72ufZRf2DG/0lzZd+Rg7X
	3cEHY0YgeoBYfyoR1ksKEhBOYVZf0Edl4z8AYE+wKd0cwgZOmHNXkpgWpWWtLmd2TSbk9V
	n39BnTQ9CiXhp/QaSciQQu+pB/Ox1nU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GsV/bFz2jJW8aQ9QDHq6eP6PICyJaBwOdY5nB5MwmFQ=;
	b=V8rzaDSZAnl9OOlV2GZ2vVo82V7Gz3FeFhuDyyVJQWGjmhPTYzaNeKkbdADtmaKzNS8q+j
	WZUTbcC/H65RiBE1tMFzS9+4Gq9fMp8/FqNFKSxWbQUMPUZFIjXFasFEtePECA40rVr2JT
	WFTMvqyFEPb3+/wSuGf5VZbkTms/35c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-il2AEd3LOgO99_tafAfVnQ-1; Mon,
 24 Aug 2026 10:44:07 -0400
X-MC-Unique: il2AEd3LOgO99_tafAfVnQ-1
X-Mimecast-MFC-AGG-ID: il2AEd3LOgO99_tafAfVnQ_1787582639
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEA9C19540E4;
	Mon, 24 Aug 2026 14:43:58 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 373967D9;
	Mon, 24 Aug 2026 14:43:51 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v10 16/35] smbdirect: Support ITER_BVECQ in smbdirect_map_sges_from_iter()
Date: Mon, 24 Aug 2026 15:41:09 +0100
Message-ID: <20260824144130.759997-17-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: PsFUlsDxuP-Kru1OXvDQBOpo8Z-CWcv60bYwYRzD-vs_1787582639
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add support for ITER_BVECQ to smbdirect_map_sges_from_iter().

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Stefan Metzmacher <metze@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Namjae Jeon <linkinjeon@kernel.org>
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


