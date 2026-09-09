Return-Path: <linux-erofs+bounces-4518-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDFBC79FAA
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Sep 2026 07:22:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfshF5zcZz2yhD;
	Wed, 09 Sep 2026 17:22:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788938541;
	cv=none; b=LGyMAiBd45kFopCfDBouOZmpxhToNKwP2/DXcikAI+NQ8Fngh7BLBu/CvqmsGs/03dlMm7tvNbpiMMA9bE6195Y/ZpM1iTg/8xHrkwqL/rtPExk0VZxtof/srg5U7SHBIJ51AvNy62tbjKkhn/ZxMiNdFmvI33/XEn+GBX2M8kGxPUnIXmFsqqPr1mbNueQTRbKupDLeFzbZbzFBrHT/hE1pOMYLedkWqsD9n3SF8Oo1l2ESH16oGFvaGPexCVFzlrHzkY7We3fdeMmhwFp2euCJajqmRkY8Y4TKOWdkhFsCVp5m+a6y6VYcfiL/pcXc/KJFfJQY1TZkfgVJJ7BUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788938541; c=relaxed/relaxed;
	bh=TN3BjUFT/Rn1kLbehCLwDsBl8cqyCMqhJ+b1AToBOH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=eqdHFwrf5gIxRCYZN9RYPYeIyaZm9LEnbfq4kYPMs6U+8nRgjYHD2SB20Yuk9Xkp80qm2TiKEFBuBaLxvj18oFTqdnf4SaZDjyxf/PCzm6eLjUKSxsGd342VomphaH8Woxd5WNagpI6Yv9EkDeQGe77vUIAVn9Sd5tdd2yPzbc/kfnMUzNHytc0DFuR8r+CqqvMTAlmmYdbdbAol4HnpAHEGDt/FqCVLAk5jaimYCKj2QK2XiLwi+mJ/Yygx9OgVnskWkSImEvYB6f94A0VVLUN+P3TIc/xEeoP7kRnKZvEu7lMYA0q06SqP6fWrUPaacv+UypOOQplDORpmLzY2BQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q1K63Jk7; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gy3sShI+; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q1K63Jk7;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gy3sShI+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfshD5wgRz2y2J
	for <linux-erofs@lists.ozlabs.org>; Wed, 09 Sep 2026 17:22:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788938536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TN3BjUFT/Rn1kLbehCLwDsBl8cqyCMqhJ+b1AToBOH8=;
	b=Q1K63Jk7GY2Lg97BaB012Cxh6GgRP1QMNV12jtSLMXcUQ4YrbaoENeLJIoJkEv3zM34+nS
	wy3v6fDT/dPxtJ9Icz6uKGcj4+a11aHPPYx7bHVaFwA66i7xaqzHHkbOBZYBRtkRi5d9T0
	1/gt1yVNRfVtl8y1qe5SjEzcCvujkho=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788938537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TN3BjUFT/Rn1kLbehCLwDsBl8cqyCMqhJ+b1AToBOH8=;
	b=Gy3sShI+5irqH2UUYJWHVkw/6eVPyYdLeWG+tE6e6U2ryMpwgfw0JuOgXEp4bbSGgjmd11
	wGMYXyGgod2LuV5Vr5wWbyY/aEgkFiTqKHB7ilJxZoWIlLAq0Rxavbg3hAHiIMveDLHGGJ
	ef/0LbRjP7VfxIq4dBiaRhk3b/3XZDs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-9xl01ZGCMAK74ylbvMxq_g-1; Wed,
 09 Sep 2026 03:22:13 -0400
X-MC-Unique: 9xl01ZGCMAK74ylbvMxq_g-1
X-Mimecast-MFC-AGG-ID: 9xl01ZGCMAK74ylbvMxq_g_1788938530
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADEA11954AE7;
	Wed,  9 Sep 2026 07:22:09 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 77EAB195608C;
	Wed,  9 Sep 2026 07:22:03 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
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
	linux-kernel@vger.kernel.org,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v13 6/8] netfs: Make deprecated PG_private_2 support opt-in
Date: Wed,  9 Sep 2026 08:21:00 +0100
Message-ID: <20260909072105.1663687-7-dhowells@redhat.com>
In-Reply-To: <20260909072105.1663687-1-dhowells@redhat.com>
References: <20260909072105.1663687-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 6XxMVl9a5YvDj9RKUuQZmcRiTRDoQwgOz3Ufgh6FPmQ_1788938530
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make the deprecated PG_private_2 support opt-in, requiring it to be
selected by the filesystems that might want to use it.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
cc: Trond Myklebust <trondmy@kernel.org>
cc: Anna Schumaker <anna@kernel.org>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Viacheslav Dubeyko <slava@dubeyko.com>
cc: netfs@lists.linux.dev
cc: linux-nfs@vger.kernel.org
cc: ceph-devel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/ceph/Kconfig          |  1 +
 fs/netfs/Kconfig         |  3 +++
 fs/netfs/Makefile        |  2 +-
 fs/netfs/buffered_read.c |  2 +-
 fs/netfs/internal.h      | 28 ++++++++++++++++++++++++++++
 fs/netfs/read_collect.c  |  4 ++--
 fs/nfs/Kconfig           |  1 +
 include/linux/netfs.h    |  2 ++
 8 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 3d64a316ca31..aa6ccd7794d2 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -4,6 +4,7 @@ config CEPH_FS
 	depends on INET
 	select CEPH_LIB
 	select NETFS_SUPPORT
+	select NETFS_PGPRIV2
 	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	default n
 	help
diff --git a/fs/netfs/Kconfig b/fs/netfs/Kconfig
index 7701c037c328..d0e7b0971fa3 100644
--- a/fs/netfs/Kconfig
+++ b/fs/netfs/Kconfig
@@ -22,6 +22,9 @@ config NETFS_STATS
 	  between CPUs.  On the other hand, the stats are very useful for
 	  debugging purposes.  Saying 'Y' here is recommended.
 
+config NETFS_PGPRIV2
+	bool
+
 config NETFS_DEBUG
 	bool "Enable dynamic debugging netfslib and FS-Cache"
 	depends on NETFS_SUPPORT
diff --git a/fs/netfs/Makefile b/fs/netfs/Makefile
index b43188d64bd8..54834cde7e56 100644
--- a/fs/netfs/Makefile
+++ b/fs/netfs/Makefile
@@ -11,7 +11,6 @@ netfs-y := \
 	misc.o \
 	objects.o \
 	read_collect.o \
-	read_pgpriv2.o \
 	read_retry.o \
 	read_single.o \
 	rolling_buffer.o \
@@ -19,6 +18,7 @@ netfs-y := \
 	write_issue.o \
 	write_retry.o
 
+netfs-$(CONFIG_NETFS_PGPRIV2) += read_pgpriv2.o
 netfs-$(CONFIG_NETFS_STATS) += stats.o
 
 netfs-$(CONFIG_FSCACHE) += \
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 61cf82b4b60d..54287a8ef0f8 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -242,7 +242,7 @@ static void netfs_mark_copy_to_cache(struct netfs_io_request *rreq,
 
 		if (overlap > 0 && copy) {
 			folio = folioq_folio(*fq, *slot);
-			if (unlikely(test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags))) {
+			if (netfs_using_pgpriv2(rreq)) {
 				if (!folio_test_private_2(folio))
 					folio_start_private_2(folio);
 			} else {
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index a4c834e32214..3aebe4a4f7b0 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -120,9 +120,37 @@ void netfs_cache_read_terminated(void *priv, ssize_t transferred_or_error);
 /*
  * read_pgpriv2.c
  */
+#ifdef CONFIG_NETFS_PGPRIV2
+int netfs_prepare_pgpriv2_write_buffer(struct netfs_io_subrequest *subreq,
+				       unsigned int max_segs);
 void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio);
 void netfs_pgpriv2_end_copy_to_cache(struct netfs_io_request *rreq);
 bool netfs_pgpriv2_unlock_copied_folios(struct netfs_io_request *wreq);
+static inline bool netfs_using_pgpriv2(const struct netfs_io_request *rreq)
+{
+	return unlikely(test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags));
+}
+#else
+static inline int netfs_prepare_pgpriv2_write_buffer(struct netfs_io_subrequest *subreq,
+						     unsigned int max_segs)
+{
+	return -EIO;
+}
+static inline void netfs_pgpriv2_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio)
+{
+}
+static inline void netfs_pgpriv2_end_copy_to_cache(struct netfs_io_request *rreq)
+{
+}
+static inline bool netfs_pgpriv2_unlock_copied_folios(struct netfs_io_request *wreq)
+{
+	return true;
+}
+static inline bool netfs_using_pgpriv2(const struct netfs_io_request *rreq)
+{
+	return false;
+}
+#endif
 
 /*
  * read_retry.c
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 61f2664de6d3..01ea1ddae04b 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -38,7 +38,7 @@ static void netfs_clear_unread(struct netfs_io_subrequest *subreq)
  */
 void netfs_cancel_copy_to_cache(struct netfs_io_request *rreq, struct folio *folio)
 {
-	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+	if (!netfs_using_pgpriv2(rreq)) {
 		if (folio_get_private(folio) == NETFS_FOLIO_COPY_TO_CACHE) {
 			folio_detach_private(folio);
 			trace_netfs_folio(folio, netfs_folio_trace_cancel_copy);
@@ -81,7 +81,7 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 	if (unlikely(test_bit(NETFS_RREQ_CANCEL_CACHING, &rreq->flags)))
 		netfs_cancel_copy_to_cache(rreq, folio);
 
-	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+	if (!netfs_using_pgpriv2(rreq)) {
 		if (netfs_folio_group(folio) == NETFS_FOLIO_COPY_TO_CACHE)  {
 			trace_netfs_folio(folio, netfs_folio_trace_sched_copy);
 			folio_mark_dirty(folio);
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 6bb30543eff0..e7862f35b72c 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -174,6 +174,7 @@ config NFS_FSCACHE
 	bool "Provide NFS client caching support"
 	depends on NFS_FS
 	select NETFS_SUPPORT
+	select NETFS_PGPRIV2
 	select FSCACHE
 	help
 	  Say Y here if you want NFS data to be cached locally on disc through
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index f2b3e61c1891..71fdd6ef43a7 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -279,8 +279,10 @@ struct netfs_io_request {
 #define NETFS_RREQ_UPLOAD_TO_SERVER	11	/* Need to write to the server */
 #define NETFS_RREQ_USE_IO_ITER		12	/* Use ->io_iter rather than ->i_pages */
 #define NETFS_RREQ_NEED_PUT_RA_REFS	17	/* Need to put the folio refs RA gave us */
+#ifdef CONFIG_NETFS_PGPRIV2
 #define NETFS_RREQ_USE_PGPRIV2		31	/* [DEPRECATED] Use PG_private_2 to mark
 						 * write to cache on read */
+#endif
 	const struct netfs_request_ops *netfs_ops;
 };
 


