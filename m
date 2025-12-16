Return-Path: <linux-erofs+bounces-1498-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B469D5B87C
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Dec 2025 07:39:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dVpjY0CYDz2xqf;
	Tue, 16 Dec 2025 18:39:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1765870784;
	cv=none; b=Mz/LOXpyxK9C88B24QWJUPcK1TN/DTAEGLSw/zcaGzMzV6YnyyDS5qEb+bq/RpqqGxP1w+/AnhBHC3DVU1ddc4YVpbbtUw6B9DJ+Ee5RQFbgAhCqnk8GeRIGgUt/Q7JynWx2A5gHOLK4q+atP6uremSgspCarjQ6vHbpZAjwUKL0l7kXmO6yXq5L3uRENizMTxyOKZnPMflsJCExdSlxHpGsZuRzAZO3QjA/2lhH2hQioph7DjpM2D07XL1V5BhZ3EPI5NegkNmc7Ok0j1Vwrb1Iku3USUBKH/wYOA+vS6hRpRPx2WyVov8aIp2BQ5dVpTJ7VRnD1aQpGhF/vvPGMw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1765870784; c=relaxed/relaxed;
	bh=qoOGuDPSU2iwQxh5JpxadP4MOeXO4ZDlhadGEc9NETk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k0JhZfoRaZPztB9/zM+QPWPs6uaYypbdTaYqpeAJ8uDCE1XcpWjqQIhW+Dug3uNW/B8pTe72EsMpvf7kvi+HMx0WPV2OYkWvFHvpacWPLlajxKUZZfbaxLaHUlj4dXiY9lj7oqRGNBd83LacOMq9qOJ5d5uthkmWNFoFC+kOyawWm71mz44pasHX+rt1US88goFJF1/3L+GJ2LiEL7JSxDEUut/bUgSk2WNGp9e+2mRSgr8n1wb2/t4L05HOQuBTKz7SRyiWGW2payJs16mxSdBw3kien6zpxxuSKKp07jwzMIakiIdAnBb60qzH3dCIEewRRDaqEbaaDe3VRcWTFA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=StuU1Xcy; dkim-atps=neutral; spf=pass (client-ip=113.46.200.223; helo=canpmsgout08.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=StuU1Xcy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.223; helo=canpmsgout08.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dVpjV1k5zz2xJ6
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Dec 2025 18:39:39 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qoOGuDPSU2iwQxh5JpxadP4MOeXO4ZDlhadGEc9NETk=;
	b=StuU1XcyvQKOKMKcZlXtxDcKRbbyVrXk8YUiN2ZLG8Wx4q/x+WDndGOQ6BlNzKHmgrdnl6hg5
	sWul3O9wOUIaz4k94xnZ/DpXqsWuB4gBIWq62SKXrTgLqU2etF+uUyCcPnh9Dgh8ROjr+fcK59M
	7ZryY/Xdcm1jB2Fl0/qo4do=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dVpg22QLszmV69
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Dec 2025 15:37:34 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 7BD4B140203
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Dec 2025 15:39:34 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 16 Dec
 2025 15:39:34 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>
CC: <jingrui@huawei.com>, <wayne.ma@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH] erofs-utils: add myself to AUTHORS
Date: Tue, 16 Dec 2025 15:38:18 +0800
Message-ID: <20251216073818.744789-1-zhaoyifan28@huawei.com>
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
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

Since 2023, I have been an active contributor to the erofs-utils project,
helping develop features such as multi-threaded compression and S3
backend support in mkfs. I've also submitted over 20 patches covering
micro-refactorings, code refinements, and bug fixes.

I'm eager to sustain my contributions to erofs-utils, covering feature
development, bug resolution, and code review.

Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 AUTHORS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/AUTHORS b/AUTHORS
index c04d068..fcbfd3e 100644
--- a/AUTHORS
+++ b/AUTHORS
@@ -3,6 +3,7 @@ M: Li Guifu <bluce.lee@aliyun.com>
 M: Gao Xiang <xiang@kernel.org>
 M: Huang Jianan <jnhuang95@gmail.com>
 M: Chengyu Zhu <hudsonzhu@tencent.com>
+M: Yifan Zhao <zhaoyifan28@huawei.com>
 R: Chao Yu <chao@kernel.org>
 R: Miao Xie <miaoxie@huawei.com>
 R: Fang Wei <fangwei1@huawei.com>
-- 
2.43.0


