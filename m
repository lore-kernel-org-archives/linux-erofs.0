Return-Path: <linux-erofs+bounces-3014-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520A710A1E64
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Mar 2026 10:46:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhL6r0Cjdz2yVB;
	Thu, 26 Mar 2026 21:46:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774521987;
	cv=none; b=MeK1cRPFg1VBwf0D8qGZvTLH+EaiDwXGA0L1f7ZKPho0446Mkp4IFlWNKNVW6uLpUCfLMu6VsgYZI6rKmHEjOryYLR3JsLKl7F1EfIcAXQiL4G3t0ja9dA11pwXzGSUdB0dyG8uI+HoRtPiTVuBMTX2C1rr61prAQHetl0eUTVKjsYfM8k3YBu91uKwF43/4V3ujbxrXIFjUnCa4JzdgOFiHdIztNtfJIaIgfzaH3Hp5qBojdMI9+LCUVG3C3qvGtUkkGbp9PonQjmWaS3e4gBjnZKouR26woSYx5a1yeXIPTekf51v/tJzV7S2z+9s3xn00Rx3+tCnHS3gMfGP63g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774521987; c=relaxed/relaxed;
	bh=ikME2fKnQmyL6ccsVR9iuIqF4Gk7rE38Es/pzWOmTZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mtAr537an/+9Nc8w2MuBf2CAd0BV+TRjgZwymTeIIOdtJNa8JB/5uiKbgu6KgpYklbdLSM/6amAXWhpUTu4iZvc4RoPsjdJCj9zKzAUhrglZAly2UOVAT3VYQtwGLh6QtcddVW2ozdROjapxJKy55aINhazpmgXB1JMbp/Eomo9y3BR1e8+2OmOX4jd0hXIU6Is6w9RuS0f3kvf/CnQ9VBoaXjax6xGNcblv1yj0cARhgR5M/b8DHfHxkOrnC+6X1kOiqWn5rXrFXIEO/1OrNATMoY7kx/tMtuExI1ABCem/1e5ztXLwZHgBTllE2ClEJ3SWsOPQFX09jcH2jjjj3g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gZSyRuxx; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gZSyRuxx; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gZSyRuxx;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gZSyRuxx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhL6p5hqCz2yS4
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 21:46:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774521983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ikME2fKnQmyL6ccsVR9iuIqF4Gk7rE38Es/pzWOmTZE=;
	b=gZSyRuxx4kcXAyO36NTtUVxqbkS0dqEOZgwczzZjNnURHPUs39p9FqETSZpH9mEBFmZFzF
	eRAwxg8IZ/tACEhhy/A2nURTiZ+4iU9/a8I87IwEOA2sjJzF5JraEPlZB1SM0+gcD486Vq
	DsbDu+RY9tF/6qIbTKml/6GrAEivJ70=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774521983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ikME2fKnQmyL6ccsVR9iuIqF4Gk7rE38Es/pzWOmTZE=;
	b=gZSyRuxx4kcXAyO36NTtUVxqbkS0dqEOZgwczzZjNnURHPUs39p9FqETSZpH9mEBFmZFzF
	eRAwxg8IZ/tACEhhy/A2nURTiZ+4iU9/a8I87IwEOA2sjJzF5JraEPlZB1SM0+gcD486Vq
	DsbDu+RY9tF/6qIbTKml/6GrAEivJ70=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-ZuIOung0PmK_T8_--PBq-A-1; Thu,
 26 Mar 2026 06:46:19 -0400
X-MC-Unique: ZuIOung0PmK_T8_--PBq-A-1
X-Mimecast-MFC-AGG-ID: ZuIOung0PmK_T8_--PBq-A_1774521975
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE5CD19560B6;
	Thu, 26 Mar 2026 10:46:13 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.121])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF2E618002A6;
	Thu, 26 Mar 2026 10:46:04 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
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
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+7227db0fbac9f348dba0@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH 01/26] netfs: Fix NULL pointer dereference in netfs_unbuffered_write() on retry
Date: Thu, 26 Mar 2026 10:45:16 +0000
Message-ID: <20260326104544.509518-2-dhowells@redhat.com>
In-Reply-To: <20260326104544.509518-1-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: NOaDSDudpPR2jqX0p9sD-LR19Ze1Y4vd3mqK-KR5Dfk_1774521975
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Deepanshu Kartikey <kartikey406@gmail.com>

When a write subrequest is marked NETFS_SREQ_NEED_RETRY, the retry path
in netfs_unbuffered_write() unconditionally calls stream->prepare_write()
without checking if it is NULL.

Filesystems such as 9P do not set the prepare_write operation, so
stream->prepare_write remains NULL. When get_user_pages() fails with
-EFAULT and the subrequest is flagged for retry, this results in a NULL
pointer dereference at fs/netfs/direct_write.c:189.

Fix this by mirroring the pattern already used in write_retry.c: if
stream->prepare_write is NULL, skip renegotiation and directly reissue
the subrequest via netfs_reissue_write(), which handles iterator reset,
IN_PROGRESS flag, stats update and reissue internally.

Fixes: a0b4c7a49137 ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Reported-by: syzbot+7227db0fbac9f348dba0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7227db0fbac9f348dba0
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/netfs/direct_write.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index dd1451bf7543..4d9760e36c11 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -186,10 +186,18 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		stream->sreq_max_segs	= INT_MAX;
 
 		netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
-		stream->prepare_write(subreq);
 
-		__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-		netfs_stat(&netfs_n_wh_retry_write_subreq);
+		if (stream->prepare_write) {
+			stream->prepare_write(subreq);
+			__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
+			netfs_stat(&netfs_n_wh_retry_write_subreq);
+		} else {
+			struct iov_iter source;
+
+			netfs_reset_iter(subreq);
+			source = subreq->io_iter;
+			netfs_reissue_write(stream, subreq, &source);
+		}
 	}
 
 	netfs_unbuffered_write_done(wreq);


