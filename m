Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A8606D802
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 13:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=C8nOCa4Z
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJqpR2xp1z2xN4;
	Wed, 04 Nov 2026 00:55:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::334"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793714127;
	cv=none; b=NwzIjX5ptmgTI6O+mjZDRhzpzNusTCFxUJd4JK6o2VGchGwUKWYj8/THWM+VpTvmd2R6JE9bF+Md7rennxE+YvNMbxfY1bmpVKa1hSD7emS/8pl4tzrGg9OqZ3dR1I7UP3s0JjiHQJfbfOsgSu9iAGqx9JQR80EFoKUEvNHHHcHBGzykAQc/S9nYXEA6do4nwLpzpsBy3nv1GUx1JtnL0oY9pEY1LeVe2A0Y4w8h+lBK4/AOPB9Aau24tkUwHmvoUgXC67+4r6sq4Y+sVkFxn7czvJYoY0GycAvbmwIkOQC2nhDB7Yd5XyRaAn549VoStptE41xdbXufBC4sAeg0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793714127; c=relaxed/relaxed;
	bh=sA7d83TPIURKpBQwIZf/Vd8TK1vj80wHKwjv//LmLbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fNFWWZ0Icz/8PbeaajVhtV94hV30lR3eSpusknae/NqQnMYX2wtOeGnxuPG67m2GKCxFbQhT/6HG5CmjMgZHP53cdycY6wYNno7ABjRLNg1+b1bXqdALqxvXCW3YMGW+DqSMAd3ZChboiftGn31NcQwA04jNZJJnpOg5RICN+pwTIJ2ZBbIdDFbPRU8DaNqi671yU2lDzmo3NZ2Mx0n23VcCZEf9etdsF6bW3EWfQqWgvtOyoyi3skq86eNcHeiJNGF1XcxwavM27EnQGjDoQxFX2OTWa/ryh3sAeH+XY9kt9GbNwqJ8swHrsxi6X4dWOsas8rmqU10MvxkFe9NxGw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=C8nOCa4Z; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=C8nOCa4Z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJqpP5Dvyz2xMQ
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 00:55:25 +1100 (AEDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so26701475e9.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 05:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1793714122; x=1794318922; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sA7d83TPIURKpBQwIZf/Vd8TK1vj80wHKwjv//LmLbI=;
        b=C8nOCa4Zj/oRyZdVMs4H2IyoAI5WT6Al8oFF8sBwfATx6pDfDoi+8k166h1ZpegHRD
         gEVZD0coex7OGsErHbBqtOcwZ5TtjEwKeZkGuDpcXV1ZmpX75bq9lwfkWg2s7zFArfHl
         DluFPm/jEmL1wVD/g0QFeF9LLUBI7aa1Uq93U8lvy/mXPp2FJXdmGTWphj0VWYJaEbMr
         Yt3izDZ0UxYmmD+yJTEpgnK48bUpqODCrH2UJpPtebBVeg6qhhWolITshi53JoZdnIN1
         1P0TMIT8kP7Sgws42sWIKdWEchh+Tpv3i2HG4OjqpWdKxnV6AGBhJJtW0sxA4NIP+9bx
         XSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714122; x=1794318922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sA7d83TPIURKpBQwIZf/Vd8TK1vj80wHKwjv//LmLbI=;
        b=mnvP+yWdlKnmawMfeIaXAJNuvsq+4IQ3SKuMexaG6JlfNEtps2RAbuHU+yTajV2UAu
         MlSsWw+gRMTPG+yd3f04qqd8z8kmet+8kVXiD34vZ0VyyKO65gC43xDJt2L6HrZqzQB9
         eO6WuRnKupLdtsvofes6Nwco+x6JYQireWthYxLAXE1WdzOoeEnd/KZxcY1ypPJ1ZzhV
         0EsIq0ycMQSoRAroNn6Cjf26Ms1dbchpG9CKW3UhadJy6ZfXP6r0MukIXk8FpeqXhgkK
         J9aPnwbgh7FH+hrC9WcS0ZfNPfsc/6E1JNher+0hrS4yhUa6dsvHu4yPUWzpCUZXp0+y
         6T4w==
X-Gm-Message-State: APuU4Z/iKYVIh6f9QwHorEBdfKetbhNuQ5ND2t6nq2dgWo2h4ofeSrHr
	v2UPo3+1h4UGKseySMEWm2O72Y2Zqp8lvLTmCOOpAG2L1WEnwxjqlnYbIzqPx96tntYaWTnMKD4
	bMi4Oc6Q=
X-Gm-Gg: AYBFou1JHuSdHjE2nK5UyGPFZL5ciUYKUoPMKJ4naOSVhr1qdetYLHf/38PeiIy5S6A
	E7GE/Vv1e6gf9DbpzdfxkhmjyeQ134CY/73UZucg0GR9xNbCR8Sz8qeVHvh1Xv7rOOqi35KRYwq
	7XFI+d/RYGvTjSa9hSCYpItVTtAUNGvEdUIUA2Uhqv+T0lB8+t+F2rSLeRE30GIhcJmK2Zii+Ca
	U/H71JI6msByyKer4dQFJ9L3eiUNeW5Quw690xIJh642mKe97LbxI+vmRXPz/wyqHNKV1kJmtX3
	OgcKvuYi9WClWFJILkvyFO5GG37Fbu59RuexVDGkYzh7KZskMRE3Xr07YsvyUzO8qrXLwDfNgPS
	xzjsiVNkX7VEvbjc2We4dnrvz7pIpF9ezGt2TF1wVLvsr+WZFRzpNU4/BeJgnZGyFW2N1YPE7w4
	GGCK1PGyPW7k8AFE00puazdFbs0ymKhlKJUK5moWr+oOAPvgrX6plqehgpbZomuWR4+S2kEN2RI
	VTNTlqT/EFB8CZz2VXvgjIf28JRDy39HA0s1MifdXeJQZKAywywuBe9R0qr5wTljmk0D+69SaDo
	4LR+O6d/0hQrpKkkCIdNVmkUkDCE2Z0wjLOkpaVOtPy9AwahwQ8=
X-Received: by 2002:a05:600c:138c:b0:4a1:f90d:6f4c with SMTP id 5b1f17b1804b1-4ac17ffaff2mr288386115e9.7.1793714122045;
        Tue, 03 Nov 2026 05:55:22 -0800 (PST)
Received: from localhost.localdomain ([2a02:8108:8388:6600:c9e:809a:89ec:9967])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a82cebdbsm65698565e9.3.2026.11.03.05.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:55:21 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH] erofs-utils: build: normalize line endings from Windows checkouts
Date: Tue,  3 Nov 2026 14:55:07 +0100
Message-ID: <20261103135507.2749-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.56.0.windows.4
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
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CRLF line endings leave a trailing carriage return in MSYS2 package
URLs, causing curl to reject them, and prevent shell scripts from
running correctly.

Use dos2unix on the dependency manifest before reading it and on text
build inputs before running Autotools in both build stages. Skip binary
files and Git metadata.

Fixes: e2d8dde04abf ("erofs-utils: add native Windows support")
Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 Dockerfile | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Dockerfile b/Dockerfile
index 2e9689d..dfedb97 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -13,6 +13,7 @@ RUN apk add --no-cache \
     libtool \
     pkgconfig \
     git \
+    dos2unix \
     util-linux-dev util-linux-static \
     fuse3-dev fuse3-static \
     zlib-dev zlib-static \
@@ -30,7 +31,9 @@ RUN apk add --no-cache \
 WORKDIR /build
 COPY . .
 
-RUN ./autogen.sh && \
+# Normalize text inputs from Windows checkouts; dos2unix skips binary files.
+RUN find . -type f ! -path './.git/*' -exec dos2unix -q {} + && \
+    ./autogen.sh && \
     PKG_CONFIG="pkg-config --static" LDFLAGS="-static -no-pie" ./configure --enable-static --disable-shared \
         --prefix=$(pwd)/output \
         --enable-multithreading \
@@ -56,7 +59,7 @@ FROM --platform=${MINGW_BUILD_PLATFORM} alpine:3.24.1 AS windows-builder
 
 RUN apk add --no-cache \
     build-base autoconf automake libtool pkgconf git \
-    ca-certificates curl tar zstd mingw-w64-gcc
+    ca-certificates curl tar zstd dos2unix mingw-w64-gcc
 
 ENV MINGW_TARGET=x86_64-w64-mingw32 MINGW_PREFIX=/ucrt64
 ENV CC=${MINGW_TARGET}-gcc \
@@ -69,7 +72,8 @@ ENV CC=${MINGW_TARGET}-gcc \
 ARG MSYS2_MIRROR=https://repo.msys2.org/mingw/ucrt64
 WORKDIR /deps
 COPY scripts/msys2-ucrt64.sha256 .
-RUN while read -r checksum package; do \
+RUN dos2unix -q msys2-ucrt64.sha256 && \
+    while read -r checksum package; do \
         curl -fLsS -o "$package" "${MSYS2_MIRROR}/$package" && \
         echo "$checksum  $package" | sha256sum -c - && \
         tar --zstd -xf "$package" -C / ucrt64 || exit 1; \
@@ -81,7 +85,9 @@ ENV PKG_CONFIG_LIBDIR=${MINGW_PREFIX}/lib/pkgconfig PKG_CONFIG_PATH=""
 
 WORKDIR /build
 COPY . .
-RUN ./autogen.sh && mkdir build-windows && cd build-windows && \
+# Normalize text inputs from Windows checkouts; dos2unix skips binary files.
+RUN find . -type f ! -path './.git/*' -exec dos2unix -q {} + && \
+    ./autogen.sh && mkdir build-windows && cd build-windows && \
     PKG_CONFIG="pkg-config --static" \
     CPPFLAGS="-I${MINGW_PREFIX}/include -I${MINGW_PREFIX}/include/tre" \
     LDFLAGS="-static -L${MINGW_PREFIX}/lib" \
-- 
2.56.0.windows.4


