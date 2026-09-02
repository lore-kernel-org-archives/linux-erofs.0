Return-Path: <linux-erofs+bounces-4435-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9574FC61DD6
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 17:35:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZqd41vpDz2y21;
	Thu, 03 Sep 2026 03:35:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788370536;
	cv=none; b=Jr3ZEWDl7HAp77gHjIpj63CCegc1vxY7PwTBb+xXA6UHOSbYHFY2MQwqNZyeFNaB1T5xM8BdqjPD6OckzLARbfLp3pln//7zOQUD9KGQ5wGTaD1d7DOLg6KMZmBpLKnL37g6dmemltkKo7I+evoLDpP9mKmXXDDJvdbmRlVUc+rq5AmoneL63TRiZCIONxFlqYbN7NSt5awBev4xoXGda8OI9mK/G+agZ2Fwm9dFYpY58/eLUec6BRC1VXicju4NLepCEUdG7GYnfCKjf8Xroiz7wpVgL4SnxTaOTbP/dCbu3HsbqpkIJjEAJw6Ocxa8EB7ofz3QIbZ7tfYx8igk0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788370536; c=relaxed/relaxed;
	bh=3V3OD3nT0V6U72OmpSYHtRK3iKHj2x5V79xiNQUQCgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DE4sqWC2+tWA+mvZ/YYcoLuOLBHf1AQQ1IYsyyGaElvEE5Pn2yTA2LjlRCozoLWDTWHa+OJfPtqXrs4MzVBd21FnxQVm5CTUwHXZAQydFA8zDqMMPUbOlgOmIx6Vgd8+JOnWLdK+Ud/NeLjN0lh8hZuYkI5MkTdq+KIvCo5IDICw6IoxNud3tSFcdUqIJDJFwXDxF69XDSp60/xJdOZw5y4D1fg0RDi7SIjSH+HB2hYx+3VomSB4fwCx/X4Vgg3jYaDnasVG4vux31iPNv4zUU0QrDn4C2HeTyC8Hm8oaCZjN4IX7LddPGa6XCmjizgzHldBJZxWzsxU5lbEyLTc5w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XUsVmhVh; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XUsVmhVh; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XUsVmhVh;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XUsVmhVh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZqd311YTz2xl6
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 03:35:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3V3OD3nT0V6U72OmpSYHtRK3iKHj2x5V79xiNQUQCgQ=;
	b=XUsVmhVhsimTXActrfwbvVepE/cYNGNACoISeOjz0o+uZtdDxEnrYAoFahO31tis0gdFwB
	aEVaY/eQdYaFHZiwJ/pVJkKySYKq2jE1SrFFLv594ckQIOiP2lD0cbswf5Pjtaz77zqZ6A
	8h5Z0APHynahXT69h3Em5kPkUdnkPqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3V3OD3nT0V6U72OmpSYHtRK3iKHj2x5V79xiNQUQCgQ=;
	b=XUsVmhVhsimTXActrfwbvVepE/cYNGNACoISeOjz0o+uZtdDxEnrYAoFahO31tis0gdFwB
	aEVaY/eQdYaFHZiwJ/pVJkKySYKq2jE1SrFFLv594ckQIOiP2lD0cbswf5Pjtaz77zqZ6A
	8h5Z0APHynahXT69h3Em5kPkUdnkPqc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-9e5O7xjaN3ySDs1lrB8c3g-1; Wed,
 02 Sep 2026 13:35:23 -0400
X-MC-Unique: 9e5O7xjaN3ySDs1lrB8c3g-1
X-Mimecast-MFC-AGG-ID: 9e5O7xjaN3ySDs1lrB8c3g_1788370520
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29DD0192DD6D;
	Wed,  2 Sep 2026 17:35:20 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF17B1800643;
	Wed,  2 Sep 2026 17:35:13 +0000 (UTC)
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
Subject: [PATCH v11 09/36] netfs: Make mempool available for bvecq
Date: Wed,  2 Sep 2026 18:33:21 +0100
Message-ID: <20260902173350.3468672-10-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: duHwIAXZwHfsMwkeNKxf-ZKuDpHOocTSn9zV7oSxEWk_1788370520
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
index ef08f0096192..6d40a69e032f 100644
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


