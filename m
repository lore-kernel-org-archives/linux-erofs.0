Return-Path: <linux-erofs+bounces-1117-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BAACAC5B0
	for <linux-erofs@archiver.kernel.org>; Sat, 27 Sep 2025 05:29:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4cYbcZ2WjXz30T9;
	Sat, 27 Sep 2025 15:29:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1758950990;
	cv=none; b=iSAE5E2fDm5irWoVaxoWdxCRUDYUl4jT5YRrB5dHCZAKyByiVEEdhB/oeZTzr7DK+2BgrCmfGnlUzRcVlj4LxTAjNDGgWJWl+kvzBNzoHzbccc+IvdUiWxd/HzGUAsVLCRGpyLaOHUh9wTAUbkZwB6KBzW6ZQtueHzk0frbeiOqNtoSc5DGlHgf0kpg8hqEKBg8u0TU8+QAwA2Nsy2RL07iZa2Dv7CtsrmBnpSeYDoM5ppdAEKyrv6y71x2GMnMc0Vy3+ZPbcQOF7J1NqtQRJRizBC1+gjTg+K5YoWUktAYDOdxbyaWHsUZ6Lwup6L2DVxxOc88cXyDHo+FxuzHPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1758950990; c=relaxed/relaxed;
	bh=VD2uxdLlhcfwnOpvwW1OtIAwE/x7phcbBuv25QOzTmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=baRGrW6poPrjjsFa+bSNpVyLpHu5tbF/yh8hfXEfQ6uV9O95uPPu5vx8m3OgTmAkcJTg2t4AU6tY9CO5bR4aeJOsO3RO1faIcmDZk2j5LeL4EIBog+v54aXMyzo5HEgvrzTLFRW9U2u1DjrqSiroP9CCkUK+fwNXmteohAmfhKVwz22/IBsN7NNYjmzdw1CG6Et0KS4h4j7sW0jJ4xdRMd86ccM/Ioa9B/gEarDfFaP/5PdyyuRhRnkMEUvpsuXLqHWSXfa5edhe0rh8YKDwPKT73QFBpRfRxaOC2mumbxY5XpGw4HSJWlcxP/AOiet7ywzuurZ/JZNuVl7msesUBg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eEa62Lmx; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eEa62Lmx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4cYbcW5k7fz30PF
	for <linux-erofs@lists.ozlabs.org>; Sat, 27 Sep 2025 15:29:43 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758950977; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=VD2uxdLlhcfwnOpvwW1OtIAwE/x7phcbBuv25QOzTmw=;
	b=eEa62LmxlZw8Q+XfWbiKMFLjKrUm1P4qDy3EAQkJR+0kgOu819fsNY4UNvW+wQ5/6F4fthBobybHNe6bJ6Z3UwGX2PFkUAywzxmL4NQ/wENw6UqXBEOEwNyHFH0HP71EbomF2R+ZqNUEqOwvtAscPljkXFqyLxK0hKM5uygqDPw=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WoutXv3_1758950969 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 27 Sep 2025 13:29:33 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	Nikolay Gorbatov <spraitt@gmail.com>
Subject: [PATCH] erofs-utils: mkfs: tar: fix SIGSEGV on `/` entry
Date: Sat, 27 Sep 2025 13:29:28 +0800
Message-ID: <20250927052928.688309-1-hsiangkao@linux.alibaba.com>
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

Add a `\0` placeholder before `path`.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Reported-by: Nikolay Gorbatov <spraitt@gmail.com>
Closes: https://github.com/erofs/erofs-utils/issues/29
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/tar.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/tar.c b/lib/tar.c
index c93f2c6..139d1c5 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -694,7 +694,7 @@ int tarerofs_parse_tar(struct erofs_importer *im, struct erofs_tarfile *tar)
 	struct erofs_sb_info *sbi = im->sbi;
 	struct erofs_inode *root = im->root;
 	bool whout, opq, e = false;
-	char path[PATH_MAX];
+	char _path[PATH_MAX + 1], *path = _path + 1;
 	struct stat st;
 	mode_t mode;
 	erofs_off_t tar_offset, dataoff;
@@ -702,8 +702,8 @@ int tarerofs_parse_tar(struct erofs_importer *im, struct erofs_tarfile *tar)
 	struct tar_header *th;
 	struct erofs_dentry *d;
 	struct erofs_inode *inode;
-	unsigned int j, csum, cksum;
-	int ckksum, ret, rem;
+	unsigned int csum, cksum;
+	int ckksum, ret, rem, j;
 
 	root->dev = tar->dev;
 	if (eh.path)
@@ -817,6 +817,7 @@ out_eot:
 			path[0] = '.';
 			path[1] = '\0';
 		} else {
+			*_path = '\0';
 			while (path[j - 1] == '/')
 				path[--j] = '\0';
 		}
-- 
2.43.5


