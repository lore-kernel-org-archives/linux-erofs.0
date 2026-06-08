Return-Path: <linux-erofs+bounces-3554-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E91CD8CA4
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Jun 2026 14:59:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gYwBY353Fz3bxf;
	Tue, 09 Jun 2026 00:57:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780930661;
	cv=none; b=MhDy2gMzDLJKiuBxmiwUiw2srJtjGTYtpta/8sDADMD2XD4UyEBc79DzVzyvqesYZQ2VpWdyVcIM1ivtP/yk78OJjrH0atWx8MvZlkYnUMEiThaCrS6wtAuMvg+zm+ru59ktudIrBWQnXH1ufIhmlbbtZITK+yZEktmS5O5ZCTINLAaEC7tdFN+EoVAP/hxzzuYpRO8CEM3+10108/twxZBqmuIkeGEMN/SOvr5ZfCqTgoAGYoerRedd6Yv6ybL1dXLWUcGySYNZ11Y11IrdcSclYze3A6D3RjgX8StsyPToLtHLsfyZu/oewqbAtBLIvAiOwdX2+p302dNkV6q87g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780930661; c=relaxed/relaxed;
	bh=nmIXKYZPaEoy+v0EUgnQEN1+1FR/WvjVVNeVAn9uPnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gBBiMZT0O1Q2gTzQhGmtPWUzFrwQjFDWb0yWSpYPOK97nqmqoF7Hik6rQ1qVZWp9uCQhFOKnJVA+b0pCYjbQUkXKVfJepsVr3IDUkOI+gVQfUdRbitBWeAaiPOQXbMGVLTbFfyaXbHB+rpXDYxfCefUAXUm93iX3qBAlnTx0Xv9Dp+2pa9Eyq7+Q+bQTkbKsm6WKYenZ+QtZsgUwgjuvW7Fy1bEQPObJgKHDn5IzxZxj4zwixkbx9Np/qUnHr7kLBWT90udbJKvQYCLEolPmA5NenFrngrgUV6FZtq72dEAV4HgApb3LTrtVOFuyGUz+LRmBRMskuA9nXLQuHXJYpg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cccspL/m; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cccspL/m; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cccspL/m;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cccspL/m;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gYwBX38Shz3bxl
	for <linux-erofs@lists.ozlabs.org>; Tue, 09 Jun 2026 00:57:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780930657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmIXKYZPaEoy+v0EUgnQEN1+1FR/WvjVVNeVAn9uPnk=;
	b=cccspL/mX0YuKkNwPETPPCVOvbG/sbJf1tkEZ9maDjP6vp/7c2PB7Sk9w8/JwbJPJoS8vx
	GmeMGui4QBPPjIL2Lqn6FxvReapzUCHlOZuK4LIE8lsxxHIOR8GKCo3PLXbk7zCtIsu8YP
	7iv82+ctGYcOx7t2CmQlSji345+5JPU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780930657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmIXKYZPaEoy+v0EUgnQEN1+1FR/WvjVVNeVAn9uPnk=;
	b=cccspL/mX0YuKkNwPETPPCVOvbG/sbJf1tkEZ9maDjP6vp/7c2PB7Sk9w8/JwbJPJoS8vx
	GmeMGui4QBPPjIL2Lqn6FxvReapzUCHlOZuK4LIE8lsxxHIOR8GKCo3PLXbk7zCtIsu8YP
	7iv82+ctGYcOx7t2CmQlSji345+5JPU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-i6wbm1NLM9-IMd-rrbx9Dg-1; Mon,
 08 Jun 2026 10:57:35 -0400
X-MC-Unique: i6wbm1NLM9-IMd-rrbx9Dg-1
X-Mimecast-MFC-AGG-ID: i6wbm1NLM9-IMd-rrbx9Dg_1780930653
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34ED219560B9;
	Mon,  8 Jun 2026 14:57:33 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.43])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 48FC61800347;
	Mon,  8 Jun 2026 14:57:27 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 20/22] netfs: Check for too much data being read
Date: Mon,  8 Jun 2026 15:54:28 +0100
Message-ID: <20260608145432.681865-21-dhowells@redhat.com>
In-Reply-To: <20260608145432.681865-1-dhowells@redhat.com>
References: <20260608145432.681865-1-dhowells@redhat.com>
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
X-Mimecast-MFC-PROC-ID: y8nLb0VItgDZXTyAfVZqaSYdP8BdBpoFgaATRSFTp5c_1780930653
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Put in a check in read subreq termination to detect more data being read
for a subrequest than was requested.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_collect.c      | 8 ++++++++
 include/trace/events/netfs.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 977b69ac8725..fc62eaef6107 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -542,6 +542,14 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 		break;
 	}
 
+	if (subreq->transferred > subreq->len) {
+		subreq->transferred = 0;
+		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+		trace_netfs_sreq(subreq, netfs_sreq_trace_too_much);
+		subreq->error = -EIO;
+	}
+
 	/* Deal with retry requests, short reads and errors.  If we retry
 	 * but don't make progress, we abandon the attempt.
 	 */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 59f330003d02..cc29582f6245 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -134,6 +134,7 @@
 	EM(netfs_sreq_trace_submit,		"SUBMT")	\
 	EM(netfs_sreq_trace_superfluous,	"SPRFL")	\
 	EM(netfs_sreq_trace_terminated,		"TERM ")	\
+	EM(netfs_sreq_trace_too_much,		"!TOOM")	\
 	EM(netfs_sreq_trace_wait_for,		"_WAIT")	\
 	EM(netfs_sreq_trace_write,		"WRITE")	\
 	EM(netfs_sreq_trace_write_skip,		"SKIP ")	\


