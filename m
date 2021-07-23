Return-Path: <SRS0=dz+x=MP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77967C4338F
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jul 2021 03:50:57 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 03A3F60C41
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jul 2021 03:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03A3F60C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GWFjC4QNlz3035
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jul 2021 13:50:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20161025 header.b=QBG8/xRO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62b;
 helo=mail-pl1-x62b.google.com; envelope-from=zbestahu@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=QBG8/xRO; dkim-atps=neutral
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com
 [IPv6:2607:f8b0:4864:20::62b])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GWFj530dZz2yWJ
 for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jul 2021 13:50:47 +1000 (AEST)
Received: by mail-pl1-x62b.google.com with SMTP id u8so1832809plr.1
 for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jul 2021 20:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Z6IPxJRZViAzD6fELASSrauar2h6iUz8qFkfU/G4wIU=;
 b=QBG8/xROA3LH/DvtKZ0wCtZNW5bWxUARqXPxpi029RS4zJXnkkYeIuzftwSRerGvTz
 rpFUYW8VrRe+k0e+JHx8YqVgU4dXjGAInnA6RigCOnwu0pVF5XUYxy56MzX/RmapthGX
 rQv+mt8lpIPfjEZEaWK79zMFrqgMpLKQcwIp5MMBuNElBHR7I7dLIYB5hKkMRlhUmjg+
 G3JYn78goNNKf/ukb0m9tdR4k1PGahxrGfSC0rJOK7E3K0/JpKDMw6em3Gdq14fXbuDL
 fsHR34LQFCxrtrz3AkemLqhpmPUVdBq3KFK+m8c16DElxz4uqKXqNzpraY33XVbBZ8ll
 eiwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Z6IPxJRZViAzD6fELASSrauar2h6iUz8qFkfU/G4wIU=;
 b=ncgB2UJQTlYH3Evww84X7w5yA+De/Dijan4kIdnVR3ReIrB5uDk2JKKOvQloke+iu/
 4/N8a6GiPOQ2+aWfzTO7IUswh05NUsk9w4KBLAHHSVzwfIe6/5a6ZDLajUck8Az3Jsei
 eaFD/KiHDzsy9wYpmVkFYvq4PaC5hGXPl9H+lcM3wHkifGZqzRYiHIBbVppZagmF0Lwr
 V7FDIlB3eLHSfbuxP6QisAOYjY6g4UiP6ShK9yMpPvRmFUlS29mL6r8zKuMERpNfiqkP
 a9NAlNG/4a6nRxWJavBVCzYoS9VuJ4wnPe9108fr3LNlBWtogvlbnH39WeXymmU+BXBd
 09GQ==
X-Gm-Message-State: AOAM530qoKIMD+lMtL1Muf3IdQTQE+143MS0Os29LAeQklk/AWH9IrKi
 u8t/pDjaG0GrrnVfmtWlRGRNow0fWEwSSg==
X-Google-Smtp-Source: ABdhPJytEstn2aAlZc/XgeUxj50xiqQkTn76pf6ZH5GdLBhXM9QgcqrjNIRAkqU1yB4k6rRynTUcJA==
X-Received: by 2002:a17:903:248f:b029:128:d5ea:18a7 with SMTP id
 p15-20020a170903248fb0290128d5ea18a7mr2615244plw.83.1627012244061; 
 Thu, 22 Jul 2021 20:50:44 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
 by smtp.gmail.com with ESMTPSA id j12sm30872811pfj.208.2021.07.22.20.50.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jul 2021 20:50:43 -0700 (PDT)
From: Yue Hu <zbestahu@gmail.com>
To: linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: [PATCH] erofs-utils: no compression case for tail-end block in
 vle_write_indexes()
Date: Fri, 23 Jul 2021 11:49:45 +0800
Message-Id: <20210723034945.1337-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Cc: huyue2@yulong.com, yuchao0@huawei.com, zbestahu@163.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Yue Hu <huyue2@yulong.com>

Note that count value will be always greater than EROFS_BLKSIZ when
calling erofs_compress_destsize() in vle_compress_one(). So, the d1
always >= 1 for compressed block in vle_write_indexes(). That is to
say tail-end block can't be compressed.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 lib/compress.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index af0c720..93fc543 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -73,10 +73,9 @@ static void vle_write_indexes(struct z_erofs_vle_compress_ctx *ctx,
 
 	di.di_clusterofs = cpu_to_le16(ctx->clusterofs);
 
-	/* whether the tail-end (un)compressed block or not */
+	/* whether the tail-end uncompressed block or not */
 	if (!d1) {
-		type = raw ? Z_EROFS_VLE_CLUSTER_TYPE_PLAIN :
-			Z_EROFS_VLE_CLUSTER_TYPE_HEAD;
+		type = Z_EROFS_VLE_CLUSTER_TYPE_PLAIN;
 		advise = cpu_to_le16(type << Z_EROFS_VLE_DI_CLUSTER_TYPE_BIT);
 
 		di.di_advise = advise;
-- 
1.9.1

