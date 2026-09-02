Return-Path: <linux-erofs+bounces-4429-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A196C624D6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 17:34:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZqc64hW3z2xlv;
	Thu, 03 Sep 2026 03:34:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788370486;
	cv=none; b=J8cU/mlMG+EF8mg6R38hCXVRO6xYg5Rc+iYs8DpTXifwUlQKYOd8nU/+tRIGYBFgZ7j3GlBKK3Sme7VMj2shroTiyD/o2kJMHZToXbqPND4px2WDt8XUY2nZbq0hBLQ52vk/w1m3js2bBdPPUJRYMkKanWno8yU+9PGY9OLyeswk243jz25sO8qPG3KB6V7QRWZ6AZmZu+SyqLer1mKMwEfUeOIswJuLWDLM8Hr9C8/XqW1V2U/4xUQM1jOVkVcFP5ccCnONdkVhaEBFuE9zASyOIUfe16isLoyOrKUp7ZWydnnqHnc+xv+HK5Yy49xQ0j1uawM6q508g522SU2vqA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788370486; c=relaxed/relaxed;
	bh=RnfEm+OhRi/45mFVUOgbuCPGW3hJeL3DRZRk8bidxUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ZndOY8h0TUx86za4qCYRni1054jFJ7TGckP0KF1XVYCyoqChtFueOi+462gxVWPgw9xXFojnKJFDB/s/HzjoP8iu7dVM9PPnQ93+stzGwfyP7baoI+Gy6M/sBkwELYD8ltgCe+GpmiaEqxKj6z+cU6gkPekEjiqhY/uDTnflWYhhqu+m1kVK93OVwGeSJVvKjFP/HCRCBDv5otOilmpoFxIJXdLfLmc8kTe8zbpjIV0LDUTuKjpLitLUB5gUvdBKNyZTGohpPALNVK2EMZCyuN7aLUDge8mLT+WGYqA+vIJdB8ue0H/fJIrxeA+OHr1LZTuOar/tZ5XmacgEjcZiRQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GDooSxlH; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QafHSHRk; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GDooSxlH;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QafHSHRk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZqc54XLYz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 03:34:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnfEm+OhRi/45mFVUOgbuCPGW3hJeL3DRZRk8bidxUc=;
	b=GDooSxlHuSzQyosw46KsiDKZheDfIVpul6FcnaoI/YRsDU3NOQH8QtQWvdNkK1WJlEhryg
	6GlXVIMMBfcIOrNCB63JVRLjEvku3MfghbSymvZRTzFlW70No5VSAwlntpgAp4CC6YaRe4
	1Y35UVqWNoAiLqrp7zafVrU3jMA41ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnfEm+OhRi/45mFVUOgbuCPGW3hJeL3DRZRk8bidxUc=;
	b=QafHSHRkc9wjY/EnjuQ+cLJB4MoRmLSolx/o7ZEVaNugKrw7lmW007KARcCsrEmv/heO9Z
	Aid3zrF7kjGmfEILEMPqDCfagjjZrKOBoyIq3uwfItmlo1Gr0A/NbDt2l5yxwTv9D+0B6d
	hLSNmGzcQ7dsIMoRTA552sFPJw48PXU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-ErtfLEkNMF-ON6266K0J_A-1; Wed,
 02 Sep 2026 13:34:35 -0400
X-MC-Unique: ErtfLEkNMF-ON6266K0J_A-1
X-Mimecast-MFC-AGG-ID: ErtfLEkNMF-ON6266K0J_A_1788370472
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A272A195C241;
	Wed,  2 Sep 2026 17:34:31 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7AE1718005BA;
	Wed,  2 Sep 2026 17:34:24 +0000 (UTC)
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
	linux-mm@kvack.org
Subject: [PATCH v11 03/36] mm: Add a bulk end-writeback tool
Date: Wed,  2 Sep 2026 18:33:15 +0100
Message-ID: <20260902173350.3468672-4-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: dj4QfXAVUBpvxTDr2rcxqG3M0HuL3-7oKYHA8pt14f4_1788370472
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add a tool to perform bulk folio_end_writeback() across a series of
contiguous folios.  The function takes a beginning and an end file position
and ends any folio that lies wholly in the range, leaving the end position
of the last folio it considered in the iterator state for the filesystem to
use as a hint for when to call again.

As folio_end_writeback() has to access the xarray to clear the marks set on
the entries for the folios involved, this tool provides the opportunity to
merge the two xarray accesses (the iteration and the unmarking) and also do
statistics update in bulk.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_collect.c  | 51 +++++++++++++++++++++++++++++++++++++++
 include/linux/writeback.h | 10 ++++++++
 mm/page-writeback.c       | 45 ++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 210eb8f3958d..c5b07b3201d7 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -21,6 +21,57 @@
 #define NEED_RETRY		0x10	/* A front op requests retrying */
 #define SAW_FAILURE		0x20	/* One stream or hit a permanent failure */
 
+struct end_writeback_ctrl {
+	struct xa_state xas;
+	uoff_t fend;
+};
+
+/**
+ * end_writeback_iter - End writeback for the folios within the range
+ * @mapping: The pagecache to modify
+ * @from: Pointer to the starting position
+ * @to: The end position (exclusive)
+ * @ctrl: Iterator state
+ * @folio: The last return from this function or NULL if first call
+ *
+ * Remove the writeback mark on folios that are entirely within in the given
+ * range, where @from is included in the range, but @to is excluded from the
+ * range.
+ *
+ * Return: The folio to end writeback upon or NULL if the next folio isn't
+ * wholly within the range.  Note that this does not necessarily imply that the
+ * ending is complete.  @ctrl->fend is updated to point directly beyond the
+ * folio that was considered and may be negative if cast to loff_t.
+ */
+static
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 uoff_t from, uoff_t to,
+				 struct end_writeback_ctrl *ctrl,
+				 struct folio *folio)
+{
+	if (!folio) {
+		lockdep_assert_in_rcu_read_lock();
+		ctrl->xas = (struct xa_state)
+			__XA_STATE(&mapping->i_pages, from / PAGE_SIZE, 0, 0);
+		folio = xas_find(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	} else {
+		folio_end_writeback(folio);
+	retry:
+		folio = xas_next_entry(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	}
+
+	if (xas_retry(&ctrl->xas, folio))
+		goto retry;
+
+	if (!folio)
+		return NULL;
+
+	ctrl->fend = folio_next_pos(folio);
+	if (ctrl->fend > to)
+		folio = NULL;
+	return folio;
+}
+
 static void netfs_dump_request(const struct netfs_io_request *rreq)
 {
 	pr_err("Request R=%08x r=%d fl=%lx or=%x e=%ld\n",
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b749a9a5a5ee..4f34cbc964f6 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -358,6 +358,16 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb);
 struct folio *writeback_iter(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio, int *error);
 
+/* end_writeback_iter() state. */
+struct end_writeback_ctrl {
+	struct xa_state	xas;	/* The xarray walker */
+	uoff_t		fend;	/* The next file pos after the folio last considered. */
+};
+
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 struct end_writeback_ctrl *ctrl,
+				 uoff_t from, uoff_t to, struct folio *folio);
+
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6c9c7ba89b8a..632b0616eceb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2546,6 +2546,51 @@ struct folio *writeback_iter(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(writeback_iter);
 
+/**
+ * end_writeback_iter - End writeback for the folios within the range
+ * @mapping: The pagecache to modify
+ * @ctrl: Iterator state
+ * @from: Pointer to the starting position
+ * @to: The end position (exclusive)
+ * @folio: The last return from this function or NULL if first call
+ *
+ * Remove the writeback mark on folios that are entirely within in the given
+ * range, where @from is included in the range, but @to is excluded from the
+ * range.
+ *
+ * Return: The folio to end writeback upon or NULL if the next folio isn't
+ * wholly within the range.  Note that this does not necessarily imply that the
+ * ending is complete.  @ctrl->fend is updated to point directly beyond the
+ * folio that was considered and may be negative if cast to loff_t.
+ */
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 struct end_writeback_ctrl *ctrl,
+				 uoff_t from, uoff_t to, struct folio *folio)
+{
+	if (!folio) {
+		lockdep_assert_in_rcu_read_lock();
+		ctrl->xas = (struct xa_state)
+			__XA_STATE(&mapping->i_pages, from / PAGE_SIZE, 0, 0);
+		folio = xas_find(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	} else {
+		folio_end_writeback(folio);
+	retry:
+		folio = xas_next_entry(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	}
+
+	if (xas_retry(&ctrl->xas, folio))
+		goto retry;
+
+	if (!folio)
+		return NULL;
+
+	ctrl->fend = folio_next_pos(folio);
+	if (ctrl->fend > to)
+		folio = NULL;
+	return folio;
+}
+EXPORT_SYMBOL_GPL(end_writeback_iter);
+
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;


