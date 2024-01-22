Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D57C4725D
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jan 2024 12:39:39 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XNq/VyTO;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XNq/VyTO;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TJVCs6NKNz3btX
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jan 2024 23:39:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XNq/VyTO;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XNq/VyTO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TJVCR2hhJz3bsQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jan 2024 23:39:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705927153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQmuqxaeIGZelSODTss8gWd4P9SrQf4vDlsO0SnTpdE=;
	b=XNq/VyTOi6DbUNnt2YpavevI9818meoIohOPO6/xAF1SD4o9jq+9Lv/ITFQDhUEyWCG9CQ
	YC8BmXM5W8TynMrM3Jlea0Xm1gRtWC8PCqtTJLV72iBs1mdKRVjQcUrH1+m1vr/9sJnO5K
	jUxbnqSYA4QB0RP2AI6Ljtk3sRVARpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705927153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQmuqxaeIGZelSODTss8gWd4P9SrQf4vDlsO0SnTpdE=;
	b=XNq/VyTOi6DbUNnt2YpavevI9818meoIohOPO6/xAF1SD4o9jq+9Lv/ITFQDhUEyWCG9CQ
	YC8BmXM5W8TynMrM3Jlea0Xm1gRtWC8PCqtTJLV72iBs1mdKRVjQcUrH1+m1vr/9sJnO5K
	jUxbnqSYA4QB0RP2AI6Ljtk3sRVARpg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-LKHoZoERMie5-61Ndg59yw-1; Mon,
 22 Jan 2024 07:39:11 -0500
X-MC-Unique: LKHoZoERMie5-61Ndg59yw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 958913C000A4;
	Mon, 22 Jan 2024 12:39:10 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A65D8492BC6;
	Mon, 22 Jan 2024 12:39:08 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Subject: [PATCH 07/10] afs: Hide silly-rename files from userspace
Date: Mon, 22 Jan 2024 12:38:40 +0000
Message-ID: <20240122123845.3822570-8-dhowells@redhat.com>
In-Reply-To: <20240122123845.3822570-1-dhowells@redhat.com>
References: <20240122123845.3822570-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, v9fs@lists.linux.dev, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, ceph-devel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-afs@lists.infradead.org, Marc Dionne <marc.dionne@auristor.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

There appears to be a race between silly-rename files being created/removed
and various userspace tools iterating over the contents of a directory,
leading to such errors as:

	find: './kernel/.tmp_cpio_dir/include/dt-bindings/reset/.__afs2080': No such file or directory
	tar: ./include/linux/greybus/.__afs3C95: File removed before we read it

when building a kernel.

Fix afs_readdir() so that it doesn't return .__afsXXXX silly-rename files
to userspace.  This doesn't stop them being looked up directly by name as
we need to be able to look them up from within the kernel as part of the
silly-rename algorithm.

Fixes: 79ddbfa500b3 ("afs: Implement sillyrename for unlink and rename")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 fs/afs/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 3f73d61f7c8a..eface67ccc06 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -474,6 +474,14 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 			continue;
 		}
 
+		/* Don't expose silly rename entries to userspace. */
+		if (nlen > 6 &&
+		    dire->u.name[0] == '.' &&
+		    ctx->actor != afs_lookup_filldir &&
+		    ctx->actor != afs_lookup_one_filldir &&
+		    memcmp(dire->u.name, ".__afs", 6) == 0)
+			continue;
+
 		/* found the next entry */
 		if (!dir_emit(ctx, dire->u.name, nlen,
 			      ntohl(dire->u.vnode),

