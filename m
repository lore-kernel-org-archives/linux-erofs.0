Return-Path: <SRS0=O26p=LK=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FAEC48BE6
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Jun 2021 08:04:44 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E24C61159
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Jun 2021 08:04:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E24C61159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4G4d570W72z3cP3
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Jun 2021 18:04:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20161025 header.b=AlJju8bv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::52c;
 helo=mail-pg1-x52c.google.com; envelope-from=zbestahu@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=AlJju8bv; dkim-atps=neutral
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com
 [IPv6:2607:f8b0:4864:20::52c])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4G4d4T5Pmlz3cB2
 for <linux-erofs@lists.ozlabs.org>; Wed, 16 Jun 2021 18:04:09 +1000 (AEST)
Received: by mail-pg1-x52c.google.com with SMTP id e22so1297017pgv.10
 for <linux-erofs@lists.ozlabs.org>; Wed, 16 Jun 2021 01:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=yadiB4Gk5ls5gyGsa2x5kO0pY7vBY4YxnVAY6760cew=;
 b=AlJju8bvBhYTU9aeQKelr0R+KZcm7BbhPAjp/bfIkEvo7P3TZOj5QarfiN0l5brYuE
 SSt+40Sc95LQ3Yy0fhrxMQFY4fOMDUmZTdLsRJ23pFzcoB/kHNsrR2PLbfNBoU1jCkHZ
 2UFIZOLgkz0aYHMHWQUvbYDRMbr4ZUxOrH8VNRRf4Ez+iJVFCJqcp6uQKnmaY4Pr7Qmg
 PHs3sZnZ2uPDaQxJ5kzH0bskBTt43ucpOGzIlJhDFJT3chZ4Pydo7w81lXk15+3M1UEJ
 0qnqz7hnNO635Xw03Lehgi1Ke9WurcZHBzeDdvDWZs/cxEnOnRZjHzDqluHPV1PHmDCn
 D7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=yadiB4Gk5ls5gyGsa2x5kO0pY7vBY4YxnVAY6760cew=;
 b=cGuuREjSK7uW5pUxCbdxJUIBtcd2z3xIsQlYI4e8Qk4wiMd0MfctPt8zm8tG1GNCN7
 y/W8PuVQm2Eiv7K7WyyoK3z8Mpz2w4gzq0B84pgo3Ry4gWUMT0SNawi4gg+TcEyf/RNh
 u1M1odi0x4yx4t6JhY3qsukaXOfAAazM6+TJvxS792mDxTA9/Ha143WSNP19d4o2KLTM
 PJjBFss5RWZz4Ufq5bPpPtOhgvcGiFGTeACKGkVYryZX37Yha0/MpShpY39H7FQuwlh6
 iOm5aXW4MWK+kAtpP/t4oTar7UO5ru1bcrMkJEiRXVvFgE13sl4oQxMllcBujwfRswR2
 RQ2g==
X-Gm-Message-State: AOAM532JtzXajko8Re8sz8R5/BAQ44B/sZqTfRVPOzXSYYkf4U39o0TQ
 oEXOLLAxI/c/EH0OabDyTD3JMat18DXgLg==
X-Google-Smtp-Source: ABdhPJxU8MLnXoFPjaYas02AKmv7NuL2HZI7m2ShVsntp0vhkCc4HK8BKR5b9xhum38gWEUZ+0bq6A==
X-Received: by 2002:a63:64a:: with SMTP id 71mr2044916pgg.360.1623830646537;
 Wed, 16 Jun 2021 01:04:06 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
 by smtp.gmail.com with ESMTPSA id t136sm1434096pfc.70.2021.06.16.01.04.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Jun 2021 01:04:06 -0700 (PDT)
From: Yue Hu <zbestahu@gmail.com>
To: linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: [PATCH] erofs-utils: correct the only tail-end data comment in
 __allocate_inode_bh_data()
Date: Wed, 16 Jun 2021 16:01:12 +0800
Message-Id: <20210616080112.941-1-zbestahu@gmail.com>
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
Cc: huyue2@yulong.com, zbestahu@163.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Yue Hu <huyue2@yulong.com>

nblocks = 0 means only tail-end data which may be inlined or not(ENOSPC).
Acturally, we also observed this non-inline tail-end data case.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 lib/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/inode.c b/lib/inode.c
index ca8952e..b6108db 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -119,7 +119,7 @@ static int __allocate_inode_bh_data(struct erofs_inode *inode,
 	int ret;
 
 	if (!nblocks) {
-		/* it has only tail-end inlined data */
+		/* it has only tail-end data */
 		inode->u.i_blkaddr = NULL_ADDR;
 		return 0;
 	}
-- 
1.9.1

