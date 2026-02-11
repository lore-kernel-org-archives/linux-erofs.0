Return-Path: <linux-erofs+bounces-2300-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F62EB595D
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Feb 2026 03:26:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f9kPZ0qV4z2xlj;
	Wed, 11 Feb 2026 14:26:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.63
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770780418;
	cv=none; b=kKbIsouxq9JL0Ap7PuT96HB0mE5OZPFvz2h2W9ArEgBg8lTMwDVNSbSgTumBa6HTeOAVffwvdY5OqWso9Tz0c3bLbcVML4DccDpTE55cdmFy3W/IDw4uCOytntQu4o1qHccs84UQwZdXnTYuOhKUr06RcGeSnyBpoBYe8jw5oTyldkQfljqGEWum9j1GvvGS1sHKGon0JZUmpnW532FRhCvoUyZkw2L9zvGjsbsoAU6ZatCTAjH4ntB+01L/UPaBf3zDNLKjkjad2D35XpHwgHdSaKa3FVUYz3/Th0Pch+WEWJBfTsRnjf3XbZTydWSBsqgwa93+t7VYZ7Q500z5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770780418; c=relaxed/relaxed;
	bh=y/6LrWPB07bqEJq1geE8c8qguXlle7WUErK4+p0H7gg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KHhUUeF+XAABM6BjRfNx2GRyo3++X01OQttNvqG0E8jplCy+Q+yOHfK3yx0kMjmQHSzNYUueB99W/4qP9mfsDlldo7GsEWZ+jsW9dyOpNIvWu0fcM4KT/DFcFweKoUbGWxNsiOreWUknCzIzTOhngFl0lzr8fS2cxv6qdWBiCLrg5+zGewxDicAyNnIrJiPonhLypWY0SlR8dSEr80qYnYQY3r0OvyN0TUY8qfN/IHllq+R1GKi+Ljt72KKFY7Lcqi2CLKqC4Z7N2pqzOET9uN2J8UTEmUKA1qMe2RnMGkyfx4g2gHsz04qKklxpYyQ40IlNmH+2udzbf5QOcSeTsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com; spf=pass (client-ip=115.124.28.63; helo=out28-63.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyzhu.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyzhu.com (client-ip=115.124.28.63; helo=out28-63.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org)
Received: from out28-63.mail.aliyun.com (out28-63.mail.aliyun.com [115.124.28.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f9kPW4MSvz2xd6
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Feb 2026 14:26:52 +1100 (AEDT)
Received: from HUDSONZHU-MB0.tencent.com(mailfrom:hudson@cyzhu.com fp:SMTPD_---.gUV-ct7_1770780405 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 11 Feb 2026 11:26:46 +0800
From: ChengyuZhu6 <hudson@cyzhu.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH v1] erofs-utils: mount: mark OCI as experimental
Date: Wed, 11 Feb 2026 11:26:45 +0800
Message-ID: <20260211032645.20962-1-hudson@cyzhu.com>
X-Mailer: git-send-email 2.47.1
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

From: Chengyu Zhu <hudsonzhu@tencent.com>

mark the OCI backend as EXPERIMENTAL in
both the help message and runtime warning.

Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
---
 mount/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mount/main.c b/mount/main.c
index a596c36..5a3dc54 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -100,7 +100,7 @@ static void usage(int argc, char **argv)
 		"    --reattach         reattach to an existing NBD device\n"
 #ifdef OCIEROFS_ENABLED
 		"\n"
-		"OCI-specific options (with -o):\n"
+		"OCI-specific options (EXPERIMENTAL, with -o):\n"
 		"   oci.blob=<digest>   specify OCI blob digest (sha256:...)\n"
 		"   oci.layer=<index>   specify OCI layer index\n"
 		"   oci.platform=<name> specify platform (default: linux/amd64)\n"
@@ -228,6 +228,7 @@ static long erofsmount_parse_flagopts(char *s, long flags, char **more)
 		if (strncmp(s, "oci", 3) == 0) {
 			/* Initialize ocicfg here iff != EROFSNBD_SOURCE_OCI */
 			if (nbdsrc.type != EROFSNBD_SOURCE_OCI) {
+				erofs_warn("OCI support is EXPERIMENTAL, use at your own risk.");
 				nbdsrc.type = EROFSNBD_SOURCE_OCI;
 				nbdsrc.ocicfg.layer_index = -1;
 			}
-- 
2.47.1


