Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31EC8C52D71
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Aug 2024 06:23:58 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eIOSbQo9;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WZwlJ6603z3dWQ
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Aug 2024 16:23:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eIOSbQo9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WZwl94H69z3cSd
	for <linux-erofs@lists.ozlabs.org>; Fri,  2 Aug 2024 16:23:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1722579823; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=y8hdQidBoEmqHKmkW3yJIVprsVqXcAgdNHimu8PYcTM=;
	b=eIOSbQo9YC2T8cCdhegKNSyEIawsg0Tf9UJL1O3Rn0iE3N4YPWGZ6fxMmNOeA3siqEayGh4E2amXEfG78jm4stkLiAJv6oXl7Lyp2CqjEMDWrslTzvNzDSLxMc4XPY8Dq2n0O9A3umFtQJjiL5+V6v01KqYhblK0NMn+zaeBDEo=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0WBwRHdA_1722579816;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WBwRHdA_1722579816)
          by smtp.aliyun-inc.com;
          Fri, 02 Aug 2024 14:23:41 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 4/3] erofs-utils: lib: fix potential memory leak in erofs_export_xattr_ibody()
Date: Fri,  2 Aug 2024 14:23:16 +0800
Message-ID: <20240802062316.2368403-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com>
References: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Although it won't happen in reality except for bugs.

Fixes: 8f93c2f83962 ("erofs-utils: mkfs: support inline xattr reservation for rootdirs")
Coverity-id: 507395
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/xattr.c b/lib/xattr.c
index f860f2e..651657f 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1020,6 +1020,7 @@ char *erofs_export_xattr_ibody(struct erofs_inode *inode)
 		memset(buf + p, 0, size - p);
 	} else if (__erofs_unlikely(p > size)) {
 		DBG_BUGON(1);
+		free(buf);
 		return ERR_PTR(-EFAULT);
 	}
 	return buf;
-- 
2.43.5

