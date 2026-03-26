Return-Path: <linux-erofs+bounces-3017-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DB510A1E62
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Mar 2026 10:46:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhL7N3wTFz2yhD;
	Thu, 26 Mar 2026 21:46:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774522016;
	cv=none; b=npplv8H5TGWlkzvTmQZfT9vfHf+iG08fzcpSuRgnz/Qzcr83bMsl1O2rGrlKNYu8vNkLAB2X/nX/xLS+WPOsZ8esJuA4YVwswhxppv57w9GmCfCXIia+vT4otOj8rieE7MlSiXpzRBkWQFB3N+PWO2/fdvTzPboCz0fmbYbpeaTU9g9Nq4BRPpd7i9mTGquhqIfh7rcScPOo2KrbjlqGuHnbwCZD2xgxYjH223orNag7Sm4sdB5km5CBfVmarS2Qnh1zlosIYVRtMMMlEFmFXWBC5geZCuJ5KMcPgsfIgNZdIe3S8cGWkFmLkG4t8tuvz6BwDgRkoaWZlr3pJwszvg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774522016; c=relaxed/relaxed;
	bh=HpVDvhFE67l3OFnKv5DoNdb7shfVdE092GWoAVAsAa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=l3uToFDe7NBcsC4mlsok3AM4d3ScfJzuztFc0KsxDn7w1XksX04KrbP5EWC3PaibliYoF603mSh5Ou5EWRaRotrivKZFuu1rqbZs98j7wakGlMMgM75HZkGg3n+ncy1e4dB82aKQOrhGDfoo4h5Ta6JGEtV9A7cNeDUdJJWIU3oAckTUsxRWEXNLGQFokJAxs7onwNCD85YJzXXMFm0RI+UK6wCjnaDaVyDBGoBGM0DUjVmVkykHhDX5GsyEsPmaaEItfEE1ozrFiFzUFWWPVtLOHBllV+wFoFBoBWJgC1ARLFREr8iQW/Y730cwTwa86Szdiw7VTNNFwDkqfKlwlg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dN9GXkpF; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gvj2aIyA; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dN9GXkpF;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gvj2aIyA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhL7M5Bqzz2yd7
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Mar 2026 21:46:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HpVDvhFE67l3OFnKv5DoNdb7shfVdE092GWoAVAsAa0=;
	b=dN9GXkpFuRh4+NxScOBmrLgOQRLRc7EzHwzmmn3GTJVbEVIk4uFAqQ24u6162Yp+pd93qd
	9i2KfqytQvDDMGs3YLsbkSYxfEeb484zRlRlAmHJ5QKajkReoX4l0eeRrwwWAgrVjDYHre
	7Q8RcrpolYsw+/5QpgiOthWmocSZnAs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HpVDvhFE67l3OFnKv5DoNdb7shfVdE092GWoAVAsAa0=;
	b=Gvj2aIyAuunJkdBIZr15K0LiO9qhiVgJssAAfAA2p7idLT04x7901FYl2cN5Gub4Wu6HpY
	dK3aOMpYG/74F2hnwA3l+kNsb58wNcp+I2J8ANmKsczWG99BtowtGGJiyEIj4q07GT0vlD
	NmXdFjiI8YLZRFWeqk5xiD3bMn8x39A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-SbEJ6LxhO5WiP_Ngehg1ZQ-1; Thu,
 26 Mar 2026 06:46:46 -0400
X-MC-Unique: SbEJ6LxhO5WiP_Ngehg1ZQ-1
X-Mimecast-MFC-AGG-ID: SbEJ6LxhO5WiP_Ngehg1ZQ_1774522003
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04DF719560B9;
	Thu, 26 Mar 2026 10:46:43 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.121])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 586C419560B1;
	Thu, 26 Mar 2026 10:46:35 +0000 (UTC)
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
	Paulo Alcantara <pc@manguebit.org>,
	Xiaoli Feng <xifeng@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH 04/26] netfs: fix error handling in netfs_extract_user_iter()
Date: Thu, 26 Mar 2026 10:45:19 +0000
Message-ID: <20260326104544.509518-5-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: ExuIgvHNOZT-wWrAzyi1UxrTz0sJkb4ynbZu2Z9m38U_1774522003
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Paulo Alcantara <pc@manguebit.org>

In netfs_extract_user_iter(), if iov_iter_extract_pages() failed to
extract user pages, bail out on -ENOMEM, otherwise return the error
code only if @npages == 0, allowing short DIO reads and writes to be
issued.

This fixes mmapstress02 from LTP tests against CIFS.

Reported-by: Xiaoli Feng <xifeng@redhat.com>
Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: netfs@lists.linux.dev
Cc: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/netfs/iterator.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 154a14bb2d7f..adca78747f23 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -22,7 +22,7 @@
  *
  * Extract the page fragments from the given amount of the source iterator and
  * build up a second iterator that refers to all of those bits.  This allows
- * the original iterator to disposed of.
+ * the original iterator to be disposed of.
  *
  * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA be
  * allowed on the pages extracted.
@@ -67,8 +67,8 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 		ret = iov_iter_extract_pages(orig, &pages, count,
 					     max_pages - npages, extraction_flags,
 					     &offset);
-		if (ret < 0) {
-			pr_err("Couldn't get user pages (rc=%zd)\n", ret);
+		if (unlikely(ret <= 0)) {
+			ret = ret ?: -EIO;
 			break;
 		}
 
@@ -97,6 +97,13 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 		npages += cur_npages;
 	}
 
+	if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
+		for (i = 0; i < npages; i++)
+			unpin_user_page(bv[i].bv_page);
+		kvfree(bv);
+		return ret;
+	}
+
 	iov_iter_bvec(new, orig->data_source, bv, npages, orig_len - count);
 	return npages;
 }


