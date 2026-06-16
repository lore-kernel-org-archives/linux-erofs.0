Return-Path: <linux-erofs+bounces-3598-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 125F2CD98E1
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 10:08:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfjPj4wZvz3bt2;
	Tue, 16 Jun 2026 20:08:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781604537;
	cv=none; b=aZzqBaGK/2P3/QFtaspzmxbBSAMymiTgakScgjuyeuQc6RtR+dlu8yatmsotlvuxIYdtwZTprhalqcTnCtq1qOvQExAwrYg3u8JojH0CcCK8WjOKHsisLSsHhfS7UBRDiSk4vEYDpmdd0XZtCNIAXc0JWWm8l8bdZsEHvLwwcS0wI/oLwuK0ad4hgR93f8XZdklOhd9CyhRYYGaB7jaU92YeTiD1Vpwzyzu8XJTzle3bcgdw18Xc9PcODIfoaJwQ/FjFMeFPfC0gH8tysiKgDhy8K/dmpYCFfv2v+22+dnQRfjtk6bgr1UfGUzhB/F/7mcTv0SH4zj+wyjHmR/Kwfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781604537; c=relaxed/relaxed;
	bh=aRFmJ/J1AuXTPRw4YdoDWjljqrX4pDv27mJgEf6FBEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ijV6nT2x6ud0WO6fMK9G64Ha1Z5ViRbZsYpN6Fq7LGMX3pe2CWySjhWn4M8CEhpRbifbd52wpiTDz4KsWKMFx+AOTxKp5Z2KtjIQg1gZiVpIlK1z4+SMZIOU66J6W6oCNdti4jVIaJ6rvXVXq5ym7gT4Mb7908b+EH8TeKXU9fE7A5s8s6gz1VQEqc1zj54XvBFFesBiTfmj41T2+JxLC/AeSvlAvzPp2JMMqKSUkcFEEz+J46/RuonxHcGDFz9GY0hrc00WZEx0dg5gDpW438hjtX0lyoGkTH5yZoEGhloS9LRrC1N+e0T09qhHZ3rcnQRlcj1jMAgYMFl0KLqJNQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Bo3+tPKd; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Bo3+tPKd; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Bo3+tPKd;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Bo3+tPKd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfjPh4XY7z3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 20:08:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aRFmJ/J1AuXTPRw4YdoDWjljqrX4pDv27mJgEf6FBEw=;
	b=Bo3+tPKd5YW4W5LE5nWGbohCaYFOBx6Sgt3vmEVZCrQ3PaE6ecebW2o+D54b1IQLicaHMW
	txsKfUwinz1pkxubyDsgtApYr0T6aaQSUGem0uurjS3ASaC9Fqy4uOy8gFdMjQQbiGoeuV
	2P3/5sYS6aL0jTvIwMfOmGqOfZX7pD0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aRFmJ/J1AuXTPRw4YdoDWjljqrX4pDv27mJgEf6FBEw=;
	b=Bo3+tPKd5YW4W5LE5nWGbohCaYFOBx6Sgt3vmEVZCrQ3PaE6ecebW2o+D54b1IQLicaHMW
	txsKfUwinz1pkxubyDsgtApYr0T6aaQSUGem0uurjS3ASaC9Fqy4uOy8gFdMjQQbiGoeuV
	2P3/5sYS6aL0jTvIwMfOmGqOfZX7pD0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-yjCnePbHMQSwjYkAMWHA0g-1; Tue,
 16 Jun 2026 06:08:48 -0400
X-MC-Unique: yjCnePbHMQSwjYkAMWHA0g-1
X-Mimecast-MFC-AGG-ID: yjCnePbHMQSwjYkAMWHA0g_1781604525
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C8461805C14;
	Tue, 16 Jun 2026 10:08:43 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5341C1800586;
	Tue, 16 Jun 2026 10:08:35 +0000 (UTC)
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
Subject: [PATCH v4 01/30] netfs: Fix decision whether to disallow write-streaming due to fscache use
Date: Tue, 16 Jun 2026 11:07:50 +0100
Message-ID: <20260616100821.2062304-2-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: hHp1tBP7vC5He6nefWUrK-G1co97sevLb-HxPwmRq1Q_1781604525
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

netfs_perform_write() buffers data by writing it into the pagecache for
later writeback.  If the folio it wants to write to isn't present, it uses
"write streaming" in which is will store partial data in a non-uptodate,
but dirty folio.

However, when fscache is in use, this is a potential problem as writes to
the cache have to be aligned to the cache backend's DIO granularity, and so
netfs_perform_write() attempts to suppress write-streaming in such a case,
requiring the folio content to be fetched first unless the entire folio is
going to be overwritten.  This allows the content to be written to the
cache too.

Unfortunately, the test netfs_perform_write() uses isn't correct because it
doesn't take into account the fact that the object lookup is asynchronous
and farmed off to a work queue, so there's a short window in which the
cache is doing a lookup but the test fails because the answer is undefined.

This can be triggered by the generic/464 xfstest, and causes a warning to
be emitted in cachefiles (in code not yet upstream) because it sees a write
that doesn't have its bounds rounded out to DIO alignment.

Fix this by changing the condition to whether FSCACHE_COOKIE_IS_CACHING is
set on a cookie rather than whether the cookie is marked enabled.  Note
that this is really just a hint as to whether we allow write streaming or
not and no other aspects of the cookie or cache object are accessed.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
cc: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c |  2 +-
 fs/netfs/internal.h       | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 6bde3320bcec..2cdb68e6b16f 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -277,7 +277,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		 * caching service temporarily because the backing store got
 		 * culled.
 		 */
-		if (netfs_is_cache_enabled(ctx)) {
+		if (netfs_is_cache_maybe_enabled(ctx)) {
 			if (finfo) {
 				netfs_stat(&netfs_n_wh_wstream_conflict);
 				goto flush_content;
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 645996ecfc80..d889caa401dc 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -239,6 +239,18 @@ static inline bool netfs_is_cache_enabled(struct netfs_inode *ctx)
 #endif
 }
 
+static inline bool netfs_is_cache_maybe_enabled(struct netfs_inode *ctx)
+{
+#if IS_ENABLED(CONFIG_FSCACHE)
+	struct fscache_cookie *cookie = ctx->cache;
+
+	return fscache_cookie_valid(cookie) &&
+		test_bit(FSCACHE_COOKIE_IS_CACHING, &cookie->flags);
+#else
+	return false;
+#endif
+}
+
 /*
  * Get a ref on a netfs group attached to a dirty page (e.g. a ceph snap).
  */


