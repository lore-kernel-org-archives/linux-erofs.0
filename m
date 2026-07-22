Return-Path: <linux-erofs+bounces-3952-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45399C4453C
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 13:03:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4vZ42s2mz2yfD;
	Wed, 22 Jul 2026 23:03:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784725388;
	cv=none; b=CUrzcpyzx7vhBqf7cd5jZUBFgpSwog8Y5/Z6uP1OxDI5KiZ79IAyhoDtC7anFDsM+AsEqsQUgUCzvf2WWdRKkHREwq3lcZ8E/9gSnrouKVR8+aBwjIG2BH8A0zK0pOH+WKzvn8udHOPCuviDFJvF6sbz11FVtA7ldq92QomF95J1t0gqW8dylFv84RfUu+NgQCsbq0a1SYgIHHU0eiteKe1ykFrIxv7VU3aGJxaJEPzmxO2NI08GEXiWCIdsPfk+RMI9fKC7lflksGZIcMZWZ1ybEwEiNxK7K4hIp0dIpxOAciFLYNce5rmELhM3KXOCiDAZDBFS+iK+NKs1UUQ1pg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784725388; c=relaxed/relaxed;
	bh=8C6bJJEtQmiVwAw0nsngdl6zXvM4+8rNe514omrJIfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=SLulOKRP7gt2XhP8nlyhLzdckwjrZ2X9XcpmmBv6cFz6LFR+9JvoHscNqaB/1Svm1xQEW+cBCv7QL9DJNWJGUXGIgNSzXbgiFHFpy37hEwHc2SgIMz9b26CCKg9RkhrZb1HzJa/z0LBEXDRVcNh5c/mqhwXKuvNJA2ac1dMhXx/9cX2yonPvlIiOnsK8agq3IQE51VKhCbjdPN3UNqXkVVlc5o++Cnq0mwGgM0BjAGARdODtU+y1EudIbQPR6EtJ6kuw2gZ6fNriKMfJOeox3qIhupHlDjKA96Ipa44Lfqm6G8NaG6WgIzcYch8rSN3e65VKwpENGd1jY1G6BxKCqA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I/cKHiDo; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gUHM4KQB; dkim-atps=neutral; spf=permerror (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I/cKHiDo;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gUHM4KQB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4vZ339H4z2ydn
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 23:03:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8C6bJJEtQmiVwAw0nsngdl6zXvM4+8rNe514omrJIfM=;
	b=I/cKHiDoaPWW8EJdTuZbdo5+wuNYB4clPqV9tHYEuiBDl2RRd+AhFNIqErzTIfa8sTU/DB
	RbSHmE+HWw4Cp+Z4kqI2YF1HiSXtMOikrru6xykVViGrTtooE9P0x6hYpIkCiYUuLKr0RK
	/YTcuQgiv2ip5FwvueL+xoGaiLiX/bg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8C6bJJEtQmiVwAw0nsngdl6zXvM4+8rNe514omrJIfM=;
	b=gUHM4KQBGgVf7/PNdzBs4ta/r25EwfMHPtMC4C3+oqofqnrhy975JxrGmH7+eJxSwRH8T3
	9Bef1bSIctKtVwYyRjZvXOMNofmdiEORQ10sk4nhNFKu1rUhVpun2c+ek4pDnMGQlBVHK3
	5jVf2Da+bBrwpQli9QHNHSDrYj1qdg8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-IvztPQHUN2qWiHQvpP2qpA-1; Wed,
 22 Jul 2026 09:02:57 -0400
X-MC-Unique: IvztPQHUN2qWiHQvpP2qpA-1
X-Mimecast-MFC-AGG-ID: IvztPQHUN2qWiHQvpP2qpA_1784725372
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00F3F1977537;
	Wed, 22 Jul 2026 13:02:51 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 638B31956042;
	Wed, 22 Jul 2026 13:02:43 +0000 (UTC)
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
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v7 02/29] netfs: handle single writeback rolling buffer allocation failure
Date: Wed, 22 Jul 2026 14:01:49 +0100
Message-ID: <20260722130218.78958-3-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: K-sJFn258DhhYGTpFrY8uQksAA1qTVsavXLLJ3xuSNo_1784725372
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Yichong Chen <chenyichong@uniontech.com>

netfs_write_folio_single() takes an extra folio reference before
appending the folio to the rolling buffer.

rolling_buffer_append() can fail if it cannot allocate another
folio_queue. Check the return value and drop the extra folio reference
before returning the error.

Fixes: 49866ce7ea8d ("netfs: Add support for caching single monolithic objects such as AFS dirs")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index f2761c99795a..14efe4cb9393 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -720,6 +720,7 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
 	size_t iter_off = 0;
 	size_t fsize = folio_size(folio), flen;
 	loff_t fpos = folio_pos(folio);
+	ssize_t ret;
 	bool to_eof = false;
 	bool no_debug = false;
 
@@ -748,7 +749,11 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
 
 	/* Attach the folio to the rolling buffer. */
 	folio_get(folio);
-	rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK);
+	ret = rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK);
+	if (ret < 0) {
+		folio_put(folio);
+		return ret;
+	}
 
 	/* Move the submission point forward to allow for write-streaming data
 	 * not starting at the front of the page.  We don't do write-streaming


