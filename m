Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 495DFC433F5
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Dec 2021 17:50:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JD5W047Ylz306m
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Dec 2021 04:50:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1639504204;
	bh=u42eR9OFzA51l055hO0zbCUnUazXZUY4AyVngnjlr2U=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=LfYy/7ST9y68nppTd6TntD7iJXTrgCRkjdZWReYhyZvgpK8mxPlxs2G8JxJCl7UyI
	 XkmQJR4Agj6/ILu5sDPoT1kjy/fpmMFI1PL7xC/pDU4Bs1V2TM8k2twBVGxaJoIC9k
	 A60sghmYtGaskpBbRK2p2N4lRa9UvMMw1MB67YgQt0A4b58UYC0sTrVDrwx0pusqmH
	 o0bQWJRGn5juo5ya6u6iso+6sWULquNadRpzv5b510N8qlvKYd1BB9AjMCuTLPWCkj
	 F19b836dPWQgewoD7BrWlB9tTdJUjjbaYZn3itNMkUDNHz65RwJ+nJkPr/gGMpcfDN
	 TYWmjjXaSvzFQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=flex--zhangkelvin.bounces.google.com
 (client-ip=2607:f8b0:4864:20::f49; helo=mail-qv1-xf49.google.com;
 envelope-from=3q9m4yqskc-wnvobuyszjwbuccuzs.qcazwbil-sfctgzwghg.cnzopg.cfu@flex--zhangkelvin.bounces.google.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256
 header.s=20210112 header.b=tSQHHKLE; dkim-atps=neutral
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com
 [IPv6:2607:f8b0:4864:20::f49])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JD5Vw6ytMz2yK3
 for <linux-erofs@lists.ozlabs.org>; Wed, 15 Dec 2021 04:49:58 +1100 (AEDT)
Received: by mail-qv1-xf49.google.com with SMTP id
 jn10-20020ad45dea000000b003bd74c93df4so27861595qvb.15
 for <linux-erofs@lists.ozlabs.org>; Tue, 14 Dec 2021 09:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=u42eR9OFzA51l055hO0zbCUnUazXZUY4AyVngnjlr2U=;
 b=rVzL+FUiB4aVZZuALfrH6QWIGqd/vOs7vDRfXF16jn6udzm+o6hkN/N2H780S2VWe9
 c5CPsxMR8TXG6nh6NnM6MFTxT3tHQvfIQ5Mihao+2VDHmOUUQdGFLmE3BlSXkVLVnRfy
 hEVBIozOf0yrCb9yY7DXAuNhGRJaSM//Uvu4LqXiVzhbEtzaFhnbQwaPrI5xD7PWpubG
 mwD1fwo+sqBk0rPwwjxM/S7bcQ57O/64ZRoBrb+I7wN/uFiSN40Z6PjJHkHsJzDnLCwf
 fBun2uofbwppPbJ7+uZHB8oxAnFI4uMVUGrZVwqmLTyM+R7O/nUp9BqDFnP/0EO3DkIV
 b3TA==
X-Gm-Message-State: AOAM531SOwBAAQrPQx8CGSa2m9x2IM0dXak4TKvygvuW00WbOTLIj05I
 Qaf24+B9dBfuTkbp1UTor3dkh6is751oJWkoTztWzNPUlhz0aC7sNH0FgxvLrvSztpWVgtvv4Gn
 Z4H7zCTufGwbFCKQybvRhN6JNorpBMezKRxKrhJaWIsaOLjdeZwro+tNvja/Oqkm+wk/sFofc0L
 d5unGGu0c=
X-Google-Smtp-Source: ABdhPJzMcZLbnNsVqZHnVmnNrSVO7TgFKGpZ4Nzt76TpgU6fJy8rnGCMJbM+wOOuHFHdmHA6RnjAzYruXVhl96Vksw==
X-Received: from zhangkelvin-big.c.googlers.com
 ([fda3:e722:ac3:cc00:14:4d90:c0a8:1f4a])
 (user=zhangkelvin job=sendgmr) by 2002:a05:622a:1901:: with SMTP id
 w1mr7665480qtc.632.1639504195420; Tue, 14 Dec 2021 09:49:55 -0800 (PST)
Date: Tue, 14 Dec 2021 09:49:53 -0800
Message-Id: <20211214174953.1947261-1-zhangkelvin@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1] Mark some compressor parameters as const
To: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
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
From: Kelvin Zhang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Kelvin Zhang <zhangkelvin@google.com>
Cc: Kelvin Zhang <zhangkelvin@google.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Change-Id: Ieba9eeca9028766826dbd404aba63f3cb5936eb8
Signed-off-by: Kelvin Zhang <zhangkelvin@google.com>
---
 lib/compressor.c         | 4 ++--
 lib/compressor.h         | 8 ++++----
 lib/compressor_liblzma.c | 4 ++--
 lib/compressor_lz4.c     | 4 ++--
 lib/compressor_lz4hc.c   | 4 ++--
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/compressor.c b/lib/compressor.c
index ad12cdf..eaf402a 100644
--- a/lib/compressor.c
+++ b/lib/compressor.c
@@ -22,8 +22,8 @@ static struct erofs_compressor *compressors[] = {
 #endif
 };
 
-int erofs_compress_destsize(struct erofs_compress *c,
-			    void *src, unsigned int *srcsize,
+int erofs_compress_destsize(const struct erofs_compress *c,
+			    const void *src, unsigned int *srcsize,
 			    void *dst, unsigned int dstsize)
 {
 	unsigned int uncompressed_size;
diff --git a/lib/compressor.h b/lib/compressor.h
index aa85ae0..ed7edee 100644
--- a/lib/compressor.h
+++ b/lib/compressor.h
@@ -21,8 +21,8 @@ struct erofs_compressor {
 	int (*exit)(struct erofs_compress *c);
 	int (*setlevel)(struct erofs_compress *c, int compression_level);
 
-	int (*compress_destsize)(struct erofs_compress *c,
-				 void *src, unsigned int *srcsize,
+	int (*compress_destsize)(const struct erofs_compress *c,
+				 const void *src, unsigned int *srcsize,
 				 void *dst, unsigned int dstsize);
 };
 
@@ -45,8 +45,8 @@ extern struct erofs_compressor erofs_compressor_lz4;
 extern struct erofs_compressor erofs_compressor_lz4hc;
 extern struct erofs_compressor erofs_compressor_lzma;
 
-int erofs_compress_destsize(struct erofs_compress *c,
-			    void *src, unsigned int *srcsize,
+int erofs_compress_destsize(const struct erofs_compress *c,
+			    const void *src, unsigned int *srcsize,
 			    void *dst, unsigned int dstsize);
 
 int erofs_compressor_setlevel(struct erofs_compress *c, int compression_level);
diff --git a/lib/compressor_liblzma.c b/lib/compressor_liblzma.c
index 40a05ef..637dfe4 100644
--- a/lib/compressor_liblzma.c
+++ b/lib/compressor_liblzma.c
@@ -18,8 +18,8 @@ struct erofs_liblzma_context {
 	lzma_stream strm;
 };
 
-static int erofs_liblzma_compress_destsize(struct erofs_compress *c,
-					   void *src, unsigned int *srcsize,
+static int erofs_liblzma_compress_destsize(const struct erofs_compress *c,
+					   const void *src, unsigned int *srcsize,
 					   void *dst, unsigned int dstsize)
 {
 	struct erofs_liblzma_context *ctx = c->private_data;
diff --git a/lib/compressor_lz4.c b/lib/compressor_lz4.c
index f6832be..4ebc758 100644
--- a/lib/compressor_lz4.c
+++ b/lib/compressor_lz4.c
@@ -12,8 +12,8 @@
 #define LZ4_DISTANCE_MAX 65535	/* set to maximum value by default */
 #endif
 
-static int lz4_compress_destsize(struct erofs_compress *c,
-				 void *src, unsigned int *srcsize,
+static int lz4_compress_destsize(const struct erofs_compress *c,
+				 const void *src, unsigned int *srcsize,
 				 void *dst, unsigned int dstsize)
 {
 	int srcSize = (int)*srcsize;
diff --git a/lib/compressor_lz4hc.c b/lib/compressor_lz4hc.c
index fd801ab..7ddb253 100644
--- a/lib/compressor_lz4hc.c
+++ b/lib/compressor_lz4hc.c
@@ -13,8 +13,8 @@
 #define LZ4_DISTANCE_MAX 65535	/* set to maximum value by default */
 #endif
 
-static int lz4hc_compress_destsize(struct erofs_compress *c,
-				   void *src, unsigned int *srcsize,
+static int lz4hc_compress_destsize(const struct erofs_compress *c,
+				   const void *src, unsigned int *srcsize,
 				   void *dst, unsigned int dstsize)
 {
 	int srcSize = (int)*srcsize;
-- 
2.34.1.173.g76aa8bc2d0-goog

