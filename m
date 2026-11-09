Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C456070E92
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Nov 2026 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=O7cIejj5
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jNM4q3vzMz2xGr;
	Mon, 09 Nov 2026 18:35:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=160.236.53.93
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794209707;
	cv=none; b=lMAMfmi2HKDfgbEYbT2UOYsoV6SSEg0vFzt7TnLO46o4xDx6VX5QCgOfsx7/S+Y8iKhKjVeUxIGVsKZ3vXHUzvUoni4qkX/OikYLNuf5BXZH8gd7s6k4adoHuK0IppeDIK1DsDzTRmEfekYAD16JwqMNXB4Q3nSdXuYBEOfhOumiYUNQOJRIoYf/3HU9BLrvb99BfX0fkePe8AY/VLjfOxkMye12/lj/ZWJcfv8HLxO+3q8EFoAHnMvIo9Ol2IQ5E4ZILD3/tBhHwumlPItev1zl//FgHM2w1+cJCUvWeN4/GgSAHrT3PMZAxFcNTIVYPegoFZwKZHzBwxLoNaSSPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794209707; c=relaxed/relaxed;
	bh=PY5p+/4XBWuEuBY0SH7Gh8DUxmvDYUR6wZWgxDcZ7Pw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=enZSp/lWnaMb3OsQtKpzNQZkUDWdJFXxncwjaPmltVtEQkqYBvl+jT+CQ/AAQ2TQpFLNelldC7ZVID+Q0nTpilcCgaT5Ij60Zom+gljc6oj7CZIW8qCC7JQ9pfEAHSdBg/lFIL4D6Ni+J/tmg1QsxwHkKILNrhCPSqDfiBpeQQvR0H0K+rBU2j7FKG3ghG4cgwCzd1EJ4mFZT/grx3JKTwmOeijtHt1INM3G+PO+ipR0pH/gzseYYeSI3ELazmxvChSxUQraCxq2wqStgwxHI/Z5zeLarXp6G9KHnCyndBjk7JoVKi10PRd0ZkoJ0Nxe7GvKbNMuC8s0Jold9+MmEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=O7cIejj5; dkim-atps=neutral; spf=pass (client-ip=160.236.53.93; helo=mail-m1602365393.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=O7cIejj5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=160.236.53.93; helo=mail-m1602365393.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m1602365393.xmail.ntesmail.com (mail-m1602365393.xmail.ntesmail.com [160.236.53.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jNM4j6mlBz2xGg
	for <linux-erofs@lists.ozlabs.org>; Mon, 09 Nov 2026 18:34:58 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.147])
	by smtp.qiye.163.com (Hmail) with ESMTP id 53fa869d5;
	Mon, 9 Nov 2026 15:34:51 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: build: enable libdeflate in static Docker image
Date: Mon,  9 Nov 2026 07:34:48 +0000
Message-ID: <20261109073448.3736205-1-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1bf3b335303a3kunm7bf0bd883f877f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSRhNVkkfSh9DH0tMTEkaQ1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKT0xZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=O7cIejj5rwhprcbGuzrNbUAgvRf0mUhbeCfDn+4YgmwTUs1ecqnauFRnWct+Rk677+EmJz3v3DbVkUXrttT/L2/EFov3wQ0rhvSlT6B1FACrtOCzPvFZambMsY9vZoi54ULSP6hzZOXwMNDH5mKwBzfwBI8wTrbrfDVCDPdLTao=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=PY5p+/4XBWuEuBY0SH7Gh8DUxmvDYUR6wZWgxDcZ7Pw=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Install the libdeflate development and static libraries and enable
--with-libdeflate so the static binaries include the libdeflate
compressor alongside the built-in deflate implementation.

Also strip the installed binaries.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 Dockerfile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Dockerfile b/Dockerfile
index 3c4e88b..13506ce 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -12,6 +12,7 @@ RUN apk add --no-cache \
     util-linux-dev util-linux-static \
     fuse3-dev fuse3-static \
     zlib-dev zlib-static \
+    libdeflate-dev libdeflate-static \
     lz4-dev lz4-static \
     openssl-dev openssl-libs-static \
     xz-dev xz-static \
@@ -39,12 +40,13 @@ RUN ./autogen.sh && \
         --enable-ublk \
         --with-json-c \
         --with-libcurl \
+        --with-libdeflate \
         --with-libnl3 \
         --with-libzstd \
         --with-libxml2 \
         --with-openssl \
         --with-uuid && \
-    make -j"$(nproc)" V=1 LDFLAGS="-all-static" && make install
+    make -j"$(nproc)" V=1 LDFLAGS="-all-static" && make install-strip
 
 FROM scratch
 COPY --from=builder /build/output .
-- 
2.43.0


