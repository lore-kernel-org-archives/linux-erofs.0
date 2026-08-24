Return-Path: <linux-erofs+bounces-4310-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDFF2C5DF81
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 14:43:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTDDs25YHz2y8p;
	Tue, 25 Aug 2026 00:43:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787582621;
	cv=none; b=JCQtv6uXehcpAUWJeV5HMtMnOxnh6QFG9Efxi8XaKb17ArA/nCzr3iOuqMgPn3QMhRGuIME7tLZCZ5KYXogtFeOVoXAlHGWvyW7ohrzY66sv5g+HS0g59Pl4rSP1hNW/uSSzKOz5S4iFn4kP+NhTgFZ34ilvuwQbVKxpJQ1Cqi2f6Wc/gh8rtt80lWyY+itF+h14OZDwnIp+bXipAh7rRu7NeGzYcEJ/nsiJz6ks8ZRzSUQfWbMOH3UmJMsNCsbvJVnVll40IkQixtem40hERKwrIeGZLzNGOInkQt2VuDvXcWozqzMHLUhpyHyhldjCVzeOORYihoASORICd2pq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787582621; c=relaxed/relaxed;
	bh=mAcMtWnodpY2/7YJsnesasXtJNGD58hwio/z27wR72E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gwO9EF890AoiqIDci70SqHO9BCmn5LHg/GQVJb91O6lNWJKKsOl5o4N0Y9eWiq0WUt6OysD4ssaZTK9utzpFTnvt+rRukregBZWyK1qlPPl3zTFCuKdNIluDRvbep5OALmTdm9W5RSxsNOl51S5rialv3ZR12WFhPxiJzq1w/Cjqz4fIIS+ZRuhfigAw/tMmj+RVXRTdj+E8OOUDsHjzEj8ohK9gEIfdsEgUyO0gOMyj5u4r/pzumH9Z9qIBhtqFOoAE5vW81MTw4lJOYC5E+rWRLe9XySA4kAZ9nJ7xexhtIDx9/UC76r4cg/coZE7KLP1GXX9HZGJK0crDifT8zg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OnBN0iTm; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OnBN0iTm; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OnBN0iTm;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OnBN0iTm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTDDr20KCz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 00:43:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAcMtWnodpY2/7YJsnesasXtJNGD58hwio/z27wR72E=;
	b=OnBN0iTmP16o712PBnVM20wm+RCnQg9TK55SAB5ykqnYAeB526xNMcNHKHUdMultMZzO24
	dWdhGLx+p2mCBa0ldkdLR+9UY8j/WqevRs6gffwcU93aS2JU45VkLCfQ8SdK87W7F6oALl
	zEoh2a/PpY3jqNKG3bf8u5NiU843CB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAcMtWnodpY2/7YJsnesasXtJNGD58hwio/z27wR72E=;
	b=OnBN0iTmP16o712PBnVM20wm+RCnQg9TK55SAB5ykqnYAeB526xNMcNHKHUdMultMZzO24
	dWdhGLx+p2mCBa0ldkdLR+9UY8j/WqevRs6gffwcU93aS2JU45VkLCfQ8SdK87W7F6oALl
	zEoh2a/PpY3jqNKG3bf8u5NiU843CB0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-MYj2p4IGMJyVwFx8awMGow-1; Mon,
 24 Aug 2026 10:43:30 -0400
X-MC-Unique: MYj2p4IGMJyVwFx8awMGow-1
X-Mimecast-MFC-AGG-ID: MYj2p4IGMJyVwFx8awMGow_1787582607
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F04E2185FE77;
	Mon, 24 Aug 2026 14:43:26 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2B681955D6D;
	Mon, 24 Aug 2026 14:43:20 +0000 (UTC)
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
Subject: [PATCH v10 12/35] netfs: Make mempool available for bvecq
Date: Mon, 24 Aug 2026 15:41:05 +0100
Message-ID: <20260824144130.759997-13-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: _Iq_u9dUxcHpZEr-PZH8FcCGBYw_qvbi-R4KyDAcyT0_1787582607
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make a mempool available for allocating bvecq structs.  Use it
automatically if anything other than GFP_KERNEL (with GFP_ZONEMASK flags
masked off) is specified.  Reading from a file can use GFP_KERNEL as the
failure mode is straightforward and the same for DIO reads and writes.
When it comes to writeback, however, the writeback_iter() API does not
permit temporary failure, including ENOMEM, if WB_SYNC_ALL is set and the
caller must process all folios to completion.  (I'm not sure if EINTR
constitutes an acceptable failure).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/bvecq.c      | 39 +++++++++++++++++++++++++++++++++------
 fs/netfs/internal.h   |  1 +
 fs/netfs/main.c       |  7 +++++++
 include/linux/bvecq.h |  3 +++
 4 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/fs/netfs/bvecq.c b/fs/netfs/bvecq.c
index 6905c84ea351..7b0aedafeda9 100644
--- a/fs/netfs/bvecq.c
+++ b/fs/netfs/bvecq.c
@@ -44,8 +44,9 @@ EXPORT_SYMBOL(bvecq_dump);
  *
  * Allocate a single bvecq node and initialise the header.  A number of inline
  * slots are also allocated, rounded up to fit after the header in a power-of-2
- * slab object of up to 512 bytes (up to 29 slots on a 64-bit cpu).  The slot
- * array is not initialised.
+ * slab object of up to 512 bytes (up to 29 slots on a 64-bit cpu).  The caller
+ * should be aware that the number of slots allocated may be more or less than
+ * the number requested.  The slot array is not initialised.
  *
  * Return: The node pointer or NULL on allocation failure.
  */
@@ -56,16 +57,39 @@ struct bvecq *bvecq_alloc_one(size_t nr_slots, gfp_t gfp, bool for_writeback)
 	const size_t max_slots = (max_size - sizeof(*bq)) / sizeof(bq->__bv[0]);
 	size_t part = min(nr_slots, max_slots);
 	size_t size = roundup_pow_of_two(struct_size(bq, __bv, part));
+	bool from_pool = false;
 
-	bq = kmalloc(size, gfp & ~GFP_ZONEMASK);
-	if (!bq)
-		return bq;
+	gfp &= ~(GFP_ZONEMASK | __GFP_THISNODE);
+
+	if (for_writeback) {
+		if (size != BVECQ_STD_SIZE) {
+			gfp_t gfp_temp = gfp;
 
+			gfp_temp |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+			gfp_temp &= ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
+			bq = kmalloc(size, gfp_temp);
+			if (bq)
+				goto success;
+		}
+
+		bq = mempool_alloc(&netfs_bvecq_pool, gfp);
+		if (!bq)
+			return bq;
+		from_pool = true;
+		size = BVECQ_STD_SIZE;
+	} else {
+		bq = kmalloc(size, gfp);
+		if (!bq)
+			return bq;
+	}
+
+success:
 	*bq = (struct bvecq) {
 		.ref		= REFCOUNT_INIT(1),
 		.bv		= bq->__bv,
 		.inline_bv	= true,
 		.max_slots	= (size - sizeof(*bq)) / sizeof(bq->__bv[0]),
+		.from_pool	= from_pool,
 	};
 	netfs_stat(&netfs_n_bvecq);
 	return bq;
@@ -245,7 +269,10 @@ void bvecq_put(struct bvecq *bq)
 			bvecq_free_slot(bq, slot);
 		next = bq->next;
 		netfs_stat_d(&netfs_n_bvecq);
-		kfree(bq);
+		if (bq->from_pool)
+			mempool_free(bq, &netfs_bvecq_pool);
+		else
+			kfree(bq);
 	}
 }
 EXPORT_SYMBOL(bvecq_put);
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 8db2c82004a4..431ec77b1305 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -43,6 +43,7 @@ extern struct list_head netfs_io_requests;
 extern spinlock_t netfs_proc_lock;
 extern mempool_t netfs_request_pool;
 extern mempool_t netfs_subrequest_pool;
+extern mempool_t netfs_bvecq_pool;
 extern mempool_t netfs_folioq_pool;
 
 #ifdef CONFIG_PROC_FS
diff --git a/fs/netfs/main.c b/fs/netfs/main.c
index 927badf3989d..9f72e5054aff 100644
--- a/fs/netfs/main.c
+++ b/fs/netfs/main.c
@@ -28,6 +28,7 @@ static struct kmem_cache *netfs_request_slab;
 static struct kmem_cache *netfs_subrequest_slab;
 mempool_t netfs_request_pool;
 mempool_t netfs_subrequest_pool;
+mempool_t netfs_bvecq_pool;
 mempool_t netfs_folioq_pool;
 
 #ifdef CONFIG_PROC_FS
@@ -112,6 +113,9 @@ static int __init netfs_init(void)
 	if (mempool_init_kmalloc_pool(&netfs_folioq_pool, 100, sizeof(struct folio_queue)) < 0)
 		goto error_folioq_pool;
 
+	if (mempool_init_kmalloc_pool(&netfs_bvecq_pool, 100, BVECQ_STD_SIZE) < 0)
+		goto error_bvecq_pool;
+
 	netfs_request_slab = kmem_cache_create("netfs_request",
 					       sizeof(struct netfs_io_request), 0,
 					       SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
@@ -164,6 +168,8 @@ static int __init netfs_init(void)
 error_reqpool:
 	kmem_cache_destroy(netfs_request_slab);
 error_req:
+	mempool_exit(&netfs_bvecq_pool);
+error_bvecq_pool:
 	mempool_exit(&netfs_folioq_pool);
 error_folioq_pool:
 	return ret;
@@ -178,6 +184,7 @@ static void __exit netfs_exit(void)
 	kmem_cache_destroy(netfs_subrequest_slab);
 	mempool_exit(&netfs_request_pool);
 	kmem_cache_destroy(netfs_request_slab);
+	mempool_exit(&netfs_bvecq_pool);
 	mempool_exit(&netfs_folioq_pool);
 }
 module_exit(netfs_exit);
diff --git a/include/linux/bvecq.h b/include/linux/bvecq.h
index 22fc7995f3ee..8adfdd43b865 100644
--- a/include/linux/bvecq.h
+++ b/include/linux/bvecq.h
@@ -43,15 +43,18 @@ struct bvecq {
 	u16		max_slots;	/* Number of elements allocated in bv[] */
 	enum bvecq_mem	mem_type:3;	/* What sort of memory and how to free it */
 	bool		inline_bv:1;	/* T if __bv[] is being used */
+	bool		from_pool:1;	/* T if bvecq from mempool */
 	struct bio_vec	*bv;		/* Pointer to array of page fragments */
 	struct bio_vec	__bv[];		/* Default array (if ->inline_bv) */
 };
 
 #if BITS_PER_LONG == 64
 /* Number of slots in __bv[] for a bvecq in a 512-byte kmalloc block. */
+#define BVECQ_STD_SIZE		512
 #define BVECQ_STD_SLOTS		29	/* 2 words/slot; 32 slots; bvecq is 6 words (3 slots) */
 #elif  BITS_PER_LONG == 32
 /* Number of slots in __bv[] for a bvecq in a 256-byte kmalloc block. */
+#define BVECQ_STD_SIZE		256
 #define BVECQ_STD_SLOTS		18	/* 3 words/slot; 21 slots; bvecq is 9 words (3 slots) */
 #else
 #error BVECQ_STD_SLOTS undetermined


