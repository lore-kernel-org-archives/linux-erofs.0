Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB76C28CF5
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Jan 2022 03:37:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Jk8Yt5Wzyz30MG
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Jan 2022 14:37:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.44;
 helo=out30-44.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-44.freemail.mail.aliyun.com
 (out30-44.freemail.mail.aliyun.com [115.124.30.44])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Jk8Yg6cRgz2yPv
 for <linux-erofs@lists.ozlabs.org>; Wed, 26 Jan 2022 14:37:41 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R631e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=2; SR=0; TI=SMTPD_---0V2tT0BL_1643168253; 
Received: from
 e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0V2tT0BL_1643168253) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 26 Jan 2022 11:37:34 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: fsck: don't set attributes when fscking only
Date: Wed, 26 Jan 2022 11:37:26 +0800
Message-Id: <20220126033726.15865-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20220126033726.15865-1-hsiangkao@linux.alibaba.com>
References: <20220126033726.15865-1-hsiangkao@linux.alibaba.com>
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
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Otherwise, when --extract is specified, it will report:
<W> erofs: erofsfsck_set_attributes() Line[189] failed to set times: (null)
<W> erofs: erofsfsck_set_attributes() Line[197] failed to set permissions: (null)
...

Fixes: 412c8f908132 ("erofs-utils: fsck: add --extract=X support to extract to path X")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fsck/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsck/main.c b/fsck/main.c
index f2af609..92e0c76 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -665,7 +665,7 @@ verify:
 		ret = erofs_iterate_dir(&ctx, true);
 	}
 
-	if (!ret)
+	if (!ret && fsckcfg.extract_path)
 		erofsfsck_set_attributes(&inode, fsckcfg.extract_path);
 
 out:
-- 
2.24.4

