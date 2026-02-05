Return-Path: <linux-erofs+bounces-2262-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B824E91291
	for <linux-erofs@archiver.kernel.org>; Thu,  5 Feb 2026 08:43:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f69jn4K8Lz2xrk;
	Thu, 05 Feb 2026 19:43:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770281021;
	cv=none; b=PLmbNlVNgjPN74tONT+c/TacYsU3d3MOJmC6YCZi0M1+IBaLy8kYham38c+m4npxi6WUI2W7aPnQqbloApbXmuawgbuEwQUOxYZG8VlgxWlMTCyo//g18QpuXdi/xQX8ExLkr14d1DDn2OiPLFMq3/U1JT6bBwhE/vV/WAa2tWaYwx2xgLRSfRevTbk/Dh3Jps2tX0y+KIIM9Kiy6pvNwDwiyUA38eZ8k9m3W0SCZ6/3nJ25L6tgaTvn93xHRo8YIcMW+lJ+CGVz5fZsoEyUHG4RUk9WTPJkVBghBiX9TW1QwKfmBJqHY5OoK0zbgxtrAx0IKT0dm3iaFpCWLOJ0Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770281021; c=relaxed/relaxed;
	bh=nMHrzzX/KfiQAU8+qPYWNRsiCRn4RCu6xgAqvZHNRCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X/9MvXauFunO8WxpV4Py0FoUt1+TPNUUOh2to5i5DJDg+MIFvEkOohs3ikLewxzI/tq2nsElgRTOS74cEk4uLdHdSsvmdeALvhZsLP4cvEN5DB2/qtwGSUa+xu6AtUYuzmqhlsTRcE0vnq+/MXJZPMWnv5V00WQtcjwJARhGNwZ8LaBwF/8j+WEfssV09z92a7amvDZ3v88LVfV56qf750pgALLowpDjh1x1DhKPyMv7MDa1myynZZkhe1266cwyDfCb8RTqGgnNwaHCDDlkYfKHzQWL54IY9Z63nkF8rQnj+DOrNpsNGpw1f/0ROzf/kpyCwQPAXmLsXa49tfQ5eQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WXobjL0B; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WXobjL0B;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f69jk4psnz2xg9
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Feb 2026 19:43:36 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770281011; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=nMHrzzX/KfiQAU8+qPYWNRsiCRn4RCu6xgAqvZHNRCs=;
	b=WXobjL0B+nMrVtRfOWm2u54qEtuKEyN1jIM4bU802EbcEch3O0aRx7Xj86iNU7CvvbNUd5hPSTIxXHWP4HojsFqIEwN0xWn0rNdi+m4gwv8hUvXAGOA+Att6GkuxBgJ+tIovbjuCJMVqe/WygS8AMvECWFhOq9zxwn9/R4I3VNk=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WyaLsVV_1770281006 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Feb 2026 16:43:29 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: manpage: only install mount.erofs.8 with the command
Date: Thu,  5 Feb 2026 16:43:22 +0800
Message-ID: <20260205084322.494282-1-hsiangkao@linux.alibaba.com>
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

Fixes: 6d91a8f11cb7 ("erofs-utils: mount: add manpage and usage information")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 man/Makefile.am | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/man/Makefile.am b/man/Makefile.am
index b76b45714b0d..c951681bd8c7 100644
--- a/man/Makefile.am
+++ b/man/Makefile.am
@@ -1,8 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0+
 
-dist_man_MANS = mkfs.erofs.1 dump.erofs.1 fsck.erofs.1 mount.erofs.8
+dist_man_MANS = mkfs.erofs.1 dump.erofs.1 fsck.erofs.1
 
-EXTRA_DIST = erofsfuse.1
+EXTRA_DIST = erofsfuse.1 mount.erofs.8
 if ENABLE_FUSE
 man_MANS = erofsfuse.1
 endif
+
+if OS_LINUX
+man_MANS = mount.erofs.8
+endif
-- 
2.43.5


