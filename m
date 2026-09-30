Return-Path: <linux-erofs+bounces-4639-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCE1CA5FBA
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 11:21:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvt0c724qz2yjN;
	Wed, 30 Sep 2026 21:21:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::29"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790767296;
	cv=none; b=WcisPlrD5e+DsknCkWRQlq+pPaxDPoOTNvlGQ3rp29wJZNiRxQYJNLlvAqTX5ChxQkNP4qEY+UIBK0cFh914DPezyZN61AzExI+xc2YD21n68154+SQMGfaGCVvZcHckN9gr7DgEuqBgNlOiiIJviut+nLaOIZhfFH3Zup+9DIJR4yO3e2pJ559E5QEVBO8SlZBbm6ehWHVYOxy9TKXc6pZGgJX7nSZhof+upIWHckBvSty2fyUV18OFTUB/01UqRPaTYU5sOkuMqxnug8Z8MTejcGJmaT0CJNgVvYpK2VkpfgVR48VZSr6vhdEvq0vQlLzrSXplozKXHvSdKNnI5w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790767296; c=relaxed/relaxed;
	bh=PfoRY3WgOFVsoBc2PGlUbg76fc6RUwYrOcpdYt4Z5U4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ifIDXuN1rXL2q4lZOPwj7VsfJ/GG1IhbTMn/E6hJHMMIZTtth2JRWkeuxlF782WxQWTLt3t09Xb91eRBGzyLHMEZrJX07KUtNafSuDYcAaB3/SKid0p7Rro5ia9+7hYRFNMTKUtiXSCFN4FI5hWBX8EEMsIiGvF3AQUSGqHYbLFGCNfwrX4ickk4ffASEkJ4B+yOFowxCogNqZfENEKH0YH57S5NIUv4VpzD0oLQv69GWKtVFBhndgRMIJeZh+zx+S5Bca9PO9H2icdhT+cCwd7O24QKFtSDjsX1xhyQ/2huf1pxqEP+eGeo8U6IUCfO2SL98Fes48WzFhlp96eeoA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=psvBa7F1; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::29; helo=mail-pz2-x29.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=psvBa7F1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::29; helo=mail-pz2-x29.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x29.google.com (mail-pz2-x29.google.com [IPv6:2607:f8b0:4864:3b::29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvt0c1vW9z2xmh
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 21:21:36 +1000 (AEST)
Received: by mail-pz2-x29.google.com with SMTP id 41be03b00d2f7-cc7d7111700so241720a12.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 04:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790767294; x=1791372094; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PfoRY3WgOFVsoBc2PGlUbg76fc6RUwYrOcpdYt4Z5U4=;
        b=psvBa7F13+FMlqkQ2O3I7w8eOcmfgPou9ZK1bJzjm9J3mGf9+J1j57UfhIWEHbu3Ix
         vnraWtnLfrBtjFKiyfLO9+xQZTHB+pfS5U7iAEP0dEfQIreEhX/hiphWID3qFvJhu2nX
         L1Q+RsCHUy9IaTZsPMAEGXNeTa8GcwRuGP1uJudaWz25M4pSMkAes3OsZkyUqfxtHaxa
         SEHAvl+GJ2TFFqAHa8hkjJmrAJlhhGFZHwhrimDerrjHk2Ds9AC1XU8QnOkYmznMlkuD
         x7Tga0PIELGTXu/Rs5Q8NWz+FJ0XOBxg0TTfeVfMQGkhR6F34yIXHYmyjFaq9p580CYO
         cZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767294; x=1791372094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PfoRY3WgOFVsoBc2PGlUbg76fc6RUwYrOcpdYt4Z5U4=;
        b=Idl4bjs9uq2iX7Op9qXxW/dPSPwMPCSfsf+KLz8DTl5xSjJRFyxKwbC3b0nZADs4tE
         t+JhC8eOvaNo8/6YC5hIfNVmV8mYfvrl/UzTQ7P7IlFNGIc+vCLXByN6YFeWC1otlG9o
         OKR3R2/gsiiN1FjX9ZA+sm1joFCuWf/FdOUCAUZ39bM4EUgYa3/F5vOCD7948j9McjQP
         kjPZEylifUnV/1thZE1FgY327L9rVh2TMVjQIhr98N4Y8fMV5xzoefdMBxn8QXCrbrQj
         jNasa72NINbjXaBL1u/ct7xuWbONVNOfLrCszLQeCqJjb33+/9bfswy/oVuJWQRj9SBm
         UX3g==
X-Forwarded-Encrypted: i=1; AKwUvBwqjzC7WcL0AI8vIUnvAH50cbecLxaOd6PkkimsP3SDlhI/QmkTsHXb4UfKZ4UMJUJPHv6Gxr3X+FN4Vw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJyjEPb+BDbxchh2vJG9vWsafz/zm51CUtK7us2GmVEW4NMeGce
	9JgGs3QKMkCGd89F57IU8xSOjTUqHSK0OsmwowFIpIqvPPHaka0YXq65
X-Gm-Gg: AYBFou3x/otuHsrZBUb31GIb0d2msSHJTLTFc//bc5Qhpe0r8p5m+GwIIU57BwHY7JQ
	gvtoRn6WPpAwo9lXeMYZX7/M852oJ/0dwbwLpdsz+g/f+VHpRwHsjeR2VKcbLANS/qsswtl+GgE
	zZ69tjbIj/Oi0Cj5sxZSGE0Kvvn880Lfes8itSBAXUdHTOiwgpepJJ/bA63QssLKstQ1jzBP5Lp
	RsDYLogrQqxmI15K55nIWXE/bdvMuVeod6isYEDkE4L6ImjwuVgJSJnF5EnZhcj1kt/4a38qka6
	XfjudOiojGPbkZuUk+uiR3/gGMBvednOMxspL89xHIC2yzZHUAgJM0g2dmITaXETYMX9CHikzQY
	bxGdtVs0WHx6HPXXOnIzc+KiA1/2LdXaM08H39mXozpWC6QGzSWGWcJZdYjWmuGB3+4y0aEUdMP
	dKKisgqznyj18IH6LuP6gGjUC8BVlU5tjCs2eaDV9Kcg==
X-Received: by 2002:a17:90b:4d81:b0:3a0:22bd:6ee5 with SMTP id 98e67ed59e1d1-3a4d1509bafmr977540a91.14.1790767294158;
        Wed, 30 Sep 2026 04:21:34 -0700 (PDT)
Received: from linux.. ([2409:8a2b:a18:4ab0:713c:5fa2:817b:4330])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4cac0d4fesm3170316a91.10.2026.09.30.04.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:21:33 -0700 (PDT)
From: Binglei Wang <l3b2w1@gmail.com>
X-Google-Original-From: Binglei Wang
To: xiang@kernel.org,
	chao@kernel.org,
	linux-kernel@vger.kernel.org
Cc: zbestahu@gmail.com,
	jefflexu@linux.alibaba.com,
	dhavale@google.com,
	hongbohbli@tencent.com,
	guochunhai@vivo.com,
	liubo03@inspur.com,
	linux-erofs@lists.ozlabs.org,
	l3b2w1@gmail.com
Subject: [PATCH] erofs: fix folio reuse from a different address_space in erofs_bread()
Date: Wed, 30 Sep 2026 19:21:27 +0800
Message-ID: <20260930112127.27059-1-l3b2w1@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Binglei Wang <l3b2w1@gmail.com>

erofs_bread() reuses a cached folio on page index match without checking folio->mapping.

xattr.c calls erofs_init_metabuf() twice on the same buffer without erofs_put_metabuf();
the two in_metabox sources differ, so buf->mapping can switch
while buf->page still belongs to the old address_space.
The next erofs_bread() then reads the wrong mapping, dropping shared xattrs with METABOX.

We require folio->mapping == buf->mapping in the reuse check;
otherwise drop the cached folio and re-read via the slow path.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
---
 fs/erofs/data.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index be63b89f0862..d8b6523bc218 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -33,8 +33,13 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 	if (buf->page) {
 		folio = page_folio(buf->page);
-		if (folio_file_page(folio, index) != buf->page)
+		if (folio->mapping != buf->mapping) {
+			/* the cached folio belongs to another address_space */
+			erofs_put_metabuf(buf);
+			folio = NULL;
+		} else if (folio_file_page(folio, index) != buf->page) {
 			erofs_unmap_metabuf(buf);
+		}
 	}
 	if (!folio || !folio_contains(folio, index)) {
 		erofs_put_metabuf(buf);
--
2.43.0


