Return-Path: <linux-erofs+bounces-1874-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 500EED37E5C
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Jan 2026 15:53:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4drrHR5RnDz2xNg;
	Thu, 15 Jan 2026 02:53:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768405987;
	cv=none; b=gBVPFItFMmMvKdPxyd0J4aqZQHf3ELxCX/e0EpTwOTQ7MbspHmpSAuLpws3fD5S5JQ5RejSEpEBs+jVCu9DSI9nvoWRP9B/FnAX0qHBjdK/A0028eLh/87dGH0rLJ7xn7ADR8mfvfF0YXtMsb9DuTyOhEB/qTM3T5UVrO9fTfvQyN9XUD1gzD30ZakNF3AmJpXYrECbhi+ZZstxZXZRGJYk1M4J7qO0Y8RPAQSJT5z7oC2Hs27ATJ+SoS61biZyhuNVniTCzFa8S0VgZYal3Yqr6V5A2hqvEDl9Ur+lvsuupfvdnygqW6Snn1DXMe80IubzDoYFbW3S3hi9cuaMmhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768405987; c=relaxed/relaxed;
	bh=SugirP7vIivOSyDft30vnF49xHcPlaIK7U9FsxKBseI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BGqXjytPRWkYrk1LAzpkBDCBY8Cvqez0msQLRG2ObWuKwNKrxfvC76uuhBhaLeos/89Vj/aV7heY+RNQBhlJkNqB8Nw/0MGgD4goqaXElzNYSJ43sk7wvq6A2w+LBRz/bxpLCfcxq468vIDFv4k7ZoavRJ9S5OUWla3r8c9+7oxpimkarsSzTI06NVUZcliWmzqTBsvtUJU6LFO1UhddHfF+kfkmYIinwkoV9A/5IhIBqLLwK2V35CUiGQr9CCxA0CToq91z+k19Gzw29Yf7yc5baU//iBKBGm2lW7HSlzVRd2VTbNjLsOmD1EBvHqrT/yiVVLJSJrQAWtlMHnuNdg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uDKAFohE; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uDKAFohE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4drrHP0GnBz2xNT
	for <linux-erofs@lists.ozlabs.org>; Thu, 15 Jan 2026 02:53:02 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768405976; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=SugirP7vIivOSyDft30vnF49xHcPlaIK7U9FsxKBseI=;
	b=uDKAFohE6zo2aIPAtKvq3FtnK//vuH01TptSt2BFuKwj9QeI2XeIoYr16EfpZFPSzEXggq+QhCj5/q6Dar2/5BQJBq0KhYgzEoNVSSfpQcE3fA7uv95fwGOjpt8ZwFk3CS0Iof934fNxrMmsfyb+V+adAS9LO7XHxuRr3UqsgZE=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wx2sihi_1768405970 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Jan 2026 23:52:55 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	manageryzy@gmail.com
Subject: [PATCH] erofs-utils: lib: support >2TiB tarballs for EROFS index-only images
Date: Wed, 14 Jan 2026 23:52:49 +0800
Message-ID: <20260114155249.2732642-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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
Content-Transfer-Encoding: 8bit

Again, the liberofs code for chunked inodes needs to be refactored.

Reported-by: <manageryzy@gmail.com>
Co-developed-by: <manageryzy@gmail.com>
Closes: https://github.com/erofs/erofs-utils/issues/31
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/blobchunk.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index c66bd2020e45..f213c2868774 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -499,6 +499,16 @@ int tarerofs_write_chunkes(struct erofs_inode *inode, erofs_off_t data_offset)
 		blkaddr += erofs_blknr(sbi, len);
 		data_offset += len;
 	}
+
+	/*
+	 * XXX: it's safe for now, but we really need to refactor blobchunk
+	 * after 1.9 is out.
+	 */
+	if (blkaddr > UINT32_MAX) {
+		inode->u.chunkformat |= EROFS_CHUNK_FORMAT_48BIT;
+		erofs_info("48-bit block addressin enabled for indexing larger tar");
+		erofs_sb_set_48bit(sbi);
+	}
 	inode->datalayout = EROFS_INODE_CHUNK_BASED;
 	return 0;
 }
-- 
2.43.5


