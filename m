Return-Path: <linux-erofs+bounces-3593-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 935A5CD98C5
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jun 2026 08:40:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gf3V150tGz3bsK;
	Mon, 15 Jun 2026 18:40:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781512825;
	cv=none; b=lsZq9/U5jS1f+U8umbhEliY220fLBSvW4vkpAav9UeVgy/OhQEQDJ/e/K9wGr3xb78gy/qjMESvcQbQ6vqTWQ5BZknEmOkiiT2EycO3n/PmAn6sU2+aVdHHk5aMkI8lyAE/DHjp2xNiDJDbaKWhgXcaeEYHf+CJRApsFd8yFbc8J8xM3AV5g+7t2/8B5mzm7S3py3qzNbOjFwy4zYq7HoDLwTLZiqnuhSQrIHxLKorhdJCQlnj1AGqR+0T9bVtTkBvzW6ITu87awg0MSKI3CX+/LrOzL66+X4ABvjopIYRaAHMSpCm/8Cmr21r7kkB4xkcl3sSLRs/yuuAyO+IlqZA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781512825; c=relaxed/relaxed;
	bh=I3Q4TrRYy4LZLaH+N1nGN5Nt0i8ybmOQOix5SaoJpI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaFN3eidCQgDF5UIsoK/VN47KG8/iAF9HPSwbyO4J4ScMS126BdFjbBuQzUUaLt4yXgWgKKpqRnAIZhtJbRXxbeqQIJ0TOV+CeGdRo4FcWuilBBbdIGCfYPIGSG/5TqWvdkTNE2NqJe8G0eJvIitBPvNXs6+wR/8q5uvOsjEhQr7Stt3bNw4Fqg3ttD9CU9TrwK/bHnmXcCIbEpu6CuwvHqwngv39vwfMU02TkCxNWaBnZOaZZhhX6BOHYbY6qAYu5G1tsKainjTwoImXk/6o/XEtHSblx66UG1PSEWB67hmtzVipVw3AF1nngrOu+AlbSu6j7lG265BXCNQYUL/Qg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wxqT5LH2; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wxqT5LH2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gf3Tz4bZwz30gJ
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 18:40:22 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781512818; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=I3Q4TrRYy4LZLaH+N1nGN5Nt0i8ybmOQOix5SaoJpI8=;
	b=wxqT5LH2+22RDZscW+lvzeVyeULG5I6DOgXHA8qDyTSWOBIP5Nsv0sRVzesNZQRHOju++TOa+p5nTQQQHTZeseFi+Lqvketbyu+DipYKEqHe3lAz3fsml9+1UpLA19FbiEuYGCvJ/4DxDmuzCBTJFrZO7f8M/Ldwms0B2PVWAaA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X4s4J.K_1781512816;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4s4J.K_1781512816 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 16:40:16 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Tristan <TristanInSec@gmail.com>
Subject: [PATCH 2/3] erofs-utils: fsck: account '/' separator in path construction
Date: Mon, 15 Jun 2026 16:40:10 +0800
Message-ID: <20260615084011.325686-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260615084011.325686-1-hsiangkao@linux.alibaba.com>
References: <20260615084011.325686-1-hsiangkao@linux.alibaba.com>
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

Reported-by: Tristan <TristanInSec@gmail.com>
Closes: https://lore.kernel.org/r/CAA1XrhPMekMqAnRkC-jV9rTsO4LHjzh=kxn6zQKMgBrqfrnp8A@mail.gmail.com/3-fsck-path-off-by-one.txt
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fsck/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index f7f1387fe642..87eeb81136ff 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -191,7 +191,7 @@ static int erofsfsck_parse_options_cfg(int argc, char **argv)
 					return -ENAMETOOLONG;
 				}
 
-				fsckcfg.extract_path = malloc(PATH_MAX);
+				fsckcfg.extract_path = malloc(PATH_MAX + 1);
 				if (!fsckcfg.extract_path)
 					return -ENOMEM;
 				strncpy(fsckcfg.extract_path, optarg, len);
@@ -902,9 +902,9 @@ static int erofsfsck_dirent_iter(struct erofs_dir_context *ctx)
 	prev_pos = fsckcfg.extract_pos;
 	curr_pos = prev_pos;
 
-	if (prev_pos + ctx->de_namelen >= PATH_MAX) {
+	if (prev_pos + ctx->de_namelen + 1 >= PATH_MAX) {
 		erofs_err("unable to fsck since the path is too long (%llu)",
-			  (curr_pos + ctx->de_namelen) | 0ULL);
+			  (curr_pos + ctx->de_namelen + 1) | 0ULL);
 		return -EOPNOTSUPP;
 	}
 
@@ -915,7 +915,7 @@ static int erofsfsck_dirent_iter(struct erofs_dir_context *ctx)
 		curr_pos += ctx->de_namelen;
 		fsckcfg.extract_path[curr_pos] = '\0';
 	} else {
-		curr_pos += ctx->de_namelen;
+		curr_pos += ctx->de_namelen + 1;
 	}
 	fsckcfg.extract_pos = curr_pos;
 	ret = erofsfsck_check_inode(ctx->dir->nid, ctx->de_nid);
-- 
2.43.5


