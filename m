Return-Path: <SRS0=6tRW=JY=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5823EC43460
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Apr 2021 02:37:37 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B820D613B2
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Apr 2021 02:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B820D613B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FTmBl2Rnwz3004
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Apr 2021 12:37:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=rtMOQTdd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=rtMOQTdd; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FTmBj67r1z2yxF
 for <linux-erofs@lists.ozlabs.org>; Tue, 27 Apr 2021 12:37:33 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD95610A5;
 Tue, 27 Apr 2021 02:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619491052;
 bh=Mh6wIxy3pUA7ZeNLviRHsD0/ducm7K/MDWFeQsdygFA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=rtMOQTddGea2FE+dkYzkhHFyPtTap1B+qTLPw6KY/4tBwmtQIfb47ciOXim7gQ6iQ
 DXXPormJvVL/IS7qOsPumeHY6Gxf5jcR+66gzxmdB8Dd3Ug8gVNAIX9WcmDijevm7c
 AX98Aut254/VTGZnCyuHd7b33zMY0pl0tngLiBSr0eAp75sbZI90DhJE5YonrqEgKd
 pdOQehk/ozmc1CQXiJ6W2dlxUVcdz5TmcfljZv/ir0hi/KVS3Lk75Srpa7IwPyymha
 yJART3VWL08mS94GLo/4XlBolWorMSehiT/c9hAB1QUsStce+cBzyJRzF6bkw+hJmp
 OmZloG0hRvi2g==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org,
	Li Guifu <bluce.liguifu@huawei.com>
Subject: [PATCH 2/3] erofs-utils: warn out experimental big pcluster
Date: Tue, 27 Apr 2021 10:37:21 +0800
Message-Id: <20210427023722.7996-2-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210427023722.7996-1-xiang@kernel.org>
References: <20210427023722.7996-1-xiang@kernel.org>
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

It's still an experimental feature for now.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/compress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/compress.c b/lib/compress.c
index 654286d3f33e..9f39de878155 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -619,6 +619,8 @@ int z_erofs_compress_init(struct erofs_buffer_head *sb_bh)
 		mapheader.h_advise |= Z_EROFS_ADVISE_BIG_PCLUSTER_1;
 		if (!cfg.c_legacy_compress)
 			mapheader.h_advise |= Z_EROFS_ADVISE_BIG_PCLUSTER_2;
+
+		erofs_info("EXPERIMENTAL big pcluster feature in use. Use at your own risk!");
 	}
 	mapheader.h_algorithmtype = algorithmtype[1] << 4 |
 					  algorithmtype[0];
-- 
2.20.1

