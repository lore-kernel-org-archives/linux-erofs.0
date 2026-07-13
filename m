Return-Path: <linux-erofs+bounces-3885-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64598C43458
	for <linux-erofs@archiver.kernel.org>; Mon, 13 Jul 2026 08:35:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gzG3j5wchz2yMm;
	Mon, 13 Jul 2026 18:35:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783931745;
	cv=none; b=YGGrtTq5fojYEwp1fHkmLFjwt89q3GWgDzR3zXbNpygMX7aiL3j+P1tTNwZt5G4at4gZyomcxZZwiewW3iJPMimt08optWospa3JTVY9a3byp+9MgMKA6bxjBJqxuv79yAY3lPtphDiq3LqIFLnbTeuACbdz70QWxhONUv7EoAO0AVy/IrlZN4l7n8O8ni/4mOy4zizQOzLeq7Pv1F7dBLEIBHLz/GpJbd6WHyIjoFrW9UE5iZkTdw6KNdzUhz2tThTo0NwgVirUwEMzwR6W+6c5bkYujSSdEAodsWpxj2sRBtdq4s+NoHBDXzkN/Zjhcy7SyFQ6QQQd/+ipbm2bzw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783931745; c=relaxed/relaxed;
	bh=2SmJ95mWigTNYSEHKoKTBhLuvadF7wM9nv0YjuUp5Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mtF2n/q5p6aH9xih6bX5Ok8+eMDs9ZCkFjU4gyZPzyLeueswxoob2iHDL6T9tuCHplkZRvfzicsEjaBb77kJJ+iKL8dXxFn+Vc2YqsRulXF/l76bUO4h7R28Cs+HfSdRCv2kBO96A9eMQefsMEjio0sPJ6FOYU9cHe8KT0kNkBCYvoBHyahPI4cOfiHQrae6LOXhJ8khpsVSwqhohOdF9Vx2NYObNGTGcMLXQrjiUfMyxb8Lnjz6qp03F25kY5Zp4k9xIxButxu8URN2yXIbjaAfOyx7sN0hVEmjkLpZT4EhSLnlb7SgVRyOX/Nh/G9eCePkyhs4FdoGKbN9NAa8uA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gfTiJzlB; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gfTiJzlB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gzG3g5x4wz2xlv
	for <linux-erofs@lists.ozlabs.org>; Mon, 13 Jul 2026 18:35:42 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783931739; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=2SmJ95mWigTNYSEHKoKTBhLuvadF7wM9nv0YjuUp5Vg=;
	b=gfTiJzlBmqydGwVCB5PDIGaDsT0+5S7bx5hU76U9LnG7Mzphd8lLS5OQ3VdHYA+C5vilq71lfg12TiQ+FSUhBbG5QpU58nk+s4M+Ro9ysH1WLvX5pQSpu1FKXbNQqdy8ZN2NWeBkHkrEIUG2i0jUmmhZRMVtbwRbJ17sQo32POw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X6xCluZ_1783931730;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X6xCluZ_1783931730 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Jul 2026 16:35:37 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs: hide "cache_strategy=" for plain filesystems
Date: Mon, 13 Jul 2026 16:35:29 +0800
Message-ID: <20260713083529.3309658-1-hsiangkao@linux.alibaba.com>
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

"cache_strategy=" is meaningless and confusing on unencoded EROFS
filesystems; gate it on compressed images only since it's now possible
after commit 7cef3c834194 ("erofs: separate plain and compressed
filesystems formally").

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 86fa5c6a0c70..85674b08f66e 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -1038,7 +1038,7 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 				",user_xattr" : ",nouser_xattr");
 	if (IS_ENABLED(CONFIG_EROFS_FS_POSIX_ACL))
 		seq_puts(seq, test_opt(opt, POSIX_ACL) ? ",acl" : ",noacl");
-	if (IS_ENABLED(CONFIG_EROFS_FS_ZIP))
+	if (IS_ENABLED(CONFIG_EROFS_FS_ZIP) && sbi->available_compr_algs)
 		seq_printf(seq, ",cache_strategy=%s",
 			  erofs_param_cache_strategy[opt->cache_strategy].name);
 	if (test_opt(opt, DAX_ALWAYS))
-- 
2.43.5


