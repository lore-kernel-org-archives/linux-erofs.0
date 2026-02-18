Return-Path: <linux-erofs+bounces-2332-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 372F1E9A03B
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Feb 2026 10:58:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fGD5r3CNTz2xlq;
	Wed, 18 Feb 2026 21:58:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771412336;
	cv=none; b=g9PtfDl18HJaOEmIRKwxbUiR7TUeqXg8oA66ziz9dITgxNpVFpVelZbSk3hyEHDElTcZXW616JILGNihcC/BajuYDfgaQc5y/km9J3HXjNTswo8f6vuVPcm98sAK5H2hEjcJembVdHmfcfDmE1QBz+lmw5QxVOttXX9mmCS/H9QwrJIPBIFOfm6E5Br1edq9b2lVUDhSWqJVk8gnoUox0mnhnYdoGJRc0FBYoN2Avg8d5cLLK4kMpUBe17Iws3NiHvBzdekmuwyd4LKL5OdUB9UQhpV7PO6N+QMdUXFxR/LcgWJMFVEBVBFnpZkjDui71oV3J3TMOQyElPaEiMAypQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771412336; c=relaxed/relaxed;
	bh=6FSbbUmT0kW9FrFKAQgMm0DpM0xB9BuAVHu/pEXcjQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IJskhV9POH9Xz0RHJJR1yqv6vLxEKREgaXSwQfcTOeUHoWFRexLkQBSPUBnBqUZWiyO97fBIUANJ2Srj+2rq8sw2Hcd7kbNfKbPflMtpVr49qQDTa9mzsi6B++dzLQue2FOqLTB16z2oGHgw8qghefyAyaBC2IU9PH8dychXow5aAEyn7JJSQ0yxGCKdlf7Ii8s+cQk52IYYPlEJN7flqV96fJ759sU4ftjU0VIrFZREqhgODSGx7jFpES6V5ldvhu81iBwszNZYYqI/QgE+6GDKRBu4cFRthERR8zwCCGuZrNazwEYrANjPLeqYtr0ktkQBNotNxf1rC7tUpYiA0w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MmFgL2Oy; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MmFgL2Oy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fGD5p27dhz2x99
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Feb 2026 21:58:52 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771412327; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6FSbbUmT0kW9FrFKAQgMm0DpM0xB9BuAVHu/pEXcjQc=;
	b=MmFgL2OyoOAzIGMMQy9soeX3E6aoqLbhyNK/vFeBlu9Yfy0Sl+83Dt9pX9BM0r8U74qxCa11d845lRX2THsPHtfkUajJh5w8sW07sZ8XfZaAcxfiV08IdhsIEnpfvndL4m6VLghBjVNyFyqzktniwBD0Ah2wVrCdDJMD8F2wi6I=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzSQDEH_1771412322 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Feb 2026 18:58:46 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: lib: set `bh->op` immediately for compressed buffers
Date: Wed, 18 Feb 2026 18:58:41 +0800
Message-ID: <20260218105841.100916-1-hsiangkao@linux.alibaba.com>
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

This fixes the following SIGSEGV that occurs when compression fails:

in __erofs_bflush (bmgr=0x7ffff695c010, bb=0x0, abort=true) at cache.c:482
482                             ret = bh->op->flush(bh, abort);
 0  0x0000000000413860 in __erofs_bflush (bmgr=0x7ffff695c010, bb=0x0, abort=true) at cache.c:482
 1  0x0000000000413cbe in erofs_buffer_exit (bmgr=0x7ffff695c010) at cache.c:549
 2  0x0000000000414f72 in erofs_put_super (sbi=0x493270 <g_sbi>) at super.c:193
 3  0x000000000040718d in main (argc=6, argv=0x7fffffffd628) at main.c:2165

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/compress.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index 995bc602b145..7e8142a48ae5 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1388,12 +1388,10 @@ int erofs_commit_compressed_file(struct z_erofs_compress_ictx *ictx,
 	erofs_info("compressed %s (%llu bytes) into %llu bytes",
 		   inode->i_srcpath, inode->i_size | 0ULL, ptotal | 0ULL);
 
-	if (inode->idata_size) {
-		bh->op = &erofs_skip_write_bhops;
+	if (inode->idata_size)
 		inode->bh_data = bh;
-	} else {
+	else
 		erofs_bdrop(bh, false);
-	}
 
 	inode->u.i_blocks = BLK_ROUND_UP(sbi, ptotal);
 
@@ -1690,7 +1688,7 @@ int erofs_mt_write_compressed_file(struct z_erofs_compress_ictx *ictx)
 		ret = PTR_ERR(bh);
 		goto out;
 	}
-
+	bh->op = &erofs_skip_write_bhops;
 	DBG_BUGON(!head);
 	pstart = erofs_pos(sbi, erofs_mapbh(NULL, bh->block));
 
@@ -1985,6 +1983,7 @@ int erofs_write_compressed_file(struct z_erofs_compress_ictx *ictx)
 		ret = PTR_ERR(bh);
 		goto err_free_idata;
 	}
+	bh->op = &erofs_skip_write_bhops;
 	pstart = erofs_pos(sbi, erofs_mapbh(NULL, bh->block));
 
 	ictx->seg_num = 1;
-- 
2.43.5


