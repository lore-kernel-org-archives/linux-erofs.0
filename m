Return-Path: <linux-erofs+bounces-3959-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569DEC44536
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 13:04:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4vb75tgWz2yfS;
	Wed, 22 Jul 2026 23:04:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784725443;
	cv=none; b=V1SXC26FfAvGtIOHxJX/WYFc5NunlSucdq50TnvD4rZgNxeIro5zLOkwF41uXMvk7HfcMUgtaLKdZ9TbsaJfo46sV9uCbIBjfHkgBSZsEpCxdSwab12+9vhijL+IwiOJEFH3zmbzPTBtegmQdXor8r1cRMPnfDdtXND5OMfbI5caI5eyNglEoQuJPynfFeVmKpflfSTKVhzN/4E5JpXrn2ilfpZiG6Nvlt9F7OhGZR8a/EOCO1yc7EilZYwRqrKpzGkL0+gujeHPaiarfePYD/c9eTF0d0uANE8IBuhpPrxCuy01mJZ7zk4CR8g21nCXYmKF+poy1CTnmt36LkBcIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784725443; c=relaxed/relaxed;
	bh=forfFVNHXdcKUrAO6tYWFvQxC3xkWQUr9XOJVlaCNVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hTX5tK4LBymCKnDi5ZmrTGfHKCaxCBncuuREjexmzayQ0eN4DJkR9Y96YmOIiR8jz1CqwFjQ8JRfDqLvkjqKXcCxZdT7ge9LyhJESkviwZvphb5zKdz2NsldkPQofXehEp8YeXjtnUtmZiG5cgNxZ5kEvIrvWvnn8+HPsp1AytrNCokPRG+3oWFe2hoaP4VRi1g8t8IwefSKb3ipaquBvyg5C2mxBhNgREvQVTvq33wyGjIp0TsAjqXdGepPtHy7yt5EVfvz9ct18owtIlstu8la+VDNjPrBuVru8AkpNOO9dAKdAbAT8bmx9o2IY26Sa/kG0ms1pTya0AKIHYj8nQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cfi3h9g3; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cfi3h9g3; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cfi3h9g3;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cfi3h9g3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4vb60kMtz2yfH
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 23:04:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=forfFVNHXdcKUrAO6tYWFvQxC3xkWQUr9XOJVlaCNVg=;
	b=cfi3h9g3Y4FBDY0X+sVMFa/u8s7rf1IzzK36JAp2XXKiATXU5maW/pgMF5ps2+v+nrOh+J
	pxboPT4Ch9saVtKcqpkL7VLHaPvBWjqxPKj8/d8jk6EmIrKEvdqo4ODrymgYoVpTGQufNa
	a0JJEH1Pdvh86nI5Yt8ZDAKj5XzeK6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=forfFVNHXdcKUrAO6tYWFvQxC3xkWQUr9XOJVlaCNVg=;
	b=cfi3h9g3Y4FBDY0X+sVMFa/u8s7rf1IzzK36JAp2XXKiATXU5maW/pgMF5ps2+v+nrOh+J
	pxboPT4Ch9saVtKcqpkL7VLHaPvBWjqxPKj8/d8jk6EmIrKEvdqo4ODrymgYoVpTGQufNa
	a0JJEH1Pdvh86nI5Yt8ZDAKj5XzeK6g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-H_oeY_ZgO5SV5KucMeI5DQ-1; Wed,
 22 Jul 2026 09:03:52 -0400
X-MC-Unique: H_oeY_ZgO5SV5KucMeI5DQ-1
X-Mimecast-MFC-AGG-ID: H_oeY_ZgO5SV5KucMeI5DQ_1784725428
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D986718E6A5B;
	Wed, 22 Jul 2026 13:03:47 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CEAB8763;
	Wed, 22 Jul 2026 13:03:41 +0000 (UTC)
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
Subject: [PATCH v7 09/29] Add a function to kmap one page of a multipage bio_vec
Date: Wed, 22 Jul 2026 14:01:56 +0100
Message-ID: <20260722130218.78958-10-dhowells@redhat.com>
In-Reply-To: <20260722130218.78958-1-dhowells@redhat.com>
References: <20260722130218.78958-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 7ur-z6dsWzUe4akhuyAsDqFvbFFCOGLnWTYVBAW4UDQ_1784725428
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add a function to kmap one page of a multipage bio_vec by offset (which is
added to the offset in the bio_vec internally).  The caller is responsible
for calculating how much of the page is then available.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: linux-block@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/bvec.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 92837e2743f1..53cf36e73967 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -343,4 +343,22 @@ static inline phys_addr_t bvec_phys(const struct bio_vec *bvec)
 	return page_to_phys(bvec->bv_page) + bvec->bv_offset;
 }
 
+/**
+ * bvec_kmap_partial - Map part of a bvec into the kernel virtual address space
+ * @bvec: bvec to map
+ * @offset: Offset into bvec
+ *
+ * Map the page containing the byte at @offset into the kernel virtual address
+ * space.  The caller is responsible for making sure this doesn't overrun.
+ *
+ * Call kunmap_local on the returned address to unmap.
+ */
+static inline void *bvec_kmap_partial(struct bio_vec *bvec, size_t offset)
+{
+	offset += bvec->bv_offset;
+
+	return kmap_local_page(bvec->bv_page + (offset >> PAGE_SHIFT)) +
+		(offset & ~PAGE_MASK);
+}
+
 #endif /* __LINUX_BVEC_H */


