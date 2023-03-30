Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304C9C761AF
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Mar 2023 08:29:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PnGms5000z3cMr
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Mar 2023 19:29:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PnGmZ2YPXz3c8T
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Mar 2023 19:29:18 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Vezpke1_1680164953;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0Vezpke1_1680164953)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 16:29:14 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	huyue2@coolpad.com,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 3/8] erofs: simplify erofs_xattr_generic_get()
Date: Thu, 30 Mar 2023 16:29:05 +0800
Message-Id: <20230330082910.125374-4-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230330082910.125374-1-jefflexu@linux.alibaba.com>
References: <20230330082910.125374-1-jefflexu@linux.alibaba.com>
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
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

erofs_xattr_generic_get() won't be called from xattr handlers other than
user/trusted/security xattr handler, and thus there's no need of extra
checking.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/xattr.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index dc36a0c0919c..d76b74ece2e5 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -432,20 +432,9 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
 				   struct dentry *unused, struct inode *inode,
 				   const char *name, void *buffer, size_t size)
 {
-	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
-
-	switch (handler->flags) {
-	case EROFS_XATTR_INDEX_USER:
-		if (!test_opt(&sbi->opt, XATTR_USER))
-			return -EOPNOTSUPP;
-		break;
-	case EROFS_XATTR_INDEX_TRUSTED:
-		break;
-	case EROFS_XATTR_INDEX_SECURITY:
-		break;
-	default:
-		return -EINVAL;
-	}
+	if (handler->flags == EROFS_XATTR_INDEX_USER &&
+	    !test_opt(&EROFS_I_SB(inode)->opt, XATTR_USER))
+		return -EOPNOTSUPP;
 
 	return erofs_getxattr(inode, handler->flags, name, buffer, size);
 }
-- 
2.19.1.6.gb485710b

