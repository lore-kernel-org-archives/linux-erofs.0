Return-Path: <linux-erofs+bounces-4500-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC27C79FA0
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 09:11:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfJ8T0wMhz2yln;
	Tue, 08 Sep 2026 19:11:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788858681;
	cv=none; b=hczzkk0jwlwjPZER7Y+DXUMfaJV6L5wsnD1Mm6BqA3p9CCJTvaP85y6XKlRx0E3YTMgO2KfWT0Jyj7R14Ko9PD9myyJ2z5Ed7DrHkRnrcWUCwiqx7/iUfDMKnyqDKNcDfvgFsV7WkvUyo2fy/R1EQf48MApywL4IyLYqL9WSLwIW4RfShts7mvFOL8CcLM4wZ67c+rDlQHReCK7GRhZcz0Q6G0FAciUcFX2KZ8gMQLHqNv76E4nuz0jNDAgSTs4KgvXmJxrODXUXzNQVOaphnAn2PEPT86k1SaejBme8J/n+j+y1hUiHt0M4TQdN/Ry/zvYTzHEgdAPqKKyxbY3ufw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788858681; c=relaxed/relaxed;
	bh=DslwRdsu/8tTWOlVJvkd0gqMqXh0L3cVibDrCzgiQjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=dQtFmryNAcilpkZSWYv9hJmlpkXrSUx2+eufAkztQFEd9PsDnSjubjIjSv4ubMLOTHTefOQQ1B0bWW9PbIPzlo5F2xeLxKS7kxquYuQCTLHOhfpucl9vLz6gRMDrDI/qzKlyinUotDpyXKTqOvUIoHmi6eaO2P0D3hfsxpOhtJPvALdYwPmYG/u5lqHxYRjvztitjebEOJrYYkeCcPzdC9G2slYxDQM8ARrS75/J054FEL4qwI5fipPfb/AKvenB0hYX3X/sUOikcU+XcZCsLbf9WTyc1o1n2GPGoXlE0y67PpQMDPwZ9gDdmjKNq/Jr/i0nPtBzmxxzMC0fb8fcnQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WNnFhZmY; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DhW6K0Yj; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WNnFhZmY;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DhW6K0Yj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfJ8S0htBz2y8d
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 19:11:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788858676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DslwRdsu/8tTWOlVJvkd0gqMqXh0L3cVibDrCzgiQjo=;
	b=WNnFhZmYadN6WwKXn16an/G11HjCxkQIIKhi36IQ6xGDHAui7SG+fsfyfTWC8A6J2G/QuE
	tHDj3QqSkVAmrHnlQtYzFd7W2S2gp1KeQvKRB9mtEKmRotM1XKbz+xCeDRUxqOVovp1Boe
	xqRrm55miZU2ypmFtquZf62PXmMcAiA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788858677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DslwRdsu/8tTWOlVJvkd0gqMqXh0L3cVibDrCzgiQjo=;
	b=DhW6K0YjHLTf/epDIPvmSTl7ZnynGfliPbs9HKl+K08bpeS/ExcQ/OmfDMd0MbEUaB0P38
	hREzaY8wy6XHVGLwuNTfjbMEWhw+4wmn1aPPhfdb6JMmN20OOznJa+PJ+ScBI1EWaom/7X
	qlfFaB3L/vQqC/HxXWZYWIrY5kWE9Nc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-215-6qvyyVzNPoy5lIqG0rbmaQ-1; Tue,
 08 Sep 2026 05:11:10 -0400
X-MC-Unique: 6qvyyVzNPoy5lIqG0rbmaQ-1
X-Mimecast-MFC-AGG-ID: 6qvyyVzNPoy5lIqG0rbmaQ_1788858668
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8A4E195DBA6;
	Tue,  8 Sep 2026 09:11:07 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2CFE030002ED;
	Tue,  8 Sep 2026 09:11:00 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
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
Subject: [PATCH v12 3/8] netfs: trace: Change the "clear" folio traces to "endwb"
Date: Tue,  8 Sep 2026 10:10:24 +0100
Message-ID: <20260908091031.1506798-4-dhowells@redhat.com>
In-Reply-To: <20260908091031.1506798-1-dhowells@redhat.com>
References: <20260908091031.1506798-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: j8BsY0WCHEzi3LBBU2tfS4x9g-mKPHU6Q4ELbnGwWVM_1788858668
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Change the "clear" folio traces to "endwb" as it's more obvious what it
means.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_collect.c     | 8 ++++----
 include/trace/events/netfs.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 244a68e04624..6114bdf27ce0 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -56,7 +56,7 @@ static void netfs_dump_request(const struct netfs_io_request *rreq)
  */
 int netfs_folio_written_back(struct folio *folio)
 {
-	enum netfs_folio_trace why = netfs_folio_trace_clear;
+	enum netfs_folio_trace why = netfs_folio_trace_endwb;
 	struct inode *inode = folio_inode(folio);
 	struct netfs_inode *ictx = netfs_inode(inode);
 	struct netfs_folio *finfo;
@@ -79,13 +79,13 @@ int netfs_folio_written_back(struct folio *folio)
 		group = finfo->netfs_group;
 		gcount++;
 		kfree(finfo);
-		why = netfs_folio_trace_clear_s;
+		why = netfs_folio_trace_endwb_s;
 		goto end_wb;
 	}
 
 	if ((group = netfs_folio_group(folio))) {
 		if (group == NETFS_FOLIO_COPY_TO_CACHE) {
-			why = netfs_folio_trace_clear_cc;
+			why = netfs_folio_trace_endwb_cc;
 			folio_detach_private(folio);
 			goto end_wb;
 		}
@@ -98,7 +98,7 @@ int netfs_folio_written_back(struct folio *folio)
 		if (!folio_test_dirty(folio)) {
 			folio_detach_private(folio);
 			gcount++;
-			why = netfs_folio_trace_clear_g;
+			why = netfs_folio_trace_endwb_g;
 		}
 	}
 
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index ef1185993ba4..2491a0bc4179 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -192,11 +192,11 @@
 	EM(netfs_folio_trace_alloc_buffer,	"alloc-buf")	\
 	EM(netfs_folio_trace_cancel_copy,	"cancel-copy")	\
 	EM(netfs_folio_trace_cancel_store,	"cancel-store")	\
-	EM(netfs_folio_trace_clear,		"clear")	\
-	EM(netfs_folio_trace_clear_cc,		"clear-cc")	\
-	EM(netfs_folio_trace_clear_g,		"clear-g")	\
-	EM(netfs_folio_trace_clear_s,		"clear-s")	\
 	EM(netfs_folio_trace_end_copy,		"end-copy")	\
+	EM(netfs_folio_trace_endwb,		"endwb")	\
+	EM(netfs_folio_trace_endwb_cc,		"endwb-cc")	\
+	EM(netfs_folio_trace_endwb_g,		"endwb-g")	\
+	EM(netfs_folio_trace_endwb_s,		"endwb-s")	\
 	EM(netfs_folio_trace_filled_gaps,	"filled-gaps")	\
 	EM(netfs_folio_trace_invalidate_all,	"inval-all")	\
 	EM(netfs_folio_trace_invalidate_front,	"inval-front")	\


