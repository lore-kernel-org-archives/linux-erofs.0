Return-Path: <linux-erofs+bounces-4307-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB3AC5DF94
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:43:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDDP00lzz2y8m;
	Tue, 25 Aug 2026 00:43:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582596;
	cv=none; b=mHg1vwvEaHxagfKcwzz5u+g+ngwbDDsSqc7ogfQeBPLJ11PQUTWKn06gqAlSR5tWpP1+oXPpqcSMmQK27PEcful8N2YDS20ofz/vDHRLZ55oSUw7Mwddt5K7hteQxO197rbMfIw/5qDP3BpuhpF6IZI/hDx1aOGR/rlCAU5AFar6m+CEm49c2zrSuyyE5PTbSUMiC8Wz21TYs+V2yLEZEgHBT9H+LnhzYG2GXgISb0IGelJnDzbXCWRh9bR9OuxFpKkE4dF4hdB48BSJSvNus0D0L8P6e1OtYHtaAeaAsvm3Kb4E2bAL0LdUu04dKyoDoaQKsh2mlVj1EZUJuILssg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582596; c=relaxed/relaxed;
	bh=HO4OLbP/FWnSz/NPberlvhYzFjgbzDJ1WK0iNKs0+Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Hh570/C21LtGicy68KA2WwyaXxBtSevXRYKjMebqlD0tBAaCJuVStbrI+1PmXNTg5plulJS2iwi7XlAaFyLa8LkLc+TDf+LhPh0ATI01bE5KJURXjIfH2feMoEo9jiKacMnt9xP4iODcoV/QsDD8lAgKgO7/7cXYjEv/X9W/GCDehc8nfUXz/9MsoiLXH5iWkkXg0A8eh9Y6Me0uiyzh5Vo9hW5eJ/M6EdjoKX5S4sOpl6Q9qRXIqn3VV81uFTz9+gIx9Pk32IrZyg5QHRenotkXofbr8Ke7bu/gRxgvhBo0FPP9FOpceJAcYZ94m0/ExGv4iJnBXkUpLYyMd7p8XA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dOuD4M6H; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZByw2Ur4; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dOuD4M6H;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZByw2Ur4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDDM6s4cz2xmh
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:43:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HO4OLbP/FWnSz/NPberlvhYzFjgbzDJ1WK0iNKs0+Tc=;
	b=dOuD4M6Hd5KuA1Pcqmogv4+CmE5AThjvgY42jvHT0TPt41EpORUIsduhUycb6s9EcHkEu/
	wlFgNFyr/Du6NUIQZI2M9GGC/jE6lWN3EPAHH/WJunAw5P6gPQsuAnvDOkpG+gg6AeHhHW
	dOzO5/LZ0u+5Mq3Hqsn367DvquLeL9I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HO4OLbP/FWnSz/NPberlvhYzFjgbzDJ1WK0iNKs0+Tc=;
	b=ZByw2Ur4hegfdplgnVA8Qmcbqb4EZ48/xSwpcdDbNJf95XuU4p6XtXQrgIMglQoEfaeLGJ
	jzCE5iOkIWEGH8vLarNFUa9GYTiQOnSNXsZpw/uonisiHHHDuhaDb8yikrWJ8mCfDKM22u
	0OegV2HyVbwWznbS8NbYfwHtkxT8e7s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-8_DUO4sUMj2SsodbKPtBAg-1; Mon,
 24 Aug 2026 10:43:07 -0400
X-MC-Unique: 8_DUO4sUMj2SsodbKPtBAg-1
X-Mimecast-MFC-AGG-ID: 8_DUO4sUMj2SsodbKPtBAg_1787582583
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CACEA195FCE6;
	Mon, 24 Aug 2026 14:43:02 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 39F391800348;
	Mon, 24 Aug 2026 14:42:55 +0000 (UTC)
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
	linux-block@vger.kernel.org
Subject: [PATCH v10 09/35] iov_iter: Make iov_iter_get_pages*() wrap iov_iter_extract_pages()
Date: Mon, 24 Aug 2026 15:41:02 +0100
Message-ID: <20260824144130.759997-10-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: t64WLZkEJrWE6s3Qevz4yJ77_DkmQ6oAqOR484U9CiU_1787582583
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make iov_iter_get_pages*() wrap iov_iter_extract_pages() for kernel
iterator types (e.g. ITER_BVEC, ITER_FOLIOQ, ITER_XARRAY).  The pages
obtained have their refcounts incremented afterwards if they're not slab
pages.  ITER_KVEC is left returning -EFAULT.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: linux-block@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 lib/iov_iter.c | 164 ++++++-------------------------------------------
 1 file changed, 19 insertions(+), 145 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c2484551a4e8..15a50d538c65 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -910,118 +910,34 @@ static int want_pages_array(struct page ***res, size_t size,
 	return count;
 }
 
-static ssize_t iter_folioq_get_pages(struct iov_iter *iter,
+/*
+ * Wrap iov_iter_extract_pages() and then pin the non-slab pages we got back.
+ * This only works for non-user iterator types as get_pages uses get_user_pages
+ * not pin_user_pages.
+ */
+static ssize_t iter_get_kernel_pages(struct iov_iter *iter,
 				     struct page ***ppages, size_t maxsize,
 				     unsigned maxpages, size_t *_start_offset)
 {
-	const struct folio_queue *folioq = iter->folioq;
 	struct page **pages;
-	unsigned int slot = iter->folioq_slot;
-	size_t extracted = 0, count = iter->count, iov_offset = iter->iov_offset;
+	ssize_t ret, done;
 
-	if (slot >= folioq_nr_slots(folioq)) {
-		folioq = folioq->next;
-		slot = 0;
-		if (WARN_ON(iov_offset != 0))
-			return -EIO;
-	}
+	ret = iov_iter_extract_pages(iter, ppages, maxsize, maxpages,
+				     0, _start_offset);
+	if (ret <= 0)
+		return ret;
 
-	maxpages = want_pages_array(ppages, maxsize, iov_offset & ~PAGE_MASK, maxpages);
-	if (!maxpages)
-		return -ENOMEM;
-	*_start_offset = iov_offset & ~PAGE_MASK;
 	pages = *ppages;
+	for (done = ret + *_start_offset; done > 0; done -= PAGE_SIZE) {
+		struct folio *folio = page_folio(*pages);
 
-	for (;;) {
-		struct folio *folio = folioq_folio(folioq, slot);
-		size_t offset = iov_offset, fsize = folioq_folio_size(folioq, slot);
-		size_t part = PAGE_SIZE - offset % PAGE_SIZE;
-
-		if (offset < fsize) {
-			part = umin(part, umin(maxsize - extracted, fsize - offset));
-			count -= part;
-			iov_offset += part;
-			extracted += part;
-
-			*pages = folio_page(folio, offset / PAGE_SIZE);
-			get_page(*pages);
-			pages++;
-			maxpages--;
-		}
-
-		if (maxpages == 0 || extracted >= maxsize)
-			break;
-
-		if (iov_offset >= fsize) {
-			iov_offset = 0;
-			slot++;
-			if (slot == folioq_nr_slots(folioq) && folioq->next) {
-				folioq = folioq->next;
-				slot = 0;
-			}
-		}
-	}
-
-	iter->count = count;
-	iter->iov_offset = iov_offset;
-	iter->folioq = folioq;
-	iter->folioq_slot = slot;
-	return extracted;
-}
-
-static ssize_t iter_xarray_populate_pages(struct page **pages, struct xarray *xa,
-					  pgoff_t index, unsigned int nr_pages)
-{
-	XA_STATE(xas, xa, index);
-	struct folio *folio;
-	unsigned int ret = 0;
-
-	rcu_read_lock();
-	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
-		if (xas_retry(&xas, folio))
-			continue;
-
-		/* Has the folio moved or been split? */
-		if (unlikely(folio != xas_reload(&xas))) {
-			xas_reset(&xas);
-			continue;
-		}
-
-		pages[ret] = folio_file_page(folio, xas.xa_index);
-		folio_get(folio);
-		if (++ret == nr_pages)
-			break;
+		if (!folio_test_slab(folio) && !folio_test_large_kmalloc(folio))
+			folio_get(folio);
+		pages++;
 	}
-	rcu_read_unlock();
 	return ret;
 }
 
-static ssize_t iter_xarray_get_pages(struct iov_iter *i,
-				     struct page ***pages, size_t maxsize,
-				     unsigned maxpages, size_t *_start_offset)
-{
-	unsigned nr, offset, count;
-	pgoff_t index;
-	loff_t pos;
-
-	pos = i->xarray_start + i->iov_offset;
-	index = pos >> PAGE_SHIFT;
-	offset = pos & ~PAGE_MASK;
-	*_start_offset = offset;
-
-	count = want_pages_array(pages, maxsize, offset, maxpages);
-	if (!count)
-		return -ENOMEM;
-	nr = iter_xarray_populate_pages(*pages, i->xarray, index, count);
-	if (nr == 0)
-		return 0;
-
-	maxsize = min_t(size_t, nr * PAGE_SIZE - offset, maxsize);
-	i->iov_offset += maxsize;
-	i->count -= maxsize;
-	return maxsize;
-}
-
 /* must be done on non-empty ITER_UBUF or ITER_IOVEC one */
 static unsigned long first_iovec_segment(const struct iov_iter *i, size_t *size)
 {
@@ -1044,22 +960,6 @@ static unsigned long first_iovec_segment(const struct iov_iter *i, size_t *size)
 	BUG(); // if it had been empty, we wouldn't get called
 }
 
-/* must be done on non-empty ITER_BVEC one */
-static struct page *first_bvec_segment(const struct iov_iter *i,
-				       size_t *size, size_t *start)
-{
-	struct page *page;
-	size_t skip = i->iov_offset, len;
-
-	len = i->bvec->bv_len - skip;
-	if (*size > len)
-		*size = len;
-	skip += i->bvec->bv_offset;
-	page = i->bvec->bv_page + skip / PAGE_SIZE;
-	*start = skip % PAGE_SIZE;
-	return page;
-}
-
 static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
 		   unsigned int maxpages, size_t *start)
@@ -1095,36 +995,10 @@ static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 		iov_iter_advance(i, maxsize);
 		return maxsize;
 	}
-	if (iov_iter_is_bvec(i)) {
-		struct page **p;
-		struct page *page;
 
-		page = first_bvec_segment(i, &maxsize, start);
-		n = want_pages_array(pages, maxsize, *start, maxpages);
-		if (!n)
-			return -ENOMEM;
-		p = *pages;
-		for (int k = 0; k < n; k++) {
-			struct folio *folio = page_folio(page + k);
-			p[k] = page + k;
-			if (!folio_test_slab(folio))
-				folio_get(folio);
-		}
-		maxsize = min_t(size_t, maxsize, n * PAGE_SIZE - *start);
-		i->count -= maxsize;
-		i->iov_offset += maxsize;
-		if (i->iov_offset == i->bvec->bv_len) {
-			i->iov_offset = 0;
-			i->bvec++;
-			i->nr_segs--;
-		}
-		return maxsize;
-	}
-	if (iov_iter_is_folioq(i))
-		return iter_folioq_get_pages(i, pages, maxsize, maxpages, start);
-	if (iov_iter_is_xarray(i))
-		return iter_xarray_get_pages(i, pages, maxsize, maxpages, start);
-	return -EFAULT;
+	if (iov_iter_is_kvec(i))
+		return -EFAULT;
+	return iter_get_kernel_pages(i, pages, maxsize, maxpages, start);
 }
 
 ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,


