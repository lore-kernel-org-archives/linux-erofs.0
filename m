Return-Path: <linux-erofs+bounces-3400-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A65ACD4855
	for <linux-erofs@archiver.kernel.org>; Tue, 12 May 2026 07:17:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gF7G173lBz2ygG;
	Tue, 12 May 2026 17:17:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778570249;
	cv=none; b=D72rcIDF9DwSGgRnQws0u2qFRg6syzTkgzXnHXgV0pDdKhQqUUIlyWyxV7B/gQGcXcc29Y5cPuXQli0KhuaEAmbEGxTyxoga4GCBs3Y89DrTwPsNC4edHHucLy6721mzy4nmfOPNnuaIIHdTgBpcWAsEqIk5uHTCD0cgRr6tCFOqnSgJYcYEslY2ZdhARtzqtUa5dQ5BNU4pXYZjBhLODobD/vBHzMWC4mUsWlmaea4w56JVijisXAYPOd52ZcggJ+nk+SpPaStN4rqLaQF2vm5eP1mzW0pOZanaA1ppoueJdMczQMyiZEEFb1PsRJKGRFYzkx9Fv6WQnw1IV9hWgg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778570249; c=relaxed/relaxed;
	bh=g1P1k2B8h1UIClSVRVjr5hZ71ShdF+/b74WeN0B/SpQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQsMenuGOu+EOzCWoBSFO7QWr4PNDni73UbJtzZIRJq/y3CbDUvltVdgUbGI0WCf35l/CWKYoIW/yisMpQogKvFqBrcW6P8u1yL0m4ES2PQbC8FgCDCddqwL0vT6t35P8JBTCjvmi4+XiY/Hkl+wmE/HeIgDkNo5TFqPtvc9QXiiWSyEGXxXIjrsGplqnithRYSLX+zVwbd+w9h81n3sB5+3KPrlI5/zzUO7QygPPB64LRXJSxmR056PwBqJQghlW52RsXAYEcjBsw01LvEYN1gZ1ecCEp3Sy6H+3RCU4EUs0ospZJKGOU8icBQAX357a1zmw8gawtwhQSpLusHxvQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=i//ZLgJH; dkim-atps=neutral; spf=pass (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=i//ZLgJH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gF7Fz3DTHz2yZ8
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 May 2026 17:17:25 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=g1P1k2B8h1UIClSVRVjr5hZ71ShdF+/b74WeN0B/SpQ=;
	b=i//ZLgJHD3xi888iEiBos/8sGQY7XnFRWo+tn0WdaHpn4R2zHhSDp0xIUwG4sn6x+DW1dkldL
	T7ebb0KK8Matf0LX/mOcV3oP7P7J/mutNwM4s4bmNomPu426jXmcTe+AjUnHaznEFTWGJu+dLXf
	kYN5RxF4re4ST1qN7JDL2U8=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gF7560vf7z1K96D
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 May 2026 15:09:46 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 2AC8240561
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 May 2026 15:17:21 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 12 May
 2026 15:17:20 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>
CC: <jingrui@huawei.com>, <zhukeqian1@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH 2/3] erofs-utils: lib: reject packed inodes in metabox
Date: Tue, 12 May 2026 15:16:30 +0800
Message-ID: <20260512071631.969752-2-zhaoyifan28@huawei.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512071631.969752-1-zhaoyifan28@huawei.com>
References: <20260512071631.969752-1-zhaoyifan28@huawei.com>
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

If packed_nid carries the metabox NID bit, loading the packed
inode first redirects its inode metadata lookup through the
metabox inode.  Initializing that metabox inode can then read
metadata that refers back through the packed inode, forming a
recursive packed inode -> metabox inode -> packed inode path.

Reject such images while parsing the superblock, matching the
format rule that the special packed inode itself is not stored
inside the metabox.

Reproducible image (base64-encoded gzipped blob):
H4sIAAAAAAAAA2NgGAWjYBSMVPDo4dcHrY0KwsxANg8jAwMLFjVMSGzPx/7Lzj3zXb3jSFTh
5iN7v6CrbQSa8f8/gq8GoRpARHErYxYDEh8EVAm4jw2Il4AMFYDoB7IYmDGVNRhAzf8PBMh+
yEjNyclXKM8vyklRIILNRcA5o2AUjIJRMApGwSgYBaNgFAxpAGorv3VkYtBgQLSfQW3sF8wv
kJvZDSqIXkCDKpANlWxQZ2Bk0NPTS8RlPkgXqP0Oa5/DxNDNB7XvR8EoGAWjYBSMglEwCkbB
KBgFo2AUjIJRQBsAAEZO6n4AIAAA

Assisted-by: Codex:GPT-5.5
Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 lib/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/super.c b/lib/super.c
index 899d51a..655a6f4 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -131,6 +131,8 @@ int erofs_read_superblock(struct erofs_sb_info *sbi)
 		sbi->root_nid = le16_to_cpu(dsb->rb.rootnid_2b);
 	}
 	sbi->packed_nid = le64_to_cpu(dsb->packed_nid);
+	if (sbi->packed_nid & BIT_ULL(EROFS_DIRENT_NID_METABOX_BIT))
+		return -EFSCORRUPTED;
 	if (erofs_sb_has_metabox(sbi)) {
 		if (sbi->sb_size <= offsetof(struct erofs_super_block,
 					     metabox_nid))
-- 
2.47.3


