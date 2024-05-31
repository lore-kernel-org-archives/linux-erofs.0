Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FD6C25B75
	for <linux-erofs@archiver.kernel.org>; Fri, 31 May 2024 07:13:30 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ytt5hVCL;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VrDqX28nBz30VF
	for <linux-erofs@archiver.kernel.org>; Fri, 31 May 2024 17:13:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ytt5hVCL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VrDqP5Gk0z30TQ
	for <linux-erofs@lists.ozlabs.org>; Fri, 31 May 2024 17:13:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1717139595; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=WM3Rg1h0DrawDYVJN1u6ngtwfxcI8REMLabAot8GUQs=;
	b=ytt5hVCLU0V6b+Zppayo8UFE7ySV76SewTXArCCJme4CceR+FAD4X5caA3uA9j8GVpVDTBn0qGEGIc5gV1vpfysLZ28jBe6iKp25N5xpThbQWWRthrC3Q8yHaRu7vgrCl5DxvFE2Dzye+MMvdB83BvdOnM2q2abkqlX1ntTN1eQ=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W7Z34sw_1717139588;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W7Z34sw_1717139588)
          by smtp.aliyun-inc.com;
          Fri, 31 May 2024 15:13:13 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: lib: fix incorrect xattr sharing
Date: Fri, 31 May 2024 15:13:05 +0800
Message-Id: <20240531071305.1183728-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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

There are off-by-one issues after refactoring, and the size of kvbuf
should be calculated by EROFS_XATTR_KVSIZE instead.

Fixes: 5df285cf405d ("erofs-utils: lib: refactor extended attribute name prefixes")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/xattr.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index 427933f..0f6fbe2 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -166,14 +166,6 @@ static unsigned int BKDRHash(char *str, unsigned int len)
 	return hash;
 }
 
-static unsigned int xattr_item_hash(char *buf, unsigned int len[2],
-				    unsigned int hash[2])
-{
-	hash[0] = BKDRHash(buf, len[0]);	/* key */
-	hash[1] = BKDRHash(buf + len[0], len[1]);	/* value */
-	return hash[0] ^ hash[1];
-}
-
 static unsigned int put_xattritem(struct xattr_item *item)
 {
 	if (item->count > 1)
@@ -188,11 +180,13 @@ static struct xattr_item *get_xattritem(char *kvbuf, unsigned int len[2])
 	struct ea_type_node *tnode;
 	unsigned int hash[2], hkey;
 
-	hkey = xattr_item_hash(kvbuf, len, hash);
+	hash[0] = BKDRHash(kvbuf, len[0]);
+	hash[1] = BKDRHash(kvbuf + EROFS_XATTR_KSIZE(len), len[1]);
+	hkey = hash[0] ^ hash[1];
 	hash_for_each_possible(ea_hashtable, item, node, hkey) {
 		if (item->len[0] == len[0] && item->len[1] == len[1] &&
 		    item->hash[0] == hash[0] && item->hash[1] == hash[1] &&
-		    !memcmp(kvbuf, item->kvbuf, len[0] + len[1])) {
+		    !memcmp(kvbuf, item->kvbuf, EROFS_XATTR_KVSIZE(len))) {
 			free(kvbuf);
 			++item->count;
 			return item;
-- 
2.39.3

