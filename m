Return-Path: <linux-erofs+bounces-4316-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06232C5DF94
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDFl2jkRz2yCL;
	Tue, 25 Aug 2026 00:44:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582667;
	cv=none; b=HouNcRkIlv+vJIRjIXexJyZBiNAdqVMH8f1YDAozKlSQLuayHi2UM3WmnfwmA9gHeN1J+MwUk7rhxNngsQFwvnGHE36R31mh/k7bO5au1J9HKH4SjMxiVRjcrthpyGQWzaf/Jgh9VujiLhnJ0udYemcVCtUU4/LWyoahPo6uZcTaqCaA7g/iJe5849ZQ95WuS0cnPvDZCTn3oq0QfYfnbC3j532E3WIy0TO5N1TQPz0HGFg3xAu36gceUCPzcB5QBqu+MiuJjfMwGnVmsuEe9pneh2M4JD74MDrzJ4aZsN+4iSLBsdjBzT+LkZDFXgV7yt48hH/IGbxY+wi7sUULxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582667; c=relaxed/relaxed;
	bh=b7baYKQZt0ba2opPjrSbjLhJKMY6G3aHST2hZ7+P0Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=E8CO/ia02nNt52uWs/DYHttpZqk3CTZey/B/CGHDjo20ngdLu7f0IV6+mfgL18a+aCgfda97q0deE0MgP/SrAsLlaS99liMW3NtYU1cwbAPayi0I0I3TOsO5hT3TBcln4tXZunZzpVmfQZKtv+fvJhaEJLVuLDTjGProvUR1EX/9rRLpS4cLoT69el55vYlSOhHkjEPaNmD2nd9sYVxrzUPZqR5/nnYZ1EkHAyfcLi/7zUmwBUhWjV4pGWl4as1j1kodSL0djTbKIXLp28t2g1XEM0hogZpnN4mBWGxkaAMTTz4VfQCaS+zwAjc7mYRlvrCKlgyVwDxIYWtjqwNiNQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cIrbTAG/; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XnYRTiaf; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cIrbTAG/;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XnYRTiaf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDFk23T6z2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:44:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b7baYKQZt0ba2opPjrSbjLhJKMY6G3aHST2hZ7+P0Gc=;
	b=cIrbTAG/bqyhH/3GkGb/tOwY0/OUlvYwBOniQBNATEBF8pHFaaXNRQ0SC+TNiK1eJeMjcK
	5im8yDlkeToO25KgZbFgXufF4yHw2Egk6/K1s0YZW+b/YA9+PK5rCpOGxTIvPXcboYmrNn
	gGeeZbHBFtCENtIqMubDot7ZPaEMTwA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b7baYKQZt0ba2opPjrSbjLhJKMY6G3aHST2hZ7+P0Gc=;
	b=XnYRTiaf+6OOONsagGunnaMJTpYqS84/q2i2bmi88VfQBwO1Kq3e/Qlb9tEGcmdOTNZq+/
	66STwisf3aw7TFIaIXqx8LLJoc5EMEWMJglOZC0jXO2+5WmKUwZ5q4xKNYnOa4ghP5BiLI
	4U12giQiBuO6H79sg929MhlYenso53g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-1-BPFk5QKYNyq37mSpxfkupA-1; Mon,
 24 Aug 2026 10:44:17 -0400
X-MC-Unique: BPFk5QKYNyq37mSpxfkupA-1
X-Mimecast-MFC-AGG-ID: BPFk5QKYNyq37mSpxfkupA_1787582654
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D892180AE34;
	Mon, 24 Aug 2026 14:44:14 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 347D230002ED;
	Mon, 24 Aug 2026 14:44:07 +0000 (UTC)
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
Subject: [PATCH v10 18/35] netfs: trace: Change the "clear" folio traces to "endwb"
Date: Mon, 24 Aug 2026 15:41:11 +0100
Message-ID: <20260824144130.759997-19-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Y_YUeLnhPo5tPsr3dPsfuEk5fH6qr9hPfVn1ZcI02kg_1787582654
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
index ccb9f3c30432..e23300c56d00 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -192,12 +192,12 @@
 	EM(netfs_folio_trace_alloc_buffer,	"alloc-buf")	\
 	EM(netfs_folio_trace_cancel_copy,	"cancel-copy")	\
 	EM(netfs_folio_trace_cancel_store,	"cancel-store")	\
-	EM(netfs_folio_trace_clear,		"clear")	\
-	EM(netfs_folio_trace_clear_cc,		"clear-cc")	\
-	EM(netfs_folio_trace_clear_g,		"clear-g")	\
-	EM(netfs_folio_trace_clear_s,		"clear-s")	\
 	EM(netfs_folio_trace_copy_to_cache,	"mark-copy")	\
 	EM(netfs_folio_trace_end_copy,		"end-copy")	\
+	EM(netfs_folio_trace_endwb,		"endwb")	\
+	EM(netfs_folio_trace_endwb_cc,		"endwb-cc")	\
+	EM(netfs_folio_trace_endwb_g,		"endwb-g")	\
+	EM(netfs_folio_trace_endwb_s,		"endwb-s")	\
 	EM(netfs_folio_trace_filled_gaps,	"filled-gaps")	\
 	EM(netfs_folio_trace_invalidate_all,	"inval-all")	\
 	EM(netfs_folio_trace_invalidate_front,	"inval-front")	\


