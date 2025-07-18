Return-Path: <linux-erofs+bounces-666-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB64C83F1A
	for <linux-erofs@archiver.kernel.org>; Fri, 18 Jul 2025 06:54:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bk0s53dMTz30Wg;
	Fri, 18 Jul 2025 16:54:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1752821673;
	cv=none; b=V0Rvr52uwcijDv4M3L/IUMDAAVND/EHwK0ro/Kjmsv338XMzR0opRHVMMor6QBL+yg0ccYLtZHwz7MncE2EmDOh4ASDbeg2/pNv/WYkztUmu/47oWQ62rocrFfIsv5K5fbjCjNGbvT+L9CAGqsi48az9SMBd/nuC37WJ/KLjolM6ARm8EQMgCNcpY2SUYr8gpn3Z4EdE8+zY9IXlDfSfnChBvZIWtZTnYkFwLDaXkmDGa1Oxi41tJhUqPHaqjV168rMbuA8GzKxiJISOZt7SnRpcFEKl2aCOqfF4LwD0LjmSqgNpb6jLUbiFhglxjT+O/knTeNeVSzqFdR2ce3WRKA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1752821673; c=relaxed/relaxed;
	bh=hUrvBhpLJeo5e2F+FxUovDoRKL1vlAGdqOeC7hnz8Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CYRXLG6fFTIhha9j6FXwt0BBn3xTCPZw0QoCWYNYVycv8gdxCioSDybkwTJd8s0+hUZwy3FCF/AdM22qpK26U5avzsqA0hbt5khc/KcpUVT1MbtdPPSYnrlUGWGOO224Gyysq/5Cl6kULg4Lb7yGCMo2FWgZmW//f5LbEVpih1hWSyk9AlGumLX+GhuUp9e0vQk/hqCJTtloOz4r1s6qPzMBpEebGGnUrapEb77A6HVaBLCQOJySlNN7pUBmNRT9bjWzSQoyVlQOWgvwmYHhQIjne7Q2EMJCjhmBw41EncYg3/h/CtKSf4CD7sNP0e2x8uQy62mDAE18nIu7iusG0A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=D4ZX1i8p; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=D4ZX1i8p;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bk0s34CtPz30Tm
	for <linux-erofs@lists.ozlabs.org>; Fri, 18 Jul 2025 16:54:30 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1752821666; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hUrvBhpLJeo5e2F+FxUovDoRKL1vlAGdqOeC7hnz8Fs=;
	b=D4ZX1i8pCGeZ4qA02624c4npmnHd7FSCqRvTh09bzNejgLQPgl56589tfpunhAPa4Qkjbn7+a90eavHPXp6h/sq3WybvgSFsVP+gIjVZP6EXv+H0Z0Uk62G/COtzUBmoPNvpHSwBjWnhP9303tiFlWEKzLhAv8EAI8dU/ZIyTfE=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WjBMlPT_1752821660 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Jul 2025 14:54:24 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 01/11] erofs-utils: mkfs: don't generate encoded extents for ztailpacking
Date: Fri, 18 Jul 2025 14:54:09 +0800
Message-ID: <20250718065419.3338307-1-hsiangkao@linux.alibaba.com>
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

.. Need more library work for ztailpacking.

Fixes: f978245e9da8 ("erofs-utils: support encoded extents")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/compress.c b/lib/compress.c
index a57bb6a3..22fb5d6d 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1142,7 +1142,8 @@ static void *z_erofs_write_indexes(struct z_erofs_compress_ictx *ctx)
 	struct z_erofs_extent_item *ei, *n;
 	void *metabuf;
 
-	if (erofs_sb_has_48bit(sbi)) {
+	/* TODO: support writing encoded extents for ztailpacking later. */
+	if (erofs_sb_has_48bit(sbi) && !inode->idata_size) {
 		metabuf = z_erofs_write_extents(ctx);
 		if (metabuf != ERR_PTR(-EAGAIN)) {
 			if (IS_ERR(metabuf))
@@ -1181,6 +1182,8 @@ static void *z_erofs_write_indexes(struct z_erofs_compress_ictx *ctx)
 	ctx->metacur = metabuf + Z_EROFS_LEGACY_MAP_HEADER_SIZE;
 	ctx->clusterofs = 0;
 	list_for_each_entry_safe(ei, n, &ctx->extents, list) {
+		DBG_BUGON(ei->list.next != &ctx->extents &&
+			  ctx->clusterofs + ei->e.length < erofs_blksiz(sbi));
 		z_erofs_write_full_indexes(ctx, &ei->e);
 
 		list_del(&ei->list);
-- 
2.43.5


