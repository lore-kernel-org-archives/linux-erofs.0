Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4920CA0EDD
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Sep 2023 13:56:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RlQ963nhWz3dTG
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Sep 2023 23:56:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RlQ4102dQz3cPf
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 Sep 2023 23:51:43 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VrxAZjD_1694526695;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VrxAZjD_1694526695)
          by smtp.aliyun-inc.com;
          Tue, 12 Sep 2023 21:51:35 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 1/2] erofs-utils: lib: fix memleak in error path of erofs_build_shared_xattrs_from_path()
Date: Tue, 12 Sep 2023 21:51:33 +0800
Message-Id: <20230912135134.21307-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Free the allocated sorted_n[] buffer when error occurced.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 lib/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index d755760..54a6ae2 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -800,11 +800,14 @@ int erofs_build_shared_xattrs_from_path(struct erofs_sb_info *sbi, const char *p
 	qsort(sorted_n, shared_xattrs_count, sizeof(n), comp_shared_xattr_item);
 
 	buf = calloc(1, shared_xattrs_size);
-	if (!buf)
+	if (!buf) {
+		free(sorted_n);
 		return -ENOMEM;
+	}
 
 	bh = erofs_balloc(XATTR, shared_xattrs_size, 0, 0);
 	if (IS_ERR(bh)) {
+		free(sorted_n);
 		free(buf);
 		return PTR_ERR(bh);
 	}
-- 
2.19.1.6.gb485710b

