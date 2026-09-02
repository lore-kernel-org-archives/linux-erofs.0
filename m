Return-Path: <linux-erofs+bounces-4427-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB15C61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 17:34:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZqbn551nz2xmh;
	Thu, 03 Sep 2026 03:34:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788370469;
	cv=none; b=i3i3IU84wZMNKYNsrm3Dl2lFJYXZ9pESrsjSnuN9qsB927qqrk3iMyrl336uR09UmxVuqKy75H2kBaVYhhDrrM+stbW27J92VB5FzTN2JVoNy8D7xpbh7UO3GNe+LMBlAyHw2Ye/DU5II0laaIogJIugAtwnZ9ECUuLoVCYlz1FOapUGWplBTvVwa+k2SzICDOKr/vCMqJYl2oywG87qlmETy2+uRoUVNdHT+bnfVGpqvdki2wQh5MK4FtqPfOe+z5buO38pjJBe7OWFNHrEOlt9a4sOoAGvhifBKKv0/xAI5VnopvuMgtjKZ0rz0xCd8DXyC/l4mVOqaHWEhCc0Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788370469; c=relaxed/relaxed;
	bh=S1mHfpJtfgW7FfYonnBE3YCotB2uCWD3Ae3Wfyv8mlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PaFzloqLIxsQa5LsL+kIKeJOjDXow5/zjaUrVQVxagmgbFR5laJ5QMq5xF9ODZXxpzdduWzF3V8ElYdEqdoJZtMssc5hwIAwGQ5z2ibwe9E63NfRaFa/h9GytjSGEVgWh4k6ykdUMk/i9XKX2qHuQ4c6Btomr+TvL5ufgBrkDOx56q9sNpI+JdhZd3wxB0qb80/9Sd30/hsVG1A/0SMyURnApf7DTh3Gdi/gdF6UuPe7GqMUwdB0Ut3kwdpyLG9fCqM20TAlpL/Fv4Xu/gLKxQoVlGZb/Z4HZC3MVhwMxDK5QwxUYg6cN8nN987ntzY71+V6l+jgx01EvPc4SIMhmw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SfJ56G1v; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SfJ56G1v; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SfJ56G1v;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SfJ56G1v;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZqbm38MTz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 03:34:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S1mHfpJtfgW7FfYonnBE3YCotB2uCWD3Ae3Wfyv8mlE=;
	b=SfJ56G1v3aO/35KkgyOqA05e3XIfdpAGOOK1qDT6JH+dq91+7LmHZ+UwIbb6WVANSY+x4E
	Rsa4WTcg4sn73wvv5lnF/IWBaoyX/9yP4yjHEwEPhnMwEe+HVjvm8uIHZycb+Ck654GEAY
	sMSXfgry1JENUosGqBZ9yOaxbUqVohc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S1mHfpJtfgW7FfYonnBE3YCotB2uCWD3Ae3Wfyv8mlE=;
	b=SfJ56G1v3aO/35KkgyOqA05e3XIfdpAGOOK1qDT6JH+dq91+7LmHZ+UwIbb6WVANSY+x4E
	Rsa4WTcg4sn73wvv5lnF/IWBaoyX/9yP4yjHEwEPhnMwEe+HVjvm8uIHZycb+Ck654GEAY
	sMSXfgry1JENUosGqBZ9yOaxbUqVohc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-ZODp_KndNZm17-U_q-6IAw-1; Wed,
 02 Sep 2026 13:34:18 -0400
X-MC-Unique: ZODp_KndNZm17-U_q-6IAw-1
X-Mimecast-MFC-AGG-ID: ZODp_KndNZm17-U_q-6IAw_1788370455
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABF50195DE0A;
	Wed,  2 Sep 2026 17:34:13 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D66D1955D69;
	Wed,  2 Sep 2026 17:34:03 +0000 (UTC)
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
	Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org
Subject: [PATCH v11 01/36] block: Fix start and length check added to iov_iter_extract_bvecs()
Date: Wed,  2 Sep 2026 18:33:13 +0100
Message-ID: <20260902173350.3468672-2-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: ud1uzBhjSecljE9HTPWpQwxTZf2hVnk5hMxUXa9ZjhM_1788370455
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Commit 14b007e17881 added an address check using iter_iov_addr() and a
length check using iter_iov_len() to iov_iter_extract_bvecs(), but these
cannot be used so and are unsafe in this circumstance as the functions have
hardwired assumptions about the iterator type.  They should only be used
with ITER_UBUF or ITER_IOVEC-type iterators; they shouldn't be used with
ITER_BVEC, ITER_KVEC, ITER_FOLIOQ, ITER_XARRAY or ITER_DISCARD iterators.

This proves to be a problem for cachefiles as an iterator of type
ITER_FOLIOQ is passed and iter_iov_addr() and iter_iov_len() both
malfunction because iter->__iov in iter_iov() is not pointing to an iovec
array.

Fix this by using iov_iter_alignment() instead.

Fixes: 14b007e17881 ("block: validate user space vectors during extraction")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
cc: Hannes Reinecke <hare@kernel.org>
cc: Christoph Hellwig <hch@lst.de>
cc: Jens Axboe <axboe@kernel.dk>
cc: Alexander Viro <viro@zeniv.linux.org.uk>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-block@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 lib/iov_iter.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 6665372ecf71..c489569a5815 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1921,15 +1921,22 @@ ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv,
 		unsigned short max_vecs, unsigned mem_align_mask,
 		iov_iter_extraction_t extraction_flags)
 {
-	unsigned long start = (unsigned long)iter_iov_addr(iter);
 	unsigned short entries_left = max_vecs - *nr_vecs;
 	unsigned short nr_pages, i = 0;
 	size_t left, offset, len;
 	struct page **pages;
 	ssize_t size;
 
-	if ((start | iter_iov_len(iter)) & mem_align_mask)
+	if (likely(iter_is_ubuf(iter) ||
+		   iter_is_iovec(iter) ||
+		   iov_iter_is_kvec(iter))) {
+		unsigned long start = (unsigned long)iter_iov_addr(iter);
+
+		if ((start | iter_iov_len(iter)) & mem_align_mask)
+			return -EINVAL;
+	} else if (iov_iter_alignment(iter) & mem_align_mask) {
 		return -EINVAL;
+	}
 
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far as


