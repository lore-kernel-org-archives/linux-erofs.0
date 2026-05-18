Return-Path: <linux-erofs+bounces-3427-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652F5CD343F
	for <linux-erofs@archiver.kernel.org>; Mon, 18 May 2026 22:31:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gKCFT0mN6z2xMQ;
	Tue, 19 May 2026 08:31:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779143469;
	cv=none; b=BJ44Slu7U3xrkiQ5+p1CvjHM2Khb8/9aXc5aB/XzRA8yIR1GQZjHTqHQAVG6pkYxrvwcQ4l/pgfxqK22jieqSW/K0Y9kmv3oL53g1w+rT8HPFPy68jxAYkJ8R4Dp8hBGoMc1qLm3o1qh/H61TP6CJahyKdTRfrQkRefSAwBDPRyNydsAXHQggkjwb0GEn+caPTsLO7Rq3QltcexFUmpMaPIfnSnPQFLmPDLzF6laOE9cGlLb/cDRVIsb7I25j9czX/55gqdZlHpyj7JaeIbsHTKqFw7tQcw6nFeioj7LL13yWO9ueBayYNomVM2ZKEj27dd5mOsfsX8qwR2kgp+AQg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779143469; c=relaxed/relaxed;
	bh=vcN8r0sMSJfS+kOrSGHEP+bv70A9Lsgfu7bf9ESMv5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Nvl5SPKqgBR9OWi6KbEqbATecdUql0uaEd/y1eVqbqz/2natmlMMzev3I6YjS1GLzvEgrNFLgUoqXgA4gz8vhzTy7xbhmm8VNqFyBq40pjBu4td179n23JLaZ8zhZKXRoybIm/jhWpU3KmpsfeiTnxWnlaKlAbMJEMo6ehoYMopTTtXhRX/NtH5l5GMqmzgPy6GEEEhuewQPSsSH81aPdENMq/NeNAcV6lvanxI0rr0dYv1xbSOhAEtpn2bTd3Glzsy0vpkQDmq5Va1GoFCcHDdWgBwyw2yK+RE4/hRU2RRNn8rOLOiVHi7+VcNyxVV6RquHmrD0WJo/m8W/vtgtxg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y1xWNGFb; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y1xWNGFb; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y1xWNGFb;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y1xWNGFb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gKCFS1RSRz2xHK
	for <linux-erofs@lists.ozlabs.org>; Tue, 19 May 2026 08:31:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779143464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcN8r0sMSJfS+kOrSGHEP+bv70A9Lsgfu7bf9ESMv5s=;
	b=Y1xWNGFbxqfofBres9TbgCbW+DvXMMo6P4GMyVCt0gwSGRzYyg2nXHbmKMy1lACDNVN+63
	TkiFhN5H77ey6xdlVgwgg4qsGAA1Qt+jysdK941DMQGRTq/1byiCNqi5vC4rvRxgjktnu5
	iuOVh14MIYKl1hHt1aVI7rjC8I/+3WA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779143464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcN8r0sMSJfS+kOrSGHEP+bv70A9Lsgfu7bf9ESMv5s=;
	b=Y1xWNGFbxqfofBres9TbgCbW+DvXMMo6P4GMyVCt0gwSGRzYyg2nXHbmKMy1lACDNVN+63
	TkiFhN5H77ey6xdlVgwgg4qsGAA1Qt+jysdK941DMQGRTq/1byiCNqi5vC4rvRxgjktnu5
	iuOVh14MIYKl1hHt1aVI7rjC8I/+3WA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-m7JavSrTOOOJ-1I2d2y8Cw-1; Mon,
 18 May 2026 18:30:59 -0400
X-MC-Unique: m7JavSrTOOOJ-1I2d2y8Cw-1
X-Mimecast-MFC-AGG-ID: m7JavSrTOOOJ-1I2d2y8Cw_1779143457
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E245180044D;
	Mon, 18 May 2026 22:30:56 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 334351800352;
	Mon, 18 May 2026 22:30:49 +0000 (UTC)
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
Subject: [PATCH v2 05/21] Add a function to kmap one page of a multipage bio_vec
Date: Mon, 18 May 2026 23:29:37 +0100
Message-ID: <20260518222959.488126-6-dhowells@redhat.com>
In-Reply-To: <20260518222959.488126-1-dhowells@redhat.com>
References: <20260518222959.488126-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: Qpaly5ogM2X4vNzcj5GmGngOm6vV1lVFCS2Ez1PZa5U_1779143457
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
 include/linux/bvec.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index d36dd476feda..9df4a56fef61 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -299,4 +299,21 @@ static inline phys_addr_t bvec_phys(const struct bio_vec *bvec)
 	return page_to_phys(bvec->bv_page) + bvec->bv_offset;
 }
 
+/**
+ * kmap_local_bvec - Map part of a bvec into the kernel virtual address space
+ * @bvec: bvec to map
+ * @offset: Offset into bvec
+ *
+ * Map the page containing the byte at @offset into the kernel virtual address
+ * space.  The caller is responsible for making sure this doesn't overrun.
+ *
+ * Call kunmap_local on the returned address to unmap.
+ */
+static inline void *kmap_local_bvec(struct bio_vec *bvec, size_t offset)
+{
+	offset += bvec->bv_offset;
+
+	return kmap_local_page(bvec->bv_page + offset / PAGE_SIZE) + offset % PAGE_SIZE;
+}
+
 #endif /* __LINUX_BVEC_H */


