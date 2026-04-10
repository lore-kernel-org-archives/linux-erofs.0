Return-Path: <linux-erofs+bounces-3255-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F72F36BB0
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 06:06:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsRCG5vMNz2yZ6;
	Fri, 10 Apr 2026 16:06:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:cf8:acf:41::8"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775801210;
	cv=none; b=HRN7W9L9YFfMHVo5L7djBRJwPt5l7deF4SzAWP59fWextwKmcVHQIX7roo6i+jtz6LjNbHpt67hgQ8Gy8tpJ/k2s+mXVzKexzVSe49ykCo+a/XBp2bCyrAoy/tCGktAUy332uyD1eVubj83o2X2f3athAf/lQdODYHhawQB+AqGsFAVSZCovWYB2TV8JIYpzxWgp3cf7uYizzS8oHhBLNoijEM12aVRuM6r1PMd6ovMq87zYP456/8H2C1DPUODxAI+kM6nNcogMbIl2KObK9EHj06Gu1hH/wogAnFNHg7O+hHV5mUv0nITrS//Oz+I3vpQyVY3FqlWi6MCGsLmDOg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775801210; c=relaxed/relaxed;
	bh=zcCDcAjrgpn+lCwqNVjWRpbg6iLJ9dGi1Yu4aQtC4HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EnriiIYEbmaAF3WaWaPqjRLjOwenJZicQCrno5osM5/2beBdJ2g7pDoPBIuWPDsjOLpclTqx6pUzFja2O4gS5f7C3JXGFLLKzh4inGbyjz1ETdurvce5ARu6qTx1wNuIp3qUAmGhfIvt95dicnnaDO2Tcd/dzBIyRBb1FhqGK2RCqi5UAr8Y7fq6BOIeM4Q6nK2qvwxMvpnWfzNGuAqlNwQgSLCHU8Af5VrcqNEt7sIWrbZzJ9lhcCHFeWJDACTSKG5otQWVb94p2ITf1MF3wJEYeDvBRp9i6BnVtXzWbde+Z2APEekaYScs/gofx6jaPDpN94YGlHrW81I8VXlvZQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=bmEP9GWe; dkim-atps=neutral; spf=pass (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=yuezhang.mo@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=bmEP9GWe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=yuezhang.mo@sony.com; receiver=lists.ozlabs.org)
Received: from jpms-ob02-os7.noc.sony.co.jp (jpms-ob02-os7.noc.sony.co.jp [IPv6:2001:cf8:acf:41::8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsRCD2kKgz2xTh
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 16:06:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1775801209; x=1807337209;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zcCDcAjrgpn+lCwqNVjWRpbg6iLJ9dGi1Yu4aQtC4HQ=;
  b=bmEP9GWea6rGRTtAgC1yPRJEa6pXjToGnBYPl85iHFaV7OuA7RXVFrTX
   eyFlygRYfp+hNoJ6d7jFAYAq79VW8ozbI+HvDXQiK22csDIv4thC+rQ09
   Wzj2tGQrWiMHG9sFn7ie/vUxvvDYh33t/uteYW8dZF3IXdWkUy+KTChPr
   yj9jTf1LwTSmB0OtMYnfmNNZJxtYqWnkaqaNfQjumMzbblZ7LLEv7f34L
   Qd4FIgD0p5J2eITD2c2ZQ+GUQ0z/L7kN6h5n+07kmfrrWiqCP+dySTcSN
   eNRuliCTksBaWAvKf6u8b+9O61e1LJZITHBpaveYzXcywF3XqqaHzLWT7
   A==;
X-CSE-ConnectionGUID: Rtw4EW0JQyuY4u8Tof2w2Q==
X-CSE-MsgGUID: La9SGrV+SASY0lIszIgyBw==
Received: from unknown (HELO jpmta-ob01-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::6])
  by jpms-ob02-os7.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:06:37 +0900
X-CSE-ConnectionGUID: ntyNo479QRCClOltK+Cy5g==
X-CSE-MsgGUID: V+n3hMP8SDmKvIrwSqXa0Q==
X-IronPort-AV: E=Sophos;i="6.23,171,1770562800"; 
   d="scan'208";a="60553941"
Received: from unknown (HELO cscsh-7000014390..) ([43.82.111.225])
  by jpmta-ob01-os7.noc.sony.co.jp with ESMTP; 10 Apr 2026 15:06:36 +0900
From: Yuezhang Mo <Yuezhang.Mo@sony.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: [PATCH v1] erofs-utils: mkfs: fix fingerprint not set in certain modes
Date: Fri, 10 Apr 2026 14:05:40 +0800
Message-ID: <20260410060539.417457-2-Yuezhang.Mo@sony.com>
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

In certain modes, such as "--tar=f --sort=none", data is written to
the image before fingerprint calculation. In this case, ->datasource
will be set to `EROFS_INODE_DATA_SOURCE_NONE`.

The original `erofs_set_inode_fingerprint()` function only attempts to
read data from a local file or disk buffer; it cannot handle the
`EROFS_INODE_DATA_SOURCE_NONE` case, causing fingerprint setting to be
skipped.

This patch adds handling for the `EROFS_INODE_DATA_SOURCE_NONE` case,
reading data from the image and calculating the fingerprint.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
---
 lib/inode.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index 2cfc6c5..51d5266 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1975,6 +1975,13 @@ static int erofs_set_inode_fingerprint(struct erofs_inode *inode, int fd,
 
 	if (!ishare_xattr_prefix_id)
 		return 0;
+
+	if (inode->datasource == EROFS_INODE_DATA_SOURCE_NONE) {
+		ret = erofs_iopen(&vf, inode);
+		if (ret)
+			return ret;
+	}
+
 	erofs_sha256_init(&md);
 	do {
 		u8 buf[32768];
@@ -2018,12 +2025,6 @@ static int erofs_mkfs_begin_nondirectory(const struct erofs_mkfs_btctx *btctx,
 			goto out;
 		}
 
-		if (S_ISREG(inode->i_mode) && inode->i_size) {
-			ret = erofs_set_inode_fingerprint(inode, ctx.fd, ctx.fpos);
-			if (ret < 0)
-				return ret;
-		}
-
 		if (inode->sbi->available_compr_algs &&
 		    erofs_file_is_compressible(im, inode)) {
 			ctx.ictx = erofs_prepare_compressed_file(im, inode);
@@ -2037,6 +2038,13 @@ static int erofs_mkfs_begin_nondirectory(const struct erofs_mkfs_btctx *btctx,
 		}
 	}
 out:
+	if (S_ISREG(inode->i_mode) && inode->i_size &&
+	    inode->datasource != EROFS_INODE_DATA_SOURCE_RESVSP) {
+		ret = erofs_set_inode_fingerprint(inode, ctx.fd, ctx.fpos);
+		if (ret < 0)
+			return ret;
+	}
+
 	return erofs_mkfs_go(btctx, EROFS_MKFS_JOB_NDIR, &ctx, sizeof(ctx));
 }
 
-- 
2.43.0


