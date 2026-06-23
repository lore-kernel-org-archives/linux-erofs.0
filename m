Return-Path: <linux-erofs+bounces-3727-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4533ECDB46B
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jun 2026 02:55:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkqRq1H5sz2y71;
	Tue, 23 Jun 2026 12:55:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782183303;
	cv=none; b=ARVPqhr8sgS2dtYzroHGvv01J1ESDbKYqGku1ri2TBobmDr8kb8AeJcu1W7r3gntbHEZReh0w4ck/6MFrj7P53339blvcxJ45vjwuDb2k4jLEpQdSt4t9OX290QBHrMxbqFqJswTwyfhfCP8jNqu/rWrm92XYyU6sTRe09pIvth+HvgGvgDiGfrAy5Gzx7xXoMJ0yDfLmRi/enHeN3C87OYv1RUwU5icQtK4/2g5qLs7bFbiDtSvBJpkBgsJinSRszl/XADz41eE8x9rMawLctVmTcFBF3NwEM1JUO0PLVjZmXVahoYbZmQyK2VTgH7OvGbX8q3AngNXKkfAWNwSvg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782183303; c=relaxed/relaxed;
	bh=h11VX+Dvwcr4sf9L/QKi579kFboCPsHaEfWInKAG9Zk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXYfSNOWuNkMP1Pn4wB/07ZZl3zPzbVBOxKcwUi7zGOuKWYSE8keMSMIDxCEnZKyn7NJMeVFVplA7bVk0FSvufpXTSOAD6icL4ri4zfuNdwMlWToy+aqsL+f2LCKBnZlwMOuGU3NqZrFQp/xgyPPJj0A9VcbXw8TKIFcOjyoQxPNRFzpCDYDdK3S2Qq2361qM4FD+FF5l+BSrpLji1CkpV7S/ARp3EwglkGj6FrVIBDsjcY9+2vNzRd8A67e7HEhpnUr0whExXaMlAmkxkDJshWg9R282Iso1uJgHmKd3yT1yOHnDtEwnjnG4m6yYbly1uKmk1eWguUYQ9+jTMuFaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=3z/uO6ZF; dkim-atps=neutral; spf=pass (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=3z/uO6ZF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkqRm2ZmMz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 12:54:59 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=h11VX+Dvwcr4sf9L/QKi579kFboCPsHaEfWInKAG9Zk=;
	b=3z/uO6ZFHxza43bHV2Lw/JZgaCTIqpVPAw5O3jkn39827dbx5QAdNXW0ae3Q6PjK0Z35SCfOy
	zXAFcUpgxA01QB2ba5W2HrgecJ7AcAfzhzEb4Rbn4ThtmVHaZJgOTXF42MqliCHfDJq4KGPIb7W
	NeeByI4OkASi/lTFD6Y8ris=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gkqFB51Qqz1K977;
	Tue, 23 Jun 2026 10:45:50 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 087DA4048B;
	Tue, 23 Jun 2026 10:54:54 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 23 Jun
 2026 10:54:53 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>, <hsiangkao@linux.alibaba.com>
CC: <zhukeqian1@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH v2 2/2] erofs-utils: lib: honor rebuild whiteouts for recreated dirs
Date: Tue, 23 Jun 2026 10:53:34 +0800
Message-ID: <20260623025334.1049210-2-zhaoyifan28@huawei.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623025334.1049210-1-zhaoyifan28@huawei.com>
References: <20260623025334.1049210-1-zhaoyifan28@huawei.com>
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
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

When rebuilding from upper to lower, a whiteout below an already
recreated directory should keep that directory but stop older lower
entries from being merged into it.

Only treat the lower whiteout as an opaque marker when the upper entry
is a directory.  If the upper entry is not a directory, keep the normal
upper-exists behavior and ignore the lower entry.

Closes: https://github.com/erofs/erofs-utils/issues/49
Assisted-by: Codex:GPT-5.5
Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 lib/rebuild.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index 51dfe18..108a464 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -401,7 +401,13 @@ static int erofs_rebuild_dirent_iter(struct erofs_dir_context *ctx)
 			.nid = ctx->de_nid
 		};
 		ret = erofs_read_inode_from_disk(&src);
-		if (ret || !S_ISDIR(src.i_mode))
+		if (ret)
+			goto out;
+		if (erofs_inode_is_whiteout(&src)) {
+			d->inode->opaque = true;
+			goto out;
+		}
+		if (!S_ISDIR(src.i_mode))
 			goto out;
 		mergedir = d->inode;
 		inode = dir = &src;
-- 
2.47.3


