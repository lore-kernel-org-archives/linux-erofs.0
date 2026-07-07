Return-Path: <linux-erofs+bounces-3855-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D978C43458
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Jul 2026 13:40:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gvj5V5CW7z2xWY;
	Tue, 07 Jul 2026 23:39:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783431598;
	cv=none; b=Kk/29qABoIC34fzGD4Nn+PXNpC4Z4Bh44BWM9mQQlMjl5zyFD1+KfWRncvXnZd3Xgkcm+71bFibnHnYMAzICZd4dZBvdAJwup/xYvPt7ii23T5EZ5xv1DwYQ/ve51sFxSRLCGiFtCi9mgtQo4QoV8y1EIBoPLeP3Xg6ehxOSSIRi4jF414mfcim1CMrWgn0lJiF0f0sev+APVfLBv3RbNX2g1m6MT54tNk8FDbdhUh3TaHkNB8OE3dk+HkwoJrXFREmr4qfGGEmNM155U01RBl0UccXTXbjEPMjKekywJ7RYkLQSHt8Whs3KlvqDHFMeJd4+OE2VrQGYBZcoSaghAA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783431598; c=relaxed/relaxed;
	bh=ow3ueylzDqfZ4A7Q4jx1GAQKDOjhMGDqaY2Vm+GmbVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eDuuC6Dl3NNF//NcVlaf3vP6RzeK1I6mPzrMSwoePC7CIiL4oli9LJ8OdW7yEXKN+qahRmVYtM+2jfQ8xeX70K77+Vw3aHWGocus48PNPHteI4X0Qw/6++fyWoznEK6wHWNyl/YU9K38nR6RHDO8Liw5kBhp5ltFJiir139CzFSEEfPg8g1O0cJqLZhRgmTugpGsMfb7z/j2AbAOFwzdMdGqxOhRFK5Yde8K8YxCqTIoqVj8Be3YFssugjcQUfvXqCP8Ag1PTwiyb83dDVxbptz4IgSGrYKhk1O3P2+GQuiPDURgvXjtm9IjWqXzaZIoAd2sRWjA3CoIU6lTGzMBDg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IWgTG8Mr; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IWgTG8Mr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gvj5R1Y1Dz2xF8
	for <linux-erofs@lists.ozlabs.org>; Tue, 07 Jul 2026 23:39:53 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783431589; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ow3ueylzDqfZ4A7Q4jx1GAQKDOjhMGDqaY2Vm+GmbVI=;
	b=IWgTG8Mr31OKNmSjXFCrb/P1VK1axHybtKHVpYBQ3O3FX9tsfk93xckiQkabudckx1kcEEeEVtcuALaIyZMAos8cWgLx2jl8K3RGLO/mbMr/yNdnTAG+BorKkmgfyOET/Zk9Gv/NTqmwir2wP5Lg1yz0iaznmmsgYPq7rpnoBHE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X6dqLjQ_1783431580;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X6dqLjQ_1783431580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jul 2026 21:39:46 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs: get rid of erofs_is_ishare_inode() helper
Date: Tue,  7 Jul 2026 21:39:39 +0800
Message-ID: <20260707133939.1204354-1-hsiangkao@linux.alibaba.com>
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

Just open-code it for simplicity since FS_ONDEMAND no longer exists.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/ishare.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 0868c12fc15b..a1a20a5ba548 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -12,12 +12,6 @@
 
 static struct vfsmount *erofs_ishare_mnt;
 
-static inline bool erofs_is_ishare_inode(struct inode *inode)
-{
-	/* assumed FS_ONDEMAND is excluded with FS_PAGE_CACHE_SHARE feature */
-	return inode->i_sb->s_type == &erofs_anon_fs_type;
-}
-
 static int erofs_ishare_iget5_eq(struct inode *inode, void *data)
 {
 	struct erofs_inode_fingerprint *fp1 = &EROFS_I(inode)->fingerprint;
@@ -179,7 +173,7 @@ struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
 	struct inode *realinode;
 
 	*need_iput = false;
-	if (!erofs_is_ishare_inode(inode))
+	if (inode->i_sb != erofs_ishare_mnt->mnt_sb)
 		return inode;
 
 	vi_share = EROFS_I(inode);
-- 
2.43.5


