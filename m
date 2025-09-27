Return-Path: <linux-erofs+bounces-1119-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED2BCAC5B0
	for <linux-erofs@archiver.kernel.org>; Sat, 27 Sep 2025 16:26:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4cYt9t1Qvbz301K;
	Sun, 28 Sep 2025 02:26:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1758990370;
	cv=none; b=N6k2FwKchaSZFVK6nX3x2v5ID3P9zLjhL9f5iJzC6AFF6w3B+EVsY14AKztFzqm2FYfAk5TWQrUfa+97gVNZkZWSgmBoAwCpGdwK7ZaJb/kFkIoN1/y49D6C4gXTrEV+nkfmu+CyWJ3zGZCTeA/gOeYiZb6FH7zihSshtNEsaGEiV+6HfT0qCkSjw8avfYGjqrLkf7aBnA8Pkn6h/sQ7ysOSht4UYCTvAoRJ7P3jh5GzsQw7BXpy1oIE34+LZeyVyQn9ERHxzixcnD/rkWVW+J4A3bJ9KP5875YvVLPtRkf8Y+64eQw+QYlU755RAxjv03gKDVo6x32WgJUaC+2bcA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1758990370; c=relaxed/relaxed;
	bh=N1dpQ2Ozet3hsEv0HsKMrBWDFHjSliI9NLOtv4QFEaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw3DkGcMLrPuqgeNIxwGDz7465V3D9/FCf8rwi0/RmThV0PjfzZDrmST8QxKBbCPzpyY1Bh8w893eW2MKY2bbSa1wIGvnUEDBjrtvbjIsD7Hm8hJaKabQWiRxSmbRmMLbay76eb9GPWrgGoIH4Ko4rdqy8pbszYMol536Z/4+2E0OJwZcw681w7OgCTAyMfyvNolapxX55fawNBxuCrhHtbJEPS0HEIbvwkBpOzqexrTl/guLWu2ncl/dqLoukNBD06aBzhyM5XH795EFAiGhJyB5ONS4qrfqxcgw4mXu/8GHV8sK9LRdQrKT6STnyqCVazu45YfK20tHxCTVXEV9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MA1vguQY; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MA1vguQY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4cYt9l2dyHz2xQ3
	for <linux-erofs@lists.ozlabs.org>; Sun, 28 Sep 2025 02:26:01 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758990356; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=N1dpQ2Ozet3hsEv0HsKMrBWDFHjSliI9NLOtv4QFEaw=;
	b=MA1vguQYjQeiDc5SQ992C1kRuvQmmZozEuJ25uCyQp9uEaE9yVSJsSicdCvgGLjSqkD86Ydgxvsp6qQRdYRK/gI6Pgbz6ZuYECGeX+nUYO2gAJ3WLr0O7LDXGEUqomRPIpuzv/7/j04JJkqmpPHGTc4TtxVje1be0nBmmWFmWLw=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WovwCg1_1758990353 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 28 Sep 2025 00:25:54 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 2/2] erofs-utils: lib: handle duplicate dirents in incremental builds
Date: Sun, 28 Sep 2025 00:25:48 +0800
Message-ID: <20250927162548.1508593-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250927162548.1508593-1-hsiangkao@linux.alibaba.com>
References: <20250927162548.1508593-1-hsiangkao@linux.alibaba.com>
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

Corrupted base images may contain duplicate dirents.

Fixes: f64d9d02576b ("erofs-utils: introduce incremental builds")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/rebuild.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index 64779cb..e3c7eb8 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -484,6 +484,11 @@ static int erofs_rebuild_basedir_dirent_iter(struct erofs_dir_context *ctx)
 		d->validnid = true;
 		if (!mergedir->whiteouts && erofs_dentry_is_wht(dir->sbi, d))
 			mergedir->whiteouts = true;
+	} else if (__erofs_unlikely(d->validnid)) {
+		/* The base image appears to be corrupted */
+		DBG_BUGON(1);
+		ret = -EFSCORRUPTED;
+		goto out;
 	} else {
 		struct erofs_inode *inode = d->inode;
 
-- 
2.43.5


