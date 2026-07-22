Return-Path: <linux-erofs+bounces-3949-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8475CC4452D
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 08:39:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4njg0QXrz2y1F;
	Wed, 22 Jul 2026 18:39:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784709558;
	cv=none; b=T3aiRHLV5YzCDAATNNJJepWw6LjyjuajotSEe3euAxckFBToTDeqFj478VpHurOo1ROvF5bDypi0vUm/fQxm+T7ORyX8uK45ZEF+bCrFRscb6UwUVhGHh6jPNsvWvRxsPWGIIS841RYFbwe3NhyUr1K614Hvb6PF6m773imytCNUl6LjjHZEPSVZ7fD8FRkNz4u0jS+Fdr51rcPT9OyCcihVAIWgOaP5OkkzUvJZLMcJYgLA04uLjA54PKEFLqvm98m/XXloFh32MERf64PFxNpZCOzJu+1YThZ6OBAzKHp8rD4DIt4yTir0sc/St/PIVRGK16UhEQAgKum1IxbZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784709558; c=relaxed/relaxed;
	bh=hoas6u+YojDLjgRsKP4lA3l1/kP9Z+NRJGOe+o+6QJY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DFV6C9z265qzxh/TvaNpy7a9vqx5JsUiyzAQwJSBT6fwNeYtlMIlMyEwbbTQbX1PBDwEjag31ouAJFy6lP30z4j1g5nwe7qQhLZjUwYdUGDWlJwh/4mMDzu+McfZf3ivH9nWz+hol1DcQa8GBK6eFNeEY/QtwVt65YjPBIYSr8T1fM6Xl8m6bSi8RcQ0KqwVfu3aXTTmHSF0auHXz++oyeI7IO2NtkRI+yGYETF4KlvElZk4trVmAWzjwtejleLmcBREm18DFc66dPJfeG0grsYGh6D+dGCu8b5rNJ0+3G1c0L+y8FST52RrF7Jtpb6vAWmYN145Rx/CruMi502DnQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=YLVemuSy; dkim-atps=neutral; spf=pass (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=YLVemuSy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4njc3ZKHz2xLd
	for <linux-erofs@lists.ozlabs.org>; Wed, 22 Jul 2026 18:39:13 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hoas6u+YojDLjgRsKP4lA3l1/kP9Z+NRJGOe+o+6QJY=;
	b=YLVemuSyP40v8mKuGLhgbbwPishh+JAw9Vgw1jSNtcOFQHbILrW8DNW00Klgt6bSJxeM9Ya7I
	nqcIwe4xPvmx7r5OPvweQqZ+CK/VfFTT8US6m4O9GNIpsfVkMFoKgTGtB+clC0ABULesG+JNWKz
	dOYnrhD5JWUBjX7GgnJSoS0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h4nVb6mvzzKm5m;
	Wed, 22 Jul 2026 16:29:43 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B83040586;
	Wed, 22 Jul 2026 16:39:09 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 22 Jul
 2026 16:39:08 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>, <hsiangkao@linux.alibaba.com>
CC: <zhukeqian1@huawei.com>, <zhiguo.niu@unisoc.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH] erofs-utils: mkfs: preserve raw inline data type
Date: Wed, 22 Jul 2026 16:37:29 +0800
Message-ID: <20260722083729.1176080-1-zhaoyifan28@huawei.com>
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

Previously, raw inline tails were treated as compressed data, causing
incorrect head padding. Set idata_type according to raw mode.

Fixes: 277a42502a7a ("erofs-utils: mkfs: handle last compacted_2B pack in z_erofs_drop_inline_pcluster")
Closes: https://github.com/erofs/erofs-utils/issues/52
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 lib/compress.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index f7ad5a1..48a18b9 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -483,7 +483,8 @@ static int z_erofs_fill_inline_data(struct erofs_inode *inode, void *data,
 {
 	inode->z_advise |= Z_EROFS_ADVISE_INLINE_PCLUSTER;
 	inode->idata_size = len;
-	inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED_DEFAULT;
+	inode->idata_type = raw ? EROFS_IDATA_TYPE_RAW :
+				EROFS_IDATA_TYPE_COMPRESSED_DEFAULT;
 
 	inode->idata = malloc(inode->idata_size);
 	if (!inode->idata)
@@ -974,7 +975,8 @@ int z_erofs_convert_to_compacted_format(struct erofs_inode *inode,
 
 	/* generate compacted_2b */
 	if (compacted_2b) {
-		if (!compacted_4b_end && inode->idata_size)
+		if (!compacted_4b_end && inode->idata_size &&
+		    inode->idata_type != EROFS_IDATA_TYPE_RAW)
 			inode->idata_type = EROFS_IDATA_TYPE_COMPRESSED_END_OF_2B;
 		do {
 			in = parse_legacy_indexes(cv, 16, in);
-- 
2.47.3


