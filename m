Return-Path: <SRS0=q/zH=N3=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B89C433EF
	for <linux-erofs@archiver.kernel.org>; Sun,  5 Sep 2021 15:25:02 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9873360F92
	for <linux-erofs@archiver.kernel.org>; Sun,  5 Sep 2021 15:25:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9873360F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4H2b1m0k2vz2yHH
	for <linux-erofs@archiver.kernel.org>; Mon,  6 Sep 2021 01:25:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=WF2CirZ2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=WF2CirZ2; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4H2b1c5mTBz2xlF
 for <linux-erofs@lists.ozlabs.org>; Mon,  6 Sep 2021 01:24:52 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C5660F12;
 Sun,  5 Sep 2021 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1630855489;
 bh=/HIEIDTnBdrFJy17jpm4BW0aluRs16KI5hegDStbof4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WF2CirZ2y1MADl6oBfXuQcD29/wldZpFVGnPZsjamgg4phDO8nHIpKm4e4SkajSNV
 +3/36yPHfzmlL7F9fJii5/HtSvw7vpywPTc/uLND+staeep0c0O2Yh/QuiRy4aq8Cv
 weGa/GGRz6IzptRZ1f/MnCszgWBh5HWXI0UXyGaUV+WDmFVDlFvkBlgvGks791QM9C
 tRSRFYI7zSu0K1AqhX1tYWhhRYSrF29NkmsKdTSQaOOIuQki9nC4Yl2G8J2GJt6Mfy
 bp5k/A9x0SBchkqMKQ30ilrSL8vJvwkI9jgtfpQrny0ZakUJkJFYuCbT1+D58tCdIM
 ccyfGrS2/kbXg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: fix up Mac OS build again
Date: Sun,  5 Sep 2021 23:24:37 +0800
Message-Id: <20210905152437.32343-1-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210724133203.178109-1-hsiangkao@linux.alibaba.com>
References: <20210724133203.178109-1-hsiangkao@linux.alibaba.com>
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
Cc: Gao Xiang <xiang@kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Failed on Mac OS X 10.15.7 again.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 7dc5ff006466..b939155ac951 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -34,7 +34,9 @@ typedef unsigned short umode_t;
 #error incompatible PAGE_SIZE is already defined
 #endif
 
+#ifndef PAGE_MASK
 #define PAGE_MASK		(~(PAGE_SIZE-1))
+#endif
 
 #define LOG_BLOCK_SIZE          (12)
 #define EROFS_BLKSIZ            (1U << LOG_BLOCK_SIZE)
-- 
2.20.1

