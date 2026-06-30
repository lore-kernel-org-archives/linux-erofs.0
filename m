Return-Path: <linux-erofs+bounces-3786-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E41DC43327
	for <linux-erofs@archiver.kernel.org>; Tue, 30 Jun 2026 02:52:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gq73r23Wmz2yYd;
	Tue, 30 Jun 2026 12:52:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782787960;
	cv=none; b=SkF9WkVl3Ijf5qGqlMRiV8UZS4733XeF6eXWKzK/S6Pz8g4EHOczoCwXkCkWa22ZMedF5EZln492ZPV2/exbHNQc21Uj6ykaZ8iZhbCq0njpxT8f6kkG1m2giKRWt/t1rbsX8+CfQvBUoq7XGrLcakHfNKY/U0stlEV3+0s0TsUCfqZV+4wA23eVmxoxZ+ppsCRZcoRGHvx5j+SUWPFgzNqIvgLTFWOHszdiIz/QscfkB+Ui6xQEA9QgrAbNTv9LfcgfVUqC6xnG2pOkWQkLqBLmkW9xb6HmuOeQbKf4FrqCpQnijYb39wHHk9uLU5ggseeqQ7OBxCp7O1eSfYv6zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782787960; c=relaxed/relaxed;
	bh=0GVlVlyYBYknUObrhkzI3a3+u4l7oQ9wo50I7h/RcLs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MFwtwD7/kPm1p2t4ofGK4o2NyiTDcAG87s/0TNPR4BX6DO0vnHj9xR9XzqqwDlgo66X9z16sQLRaHTlmEoMt8MFyvcTQgDe+Bo4hvuCV0R0Bl1cpYb1fBPiQcpdF/cJbVcQynVs5+fA8nqKhMg7idEVz5vsn1kvmMYirjAvbrHdMd6gjNqipsLabKXwm/z8HugtBbzWpbHbJG6IEROXmLhNTbESovyA5o40hu1lGrFEIsWg8hfqBhLsTzcb6Fi0IHTFfdnRLPdrH2GvI2FPXtQwZrIBo/ozuaMznhiWqqB5OCkyJTPTVapty5KMYQvKZ0/uUdn6fk0UkY/bPcUPY/Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mc1faq8R; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mc1faq8R;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gq73m6MPbz2xHK
	for <linux-erofs@lists.ozlabs.org>; Tue, 30 Jun 2026 12:52:35 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782787950; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=0GVlVlyYBYknUObrhkzI3a3+u4l7oQ9wo50I7h/RcLs=;
	b=mc1faq8RhvaLoRdti/EevLtr56yxhY0lSoN9VKRbk7B6peXyEFRCDTSyUtwyU8HGfyvSth2LpA+/YgTssFn4od7gsjzbM5E2GH+53c89cR3knf6RKcKWk8PcbqaIsgO9lR1WxdRe4INPXEFfeoeMwoWWDtZmm6j6j2hucv5cg1c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X5zS2nz_1782787945;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5zS2nz_1782787945 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Jun 2026 10:52:29 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 1/7] erofs-utils: lib: fix `ictx` leak in the failure path
Date: Tue, 30 Jun 2026 10:52:18 +0800
Message-ID: <20260630025224.3955763-1-hsiangkao@linux.alibaba.com>
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

Coverity-id: 647272
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index e57de425be28..f7ad5a1c6c87 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1881,8 +1881,7 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 			if (!erofs_sb_has_48bit(sbi)) {
 				erofs_err("Unaligned compressed extents must be used with the 48bit encoded extent layout",
 					  ictx->max_compressed_extent_size);
-				free(ictx);
-				return ERR_PTR(-EINVAL);
+				goto err_out;
 			}
 			ictx->data_unaligned = true;
 		} else {
@@ -1894,7 +1893,7 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 		if (ictx->max_compressed_extent_size < erofs_blksiz(sbi)) {
 			erofs_err("Maximum compressed extent size (%u) must be at least the block size (%u)",
 				  ictx->max_compressed_extent_size, erofs_blksiz(sbi));
-			return ERR_PTR(-EINVAL);
+			goto err_out;
 		}
 	} else {
 		ictx->max_compressed_extent_size =
@@ -1910,6 +1909,9 @@ void *erofs_prepare_compressed_file(struct erofs_importer *im,
 	ictx->fragemitted = false;
 	ictx->dedupe = false;
 	return ictx;
+err_out:
+	free(ictx);
+	return ERR_PTR(-EINVAL);
 }
 
 void erofs_bind_compressed_file_with_fd(struct z_erofs_compress_ictx *ictx,
-- 
2.43.5


