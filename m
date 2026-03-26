Return-Path: <linux-erofs+bounces-3030-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26B210A1E65
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Mar 2026 10:48:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhL9R3jqhz2ygp;
	Thu, 26 Mar 2026 21:48:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774522123;
	cv=none; b=PuJbBJxrU5S+7HjTNY7h6EMZ/OVnldNFXMSqzRJ1mnbOQXNZvQSF0c2q0OATVvgnNQp9WuWehFC47Dkjl/96SNKAFAlND9L7K7PBzoG6+5EssOn5orYBPdlfiyb4Z/JJiVMUk+DYVExQLC4TO1v1XzEd0fOLMFWmN1bf1ZQ8r0wG0KG4+ARcVUSbCtRqxpI0g9Bo8Vln4eLnNZvVyxGdCrbR1OAW+DMBe83uY/GM5wt9o77MaeAIPQKo99dZaPa1iaMcY58lVj41eqPnc+vNv48+Zbi1XIi1OKRn7H58joUGDvKRasz6L67V1QHzWw0e6h4XdM9mwlpD1Whsco3AQg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774522123; c=relaxed/relaxed;
	bh=eMP9bnV0yq18QtXiFKmTkxFw+bIJoptINTzT8/zA4D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Exj1+qe2sKjUfO62SURl+EIUg1zythJoXCcfWOFJnyq5s7pKHU6VHBY8OdBQ6Frv0Fm4ki8RopLJmc8ZxoRtJ2P0FI1+87l0Chx6L9OBgiS+OWiAnZwnIAhaLjDfYSAg/xQHbo6s6hf/7WGZaeOIdEat/DxriHnkfyDroE85hQ0wgsK7QZZBsjC/h5fFiUJQ9KjyFW+ih634dmP0Vm8qGkMl0L0FYmF2l9u9ABQGstx5IPQ0qk9z6FxqqkncOYVUxry6yyuQrUqvvGYDb5e8HUQZZ2QoPxmA3MLgpFDsckFL+WwxzEMGBYFQ1b5P2AUmh4cjuyz0yOA7pgEs2UpkmA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iaojWgWS; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iaojWgWS; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iaojWgWS;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iaojWgWS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhL9Q53skz2yd7
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 21:48:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eMP9bnV0yq18QtXiFKmTkxFw+bIJoptINTzT8/zA4D0=;
	b=iaojWgWS0k0oGJ3Sqtp9GwckP4JvvJDoAuDlfUvYPQY1EeS7F/CawFHBtjVuEFd+VLbsWu
	7+yTMXeSwuhzqpcYWbnN0ZkLtMUyKCi6qQ+7vJMeAInjpKE6FzwuGOq6NuPSFTrnkyypte
	/vh/EiI+eZrbtwGH+OQVuatB+y8jhtE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eMP9bnV0yq18QtXiFKmTkxFw+bIJoptINTzT8/zA4D0=;
	b=iaojWgWS0k0oGJ3Sqtp9GwckP4JvvJDoAuDlfUvYPQY1EeS7F/CawFHBtjVuEFd+VLbsWu
	7+yTMXeSwuhzqpcYWbnN0ZkLtMUyKCi6qQ+7vJMeAInjpKE6FzwuGOq6NuPSFTrnkyypte
	/vh/EiI+eZrbtwGH+OQVuatB+y8jhtE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-a-gXVbOYNM-z_sxtwygWsw-1; Thu,
 26 Mar 2026 06:48:36 -0400
X-MC-Unique: a-gXVbOYNM-z_sxtwygWsw-1
X-Mimecast-MFC-AGG-ID: a-gXVbOYNM-z_sxtwygWsw_1774522114
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F17C6180049D;
	Thu, 26 Mar 2026 10:48:33 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.121])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 218C219560B1;
	Thu, 26 Mar 2026 10:48:26 +0000 (UTC)
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
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 17/26] cifs: Support ITER_BVECQ in smb_extract_iter_to_rdma()
Date: Thu, 26 Mar 2026 10:45:32 +0000
Message-ID: <20260326104544.509518-18-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Ad_QVbu6rasUBpS_qCGK6LzRDyJzvTWRHR-DHSgXTnw_1774522114
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add support for ITER_BVECQ to smb_extract_iter_to_rdma().

Signed-off-by: David Howells <dhowells@redhat.com>
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
 fs/smb/client/smbdirect.c | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c79304012b08..f8a6be83db98 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -3298,6 +3298,63 @@ static ssize_t smb_extract_folioq_to_rdma(struct iov_iter *iter,
 	return ret;
 }
 
+/*
+ * Extract memory fragments from a BVECQ-class iterator and add them to an RDMA
+ * list.  The folios are not pinned.
+ */
+static ssize_t smb_extract_bvecq_to_rdma(struct iov_iter *iter,
+					 struct smb_extract_to_rdma *rdma,
+					 ssize_t maxsize)
+{
+	const struct bvecq *bq = iter->bvecq;
+	unsigned int slot = iter->bvecq_slot;
+	ssize_t ret = 0;
+	size_t offset = iter->iov_offset;
+
+	if (slot >= bq->nr_slots) {
+		bq = bq->next;
+		if (WARN_ON_ONCE(!bq))
+			return -EIO;
+		slot = 0;
+	}
+
+	do {
+		struct bio_vec *bv = &bq->bv[slot];
+		struct page *page = bv->bv_page;
+		size_t bsize = bv->bv_len;
+
+		if (offset < bsize) {
+			size_t part = umin(maxsize, bsize - offset);
+
+			if (!smb_set_sge(rdma, page, bv->bv_offset + offset, part))
+				return -EIO;
+
+			offset += part;
+			ret += part;
+			maxsize -= part;
+		}
+
+		if (offset >= bsize) {
+			offset = 0;
+			slot++;
+			if (slot >= bq->nr_slots) {
+				if (!bq->next) {
+					WARN_ON_ONCE(ret < iter->count);
+					break;
+				}
+				bq = bq->next;
+				slot = 0;
+			}
+		}
+	} while (rdma->nr_sge < rdma->max_sge && maxsize > 0);
+
+	iter->bvecq = bq;
+	iter->bvecq_slot = slot;
+	iter->iov_offset = offset;
+	iter->count -= ret;
+	return ret;
+}
+
 /*
  * Extract page fragments from up to the given amount of the source iterator
  * and build up an RDMA list that refers to all of those bits.  The RDMA list
@@ -3325,6 +3382,9 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
 	case ITER_FOLIOQ:
 		ret = smb_extract_folioq_to_rdma(iter, rdma, len);
 		break;
+	case ITER_BVECQ:
+		ret = smb_extract_bvecq_to_rdma(iter, rdma, len);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;


