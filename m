Return-Path: <linux-erofs+bounces-1159-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCBCCAC5B8
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Oct 2025 03:22:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4cghK76YNgz2yqW;
	Tue,  7 Oct 2025 14:22:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1759807355;
	cv=none; b=HhrmSG2L/2Z1JLbc6hi3x59L1y3nLZEFW+AXJgdd9782uYiry2PxIHl06zGr6LzJj425vvBI2BjvkWX8ECG8+914VR/jt56DW6fflgnViDai90KRx81whNNxz5TeuUzv/vvzex2+W4alWAeRfJHMVLPQLwWVat/ukddhn6/o/xBte/5uOFxDxQG/J0n81adCgDCnZS7a0la90NlO63sU7f/SURBj7NXvb+l/RVsgd/UGjUX3/YwUTK0wqIBxNrZY3RpSYfaEfZTaqJyHPN4eyh6NrnI8QtiTDerlRxuiEO8LajGf2QHrY0kUku7EClavlXaBXrNA4+4PjKYF0FAB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1759807355; c=relaxed/relaxed;
	bh=Z9VjBgCm2WJY9mogjDeUZ6HhhPwfNE++N4EQSzfXlxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SU5DcmgbxU8eK2sYJjXbqIuePOgYggFI6y0WV671Q8UpwWzt4wbUXxcQ+ELk8JVcl4/bwtMFoKqcA0u1vp0SrSqE1VaZ46JwaiI1b7TVQmoJMocwg2kouLVql08kZyGelc/8vmt/0tU8FI8b4RgJOYy6emL4b+drL4+X8SHxJx+mini8iSXG+GcUdmJkSFHtW/CKylR61vupzPTHaCxUK5D/vf1nupyUWfXOcI1fEdyLKfEpBRpp3koEhaeWFFg+1jOv3P5PBlkqkhDkHuqJu5MRzHm+/i/JIf4r9cLoJTVhIME+f745Q7lao4ubGlqnsXOnIF3w0nbyL/d/mpcZMg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SEAZeor6; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SEAZeor6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4cghK60fJ3z2yGM
	for <linux-erofs@lists.ozlabs.org>; Tue,  7 Oct 2025 14:22:32 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759807348; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Z9VjBgCm2WJY9mogjDeUZ6HhhPwfNE++N4EQSzfXlxo=;
	b=SEAZeor6tagJUE+pmWBmixsNWtfzK7zCaYJBn4OwhZnvXet1yK5UGyxA/S2HsLs0QXkU5TG/glM4Ye3jOoMVUk4tbvPtqaJlgl94xrbnDJsup8zNCNY2cD8wtyWFRjROzX5kC25hgZPpVd+7RICcf5IufWdLf957VH2Ag07PoXw=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WpagAxr_1759807341 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Oct 2025 11:22:26 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH] erofs-utils: mount: don't overwrite layer_index with -1 again
Date: Tue,  7 Oct 2025 11:22:20 +0800
Message-ID: <20251007032220.1860559-1-hsiangkao@linux.alibaba.com>
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

Initialize ocicfg only when nbdsrc.type changes to
EROFSNBD_SOURCE_OCI.

Fixes: 6a7cfdb9cd66 ("erofs-utils: oci: add support for indexing by layer digest")
Cc: Chengyu Zhu <hudsonzhu@tencent.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mount/main.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mount/main.c b/mount/main.c
index eb0dd01..e2443f8 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -83,10 +83,6 @@ static int erofsmount_parse_oci_option(const char *option)
 	char *p;
 	long idx;
 
-	if (oci_cfg->layer_index == 0 && !oci_cfg->blob_digest &&
-	    !oci_cfg->platform && !oci_cfg->username && !oci_cfg->password)
-		oci_cfg->layer_index = -1;
-
 	p = strstr(option, "oci.blob=");
 	if (p != NULL) {
 		p += strlen("oci.blob=");
@@ -147,10 +143,6 @@ static int erofsmount_parse_oci_option(const char *option)
 			}
 		}
 	}
-
-	if (oci_cfg->platform || oci_cfg->username || oci_cfg->password ||
-	    oci_cfg->blob_digest || oci_cfg->layer_index >= 0)
-		nbdsrc.type = EROFSNBD_SOURCE_OCI;
 	return 0;
 }
 #else
@@ -191,6 +183,11 @@ static long erofsmount_parse_flagopts(char *s, long flags, char **more)
 			*comma = '\0';
 
 		if (strncmp(s, "oci", 3) == 0) {
+			/* Initialize ocicfg here iff != EROFSNBD_SOURCE_OCI */
+			if (nbdsrc.type != EROFSNBD_SOURCE_OCI) {
+				nbdsrc.type = EROFSNBD_SOURCE_OCI;
+				nbdsrc.ocicfg.layer_index = -1;
+			}
 			err = erofsmount_parse_oci_option(s);
 			if (err < 0)
 				return err;
-- 
2.43.5


