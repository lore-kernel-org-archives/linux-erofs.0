Return-Path: <linux-erofs+bounces-3954-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B591C44536
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 13:03:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4vZJ0PNcz2yfH;
	Wed, 22 Jul 2026 23:03:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784725400;
	cv=none; b=DoS4Qu8t3wOPzmjSqieki7L3RZCcMKYIlw4yRm/oMRJp9B4dBbdqFLd+kTmpgAZDIgmvz/ruliz4G0QwQSGYpQkPUEkHW6EsOzp1ZGB+ybl2BTW8zQ4VkLfnk2VEM8HNKtj31jS0CqOi8AjX/NCk1avQIC/+ahATm2RCaHS4zj/4Sml+RxSIhJRHBCAJmDDsHhHipgPCQjTlAkEQuF2dXczM9W3/SaTaY3fHa2cpwScOe46xwMLgdfI5fNfwWUp7IsY3UoyFkSnvW3pLJ0HVv5414avSoA6l9pWXBWvIU4iSGWrEfF5AQ5svPOA4ZU8OU/NHOIZr3/i1CVy08fYfMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784725400; c=relaxed/relaxed;
	bh=NQ4xYgPisX1eloJMBrUIHWw1g1geoI0YKTxulh3uSC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UHZYbsfVSpdsoeNLMEEUH8DrNoDAxep0IU7zkF1fkaS4Ifm9jGpqch4Zkxz9X6QtdGJrfjcskZ692skNwPSr4bE6D/DBCVbX6k4+Q5gr9JStjmL694btxys75LFNsBFohDpIt9vq0YoF2dQfAbna+XVAeRjkgYb0vxO6dFjjx8QPxslZL4vOaweWnDyOeqQpAIb+uibyTZsrla5qYlD0GeNuT/o3kxHOc+Mhg3g/6mSLWiXnFGjoATItjiWRlFZ3DkHet6lovFf5twh6N5X0Ryg4B994UY15SkL1BGL78z1bAHseRdwMSFzdgDYLsfJa4MVbVe2wjusedWcen2Ursw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VmqyGIhh; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VmqyGIhh; dkim-atps=neutral; spf=permerror (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VmqyGIhh;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VmqyGIhh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4vZH06tcz2ydn
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 23:03:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQ4xYgPisX1eloJMBrUIHWw1g1geoI0YKTxulh3uSC0=;
	b=VmqyGIhhza8RjswGw6YBAhj5uLpuSs6eJwQbeD46Wz8Eg0RT41+gcGb6dAywtfrPgL8Al2
	DaldZGR8XN0TsTBguk+26oQ/OmzvmnX80tY4kNg2OqSHHEoDe3w5uzdtYyQ2kL9O5BVik6
	XkY7b/rNNsjG0umqc0YA1NojmAxb6Ro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQ4xYgPisX1eloJMBrUIHWw1g1geoI0YKTxulh3uSC0=;
	b=VmqyGIhhza8RjswGw6YBAhj5uLpuSs6eJwQbeD46Wz8Eg0RT41+gcGb6dAywtfrPgL8Al2
	DaldZGR8XN0TsTBguk+26oQ/OmzvmnX80tY4kNg2OqSHHEoDe3w5uzdtYyQ2kL9O5BVik6
	XkY7b/rNNsjG0umqc0YA1NojmAxb6Ro=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-kcdqLBnDM5yJsC5CRwEuYQ-1; Wed,
 22 Jul 2026 09:03:12 -0400
X-MC-Unique: kcdqLBnDM5yJsC5CRwEuYQ-1
X-Mimecast-MFC-AGG-ID: kcdqLBnDM5yJsC5CRwEuYQ_1784725387
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67382195D001;
	Wed, 22 Jul 2026 13:03:07 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 892761956042;
	Wed, 22 Jul 2026 13:03:00 +0000 (UTC)
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
	stable@vger.kernel.org
Subject: [PATCH v7 04/29] afs: Fix missing kunmap in afs_dir_search_bucket()
Date: Wed, 22 Jul 2026 14:01:51 +0100
Message-ID: <20260722130218.78958-5-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: IeqHjD6Jksg6ytf95cuVXKLoGp9vaqxsfp2tlCjPKu0_1784725387
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix afs_dir_search_bucket() to kunmap the block it's using in the "bad:"
path.

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260716103030.3065561-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
---
 fs/afs/dir_search.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/afs/dir_search.c b/fs/afs/dir_search.c
index 104411c0692f..4977ad81fa82 100644
--- a/fs/afs/dir_search.c
+++ b/fs/afs/dir_search.c
@@ -173,12 +173,11 @@ int afs_dir_search_bucket(struct afs_dir_iter *iter, const struct qstr *name,
 
 	ret = -ENOENT;
 found:
+bad:
 	if (iter->block) {
 		kunmap_local(iter->block);
 		iter->block = NULL;
 	}
-
-bad:
 	if (ret == -ESTALE)
 		afs_invalidate_dir(iter->dvnode, afs_dir_invalid_iter_stale);
 	_leave(" = %d", ret);


