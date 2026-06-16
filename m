Return-Path: <linux-erofs+bounces-3605-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580DFCD98E7
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 10:09:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfjQr0Bh4z3brH;
	Tue, 16 Jun 2026 20:09:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781604595;
	cv=none; b=fD3XK3aUX1de/Z4qSKyL3lhMs+ar52qgMYsgoBA9Sk/5MdoRNx/zgZudmS0PJenEThv3E1d0HvCae3pgvPPz/UeYdAAOVyUVg3FObr7bHa9/wIGTo/MReUzPv/lJ2ebh5jnwgbTf7OsBcMcNGDwd38rvIpvKLakq/PW2/yUroxBgjv4dzUIVTDnVD4CmseFCA+BxZPxJ+4kJ6bhXcLnGQFyksfqihhhoPRl38NzrD++F5Gr9/kwTpETQqNun40vpe8ytBkfhahbJGGlr8AnWvnYmAL43oGxFHP45lbgHNOebOVZCjRfvge84roVYgKmO+W6YSua3wbv2MKWatXwq5g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781604595; c=relaxed/relaxed;
	bh=p9DNEnvUuEWndqSbROk8DKtJ535ilbu1JwdDRpUce88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cpaTEkmdx6T5E75xACgVW2q4DoyLg+5QaNjkqw8F05RzPxusEeO5tS7JknaIyTLbkhcHKIj4liIANflXydHSAe9uNEypEQv+N6ppPS5WdcYoPqeapEKdQn4CiHqQFRIzMDbQfPz2lGVwvWEH/lF6ZRqZFhhZM5/BOsKpOTiCltSl++D2TWkPpaSYS2GNBE1Egx6jN+ipWJEFLuwdjgehimkC99xqu32UM4FoM+c3pEkeA0z0PzamklmcWvZ/IeqfjKl3WhxQwV8wTBCTVghVunGT2dPNyAgAh/1SUACDWcWXypwiRcQiSNwcW/ZSFCIK49gLp2lweTL8D0tRtVHlaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PGuHcoQ/; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PGuHcoQ/; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PGuHcoQ/;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PGuHcoQ/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfjQq0hnmz3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 20:09:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p9DNEnvUuEWndqSbROk8DKtJ535ilbu1JwdDRpUce88=;
	b=PGuHcoQ/Lak1vw6JyGz28thGLv2jiZHofBHkw1Z8D+n47QoY/n3WVMYboG6IJhngFvyt2L
	uBdi6tje4d12/Gva9EOmD+FfFKT6KzVTKd9aOjsr2xJxuqkAXPnEjyBfzOZ21Akz1H9/W3
	OXfv53v0kzdCF3tc5bDreT0/G36mXjI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p9DNEnvUuEWndqSbROk8DKtJ535ilbu1JwdDRpUce88=;
	b=PGuHcoQ/Lak1vw6JyGz28thGLv2jiZHofBHkw1Z8D+n47QoY/n3WVMYboG6IJhngFvyt2L
	uBdi6tje4d12/Gva9EOmD+FfFKT6KzVTKd9aOjsr2xJxuqkAXPnEjyBfzOZ21Akz1H9/W3
	OXfv53v0kzdCF3tc5bDreT0/G36mXjI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-tzbC4J7tO7aO9tOQbD3bZA-1; Tue,
 16 Jun 2026 06:09:44 -0400
X-MC-Unique: tzbC4J7tO7aO9tOQbD3bZA-1
X-Mimecast-MFC-AGG-ID: tzbC4J7tO7aO9tOQbD3bZA_1781604582
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 095661954B3A;
	Tue, 16 Jun 2026 10:09:42 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8622419560B2;
	Tue, 16 Jun 2026 10:09:35 +0000 (UTC)
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
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/30] netfs: Fix kdoc warning
Date: Tue, 16 Jun 2026 11:07:57 +0100
Message-ID: <20260616100821.2062304-9-dhowells@redhat.com>
In-Reply-To: <20260616100821.2062304-1-dhowells@redhat.com>
References: <20260616100821.2062304-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: joBYDKxYP0r3Z05_iUGam9NSukZtwNJKN2WF91hWTXU_1781604582
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix a kdoc warning due to a misnamed parameter in the description.

Reported-by: Matthew Wilcox <willy@infradead.org>
cc: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/netfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 06e6cceffaeb..1bc120d61c5b 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -760,7 +760,7 @@ static inline void netfs_inode_init(struct netfs_inode *ctx,
 
 /**
  * netfs_resize_file - Note that a file got resized
- * @ctx: The netfs inode being resized
+ * @ictx: The netfs inode being resized
  * @new_i_size: The new file size
  * @changed_on_server: The change was applied to the server
  *


