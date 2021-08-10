Return-Path: <SRS0=0yrl=NB=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95ECEC4338F
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Aug 2021 06:55:30 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9B0C60FC4
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Aug 2021 06:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9B0C60FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GkNxr1HR2z30GH
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Aug 2021 16:55:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20161025 header.b=Z2PfQTKH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102d;
 helo=mail-pj1-x102d.google.com; envelope-from=zbestahu@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=Z2PfQTKH; dkim-atps=neutral
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com
 [IPv6:2607:f8b0:4864:20::102d])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GkNxk5B1qz2xnd
 for <linux-erofs@lists.ozlabs.org>; Tue, 10 Aug 2021 16:55:21 +1000 (AEST)
Received: by mail-pj1-x102d.google.com with SMTP id
 u21-20020a17090a8915b02901782c36f543so2927180pjn.4
 for <linux-erofs@lists.ozlabs.org>; Mon, 09 Aug 2021 23:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=wp6AQyVuidbbmZh4SpEnbdNrLtEBOB0mz0m+17qvH80=;
 b=Z2PfQTKHT/f2cgdX8JT6mIdT8GrweddGz6wWggyjQOVyZ+5gJzRgclw1kl/MmtOeA4
 Qg7VnIjiSk4AKyjgE/OrlEul1zGhmLTxFmOH7TmUJsAftiN3geenFmvhUG9GZs+OSzVC
 8CoQkfDZC1F+GsMXDkpfbUzlMkx13AMVafJaJrkkbqJrw2xacfsfu3Tfk932odh7p6nu
 JmiXIHH/ZiE1EGR2vO+m5JLo/REnZwSTDRSKI9j0cdMI11KMDtm1py4fPffTZ/Hi295J
 Gx3meUaiEnhEJc8Iru1Evwk5GC+0OXLFC//a8fn39JhFadc85L2/ZdiLW/ATMwnPcfM1
 Vbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=wp6AQyVuidbbmZh4SpEnbdNrLtEBOB0mz0m+17qvH80=;
 b=po1RTuqho2kriwo9IIfAzPsItvNBfbOEDbk3nqK0dJYc0/zDlenO6T7gZigLG7h2jM
 zU6/zvqhVz8YxxFE1ZfluHV58eKoADBXeSc69VbDDHw8KIJXTMzav8bV9cBB3syfx2hZ
 ZrWwQcMzfdFWuBws+RRk2P+YOCDNMDULcb2jzOv3Rxg22T3zOzq8RccTLVuQRNHt/Jer
 xnppvmwJqubns84XqTSHEICX1wuNEwejtbImjNsH4z7aLFJyfZwAUvC5d3VwIarXW5Nc
 QG5HgdPiyjWsru6kZ/Hz9yX0Mk3CCTiTSHVjLZSXEKzOwsrlihId44ZF+IwGaK22CqQH
 HjeA==
X-Gm-Message-State: AOAM532ipRirk+lfPMV165Ox1xFetlP1flwEWqIc7nsP7fIkjcrd34jB
 cB8HGF27FNyTAdFdIVEGpsI=
X-Google-Smtp-Source: ABdhPJyA9LmdyqIvPLhi85SmsV6nAGqM8rJ8oFoHSoOwf7HnCEnq9KFc3tFAHT2cBpaSvcSXkCu1zA==
X-Received: by 2002:a63:36cb:: with SMTP id d194mr8637pga.224.1628578517243;
 Mon, 09 Aug 2021 23:55:17 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
 by smtp.gmail.com with ESMTPSA id bk24sm1667496pjb.26.2021.08.09.23.55.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Aug 2021 23:55:17 -0700 (PDT)
From: Yue Hu <zbestahu@gmail.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: directly use wrapper erofs_page_is_managed() when
 shrinking
Date: Tue, 10 Aug 2021 14:54:50 +0800
Message-Id: <20210810065450.1320-1-zbestahu@gmail.com>
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
Cc: huyue2@yulong.com, linux-kernel@vger.kernel.org, zbestahu@163.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Yue Hu <huyue2@yulong.com>

We already have the wrapper function to identify managed page.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 fs/erofs/zdata.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 78e4b59..a809730 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -310,7 +310,6 @@ int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 {
 	struct z_erofs_pcluster *const pcl =
 		container_of(grp, struct z_erofs_pcluster, obj);
-	struct address_space *const mapping = MNGD_MAPPING(sbi);
 	int i;
 
 	/*
@@ -327,7 +326,7 @@ int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 		if (!trylock_page(page))
 			return -EBUSY;
 
-		if (page->mapping != mapping)
+		if (!erofs_page_is_managed(sbi, page))
 			continue;
 
 		/* barrier is implied in the following 'unlock_page' */
-- 
1.9.1

