Return-Path: <linux-erofs+bounces-3892-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282EDC44501
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jul 2026 05:56:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gzpSw0qpxz2y71;
	Tue, 14 Jul 2026 15:56:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784008560;
	cv=none; b=n/SSeLxPtLoWatGNb/Bgi4JquNSeGZIu9wjJu4HCK9dt90+pJF7e928KvSyv+yP7r8t0/jVkedMRDlNJnRhc0r3oF+YGS8ycl70ybxJxB0V9iPKoBzDm4rr+4ifk9Vd5HshfcbUQf1bR/XZ+8zqh38TLHy0WE0v12X5mISkbeORkCS2MHH9AGx2vKqe6xtyzLjaf2GY2+gc8k5Z7DebqtaUxsqfeTNiydjG7NJcg8WcMKUXVateGaN0oVROMUMHpL3th2EcZYPAZldyMQz+GcWPVNEBmeaWJb00KYSwsiUJNL7qqmoKtiRbjiz0JyIFgZeVIDRmj9Dhwy+5ImuknIg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784008560; c=relaxed/relaxed;
	bh=mHn6JG6x/AJt0TgwaMB9zfWK9GHqrvRmWx19wvuNMGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DXQtlgNB575fH3N8JgtK7+Mgdv4yEwWs+MCetMvEvhRIpQddhGwh1FpcKrpe1JOkzV1ynz53CbiEmWYz+dNpvrqmz/x99orGxvbvZWnTMGNQXRyicnQrN773p87NeFkDIMu7aAN/jVM/akUSMxHSjxiGjyuL8brf1/4HYa6PQ2Mi11ZIhW1yHD/7SH6u3LwaU+g8Ij2i6XmZxcTODtgmhbU+hsWg+SHtypo5eYMkJHPCBcSeYAWLOPZhPexJRTfB3hvsik/PqAh3Ap0kRKVzc4YoPcgfSa3fRv3Ya4wDV8hkP9YUDHGRy1lH8Bngu20kU32LT2sx0q763q29l04ecQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d2pV2EXi; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d2pV2EXi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gzpSs3YZnz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 14 Jul 2026 15:55:56 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784008551; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=mHn6JG6x/AJt0TgwaMB9zfWK9GHqrvRmWx19wvuNMGU=;
	b=d2pV2EXi+FWG82rDNjU38ZnuqlPKqrBD4uM4AKYZA1zla1KWr6+danGEGmFWWmaoltIKeCeueZZcP0fbYjMVcpaIq+YiDwfi2ImDvwM48mSly+B8xwT9S1sH/m/jwCSMgKzgS72ddDBwfR5FK5b7W0mc6CCatLHoMkSGDqxsbhg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X731r9r_1784008545;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X731r9r_1784008545 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 13:55:50 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: lib: fix undeclared gettid()
Date: Tue, 14 Jul 2026 13:55:44 +0800
Message-ID: <20260714055544.742154-1-hsiangkao@linux.alibaba.com>
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

gettid() is only available since glibc 2.30.

Fixes: 799c933bbefb ("erofs-utils: add ublk userspace block device backend")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 configure.ac        | 1 +
 lib/backends/ublk.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index ddee374b6e85..25a48922c1dc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -284,6 +284,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	fallocate
 	getrandom
 	getrlimit
+	gettid
 	gettimeofday
 	lgetxattr
 	llistxattr
diff --git a/lib/backends/ublk.c b/lib/backends/ublk.c
index b63d121e54ac..d2c5e1968014 100644
--- a/lib/backends/ublk.c
+++ b/lib/backends/ublk.c
@@ -29,6 +29,11 @@
 #include <liburing.h>
 #endif
 
+#ifndef HAVE_GETTID
+#include <sys/syscall.h>
+#define gettid() syscall(__NR_gettid)
+#endif
+
 /* (Legacy) Admin commands, issued by ublk server, and handled by ublk driver */
 #define UBLK_CMD_GET_QUEUE_AFFINITY	0x01
 #define UBLK_CMD_GET_DEV_INFO		0x02
-- 
2.43.5


