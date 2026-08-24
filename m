Return-Path: <linux-erofs+bounces-4319-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F34C5DF81
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:44:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDGD2XwPz2yCr;
	Tue, 25 Aug 2026 00:44:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582692;
	cv=none; b=IZr7CcPR7/ERS0DM+y+ibb12FV87e3QXfg8m8LqlPBKoOz70m9E6h8FbZ1s1xPlW1ktW6m2Mu8veiZcPGBASFdvjrLlQkd+tJavpre6SDtT51pyFmQp8qTdyTe479mCTZz1iba3lHf5vp34xn4+E4jmlt3wEZpqqMG7XysLoYSxXWY8u3FGNbqVidbwNz7YwJ0ZpvC0n2Y3+6AYTZemCKTw3RF0uyXYq/UPq16SJz9H5n1tsGnpnmWiiSypWJbc9ZBfSBFbDQTyCBoduDZTm/dr03s7YC4CFevs/+cMlctMds6/oFJulx6rpy6d2ighFguJjnvFKSYnul7FOaMbqaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582692; c=relaxed/relaxed;
	bh=+g0CT/3xbEYkbuzN70YZ1k411vm20BLM3/RDiJeUpoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QChMjhqV3B8m89RfP8MaRLXywF/4296N4jTdjPCOplqECCsrI4a1CT1BLyJARbpxMXSHv0k5aKPyqH6A6Q8VegS3uoVRXKImJwrImS1COFJCu/7FyNt1IVbJSOaGDtgIqtCL/Bgb77J/zo2haawZZcTWUYWloAdHmWpQ6ZVnLsK/S65EKAc0O+C3ienmxONP/QxxNu3r8X0f4MjzUdxozXNGROapLFPKULo5XzZ06ZCpvnSRvhlRbg1QKEZe5gMnchn5k20Kk3uAVUVY3zA508qZd/Xekwad+v1rqYDW4iJ1+Ej9toJ/pG0OahrylzFpRU6COCRPI6mgzwFxgQ00Xg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dRThSzmJ; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dRThSzmJ; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dRThSzmJ;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dRThSzmJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDGC2bFHz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:44:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+g0CT/3xbEYkbuzN70YZ1k411vm20BLM3/RDiJeUpoQ=;
	b=dRThSzmJCJ6DGWYy/mIh1P0rdVppWW4Iw9yRgQ33IXIb5sC9nkI4UQbRLXu13g8K8hV2TO
	MR9L0Xg+b+ESY6ge6sql5Avc0rqM80VURsJQaET2CcnRj6e50He/JtQLx/Q8bLAefNv9K/
	IMJ48hG0xCnjL6TB4iROSFA2llyNyyU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+g0CT/3xbEYkbuzN70YZ1k411vm20BLM3/RDiJeUpoQ=;
	b=dRThSzmJCJ6DGWYy/mIh1P0rdVppWW4Iw9yRgQ33IXIb5sC9nkI4UQbRLXu13g8K8hV2TO
	MR9L0Xg+b+ESY6ge6sql5Avc0rqM80VURsJQaET2CcnRj6e50He/JtQLx/Q8bLAefNv9K/
	IMJ48hG0xCnjL6TB4iROSFA2llyNyyU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-6DFV8RnON6uyFerSV8GGUg-1; Mon,
 24 Aug 2026 10:44:43 -0400
X-MC-Unique: 6DFV8RnON6uyFerSV8GGUg-1
X-Mimecast-MFC-AGG-ID: 6DFV8RnON6uyFerSV8GGUg_1787582679
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B5F41834590;
	Mon, 24 Aug 2026 14:44:39 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B193B30002ED;
	Mon, 24 Aug 2026 14:44:31 +0000 (UTC)
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
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v10 21/35] netfs: Make deprecated PG_private_2 support optional
Date: Mon, 24 Aug 2026 15:41:14 +0100
Message-ID: <20260824144130.759997-22-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 5l9JoHfV_QbLk0R4qrpkVK3NAgFkgPnTgMsDEvE0-E0_1787582679
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make the deprecated PG_private_2 support optional, requiring it to be
selected by the filesystems that might want to use it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
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
 fs/netfs/read_collect.c |  2 +-
 fs/nfs/Kconfig          |  1 +
 include/linux/netfs.h   |  2 ++
 7 files changed, 37 insertions(+), 2 deletions(-)

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
index e1f12ecb5abf..b1ea4439c1bb 100644
--- a/fs/netfs/Makefile
+++ b/fs/netfs/Makefile
@@ -12,7 +12,6 @@ netfs-y := \
 	misc.o \
 	objects.o \
 	read_collect.o \
-	read_pgpriv2.o \
 	read_retry.o \
 	read_single.o \
 	rolling_buffer.o \
@@ -20,6 +19,7 @@ netfs-y := \
 	write_issue.o \
 	write_retry.o
 
+netfs-$(CONFIG_NETFS_PGPRIV2) += read_pgpriv2.o
 netfs-$(CONFIG_NETFS_STATS) += stats.o
 
 netfs-$(CONFIG_FSCACHE) += \
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index df04ee82e34b..c50750b72262 100644
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
index f758ab0aaf5d..f773579692ab 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -54,7 +54,7 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 	flush_dcache_folio(folio);
 	folio_mark_uptodate(folio);
 
-	if (!test_bit(NETFS_RREQ_USE_PGPRIV2, &rreq->flags)) {
+	if (!netfs_using_pgpriv2(rreq)) {
 		finfo = netfs_folio_info(folio);
 		if (finfo) {
 			trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
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
index b6e5f6dc54e2..7cdb14a130d9 100644
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
 


