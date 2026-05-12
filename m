Return-Path: <linux-erofs+bounces-3401-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E19CD4F35
	for <linux-erofs@archiver.kernel.org>; Tue, 12 May 2026 07:17:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gF7G20KY6z2ygJ;
	Tue, 12 May 2026 17:17:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778570249;
	cv=none; b=GUdh4Cg7NIaQe4HC1LWtR0gO1SO3EjjGsFdllEo9Mxh9Kkd69U4UBZSjtkMpvibaJc+ODuuTQYnbNryW6YcDiphBZCdBqn02Evc6/MUOJ64dmXIVZWdE+b7lGQLaA4hBWU1sP8+MSmflzcpyuebAJINnleNd2ZHmSI7B3JLasvYIw25s6WlnQY3x67zzRNlgadUCy6xpjNF7yWKhYxMzjXBCO+dV0Dmy5JOGm+3SDJFh6KDdzPi9BLDKY2Xx7Six+dDNP9DrOGSFRG4pCauL2VB7Wm8MZNDwDUtyEQe9I8YqzHt72YnhORce1aFUARf5MjyejQYLAMJzlRcrF9mrJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778570249; c=relaxed/relaxed;
	bh=B2WM1B+rDlIbVQVxpC63NjKCuSavvyFFOqSqzkOFNK0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IwJP0MRDU/wkAv4QTKicB+ak/+Kju1GlvPx38RU0OYxbCnLaNAhs3Qr52lCj9bp3Gt2PBSE/6v2HQrxQDy9uzJ4vF3UdtSNQFtkSbN85DWvqKWgFFKWe6ZIiQ5ucgxGeumF5jsB9cdImzcWKAUukVaXu1bcvJYLk05uCxlXH6WlfSKQm1K6JahEEE6rbLu0XxTVgGfL4WwEiNGZ2VNg2MBDOV1NuYS3UmiQnEJU3Ksg+TkpfpqN1wsamL/hoUHwciz4QgkHy9vdKE7EOcPFd+uOlOSsDsoadLxTMieLsD/C6/hdOZqYdaVis7d0ZBNorc8Mu/jguN0ANwUUeLXkOwQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oUln9Sxo; dkim-atps=neutral; spf=pass (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oUln9Sxo;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gF7Fz3BZKz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 May 2026 17:17:25 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=B2WM1B+rDlIbVQVxpC63NjKCuSavvyFFOqSqzkOFNK0=;
	b=oUln9SxopPON8toytvFbGLTPTVWBsGrFO3BP+Jaxx2jvbhhIwVfjaq00VYwDf82a0ECqo2tIu
	107dGJgwUZPSTkfHGKFf1GNjgbowe5ihSeimzr0Ml3nNa8b/bdornN9GESBiS5KdFcJU5WwDtVu
	ud6mi0JBeVYWq6WqC5G2G9I=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gF7516p6jzKm63
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 May 2026 15:09:41 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id C3EA14056E
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 May 2026 15:17:20 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 12 May
 2026 15:17:20 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>
CC: <jingrui@huawei.com>, <zhukeqian1@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH 1/3] erofs-utils: lib: ignore xattr prefixes if feature is off
Date: Tue, 12 May 2026 15:16:29 +0800
Message-ID: <20260512071631.969752-1-zhaoyifan28@huawei.com>
X-Mailer: git-send-email 2.47.3
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
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100010.china.huawei.com (7.202.195.125)

Ignore xattr_prefix_{count,start} and do not validate the inode-sharing
prefix id without INCOMPAT_XATTR_PREFIXES bit set. This keeps stale
superblock bytes from enabling long xattr prefix decoding on images
that did not declare the feature.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 lib/super.c | 3 ++-
 lib/xattr.c | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/super.c b/lib/super.c
index c21d5ad..899d51a 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -149,7 +149,8 @@ int erofs_read_superblock(struct erofs_sb_info *sbi)
 	sbi->build_time = le32_to_cpu(dsb->build_time);
 
 	memcpy(&sbi->uuid, dsb->uuid, sizeof(dsb->uuid));
-	if (erofs_sb_has_ishare_xattrs(sbi)) {
+	if (erofs_sb_has_ishare_xattrs(sbi) &&
+	    erofs_sb_has_xattr_prefixes(sbi)) {
 		if (dsb->ishare_xattr_prefix_id >= sbi->xattr_prefix_count) {
 			erofs_err("invalid ishare xattr prefix id %d",
 				  dsb->ishare_xattr_prefix_id);
diff --git a/lib/xattr.c b/lib/xattr.c
index 1891ac3..6093572 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1547,6 +1547,11 @@ int erofs_xattr_prefixes_init(struct erofs_sb_info *sbi)
 	int ret = 0, i, len;
 	void *buf;
 
+	if (!erofs_sb_has_xattr_prefixes(sbi)) {
+		sbi->xattr_prefix_count = 0;
+		return 0;
+	}
+
 	if (!sbi->xattr_prefix_count)
 		return 0;
 
-- 
2.47.3


