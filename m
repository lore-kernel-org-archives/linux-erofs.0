Return-Path: <linux-erofs+bounces-4441-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0702C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 17:36:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZqdt33mjz2y2W;
	Thu, 03 Sep 2026 03:36:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788370578;
	cv=none; b=ZqIOk7SvLftQNDl4SqtKHpcMHTYfgX0o3Tjvsk8jOq5DkRZCejmcgvep9QP/pB/SpTciR0w0s3u82Wpm0WM2zNJhUq/BIGXwf4amP298P6mRzuNU9NntgvqzgBHfGRo9z9212a843GTMceWSKoWv/QO/0Bg6NWW9ssJH99E9hdRr1KLKWcL23cApBq/q/f1wLu017sIK90AUNU4fAtsbndBDp7O1iUdv1K8PREA2NXT1BbCmSGYqb2YsI0WJKwpkBKcdnqzvox/tzFV6ShUlM1uyq0HPPKKBR88CBH7e2PVMpR9ujGT7tQAHf2IcJGax4pnT9Tk9CidSY9d4ygYZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788370578; c=relaxed/relaxed;
	bh=uXcxisGkFr00fA1HSGINsqvSECkN1n0sGU0Y/DRd/g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=MBI59v0/Y2I7YOITkICqk4dB+I7odJlaQW9E/B8Eg7bu7v6BH09AgMn/0a+vPJMm6S9Oijds8V4kGHA0FWjRwPcgKd9qUvvKoVG0iDS8U6HbRD55UBQ4hjoOc/7kmaN9Nw/+VfyjAhAl9QsXfzsNeOE8HSuB+3nBe9PKpKT4+QOdMNjMPqAWkyGFPwQzaUdeWceoeFn2oNtwIMQDl712h/lWxvC4vi3WiPy1pPFORuaD+t8neHYvrIe5RqGXgvjjMsKB+s9aS/kylkidyEstbs2EI2/9XVkVKCFdQq6TSq4jypoZyjsjzlM72akY8JoV/wDWyMwlnlPwKpjGmPWtNA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WbMxZhZT; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zi9pAzwO; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WbMxZhZT;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zi9pAzwO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZqds2KYmz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 03:36:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXcxisGkFr00fA1HSGINsqvSECkN1n0sGU0Y/DRd/g8=;
	b=WbMxZhZTlmdP34CgGUD/n+b1HQ0d6k1/ETBRJAjR2jMhWie3PKS3PvijiwlnSdpXBQEKJ6
	AvLDZC40BTD9bpRasg/LbOPosKgYzEX5t+HHw+XX7P28U3KY1Vh2xaSlrBd3Qb5Q19QBTE
	6ru/Op/CnIzgq/zCHIxgBKtl1zyc7Rg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXcxisGkFr00fA1HSGINsqvSECkN1n0sGU0Y/DRd/g8=;
	b=Zi9pAzwOOc+MPMHh22xIc87ynqtRIrh6sHEyGlH7OyV0uB9WTvc2rW64fPmdZ5wvFUwaO7
	j/pL+OsuZnsvPOQrqMnZilEiSSSfz9oJP4yxZlxXg4RyPWO9xOVxB7gpU8HpfeZ7n/te6m
	RXxaLdxm1wHtkF+s0Wq/tBhmkR5wtDU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-nP4nQ_fgMVOBaAxc4_M2YA-1; Wed,
 02 Sep 2026 13:36:09 -0400
X-MC-Unique: nP4nQ_fgMVOBaAxc4_M2YA-1
X-Mimecast-MFC-AGG-ID: nP4nQ_fgMVOBaAxc4_M2YA_1788370567
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E47EA1800990;
	Wed,  2 Sep 2026 17:36:06 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BCF9279;
	Wed,  2 Sep 2026 17:36:00 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 15/36] netfs: trace: Change the "clear" folio traces to "endwb"
Date: Wed,  2 Sep 2026 18:33:27 +0100
Message-ID: <20260902173350.3468672-16-dhowells@redhat.com>
In-Reply-To: <20260902173350.3468672-1-dhowells@redhat.com>
References: <20260902173350.3468672-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 8uewN_5b9fCmKMretIgSQTGy-XOSJp4_FBGF_fgeUYQ_1788370567
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Change the "clear" folio traces to "endwb" as it's more obvious what it
means.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_collect.c     | 8 ++++----
 include/trace/events/netfs.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index c92aba14a0b5..ba2327ce96e8 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -107,7 +107,7 @@ static void netfs_dump_request(const struct netfs_io_request *rreq)
  */
 int netfs_folio_written_back(struct folio *folio)
 {
-	enum netfs_folio_trace why = netfs_folio_trace_clear;
+	enum netfs_folio_trace why = netfs_folio_trace_endwb;
 	struct inode *inode = folio_inode(folio);
 	struct netfs_inode *ictx = netfs_inode(inode);
 	struct netfs_folio *finfo;
@@ -130,13 +130,13 @@ int netfs_folio_written_back(struct folio *folio)
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
@@ -149,7 +149,7 @@ int netfs_folio_written_back(struct folio *folio)
 		if (!folio_test_dirty(folio)) {
 			folio_detach_private(folio);
 			gcount++;
-			why = netfs_folio_trace_clear_g;
+			why = netfs_folio_trace_endwb_g;
 		}
 	}
 
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 1c99fa753fe8..f69cac698f74 100644
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


