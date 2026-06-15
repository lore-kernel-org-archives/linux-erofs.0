Return-Path: <linux-erofs+bounces-3592-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC95BCD98DE
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Jun 2026 08:40:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gf3V14w1dz3brl;
	Mon, 15 Jun 2026 18:40:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781512825;
	cv=none; b=k2lvM4fllLJWaB8ZJO0wertzs3UhR5JpuVUozxy3QXqV2Jl+cjJAN+nQ5p1ZgoSCndTXggI57jCcafggixsK5q0dMEsFc1fhP2bykdb/HhBz9jYAQCBRLF5e2wjVNhUuAo9WM6k1KVZ+YTxfO+Si1UMQJrRgeHgjvf9pzGTE46LN64D++W2BhsaN8HLndiaDyP/zOEnvTK4Ak3nfv56DbWQ3XP/euU0HmURczhQjjqAGhmw1juCcgwSO8cmNWYt3W4wW8Ml7ign0qGcvEAh8ewVAdQvLnNOv1x/nJgHddCqUU5qI8lwhEyCKHTBKwsgM2GBlaLnLLRYFW/EJg1HNsA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781512825; c=relaxed/relaxed;
	bh=8xg77bk+KPLHCMhyaz7bgwG/mSdV3dG0HDHULy16OgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jgdqjw3Yz0jRS7XtcS3XsCR3Kr+cyxdtLgSbXGAhhJusSX/otZgYsbk7bsCidRP2lbhBqhKlrQ4EwnVyiKMqz8T2bDRULX/cyXww7sYuzr1uNGTFg+TCJRGweb0511T5pGzREwP4dDXEEGR7cxPFAfsDV9AB5IXNuE+i5QBjqR8SFzcSHSjfyzh19KWbk6W3/S0wgtizP9pNLzfUadWIq8/vFZK9UbuEntqtqIW1oLESNeFbxglkTvtb4kzrVBsmVJVFhdVxBSjRVMi8Wa//NWRG0NGPU32MDzVAeYMoy1JTX2r/j5/nE/tHZoWad1v4y6czz0dq48vGZId+HtWF7A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Dk7HAV8Q; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Dk7HAV8Q;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gf3Tz3w78z2xnK
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Jun 2026 18:40:21 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781512817; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=8xg77bk+KPLHCMhyaz7bgwG/mSdV3dG0HDHULy16OgY=;
	b=Dk7HAV8QNvynw/+A6zO3WLDQkJVQ3Sw0lvII4O6pAJ7B8Q0+P+xucSOkQ6kNjbfQdn6rcipcd2mHVSD5YwPPUO+ecTxSR45lxMYqkLMjT0DgC3EOe5z27lZaMSuhcRHcPwgZHf5l+Rs9whJBvNBtNVUr0v5E5Zu2whqb3krctYs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X4s4IzQ_1781512811;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4s4IzQ_1781512811 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 16:40:15 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Tristan <TristanInSec@gmail.com>
Subject: [PATCH 1/3] erofs-utils: fsck: fix unsigned integer overflow in symlink extraction
Date: Mon, 15 Jun 2026 16:40:09 +0800
Message-ID: <20260615084011.325686-1-hsiangkao@linux.alibaba.com>
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

erofs_extract_symlink() allocates a buffer using malloc(i_size + 1)
where i_size is a 64-bit value read directly from the on-disk inode
with no upper bound validation. When i_size equals UINT64_MAX, the
addition wraps to zero, and malloc(0) returns a minimal allocation.
The subsequent erofs_pread() writes i_size bytes into this tiny
buffer.

Reported-by: Tristan <TristanInSec@gmail.com>
Closes: https://lore.kernel.org/r/CAA1XrhPMekMqAnRkC-jV9rTsO4LHjzh=kxn6zQKMgBrqfrnp8A@mail.gmail.com/5-symlink-integer-overflow.txt
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fsck/main.c          | 5 +++--
 include/erofs/defs.h | 9 +++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index 21ada195edab..f7f1387fe642 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -784,6 +784,7 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 {
 	struct erofs_vfile vf;
 	bool tryagain = true;
+	erofs_off_t bufsz;
 	int ret;
 	char *buf = NULL;
 
@@ -794,8 +795,8 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 	if (ret)
 		return ret;
 
-	buf = malloc(inode->i_size + 1);
-	if (!buf) {
+	if (check_add_overflow(inode->i_size, (erofs_off_t)1, &bufsz) ||
+	    (buf = malloc(bufsz))) {
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/include/erofs/defs.h b/include/erofs/defs.h
index 8151b76ad0f5..fabd867d159c 100644
--- a/include/erofs/defs.h
+++ b/include/erofs/defs.h
@@ -392,6 +392,15 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 #define __erofs_stringify_1(x...)	#x
 #define __erofs_stringify(x...)		__erofs_stringify_1(x)
 
+#define check_add_overflow(a, b, d) ({		\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_add_overflow(__a, __b, __d);	\
+})
+
 #define check_sub_overflow(a, b, d) ({		\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
-- 
2.43.5


