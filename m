Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759B606A32A
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=BBz9asoL
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXcdN22R5z2xwN;
	Mon, 23 Nov 2026 05:13:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::331"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795371208;
	cv=none; b=Gz3aj9zGqqwhzHyf4Df/geYJpq4hk4BMgIjMjKL2xmFpi/h6SWYulahuanU0L0UrPPI2POV8rkqf/6Lxsk4plNRqEv1gEvy5GIq1wZPE73Hf8dDLRI2B3CwpBlicxn+3C2acIlDFriQ7lxMrNxAZnTNXNcWlHP2F42RSHxB/UkAIxJlbzN48jKf0ZggnKrxmcNKifEiwhCnG9i7owHziyu7pMjz4+U/+rDDadPYfqpefir7KMY+UpBXEwqokbM+maATFaSVaS1okpcwsO0iMRL0QxtIzTViCt5m7ZeP5xIJxkC3KhsmswqH6EZS6GW2+BzC8flLUJPZCokdvF7T7EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795371208; c=relaxed/relaxed;
	bh=hSkRV3MHq4HwJ5BAKNJrdxnOtVo4kBI+g7Bfc94V5aM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jiyjvh07hrdSuYFwdfyntsqooTAARdfih6EZGfA5x73FUYdqdRHnIpJYsRya415+ZeecvLoSLyHUWK4vAMkOhdVAFCFShKWloYO2uKWMgvVbC9ON8oixn6U0O7M/Ov0j8zlTIK8LUSZK7QL9rFSJoy255wqcTtk7it7u1PBqL+DjYyeQf0e4VjgS2I9jznugboGykykghKQ8cV7r7yWhEK6TUrV5Xx6cEi1byK5zQKsSF0EvAvE28tewRc8WUQpWUuDeELKSgo+aOFGJw1bFY1j4TD65q7bdJxyRQsNgFLD71BsqohWOnMRanUnhrw1aArOAYX1dqRoVOA9/gtGhxg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=BBz9asoL; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=BBz9asoL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXcdL3jpbz2x99
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Nov 2026 05:13:25 +1100 (AEDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so22804005e9.2
        for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 10:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795371200; x=1795976000; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hSkRV3MHq4HwJ5BAKNJrdxnOtVo4kBI+g7Bfc94V5aM=;
        b=BBz9asoLRHiWO3qSIQdtRM10yfXqXtFf6JB6I8CSGWUT9VMpBEpBevfpI4EUD8FX7z
         QipFHlY6X0ne93PlcgG9wxoEOJd7rXqPEni4QzwnQCEtpfT3qnWxE8815L2C2PwJiTwd
         Cr4s5U0XdVTky5aVKR4p6uLixRPWaVZc4I3I3bo6E6AgjT7XZWjGR/dBEPfUoVCDvtDW
         GKzfiHjCSl2yXe5mSDUYKRLjwTuRBGZHZeyVyomGpLWgdr5UQ7/mzWTgdcUwjcaRLYi7
         K4udURYoz0YrLKsQEOpW/1jR8xoKMnJMG3huQ1R58J429GxfGKUSbRvCnUmmQqv/loHZ
         NM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795371200; x=1795976000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hSkRV3MHq4HwJ5BAKNJrdxnOtVo4kBI+g7Bfc94V5aM=;
        b=gPfE9KPI7y/hXld0dXgV1DEfCinjy+wfks+2G/eZyvcNLwr/bKxzjmKUbQo0af5FWd
         Q+XBZXryo8jODtGllsrnIoHBzcjFR5+ocZOoE3VN+l3Du4huedk3NaaVLIIKC6vq/S75
         6LBFDTzAOR5Mq/B/ZWuHxABr7t5saKsFWe6wiT/iYJQD6LI9EepxSYbW8PacFSYRSbQK
         v4S9Am7KKZyd9G3Ajucop1aD2ir23cjwdytTNtPzt+kniKZ8gXlVV7ZDGk4npYrfmNS9
         1xQoNjow6/P6q6BQzRuTPFYzj0u8z8HjNQF1SnoSvPPIUAcY97Zdm6OpY3DsntncaeC0
         uKHQ==
X-Gm-Message-State: APuU4Z+Sk1K5XGL08ROu/Egs6C5iC0Cn64WpzQoRAsz6EujH3D5Qvuzk
	08oCa/4SypoAXlKxXv6QgH9p1iz40ATRJLBnHATTI3Om3QaPi0Od5frPsoTcZTEmKCC+KdAqpzo
	SdIQrVj0=
X-Gm-Gg: AZFdTZewZ4LHnvmzPsXFgT6R2v9Eug3MO1gh5hVBX5pwqIYb2rloHN3bt3To6AukmYt
	i1sIbP8Pn6zMS/ClevWL7cf2OYHYwUERRjyzJxovDHXAyZxoGhoIFcwOogyMkL9EMhlZctFaCve
	tIITcWLVUPALu2nxdyWDbg+4zRu+RhTdUmbWx1/gkTeFDd4zuAzyf2FnLPjMAVU5FoP5Vx9fsQp
	GRP+ZY6yLTgVxjATu2uDs8i2gG08msZ5+XvMpQz4eElFZK8U0ppAiRzK7FImM3gNiyR+doVma88
	nYO2QLTLHaSPfurZ4z1cqZE4Wpj4Zd4cBhjIrCTRo937FB33MJdoswt5YzduApiE0QgOTUgkZlY
	aMLmL40igWRgStRZu4lLmlggU7eXOZVcRnfHtN4qw9HOeCICo4KG6JxPEa24rlc8r1reHPFXHr5
	0rDmm1/dWSJUhqPA3OkMalU2Ld9NUFc3UPEqIhf/1QfS6in7B8TpK5X5cD4t2Pq7Cr4RypxZm2C
	1rU8dew6R4iSMEN5P8Zgv/Luryz6/PXw7zWbHERaMvrpx05eR/9QRL6sZ6StnpELhMDwYVgyvUi
	IJuCM7Ra2WV0bwcQrTbwIt1/lvEjyvrpSyMCWQ/q2fhxF6JyKVdlaXn74g6m9w==
X-Received: by 2002:a05:600c:46cc:b0:4bb:69b3:2b42 with SMTP id 5b1f17b1804b1-4bb888277b3mr202054675e9.16.1795371200179;
        Sun, 22 Nov 2026 10:13:20 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5888:55e8:d901:aec])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8d4f9aa8sm233373495e9.4.2026.11.22.10.13.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 10:13:19 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH] erofs-utils: add Windows binaries to release artifacts
Date: Sun, 22 Nov 2026 19:13:15 +0100
Message-ID: <20261122181315.45388-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Build static Windows amd64 binaries with the Dockerfile's windows
target and include the resulting archive in draft releases.

Also select the linux target explicitly for Linux builds.

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 .github/workflows/release.yml | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/.github/workflows/release.yml b/.github/workflows/release.yml
index 8b6f0ab..b8ffa39 100644
--- a/.github/workflows/release.yml
+++ b/.github/workflows/release.yml
@@ -48,7 +48,32 @@ jobs:
         run: |
           VERSION=${{ needs.getvers.outputs.string }}-linux-${{ matrix.arch }}
           echo "VERS_OSARCH=${VERSION}" >> $GITHUB_ENV
-          docker build -o - . | xz -e9 > erofs-utils-static-${VERSION}.tar.xz
+          docker build --target linux -o - . | xz -e9 > erofs-utils-static-${VERSION}.tar.xz
+
+      - name: Upload release artifact
+        uses: actions/upload-artifact@v7
+        with:
+          name: erofs-utils-static-${{ env.VERS_OSARCH }}
+          path: erofs-utils-static-${{ env.VERS_OSARCH }}.tar.xz
+          archive: false
+
+  windows-static-build:
+    name: Static binaries for windows/amd64
+    runs-on: ubuntu-latest
+    needs: [getvers]
+    steps:
+      - name: Checkout
+        uses: actions/checkout@v7
+
+      - name: Set up Docker Buildx
+        uses: docker/setup-buildx-action@v4
+
+      - name: Build static release
+        id: rel
+        run: |
+          VERSION=${{ needs.getvers.outputs.string }}-windows-amd64
+          echo "VERS_OSARCH=${VERSION}" >> $GITHUB_ENV
+          docker build --target windows -o - . | xz -e9 > erofs-utils-static-${VERSION}.tar.xz
 
       - name: Upload release artifact
         uses: actions/upload-artifact@v7
@@ -63,7 +88,7 @@ jobs:
     runs-on: ubuntu-latest
     permissions:
       contents: write
-    needs: [getvers, linux-static-build]
+    needs: [getvers, linux-static-build, windows-static-build]
     steps:
       - name: Download release artifacts
         uses: actions/download-artifact@v8
-- 
2.54.0 (Apple Git-157)


