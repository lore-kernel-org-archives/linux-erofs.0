Return-Path: <linux-erofs+bounces-3541-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6653CCD8CA4
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Jun 2026 14:58:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gYw8f4fMQz3btX;
	Tue, 09 Jun 2026 00:56:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780930562;
	cv=none; b=TzesYSS+o4SKjDD2CJX8zT0Pp+FRZZIDkoz4RzkhCSdKJf4/xNbcrg1sGsaXy6UFgcyRbuJKR4gKUtQzyWitV8kmbMjkscVJUqtHEyBWoxkO/VqdNchtXIGi7dDSvdXB0OqERtt19MNPsqK0qscteg43eQmklcun0wqB+ALYeeLBJ+13MbBbV7mMHgWpOvSB8wbD0bfyjOADvgknY+OpNYs3yThA16U5LqVsZEYTMg0gxKTq0bIFLkJ7ppa/Hfq+GiuAk2uR/CxkLbiCnu32iv0ZmUKEh/ItwddEgJagz5B/cY68x4AHHEMVIQtgoEo0epd80pa/iwuQ5Pqf1euoNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780930562; c=relaxed/relaxed;
	bh=x2ry9yfrsp4bz8l1rJhaUu5Q7jTF4XqPXt4HsPXH488=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VyHgn3IzNecqTUO5xoN/ByhA1vwVzJ+Gc+zMnSWrmBO18WwOlMmLM7OMgf8Y9GpfClX7GTau0on+JPhSCDRvFSo9DdwosmsYpFjAzAcB2/FbeOJmL9dYw8CCyMsANpmR7T8RfabnDYix7krPh7/K/kY1uhhc2zNJ3UeHUfJncWdazfaAxBDb+hGQzaLidqEfP/KqVrbZlkNliXzobJQvgv4DQjRtfSTQdd12JvWGNAU8Mw2J2P3Swi7cqAKL2xOngriXdckVxPk/1GtsqStV8uzmxVZ7wne/K8/Ifhj1jUXgoMK6p91Yq6bz6GkXBd0EH++H3/UAxkmVfI1eUMKLNg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AJKvjc6A; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AJKvjc6A; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AJKvjc6A;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AJKvjc6A;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gYw8d4XK6z30FP
	for <linux-erofs@lists.ozlabs.org>; Tue, 09 Jun 2026 00:56:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780930558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x2ry9yfrsp4bz8l1rJhaUu5Q7jTF4XqPXt4HsPXH488=;
	b=AJKvjc6Am+VTCHRPuoh9gATkSAcrxlYdDkFijwsApbc30pekgiknXdzuZNwfFP9m3aBZtQ
	2sZ36dQy78xkMuEz2s0W+ilonggv7EcwKg2g8Lons6DAPzUds/y3YD8A+2DEXapSsTa7ni
	fp+49mMArpdwM3NQz87viuA9BmBYtZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780930558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x2ry9yfrsp4bz8l1rJhaUu5Q7jTF4XqPXt4HsPXH488=;
	b=AJKvjc6Am+VTCHRPuoh9gATkSAcrxlYdDkFijwsApbc30pekgiknXdzuZNwfFP9m3aBZtQ
	2sZ36dQy78xkMuEz2s0W+ilonggv7EcwKg2g8Lons6DAPzUds/y3YD8A+2DEXapSsTa7ni
	fp+49mMArpdwM3NQz87viuA9BmBYtZE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-IeqPMvgxOP6dxbSt13DTxQ-1; Mon,
 08 Jun 2026 10:55:51 -0400
X-MC-Unique: IeqPMvgxOP6dxbSt13DTxQ-1
X-Mimecast-MFC-AGG-ID: IeqPMvgxOP6dxbSt13DTxQ_1780930548
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1575180064A;
	Mon,  8 Jun 2026 14:55:47 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.43])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 746EA19541B0;
	Mon,  8 Jun 2026 14:55:41 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
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
	linux-block@vger.kernel.org
Subject: [PATCH v3 07/22] iov_iter: Make iov_iter_get_pages*() wrap iov_iter_extract_pages()
Date: Mon,  8 Jun 2026 15:54:15 +0100
Message-ID: <20260608145432.681865-8-dhowells@redhat.com>
In-Reply-To: <20260608145432.681865-1-dhowells@redhat.com>
References: <20260608145432.681865-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: YGuZQmhzISv0DzgnEadH5CIBEipvqegtBynRwuVy1FY_1780930548
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
index 243662af1af7..cac7d7364bc2 100644
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
+		if (!folio_test_slab(folio))
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


