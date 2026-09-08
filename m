Return-Path: <linux-erofs+bounces-4503-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9980CC79FA0
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 09:11:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfJ8q12rLz2ypw;
	Tue, 08 Sep 2026 19:11:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788858699;
	cv=none; b=D0o+EnFdB+0ZYJ/nyMgTTQd7QWd24yfNg4D+kBPh1mtyQ4czN4e18LsrHQ2gdF8dHYzL310OOnoNh4K5qpKpspiN1HEu0PJzhMWS8sMReS5bq8MNm6XzwBTPY1AByUUXKoSMcWEiW8tPkOO7WSsd5Nw9HFktw9vRAAhho/KzWl/ee//32z/PDMCLwXDl3geBRXKbb/VPNAqhTs63bubTP0SuJmGWZDe+Al3G+ylx2Q8DUiSO4HrteiGr3Z2fgMf3dU6rToRjfkJ1Mk9+SZQElL8YQGeLXeQ+/ODc9c56WVDYv5ZF1uMgxaplP8FzCHrAMs/3nSqRbUU0LUAAsqCmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788858699; c=relaxed/relaxed;
	bh=p547j3VyZN42h1CHEtOtl085drm+stiJJ8mToU3R6J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RPy8ejoiBLJLxyXOgwglEzSSudKQZkxfC5he1xUctBvmj28jSggitk0LBTgRwaaxnR+aI47+cY2xuIYu5inx33jdZfQwCw9ouWkZCBlnmEwwpYHxtTR0dHWIAUKeBSytZ1iylavmsJKrB19BeI88RycP6g47pVBWnT7W3IoqbNm0YnbzGd2ZUxpNvjXFloF6wDoJtSjqPu0qsWNN1z2+DV+jLmXx5rSQ0QKc/GemnUBLwVodlarODAskT5BibnY4gyWeREG/RMMvMPdpQR7vbU3ZqMTApkZ+WdfKIo1iSul7Xz5gsXpM4YhB0HJUgaSW+Co+QVgda0+hOOQJeyJyoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PL7WEDtQ; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YxKx2JJ6; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PL7WEDtQ;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YxKx2JJ6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfJ8p15gnz2y8d
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 19:11:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788858694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p547j3VyZN42h1CHEtOtl085drm+stiJJ8mToU3R6J4=;
	b=PL7WEDtQTpdtBNPWh+nM1W76dsR7phqNjVhVLQD+sFhbwr+5w0/YYGkdb+MBQfT15+o0wM
	6x2Nd989vFp3wngbXPgyA6JRfrXccrEt3Xp6beTzsBaBdmupZsKZltxT+BCp8Z0xUn5zeC
	uXVYjd1kC3vBHr0p3kD+IXNryT3PP9c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788858695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p547j3VyZN42h1CHEtOtl085drm+stiJJ8mToU3R6J4=;
	b=YxKx2JJ6J+NJMkDTZA0tYHWFxeo4vki68vtTN8fdOuBd5E9cyUb3nYW1mYZXXa6SqSxsUI
	Vjac6/mAQkn46m1dad4EHTOOchc42CifgQ0/0cWzb+rkJX9PMZa81UrlI8t+2u3XR4jrmW
	brIND4hXnLC/i8Qz65QXIET609ai0WY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-4eFBHzqLNde9yRx9H1gK_Q-1; Tue,
 08 Sep 2026 05:11:33 -0400
X-MC-Unique: 4eFBHzqLNde9yRx9H1gK_Q-1
X-Mimecast-MFC-AGG-ID: 4eFBHzqLNde9yRx9H1gK_Q_1788858690
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3984F195E907;
	Tue,  8 Sep 2026 09:11:30 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 811801800346;
	Tue,  8 Sep 2026 09:11:23 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v12 6/8] netfs: Make deprecated PG_private_2 support opt-in
Date: Tue,  8 Sep 2026 10:10:27 +0100
Message-ID: <20260908091031.1506798-7-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: qFdJ0VwntXg4xVA3SsvApW2JIA5TXyWxzrJNaJ1CgKA_1788858690
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
 fs/ceph/Kconfig         |  1 +
 fs/netfs/Kconfig        |  3 +++
 fs/netfs/Makefile       |  2 +-
 fs/netfs/internal.h     | 28 ++++++++++++++++++++++++++++
 fs/netfs/read_collect.c |  4 ++--
 fs/nfs/Kconfig          |  1 +
 include/linux/netfs.h   |  2 ++
 7 files changed, 38 insertions(+), 3 deletions(-)

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
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index a4c834e32214..532263d896a1 100644
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
+	return test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags);
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
 


