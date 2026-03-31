Return-Path: <linux-erofs+bounces-3140-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BB8FF60DC
	for <linux-erofs@archiver.kernel.org>; Tue, 31 Mar 2026 07:51:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4flL0b5ZRFz2xnZ;
	Tue, 31 Mar 2026 18:51:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774943487;
	cv=none; b=hfDMQg4clHmvnIwwApkbJd95cgc8CKaTH6btITsXqnWQSs1ak7bpdqedkHAROr6Of44OHjiJzSEfrWKPwbHsVD38JiMxYOaSmgFn3FejKbRqcKxwQVrVMebDxDaMJNN9isbsvNCNmPVUYa91TPYZTwe7wbrrPzxuLEi+te5d6fbPjEf1ddAzBVKWW0DEnznT5Y44Dsqo2qFMZVeVZp4LiUL7etqUY1i2UU89ws4UEgJToxX1di4xg/lZsUoH2AN/iiSGLhsP63Av0tCZ2xjdIMpMkN5lcPb3MwSFERqmUeKmyKse90g9lPje7q1Rqlkns7MZGXE+YbLxp11o1uLn4w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774943487; c=relaxed/relaxed;
	bh=runFf+jfsNjOnBJag06Ahzvb4/YkJSX3w8pB7bW3jYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klbOGhTXu9XS43XT5/US38HkHpt1tbnsXPKT9kfFcKZS22z5EbRlRVbtISkgadsZk4CO0IFWSchNJfauYdHEgHfgJgxqe6k0ViNX0rtvpjw4QM/LCjQinrn0mrAmb9twE43OKKrWbn8KvEE7Nuinjgg2TacINYw6sM32USoJVmIF2Ogp+2LI5EulKDec01xTCteLiVLZbxx1ldkhmseZVxQO0ReP7MqDFJT5Z3qDIjQCosHWZ0SWjA5P+0FRGgxbxUobwQ3AtMf0m9gx/0eyFnhNOnvm1m/Qx/J9xfrZiSAjwqR2bZDT1KvRIH8pRS9KjONALX4OkzrJvyZaWNLUpg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Zr3UF6kk; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Zr3UF6kk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4flL0Y6fP7z2xSb
	for <linux-erofs@lists.ozlabs.org>; Tue, 31 Mar 2026 18:51:24 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774943479; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=runFf+jfsNjOnBJag06Ahzvb4/YkJSX3w8pB7bW3jYs=;
	b=Zr3UF6kkylQfVh1TLBl/Ty6bdt4u5uLhsBIItlrudx5sAmQ4ERDS8n0vJpTDtSI9+HbJC2zZItrymg2WfcxKSRwKTodMBO8AS9BwoS+wYC+qYN0C1mksVvkTya5iOBvqGA+SF+OWUcyFih1mBnR0aINYmhXmvOnjp8/RjN+9urw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X03faBl_1774943475;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X03faBl_1774943475 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 15:51:18 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Vansh Choudhary <ch@vnsh.in>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v2] erofs-utils: tar: handle gzread errors
Date: Tue, 31 Mar 2026 15:51:14 +0800
Message-ID: <20260331075114.1015683-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260330180958.1372245-1-ch@vnsh.in>
References: <20260330180958.1372245-1-ch@vnsh.in>
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

From: Vansh Choudhary <ch@vnsh.in>

Treat gzread() errors as I/O failures before updating the stream
buffer state.

Without that, a negative gzread() result could underflow ios->tail
and leave the reader in a corrupted state.

Signed-off-by: Vansh Choudhary <ch@vnsh.in>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
v2:
 - some cleanups.

I will apply this one.

 lib/tar.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/tar.c b/lib/tar.c
index eca29f54c06f..0fe9853dfb16 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -170,16 +170,17 @@ int erofs_iostream_read(struct erofs_iostream *ios, void **buf, u64 bytes)
 #if defined(HAVE_ZLIB)
 			ret = gzread(ios->handler, ios->buffer + rabytes,
 				     ios->bufsize - rabytes);
-			if (!ret) {
-				int errnum;
+			if (ret <= 0) {
 				const char *errstr;
+				int errnum;
 
 				errstr = gzerror(ios->handler, &errnum);
-				if (errnum != Z_STREAM_END) {
+				if (!ret && errnum == Z_STREAM_END) {
+					ios->feof = true;
+				} else {
 					erofs_err("failed to gzread: %s", errstr);
 					return -EIO;
 				}
-				ios->feof = true;
 			}
 			ios->tail += ret;
 #else
-- 
2.43.5


