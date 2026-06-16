Return-Path: <linux-erofs+bounces-3599-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E308ACD98CF
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 10:09:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfjPv47dvz3brR;
	Tue, 16 Jun 2026 20:09:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781604547;
	cv=none; b=X5mPXrn0hzHx+su2X4nX6up4QdT8MFMqXKnx5AFQNZoeitFcBUCNDO9rwKvCrH9htr6qXdQfzqBXSMh4xGtuyS5T/9EI9IFzGyaqqbwCaW+Woins9wOlLZjybZ4ev7jCakTceMLfGkklhjbTaoWkNvqQEXDRK0OlhnnE9LenMmAqyN8Jtfihw7aokt/G2T0v+HEldgcOYfDEvnNN+1HuIb2NLGvpyRWmsJyhncBO+rHA4eMjTlnIjEGDFe6D83aHf4y1J45h5S1JjVtaEzYvWo5IapgXQ4cZMA7gj0PsQSdoCiELtmiEQyx9OiSARgEwFu5Oekhpx5FJ7N6wvTQR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781604547; c=relaxed/relaxed;
	bh=6xzr+Qi6ZDs+0Riq2AVSQ7VxUd6HCUSx75f0+qxBdXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=P03jAp1jiwy0Xc2VEPBwX18hpVJfK5RkXpriwITkXJtCuHMT39HrPpBm8hqDf1MQqICzpM06HkFic5AmJ1UDsNF7cWZt5wJLeupyHEf99Ve+sc1kT7XOp9N4wbtpSjo9FaJJAB0A+nZ4TWocSaJ0UJ49/i2G2rHqPWE1e3IrlyYkknivPI5dt1PuqrCHUpM7PGQgtzmumojNTP7swekKI1Z/3LP7GwmylaPVQRy0gQed9elQt315bmg7aSyHz4r1kh4l6b8ybI2hHpX0p8NYBeo5hrHTTngmqqsI2HswXW6HxKeJxaU1Gg6cJZTryW+PrP/zGCIXSvqxr/f2zUvp/g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YhyzwJ/k; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=icNxpEQ+; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YhyzwJ/k;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=icNxpEQ+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfjPt4KsKz3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 20:09:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6xzr+Qi6ZDs+0Riq2AVSQ7VxUd6HCUSx75f0+qxBdXU=;
	b=YhyzwJ/ka+s6ofHUlKhXtVaGuuYKNv4q126kt1Si0Ry9OYAoZNZkpWB9JWEwcPGGxOZGgX
	ibYkQoLrE3IRF/WUoTrKEECgzncye8wzhM2aewixUug3k1lN2Mp89SFmEI3hBWwnuJgtM4
	tx+TIyRiBkTg+tb7Oj5YKTXrbcMj4fg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6xzr+Qi6ZDs+0Riq2AVSQ7VxUd6HCUSx75f0+qxBdXU=;
	b=icNxpEQ+urLn97ExqgCCiGHIaWvOdKyj4FZ9sCepOWeOWB2zszuPrx3p/y0NVHi/gIR+QT
	4LRY38gTcYScgcRt8DN9gVQ0gXMkwRWZ1yogOi8n/DFM4jHVgAUcjfhulurCis0hflaQ3a
	ma8dosgiekJmv/XDxj8gWkudr26RgZE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-Qj7_fXm2OlK3_pmFP6or6Q-1; Tue,
 16 Jun 2026 06:08:56 -0400
X-MC-Unique: Qj7_fXm2OlK3_pmFP6or6Q-1
X-Mimecast-MFC-AGG-ID: Qj7_fXm2OlK3_pmFP6or6Q_1781604534
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E18F1955E98;
	Tue, 16 Jun 2026 10:08:52 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 66FD43008B37;
	Tue, 16 Jun 2026 10:08:44 +0000 (UTC)
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
Subject: [PATCH v4 02/30] cachefiles: Fix double fput
Date: Tue, 16 Jun 2026 11:07:51 +0100
Message-ID: <20260616100821.2062304-3-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: sDQwxIbs1MJX7DRujkOye_GplXhjTM_zkmfwQfcwlfs_1781604534
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix a double fput() in error handling in cachefiles_create_tmpfile().

Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/cachefiles/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 2937db690b40..a464c4646c04 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -467,7 +467,6 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
-		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		goto err_unuse;
 	}


