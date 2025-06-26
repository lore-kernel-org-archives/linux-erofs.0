Return-Path: <linux-erofs+bounces-493-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A09C77B7C
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Jun 2025 00:32:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bSKQT4WFFz2xWc;
	Thu, 26 Jun 2025 10:32:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1750897953;
	cv=none; b=FdF21lhne19G9QNxr++4ZN+A4qvkh9CLUbcDg7vqLu+ZPlVyPkqNSCNZZKhbrVlhLGgFEZLUbNs7gbmH+jLlZnb+2mgChCDjffleBAnAxeHouhYwTGKMHzj/jQZandtRvEm8QjXifZGPUcYFNOOYp7r68GRRgEWiloX9zyMAQ9pTy62J+H1BU6YnDqUfsm1/DFn6Pe3hwUb7AXe+CgoOxepklsl5eaGlcjO8izTxhZ/hSk1Gq7NaWitOFa1L46JiW+EN7a2JckX6R37mMwte1RiJ3ib7pNARvgpmhLyBVTty/Hti2fY6/RICebOEwsyxAGfE9QzqyAG6bEag8B2QyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1750897953; c=relaxed/relaxed;
	bh=SxEMG9ZQgsp1ztTxz8FYey2AAb6wu+XT/1m7q4W62AA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Reyfh4htTbdz2pSCFPIsYDncmNdTB2vTPXrYMJzPYRAdKN1F3GC52Zoka8kSNOjhaOGIvZMO+K10UWntSTXk/l/LjPcrd/dkaaC9zOhslZFxl39Rerf3DY1hJitRBNP49i8NpG7M/7Vgj+ihwdTQ29rqtVn63oQUYIwEkwzNNh4Zlg05RejK3/GK30Vg/DFtfDZHrcAukiBUHhjhDGlgNI0/h8PVtIr3nZ/dJuq9Xm9CZ1fbcU3wx7I69WNG0GGZwO3WfTxy2dhgmHTEn5T3h2bzG2XRNOjmk/91vyZ9ZyYOp8iwbx5aup14pvWKcXQinSAjqAr4kMWVjxpIMj2I/Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FOSe1ctM; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FOSe1ctM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bSKQR1xWwz2xRt
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Jun 2025 10:32:29 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1750897945; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=SxEMG9ZQgsp1ztTxz8FYey2AAb6wu+XT/1m7q4W62AA=;
	b=FOSe1ctMa7nhqgKEi/35rhBQUQbLm02CBLRtvuviqXvcgPTm/xNopELjJ3VAM2zfVPTeqC/4FS4BxonXeR4ojd+tjbg4mcEcwyS4UF00B7V4G3uOYh3LhMF8cRxQDm84vkuCqT1c3rAHBwnRciMy7eppSxtos2MPKBlnWBlDRRk=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wf4NyOD_1750897940 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Jun 2025 08:32:24 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: David Michael <fedora.dm0@gmail.com>,
	Neal Gompa <ngompa13@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: lib: fix small fragments again
Date: Thu, 26 Jun 2025 08:32:19 +0800
Message-ID: <20250626003219.3866538-1-hsiangkao@linux.alibaba.com>
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

`inode->fragment = NULL;` overrides `inode->fragmentoff`, which is
unintended.

In fact, the latest stress test [1] had already failed, but I didn't
notice it. Fedora openQA tests [2] also reported the issue.

Fixes: 9fa1a5838a2a ("erofs-utils: mkfs: fix memory leak from small fragments")
[1] https://github.com/erofs/erofsstress/actions/runs/15881657361
[2] https://bodhi.fedoraproject.org/updates/FEDORA-2025-e6256ddcc4
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/fragments.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/fragments.c b/lib/fragments.c
index 6111631..3278f47 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -365,7 +365,6 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
 		return 0;
 	}
 	inode->fragmentoff = (erofs_off_t)offset - len;
-	inode->fragment = NULL;
 	free(fi->data);
 	free(fi);
 	return 0;
-- 
2.43.5


