Return-Path: <linux-erofs+bounces-3905-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9323C44501
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jul 2026 10:31:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h18Tr1xJPz308Y;
	Thu, 16 Jul 2026 20:31:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784197888;
	cv=none; b=kBu3HPHI6qURvvXJMxF4FCwvIPovVGZ9ayKYJDrD9oDmMV6gHEkoBtkAe9rESJpjzM+u9GiEjMhC2Fd0BsH066fqKVGp3oSXSlfvArmiBC/szP5BzPleq6f9ANVew+nhQAgsqz6+YH3Tf8gA16VTZY0+uE2qZGv0nJPCzd1Xywj0t8GepImefLgWbu8qPTrIYzRjvy/Ky7Tu2L4/MZxzNU8khnUEb/KO9wfUQpfbTV32A+3TSCNKeM3Ib+s0Za8k6s0/6kCLdKAI4LfZ42AnqX280h0CFaRVoNmQlvJmO/J5AdhVqouKCRPCfRj8uHvkjKJ6+4PCbxXfr+MoWLZ5dA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784197888; c=relaxed/relaxed;
	bh=forfFVNHXdcKUrAO6tYWFvQxC3xkWQUr9XOJVlaCNVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Ea75U77YFNwOjW/AMfZNW2P7flVf4C/1YpA05vRa3X65C5rQL3wpVAMutibSD2fgkfzNk9k/MunFIL8E0mRxEgsVTp1EU89zsBKQ+9hE4KcK7DBMnM9g0y05Qi+scqpfEBgXEZ+oe29PwNYWix4OwJPsz7usTzlKofZSjuIC5BEoV62DDLKIzKGOYIh8IUibs3jbgF1AfwlH6y11kLApEI8I3KCCk925O3yvdZWe16bKggBdKNuCj8yX6hDN3IgYtNeyCIohGoZW1ihb/Ae1FSR67qWu8UcoIpINGVP8vsvN5N9M8d7fbjl6BMql3laTlRMxQNJWlywuNr35VME0XQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HslxCYa+; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=h3bN8J4m; dkim-atps=neutral; spf=permerror (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HslxCYa+;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=h3bN8J4m;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=permerror (SPF Permanent Error: Void lookup limit of 2 exceeded) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h18Tq1cGBz2xlZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 16 Jul 2026 20:31:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=forfFVNHXdcKUrAO6tYWFvQxC3xkWQUr9XOJVlaCNVg=;
	b=HslxCYa+VnHy0cFa+Kh7qpY0iayK3BRMbFELshb7tG5+66Ob/a+V6uACf4uu/yxsuruGHY
	K+wRqHp/1d992cD5hkcj/b/VpyITCTSylUMLuNF7QF6YFnY6rfxUaSbEjvsPgvN5Xoab9D
	UtmJVrMIqpQ0i/eknadIFXH1przHPeI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784197884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=forfFVNHXdcKUrAO6tYWFvQxC3xkWQUr9XOJVlaCNVg=;
	b=h3bN8J4m7bGJBaAKMlNDcvrUwn++hQ0173iKUNmYInnqXSlBNgGUxiTM4TeKfmBREfgflV
	WrnMnpHzKWaZDThp8Yy49q6rH8CZFu6Xuy24494+dbe4yIQ7UkX8piC7QRDqqg9j6Zi1CF
	quhCq+ZJFjONtNsJf+rhbsMxLhCWTF8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-CRMZ5cTANlyRJrFFM9ec3g-1; Thu,
 16 Jul 2026 06:31:18 -0400
X-MC-Unique: CRMZ5cTANlyRJrFFM9ec3g-1
X-Mimecast-MFC-AGG-ID: CRMZ5cTANlyRJrFFM9ec3g_1784197875
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BCA11800610;
	Thu, 16 Jul 2026 10:31:13 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 96F2C42C;
	Thu, 16 Jul 2026 10:31:05 +0000 (UTC)
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
	linux-block@vger.kernel.org
Subject: [PATCH v6 03/24] Add a function to kmap one page of a multipage bio_vec
Date: Thu, 16 Jul 2026 11:30:02 +0100
Message-ID: <20260716103030.3065561-4-dhowells@redhat.com>
In-Reply-To: <20260716103030.3065561-1-dhowells@redhat.com>
References: <20260716103030.3065561-1-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: WcNH-KtpZIlH-IUu5x_B_kJY6gIp3Brm3bblvGUPE2c_1784197875
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add a function to kmap one page of a multipage bio_vec by offset (which is
added to the offset in the bio_vec internally).  The caller is responsible
for calculating how much of the page is then available.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: linux-block@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/bvec.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 92837e2743f1..53cf36e73967 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -343,4 +343,22 @@ static inline phys_addr_t bvec_phys(const struct bio_vec *bvec)
 	return page_to_phys(bvec->bv_page) + bvec->bv_offset;
 }
 
+/**
+ * bvec_kmap_partial - Map part of a bvec into the kernel virtual address space
+ * @bvec: bvec to map
+ * @offset: Offset into bvec
+ *
+ * Map the page containing the byte at @offset into the kernel virtual address
+ * space.  The caller is responsible for making sure this doesn't overrun.
+ *
+ * Call kunmap_local on the returned address to unmap.
+ */
+static inline void *bvec_kmap_partial(struct bio_vec *bvec, size_t offset)
+{
+	offset += bvec->bv_offset;
+
+	return kmap_local_page(bvec->bv_page + (offset >> PAGE_SHIFT)) +
+		(offset & ~PAGE_MASK);
+}
+
 #endif /* __LINUX_BVEC_H */


