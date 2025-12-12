Return-Path: <linux-erofs+bounces-1491-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA42D44160
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Dec 2025 10:19:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dSQR91pLzz2xnl;
	Fri, 12 Dec 2025 21:19:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1765534741;
	cv=none; b=bAfZHsxLeqpoy6obp3aUP3a7DYE1hSX3k43RixcjcUTOXHFLdvS6lHMx4RHAjIHMj4NgL1VLz7hLh62P9NdtK699wjR0/IDEEZ3XoVu/j+Bh0AtPOyKb/wTdB+6TBhj2EJ/xxoedgfXmboIQCqAqlifV4GVcn2Kjsql14g6cl/Mw6GG9lqsqrPGN1HEyL9TUjE0ij0Uio4+BqJN3hx+HoADrII7Nuu5s4FXX0DLIksOWAY7egnksRCmxOnmEQ3WSgOpNYm4tewT3GLHv8OUjmQQ8DPI9Fi6ohO0KHdXNIpX4IbSnDKQlUpfJtw+YlAXMSKB2//UQ5aJSZVh0B5z5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1765534741; c=relaxed/relaxed;
	bh=OxZfVyvnuJQRSzVFF10h7ZUUfl+d5JU/DbQilu/tXyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LDK5xBelKtt2+v3AiNXTxOMFkFAf005bR5Ke5/kT7q9iYTkot0rWxs+iqqUpY7RS5B4Qtpz9LRAttkXNHggh5R+1CreBqWBikP4KpkJlsxaaBRZnU7sfhRdO/CBcQq0dk4przbhTtoRZw9VrAEJNlE9c3K2a9oMCok7GMPFIBVU811wSX0FFysGCSVaiuMi/Sv8aAt3pt0HdKoqCA6Na1/fvZ/PSGt8DIpX+5pAUIuQmJsX9NxA1inN5vTgacPBc+2vh4wzK4dSNa7GCMgbcF6GkdITEz5fBpVAucYDF/AkTCxL7DyqGFpr4P+YtHKs3MWVSBfDDWIUBsWrNgGtBiw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass (client-ip=113.46.200.227; helo=canpmsgout12.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.227; helo=canpmsgout12.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dSQR65yBMz2x9M
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Dec 2025 21:18:57 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OxZfVyvnuJQRSzVFF10h7ZUUfl+d5JU/DbQilu/tXyE=;
	b=p4FHMq5t2TqyqcWk728motLoCRdkL/OAh+7W8LRtFOAM6pTWGuxzYOq9Smj2+smJXnmLtY4h+
	XFSPjTAeKDU6DVbd+Qo0hDwxac3ygYzxEsZmNKieKk3jQ70Wq11VjjxFq7R1vxcVraW+omzktMK
	lfCEETeTSIdPIG5EU4rBuIU=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dSQNC65RlznTXC;
	Fri, 12 Dec 2025 18:16:27 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 26543140293;
	Fri, 12 Dec 2025 18:18:44 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 12 Dec
 2025 18:18:43 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>
CC: <hsiangkao@linux.alibaba.com>, <hudson@cyzhu.com>, <jingrui@huawei.com>,
	<wayne.ma@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH 2/2] erofs-utils: mkfs: correctly initialize `oci_cfg->layer_index`
Date: Fri, 12 Dec 2025 18:17:33 +0800
Message-ID: <20251212101733.590089-2-zhaoyifan28@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251212101733.590089-1-zhaoyifan28@huawei.com>
References: <20251212101733.590089-1-zhaoyifan28@huawei.com>
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

As a global variable, `oci_cfg->layer_index` is currently default
initialized to 0, which carries a specific semantic meaning.
Consequently, the current mkfs.erofs command only mistakenly constructs
layer 0 of the OCI image when invoked without explicitly specifying the
`layer=` option. Moreover, it becomes impossible to specify the image's
digest via the `blob=` option, erroneously resulting in EINVAL.

This patch addresses the issue by initializing `oci_cfg->layer_index`
to the invalid value -1.

Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 mkfs/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 5710948..22201d3 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -757,6 +757,8 @@ static int mkfs_parse_oci_options(struct ocierofs_config *oci_cfg, char *options
 	if (!options_str)
 		return 0;
 
+	oci_cfg->layer_index = -1;
+
 	opt = options_str;
 	q = strchr(opt, ',');
 	if (q)
-- 
2.43.0


