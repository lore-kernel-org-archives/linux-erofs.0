Return-Path: <linux-erofs+bounces-3955-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6732C44536
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 13:03:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4vZV07Bxz2yfy;
	Wed, 22 Jul 2026 23:03:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784725409;
	cv=none; b=U+nzzq5h5qUhn6D25PWSySaMJI+pt0uNqkpuJx2+Vy/ROG+u8octkwYPgxrT13QdO2sww4O6xTj39IXwToNSIiIA5vAln4rAz/fStYqwFk18WsE6JZjmbqKuO2uDhJ793qkwufDJoVFFfPMaQvM6qUXhx1oAehaHLAfi/x0ngILRmTOW26idwdA1feT8miPnRTBf6uuhRdeztFe78tDOLM5UUAPUCbVQs+Ldtm44YDwGisO1EDQAJZxVjn4Zf5s8M75pxcYQXRaraUjgJmJsopQk9rfZ6lFFoteSrhIzvbFGkVs08R11AgzBqGoVWFYDHnUfGMPJyWHTupikkMWK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784725409; c=relaxed/relaxed;
	bh=9RuMIYaYxQ3aZE1J/C1CbAmhDK6Ryjd7CE/reIVD6Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=def5kJKjsnsjpri+m+svWtb3MNLXuL/tGFxs1y6uvuGxkN7WhDdMNsrOJZG/hekZoJbVa718dGkHAhNh47QGyqPKDT50UwV7ftr6bUlIiOHvddwrUH9gXEYZCxfYY4y8q3ZjNGTM4HH5jHopnWR00xbtWzzX9GmLZxRaUMpHmdaguJazy2VF/lQrCUkzPkoJnd7ljyCVHX9LJ+SXXGbkraFz5EmqIKQ7E7HMhpZkdca12oNmA9NkIVy8GkhVTrfS/JnqmLB7A5+jcvSG+FR/VgXfY4qtOCcgoKSaE6PIz85VlG8imhdw9ajmn2QQ2Uz9/7vcCx2EEQdNlH60jceO0g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QHjMuCx+; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RMalrdzb; dkim-atps=neutral; spf=permerror (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QHjMuCx+;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RMalrdzb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4vZS6mrRz2yfs
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 23:03:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RuMIYaYxQ3aZE1J/C1CbAmhDK6Ryjd7CE/reIVD6Co=;
	b=QHjMuCx+omDYr/MrXS93Ox95NyPylKGfbjJpgV3z6Rzt7ih8Pe/l1omyWVUKDjRQMhMsWk
	7xeIHNy0jrvZJjIT0vDcFnZb7qMBYGJvf1mSaL3Miu/AKyWg6VgvO9ul9CDopgJ/1AyouQ
	Vp6ZTFpFBrYCJSW+tX7tTnDm3zibCtg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RuMIYaYxQ3aZE1J/C1CbAmhDK6Ryjd7CE/reIVD6Co=;
	b=RMalrdzbbQV8lvN3OWLrvnOhiQ6B9ZTIT8xBCLNSkYKpEsbmfw0K6HtT/BNNuSdXloymoM
	xfiJbTBaCsjPHwWMil7TMOirRaIEujtv0msLUlZ0WLo7sTIe+Ku4s1zqd7NA7/AXJXD7Gj
	MlW6i2eWSt7fVcatG8yzkxngxIU7wLI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-Fu614UCEMOqxu3toLt55kg-1; Wed,
 22 Jul 2026 09:03:21 -0400
X-MC-Unique: Fu614UCEMOqxu3toLt55kg-1
X-Mimecast-MFC-AGG-ID: Fu614UCEMOqxu3toLt55kg_1784725397
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B06D195FDF6;
	Wed, 22 Jul 2026 13:03:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A1911955D88;
	Wed, 22 Jul 2026 13:03:08 +0000 (UTC)
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
Subject: [PATCH v7 05/29] afs: Fix afs_edit_dir_remove() to get, not find, block 0
Date: Wed, 22 Jul 2026 14:01:52 +0100
Message-ID: <20260722130218.78958-6-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ZeHDvIDyV52UFs5ucjpmwIEdIKdflmwBjrO5u7nzXxg_1784725397
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix afs_edit_dir_remove() to use afs_dir_get_block() to get block 0 rather
than afs_dir_find_block() as the latter caches the found block in the
afs_dir_iter and may[*] switch out the page it's on if another
afs_dir_find_block() is done.  This parallels what afs_edit_dir_add() does.

[*] There's more than one block per page.

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260706153408.1231650-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
---
 fs/afs/dir_edit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index fd3aa9f97ce6..3ead36a07048 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -415,7 +415,7 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 	if (!afs_dir_init_iter(&iter, name))
 		return;
 
-	meta = afs_dir_find_block(&iter, 0);
+	meta = afs_dir_get_block(&iter, 0);
 	if (!meta)
 		return;
 


