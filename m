Return-Path: <SRS0=xEWh=I6=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B753C433ED
	for <linux-erofs@archiver.kernel.org>; Thu,  1 Apr 2021 03:30:32 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6BAE610FA
	for <linux-erofs@archiver.kernel.org>; Thu,  1 Apr 2021 03:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6BAE610FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4F9pbp2H1hz3bpT
	for <linux-erofs@archiver.kernel.org>; Thu,  1 Apr 2021 14:30:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=gwBoG+20;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=gwBoG+20; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4F9pbm1Xqrz304J
 for <linux-erofs@lists.ozlabs.org>; Thu,  1 Apr 2021 14:30:28 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DE12610EA;
 Thu,  1 Apr 2021 03:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617247826;
 bh=A0qkS7QWzidI3MgcCwg+Y/FUO3s2/bOI/ufSEbt+T3Q=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gwBoG+20+/GbSNimGtHHYe0Ct0fK+JNo7QHeHVYy+vTXUg2fKhGU9MYz8RaBz9dHE
 AaWNjeisETmLSISsw70jDrX4UbaTr7aT5b07mDYPRv7eIeuOVUVH2/04YDrfyi17za
 NGPgnNZFfzIAXcboj+R8f2f+ki4SvO1uI7z+VFJy+T7MRToVr0qgXi48NWjLdHLyCH
 D9luueAapum1vC/pYxkYHUP4nJR5hNEPWwwt1sIpxM3s7L36yrRoJSBCYSwwSMf7aD
 90lxiLKt1VEbK42CbAuqMu/hz+G68JPjDYCyu3sEmwqaNhi4EK3y9mpShkze6KMOcr
 Rjwvq3VfASKNg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>,
 Chao Yu <chao@kernel.org>
Subject: [PATCH v2 10/10] erofs: enable big pcluster feature
Date: Thu,  1 Apr 2021 11:29:54 +0800
Message-Id: <20210401032954.20555-11-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210401032954.20555-1-xiang@kernel.org>
References: <20210401032954.20555-1-xiang@kernel.org>
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <hsiangkao@redhat.com>

Enable COMPR_CFGS and BIG_PCLUSTER since the implementations are
all settled properly.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/erofs_fs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index ecc3a0ea0bc4..8739d3adf51f 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -20,7 +20,10 @@
 #define EROFS_FEATURE_INCOMPAT_LZ4_0PADDING	0x00000001
 #define EROFS_FEATURE_INCOMPAT_COMPR_CFGS	0x00000002
 #define EROFS_FEATURE_INCOMPAT_BIG_PCLUSTER	0x00000002
-#define EROFS_ALL_FEATURE_INCOMPAT		EROFS_FEATURE_INCOMPAT_LZ4_0PADDING
+#define EROFS_ALL_FEATURE_INCOMPAT		\
+	(EROFS_FEATURE_INCOMPAT_LZ4_0PADDING | \
+	 EROFS_FEATURE_INCOMPAT_COMPR_CFGS | \
+	 EROFS_FEATURE_INCOMPAT_BIG_PCLUSTER)
 
 #define EROFS_SB_EXTSLOT_SIZE	16
 
-- 
2.20.1

