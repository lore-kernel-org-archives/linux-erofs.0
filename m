Return-Path: <linux-erofs+bounces-3951-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F6FC44539
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 13:02:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4vYp1k4qz2yVd;
	Wed, 22 Jul 2026 23:02:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784725374;
	cv=none; b=ZLZEZL5APNWW6QjllNYpbGtTGiQBOF7VJQzyJQA1kqoBXlzYmo4JK0J7MFLrjNePlAZf1MPJickQKfrUtANCHhV2ZJn4e3Ic9dVyKMQRTrDB+SMuHYZf00vJju+YsGd8NDcWX3/1YR83juBgyJOuW+kjS4wm4sx8iWfBBjC7KnyjWekwQPaOgnA76zgYns/hZCFiJghbkDRDl6Ns3QChXk8zT/fgFRfJYr2c/TjZRe3zEAafm2qxqH7owunvcu4M+/O5aYWKBnoJdzdowRDDfxIw2qO6z88Bun019NWQGQlXgeMGCqy+DlFj3/iWpmiPr5zyXY1R1Gmum5JSNuiiMA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784725374; c=relaxed/relaxed;
	bh=vprsViKY72rawZWltum/UMfZGzgPWXZ8iTQuEYnb2yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mLjkQRmN5PYCjOUeyXjI5b8raHwXg6BAgxZdzwpGSTdR8gzXL4utnN+4HIQRKRTm3EOJrBqukMIdhWTqYMloeq2uDOZMOtJcXqG9tJ4J3VjkrMIS3xgN4N2ZSbb6gJSiTnx9t98aN4umpqsD+LO+G0PEfomDtSQzq/aYXc7Ar6IdJwOOcppdAlGPo0aRovVeSvP2F6csqblahQ8CFiQmlUpTZQJIYQZXRRuobRZmFD2lBMgnsYZCBFHGkzA6WHynUY6vLe2pLCdtveS6YtDi/tmlFxzRBBACfRKISlZ3NYyDq3wxGhiMytVyw/0CY6Nb5ZthLuKbZWVmxmP7f9Tz2w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L5F1Z8eM; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RmtMfhRC; dkim-atps=neutral; spf=permerror (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=L5F1Z8eM;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RmtMfhRC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4vYn3N84z2xBb
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 23:02:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vprsViKY72rawZWltum/UMfZGzgPWXZ8iTQuEYnb2yU=;
	b=L5F1Z8eM+HDB2mnka3yr0ClLQrxoyQdyu+ZssAfrwZLcoDE/8hM+stEegCYgyQuful8hSr
	WyYnVWvLtwKtD9Hfm9vmm8dqvuPIklf8k0iMEAx/Htom0Kwc4yoJzox7zGuFDUinwL2LMo
	SzIb6Ms3p7YSkYYVYFt6OAyq+pdEpcs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vprsViKY72rawZWltum/UMfZGzgPWXZ8iTQuEYnb2yU=;
	b=RmtMfhRC/W4LoZeeSWWFN6bMZsx5aTjHx8IZGoezN3U5mlgiwZz6En1ATXSqEZuhYxajD1
	+eFzi4Y6Z9BBlG0g0bBF7dOibdXWBZWZyuQejFXRUYMx9K128UF1uNZiuQVZg7EVQHPwAo
	RTnW+8ssfgJFl83KruRsNekUi3fzqeI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-GphHkRAXMoOOxTVmcFV2PA-1; Wed,
 22 Jul 2026 09:02:47 -0400
X-MC-Unique: GphHkRAXMoOOxTVmcFV2PA-1
X-Mimecast-MFC-AGG-ID: GphHkRAXMoOOxTVmcFV2PA_1784725364
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC9E71800756;
	Wed, 22 Jul 2026 13:02:41 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3EF5F1955D88;
	Wed, 22 Jul 2026 13:02:32 +0000 (UTC)
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
Subject: [PATCH v7 01/29] netfs: clear PG_private_2 on copy-to-cache append failure
Date: Wed, 22 Jul 2026 14:01:48 +0100
Message-ID: <20260722130218.78958-2-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: N49UplEO_3_xZrtttXmtaMGOdgXg9TFfrl16O50Pl68_1784725364
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Yichong Chen <chenyichong@uniontech.com>

netfs_pgpriv2_copy_to_cache() marks the folio with PG_private_2 before
netfs_pgpriv2_copy_folio() appends it to the copy-to-cache rolling
buffer.

If the append fails, the folio is not queued for cache writeback, so
the PG_private_2 state and its reference must be released immediately.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_pgpriv2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index a1489aa29f78..7eacc58abadb 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -54,6 +54,7 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 
 	/* Attach the folio to the rolling buffer. */
 	if (rolling_buffer_append(&creq->buffer, folio, 0) < 0) {
+		folio_end_private_2(folio);
 		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
 		return;
 	}


