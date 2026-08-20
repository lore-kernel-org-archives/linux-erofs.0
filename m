Return-Path: <linux-erofs+bounces-4259-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 554B0C5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 10:00:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQf825mlpz2xT6;
	Thu, 20 Aug 2026 20:00:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787220034;
	cv=none; b=ICYqEQ6sOC1hrBOs/YIPB4CY5QeJk7aaToFAoLIHC1o5jfDEHxR6q91nWdmDeJvH+hLLzeTl+/6DLF7XM/6JlJ6TL2QGdhJ/wNEl1sQJpI+Y7ZDo4fscfSNgb4sMrpYs8elTJr8kacNiDq5iiMDM9UE3EWfyRoQoKlGqSKzETB6KpMRiLorHTFq3lor9gqFNFdjnxfabKEaNWPtLm/+5peoEDtyC30Rr+YUQ50JUtd6pfxtZtBF8XJDlqfRvvMHuwdyoprOkHemju/cr3DXJOILq3EvFyGMPQn2mo5/+ePzyvfjB98UHlou08k4ehHuPDb3FxQOOHowS3IXtKLZfvw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787220034; c=relaxed/relaxed;
	bh=bE5bEzgA2XQbvp6yZKaI4M8VIgqSfdyg4HWCWlpJen8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T6S6kvAx+9G+nNpYczffYxv2j0zjqaKb3vnp9+E8g5YG5i/iPv5VfCuTk4CE+C0x+DuZ3epRmk8jGoAweyDgA7OgJhQD21EXj9M48lEvcNULYCz9rlKpj0Y6OE7tVBmTnWv99OTqZoI59suptanQx7501+wH2vJ4F01cYqW96jY5agf8YlVx84PhrcDMlXOyUoVeRape3cGdaE5y/aInCyk4+e8TIzzdPPycWKVUGHBJkGYi1VLLSYK26dI4uCwDFBbgwv1ZYqyBzlFVe2pXVl4VCQS4SVewrSFYv9Regmwo3VvhQehh2eKFkXRaDEE36WVP23hcfVW3VBGxuJf0Sg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=srs0=phdl=gn=glider.be=geert+renesas@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=srs0=phdl=gn=glider.be=geert+renesas@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQf814WPbz2xRx
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 20:00:33 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1EB943682;
	Thu, 20 Aug 2026 10:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DC81F000E9;
	Thu, 20 Aug 2026 10:00:26 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
Date: Thu, 20 Aug 2026 12:00:23 +0200
Message-ID: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
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

When NR_CPUS is less than 16, or when SMP is disabled, the default value
of 16 is invalid.

While actual configuration picks up a sensible and valid default
(NR_CPUS or 1), "make savedefconfig" will still write a line like

    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1

to the defconfig file, even if that matches the sensible default.

Avoid needlessly enlarging the defconfig files, and reduce churn for
updating them, by specifying valid defaults depending on SMP and
NR_CPUS.

While at it, make the prompt depend on SMP, as there is no point in
asking the user about the maximum number of decompression streams if
there is only one valid answer.

Fixes: c9b47e6b23114e93 ("erofs: cap LZMA stream pool size")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 fs/erofs/Kconfig | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 2dfc313588d283a0..37495e95a78d9bf6 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -132,11 +132,13 @@ config EROFS_FS_ZIP_LZMA
 	  Say N if you want to disable LZMA compression support.
 
 config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
-	int "EROFS LZMA default maximum decompression streams"
+	int "EROFS LZMA default maximum decompression streams" if SMP
 	depends on EROFS_FS_ZIP_LZMA
 	range 1 NR_CPUS if SMP
 	range 1 1 if !SMP
-	default 16
+	default 16 if SMP && NR_CPUS >= 16
+	default NR_CPUS if SMP
+	default 1
 	help
 	  By default EROFS allocates one LZMA decompression stream per CPU.
 	  Each stream can hold a dictionary of up to 8 MiB taken from the
@@ -144,7 +146,7 @@ config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	  of memory.  This caps the default; the lzma_streams module parameter
 	  still overrides it.
 
-	  If unsure, keep the default of 16.
+	  If unsure, keep the suggested default (16 or lower).
 
 config EROFS_FS_ZIP_DEFLATE
 	bool "EROFS DEFLATE compressed data support"
-- 
2.43.0


