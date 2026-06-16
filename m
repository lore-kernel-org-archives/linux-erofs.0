Return-Path: <linux-erofs+bounces-3603-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C59ECCD98DA
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 10:09:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfjQS3YKrz3c2G;
	Tue, 16 Jun 2026 20:09:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781604576;
	cv=none; b=M0nkwQkJWJmBgIbh6CiS3PjUc/R4qHafX4E/N47LK4WJo5sezaA1bMc2GA2Ns3f+0Ye1ZI5Qic31UWOy4XvaD3TlVV+gUrWC8z1epIfmNFZUWcN9dgHnwOTua8w1MUOrSzanBcC3iBxBahf0P3SVaRv+JO4id+3LlUz+30tA0hLjZar04a/Tm2LVhlwG68NPh/lPHTIlbzt5aCP6xtZXzcTznKEndbDImQQMWEUn/1XhCQK7M0TI/A4VNW2O9wbtCPtSIyCfNnkbcVmvH2iG/rLKKN9udnx0bjLUlXDfJjZrRvSFd2fgq7xTX9a/4moSaZlAFsDOwxBS/VT5BUK8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781604576; c=relaxed/relaxed;
	bh=G/liEajtHx9CYrzJvqnOmvWcXVvucaBQw0Nv7dYml2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UpyGEOHwoQ9no0vHKLCO9ygloAXqzJ75tB6ezBRnLfB25G43AmwDUXTIu+RUH8KFFD1QbL0aB6j5er1jpcYxlPf+F3SedyJfZHGvNHFZSmTU4fu4dHcNWN8QhxD2G+wwu8O85FxH237nX0UgDS9xwFERq/0BAQF0TKD0/bn3A6xN/ybRmWH4p2h+jP4m3LNs2xjENvE72WxcOHb4oPv7MTm3ceydKbyTeLDQto9enEnicpzfhHmgW3CEEPnEYocMF6LoYgfZuM+v2ClGSsBfD1eXSPjrHItXHOqdJL71Nz5Nhx9BOCJqReQvUlyCl4/UdBvQA6Udzs533nMJn2xGIw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JEM4ubaX; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JEM4ubaX; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JEM4ubaX;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JEM4ubaX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=dhowells@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfjQR1Y4vz3bqh
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jun 2026 20:09:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/liEajtHx9CYrzJvqnOmvWcXVvucaBQw0Nv7dYml2Q=;
	b=JEM4ubaXaYhpNlSwLVJFaETun/2QK5hO8qPKmVS6o53wBlm5tye6cR/3ywr8o7CuzLtup6
	UF6ixIP8aoNK1V46bIG9+D/j/poVf4WBtXatguwvD8sJL0WUjgbOC/9fR6ioacjUPtqtX3
	TVn9pI3GU8Oosg+oBIWIPGiklC4ZwSQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/liEajtHx9CYrzJvqnOmvWcXVvucaBQw0Nv7dYml2Q=;
	b=JEM4ubaXaYhpNlSwLVJFaETun/2QK5hO8qPKmVS6o53wBlm5tye6cR/3ywr8o7CuzLtup6
	UF6ixIP8aoNK1V46bIG9+D/j/poVf4WBtXatguwvD8sJL0WUjgbOC/9fR6ioacjUPtqtX3
	TVn9pI3GU8Oosg+oBIWIPGiklC4ZwSQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-ZdxWWUE-OU6UadleGbLJKw-1; Tue,
 16 Jun 2026 06:09:28 -0400
X-MC-Unique: ZdxWWUE-OU6UadleGbLJKw-1
X-Mimecast-MFC-AGG-ID: ZdxWWUE-OU6UadleGbLJKw_1781604566
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E01D61800597;
	Tue, 16 Jun 2026 10:09:25 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A73019560B2;
	Tue, 16 Jun 2026 10:09:18 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH v4 06/30] scatterlist: Fix offset in folio calc in extract_xarray_to_sg()
Date: Tue, 16 Jun 2026 11:07:55 +0100
Message-ID: <20260616100821.2062304-7-dhowells@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: lh_uGgjBv0lgtaiil4RuIT0rF2bFQeThHoh0ElLvkH0_1781604566
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix the calculation of the offset in the folio being extracted in
extract_xarray_to_sg().

Note that in the near future, ITER_XARRAY should be removed.

Fixes: f5f82cd18732 ("Move netfs_extract_iter_to_sg() to lib/scatterlist.c")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Mike Marshall <hubcap@omnibond.com>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 lib/scatterlist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b7fe91ef35b8..6ea40d2e6247 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1366,6 +1366,7 @@ static ssize_t extract_xarray_to_sg(struct iov_iter *iter,
 		sg_max--;
 
 		maxsize -= len;
+		start += len;
 		ret += len;
 		if (maxsize <= 0 || sg_max == 0)
 			break;


